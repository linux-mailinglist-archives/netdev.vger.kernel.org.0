Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E634FDE78
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344225AbiDLLu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353391AbiDLLs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:48:26 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A353618B18;
        Tue, 12 Apr 2022 03:29:42 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 23CATYB7108170;
        Tue, 12 Apr 2022 05:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649759374;
        bh=Ie1CjRD+pt23VZcOFMX0xR+Q4I0rfY1AoMsBHpHp70U=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ZYozED5nXyWgW1b/Hei7GcBtstgLiGJBBu+ghvVSGQOcUF1xpmBDzz/nkz5UWUpjK
         oxZ6e+y8MaM5Y+RviL1wxu1kbM/HbiTKJkrlYFB11q9R6QhXr4ieWLwMpLaVoLo/KA
         2pCzTRTjcWXtnHTLedcHFxo3TBfPAUMXZrg4XwS8=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 23CATYoI103449
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 Apr 2022 05:29:34 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 12
 Apr 2022 05:29:33 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 12 Apr 2022 05:29:33 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 23CATWPP005040;
        Tue, 12 Apr 2022 05:29:32 -0500
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
Subject: [PATCH net-next v3 2/3] net: ethernet: ti: am65-cpsw: enable bc/mc storm prevention support
Date:   Tue, 12 Apr 2022 13:29:28 +0300
Message-ID: <20220412102929.30719-3-grygorii.strashko@ti.com>
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
rate limiting in TI AM65x CPSW driver (the corresponding ALE support was
added in previous patch) by implementing HW offload for simple tc-flower
with policer action with matches on dst_mac/mask:
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
  action police rate pkts_rate 20000 pkts_burst 1 drop

  pkts_burst - not used.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 180 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
 2 files changed, 188 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index ebcc6386cc34..aa32dd905e2b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -8,10 +8,12 @@
 
 #include <linux/pm_runtime.h>
 #include <linux/time.h>
+#include <net/pkt_cls.h>
 
 #include "am65-cpsw-nuss.h"
 #include "am65-cpsw-qos.h"
 #include "am65-cpts.h"
+#include "cpsw_ale.h"
 
 #define AM65_CPSW_REG_CTL			0x004
 #define AM65_CPSW_PN_REG_CTL			0x004
@@ -588,12 +590,190 @@ static int am65_cpsw_setup_taprio(struct net_device *ndev, void *type_data)
 	return am65_cpsw_set_taprio(ndev, type_data);
 }
 
+static int am65_cpsw_qos_clsflower_add_policer(struct am65_cpsw_port *port,
+					       struct netlink_ext_ack *extack,
+					       struct flow_cls_offload *cls,
+					       u64 rate_pkt_ps)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	static const u8 mc_mac[] = {0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct am65_cpsw_qos *qos = &port->qos;
+	struct flow_match_eth_addrs match;
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
+	if (is_broadcast_ether_addr(match.key->dst) &&
+	    is_broadcast_ether_addr(match.mask->dst)) {
+		ret = cpsw_ale_rx_ratelimit_bc(port->common->ale, port->port_id, rate_pkt_ps);
+		if (ret)
+			return ret;
+
+		qos->ale_bc_ratelimit.cookie = cls->cookie;
+		qos->ale_bc_ratelimit.rate_packet_ps = rate_pkt_ps;
+	} else if (ether_addr_equal_unaligned(match.key->dst, mc_mac) &&
+		   ether_addr_equal_unaligned(match.mask->dst, mc_mac)) {
+		ret = cpsw_ale_rx_ratelimit_mc(port->common->ale, port->port_id, rate_pkt_ps);
+		if (ret)
+			return ret;
+
+		qos->ale_mc_ratelimit.cookie = cls->cookie;
+		qos->ale_mc_ratelimit.rate_packet_ps = rate_pkt_ps;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Not supported matching key");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int am65_cpsw_qos_clsflower_policer_validate(const struct flow_action *action,
+						    const struct flow_action_entry *act,
+						    struct netlink_ext_ack *extack)
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
+static int am65_cpsw_qos_configure_clsflower(struct am65_cpsw_port *port,
+					     struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	const struct flow_action_entry *act;
+	int i, ret;
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_POLICE:
+			ret = am65_cpsw_qos_clsflower_policer_validate(&rule->action, act, extack);
+			if (ret)
+				return ret;
+
+			return am65_cpsw_qos_clsflower_add_policer(port, extack, cls,
+								   act->police.rate_pkt_ps);
+		default:
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Action not supported");
+			return -EOPNOTSUPP;
+		}
+	}
+	return -EOPNOTSUPP;
+}
+
+static int am65_cpsw_qos_delete_clsflower(struct am65_cpsw_port *port, struct flow_cls_offload *cls)
+{
+	struct am65_cpsw_qos *qos = &port->qos;
+
+	if (cls->cookie == qos->ale_bc_ratelimit.cookie) {
+		qos->ale_bc_ratelimit.cookie = 0;
+		qos->ale_bc_ratelimit.rate_packet_ps = 0;
+		cpsw_ale_rx_ratelimit_bc(port->common->ale, port->port_id, 0);
+	}
+
+	if (cls->cookie == qos->ale_mc_ratelimit.cookie) {
+		qos->ale_mc_ratelimit.cookie = 0;
+		qos->ale_mc_ratelimit.rate_packet_ps = 0;
+		cpsw_ale_rx_ratelimit_mc(port->common->ale, port->port_id, 0);
+	}
+
+	return 0;
+}
+
+static int am65_cpsw_qos_setup_tc_clsflower(struct am65_cpsw_port *port,
+					    struct flow_cls_offload *cls_flower)
+{
+	switch (cls_flower->command) {
+	case FLOW_CLS_REPLACE:
+		return am65_cpsw_qos_configure_clsflower(port, cls_flower);
+	case FLOW_CLS_DESTROY:
+		return am65_cpsw_qos_delete_clsflower(port, cls_flower);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int am65_cpsw_qos_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct am65_cpsw_port *port = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(port->ndev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return am65_cpsw_qos_setup_tc_clsflower(port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(am65_cpsw_qos_block_cb_list);
+
+static int am65_cpsw_qos_setup_tc_block(struct net_device *ndev, struct flow_block_offload *f)
+{
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+
+	return flow_block_cb_setup_simple(f, &am65_cpsw_qos_block_cb_list,
+					  am65_cpsw_qos_setup_tc_block_cb,
+					  port, port, true);
+}
+
 int am65_cpsw_qos_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			       void *type_data)
 {
 	switch (type) {
 	case TC_SETUP_QDISC_TAPRIO:
 		return am65_cpsw_setup_taprio(ndev, type_data);
+	case TC_SETUP_BLOCK:
+		return am65_cpsw_qos_setup_tc_block(ndev, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.h b/drivers/net/ethernet/ti/am65-cpsw-qos.h
index e8f1b6b59e93..fb223b43b196 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.h
@@ -14,11 +14,19 @@ struct am65_cpsw_est {
 	struct tc_taprio_qopt_offload taprio;
 };
 
+struct am65_cpsw_ale_ratelimit {
+	unsigned long cookie;
+	u64 rate_packet_ps;
+};
+
 struct am65_cpsw_qos {
 	struct am65_cpsw_est *est_admin;
 	struct am65_cpsw_est *est_oper;
 	ktime_t link_down_time;
 	int link_speed;
+
+	struct am65_cpsw_ale_ratelimit ale_bc_ratelimit;
+	struct am65_cpsw_ale_ratelimit ale_mc_ratelimit;
 };
 
 int am65_cpsw_qos_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-- 
2.17.1

