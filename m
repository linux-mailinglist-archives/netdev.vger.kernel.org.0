Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2425967EDBB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbjA0Sjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235168AbjA0Sjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF92E8737F;
        Fri, 27 Jan 2023 10:39:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rvnwlb1c3j3uo3oRRK0atOTlqC6DiS57VbVmGUDoCpSKxa3NtOjEzNmWZGX8+gfXy/Hv2rtF6P8PAPPXQ2CeNPzS/rvd7N07SRIN1ncRLqiAZM6V5yLQ4XhRElBHeutvJRRRrp6wsP+PkOWmIOEpcn0imDMMhQr4PFi5M+7LvXR19GvVS0Qg77296ZleQKcSlPzeWj+cCFfsIr1558dQgSJUUNv4vKmqokT9Lc5ovkr6ofm+Im9I/PzFiFi3bSdU+AocnONuZbR/8CWSFKY6C9ptsSE61SWnhLokMfJJ03KIruQgOUTF7aWlztuTRCnXrGMSSP0l9Ppw9flFnTUsyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjOmgY6gUtIxb0LXGEBTRKMWCnRPhXjklty3iBiVzZo=;
 b=NQIx1f0rKubn9CNBojRc4kTdE318aPd/8hj2Qk99FfSKeHtAxxCIOY8F3nN96HKyXDDcl42fQkcwueFP6q3cZO9nRKrPRwIsDgjXDmq7XpEUmDijAyyLuulWPGZ0q3uX5IQwPz9cgqnSIXeh5dLd8iUkUBk/pTLaUOV4ddSFBjP8ok1+Z0bTYdaqer85A32Yp3/cpIt3FLmrVNUUAiEjwJWaoOu/1ddrniJCYZQEEahweB2Ys9NEPavc1QaEYdS2TdLOKSjo7Noe3JZ8v4nJXabsrurYxPVEylhcPDI3xhopcfot3HAbkbXpE81kdaBGrBDKKRkudDpAVTC4swGPgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjOmgY6gUtIxb0LXGEBTRKMWCnRPhXjklty3iBiVzZo=;
 b=GlSQd+LYCK++Se/yscOygpNH2lKfXOWhc8eMky0wU6oNAkLPYGs3xb5nGxZJXUPKnAeViJNJbeRaZyoCIsCTlzBrwYwOp865swYb/zGUW/4sm46RJe0avdtfSHhi2KdbjfEpCiVjf5I/KDK/I5+D/GxGPdxjs1ZsG8kYlhXrrtDggDBWIikLl2VM+Nsyhc/k3LZr+Zp0ZNPV8Ppf4klKA5DwpAM+GGhdyAd0uAYvDKC5ykyTYOnrSP2YhM3lEryuDsjUrFkPaOkpH9kgPYVvwrCbiP6ptmHQvHfQo9lynwQ+bj5Tvl1kNSpGhdKbtw7l5cw51iLLeBPfkEk37IYBHg==
Received: from CY5PR10CA0006.namprd10.prod.outlook.com (2603:10b6:930:1c::6)
 by CH2PR12MB4118.namprd12.prod.outlook.com (2603:10b6:610:a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:39:29 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:1c:cafe::b1) by CY5PR10CA0006.outlook.office365.com
 (2603:10b6:930:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Fri, 27 Jan 2023 18:39:29 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:22 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:21 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:39:18 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 6/7] net/sched: act_ct: offload UDP NEW connections
Date:   Fri, 27 Jan 2023 19:38:44 +0100
Message-ID: <20230127183845.597861-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|CH2PR12MB4118:EE_
X-MS-Office365-Filtering-Correlation-Id: 0138c5c0-0bab-408c-c7cd-08db0095d328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tG4yDSRsf/7aQiAddK/Y5BjdljdGnk5XmQhtC1EYNMf4UzUg1kgqPWKTK7S4ZRRBGaZyLwXMnqhp6Q+VN8Dk5f72nxPWOH64GKpCSuR26dE6q5mkf9gLlW7NW+/SIKpWmMXea6uMVdcHJm2B2yp9NyEwj6pngIUfB6o9AN5wSUE/t+9tYvooQ6vDkQmXc32nYfGuF7HSil46U5b7E3dKFyGt8fj18GbzLwFWcoymydq/BoY3p+4WNEuWSQvKLH5wXc+ZAiEYJBiwkfgsu7hJt/Ypoa+dvEs3bEIZ2e3wyxNU7hXx222YqJ5KiZS5keFAhbmEa8W2ngeXSZH7qRTC3zhpbEim7p8itQD//9ZhTWqzmlRKfGybFhi0gTmMF0pY6MGhP0epiXhWpQFBVE27oraUrSoPs7vfLQcriZNMmQLdTjCHIUiz066lEQaMYiYxCtBS7Kp4vDHZewP8g0LJO9AsxcsweqdRwgoJg0Z26rsP60Oi73UgxLGUz7Ga01HBCnP+DoSQu8COH1C/m/RgKIyfbl4kTVV18SeBWIHurhEU7t2hciZ6fFtQRm6iFFCHINDUTp9xWNYiKwCF3eWxoH2gSOtGCJDmaaRyr2g4wHLgYRrDo814Q4dBcXDclvYBCyi73JrtL8UG8DGoyRloig5ekuL47S7gno5/HsRilqk0t975qV+aBpaw1jdGVq41EIIR34GHKe0gyVxYNyZaYXhuCu/aO7IrBT9x/OGibmw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(47076005)(8676002)(36756003)(40460700003)(7696005)(54906003)(40480700001)(356005)(336012)(110136005)(36860700001)(26005)(2616005)(83380400001)(7636003)(86362001)(186003)(82310400005)(426003)(6666004)(7416002)(478600001)(107886003)(316002)(1076003)(70586007)(82740400003)(8936002)(70206006)(5660300002)(4326008)(2906002)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:29.4755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0138c5c0-0bab-408c-c7cd-08db0095d328
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the offload algorithm of UDP connections to the following:

- Offload NEW connection as unidirectional.

- When connection state changes to ESTABLISHED also update the hardware
flow. However, in order to prevent act_ct from spamming offload add wq for
every packet coming in reply direction in this state verify whether
connection has already been updated to ESTABLISHED in the drivers. If that
it the case, then skip flow_table and let conntrack handle such packets
which will also allow conntrack to potentially promote the connection to
ASSURED.

- When connection state changes to ASSURED set the flow_table flow
NF_FLOW_HW_BIDIRECTIONAL flag which will cause refresh mechanism to offload
the reply direction.

All other protocols have their offload algorithm preserved and are always
offloaded as bidirectional.

Note that this change tries to minimize the load on flow_table add
workqueue. First, it tracks the last ctinfo that was offloaded by using new
flow 'ext_data' field and doesn't schedule the refresh for reply direction
packets when the offloads have already been updated with current ctinfo.
Second, when 'add' task executes on workqueue it always update the offload
with current flow state (by checking 'bidirectional' flow flag and
obtaining actual ctinfo/cookie through meta action instead of caching any
of these from the moment of scheduling the 'add' work) preventing the need
from scheduling more updates if state changed concurrently while the 'add'
work was pending on workqueue.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V4 -> V5:
    
    - Make clang happy.
    
    Changes V3 -> V4:
    
    - Refactor the patch to leverage the refresh code and new flow 'ext_data'
    field in order to change the offload state instead of relying on async gc
    update.

 net/sched/act_ct.c | 51 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2b81a7898662..5107f4149474 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -401,7 +401,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
 
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
-				  bool tcp)
+				  bool tcp, bool bidirectional)
 {
 	struct nf_conn_act_ct_ext *act_ct_ext;
 	struct flow_offload *entry;
@@ -420,6 +420,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
+	if (bidirectional)
+		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
@@ -443,26 +445,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
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
@@ -478,7 +488,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	    ct->status & IPS_SEQ_ADJUST)
 		return;
 
-	tcf_ct_flow_table_add(ct_ft, ct, tcp);
+	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
 }
 
 static bool
@@ -657,13 +667,30 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	ct = flow->ct;
 
+	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
+	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
+		/* Only offload reply direction after connection became
+		 * assured.
+		 */
+		if (test_bit(IPS_ASSURED_BIT, &ct->status))
+			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		else if (READ_ONCE(flow->ext_data) == IP_CT_ESTABLISHED)
+			/* If flow_table flow has already been updated to the
+			 * established state, then don't refresh.
+			 */
+			return false;
+	}
+
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
 		flow_offload_teardown(nf_ft, flow);
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

