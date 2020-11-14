Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111AE2B2B34
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgKND5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:57:30 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60890 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKND5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:57:30 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AE3vOnB082156;
        Fri, 13 Nov 2020 21:57:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605326244;
        bh=UO2P5xbkCzzoN+M+GF4SPr9P3F3tL6TtRDKGqHjfOT8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=MdDLjzCnqiZrtRVbhEGdiz+afzTKSvK0RjoNhFI4JDUkkBJrTUDevDH/AnljEst7j
         f3dns4iimqxUvrviQZ3ps+4d8PMpwfOEbWl7Gqk2hhpioowzZuo23mC9i8Hv2s7Hjl
         TRWjTdtCjxByEGYBF/R5CKFXWY+7L7nKGk7rpaKs=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AE3vOSX039599
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 21:57:24 -0600
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 13
 Nov 2020 21:57:24 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 13 Nov 2020 21:57:24 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AE3vNMU006219;
        Fri, 13 Nov 2020 21:57:23 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 3/3] net: ethernet: ti: am65-cpsw: enable broadcast/multicast rate limit support
Date:   Sat, 14 Nov 2020 05:56:54 +0200
Message-ID: <20201114035654.32658-4-grygorii.strashko@ti.com>
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
in TI AM65x CPSW driver (the corresponding ALE support was added in previous
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
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 148 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/am65-cpsw-qos.h |   8 ++
 2 files changed, 156 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index 3bdd4dbcd2ff..a06207233cd5 100644
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
@@ -588,12 +590,158 @@ static int am65_cpsw_setup_taprio(struct net_device *ndev, void *type_data)
 	return am65_cpsw_set_taprio(ndev, type_data);
 }
 
+static int am65_cpsw_qos_clsflower_add_policer(struct am65_cpsw_port *port,
+					       struct netlink_ext_ack *extack,
+					       struct flow_cls_offload *cls,
+					       u64 rate_bytes_ps)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	u8 null_mac[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	u8 mc_mac[] = {0x01, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct am65_cpsw_qos *qos = &port->qos;
+	struct flow_match_eth_addrs match;
+	u32 pps;
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
+	/* Calculate number of packets per second for given bps
+	 * assuming min ethernet packet size
+	 */
+	pps = div_u64(rate_bytes_ps, ETH_ZLEN);
+
+	if (ether_addr_equal(match.key->dst, bc_mac)) {
+		ret = cpsw_ale_rx_ratelimit_bc(port->common->ale, port->port_id, pps);
+		if (ret)
+			return ret;
+
+		qos->ale_bc_ratelimit.cookie = cls->cookie;
+		qos->ale_bc_ratelimit.rate_packet_ps = pps;
+	}
+
+	if (ether_addr_equal(match.key->dst, mc_mac)) {
+		ret = cpsw_ale_rx_ratelimit_mc(port->common->ale, port->port_id, pps);
+		if (ret)
+			return ret;
+
+		qos->ale_mc_ratelimit.cookie = cls->cookie;
+		qos->ale_mc_ratelimit.rate_packet_ps = pps;
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
+	int i;
+
+	flow_action_for_each(i, act, &rule->action) {
+		switch (act->id) {
+		case FLOW_ACTION_POLICE:
+			return am65_cpsw_qos_clsflower_add_policer(port, extack, cls,
+							 act->police.rate_bytes_ps);
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

