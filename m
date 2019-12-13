Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5763611E70C
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfLMPuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:50:40 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:59557 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbfLMPue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:50:34 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 38B1B1BF209;
        Fri, 13 Dec 2019 15:50:31 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v3 06/15] net: macsec: add nla support for changing the offloading selection
Date:   Fri, 13 Dec 2019 16:48:35 +0100
Message-Id: <20191213154844.635389-7-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213154844.635389-1-antoine.tenart@bootlin.com>
References: <20191213154844.635389-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MACsec offloading to underlying hardware devices is disabled by default
(the software implementation is used). This patch adds support for
changing this setting through the MACsec netlink interface. Many checks
are done when enabling offloading on a given MACsec interface as there
are limitations (it must be supported by the hardware, only a single
interface can be offloaded on a given physical device at a time, rules
can't be moved for now).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c           | 147 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/if_macsec.h |  11 +++
 2 files changed, 155 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c785fd9cc0f3..abe7a0599367 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1483,6 +1483,7 @@ static const struct nla_policy macsec_genl_policy[NUM_MACSEC_ATTR] = {
 	[MACSEC_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[MACSEC_ATTR_RXSC_CONFIG] = { .type = NLA_NESTED },
 	[MACSEC_ATTR_SA_CONFIG] = { .type = NLA_NESTED },
+	[MACSEC_ATTR_OFFLOAD] = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy macsec_genl_rxsc_policy[NUM_MACSEC_RXSC_ATTR] = {
@@ -1500,6 +1501,10 @@ static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 				 .len = MACSEC_MAX_KEY_LEN, },
 };
 
+static const struct nla_policy macsec_genl_offload_policy[NUM_MACSEC_OFFLOAD_ATTR] = {
+	[MACSEC_OFFLOAD_ATTR_TYPE] = { .type = NLA_U8 },
+};
+
 /* Offloads an operation to a device driver */
 static int macsec_offload(int (* const func)(struct macsec_context *),
 			  struct macsec_context *ctx)
@@ -2328,6 +2333,128 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+static bool macsec_is_configured(struct macsec_dev *macsec)
+{
+	struct macsec_secy *secy = &macsec->secy;
+	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+	int i;
+
+	if (secy->n_rx_sc > 0)
+		return true;
+
+	for (i = 0; i < MACSEC_NUM_AN; i++)
+		if (tx_sc->sa[i])
+			return true;
+
+	return false;
+}
+
+static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
+	enum macsec_offload offload, prev_offload;
+	int (*func)(struct macsec_context *ctx);
+	struct nlattr **attrs = info->attrs;
+	struct net_device *dev, *loop_dev;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	struct macsec_dev *macsec;
+	struct net *loop_net;
+	int ret;
+
+	if (!attrs[MACSEC_ATTR_IFINDEX])
+		return -EINVAL;
+
+	if (!attrs[MACSEC_ATTR_OFFLOAD])
+		return -EINVAL;
+
+	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
+					attrs[MACSEC_ATTR_OFFLOAD],
+					macsec_genl_offload_policy, NULL))
+		return -EINVAL;
+
+	dev = get_dev_from_nl(genl_info_net(info), attrs);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+	macsec = macsec_priv(dev);
+
+	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
+	if (macsec->offload == offload)
+		return 0;
+
+	/* Check if the offloading mode is supported by the underlying layers */
+	if (offload != MACSEC_OFFLOAD_OFF &&
+	    !macsec_check_offload(offload, macsec))
+		return -EOPNOTSUPP;
+
+	if (offload == MACSEC_OFFLOAD_OFF)
+		goto skip_limitation;
+
+	/* Check the physical interface isn't offloading another interface
+	 * first.
+	 */
+	for_each_net(loop_net) {
+		for_each_netdev(loop_net, loop_dev) {
+			struct macsec_dev *priv;
+
+			if (!netif_is_macsec(loop_dev))
+				continue;
+
+			priv = macsec_priv(loop_dev);
+
+			if (!macsec_check_offload(MACSEC_OFFLOAD_PHY, priv))
+				continue;
+
+			if (priv->offload != MACSEC_OFFLOAD_OFF)
+				return -EBUSY;
+		}
+	}
+
+skip_limitation:
+	/* Check if the net device is busy. */
+	if (netif_running(dev))
+		return -EBUSY;
+
+	rtnl_lock();
+
+	prev_offload = macsec->offload;
+	macsec->offload = offload;
+
+	/* Check if the device already has rules configured: we do not support
+	 * rules migration.
+	 */
+	if (macsec_is_configured(macsec)) {
+		ret = -EBUSY;
+		goto rollback;
+	}
+
+	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
+			       macsec, &ctx);
+	if (!ops) {
+		ret = -EOPNOTSUPP;
+		goto rollback;
+	}
+
+	if (prev_offload == MACSEC_OFFLOAD_OFF)
+		func = ops->mdo_add_secy;
+	else
+		func = ops->mdo_del_secy;
+
+	ctx.secy = &macsec->secy;
+	ret = macsec_offload(func, &ctx);
+	if (ret)
+		goto rollback;
+
+	rtnl_unlock();
+	return 0;
+
+rollback:
+	macsec->offload = prev_offload;
+
+	rtnl_unlock();
+	return ret;
+}
+
 static int copy_tx_sa_stats(struct sk_buff *skb,
 			    struct macsec_tx_sa_stats __percpu *pstats)
 {
@@ -2589,12 +2716,13 @@ static noinline_for_stack int
 dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	  struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct macsec_rx_sc *rx_sc;
+	struct macsec_dev *macsec = netdev_priv(dev);
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	struct nlattr *txsa_list, *rxsc_list;
-	int i, j;
-	void *hdr;
+	struct macsec_rx_sc *rx_sc;
 	struct nlattr *attr;
+	void *hdr;
+	int i, j;
 
 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &macsec_fam, NLM_F_MULTI, MACSEC_CMD_GET_TXSC);
@@ -2606,6 +2734,13 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	if (nla_put_u32(skb, MACSEC_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
+	attr = nla_nest_start_noflag(skb, MACSEC_ATTR_OFFLOAD);
+	if (!attr)
+		goto nla_put_failure;
+	if (nla_put_u8(skb, MACSEC_OFFLOAD_ATTR_TYPE, macsec->offload))
+		goto nla_put_failure;
+	nla_nest_end(skb, attr);
+
 	if (nla_put_secy(secy, skb))
 		goto nla_put_failure;
 
@@ -2871,6 +3006,12 @@ static const struct genl_ops macsec_genl_ops[] = {
 		.doit = macsec_upd_rxsa,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = MACSEC_CMD_UPD_OFFLOAD,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = macsec_upd_offload,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family macsec_fam __ro_after_init = {
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 573208cac210..1ca5278aafb7 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -44,6 +44,7 @@ enum macsec_attrs {
 	MACSEC_ATTR_RXSC_LIST,   /* dump, nested, macsec_rxsc_attrs for each RXSC */
 	MACSEC_ATTR_TXSC_STATS,  /* dump, nested, macsec_txsc_stats_attr */
 	MACSEC_ATTR_SECY_STATS,  /* dump, nested, macsec_secy_stats_attr */
+	MACSEC_ATTR_OFFLOAD,     /* config, nested, macsec_offload_attrs */
 	__MACSEC_ATTR_END,
 	NUM_MACSEC_ATTR = __MACSEC_ATTR_END,
 	MACSEC_ATTR_MAX = __MACSEC_ATTR_END - 1,
@@ -96,6 +97,15 @@ enum macsec_sa_attrs {
 	MACSEC_SA_ATTR_MAX = __MACSEC_SA_ATTR_END - 1,
 };
 
+enum macsec_offload_attrs {
+	MACSEC_OFFLOAD_ATTR_UNSPEC,
+	MACSEC_OFFLOAD_ATTR_TYPE, /* config/dump, u8 0..2 */
+	MACSEC_OFFLOAD_ATTR_PAD,
+	__MACSEC_OFFLOAD_ATTR_END,
+	NUM_MACSEC_OFFLOAD_ATTR = __MACSEC_OFFLOAD_ATTR_END,
+	MACSEC_OFFLOAD_ATTR_MAX = __MACSEC_OFFLOAD_ATTR_END - 1,
+};
+
 enum macsec_nl_commands {
 	MACSEC_CMD_GET_TXSC,
 	MACSEC_CMD_ADD_RXSC,
@@ -107,6 +117,7 @@ enum macsec_nl_commands {
 	MACSEC_CMD_ADD_RXSA,
 	MACSEC_CMD_DEL_RXSA,
 	MACSEC_CMD_UPD_RXSA,
+	MACSEC_CMD_UPD_OFFLOAD,
 };
 
 /* u64 per-RXSC stats */
-- 
2.23.0

