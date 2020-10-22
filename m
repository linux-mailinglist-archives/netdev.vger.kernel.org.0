Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2B9295C70
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896353AbgJVKKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:10:31 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:9606 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896302AbgJVKKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:10:30 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09MAAK5c013211;
        Thu, 22 Oct 2020 03:10:24 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net 1/7] cxgb4/ch_ktls: decrypted bit is not enough
Date:   Thu, 22 Oct 2020 15:40:13 +0530
Message-Id: <20201022101019.7363-2-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201022101019.7363-1-rohitm@chelsio.com>
References: <20201022101019.7363-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb has retransmit data starting before start marker, e.g. ccs,
decrypted bit won't be set for that, and if it has some data to
encrypt, then it must be given to crypto ULD. So in place of
decrypted, check if socket is tls offloaded. Also, unless skb has
some data to encrypt, no need to give it for tls offload handling.

Fixes: 5a4b9fe7fece ("cxgb4/chcr: complete record tx handling")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c            | 3 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h             | 7 +++++++
 drivers/net/ethernet/chelsio/cxgb4/sge.c                   | 3 ++-
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 4 ----
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a952fe198eb9..c555a9f962f8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1176,6 +1176,9 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
 		txq = netdev_pick_tx(dev, skb, sb_dev);
 		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
 		    skb->encapsulation ||
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+		    cxgb4_is_ktls_skb(skb) ||
+#endif
 		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
 			txq = txq % pi->nqsets;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index b169776ab484..65a8d4d4c6e5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -493,6 +493,13 @@ struct cxgb4_uld_info {
 #endif
 };
 
+#if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
+static inline bool cxgb4_is_ktls_skb(struct sk_buff *skb)
+{
+	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
+}
+#endif
+
 void cxgb4_uld_enable(struct adapter *adap);
 void cxgb4_register_uld(enum cxgb4_uld type, const struct cxgb4_uld_info *p);
 int cxgb4_unregister_uld(enum cxgb4_uld type);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index a9e9c7ae565d..01bd9c0dfe4e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1422,7 +1422,8 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif /* CHELSIO_IPSEC_INLINE */
 
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
-	if (skb->decrypted)
+	if (cxgb4_is_ktls_skb(skb) &&
+	    (skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb))))
 		return adap->uld[CXGB4_ULD_KTLS].tx_handler(skb, dev);
 #endif /* CHELSIO_TLS_DEVICE */
 
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 5195f692f14d..43c723c72c61 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1878,10 +1878,6 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : skb->data_len;
 
-	/* check if we haven't set it for ktls offload */
-	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
-		goto out;
-
 	tls_ctx = tls_get_ctx(skb->sk);
 	if (unlikely(tls_ctx->netdev != dev))
 		goto out;
-- 
2.18.1

