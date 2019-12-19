Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F6712604F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfLSLA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:29 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37499 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbfLSLA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:27 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6274160019;
        Thu, 19 Dec 2019 11:00:24 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 05/15] net: macsec: hardware offloading infrastructure
Date:   Thu, 19 Dec 2019 11:55:05 +0100
Message-Id: <20191219105515.78400-6-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the MACsec hardware offloading infrastructure.

The main idea here is to re-use the logic and data structures of the
software MACsec implementation. This allows not to duplicate definitions
and structure storing the same kind of information. It also allows to
use a unified genlink interface for both MACsec implementations (so that
the same userspace tool, `ip macsec`, is used with the same arguments).
The MACsec offloading support cannot be disabled if an interface
supports it at the moment.

The MACsec configuration is passed to device drivers supporting it
through macsec_ops which are called from the MACsec genl helpers. Those
functions call the macsec ops of PHY and Ethernet drivers in two steps:
a preparation one, and a commit one. The first step is allowed to fail
and should be used to check if a provided configuration is compatible
with the features provided by a MACsec engine, while the second step is
not allowed to fail and should only be used to enable a given MACsec
configuration. Two extra calls are made: when a virtual MACsec interface
is created and when it is deleted, so that the hardware driver can stay
in sync.

The Rx and TX handlers are modified to take in account the special case
were the MACsec transformation happens in the hardware, whether in a PHY
or in a MAC, as the packets seen by the networking stack on both the
physical and MACsec virtual interface are exactly the same. This leads
to some limitations: the hardware and software implementations can't be
used on the same physical interface, as the policies would be impossible
to fulfill (such as strict validation of the frames). Also only a single
virtual MACsec interface can be offloaded to a physical port supporting
hardware offloading as it would be impossible to guess onto which
interface a given packet should go (for ingress traffic).

Another limitation as of now is that the counters and statistics are not
reported back from the hardware to the software MACsec implementation.
This isn't an issue when using offloaded MACsec transformations, but it
should be added in the future so that the MACsec state can be reported
to the user (which would also improve the debug).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c | 453 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 441 insertions(+), 12 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 9bce52d62eb3..3aa2a827c2bd 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -11,11 +11,13 @@
 #include <linux/module.h>
 #include <crypto/aead.h>
 #include <linux/etherdevice.h>
+#include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/refcount.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
 #include <net/gro_cells.h>
+#include <linux/phy.h>
 
 #include <uapi/linux/if_macsec.h>
 
@@ -97,6 +99,7 @@ struct pcpu_secy_stats {
  * @real_dev: pointer to underlying netdevice
  * @stats: MACsec device stats
  * @secys: linked list of SecY's on the underlying device
+ * @offload: status of offloading on the MACsec device
  */
 struct macsec_dev {
 	struct macsec_secy secy;
@@ -104,6 +107,7 @@ struct macsec_dev {
 	struct pcpu_secy_stats __percpu *stats;
 	struct list_head secys;
 	struct gro_cells gro_cells;
+	enum macsec_offload offload;
 };
 
 /**
@@ -317,6 +321,56 @@ static void macsec_set_shortlen(struct macsec_eth_header *h, size_t data_len)
 		h->short_length = data_len;
 }
 
+/* Checks if a MACsec interface is being offloaded to an hardware engine */
+static bool macsec_is_offloaded(struct macsec_dev *macsec)
+{
+	if (macsec->offload == MACSEC_OFFLOAD_PHY)
+		return true;
+
+	return false;
+}
+
+/* Checks if underlying layers implement MACsec offloading functions. */
+static bool macsec_check_offload(enum macsec_offload offload,
+				 struct macsec_dev *macsec)
+{
+	if (!macsec || !macsec->real_dev)
+		return false;
+
+	if (offload == MACSEC_OFFLOAD_PHY)
+		return macsec->real_dev->phydev &&
+		       macsec->real_dev->phydev->macsec_ops;
+
+	return false;
+}
+
+static const struct macsec_ops *__macsec_get_ops(enum macsec_offload offload,
+						 struct macsec_dev *macsec,
+						 struct macsec_context *ctx)
+{
+	if (ctx) {
+		memset(ctx, 0, sizeof(*ctx));
+		ctx->offload = offload;
+
+		if (offload == MACSEC_OFFLOAD_PHY)
+			ctx->phydev = macsec->real_dev->phydev;
+	}
+
+	return macsec->real_dev->phydev->macsec_ops;
+}
+
+/* Returns a pointer to the MACsec ops struct if any and updates the MACsec
+ * context device reference if provided.
+ */
+static const struct macsec_ops *macsec_get_ops(struct macsec_dev *macsec,
+					       struct macsec_context *ctx)
+{
+	if (!macsec_check_offload(macsec->offload, macsec))
+		return NULL;
+
+	return __macsec_get_ops(macsec->offload, macsec, ctx);
+}
+
 /* validate MACsec packet according to IEEE 802.1AE-2006 9.12 */
 static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
 {
@@ -866,8 +920,10 @@ static struct macsec_rx_sc *find_rx_sc_rtnl(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static void handle_not_macsec(struct sk_buff *skb)
+static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 {
+	/* Deliver to the uncontrolled port by default */
+	enum rx_handler_result ret = RX_HANDLER_PASS;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 
@@ -882,7 +938,8 @@ static void handle_not_macsec(struct sk_buff *skb)
 		struct sk_buff *nskb;
 		struct pcpu_secy_stats *secy_stats = this_cpu_ptr(macsec->stats);
 
-		if (macsec->secy.validate_frames == MACSEC_VALIDATE_STRICT) {
+		if (!macsec_is_offloaded(macsec) &&
+		    macsec->secy.validate_frames == MACSEC_VALIDATE_STRICT) {
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoTag++;
 			u64_stats_update_end(&secy_stats->syncp);
@@ -901,9 +958,17 @@ static void handle_not_macsec(struct sk_buff *skb)
 			secy_stats->stats.InPktsUntagged++;
 			u64_stats_update_end(&secy_stats->syncp);
 		}
+
+		if (netif_running(macsec->secy.netdev) &&
+		    macsec_is_offloaded(macsec)) {
+			ret = RX_HANDLER_EXACT;
+			goto out;
+		}
 	}
 
+out:
 	rcu_read_unlock();
+	return ret;
 }
 
 static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
@@ -928,12 +993,8 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		goto drop_direct;
 
 	hdr = macsec_ethhdr(skb);
-	if (hdr->eth.h_proto != htons(ETH_P_MACSEC)) {
-		handle_not_macsec(skb);
-
-		/* and deliver to the uncontrolled port */
-		return RX_HANDLER_PASS;
-	}
+	if (hdr->eth.h_proto != htons(ETH_P_MACSEC))
+		return handle_not_macsec(skb);
 
 	skb = skb_unshare(skb, GFP_ATOMIC);
 	*pskb = skb;
@@ -1439,6 +1500,40 @@ static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 				 .len = MACSEC_MAX_KEY_LEN, },
 };
 
+/* Offloads an operation to a device driver */
+static int macsec_offload(int (* const func)(struct macsec_context *),
+			  struct macsec_context *ctx)
+{
+	int ret;
+
+	if (unlikely(!func))
+		return 0;
+
+	if (ctx->offload == MACSEC_OFFLOAD_PHY)
+		mutex_lock(&ctx->phydev->lock);
+
+	/* Phase I: prepare. The drive should fail here if there are going to be
+	 * issues in the commit phase.
+	 */
+	ctx->prepare = true;
+	ret = (*func)(ctx);
+	if (ret)
+		goto phy_unlock;
+
+	/* Phase II: commit. This step cannot fail. */
+	ctx->prepare = false;
+	ret = (*func)(ctx);
+	/* This should never happen: commit is not allowed to fail */
+	if (unlikely(ret))
+		WARN(1, "MACsec offloading commit failed (%d)\n", ret);
+
+phy_unlock:
+	if (ctx->offload == MACSEC_OFFLOAD_PHY)
+		mutex_unlock(&ctx->phydev->lock);
+
+	return ret;
+}
+
 static int parse_sa_config(struct nlattr **attrs, struct nlattr **tb_sa)
 {
 	if (!attrs[MACSEC_ATTR_SA_CONFIG])
@@ -1554,13 +1649,40 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
 		rx_sa->active = !!nla_get_u8(tb_sa[MACSEC_SA_ATTR_ACTIVE]);
 
-	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rx_sa->sc = rx_sc;
+
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			err = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.rx_sa = rx_sa;
+		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
+		       MACSEC_KEYID_LEN);
+
+		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
+		if (err)
+			goto cleanup;
+	}
+
+	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
 
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	kfree(rx_sa);
+	rtnl_unlock();
+	return err;
 }
 
 static bool validate_add_rxsc(struct nlattr **attrs)
@@ -1583,6 +1705,8 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **attrs = info->attrs;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	bool was_active;
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1608,12 +1732,35 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
+	was_active = rx_sc->active;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
 		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.rx_sc = rx_sc;
+
+		ret = macsec_offload(ops->mdo_add_rxsc, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	rx_sc->active = was_active;
+	rtnl_unlock();
+	return ret;
 }
 
 static bool validate_add_txsa(struct nlattr **attrs)
@@ -1650,6 +1797,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_tx_sa *tx_sa;
 	unsigned char assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_operational;
 	int err;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1700,8 +1848,6 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		return err;
 	}
 
-	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
-
 	spin_lock_bh(&tx_sa->lock);
 	tx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
@@ -1709,14 +1855,43 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
 		tx_sa->active = !!nla_get_u8(tb_sa[MACSEC_SA_ATTR_ACTIVE]);
 
+	was_operational = secy->operational;
 	if (assoc_num == tx_sc->encoding_sa && tx_sa->active)
 		secy->operational = true;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			err = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.tx_sa = tx_sa;
+		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
+		       MACSEC_KEYID_LEN);
+
+		err = macsec_offload(ops->mdo_add_txsa, &ctx);
+		if (err)
+			goto cleanup;
+	}
+
+	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);
 
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	secy->operational = was_operational;
+	kfree(tx_sa);
+	rtnl_unlock();
+	return err;
 }
 
 static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
@@ -1729,6 +1904,7 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 	u8 assoc_num;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1752,12 +1928,35 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 		return -EBUSY;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.rx_sa = rx_sa;
+
+		ret = macsec_offload(ops->mdo_del_rxsa, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	RCU_INIT_POINTER(rx_sc->sa[assoc_num], NULL);
 	clear_rx_sa(rx_sa);
 
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	rtnl_unlock();
+	return ret;
 }
 
 static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
@@ -1768,6 +1967,7 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	sci_t sci;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1794,10 +1994,31 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return -ENODEV;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.rx_sc = rx_sc;
+		ret = macsec_offload(ops->mdo_del_rxsc, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	free_rx_sc(rx_sc);
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	rtnl_unlock();
+	return ret;
 }
 
 static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
@@ -1809,6 +2030,7 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_tx_sa *tx_sa;
 	u8 assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1829,12 +2051,35 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 		return -EBUSY;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.tx_sa = tx_sa;
+
+		ret = macsec_offload(ops->mdo_del_txsa, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	RCU_INIT_POINTER(tx_sc->sa[assoc_num], NULL);
 	clear_tx_sa(tx_sa);
 
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	rtnl_unlock();
+	return ret;
 }
 
 static bool validate_upd_sa(struct nlattr **attrs)
@@ -1867,6 +2112,9 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_tx_sa *tx_sa;
 	u8 assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_operational, was_active;
+	u32 prev_pn = 0;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1887,19 +2135,52 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&tx_sa->lock);
+		prev_pn = tx_sa->next_pn;
 		tx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
+	was_active = tx_sa->active;
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
 		tx_sa->active = nla_get_u8(tb_sa[MACSEC_SA_ATTR_ACTIVE]);
 
+	was_operational = secy->operational;
 	if (assoc_num == tx_sc->encoding_sa)
 		secy->operational = tx_sa->active;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.tx_sa = tx_sa;
+
+		ret = macsec_offload(ops->mdo_upd_txsa, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		spin_lock_bh(&tx_sa->lock);
+		tx_sa->next_pn = prev_pn;
+		spin_unlock_bh(&tx_sa->lock);
+	}
+	tx_sa->active = was_active;
+	secy->operational = was_operational;
+	rtnl_unlock();
+	return ret;
 }
 
 static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
@@ -1912,6 +2193,9 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 	u8 assoc_num;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_active;
+	u32 prev_pn = 0;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1935,15 +2219,46 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
+		prev_pn = rx_sa->next_pn;
 		rx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
+	was_active = rx_sa->active;
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
 		rx_sa->active = nla_get_u8(tb_sa[MACSEC_SA_ATTR_ACTIVE]);
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.rx_sa = rx_sa;
+
+		ret = macsec_offload(ops->mdo_upd_rxsa, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	rtnl_unlock();
 	return 0;
+
+cleanup:
+	if (tb_sa[MACSEC_SA_ATTR_PN]) {
+		spin_lock_bh(&rx_sa->lock);
+		rx_sa->next_pn = prev_pn;
+		spin_unlock_bh(&rx_sa->lock);
+	}
+	rx_sa->active = was_active;
+	rtnl_unlock();
+	return ret;
 }
 
 static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
@@ -1953,6 +2268,9 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	unsigned int prev_n_rx_sc;
+	bool was_active;
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1970,6 +2288,8 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
+	was_active = rx_sc->active;
+	prev_n_rx_sc = secy->n_rx_sc;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]) {
 		bool new = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
@@ -1979,9 +2299,33 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		rx_sc->active = new;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.rx_sc = rx_sc;
+
+		ret = macsec_offload(ops->mdo_upd_rxsc, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
 	rtnl_unlock();
 
 	return 0;
+
+cleanup:
+	secy->n_rx_sc = prev_n_rx_sc;
+	rx_sc->active = was_active;
+	rtnl_unlock();
+	return ret;
 }
 
 static int copy_tx_sa_stats(struct sk_buff *skb,
@@ -2549,6 +2893,11 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	struct pcpu_secy_stats *secy_stats;
 	int ret, len;
 
+	if (macsec_is_offloaded(netdev_priv(dev))) {
+		skb->dev = macsec->real_dev;
+		return dev_queue_xmit(skb);
+	}
+
 	/* 10.5 */
 	if (!secy->protect_frames) {
 		secy_stats = this_cpu_ptr(macsec->stats);
@@ -2662,6 +3011,22 @@ static int macsec_dev_open(struct net_device *dev)
 			goto clear_allmulti;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			err = -EOPNOTSUPP;
+			goto clear_allmulti;
+		}
+
+		err = macsec_offload(ops->mdo_dev_open, &ctx);
+		if (err)
+			goto clear_allmulti;
+	}
+
 	if (netif_carrier_ok(real_dev))
 		netif_carrier_on(dev);
 
@@ -2682,6 +3047,16 @@ static int macsec_dev_stop(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops)
+			macsec_offload(ops->mdo_dev_stop, &ctx);
+	}
+
 	dev_mc_unsync(real_dev, dev);
 	dev_uc_unsync(real_dev, dev);
 
@@ -2913,6 +3288,11 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct nlattr *data[],
 			     struct netlink_ext_ack *extack)
 {
+	struct macsec_dev *macsec = macsec_priv(dev);
+	struct macsec_tx_sa tx_sc;
+	struct macsec_secy secy;
+	int ret;
+
 	if (!data)
 		return 0;
 
@@ -2922,7 +3302,41 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	    data[IFLA_MACSEC_PORT])
 		return -EINVAL;
 
-	return macsec_changelink_common(dev, data);
+	/* Keep a copy of unmodified secy and tx_sc, in case the offload
+	 * propagation fails, to revert macsec_changelink_common.
+	 */
+	memcpy(&secy, &macsec->secy, sizeof(secy));
+	memcpy(&tx_sc, &macsec->secy.tx_sc, sizeof(tx_sc));
+
+	ret = macsec_changelink_common(dev, data);
+	if (ret)
+		return ret;
+
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+		int ret;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (!ops) {
+			ret = -EOPNOTSUPP;
+			goto cleanup;
+		}
+
+		ctx.secy = &macsec->secy;
+		ret = macsec_offload(ops->mdo_upd_secy, &ctx);
+		if (ret)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	memcpy(&macsec->secy.tx_sc, &tx_sc, sizeof(tx_sc));
+	memcpy(&macsec->secy, &secy, sizeof(secy));
+
+	return ret;
 }
 
 static void macsec_del_dev(struct macsec_dev *macsec)
@@ -2965,6 +3379,18 @@ static void macsec_dellink(struct net_device *dev, struct list_head *head)
 	struct net_device *real_dev = macsec->real_dev;
 	struct macsec_rxh_data *rxd = macsec_data_rtnl(real_dev);
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			macsec_offload(ops->mdo_del_secy, &ctx);
+		}
+	}
+
 	macsec_common_dellink(dev, head);
 
 	if (list_empty(&rxd->secys)) {
@@ -3076,6 +3502,9 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 
 	macsec->real_dev = real_dev;
 
+	/* MACsec offloading is off by default */
+	macsec->offload = MACSEC_OFFLOAD_OFF;
+
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
 	dev->mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
-- 
2.24.1

