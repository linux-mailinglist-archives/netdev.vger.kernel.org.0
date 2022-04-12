Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4577D4FDEA1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiDLLuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353442AbiDLLs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:48:27 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E590233EB9;
        Tue, 12 Apr 2022 03:29:44 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23CATZ01019240;
        Tue, 12 Apr 2022 05:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649759375;
        bh=cDQw28jY1z3IoFU4yKajatPVQXHOuXMwLuD2t4PLUIE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Tol9BeDYSZotvcFtWXkizTKBdqG1OzQZQnjKp4gZvPY9bZvyCw8+w8Dmv2+BpE7fP
         nBaGZYzleZbvv92gtTyFP/W7QDjRyi8knt5aKKvlry4WzrwekPYmIRTN7cHzBmPzp4
         g2qQELhP3w+ItWQRy2RTQqt+dixpY3pLc0jIqk9Y=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23CATZhP018366
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 05:29:35 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 05:29:34 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 05:29:34 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23CATYZA006808;
        Tue, 12 Apr 2022 05:29:34 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v3 3/3] net: ethernet: ti: cpsw_new: enable bc/mc storm prevention support
Date:   Tue, 12 Apr 2022 13:29:29 +0300
Message-ID: <20220412102929.30719-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220412102929.30719-1-grygorii.strashko@ti.com>
References: <20220412102929.30719-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables support for ingress broadcast(BC)/multicast(MC) packets
rate limiting in TI CPSW switchdev driver (the corresponding ALE support
was added in previous patch) by implementing HW offload for simple
tc-flower with policer action with matches on dst_mac:
 - ff:ff:ff:ff:ff:ff/ff:ff:ff:ff:ff:ff has to be used for BC packets rate
limiting (exact match)
 - 01:00:00:00:00:00/01:00:00:00:00:00 fixed value has to be used for MC
packets rate limiting

The CPSW supports MC/BC packets rate limiting in packets/sec and affects
all ingress MC/BC packets and serves as BC/MC storm prevention feature.

Examples:
- BC rate limit to 1000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
  action police pkts_rate 1000 pkts_burst 1 drop

- MC rate limit to 20000pps:
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 \
  action police rate pkts_rate 10000 pkts_burst 1 drop

  pkts_burst - not used.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_new.c  |   4 +-
 drivers/net/ethernet/ti/cpsw_priv.c | 205 ++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h |   8 ++
 3 files changed, 216 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 394145d06d54..dfa0a9cf9d89 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -498,6 +498,8 @@ static void cpsw_restore(struct cpsw_priv *priv)
 
 	/* restore CBS offload */
 	cpsw_cbs_resume(&cpsw->slaves[priv->emac_port - 1], priv);
+
+	cpsw_qos_clsflower_resume(priv);
 }
 
 static void cpsw_init_stp_ale_entry(struct cpsw_common *cpsw)
@@ -1407,7 +1409,7 @@ static int cpsw_create_ports(struct cpsw_common *cpsw)
 		cpsw->slaves[i].ndev = ndev;
 
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL;
+				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
 
 		ndev->netdev_ops = &cpsw_netdev_ops;
 		ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 8f6817f346ba..4dbd327c6a4d 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -502,6 +502,7 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 	ale_params.ale_ageout		= ale_ageout;
 	ale_params.ale_ports		= CPSW_ALE_PORTS_NUM;
 	ale_params.dev_id		= "cpsw";
+	ale_params.bus_freq		= cpsw->bus_freq_mhz * 1000000;
 
 	cpsw->ale = cpsw_ale_create(&ale_params);
 	if (IS_ERR(cpsw->ale)) {
@@ -1048,6 +1049,8 @@ static int cpsw_set_mqprio(struct net_device *ndev, void *type_data)
 	return 0;
 }
 
+static int cpsw_qos_setup_tc_block(struct net_device *ndev, struct flow_block_offload *f);
+
 int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		      void *type_data)
 {
@@ -1058,6 +1061,9 @@ int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return cpsw_set_mqprio(ndev, type_data);
 
+	case TC_SETUP_BLOCK:
+		return cpsw_qos_setup_tc_block(ndev, type_data);
+
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1381,3 +1387,202 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 	page_pool_recycle_direct(cpsw->page_pool[ch], page);
 	return ret;
 }
+
+static int cpsw_qos_clsflower_add_policer(struct cpsw_priv *priv,
+					  struct netlink_ext_ack *extack,
+					  struct flow_cls_offload *cls,
+					  u64 rate_pkt_ps)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	static const u8 mc_mac[] = {0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct flow_match_eth_addrs match;
+	u32 port_id;
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
+	if (!is_zero_ether_addr(match.mask->src)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on source MAC not supported");
+		return -EOPNOTSUPP;
+	}
+
+	port_id = cpsw_slave_index(priv->cpsw, priv) + 1;
+
+	if (is_broadcast_ether_addr(match.key->dst) &&
+	    is_broadcast_ether_addr(match.mask->dst)) {
+		ret = cpsw_ale_rx_ratelimit_bc(priv->cpsw->ale, port_id, rate_pkt_ps);
+		if (ret)
+			return ret;
+
+		priv->ale_bc_ratelimit.cookie = cls->cookie;
+		priv->ale_bc_ratelimit.rate_packet_ps = rate_pkt_ps;
+	} else if (ether_addr_equal_unaligned(match.key->dst, mc_mac) &&
+		   ether_addr_equal_unaligned(match.mask->dst, mc_mac)) {
+		ret = cpsw_ale_rx_ratelimit_mc(priv->cpsw->ale, port_id, rate_pkt_ps);
+		if (ret)
+			return ret;
+
+		priv->ale_mc_ratelimit.cookie = cls->cookie;
+		priv->ale_mc_ratelimit.rate_packet_ps = rate_pkt_ps;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Not supported matching key");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int cpsw_qos_clsflower_policer_validate(const struct flow_action *action,
+					       const struct flow_action_entry *act,
+					       struct netlink_ext_ack *extack)
+{
+	if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when exceed action is not drop");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is not pipe or ok");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+	    !flow_action_is_last_entry(action, act)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is ok, but action is not last");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_bytes_ps || act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when bytes per second/peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
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
+	int i, ret;
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_POLICE:
+			ret = cpsw_qos_clsflower_policer_validate(&rule->action, act, extack);
+			if (ret)
+				return ret;
+
+			return cpsw_qos_clsflower_add_policer(priv, extack, cls,
+							      act->police.rate_pkt_ps);
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
index 86a0a1a093b5..fc591f5ebe18 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -364,6 +364,11 @@ struct cpsw_common {
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
@@ -384,6 +389,8 @@ struct cpsw_priv {
 	struct cpsw_common *cpsw;
 	int offload_fwd_mark;
 	u32 tx_packet_min;
+	struct cpsw_ale_ratelimit ale_bc_ratelimit;
+	struct cpsw_ale_ratelimit ale_mc_ratelimit;
 };
 
 #define ndev_to_cpsw(ndev) (((struct cpsw_priv *)netdev_priv(ndev))->cpsw)
@@ -461,6 +468,7 @@ int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 bool cpsw_shp_is_off(struct cpsw_priv *priv);
 void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
 void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
+void cpsw_qos_clsflower_resume(struct cpsw_priv *priv);
 
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
-- 
2.17.1

