Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE41B167F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgDTUBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbgDTUBJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:01:09 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6372223D;
        Mon, 20 Apr 2020 20:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587412868;
        bh=GkiNvjY7wJSvOouNeJtYcLeLpSNpgaVbB19K1+8NTsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkLQ8smvyiFl6BxqxqGqo57njbv1MaolDc/0Oknw1gnDvradlmc5YPmO7X3Am7gbg
         cdojh92UXIi8Wpxoh/mqBRx1zReSCpIvJcvxjeqNUL8+V+cnUFCBXlvgk88ZWKjcKw
         95TR/4y214GpmhqJA9icj5AFLycLxZhJMx/qUggY=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 10/16] net: Support xdp in the Tx path for packets as an skb
Date:   Mon, 20 Apr 2020 14:00:49 -0600
Message-Id: <20200420200055.49033-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200420200055.49033-1-dsahern@kernel.org>
References: <20200420200055.49033-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add support to run Tx path program on packets about to hit the
ndo_start_xmit function for a device. Only XDP_DROP and XDP_PASS
are supported now. Conceptually, XDP_REDIRECT for this path can
work the same as it does for the Rx path, but that support is left
for a follow on series.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h | 11 +++++++++
 net/core/dev.c            | 52 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0c89996a6bec..39e1b42c042f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3714,6 +3714,7 @@ static inline void dev_consume_skb_any(struct sk_buff *skb)
 
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog);
 int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb);
+u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb);
 int netif_rx(struct sk_buff *skb);
 int netif_rx_ni(struct sk_buff *skb);
 int netif_receive_skb(struct sk_buff *skb);
@@ -4534,6 +4535,16 @@ static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
 					      struct sk_buff *skb, struct net_device *dev,
 					      bool more)
 {
+	if (static_branch_unlikely(&xdp_egress_needed_key)) {
+		u32 act;
+
+		rcu_read_lock();
+		act = do_xdp_egress_skb(dev, skb);
+		rcu_read_unlock();
+		if (act == XDP_DROP)
+			return NET_XMIT_DROP;
+	}
+
 	__this_cpu_write(softnet_data.xmit.more, more);
 	return ops->ndo_start_xmit(skb, dev);
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 6718048c3448..d47e88beeeca 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4620,7 +4620,6 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 }
 
 static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
-DEFINE_STATIC_KEY_FALSE(xdp_egress_needed_key);
 
 int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 {
@@ -4671,6 +4670,57 @@ int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(do_xdp_generic_rx);
 
+DEFINE_STATIC_KEY_FALSE(xdp_egress_needed_key);
+EXPORT_SYMBOL_GPL(xdp_egress_needed_key);
+
+static u32 handle_xdp_egress_act(u32 act, struct net_device *dev,
+				 struct bpf_prog *xdp_prog)
+{
+	switch (act) {
+	case XDP_DROP:
+		/* fall through */
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		/* fall through */
+	case XDP_REDIRECT:
+		/* fall through */
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, xdp_prog, act);
+		act = XDP_DROP;
+		break;
+	}
+
+	return act;
+}
+
+u32 do_xdp_egress_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	struct bpf_prog *xdp_prog;
+	u32 act = XDP_PASS;
+
+	xdp_prog = rcu_dereference(dev->xdp_egress_prog);
+	if (xdp_prog) {
+		struct xdp_txq_info txq = { .dev = dev };
+		struct xdp_buff xdp;
+
+		xdp.txq = &txq;
+		act = do_xdp_generic_core(skb, &xdp, xdp_prog);
+		act = handle_xdp_egress_act(act, dev, xdp_prog);
+		if (act == XDP_DROP) {
+			atomic_long_inc(&dev->tx_dropped);
+			skb_tx_error(skb);
+			kfree_skb(skb);
+		}
+	}
+
+	return act;
+}
+EXPORT_SYMBOL_GPL(do_xdp_egress_skb);
+
 static int netif_rx_internal(struct sk_buff *skb)
 {
 	int ret;
-- 
2.21.1 (Apple Git-122.3)

