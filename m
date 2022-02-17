Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C484B9AE5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbiBQI3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:29:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbiBQI3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:29:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270FF1F6B87;
        Thu, 17 Feb 2022 00:28:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+9s26ahdyvt8M5nkvWODON7h0/YbcPtWRWPLUKjAVh5nn3vaQwHrRZ6wNE9IE1Xs4OFXGVg74SgzdQ0gjTVustGMwgeJNcTxl2oAb3U0HFkRLXTBuYRHliu/RZrISIU81xl5YAQCJvh6cGlkMNAvYmUqD73D8xaCG1ojUhqwl+QvPKP5gqnjNKjQUVafoWAw3lmonH3YZvKw93epinGxW1LqvEBVzYrmhOqvSOauZRUBZRspogfQbY+GpccyWf15nN5W63XGk2RGNjHp0nYlxoe+kSLvhqz5UZpfyn6WhzbTr8ga0Bg4AXvejLCko7ZCfhWuN2h8o0KwIAjDe7rrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTv8hblTDu/R/HbOVSeJiBn1U3cUBTr+K2k793jyw7c=;
 b=O+3yi9atxrm9xZwQ8Lf4Z86FF9giszhIqRZBDPq5QumGV1HUcmdxPiOwFQDnZ3apALlMLmxQ1M+4LTzaioyufrBIlVmd/tOTNsWWPrJGZLwEX9Vxpb0AFExgm4GPvCSykVVORiqljW0gfsQitoplJ0C0nm8LVdZ4oAkPPCu5ff6xQHy5yWEpPo8ROJ+xjXLZeGQ+fil0hF268nwCCS4YBCBO1STJeqojZ5hnpXW0CPm7Bt7AoR+y5aO+0zroddnvrFgKDxsvkzeuykNNTeMPGp18h5q051aQQIplj7b3ZEDG1esITaigPJ1M8971Jv6X4wsXzeQkCm7VH6sTqIa2uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTv8hblTDu/R/HbOVSeJiBn1U3cUBTr+K2k793jyw7c=;
 b=Lb12CiyZmhTPlfSNCr2XyyT0APnPP+yTEIwl5tzbjMfDfBYXrrQN3UDobGfTM2OE7vPsCa56OpdVdExavaj5hPyV1cy0qH/UQK3oU9kvk5islc6P/9PDCXPNzIMI6Lb76AvZx99yYffDiziGIdb9U81WOwgT5ZfsZUiye3SZylRB2aqJ2e5pHoSmyinrEy0FYX5t8BKDBk2RtBAfi6Y9lwGt6D1qWX0kqOIzSO8YzvvewInWewD6PYAit3kuc1ZBarc1ClEq1CgSAACTLDVQ3ifua+cl+i6zm34nnoqTEJ97rq40eW09DrZbWFL8vQ7CVp6c9lhqGXuo3Xy2owI25g==
Received: from BN9PR03CA0133.namprd03.prod.outlook.com (2603:10b6:408:fe::18)
 by BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 08:28:56 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::c9) by BN9PR03CA0133.outlook.office365.com
 (2603:10b6:408:fe::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Thu, 17 Feb 2022 08:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 08:28:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 08:28:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 00:28:31 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 00:28:24 -0800
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
Subject: [PATCH net-next v2 1/2] net: flow_offload: add tc police action parameters
Date:   Thu, 17 Feb 2022 08:28:02 +0000
Message-ID: <20220217082803.3881-2-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220217082803.3881-1-jianbol@nvidia.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a32411e-5dda-46bd-de7d-08d9f1ef89e8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB587314E06F23010CB501C829C5369@BL1PR12MB5873.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hk+KdFa79383eFld3q24Xmwj6EQ3zb78vW5BQ4H9j2iJQVYqntTB/bC81LPhXwmiM0dffUd0VJcx2WVKqq846fpAOiqhdT2UZ2QHIlemYtVpANc9y5HHUVyaQ//TO2eMCFWDdT9yZQvqVUWthysBPt/1BnG80zhoDmiP7MH7aCD9QL/Yec5XKsOsbSEiHFgtkiGad9ruBOdeVWtC0ttPwkGjuY4em1TLNv6QC1GHV9YNNuT9LWvvwtSWxSD9QT0D7U6LsO5fM4Zy6PYctTK3vhyy09riuYXmKQXDc5u8GdCXY1f8Sa03mTToHW5N+dspu/pxYmTW+AcxFvTdHOWlGi54+DKjNbDnlUTv8B40kCfm5cgQUYKGhRIm/vaEN47uH/fNcbvnuYl29z/TsIRiG/ICXQC7ETs3TlATIYSuzaJfwQqXztKCmJ9S6034Xmvsqko5k6c0NHJS3zVRgbGJ5D2hDmWS6xJdEJuquCr8Gb8S9C/8/CVnZRpLN5WFz7F2TDnSUUuevNax6be8gJQTrZ0STMvkWq5JjSjjUFuYNOwAQuO11VOo80yQWcErpgAB4M7cDPGsJdY2fBXdAgolVzL5C2pdm2cXeTJtLJUu3D6mDXYTUWI4HNLITH7yYkEKuojJvzfI1XF8qWxTr9BTaBx1F5lrkKvTZDcWl7RcGqC0WoRETA3mRvr9QhyhUiiQZfBmoFQ9ilyLHZGOkhx44g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(86362001)(70586007)(70206006)(81166007)(36860700001)(508600001)(107886003)(36756003)(356005)(5660300002)(336012)(26005)(426003)(186003)(83380400001)(8936002)(1076003)(2616005)(7416002)(316002)(4326008)(8676002)(54906003)(82310400004)(40460700003)(6666004)(47076005)(7696005)(2906002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:28:56.1134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a32411e-5dda-46bd-de7d-08d9f1ef89e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5873
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current police offload action entry is missing exceed/notexceed
actions and parameters that can be configured by tc police action.
Add the missing parameters as a pre-step for offloading police actions
to hardware.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_offload.h     | 13 ++++++++++
 include/net/tc_act/tc_police.h | 30 ++++++++++++++++++++++
 net/sched/act_police.c         | 46 ++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 5b8c54eb7a6b..94cde6bbc8a5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -148,6 +148,8 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
 	FLOW_ACTION_PPPOE_PUSH,
+	FLOW_ACTION_JUMP,
+	FLOW_ACTION_PIPE,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -235,9 +237,20 @@ struct flow_action_entry {
 		struct {				/* FLOW_ACTION_POLICE */
 			u32			burst;
 			u64			rate_bytes_ps;
+			u64			peakrate_bytes_ps;
+			u32			avrate;
+			u16			overhead;
 			u64			burst_pkt;
 			u64			rate_pkt_ps;
 			u32			mtu;
+			struct {
+				enum flow_action_id     act_id;
+				u32                     index;
+			} exceed;
+			struct {
+				enum flow_action_id     act_id;
+				u32                     index;
+			} notexceed;
 		} police;
 		struct {				/* FLOW_ACTION_CT */
 			int action;
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index 72649512dcdd..283bde711a42 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -159,4 +159,34 @@ static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
 	return params->tcfp_mtu;
 }
 
+static inline u64 tcf_police_peakrate_bytes_ps(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->peak.rate_bytes_ps;
+}
+
+static inline u32 tcf_police_tcfp_ewma_rate(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->tcfp_ewma_rate;
+}
+
+static inline u16 tcf_police_rate_overhead(const struct tc_action *act)
+{
+	struct tcf_police *police = to_police(act);
+	struct tcf_police_params *params;
+
+	params = rcu_dereference_protected(police->params,
+					   lockdep_is_held(&police->tcf_lock));
+	return params->rate.overhead;
+}
+
 #endif /* __NET_TC_POLICE_H */
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0923aa2b8f8a..0457b6c9c4e7 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -405,20 +405,66 @@ static int tcf_police_search(struct net *net, struct tc_action **a, u32 index)
 	return tcf_idr_search(tn, a, index);
 }
 
+static int tcf_police_act_to_flow_act(int tc_act, int *index)
+{
+	int act_id = -EOPNOTSUPP;
+
+	if (!TC_ACT_EXT_OPCODE(tc_act)) {
+		if (tc_act == TC_ACT_OK)
+			act_id = FLOW_ACTION_ACCEPT;
+		else if (tc_act ==  TC_ACT_SHOT)
+			act_id = FLOW_ACTION_DROP;
+		else if (tc_act == TC_ACT_PIPE)
+			act_id = FLOW_ACTION_PIPE;
+	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
+		act_id = FLOW_ACTION_GOTO;
+		*index = tc_act & TC_ACT_EXT_VAL_MASK;
+	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
+		act_id = FLOW_ACTION_JUMP;
+		*index = tc_act & TC_ACT_EXT_VAL_MASK;
+	}
+
+	return act_id;
+}
+
 static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
 					u32 *index_inc, bool bind)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
+		struct tcf_police *police = to_police(act);
+		struct tcf_police_params *p;
+		int act_id;
+
+		p = rcu_dereference_protected(police->params,
+					      lockdep_is_held(&police->tcf_lock));
 
 		entry->id = FLOW_ACTION_POLICE;
 		entry->police.burst = tcf_police_burst(act);
 		entry->police.rate_bytes_ps =
 			tcf_police_rate_bytes_ps(act);
+		entry->police.peakrate_bytes_ps = tcf_police_peakrate_bytes_ps(act);
+		entry->police.avrate = tcf_police_tcfp_ewma_rate(act);
+		entry->police.overhead = tcf_police_rate_overhead(act);
 		entry->police.burst_pkt = tcf_police_burst_pkt(act);
 		entry->police.rate_pkt_ps =
 			tcf_police_rate_pkt_ps(act);
 		entry->police.mtu = tcf_police_tcfp_mtu(act);
+
+		act_id = tcf_police_act_to_flow_act(police->tcf_action,
+						    &entry->police.exceed.index);
+		if (act_id < 0)
+			return act_id;
+
+		entry->police.exceed.act_id = act_id;
+
+		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
+						    &entry->police.notexceed.index);
+		if (act_id < 0)
+			return act_id;
+
+		entry->police.notexceed.act_id = act_id;
+
 		*index_inc = 1;
 	} else {
 		struct flow_offload_action *fl_action = entry_data;
-- 
2.26.2

