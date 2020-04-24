Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5341B6B1F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgDXCMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgDXCMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:12:01 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED292215A4;
        Fri, 24 Apr 2020 02:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694320;
        bh=fx+VVj3jtgcKvjqecXTges10Co820atjUmxQypl4RTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOGO6M6KrLlsmiaWrbjm0T590Igmj3Dk5WKaIXnxLS0KXuOSUZZO+62C9hMUR7CB+
         tID1HR91jWlT/Wb7d7CcF93v7K7pX00RxKp468iOlpLydHh2ZEssYaHWU82qQuQZrA
         G1PF/QZilN8yEPoyDFmHjmwj52ysdDBbiGGSAqC0=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 08/17] net: rename netif_receive_generic_xdp to do_generic_xdp_core
Date:   Thu, 23 Apr 2020 20:11:39 -0600
Message-Id: <20200424021148.83015-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

In skb generic path, we need a way to run XDP program on skb but
to have customized handling of XDP actions. netif_receive_generic_xdp
will be more helpful in such cases than do_xdp_generic.

This patch prepares netif_receive_generic_xdp() to be used as general
purpose function for running xdp programs on skbs by renaming it to
do_xdp_generic_core, moving skb_is_redirected and rxq settings as well
as XDP return code checks to the callers.

This allows this core function to be used from both Rx and Tx paths
with rxq and txq set based on context.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 net/core/dev.c | 52 ++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3c38f576ffcc..74610b5cf2da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4501,25 +4501,17 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+static u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			       struct bpf_prog *xdp_prog)
 {
-	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
-	u32 metalen, act = XDP_DROP;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
+	u32 metalen, act;
 	bool orig_bcast;
 	int hlen, off;
 	u32 mac_len;
 
-	/* Reinjected packets coming from act_mirred or similar should
-	 * not get XDP generic processing.
-	 */
-	if (skb_is_redirected(skb))
-		return XDP_PASS;
-
 	/* XDP packets must be linear and must have sufficient headroom
 	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
 	 * native XDP provides, thus we need to do it here as well.
@@ -4535,9 +4527,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		if (pskb_expand_head(skb,
 				     hroom > 0 ? ALIGN(hroom, NET_SKB_PAD) : 0,
 				     troom > 0 ? troom + 128 : 0, GFP_ATOMIC))
-			goto do_drop;
+			return XDP_DROP;
 		if (skb_linearize(skb))
-			goto do_drop;
+			return XDP_DROP;
 	}
 
 	/* The XDP program wants to see the packet starting at the MAC
@@ -4555,9 +4547,6 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
-	rxqueue = netif_get_rxqueue(skb);
-	xdp->rxq = &rxqueue->xdp_rxq;
-
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	/* check if bpf_xdp_adjust_head was used */
@@ -4600,16 +4589,6 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		if (metalen)
 			skb_metadata_set(skb, metalen);
 		break;
-	default:
-		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
-	case XDP_ABORTED:
-		trace_xdp_exception(skb->dev, xdp_prog, act);
-		/* fall through */
-	case XDP_DROP:
-	do_drop:
-		kfree_skb(skb);
-		break;
 	}
 
 	return act;
@@ -4644,12 +4623,22 @@ static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 
 int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 {
+	/* Reinjected packets coming from act_mirred or similar should
+	 * not get XDP generic processing.
+	 */
+	if (skb_is_redirected(skb))
+		return XDP_PASS;
+
 	if (xdp_prog) {
+		struct netdev_rx_queue *rxqueue;
 		struct xdp_buff xdp;
 		u32 act;
 		int err;
 
-		act = netif_receive_generic_xdp(skb, &xdp, xdp_prog);
+		rxqueue = netif_get_rxqueue(skb);
+		xdp.rxq = &rxqueue->xdp_rxq;
+
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
 		if (act != XDP_PASS) {
 			switch (act) {
 			case XDP_REDIRECT:
@@ -4661,6 +4650,15 @@ int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 			case XDP_TX:
 				generic_xdp_tx(skb, xdp_prog);
 				break;
+			default:
+				bpf_warn_invalid_xdp_action(act);
+				/* fall through */
+			case XDP_ABORTED:
+				trace_xdp_exception(skb->dev, xdp_prog, act);
+				/* fall through */
+			case XDP_DROP:
+				kfree_skb(skb);
+				break;
 			}
 			return XDP_DROP;
 		}
-- 
2.21.1 (Apple Git-122.3)

