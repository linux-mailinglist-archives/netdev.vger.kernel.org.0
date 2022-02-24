Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256E14C2965
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiBXKaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbiBXKaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:30:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEE4208317;
        Thu, 24 Feb 2022 02:29:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyCEUkps0YcX0W3Z3RcWj33d0aDcnQ+Psg23jnzFOvfyi4Yt81vZXt5JIaEXiDV6fC/0r6AuWjRI/62DCoq8majRXoJ29zByTggtPdTpCqaOwG/EhY6d0IaKuzWe8QDQFoBDx98fJGy9VvfI5dAbvblaYvKHq6Ab8mKKtv9fTTfFFum1U0aF973c7D4E435ZpdFCqvYiklEFV3mU56xsTXXX0P0Qfuw21XK7igEekcm0HnbrOXSh004WYE5lVB+d/j34VVzcgRq0ftoycR3Sri07eweOWp3yVFMFfNeRmgbc3qULzkB0YXbslELGgdjUmOrTGdppIVGW2E7aj2+vWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sG4sMU+f25ko6uxOEJjSbo0JnXZk9jB0T28nQTkAUo=;
 b=mFhQcw2bI4wLv3xVqhEFhv+b3q1lD2aLcZVQa8Tp6JpT57OqP8TZp7NyK8ppJOykrsbaYrkEJxNx1f70KNSnmU3ccTnf8ngp7WHIvZAcg9h4cf/uYyLcZ5K6RopReFIoPFWiQhXMXuShz2REy9YYDpVA6S0l13Ru/TtcZG+RPBPO0F0JFY5jeLNLMuOjmDDGoUJjt6lixGt/M8H2PY77OIPpeOrCqBDbXmxniu/RDkG+ltZdrl+2haGG2PgNHn2hNnehK5wDn75NrNVLInkSsOMC74nqoecOAVbSNPtEip0REG6/AgZiQD0aRObj9QjqesCiEEcqINWvH/7fhTd3Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sG4sMU+f25ko6uxOEJjSbo0JnXZk9jB0T28nQTkAUo=;
 b=MoQk0dzU6GQ92REp7Hw7/SyFO2xVKOIABM3c/J23JXeJ4l4QWj7XxEmiimvxKNM7dLGQnRe7HCW8wsVSypd3rC9ktOVS0MZA7thhAbrbTXPsCNNvBIRavDe0oQQs51YH+Ck56T2ZyTHaXa1paH6hAtWhmG/gZ3SPVzdtCqT+/0XEfB2M0EGFovgtpj2+Fz6nuj7zluw7ODXfrPqcaWGl6rt3GRtjHXzwOlEcPd0+y65C5bAdeJNJuKvhWZj6ETPMtsl41REycLIbfkgofmBS2nbOxUJ8u9pMmFcAoMqWoY5buCgIVBHD0TEIkAotPNNTCOjNfye5YLX2bMw/Q0cZbg==
Received: from DS7PR07CA0003.namprd07.prod.outlook.com (2603:10b6:5:3af::11)
 by MN2PR12MB4063.namprd12.prod.outlook.com (2603:10b6:208:1dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 10:29:34 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::d6) by DS7PR07CA0003.outlook.office365.com
 (2603:10b6:5:3af::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 10:29:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 10:29:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 10:29:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 02:29:33 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 02:29:26 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rajur@chelsio.com>, <claudiu.manoil@nxp.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <simon.horman@corigine.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <baowen.zheng@corigine.com>, <louis.peens@netronome.com>,
        <peng.zhang@corigine.com>, <oss-drivers@corigine.com>,
        <roid@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next v3 2/2] flow_offload: reject offload for all drivers with invalid police parameters
Date:   Thu, 24 Feb 2022 10:29:08 +0000
Message-ID: <20220224102908.5255-3-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220224102908.5255-1-jianbol@nvidia.com>
References: <20220224102908.5255-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccc2b240-6cdd-450b-af7c-08d9f7808d2f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4063:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4063A7ADC30D9DBE4C70E090C53D9@MN2PR12MB4063.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMCLY0ySn+bqzd/opXzLflec0HHRwpIeE4Zj7FSvdkqR+pznQG6JCU6U0OuQoipb5sO66fy5XZY2aJAWDebcWPZuYTatUTNVjeGnAPrQihtNzvM2h/y2+5+jGuRPSXBCjFud9MjCNYfLvOqTGspbSNVF1Abxt4lBUyu1SKFOPXBPHzpQIfXodT2WVp+iFqqhsc/4MKwDKBJ7hZrJcmfKWLuoJaAT7RvZT5hArfmvqc7qLBkSQ455swX805UFO4nTo1fobDMBdTRPzVbj/LMl3dDsDXh4ZYSN7mUm8ydmw6hj5THGFE/E/YEmU1qfyoCDkVH63W5X1DHxe8AZ1ZgmtGrkaB6u/xRIxtEo7cuW3ADtuQMjBvp3mR0BkPuezqm4HdRgoJAIzQgNb7BMx3iTz27AnH6Qtlm60MgGQ1v3xYuEf031VAwWG8oxC/jEqmWNW+9UCrfd/Fh6rpInhbkdZPXvnK2HDcQHwR1yCqZooEn9LO7KL+kQP5Ghr9Ezjh1iAv/RhopBrNSM4QtFwn7k2m98ubtnmYDpNeYE5/8iIek3PLihEAEKdoylrBlEWpKKw9T4IaAFTpOWgXSrYjQ2+GlyIZ5wQeor45Z/y8DHLxKs7gwI31mozLWDkuiS56DSefC/JcXidSP4rIu86rABrtttG4ctophTl6yDOeWIzmRsPCVbBjgRztJ8RUc/rAguasVsEiwp3OVrmUKIsjQLEw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(86362001)(508600001)(7696005)(8936002)(36756003)(81166007)(30864003)(5660300002)(426003)(336012)(2906002)(54906003)(110136005)(7416002)(83380400001)(107886003)(316002)(26005)(4326008)(70586007)(1076003)(8676002)(36860700001)(2616005)(186003)(82310400004)(356005)(6666004)(70206006)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 10:29:34.4973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc2b240-6cdd-450b-af7c-08d9f7808d2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4063
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As more police parameters are passed to flow_offload, driver can check
them to make sure hardware handles packets in the way indicated by tc.
The conform-exceed control should be drop/pipe or drop/ok. Besides,
for drop/ok, the police should be the last action. As hardware can't
configure peakrate/avrate/overhead, offload should not be supported if
any of them is configured.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c      | 47 +++++++++++++--
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 59 +++++++++++++++----
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 47 +++++++++++++--
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 43 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 48 +++++++++++++--
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 47 +++++++++++++--
 drivers/net/ethernet/mscc/ocelot_flower.c     | 14 +++--
 drivers/net/ethernet/mscc/ocelot_net.c        | 10 ++--
 drivers/net/ethernet/mscc/ocelot_police.c     | 41 +++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.h     |  5 ++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 40 +++++++++++++
 include/net/flow_offload.h                    |  6 ++
 12 files changed, 369 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 7dcdd784aea4..fad5afe3819c 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -300,6 +300,46 @@ static int sja1105_flower_parse_key(struct sja1105_private *priv,
 	return -EOPNOTSUPP;
 }
 
+static int sja1105_policer_validate(const struct flow_action *action,
+				    const struct flow_action_entry *act,
+				    struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			   struct flow_cls_offload *cls, bool ingress)
 {
@@ -321,12 +361,9 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
-			if (act->police.rate_pkt_ps) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "QoS offload not support packets per second");
-				rc = -EOPNOTSUPP;
+			rc = sja1105_policer_validate(&rule->action, act, extack);
+			if (rc)
 				goto out;
-			}
 
 			rc = sja1105_flower_policer(priv, port, extack, cookie,
 						    &key,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 28fd2de9e4cf..1672d3afe5be 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -8,6 +8,46 @@
 #include "cxgb4_filter.h"
 #include "cxgb4_tc_flower.h"
 
+static int cxgb4_policer_validate(const struct flow_action *action,
+				  const struct flow_action_entry *act,
+				  struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int cxgb4_matchall_egress_validate(struct net_device *dev,
 					  struct tc_cls_matchall_offload *cls)
 {
@@ -48,11 +88,10 @@ static int cxgb4_matchall_egress_validate(struct net_device *dev,
 	flow_action_for_each(i, entry, actions) {
 		switch (entry->id) {
 		case FLOW_ACTION_POLICE:
-			if (entry->police.rate_pkt_ps) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "QoS offload not support packets per second");
-				return -EOPNOTSUPP;
-			}
+			ret = cxgb4_policer_validate(actions, entry, extack);
+			if (ret)
+				return ret;
+
 			/* Convert bytes per second to bits per second */
 			if (entry->police.rate_bytes_ps * 8 > max_link_rate) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -150,11 +189,11 @@ static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 	flow_action_for_each(i, entry, &cls->rule->action)
 		if (entry->id == FLOW_ACTION_POLICE)
 			break;
-	if (entry->police.rate_pkt_ps) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "QoS offload not support packets per second");
-		return -EOPNOTSUPP;
-	}
+
+	ret = cxgb4_policer_validate(&cls->rule->action, entry, extack);
+	if (ret)
+		return ret;
+
 	/* Convert from bytes per second to Kbps */
 	p.u.params.maxrate = div_u64(entry->police.rate_bytes_ps * 8, 1000);
 	p.u.params.channel = pi->tx_chan;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 3555c12edb45..6782a76aeaf6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1074,6 +1074,46 @@ static struct actions_fwd *enetc_check_flow_actions(u64 acts,
 	return NULL;
 }
 
+static int enetc_psfp_policer_validate(const struct flow_action *action,
+				       const struct flow_action_entry *act,
+				       struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 				      struct flow_cls_offload *f)
 {
@@ -1230,11 +1270,10 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	/* Flow meter and max frame size */
 	if (entryp) {
-		if (entryp->police.rate_pkt_ps) {
-			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
-			err = -EOPNOTSUPP;
+		err = enetc_psfp_policer_validate(&rule->action, entryp, extack);
+		if (err)
 			goto free_sfi;
-		}
+
 		if (entryp->police.burst) {
 			fmi = kzalloc(sizeof(*fmi), GFP_KERNEL);
 			if (!fmi) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 626961a41089..8c90be81677d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -190,6 +190,40 @@ static int otx2_tc_validate_flow(struct otx2_nic *nic,
 	return 0;
 }
 
+static int otx2_policer_validate(const struct flow_action *action,
+				 const struct flow_action_entry *act,
+				 struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 					   struct tc_cls_matchall_offload *cls)
 {
@@ -212,6 +246,10 @@ static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
 	entry = &cls->rule->action.entries[0];
 	switch (entry->id) {
 	case FLOW_ACTION_POLICE:
+		err = otx2_policer_validate(&cls->rule->action, entry, extack);
+		if (err)
+			return err;
+
 		if (entry->police.rate_pkt_ps) {
 			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
 			return -EOPNOTSUPP;
@@ -315,6 +353,7 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 	u8 nr_police = 0;
 	bool pps = false;
 	u64 rate;
+	int err;
 	int i;
 
 	if (!flow_action_has_entries(flow_action)) {
@@ -355,6 +394,10 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				return -EOPNOTSUPP;
 			}
 
+			err = otx2_policer_validate(flow_action, act, extack);
+			if (err)
+				return err;
+
 			if (act->police.rate_bytes_ps > 0) {
 				rate = act->police.rate_bytes_ps * 8;
 				burst = act->police.burst;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1287193a019b..69a2f8d52b2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4170,6 +4170,46 @@ static int apply_police_params(struct mlx5e_priv *priv, u64 rate,
 	return err;
 }
 
+static int mlx5e_policer_validate(const struct flow_action *action,
+				  const struct flow_action_entry *act,
+				  struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 					struct flow_action *flow_action,
 					struct netlink_ext_ack *extack)
@@ -4197,10 +4237,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
-			if (act->police.rate_pkt_ps) {
-				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
-				return -EOPNOTSUPP;
-			}
+			err = mlx5e_policer_validate(flow_action, act, extack);
+			if (err)
+				return err;
+
 			err = apply_police_params(priv, act->police.rate_bytes_ps, extack);
 			if (err)
 				return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index bb417db773b9..8c31b73088bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -15,6 +15,46 @@
 #include "spectrum.h"
 #include "core_acl_flex_keys.h"
 
+static int mlxsw_sp_policer_validate(const struct flow_action *action,
+				     const struct flow_action_entry *act,
+				     struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_flow_block *block,
 					 struct mlxsw_sp_acl_rule_info *rulei,
@@ -191,10 +231,9 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 
-			if (act->police.rate_pkt_ps) {
-				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
-				return -EOPNOTSUPP;
-			}
+			err = mlxsw_sp_policer_validate(flow_action, act, extack);
+			if (err)
+				return err;
 
 			/* The kernel might adjust the requested burst size so
 			 * that it is not exactly a power of two. Re-adjust it
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 949858891973..70191ba9d8af 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -6,6 +6,7 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
 #include <soc/mscc/ocelot_vcap.h>
+#include "ocelot_police.h"
 #include "ocelot_vcap.h"
 
 /* Arbitrarily chosen constants for encoding the VCAP block and lookup number
@@ -217,6 +218,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 				      bool ingress, struct flow_cls_offload *f,
 				      struct ocelot_vcap_filter *filter)
 {
+	const struct flow_action *action = &f->rule->action;
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool allow_missing_goto_target = false;
 	const struct flow_action_entry *a;
@@ -244,7 +246,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 	filter->goto_target = -1;
 	filter->type = OCELOT_VCAP_FILTER_DUMMY;
 
-	flow_action_for_each(i, a, &f->rule->action) {
+	flow_action_for_each(i, a, action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
 			if (filter->block_id != VCAP_IS2) {
@@ -296,11 +298,11 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 						   "Last action must be GOTO");
 				return -EOPNOTSUPP;
 			}
-			if (a->police.rate_pkt_ps) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "QoS offload not support packets per second");
-				return -EOPNOTSUPP;
-			}
+
+			err = ocelot_policer_validate(action, a, extack);
+			if (err)
+				return err;
+
 			filter->action.police_ena = true;
 
 			pol_ix = a->hw_index + ocelot->vcap_pol.base;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e271b6225b72..e6467831d05a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -14,6 +14,7 @@
 #include <linux/phy/phy.h>
 #include <net/pkt_cls.h>
 #include "ocelot.h"
+#include "ocelot_police.h"
 #include "ocelot_vcap.h"
 #include "ocelot_fdma.h"
 
@@ -258,11 +259,10 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 			return -EEXIST;
 		}
 
-		if (action->police.rate_pkt_ps) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "QoS offload not support packets per second");
-			return -EOPNOTSUPP;
-		}
+		err = ocelot_policer_validate(&f->rule->action, action,
+					      extack);
+		if (err)
+			return err;
 
 		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
 		pol.burst = action->police.burst;
diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
index 6f5068c1041a..a65606bb84a0 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.c
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -154,6 +154,47 @@ int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
 	return 0;
 }
 
+int ocelot_policer_validate(const struct flow_action *action,
+			    const struct flow_action_entry *a,
+			    struct netlink_ext_ack *extack)
+{
+	if (a->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when exceed action is not drop");
+		return -EOPNOTSUPP;
+	}
+
+	if (a->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    a->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is not pipe or ok");
+		return -EOPNOTSUPP;
+	}
+
+	if (a->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+	    !flow_action_is_last_entry(action, a)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is ok, but police action is not last");
+		return -EOPNOTSUPP;
+	}
+
+	if (a->police.peakrate_bytes_ps ||
+	    a->police.avrate || a->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (a->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload does not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_policer_validate);
+
 int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 			    struct ocelot_policer *pol)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index 7adb05f71999..7552995f8b17 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -8,6 +8,7 @@
 #define _MSCC_OCELOT_POLICE_H_
 
 #include "ocelot.h"
+#include <net/flow_offload.h>
 
 enum mscc_qos_rate_mode {
 	MSCC_QOS_RATE_MODE_DISABLED, /* Policer/shaper disabled */
@@ -33,4 +34,8 @@ struct qos_policer_conf {
 int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
 			 struct qos_policer_conf *conf);
 
+int ocelot_policer_validate(const struct flow_action *action,
+			    const struct flow_action_entry *a,
+			    struct netlink_ext_ack *extack);
+
 #endif /* _MSCC_OCELOT_POLICE_H_ */
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 784c6dbf8bc4..6c8f0e114307 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -67,6 +67,40 @@ struct nfp_police_stats_reply {
 	__be64 drop_pkts;
 };
 
+static int nfp_policer_validate(const struct flow_action *action,
+				const struct flow_action_entry *act,
+				struct netlink_ext_ack *extack)
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
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int
 nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 				struct tc_cls_matchall_offload *flow,
@@ -86,6 +120,7 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	u32 pps_num = 0;
 	u32 burst;
 	u64 rate;
+	int err;
 
 	if (!nfp_netdev_is_nfp_repr(netdev)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not supported on higher level port");
@@ -132,6 +167,11 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 					   "unsupported offload: qos rate limit offload requires police action");
 			return -EOPNOTSUPP;
 		}
+
+		err = nfp_policer_validate(&flow->rule->action, action, extack);
+		if (err)
+			return err;
+
 		if (action->police.rate_bytes_ps > 0) {
 			if (bps_num++) {
 				NL_SET_ERR_MSG_MOD(extack,
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 74f44d44abe3..92267d23083e 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -311,6 +311,12 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
 	return action->num_entries == 1;
 }
 
+static inline bool flow_action_is_last_entry(const struct flow_action *action,
+					     const struct flow_action_entry *entry)
+{
+	return entry == &action->entries[action->num_entries - 1];
+}
+
 #define flow_action_for_each(__i, __act, __actions)			\
         for (__i = 0, __act = &(__actions)->entries[0];			\
 	     __i < (__actions)->num_entries;				\
-- 
2.26.2

