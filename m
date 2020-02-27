Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C33170EF4
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 04:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgB0DU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 22:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728339AbgB0DU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:26 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6CA124685;
        Thu, 27 Feb 2020 03:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582773625;
        bh=08PJP2RcpxbTrvOK9ILwnItY4KnUJ9YK9Y6oPJrCYuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfthH+cOghYBGuSZwEtlM31zy6xBuCA46itRV8xrdVDPWysla1G5mHJ9Qb84v2FOw
         VWifKLr5r3DGNVJZ6S8krovkrLem8mnmdoyKqs6gg1OALC5NqFJEcVRHoFHrOemai7
         apsLhiqIQfryzORW1ubHUUwGsWhyCpClBGsg1pvw=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC v4 bpf-next 05/11] net: core: rename netif_receive_generic_xdp to do_generic_xdp_core
Date:   Wed, 26 Feb 2020 20:20:07 -0700
Message-Id: <20200227032013.12385-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200227032013.12385-1-dsahern@kernel.org>
References: <20200227032013.12385-1-dsahern@kernel.org>
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
purpose function by renaming it and exporting as a general purpose
function. It will just run XDP program on skb but will not handle XDP
actions.

Move setting xdp->rxq to the caller. This allows this core function
to be used from both Rx and Tx paths with rxq and txq set as needed.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 16 ++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d0dd0706ece4..bc58c489e959 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3701,6 +3701,8 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 15c511c5c7d5..bfa7a64c4e68 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4498,11 +4498,9 @@ static struct netdev_rx_queue *netif_get_rxqueue(struct sk_buff *skb)
 	return rxqueue;
 }
 
-static u32 netif_receive_generic_xdp(struct sk_buff *skb,
-				     struct xdp_buff *xdp,
-				     struct bpf_prog *xdp_prog)
+u32 do_xdp_generic_core(struct sk_buff *skb, struct xdp_buff *xdp,
+			struct bpf_prog *xdp_prog)
 {
-	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
 	u32 metalen, act = XDP_DROP;
 	__be16 orig_eth_type;
@@ -4552,9 +4550,6 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
-	rxqueue = netif_get_rxqueue(skb);
-	xdp->rxq = &rxqueue->xdp_rxq;
-
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
 	/* check if bpf_xdp_adjust_head was used */
@@ -4611,6 +4606,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	return act;
 }
+EXPORT_SYMBOL_GPL(do_xdp_generic_core);
 
 /* When doing generic XDP we have to bypass the qdisc layer and the
  * network taps in order to match in-driver-XDP behavior.
@@ -4643,11 +4639,15 @@ static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
 int do_xdp_generic(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 {
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
-- 
2.21.1 (Apple Git-122.3)

