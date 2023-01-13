Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC597669ED8
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjAMQ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjAMQ5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:57:14 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05541544E7;
        Fri, 13 Jan 2023 08:56:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nq6LHj80drUmuDRMuL+s0FKtYtHu8lJMylT3jW8WranubsnFnRWZ7HFlMGVIJeHwP7xVUy882ZszjK9riZTqELOVJ3PkvSbkowQmTA3Zhx63xvf+8SQVObwR4JuuUnA+ZR6EMOOzTUgI4CaRIndeEe73fi9Liq0YwHvXLoZRbwyKQUoLy6w4hwTvM+nE1bGOTyN0r+atyj4O85kanglmDHfm1JtvyhQ049BVQ8264M6Lc+Dz7u6ksUHdacDNELF4GMF+gUnUSS+CjCOShO1W9ovNUFAJdbBrIMVnBs+I4llBZvVU8WZ8EHkb6aREzbFxh3MxUBSCjq9wSVPKzZZYAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wM2paC/pUdX6NnkKABrYxLcS03Usi5y6IxiikT2Ul2k=;
 b=O1aR8os+B+KsU23V45CpkYw4WZi1hA1tpN+PX7gU3sehZsH7o6hYaay4k0HzjikkmDM/otbq2p630opFbXo1WDQPkSW7xeJWkTf82pdO1054A3WG8yrcogV8m+sA7JrI1jlM9qSqT+CR5/BHI6N8hHuJ6dpLS5ZYVDmpz08ltKhPgcjjmZuCMLFUmEp0KFHxKxo4+CmzuQ/5OHXzCT/+XG/fe5Tvb9KJuoFCTbDKZGSZQZE8ugZQUXS3+wwN590qPnrxYdbqMB/O5BhpPFxDA+0mgz4Izs3x0MxFcnSddfuD/hz0F7z5EjYdXMzAS+u+Kz3ad3JYfjQ6LlroE8hqzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wM2paC/pUdX6NnkKABrYxLcS03Usi5y6IxiikT2Ul2k=;
 b=Vuweuy/G5w8hR/AYfQ9FAbPyGDyZhKHfh4a25v20dM1q7Xh4rA8dwtkLzpQgCkNAocWJe2j0/8qhV+beME9c2xjxEQatYyHSxD3k3SIuP8b13f7pkqwwuXhgreUXqUxYjzyl4TKGrKctUnKCmJP3ubc79KgmFh1SUXbqsdJh5GWbGOoiyF0MnHAgxkOxIDjhWhFg6yXZ0zEUxMd7LPRUaBssk2s0SOnffktNZtNRqOp6uIX5syue263oF/TTTieGleqBQY3dpm/lrwp/Q249jt2mwefZClXDSz2MD2rxz7kiVYWKn+OMC+/02qPl0rENTuCKfcLR4OvsK9DGNesvCQ==
Received: from DS7PR05CA0074.namprd05.prod.outlook.com (2603:10b6:8:57::22) by
 BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Fri, 13 Jan 2023 16:56:56 +0000
Received: from DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::14) by DS7PR05CA0074.outlook.office365.com
 (2603:10b6:8:57::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.6 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT089.mail.protection.outlook.com (10.13.173.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:47 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:46 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:43 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 6/7] net/sched: act_ct: offload UDP NEW connections
Date:   Fri, 13 Jan 2023 17:55:47 +0100
Message-ID: <20230113165548.2692720-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT089:EE_|BL1PR12MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a998c4-33a7-4723-095d-08daf5872d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8QQcao3AwbbrQKNhD5wuOCmPLbB76enxQQwSygfW+5OUjc22rfiTwiG74psS8EMDhfPnvqupWQ/69KL5EVh1G/3y+OiQkILljZEmNdlyBGMXmRpKKSRhWubw4zWFA34ncnJ5DYHAAZbFDbnFWWwsoy1IUB/1hyRl1a9ucv2nZbbhsByHLB76zRg0knBf9+pQwN1s32xvIUI0c3uM7QUVcMCS0NKb5QhfFEKpz6Fo6CZQRmbksShT3UaLeTCt3LW5qOMH8y3SUwBZFftOQCCSjo7hTTKWE5Cuzl6pZhx+loqnOLcbayhOOrDFHoXF+/GGMpbv2iu8CcXr7d6+Rs28YWDc/FsC8Iec0ljCqWFE1Qbhj0VJY9993gxtmwMu+UyBg+ig4kHO6gsP9ofItUBygnVN7SPJXZ4ueHx/2vgbQjd1wSmLLEnc//HdJcV77xTnHgYXjmYsRpRgChema0nj62Bgd1kSsaVg7CZ119VfpJuYXqFWsZQd3wmirMuJOMeO0VLVSC6U61bR7PXbe5lzkpKfT6jeefEdNfeqGy2N+74gzJcVTaxse6F9w90xXkDn4SSAEwaldX0fURIX03LR6EdC1RQRavL2tM9/1HS6bJgkGHH+5zkpWLojn/Yzs2aCR6Vpa+yw/phz355jjTD3EzeTvpLbSh7xtY/4FfU7hzuIyah+uoo+d/7OLOSkFGbWPQVn8drjCV+QawCno5/XfXo0ltKU8DVoGqwNwcDlaI=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(2906002)(82310400005)(83380400001)(47076005)(336012)(36860700001)(426003)(1076003)(7416002)(40480700001)(5660300002)(186003)(8936002)(107886003)(36756003)(26005)(7696005)(2616005)(70586007)(7636003)(41300700001)(70206006)(110136005)(478600001)(86362001)(8676002)(54906003)(356005)(316002)(40460700003)(4326008)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:55.6319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a998c4-33a7-4723-095d-08daf5872d6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing connections allow offloading of UDP connections that don't
have IPS_ASSURED_BIT set as unidirectional. When performing table lookup
for reply packets check the current connection status: If UDP
unidirectional connection became assured also promote the corresponding
flow table entry to bidirectional and set the 'update' bit, else just set
the 'update' bit since reply directional traffic will most likely cause
connection status to become 'established' which requires updating the
offload state.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_ct.c | 48 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index bfddb462d2bc..563cbdd8341c 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -369,7 +369,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
 
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
-				  bool tcp)
+				  bool tcp, bool bidirectional)
 {
 	struct nf_conn_act_ct_ext *act_ct_ext;
 	struct flow_offload *entry;
@@ -388,6 +388,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
+	if (bidirectional)
+		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
@@ -411,26 +413,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 					   struct nf_conn *ct,
 					   enum ip_conntrack_info ctinfo)
 {
-	bool tcp = false;
-
-	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
-	    !test_bit(IPS_ASSURED_BIT, &ct->status))
-		return;
+	bool tcp = false, bidirectional = true;
 
 	switch (nf_ct_protonum(ct)) {
 	case IPPROTO_TCP:
-		tcp = true;
-		if (ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
+		if ((ctinfo != IP_CT_ESTABLISHED &&
+		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
+		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
+		    ct->proto.tcp.state != TCP_CONNTRACK_ESTABLISHED)
 			return;
+
+		tcp = true;
 		break;
 	case IPPROTO_UDP:
+		if (!nf_ct_is_confirmed(ct))
+			return;
+		if (!test_bit(IPS_ASSURED_BIT, &ct->status))
+			bidirectional = false;
 		break;
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	case IPPROTO_GRE: {
 		struct nf_conntrack_tuple *tuple;
 
-		if (ct->status & IPS_NAT_MASK)
+		if ((ctinfo != IP_CT_ESTABLISHED &&
+		     ctinfo != IP_CT_ESTABLISHED_REPLY) ||
+		    !test_bit(IPS_ASSURED_BIT, &ct->status) ||
+		    ct->status & IPS_NAT_MASK)
 			return;
+
 		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
 		/* No support for GRE v1 */
 		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
@@ -446,7 +456,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	    ct->status & IPS_SEQ_ADJUST)
 		return;
 
-	tcf_ct_flow_table_add(ct_ft, ct, tcp);
+	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
 }
 
 static bool
@@ -625,13 +635,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	ct = flow->ct;
 
+	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
+	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
+		/* Only offload reply direction after connection became
+		 * assured.
+		 */
+		if (test_bit(IPS_ASSURED_BIT, &ct->status))
+			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
+		return false;
+	}
+
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
 		flow_offload_teardown(flow);
 		return false;
 	}
 
-	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-						    IP_CT_ESTABLISHED_REPLY;
+	if (dir == FLOW_OFFLOAD_DIR_ORIGINAL)
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
+	else
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 
 	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
-- 
2.38.1

