Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCC91928D3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCYMr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:47:27 -0400
Received: from correo.us.es ([193.147.175.20]:58764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgCYMr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 08:47:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1324B1176A8
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:46:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 049D3DA390
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:46:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDA6ADA3C4; Wed, 25 Mar 2020 13:46:47 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D56F2DA72F;
        Wed, 25 Mar 2020 13:46:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Mar 2020 13:46:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AC53F42EF42A;
        Wed, 25 Mar 2020 13:46:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH net] net: Fix CONFIG_NET_CLS_ACT=n and CONFIG_NFT_FWD_NETDEV={y,m} build
Date:   Wed, 25 Mar 2020 13:47:18 +0100
Message-Id: <20200325124718.77151-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/netfilter/nft_fwd_netdev.c: In function ‘nft_fwd_netdev_eval’:
    net/netfilter/nft_fwd_netdev.c:32:10: error: ‘struct sk_buff’ has no member named ‘tc_redirected’
      pkt->skb->tc_redirected = 1;
              ^~
    net/netfilter/nft_fwd_netdev.c:33:10: error: ‘struct sk_buff’ has no member named ‘tc_from_ingress’
      pkt->skb->tc_from_ingress = 1;
              ^~

To avoid a direct dependency with tc actions from netfilter, wrap the
redirect bits around CONFIG_NET_REDIRECT and move helpers to
include/linux/skbuff.h. Turn on this toggle from the ifb driver, the
only existing client of these bits in the tree.

This patch adds skb_set_redirected() that sets on the redirected bit
on the skbuff, it specifies if the packet was redirect from ingress
and resets the timestamp (timestamp reset was originally missing in the
netfilter bugfix).

Fixes: bcfabee1afd99484 ("netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress")
Reported-by: noreply@ellerman.id.au
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/Kconfig              |  1 +
 drivers/net/ifb.c                |  6 +++---
 drivers/net/wireguard/queueing.h |  2 +-
 include/linux/skbuff.h           | 36 ++++++++++++++++++++++++++++++++----
 include/net/sch_generic.h        | 16 ----------------
 net/Kconfig                      |  3 +++
 net/core/dev.c                   |  4 ++--
 net/core/pktgen.c                |  2 +-
 net/netfilter/nft_fwd_netdev.c   |  5 ++---
 net/sched/act_mirred.c           |  6 ++----
 10 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 25a8f9387d5a..db8884ad6d40 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -149,6 +149,7 @@ config NET_FC
 config IFB
 	tristate "Intermediate Functional Block support"
 	depends on NET_CLS_ACT
+	select NET_REDIRECT
 	---help---
 	  This is an intermediate driver that allows sharing of
 	  resources.
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 242b9b0943f8..7fe306e76281 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -75,7 +75,7 @@ static void ifb_ri_tasklet(unsigned long _txp)
 	}
 
 	while ((skb = __skb_dequeue(&txp->tq)) != NULL) {
-		skb->tc_redirected = 0;
+		skb->redirected = 0;
 		skb->tc_skip_classify = 1;
 
 		u64_stats_update_begin(&txp->tsync);
@@ -96,7 +96,7 @@ static void ifb_ri_tasklet(unsigned long _txp)
 		rcu_read_unlock();
 		skb->skb_iif = txp->dev->ifindex;
 
-		if (!skb->tc_from_ingress) {
+		if (!skb->from_ingress) {
 			dev_queue_xmit(skb);
 		} else {
 			skb_pull_rcsum(skb, skb->mac_len);
@@ -243,7 +243,7 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev)
 	txp->rx_bytes += skb->len;
 	u64_stats_update_end(&txp->rsync);
 
-	if (!skb->tc_redirected || !skb->skb_iif) {
+	if (!skb->redirected || !skb->skb_iif) {
 		dev_kfree_skb(skb);
 		dev->stats.rx_dropped++;
 		return NETDEV_TX_OK;
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index cf1e0e2376d8..3432232afe06 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -100,8 +100,8 @@ static inline void wg_reset_packet(struct sk_buff *skb)
 	skb->dev = NULL;
 #ifdef CONFIG_NET_SCHED
 	skb->tc_index = 0;
-	skb_reset_tc(skb);
 #endif
+	skb_reset_redirect(skb);
 	skb->hdr_len = skb_headroom(skb);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5b50278c4bc8..e59620234415 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -645,8 +645,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@offload_l3_fwd_mark: Packet was L3-forwarded in hardware
  *	@tc_skip_classify: do not classify packet. set by IFB device
  *	@tc_at_ingress: used within tc_classify to distinguish in/egress
- *	@tc_redirected: packet was redirected by a tc action
- *	@tc_from_ingress: if tc_redirected, tc_at_ingress at time of redirect
+ *	@redirected: packet was redirected by packet classifier
+ *	@from_ingress: packet was redirected from the ingress path
  *	@peeked: this packet has been seen already, so stats have been
  *		done for it, don't do them again
  *	@nf_trace: netfilter packet trace flag
@@ -848,8 +848,10 @@ struct sk_buff {
 #ifdef CONFIG_NET_CLS_ACT
 	__u8			tc_skip_classify:1;
 	__u8			tc_at_ingress:1;
-	__u8			tc_redirected:1;
-	__u8			tc_from_ingress:1;
+#endif
+#ifdef CONFIG_NET_REDIRECT
+	__u8			redirected:1;
+	__u8			from_ingress:1;
 #endif
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
@@ -4579,5 +4581,31 @@ static inline __wsum lco_csum(struct sk_buff *skb)
 	return csum_partial(l4_hdr, csum_start - l4_hdr, partial);
 }
 
+static inline bool skb_is_redirected(const struct sk_buff *skb)
+{
+#ifdef CONFIG_NET_REDIRECT
+	return skb->redirected;
+#else
+	return false;
+#endif
+}
+
+static inline void skb_set_redirected(struct sk_buff *skb, bool from_ingress)
+{
+#ifdef CONFIG_NET_REDIRECT
+	skb->redirected = 1;
+	skb->from_ingress = from_ingress;
+	if (skb->from_ingress)
+		skb->tstamp = 0;
+#endif
+}
+
+static inline void skb_reset_redirect(struct sk_buff *skb)
+{
+#ifdef CONFIG_NET_REDIRECT
+	skb->redirected = 0;
+#endif
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 151208704ed2..c30f914867e6 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -675,22 +675,6 @@ void __qdisc_calculate_pkt_len(struct sk_buff *skb,
 			       const struct qdisc_size_table *stab);
 int skb_do_redirect(struct sk_buff *);
 
-static inline void skb_reset_tc(struct sk_buff *skb)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	skb->tc_redirected = 0;
-#endif
-}
-
-static inline bool skb_is_tc_redirected(const struct sk_buff *skb)
-{
-#ifdef CONFIG_NET_CLS_ACT
-	return skb->tc_redirected;
-#else
-	return false;
-#endif
-}
-
 static inline bool skb_at_tc_ingress(const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_CLS_ACT
diff --git a/net/Kconfig b/net/Kconfig
index 2eeb0e55f7c9..df8d8c9bd021 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -52,6 +52,9 @@ config NET_INGRESS
 config NET_EGRESS
 	bool
 
+config NET_REDIRECT
+	bool
+
 config SKB_EXTENSIONS
 	bool
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 402a986659cf..500bba8874b0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4516,7 +4516,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
 	 */
-	if (skb_is_tc_redirected(skb))
+	if (skb_is_redirected(skb))
 		return XDP_PASS;
 
 	/* XDP packets must be linear and must have sufficient headroom
@@ -5063,7 +5063,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			goto out;
 	}
 #endif
-	skb_reset_tc(skb);
+	skb_reset_redirect(skb);
 skip_classify:
 	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
 		goto drop;
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index acc849df60b5..d0641bba6b81 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3362,7 +3362,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 			/* skb was 'freed' by stack, so clean few
 			 * bits and reuse it
 			 */
-			skb_reset_tc(skb);
+			skb_reset_redirect(skb);
 		} while (--burst > 0);
 		goto out; /* Skips xmit_mode M_START_XMIT */
 	} else if (pkt_dev->xmit_mode == M_QUEUE_XMIT) {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 74f050ba6bad..3087e23297db 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -28,9 +28,8 @@ static void nft_fwd_netdev_eval(const struct nft_expr *expr,
 	struct nft_fwd_netdev *priv = nft_expr_priv(expr);
 	int oif = regs->data[priv->sreg_dev];
 
-	/* These are used by ifb only. */
-	pkt->skb->tc_redirected = 1;
-	pkt->skb->tc_from_ingress = 1;
+	/* This is used by ifb only. */
+	skb_set_redirected(pkt->skb, true);
 
 	nf_fwd_netdev_egress(pkt, oif);
 	regs->verdict.code = NF_STOLEN;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 1ad300e6dbc0..83dd82fc9f40 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -284,10 +284,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 	/* mirror is always swallowed */
 	if (is_redirect) {
-		skb2->tc_redirected = 1;
-		skb2->tc_from_ingress = skb2->tc_at_ingress;
-		if (skb2->tc_from_ingress)
-			skb2->tstamp = 0;
+		skb_set_redirected(skb2, skb2->tc_at_ingress);
+
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-- 
2.11.0

