Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61522B2B31
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgKND5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:57:22 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60882 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKND5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:57:22 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AE3vHhM082146;
        Fri, 13 Nov 2020 21:57:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605326237;
        bh=YIoeUjMHUfK1QMBaMAxMhu/OAVLNRicyoJVOSDycZ84=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=X8UsPuY7ELbHRdjA2ZhV0pEl9NOY33Cdl9SsIe7bg1m+OoRlG1CF6bBETkHP5Xd0w
         Wji5TyTctyLhh4zzgAfN1tvtFz0aBVo8zyhLAZor8NRNfnajAfV9vWdM/2HD+I4kNz
         5CSFgZ+58NKuOJBrwtA6fMWmR5klgkyGR08PkBdE=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AE3vHTX127964
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 21:57:17 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 13
 Nov 2020 21:57:17 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 13 Nov 2020 21:57:17 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AE3vGjY015234;
        Fri, 13 Nov 2020 21:57:16 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 2/3] net: ethernet: ti: cpsw_new: enable broadcast/multicast rate limit support
Date:   Sat, 14 Nov 2020 05:56:53 +0200
Message-ID: <20201114035654.32658-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201114035654.32658-1-grygorii.strashko@ti.com>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables support for ingress broadcast(BC)/multicast(MC) rate limiting
in TI CPSW switchdev driver (the corresponding ALE support was added in previous
patch) by implementing HW offload for simple tc-flower policer with matches
on dst_mac:
 - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
 - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting

Hence tc policer defines rate limit in terms of bits per second, but the
ALE supports limiting in terms of packets per second - the rate limit
bits/sec is converted to number of packets per second assuming minimum
Ethernet packet size ETH_ZLEN=60 bytes.

Examples:
- BC rate limit to 1000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
  action police rate 480kbit burst 64k

  rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.

- MC rate limit to 20000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
  action police rate 9600kbit burst 64k

  rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_new.c  |   4 +-
 drivers/net/ethernet/ti/cpsw_priv.c | 171 ++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h |   8 ++
 3 files changed, 182 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 2f5e0ad23ad7..6fad5a5461f6 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -505,6 +505,8 @@ static void cpsw_restore(struct cpsw_priv *priv)
 
 	/* restore CBS offload */
 	cpsw_cbs_resume(&cpsw->slaves[priv->emac_port - 1], priv);
+
+	cpsw_qos_clsflower_resume(priv);
 }
 
 static void cpsw_init_stp_ale_entry(struct cpsw_common *cpsw)
@@ -1418,7 +1420,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		cpsw->slaves[i].ndev = ndev;
 
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL;
+				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
 
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 31c5e36ff706..0908d476b854 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -502,6 +502,7 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 	ale_params.ale_ageout		= ale_ageout;
 	ale_params.ale_ports		= CPSW_ALE_PORTS_NUM;
 	ale_params.dev_id		= "cpsw";
+	ale_params.bus_freq		= cpsw->bus_freq_mhz * 1000000;
 
 	cpsw->ale = cpsw_ale_create(&ale_params);
 	if (IS_ERR(cpsw->ale)) {
@@ -1046,6 +1047,8 @@ static int cpsw_set_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
+static int cpsw_qos_setup_tc_block(struct net_device *ndev, struct flow_block_offload *f);
+
 int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		      void *type_data)
 {
@@ -1056,6 +1059,9 @@ int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return cpsw_set_mqprio(ndev, type_data);
 
+	case TC_SETUP_BLOCK:
+		return cpsw_qos_setup_tc_block(ndev, type_data);
+
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1383,3 +1389,168 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 	page_pool_recycle_direct(cpsw->page_pool[ch], page);
 	return ret;
 }
+
+static int cpsw_qos_clsflower_add_policer(struct cpsw_priv *priv,
+					  struct netlink_ext_ack *extack,
+					  struct flow_cls_offload *cls,
+					  u64 rate_bytes_ps)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	u8 null_mac[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	u8 mc_mac[] = {0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct flow_match_eth_addrs match;
+	u32 pps, port_id;
+	int ret;
+
+	if (dissector->used_keys &
+	    ~(BIT(FLOW_DISSECTOR_KEY_BASIC) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS))) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Unsupported keys used");
+		return -EOPNOTSUPP;
+	}
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
+		NL_SET_ERR_MSG_MOD(extack, "Not matching on eth address");
+		return -EOPNOTSUPP;
+	}
+
+	flow_rule_match_eth_addrs(rule, &match);
+
+	if (!ether_addr_equal_masked(match.key->src, null_mac,
+				     match.mask->src)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on source MAC not supported");
+		return -EOPNOTSUPP;
+	}
+
+	port_id = cpsw_slave_index(priv->cpsw, priv) + 1;
+	/* Calculate number of packets per second for given bps
+	 * assuming min ethernet packet size
+	 */
+	pps = div_u64(rate_bytes_ps, ETH_ZLEN);
+
+	if (ether_addr_equal(match.key->dst, bc_mac)) {
+		ret = cpsw_ale_rx_ratelimit_bc(priv->cpsw->ale, port_id, pps);
+		if (ret)
+			return ret;
+
+		priv->ale_bc_ratelimit.cookie = cls->cookie;
+		priv->ale_bc_ratelimit.rate_packet_ps = pps;
+	}
+
+	if (ether_addr_equal(match.key->dst, mc_mac)) {
+		ret = cpsw_ale_rx_ratelimit_mc(priv->cpsw->ale, port_id, pps);
+		if (ret)
+			return ret;
+
+		priv->ale_mc_ratelimit.cookie = cls->cookie;
+		priv->ale_mc_ratelimit.rate_packet_ps = pps;
+	}
+
+	return 0;
+}
+
+static int cpsw_qos_configure_clsflower(struct cpsw_priv *priv, struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	const struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_POLICE:
+			return cpsw_qos_clsflower_add_policer(priv, extack, cls,
+							      act->police.rate_bytes_ps);
+		default:
+			NL_SET_ERR_MSG_MOD(extack, "Action not supported");
+			return -EOPNOTSUPP;
+		}
+	}
+	return -EOPNOTSUPP;
+}
+
+static int cpsw_qos_delete_clsflower(struct cpsw_priv *priv, struct flow_cls_offload *cls)
+{
+	u32 port_id = cpsw_slave_index(priv->cpsw, priv) + 1;
+
+	if (cls->cookie == priv->ale_bc_ratelimit.cookie) {
+		priv->ale_bc_ratelimit.cookie = 0;
+		priv->ale_bc_ratelimit.rate_packet_ps = 0;
+		cpsw_ale_rx_ratelimit_bc(priv->cpsw->ale, port_id, 0);
+	}
+
+	if (cls->cookie == priv->ale_mc_ratelimit.cookie) {
+		priv->ale_mc_ratelimit.cookie = 0;
+		priv->ale_mc_ratelimit.rate_packet_ps = 0;
+		cpsw_ale_rx_ratelimit_mc(priv->cpsw->ale, port_id, 0);
+	}
+
+	return 0;
+}
+
+static int cpsw_qos_setup_tc_clsflower(struct cpsw_priv *priv, struct flow_cls_offload *cls_flower)
+{
+	switch (cls_flower->command) {
+	case FLOW_CLS_REPLACE:
+		return cpsw_qos_configure_clsflower(priv, cls_flower);
+	case FLOW_CLS_DESTROY:
+		return cpsw_qos_delete_clsflower(priv, cls_flower);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int cpsw_qos_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct cpsw_priv *priv = cb_priv;
+	int ret;
+
+	if (!tc_cls_can_offload_and_chain0(priv->ndev, type_data))
+		return -EOPNOTSUPP;
+
+	ret = pm_runtime_get_sync(priv->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->dev);
+		return ret;
+	}
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		ret = cpsw_qos_setup_tc_clsflower(priv, type_data);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	pm_runtime_put(priv->dev);
+	return ret;
+}
+
+static LIST_HEAD(cpsw_qos_block_cb_list);
+
+static int cpsw_qos_setup_tc_block(struct net_device *ndev, struct flow_block_offload *f)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+
+	return flow_block_cb_setup_simple(f, &cpsw_qos_block_cb_list,
+					  cpsw_qos_setup_tc_block_cb,
+					  priv, priv, true);
+}
+
+void cpsw_qos_clsflower_resume(struct cpsw_priv *priv)
+{
+	u32 port_id = cpsw_slave_index(priv->cpsw, priv) + 1;
+
+	if (priv->ale_bc_ratelimit.cookie)
+		cpsw_ale_rx_ratelimit_bc(priv->cpsw->ale, port_id,
+					 priv->ale_bc_ratelimit.rate_packet_ps);
+
+	if (priv->ale_mc_ratelimit.cookie)
+		cpsw_ale_rx_ratelimit_mc(priv->cpsw->ale, port_id,
+					 priv->ale_mc_ratelimit.rate_packet_ps);
+}
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 7b7f3596b20d..9e2fac0873c9 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -361,6 +361,11 @@ struct cpsw_common {
 	u8 base_mac[ETH_ALEN];
 };
 
+struct cpsw_ale_ratelimit {
+	unsigned long cookie;
+	u64 rate_packet_ps;
+};
+
 struct cpsw_priv {
 	struct net_device		*ndev;
 	struct device			*dev;
@@ -380,6 +385,8 @@ struct cpsw_priv {
 	u32 emac_port;
 	struct cpsw_common *cpsw;
 	int offload_fwd_mark;
+	struct cpsw_ale_ratelimit ale_bc_ratelimit;
+	struct cpsw_ale_ratelimit ale_mc_ratelimit;
 };
 
 #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)
@@ -458,6 +465,7 @@ int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 bool cpsw_shp_is_off(struct cpsw_priv *priv);
 void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
 void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
+void cpsw_qos_clsflower_resume(struct cpsw_priv *priv);
 
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
-- 
2.17.1

