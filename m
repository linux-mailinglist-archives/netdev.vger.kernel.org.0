Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7894629DE1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKOPo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiKOPo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:44:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197E6114C
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:44:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D55DB8199A
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 15:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA21CC433C1;
        Tue, 15 Nov 2022 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668527094;
        bh=bU5lhSWMGNbUTV03hyRVn3s1bXhCWa/IY8lnSTVMJYk=;
        h=From:To:Cc:Subject:Date:From;
        b=GcWiN1ZDgpNT/HUdMxtK0E+12lkQNcuUDFBifb6HaHOz9zF50OP1SoGgh1Uy0MWHm
         ZegsNI2/13dGlom8wZg9g6T1Gi0bRZ3BMViNs1QdeRNyQIT+B81DqC8lfOVaqY6EWg
         cUcclbUb11mZ4YzoguX3+uH3cfi+sqMbScW/f8SxKUx1r+SELegzE+71kio3uGAQbq
         NNfRNEFyTQdvLc8lOt5QI7HNmOcpSbqGFBGO9U6ILnJburXlcNSV4R2mn1FeSLmEuO
         BXrE04m6R0t2zQEsVktfqQXqvd/BOElMOkpelUNDmqTgPvpT99D8r7DHgF9JVDf8eQ
         9eKGMiJxLm1Eg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, sd@queasysnail.net,
        irusskikh@marvell.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2] net: phy: mscc: macsec: do not copy encryption keys
Date:   Tue, 15 Nov 2022 16:44:51 +0100
Message-Id: <20221115154451.266160-1-atenart@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following 1b16b3fdf675 ("net: phy: mscc: macsec: clear encryption keys when freeing a flow"),
go one step further and instead of calling memzero_explicit on the key
when freeing a flow, simply not copy the key in the first place as it's
only used when a new flow is set up.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Following
https://lore.kernel.org/all/20221108153459.811293-1-atenart@kernel.org/T/
refactor the MSCC PHY driver not to make a copy the encryption keys.

Since v1:
- Reworked the commit message to include a reference to the previous
  fix.

 drivers/net/phy/mscc/mscc_macsec.c | 57 ++++++++++++++++--------------
 drivers/net/phy/mscc/mscc_macsec.h |  2 --
 2 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index f81b077618f4..018253a573b8 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -501,8 +501,7 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
 }
 
 /* Derive the AES key to get a key for the hash autentication */
-static int vsc8584_macsec_derive_key(const u8 key[MACSEC_MAX_KEY_LEN],
-				     u16 key_len, u8 hkey[16])
+static int vsc8584_macsec_derive_key(const u8 *key, u16 key_len, u8 hkey[16])
 {
 	const u8 input[AES_BLOCK_SIZE] = {0};
 	struct crypto_aes_ctx ctx;
@@ -518,7 +517,8 @@ static int vsc8584_macsec_derive_key(const u8 key[MACSEC_MAX_KEY_LEN],
 }
 
 static int vsc8584_macsec_transformation(struct phy_device *phydev,
-					 struct macsec_flow *flow)
+					 struct macsec_flow *flow,
+					 const u8 *key)
 {
 	struct vsc8531_private *priv = phydev->priv;
 	enum macsec_bank bank = flow->bank;
@@ -527,7 +527,7 @@ static int vsc8584_macsec_transformation(struct phy_device *phydev,
 	u8 hkey[16];
 	u64 sci;
 
-	ret = vsc8584_macsec_derive_key(flow->key, priv->secy->key_len, hkey);
+	ret = vsc8584_macsec_derive_key(key, priv->secy->key_len, hkey);
 	if (ret)
 		return ret;
 
@@ -563,7 +563,7 @@ static int vsc8584_macsec_transformation(struct phy_device *phydev,
 	for (i = 0; i < priv->secy->key_len / sizeof(u32); i++)
 		vsc8584_macsec_phy_write(phydev, bank,
 					 MSCC_MS_XFORM_REC(index, rec++),
-					 ((u32 *)flow->key)[i]);
+					 ((u32 *)key)[i]);
 
 	/* Set the authentication key */
 	for (i = 0; i < 4; i++)
@@ -632,28 +632,14 @@ static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
 
 	list_del(&flow->list);
 	clear_bit(flow->index, bitmap);
-	memzero_explicit(flow->key, sizeof(flow->key));
 	kfree(flow);
 }
 
-static int vsc8584_macsec_add_flow(struct phy_device *phydev,
-				   struct macsec_flow *flow, bool update)
+static void vsc8584_macsec_add_flow(struct phy_device *phydev,
+				    struct macsec_flow *flow)
 {
-	int ret;
-
 	flow->port = MSCC_MS_PORT_CONTROLLED;
 	vsc8584_macsec_flow(phydev, flow);
-
-	if (update)
-		return 0;
-
-	ret = vsc8584_macsec_transformation(phydev, flow);
-	if (ret) {
-		vsc8584_macsec_free_flow(phydev->priv, flow);
-		return ret;
-	}
-
-	return 0;
 }
 
 static int vsc8584_macsec_default_flows(struct phy_device *phydev)
@@ -706,6 +692,7 @@ static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
 {
 	struct phy_device *phydev = ctx->phydev;
 	struct vsc8531_private *priv = phydev->priv;
+	int ret;
 
 	flow->assoc_num = ctx->sa.assoc_num;
 	flow->rx_sa = ctx->sa.rx_sa;
@@ -717,19 +704,39 @@ static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
 	if (priv->secy->validate_frames != MACSEC_VALIDATE_DISABLED)
 		flow->match.untagged = 1;
 
-	return vsc8584_macsec_add_flow(phydev, flow, update);
+	vsc8584_macsec_add_flow(phydev, flow);
+
+	if (update)
+		return 0;
+
+	ret = vsc8584_macsec_transformation(phydev, flow, ctx->sa.key);
+	if (ret)
+		vsc8584_macsec_free_flow(phydev->priv, flow);
+
+	return ret;
 }
 
 static int __vsc8584_macsec_add_txsa(struct macsec_context *ctx,
 				     struct macsec_flow *flow, bool update)
 {
+	int ret;
+
 	flow->assoc_num = ctx->sa.assoc_num;
 	flow->tx_sa = ctx->sa.tx_sa;
 
 	/* Always match untagged packets on egress */
 	flow->match.untagged = 1;
 
-	return vsc8584_macsec_add_flow(ctx->phydev, flow, update);
+	vsc8584_macsec_add_flow(ctx->phydev, flow);
+
+	if (update)
+		return 0;
+
+	ret = vsc8584_macsec_transformation(ctx->phydev, flow, ctx->sa.key);
+	if (ret)
+		vsc8584_macsec_free_flow(ctx->phydev->priv, flow);
+
+	return ret;
 }
 
 static int vsc8584_macsec_dev_open(struct macsec_context *ctx)
@@ -829,8 +836,6 @@ static int vsc8584_macsec_add_rxsa(struct macsec_context *ctx)
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
-
 	ret = __vsc8584_macsec_add_rxsa(ctx, flow, false);
 	if (ret)
 		return ret;
@@ -882,8 +887,6 @@ static int vsc8584_macsec_add_txsa(struct macsec_context *ctx)
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
 
-	memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
-
 	ret = __vsc8584_macsec_add_txsa(ctx, flow, false);
 	if (ret)
 		return ret;
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index 453304bae778..21ce3b892f7f 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -81,8 +81,6 @@ struct macsec_flow {
 	/* Highest takes precedence [0..15] */
 	u8 priority;
 
-	u8 key[MACSEC_MAX_KEY_LEN];
-
 	union {
 		struct macsec_rx_sa *rx_sa;
 		struct macsec_tx_sa *tx_sa;
-- 
2.38.1

