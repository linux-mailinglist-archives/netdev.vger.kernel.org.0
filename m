Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D8A197F6C
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgC3PTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:19:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:55261 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgC3PTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:19:37 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02UFJFT6027024;
        Mon, 30 Mar 2020 08:19:31 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 2/2] Crypto: chelsio - Fixes a deadlock between rtnl_lock and uld_mutex
Date:   Mon, 30 Mar 2020 20:48:53 +0530
Message-Id: <20200330151853.32550-3-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200330151853.32550-1-ayush.sawal@chelsio.com>
References: <20200330151853.32550-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The locks are taken in this order during driver registration
(uld_mutex), at: cxgb4_register_uld.part.14+0x49/0xd60 [cxgb4]
(rtnl_mutex), at: rtnetlink_rcv_msg+0x2db/0x400
(uld_mutex), at: cxgb_up+0x3a/0x7b0 [cxgb4]
(rtnl_mutex), at: chcr_add_xfrmops+0x83/0xa0 [chcr](stucked here)

To avoid this now the netdev features are updated after the
cxgb4_register_uld function is completed.

Fixes: 6dad4e8ab3ec6 ("chcr: Add support for Inline IPSec").

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_core.c  | 32 +++++++++++++++++++++++++----
 drivers/crypto/chelsio/chcr_ipsec.c |  2 --
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index f1499534a0fe..dfb53e746e51 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -33,6 +33,10 @@ static int cpl_fw6_pld_handler(struct adapter *adap, unsigned char *input);
 static void *chcr_uld_add(const struct cxgb4_lld_info *lld);
 static int chcr_uld_state_change(void *handle, enum cxgb4_state state);
 
+#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+static void update_netdev_features(void);
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 	[CPL_FW6_PLD] = cpl_fw6_pld_handler,
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
@@ -202,10 +206,6 @@ static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
 	}
 	u_ctx->lldi = *lld;
 	chcr_dev_init(u_ctx);
-#ifdef CONFIG_CHELSIO_IPSEC_INLINE
-	if (lld->crypto & ULP_CRYPTO_IPSEC_INLINE)
-		chcr_add_xfrmops(lld);
-#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
 
 #ifdef CONFIG_CHELSIO_TLS_DEVICE
 	if (lld->ulp_crypto & ULP_CRYPTO_KTLS_INLINE)
@@ -297,6 +297,24 @@ static int chcr_uld_state_change(void *handle, enum cxgb4_state state)
 	return ret;
 }
 
+#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+static void update_netdev_features(void)
+{
+	struct uld_ctx *u_ctx, *tmp;
+
+	mutex_lock(&drv_data.drv_mutex);
+	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
+		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
+			chcr_add_xfrmops(&u_ctx->lldi);
+	}
+	list_for_each_entry_safe(u_ctx, tmp, &drv_data.act_dev, entry) {
+		if (u_ctx->lldi.crypto & ULP_CRYPTO_IPSEC_INLINE)
+			chcr_add_xfrmops(&u_ctx->lldi);
+	}
+	mutex_unlock(&drv_data.drv_mutex);
+}
+#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 static int __init chcr_crypto_init(void)
 {
 	INIT_LIST_HEAD(&drv_data.act_dev);
@@ -306,6 +324,12 @@ static int __init chcr_crypto_init(void)
 	drv_data.last_dev = NULL;
 	cxgb4_register_uld(CXGB4_ULD_CRYPTO, &chcr_uld_info);
 
+	#ifdef CONFIG_CHELSIO_IPSEC_INLINE
+	rtnl_lock();
+	update_netdev_features();
+	rtnl_unlock();
+	#endif /* CONFIG_CHELSIO_IPSEC_INLINE */
+
 	return 0;
 }
 
diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 9da0f93a330b..9fd3b9d1ec2f 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -99,9 +99,7 @@ void chcr_add_xfrmops(const struct cxgb4_lld_info *lld)
 		netdev->xfrmdev_ops = &chcr_xfrmdev_ops;
 		netdev->hw_enc_features |= NETIF_F_HW_ESP;
 		netdev->features |= NETIF_F_HW_ESP;
-		rtnl_lock();
 		netdev_change_features(netdev);
-		rtnl_unlock();
 	}
 }
 
-- 
2.26.0.rc1.11.g30e9940

