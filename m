Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF3A86401
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390115AbfHHOKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:10:15 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56901 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390104AbfHHOKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:14 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 92B206000B;
        Thu,  8 Aug 2019 14:10:11 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 6/9] net: macsec: hardware offloading infrastructure
Date:   Thu,  8 Aug 2019 16:05:57 +0200
Message-Id: <20190808140600.21477-7-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808140600.21477-1-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
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
through macsec_hw_offload() which is called from the MACsec genl
helpers. This function calls the macsec ops of PHY and Ethernet
drivers in two steps: a preparation one, and a commit one. The first
step is allowed to fail and should be used to check if a provided
configuration is compatible with the features provided by a MACsec
engine, while the second step is not allowed to fail and should only be
used to enable a given MACsec configuration. Two extra calls are made:
when a virtual MACsec interface is created and when it is deleted, so
that the hardware driver can stay in sync.

The Rx and TX handlers are modified to take in account the special case
were the MACsec transformation happens in the hardware, whether in a PHY
or in a MAC, as the packets seen by the networking stack on both the
physical and MACsec virtual interface are exactly the same. This leads
to some limitations: the hardware and software implementations can't be
used on the same physical interface, as the policies would be impossible
to fulfill (such as strict validation of the frames). Also only a single
virtual MACsec interface can be attached to a physical port supporting
hardware offloading as it would be impossible to guess onto which
interface a given packet should go (for ingress traffic).

Another limitation as of now is that the counters and statistics are not
reported back from the hardware to the software MACsec implementation.
This isn't an issue when using offloaded MACsec transformations, but it
should be added in the future so that the MACsec state can be reported
to the user (which would also improve the debug).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c | 379 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 362 insertions(+), 17 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3815cb6e9bf2..74f0e06a9fc2 100644
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
 
@@ -318,6 +320,44 @@ static void macsec_set_shortlen(struct macsec_eth_header *h, size_t data_len)
 		h->short_length = data_len;
 }
 
+/* Checks if underlying layers implement MACsec offloading functions
+ * and returns a pointer to the MACsec ops struct if any (also updates
+ * the MACsec context device reference if provided).
+ */
+static const struct macsec_ops *macsec_get_ops(struct macsec_dev *dev,
+					       struct macsec_context *ctx)
+{
+	struct phy_device *phydev;
+
+	if (!dev || !dev->real_dev)
+		return NULL;
+
+	/* Check if the PHY device provides MACsec ops */
+	phydev = dev->real_dev->phydev;
+	if (phydev && phydev->macsec_ops) {
+		if (ctx) {
+			memset(ctx, 0, sizeof(*ctx));
+			ctx->phydev = phydev;
+			ctx->is_phy = 1;
+		}
+
+		return phydev->macsec_ops;
+	}
+
+	/* Check if the net device provides MACsec ops */
+	if (dev->real_dev->features & NETIF_F_HW_MACSEC &&
+	    dev->real_dev->macsec_ops) {
+		if (ctx) {
+			memset(ctx, 0, sizeof(*ctx));
+			ctx->netdev = dev->real_dev;
+		}
+
+		return dev->real_dev->macsec_ops;
+	}
+
+	return NULL;
+}
+
 /* validate MACsec packet according to IEEE 802.1AE-2006 9.12 */
 static bool macsec_validate_skb(struct sk_buff *skb, u16 icv_len)
 {
@@ -867,8 +907,10 @@ static struct macsec_rx_sc *find_rx_sc_rtnl(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static void handle_not_macsec(struct sk_buff *skb)
+static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 {
+	/* Deliver to the uncontrolled port by default */
+	enum rx_handler_result ret = RX_HANDLER_PASS;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 
@@ -883,7 +925,8 @@ static void handle_not_macsec(struct sk_buff *skb)
 		struct sk_buff *nskb;
 		struct pcpu_secy_stats *secy_stats = this_cpu_ptr(macsec->stats);
 
-		if (macsec->secy.validate_frames == MACSEC_VALIDATE_STRICT) {
+		if (!macsec_get_ops(macsec, NULL) &&
+		    macsec->secy.validate_frames == MACSEC_VALIDATE_STRICT) {
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoTag++;
 			u64_stats_update_end(&secy_stats->syncp);
@@ -902,9 +945,17 @@ static void handle_not_macsec(struct sk_buff *skb)
 			secy_stats->stats.InPktsUntagged++;
 			u64_stats_update_end(&secy_stats->syncp);
 		}
+
+		if (netif_running(macsec->secy.netdev) &&
+		    macsec_get_ops(macsec, NULL)) {
+			ret = RX_HANDLER_EXACT;
+			goto out;
+		}
 	}
 
+out:
 	rcu_read_unlock();
+	return ret;
 }
 
 static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
@@ -929,12 +980,8 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
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
@@ -1439,6 +1486,40 @@ static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
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
+	if (ctx->is_phy)
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
+	if (ctx->is_phy)
+		mutex_unlock(&ctx->phydev->lock);
+
+	return ret;
+}
+
 static int parse_sa_config(struct nlattr **attrs, struct nlattr **tb_sa)
 {
 	if (!attrs[MACSEC_ATTR_SA_CONFIG])
@@ -1490,11 +1571,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev;
 	struct nlattr **attrs = info->attrs;
 	struct macsec_secy *secy;
-	struct macsec_rx_sc *rx_sc;
+	struct macsec_rx_sc *rx_sc, *prev_sc;
 	struct macsec_rx_sa *rx_sa;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	unsigned char assoc_num;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_active;
 	int err;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1551,11 +1635,32 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
+	was_active = rx_sa->active;
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
 		rx_sa->active = !!nla_get_u8(tb_sa[MACSEC_SA_ATTR_ACTIVE]);
 
-	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
+	prev_sc = rx_sa->sc;
 	rx_sa->sc = rx_sc;
+
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.rx_sa = rx_sa;
+		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
+		       MACSEC_KEYID_LEN);
+
+		err = macsec_offload(ops->mdo_add_rxsa, &ctx);
+		if (err) {
+			rx_sa->active = was_active;
+			rx_sa->sc = prev_sc;
+			kfree(rx_sa);
+			rtnl_unlock();
+			return err;
+		}
+	}
+
+	nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
 
 	rtnl_unlock();
@@ -1583,6 +1688,10 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **attrs = info->attrs;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	bool was_active;
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1608,9 +1717,22 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
+	was_active = rx_sc->active;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
 		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.rx_sc = rx_sc;
+
+		ret = macsec_offload(ops->mdo_add_rxsc, &ctx);
+		if (ret) {
+			rx_sc->active = was_active;
+			rtnl_unlock();
+			return ret;
+		}
+	}
+
 	rtnl_unlock();
 
 	return 0;
@@ -1648,8 +1770,12 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	unsigned char assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_operational, was_active;
+	u32 prev_pn;
 	int err;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1700,18 +1826,42 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		return err;
 	}
 
-	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
-
 	spin_lock_bh(&tx_sa->lock);
+	prev_pn = tx_sa->next_pn;
 	tx_sa->next_pn = nla_get_u32(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
+	was_active = tx_sa->active;
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
 		tx_sa->active = !!nla_get_u8(tb_sa[MACSEC_SA_ATTR_ACTIVE]);
 
+	was_operational = secy->operational;
 	if (assoc_num == tx_sc->encoding_sa && tx_sa->active)
 		secy->operational = true;
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.tx_sa = tx_sa;
+		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
+		       MACSEC_KEYID_LEN);
+
+		err = macsec_offload(ops->mdo_add_txsa, &ctx);
+		if (err) {
+			spin_lock_bh(&tx_sa->lock);
+			tx_sa->next_pn = prev_pn;
+			spin_unlock_bh(&tx_sa->lock);
+
+			tx_sa->active = was_active;
+			secy->operational = was_operational;
+			kfree(tx_sa);
+			rtnl_unlock();
+			return err;
+		}
+	}
+
+	nla_memcpy(tx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEYID_LEN);
 	rcu_assign_pointer(tx_sc->sa[assoc_num], tx_sa);
 
 	rtnl_unlock();
@@ -1726,9 +1876,12 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_rx_sa *rx_sa;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	u8 assoc_num;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1752,6 +1905,19 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 		return -EBUSY;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.rx_sa = rx_sa;
+
+		ret = macsec_offload(ops->mdo_del_rxsa, &ctx);
+		if (ret) {
+			rtnl_unlock();
+			return ret;
+		}
+	}
+
 	RCU_INIT_POINTER(rx_sc->sa[assoc_num], NULL);
 	clear_rx_sa(rx_sa);
 
@@ -1766,8 +1932,11 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev;
 	struct macsec_secy *secy;
 	struct macsec_rx_sc *rx_sc;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	sci_t sci;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1794,6 +1963,17 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return -ENODEV;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.rx_sc = rx_sc;
+		ret = macsec_offload(ops->mdo_del_rxsc, &ctx);
+		if (ret) {
+			rtnl_unlock();
+			return ret;
+		}
+	}
+
 	free_rx_sc(rx_sc);
 	rtnl_unlock();
 
@@ -1807,8 +1987,11 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	u8 assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1829,6 +2012,19 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 		return -EBUSY;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.tx_sa = tx_sa;
+
+		ret = macsec_offload(ops->mdo_del_txsa, &ctx);
+		if (ret) {
+			rtnl_unlock();
+			return ret;
+		}
+	}
+
 	RCU_INIT_POINTER(tx_sc->sa[assoc_num], NULL);
 	clear_tx_sa(tx_sa);
 
@@ -1865,8 +2061,13 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_tx_sc *tx_sc;
 	struct macsec_tx_sa *tx_sa;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	u8 assoc_num;
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_operational, was_active;
+	u32 prev_pn = 0;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1887,19 +2088,41 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
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
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.tx_sa = tx_sa;
+
+		ret = macsec_offload(ops->mdo_upd_txsa, &ctx);
+		if (ret) {
+			if (tb_sa[MACSEC_SA_ATTR_PN]) {
+				spin_lock_bh(&tx_sa->lock);
+				tx_sa->next_pn = prev_pn;
+				spin_unlock_bh(&tx_sa->lock);
+			}
+
+			tx_sa->active = was_active;
+			secy->operational = was_operational;
+		}
+	}
+
 	rtnl_unlock();
 
-	return 0;
+	return ret;
 }
 
 static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
@@ -1909,9 +2132,14 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_rx_sa *rx_sa;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	u8 assoc_num;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct nlattr *tb_sa[MACSEC_SA_ATTR_MAX + 1];
+	bool was_active;
+	u32 prev_pn = 0;
+	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1935,15 +2163,35 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
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
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.sa.assoc_num = assoc_num;
+		ctx.sa.rx_sa = rx_sa;
+
+		ret = macsec_offload(ops->mdo_upd_rxsa, &ctx);
+		if (ret) {
+			if (tb_sa[MACSEC_SA_ATTR_PN]) {
+				spin_lock_bh(&rx_sa->lock);
+				rx_sa->next_pn = prev_pn;
+				spin_unlock_bh(&rx_sa->lock);
+			}
+
+			rx_sa->active = was_active;
+		}
+	}
+
 	rtnl_unlock();
-	return 0;
+	return ret;
 }
 
 static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
@@ -1953,6 +2201,11 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_secy *secy;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	unsigned int prev_n_rx_sc;
+	bool was_active;
+	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
 		return -EINVAL;
@@ -1970,6 +2223,8 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
+	was_active = rx_sc->active;
+	prev_n_rx_sc = secy->n_rx_sc;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]) {
 		bool new = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
@@ -1979,6 +2234,19 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		rx_sc->active = new;
 	}
 
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.rx_sc = rx_sc;
+
+		ret = macsec_offload(ops->mdo_upd_rxsc, &ctx);
+		if (ret) {
+			secy->n_rx_sc = prev_n_rx_sc;
+			rx_sc->active = was_active;
+			rtnl_unlock();
+			return 0;
+		}
+	}
+
 	rtnl_unlock();
 
 	return 0;
@@ -2546,11 +2814,15 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 {
 	struct macsec_dev *macsec = netdev_priv(dev);
 	struct macsec_secy *secy = &macsec->secy;
+	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	struct pcpu_secy_stats *secy_stats;
+	struct macsec_tx_sa *tx_sa;
 	int ret, len;
 
+	tx_sa = macsec_txsa_get(tx_sc->sa[tx_sc->encoding_sa]);
+
 	/* 10.5 */
-	if (!secy->protect_frames) {
+	if (!secy->protect_frames || macsec_get_ops(netdev_priv(dev), NULL)) {
 		secy_stats = this_cpu_ptr(macsec->stats);
 		u64_stats_update_begin(&secy_stats->syncp);
 		secy_stats->stats.OutPktsUntagged++;
@@ -2645,6 +2917,8 @@ static int macsec_dev_open(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 	int err;
 
 	err = dev_uc_add(real_dev, dev->dev_addr);
@@ -2663,6 +2937,14 @@ static int macsec_dev_open(struct net_device *dev)
 			goto clear_allmulti;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		err = macsec_offload(ops->mdo_dev_open, &ctx);
+		if (err)
+			goto clear_allmulti;
+	}
+
 	if (netif_carrier_ok(real_dev))
 		netif_carrier_on(dev);
 
@@ -2680,9 +2962,16 @@ static int macsec_dev_stop(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
 
 	netif_carrier_off(dev);
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops)
+		macsec_offload(ops->mdo_dev_stop, &ctx);
+
 	dev_mc_unsync(real_dev, dev);
 	dev_uc_unsync(real_dev, dev);
 
@@ -2922,6 +3211,11 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct nlattr *data[],
 			     struct netlink_ext_ack *extack)
 {
+	struct macsec_dev *macsec = macsec_priv(dev);
+	struct macsec_context ctx;
+	const struct macsec_ops *ops;
+	int ret;
+
 	if (!data)
 		return 0;
 
@@ -2931,7 +3225,18 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	    data[IFLA_MACSEC_PORT])
 		return -EINVAL;
 
-	return macsec_changelink_common(dev, data);
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.secy = &macsec->secy;
+		return macsec_offload(ops->mdo_upd_secy, &ctx);
+	}
+
+	ret = macsec_changelink_common(dev, data);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static void macsec_del_dev(struct macsec_dev *macsec)
@@ -2973,6 +3278,15 @@ static void macsec_dellink(struct net_device *dev, struct list_head *head)
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 	struct macsec_rxh_data *rxd = macsec_data_rtnl(real_dev);
+	struct macsec_context ctx;
+	const struct macsec_ops *ops;
+
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.secy = &macsec->secy;
+		macsec_offload(ops->mdo_del_secy, &ctx);
+	}
 
 	macsec_common_dellink(dev, head);
 
@@ -3069,7 +3383,10 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 			  struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
-	struct net_device *real_dev;
+	struct net_device *real_dev, *loop_dev;
+	struct macsec_context ctx;
+	const struct macsec_ops *ops;
+	struct net *loop_net;
 	int err;
 	sci_t sci;
 	u8 icv_len = DEFAULT_ICV_LEN;
@@ -3081,6 +3398,25 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	if (!real_dev)
 		return -ENODEV;
 
+	for_each_net(loop_net) {
+		for_each_netdev(loop_net, loop_dev) {
+			struct macsec_dev *priv;
+
+			if (!netif_is_macsec(loop_dev))
+				continue;
+
+			priv = macsec_priv(loop_dev);
+
+			/* A limitation of the MACsec h/w offloading is only a
+			 * single MACsec interface can be created for a given
+			 * real interface.
+			 */
+			if (macsec_get_ops(netdev_priv(dev), NULL) &&
+			    priv->real_dev == real_dev)
+				return -EBUSY;
+		}
+	}
+
 	dev->priv_flags |= IFF_MACSEC;
 
 	macsec->real_dev = real_dev;
@@ -3134,6 +3470,15 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 			goto del_dev;
 	}
 
+	/* If h/w offloading is available, propagate to the device */
+	ops = macsec_get_ops(netdev_priv(dev), &ctx);
+	if (ops) {
+		ctx.secy = &macsec->secy;
+		err = macsec_offload(ops->mdo_add_secy, &ctx);
+		if (err)
+			goto del_dev;
+	}
+
 	err = register_macsec_dev(real_dev, dev);
 	if (err < 0)
 		goto del_dev;
-- 
2.21.0

