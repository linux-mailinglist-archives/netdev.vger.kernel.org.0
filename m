Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1158863FD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403859AbfHHOKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:10:23 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:36187 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403794AbfHHOKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:21 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id E261BFF80B;
        Thu,  8 Aug 2019 14:10:15 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 9/9] net: phy: mscc: macsec support
Date:   Thu,  8 Aug 2019 16:06:00 +0200
Message-Id: <20190808140600.21477-10-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808140600.21477-1-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds MACsec support to the Microsemi Ocelot PHY, to configure
flows and transformations so that matched packets can be processed by
the MACsec engine, either at egress, or at ingress. This addition allows
a user to create an hardware accelerated virtual MACsec interface on a
port using a Microsemi Ocelot PHY.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/Kconfig       |   2 +
 drivers/net/phy/mscc.c        | 621 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/mscc_macsec.h |   2 +
 3 files changed, 625 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 48ca213c0ada..296b29b20565 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -421,6 +421,8 @@ config MICROCHIP_T1_PHY
 
 config MICROSEMI_PHY
 	tristate "Microsemi PHYs"
+	select CRYPTO_AES
+	select CRYPTO_ECB
 	---help---
 	  Currently supports VSC8514, VSC8530, VSC8531, VSC8540 and VSC8541 PHYs
 
diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 603a3dbd83e9..19ae897b5268 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -18,6 +18,9 @@
 #include <linux/netdevice.h>
 #include <dt-bindings/net/mscc-phy-vsc8531.h>
 
+#include <linux/scatterlist.h>
+#include <crypto/skcipher.h>
+
 #include "mscc_macsec.h"
 #include "mscc_mac.h"
 #include "mscc_fc_buffer.h"
@@ -428,6 +431,31 @@ static const struct vsc85xx_hw_stat vsc8584_hw_stats[] = {
 	},
 };
 
+#if IS_ENABLED(CONFIG_MACSEC)
+struct macsec_flow {
+	struct list_head list;
+	enum macsec_bank bank;
+	u32 index;
+	unsigned char assoc_num;
+
+	u8 key[MACSEC_KEYID_LEN];
+
+	union {
+		const struct macsec_rx_sa *rx_sa;
+		const struct macsec_tx_sa *tx_sa;
+	};
+
+	/* Matching */
+	bool tagged;
+	bool untagged;
+	bool control;
+	/* Action */
+	bool bypass;
+	bool drop;
+
+};
+#endif
+
 struct vsc8531_private {
 	int rate_magic;
 	u16 supp_led_modes;
@@ -441,6 +469,19 @@ struct vsc8531_private {
 	 * package.
 	 */
 	unsigned int base_addr;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* MACsec fields:
+	 * - One SecY per device (enforced at the s/w implementation level)
+	 * - macsec_flows: list of h/w flows
+	 * - ingr_flows: bitmap of ingress flows
+	 * - egr_flows: bitmap of egress flows
+	 */
+	const struct macsec_secy *secy;
+	struct list_head macsec_flows;
+	unsigned long ingr_flows;
+	unsigned long egr_flows;
+#endif
 };
 
 #ifdef CONFIG_OF_MDIO
@@ -1972,6 +2013,579 @@ static int vsc8584_macsec_init(struct phy_device *phydev)
 
 	return 0;
 }
+
+static void vsc8584_macsec_flow(struct phy_device *phydev,
+				struct macsec_flow *flow)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	enum macsec_bank bank = flow->bank;
+	u32 val, match = 0, mask = 0, action = 0, idx = flow->index;
+
+	if (flow->control) {
+		match |= MSCC_MS_SAM_MISC_MATCH_CONTROL_PACKET;
+		mask |= MSCC_MS_SAM_MASK_CTL_PACKET_MASK;
+	}
+	if (flow->tagged)
+		match |= MSCC_MS_SAM_MISC_MATCH_TAGGED;
+	if (flow->untagged)
+		match |= MSCC_MS_SAM_MISC_MATCH_UNTAGGED;
+
+	if (bank == MACSEC_INGR) {
+		match |= MSCC_MS_SAM_MISC_MATCH_AN(flow->index);
+		mask |= MSCC_MS_SAM_MASK_AN_MASK(0x3);
+	}
+
+	/* If an SCI is present, the SC bit must be set */
+	if (bank == MACSEC_INGR && flow->rx_sa->sc->sci) {
+		match |= MSCC_MS_SAM_MISC_MATCH_TCI(BIT(3));
+		mask |= MSCC_MS_SAM_MASK_TCI_MASK(BIT(3)) |
+			MSCC_MS_SAM_MASK_SCI_MASK;
+
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_LO(idx),
+					 lower_32_bits(flow->rx_sa->sc->sci));
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_HI(idx),
+					 upper_32_bits(flow->rx_sa->sc->sci));
+	}
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MISC_MATCH(idx), match);
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MASK(idx), mask);
+
+	/* Action for matching packets */
+	if (flow->bypass)
+		action = MSCC_MS_FLOW_BYPASS;
+	else if (flow->drop)
+		action = MSCC_MS_FLOW_DROP;
+	else
+		action = (bank == MACSEC_INGR) ?
+			 MSCC_MS_FLOW_INGRESS : MSCC_MS_FLOW_EGRESS;
+
+	val = MSCC_MS_SAM_FLOW_CTRL_FLOW_TYPE(action) |
+	      MSCC_MS_SAM_FLOW_CTRL_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+	      MSCC_MS_SAM_FLOW_CTRL_DEST_PORT(MSCC_MS_PORT_CONTROLLED);
+
+	if (bank == MACSEC_INGR) {
+		if (priv->secy->replay_protect)
+			val |= MSCC_MS_SAM_FLOW_CTRL_REPLAY_PROTECT;
+		if (priv->secy->validate_frames == MACSEC_VALIDATE_STRICT)
+			val |= MSCC_MS_SAM_FLOW_CTRL_VALIDATE_FRAMES(MSCC_MS_VALIDATE_STRICT);
+		else if (priv->secy->validate_frames == MACSEC_VALIDATE_CHECK)
+			val |= MSCC_MS_SAM_FLOW_CTRL_VALIDATE_FRAMES(MSCC_MS_VALIDATE_CHECK);
+	} else if (bank == MACSEC_EGR) {
+		if (priv->secy->protect_frames)
+			val |= MSCC_MS_SAM_FLOW_CTRL_PROTECT_FRAME;
+		if (priv->secy->tx_sc.encrypt)
+			val |= MSCC_MS_SAM_FLOW_CTRL_CONF_PROTECT;
+		if (priv->secy->tx_sc.send_sci)
+			val |= MSCC_MS_SAM_FLOW_CTRL_INCLUDE_SCI;
+	}
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
+}
+
+static struct macsec_flow *vsc8584_macsec_find_flow(struct macsec_context *ctx,
+						    enum macsec_bank bank)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *pos, *tmp;
+	sci_t flow_sci, sci = bank == MACSEC_INGR ?
+			      ctx->sa.rx_sa->sc->sci : priv->secy->sci;
+
+	list_for_each_entry_safe(pos, tmp, &priv->macsec_flows, list) {
+		flow_sci = pos->bank == MACSEC_INGR ?
+			   pos->rx_sa->sc->sci : priv->secy->sci;
+		if (pos->assoc_num == ctx->sa.assoc_num && flow_sci == sci &&
+		    pos->bank == bank)
+			return pos;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
+static void vsc8584_macsec_flow_enable(struct phy_device *phydev,
+				       struct macsec_flow *flow)
+{
+	enum macsec_bank bank = flow->bank;
+	u32 val, idx = flow->index;
+	bool active = (flow->bank == MACSEC_INGR) ?
+		      flow->rx_sa->active : flow->tx_sa->active;
+
+	if (!active)
+		return;
+
+	/* Enable */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_ENTRY_SET1, BIT(idx));
+
+	/* Set in-use */
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx));
+	val |= MSCC_MS_SAM_FLOW_CTRL_SA_IN_USE;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
+}
+
+static void vsc8584_macsec_flow_disable(struct phy_device *phydev,
+					struct macsec_flow *flow)
+{
+	enum macsec_bank bank = flow->bank;
+	u32 val, idx = flow->index;
+
+	/* Disable */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_ENTRY_CLEAR1, BIT(idx));
+
+	/* Clear in-use */
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx));
+	val &= ~MSCC_MS_SAM_FLOW_CTRL_SA_IN_USE;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
+}
+
+static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
+{
+	if (flow->bank == MACSEC_INGR)
+		return flow->index + MSCC_MS_MAX_FLOWS;
+
+	return flow->index;
+}
+
+/* Derive the AES key to get a key for the hash autentication */
+static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
+				     u16 key_len, u8 hkey[16])
+{
+	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	struct skcipher_request *req = NULL;
+	struct scatterlist src, dst;
+	DECLARE_CRYPTO_WAIT(wait);
+	u32 input[4] = {0};
+	int ret;
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done,
+				      &wait);
+	ret = crypto_skcipher_setkey(tfm, key, key_len);
+	if (ret < 0)
+		goto out;
+
+	sg_init_one(&src, input, 16);
+	sg_init_one(&dst, hkey, 16);
+	skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
+
+	ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+
+out:
+	skcipher_request_free(req);
+	crypto_free_skcipher(tfm);
+	return ret;
+}
+
+static int vsc8584_macsec_transformation(struct phy_device *phydev,
+					 struct macsec_flow *flow)
+{
+	u32 rec = 0, control = 0, index = flow->index;
+	struct vsc8531_private *priv = phydev->priv;
+	enum macsec_bank bank = flow->bank;
+	u8 hkey[16];
+	int i, ret;
+	sci_t sci;
+
+	ret = vsc8584_macsec_derive_key(flow->key, priv->secy->key_len, hkey);
+	if (ret)
+		return ret;
+
+	switch (priv->secy->key_len) {
+	case 16:
+		control |= CONTROL_CRYPTO_ALG(CTRYPTO_ALG_AES_CTR_128);
+		break;
+	case 32:
+		control |= CONTROL_CRYPTO_ALG(CTRYPTO_ALG_AES_CTR_256);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	control |= (bank == MACSEC_EGR) ?
+		   (CONTROL_TYPE_EGRESS | CONTROL_AN(priv->secy->tx_sc.encoding_sa)) :
+		   (CONTROL_TYPE_INGRESS | CONTROL_SEQ_MASK);
+
+	control |= CONTROL_UPDATE_SEQ | CONTROL_ENCRYPT_AUTH | CONTROL_KEY_IN_CTX |
+		   CONTROL_IV0 | CONTROL_IV1 | CONTROL_IV_IN_SEQ |
+		   CONTROL_DIGEST_TYPE(0x2) | CONTROL_SEQ_TYPE(0x1) |
+		   CONTROL_AUTH_ALG(AUTH_ALG_AES_GHAS) | CONTROL_CONTEXT_ID;
+
+	/* Set the control word */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 control);
+
+	/* Set the context ID. Must be unique. */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 vsc8584_macsec_flow_context_id(flow));
+
+	/* Set the encryption/decryption key */
+	for (i = 0; i < priv->secy->key_len / sizeof(u32); i++)
+		vsc8584_macsec_phy_write(phydev, bank,
+					 MSCC_MS_XFORM_REC(index, rec++),
+					 ((u32 *)flow->key)[i]);
+
+	/* Set the authentication key */
+	for (i = 0; i < 4; i++)
+		vsc8584_macsec_phy_write(phydev, bank,
+					 MSCC_MS_XFORM_REC(index, rec++),
+					 ((u32 *)hkey)[i]);
+
+	/* Initial sequence number */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 bank == MACSEC_INGR ?
+				 flow->rx_sa->next_pn : flow->tx_sa->next_pn);
+
+	if (bank == MACSEC_INGR)
+		/* Set the mask (replay window size) */
+		vsc8584_macsec_phy_write(phydev, bank,
+					 MSCC_MS_XFORM_REC(index, rec++),
+					 priv->secy->replay_window);
+
+	/* Set the input vectors */
+	sci = bank == MACSEC_INGR ? flow->rx_sa->sc->sci : priv->secy->sci;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 lower_32_bits(sci));
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 upper_32_bits(sci));
+
+	while (rec < 20)
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+					 0);
+	return 0;
+}
+
+static struct macsec_flow *vsc8584_macsec_alloc_flow(struct vsc8531_private *priv,
+						     enum macsec_bank bank)
+{
+	struct macsec_flow *flow;
+	unsigned long *bitmap;
+	int index;
+
+	bitmap = bank == MACSEC_INGR ? &priv->ingr_flows : &priv->egr_flows;
+	index = find_first_zero_bit(bitmap, MSCC_MS_MAX_FLOWS);
+
+	if (index == MSCC_MS_MAX_FLOWS)
+		return ERR_PTR(-ENOMEM);
+
+	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+	if (!flow)
+		return ERR_PTR(-ENOMEM);
+
+	set_bit(index, bitmap);
+	flow->index = index;
+	flow->bank = bank;
+
+	list_add_tail(&flow->list, &priv->macsec_flows);
+	return flow;
+}
+
+static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
+				     struct macsec_flow *flow)
+{
+	unsigned long *bitmap = flow->bank == MACSEC_INGR ?
+				&priv->ingr_flows : &priv->egr_flows;
+
+	list_del(&flow->list);
+	clear_bit(flow->index, bitmap);
+	kfree(flow);
+}
+
+static int vsc8584_macsec_add_flow(struct phy_device *phydev,
+				   struct macsec_flow *flow, bool update)
+{
+	int ret;
+
+	vsc8584_macsec_flow(phydev, flow);
+
+	if (update)
+		return 0;
+
+	ret = vsc8584_macsec_transformation(phydev, flow);
+	if (ret) {
+		vsc8584_macsec_free_flow(phydev->priv, flow);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void vsc8584_macsec_del_flow(struct phy_device *phydev,
+				    struct macsec_flow *flow)
+{
+	vsc8584_macsec_flow_disable(phydev, flow);
+	vsc8584_macsec_free_flow(phydev->priv, flow);
+}
+
+static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
+				     struct macsec_flow *flow, bool update)
+{
+	struct phy_device *phydev = ctx->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+
+	if (!flow) {
+		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_INGR);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
+	}
+
+	flow->assoc_num = ctx->sa.assoc_num;
+	flow->rx_sa = ctx->sa.rx_sa;
+
+	/* Always match tagged packets on ingress */
+	flow->tagged = true;
+
+	if (priv->secy->validate_frames != MACSEC_VALIDATE_DISABLED)
+		flow->untagged = true;
+
+	return vsc8584_macsec_add_flow(phydev, flow, update);
+}
+
+static int __vsc8584_macsec_add_txsa(struct macsec_context *ctx,
+				     struct macsec_flow *flow, bool update)
+{
+	struct phy_device *phydev = ctx->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+
+	if (!flow) {
+		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_EGR);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
+	}
+
+	flow->assoc_num = ctx->sa.assoc_num;
+	flow->tx_sa = ctx->sa.tx_sa;
+
+	/* Always match untagged packets on egress */
+	flow->untagged = true;
+
+	return vsc8584_macsec_add_flow(phydev, flow, update);
+}
+
+static int vsc8584_macsec_dev_open(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
+		vsc8584_macsec_flow_enable(ctx->phydev, flow);
+
+	return 0;
+}
+
+static int vsc8584_macsec_dev_stop(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
+		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+
+	return 0;
+}
+
+static int vsc8584_macsec_add_secy(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+
+	if (ctx->prepare) {
+		if (priv->secy)
+			return -EEXIST;
+
+		return 0;
+	}
+
+	priv->secy = ctx->secy;
+	return 0;
+}
+
+static int vsc8584_macsec_del_secy(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
+		vsc8584_macsec_del_flow(ctx->phydev, flow);
+
+	priv->secy = NULL;
+	return 0;
+}
+
+static int vsc8584_macsec_upd_secy(struct macsec_context *ctx)
+{
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	vsc8584_macsec_del_secy(ctx);
+	return vsc8584_macsec_add_secy(ctx);
+}
+
+static int vsc8584_macsec_add_rxsc(struct macsec_context *ctx)
+{
+	/* Nothing to do */
+	return 0;
+}
+
+static int vsc8584_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int vsc8584_macsec_del_rxsc(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
+		if (flow->bank == MACSEC_INGR &&
+		    flow->rx_sa->sc->sci == ctx->rx_sc->sci)
+			vsc8584_macsec_del_flow(ctx->phydev, flow);
+	}
+
+	return 0;
+}
+
+static int vsc8584_macsec_add_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow = NULL;
+
+	if (ctx->prepare)
+		return __vsc8584_macsec_add_rxsa(ctx, flow, false);
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	if (ctx->prepare) {
+		/* Make sure the flow is disabled before updating it */
+		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+
+		return __vsc8584_macsec_add_rxsa(ctx, flow, true);
+	}
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_del_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+	if (ctx->prepare)
+		return 0;
+
+	vsc8584_macsec_del_flow(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_add_txsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow = NULL;
+
+	if (ctx->prepare)
+		return __vsc8584_macsec_add_txsa(ctx, flow, false);
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_upd_txsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	if (ctx->prepare) {
+		/* Make sure the flow is disabled before updating it */
+		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+
+		return __vsc8584_macsec_add_txsa(ctx, flow, true);
+	}
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_del_txsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+	if (ctx->prepare)
+		return 0;
+
+	vsc8584_macsec_del_flow(ctx->phydev, flow);
+	return 0;
+}
+
+static struct macsec_ops vsc8584_macsec_ops = {
+	.mdo_dev_open = vsc8584_macsec_dev_open,
+	.mdo_dev_stop = vsc8584_macsec_dev_stop,
+	.mdo_add_secy = vsc8584_macsec_add_secy,
+	.mdo_upd_secy = vsc8584_macsec_upd_secy,
+	.mdo_del_secy = vsc8584_macsec_del_secy,
+	.mdo_add_rxsc = vsc8584_macsec_add_rxsc,
+	.mdo_upd_rxsc = vsc8584_macsec_upd_rxsc,
+	.mdo_del_rxsc = vsc8584_macsec_del_rxsc,
+	.mdo_add_rxsa = vsc8584_macsec_add_rxsa,
+	.mdo_upd_rxsa = vsc8584_macsec_upd_rxsa,
+	.mdo_del_rxsa = vsc8584_macsec_del_rxsa,
+	.mdo_add_txsa = vsc8584_macsec_add_txsa,
+	.mdo_upd_txsa = vsc8584_macsec_upd_txsa,
+	.mdo_del_txsa = vsc8584_macsec_del_txsa,
+};
 #endif /* CONFIG_MACSEC */
 
 /* Check if one PHY has already done the init of the parts common to all PHYs
@@ -2103,10 +2717,17 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		goto err;
 
+#if IS_ENABLED(CONFIG_MACSEC)
 	/* MACsec */
+	INIT_LIST_HEAD(&vsc8531->macsec_flows);
+	vsc8531->secy = NULL;
+
+	phydev->macsec_ops = &vsc8584_macsec_ops;
+
 	ret = vsc8584_macsec_init(phydev);
 	if (ret)
 		goto err;
+#endif
 
 	mutex_unlock(&phydev->mdio.bus->mdio_lock);
 
diff --git a/drivers/net/phy/mscc_macsec.h b/drivers/net/phy/mscc_macsec.h
index 52902669e8ca..cf12d7967133 100644
--- a/drivers/net/phy/mscc_macsec.h
+++ b/drivers/net/phy/mscc_macsec.h
@@ -8,6 +8,8 @@
 #ifndef _MSCC_OCELOT_MACSEC_H_
 #define _MSCC_OCELOT_MACSEC_H_
 
+#define MSCC_MS_MAX_FLOWS		16
+
 #define CONTROL_TYPE_EGRESS		0x6
 #define CONTROL_TYPE_INGRESS		0xf
 #define CONTROL_IV0			BIT(5)
-- 
2.21.0

