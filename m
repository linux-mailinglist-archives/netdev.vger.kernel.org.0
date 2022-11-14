Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12EC6278E5
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiKNJUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbiKNJUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:20:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA09E0CC
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FCFF60E9F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EBFC433C1;
        Mon, 14 Nov 2022 09:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668417635;
        bh=4bClsQ2V2y/lEZ4oVLI8XCwXCN/+WWMxTBRMeqCWYwM=;
        h=From:To:Cc:Subject:Date:From;
        b=ZPYYJDacKKMjlqJORAM4WevZPa2eZH3N1EVNEb2si1eb3DucEQdmQrKjR0Y0cwxLF
         JWjHY07YVR+i8xRQf7C5ACz4qBiRjHj+yzrswar5himMFHn5vP92E1kI6LR3UPfQYE
         L02lTFs+NRiQ5z3XRZcCVjt774Q9Qs9JytCKLu4vtcF2NS2sCJt0yFQ148iIbiwt4n
         AA32s05PutbRNzjU69uHv7EX7QBtrBssYiNMs0i3aynblRqqaJROYGhTytz4MZRJEe
         ptAp3afMdS6lvbfPbfNh3qpVC2ph1ZjreASjKgm2Q9DTpNSohzJFZamkzc94qYXE5b
         vwWqgswmhpEdA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, sd@queasysnail.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: mscc: macsec: do not copy encryption keys
Date:   Mon, 14 Nov 2022 10:20:33 +0100
Message-Id: <20221114092033.34405-1-atenart@kernel.org>
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

Instead of calling memzero_explicit on the key when freeing a flow,
let's simply not copy the key in the first place as it's only used when
a new flow is set up.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Following
https://lore.kernel.org/all/20221108153459.811293-1-atenart@kernel.org/T/
refactor the MSCC PHY driver not to make a copy the encryption keys.

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

