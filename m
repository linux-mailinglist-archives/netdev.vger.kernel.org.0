Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA72679B0D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbjAXOEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbjAXOEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:04:14 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9006046728;
        Tue, 24 Jan 2023 06:03:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNRRN8bc9BuFjPPyM8vwlzcuzqoSn/etRpcUuMPzhpQdaNA4kZuA5su9BU7oS/GbDc3HFNbRV66ZL49LdLhfXsCIAZTEI45X0pXkVd0okMdpYPuNoMC1RsGYWqwed+KsBBIkPxiU/lV3UB5X9tqxKODwHprSBl5Hl00KZSnvrTu32pNoXFCLdm0yo5IKRSpIdG3zEWemLiETgkloUZdRmB6murxbpC8YmbixJASuDaha1hkc34rgahLgyBFtVIG7IfcoVfrLIxt8Q6NqKnFsn8Dt6/uYDl0qbLt5tLvrzb6uP8J1+B91WMt6qkC8MSVLoUKCNB2sPVfUO/llzJkpsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sx7rDKIENmpYfMMvC0RZJw+lI6iyP0Ps6js6T3lSVgM=;
 b=PDnK9UBM0bri74xs0PqpPou+A6X8C05QfI9UBLxxSQ3Yf++Ll2D9qcvBhusIcUtMmB1ucOhfMCoJ7SCWsflR1eJM1gknjjqCPSHg2cOnQloP/6JQZKwvx0SYlXMDM446m6d963Pn6B1mGbNz/dIis8JR46z6WjcN9Kq0ThrSRf4R9p28FmcSBWxQRS5cnDiIbuGYagD/ZN0byEdDf51FwxEcVZSkiYYf6Z5GbV9uBRVf2ROWaikz97WqoPue13/ni0SVcNK6cQAegkPgEIE6LWBdUrxFhtPLEsDRTjhGbKi6vczqfQ3WBRp+N4X4d9GcaLD9Bs1p3FH+mAVe6hvfUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sx7rDKIENmpYfMMvC0RZJw+lI6iyP0Ps6js6T3lSVgM=;
 b=N6PiyMQWUjBAE9NMql0sSpfUIKxb4L+XqrbR8fB0Xyesq/O1HDiF2zYCp+uldP3op5i4fHmBhQR5Eo5WU+2Zmr0YpqsKm9siJwbE1cmXa8qyZtQ9C3JdMBuBlVxFtnwTbxqWaxYL7VMt48HEmTxJ/FeeFLjs+rkt4DUWpQu3VYez6FYgfNuPz7ko0bALcNiQF9GbttrcGnh9S8cP6H1K9BnyeiO6zjXEHu0SsSHl8r9bycdcENiFbwi/dyDZG6XE8LXDUsovFr+WCfwd7UDwx4rs8SC52c0PbGXsQYoT3JTtOSYW5AiViOHPMjk352jwvy/epspzM63BXoxwTLyQKw==
Received: from BN9PR03CA0243.namprd03.prod.outlook.com (2603:10b6:408:ff::8)
 by DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Tue, 24 Jan 2023 14:03:34 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::9) by BN9PR03CA0243.outlook.office365.com
 (2603:10b6:408:ff::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:33 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:12 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:12 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:03:08 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 6/7] net/sched: act_ct: offload UDP NEW connections
Date:   Tue, 24 Jan 2023 15:02:06 +0100
Message-ID: <20230124140207.3975283-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c8fb2b4-793f-4cb2-7117-08dafe13c7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gbUsaRBJiNUlaf5wDSGpqNBeo06a+KwrRKw3xbeUIVdeawG1ZHkit3947T0fm1O3AC+lrF7ce/LHNFcraVXMQByLRvYTu6OFaqOVgQwVu3Y7eZPyCrwhJHvs7we4oJq/JhejrgHT+LfzUoT0noIxN/4MZraG2/kU8fAXyIA+wlFXiMX3CFdcXJBD3gbZIUQt7YpBcIYo3sn27VAuXrkQnsyEWkCsmPh0oonya87vcYkcHdJn6nXVsN31lrM4pgS4XBmewybNoL9GTKO4jBFNeJbZcTx6MdeOPf6oYX3Yyx74Yrnu3rkqNUJ3WuEJmoDofj+7SLPg1SNIWdAJTlBWgaXIlBTRh2TRvPjTAFdQkwiaBrQerUoNeJsaD16EBCI9MhI8iM+AeTM8cJzezF7zWv9qixpZymiaNprOnZ/lw7bPSSjh4L7ULH5plHNS7jwO6tOZddcoXXxxobZY/GEI+haYrgu/pTktkjRxntz1ct4vNKrqlWmyax5johXgcdIqK1b2Lh10yOA7KSHnA7MQPXBPBT1KMaL37BVjDw25ox24cwi9aWcuilBAiO1aXC2S4hPRYOYIvasKqgm61V7LHsAhsGz41xtaiNiPGHAPRtOLw3bRTt5QpcU8wWcklfDRisJV9yncTGyydVT0n8CfFnmEXcYFB+9ccPwt9R8TVGBUos7dFCjHUpKz8XlnJjyo+OuPOpHrq7vF8ijPQMD8+PZrywyNZKbsUv2Z5ReZfM0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(36756003)(107886003)(478600001)(2906002)(40480700001)(2616005)(7416002)(336012)(186003)(26005)(5660300002)(8936002)(7636003)(356005)(54906003)(36860700001)(47076005)(70206006)(40460700003)(8676002)(110136005)(316002)(426003)(70586007)(83380400001)(4326008)(7696005)(82740400003)(1076003)(86362001)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:33.5196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8fb2b4-793f-4cb2-7117-08dafe13c7db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962
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
    Changes V3 -> V4:
    
    - Refactor the patch to leverage the refresh code and new flow 'ext_data'
    field in order to change the offload state instead of relying on async gc
    update.

 net/sched/act_ct.c | 52 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2b81a7898662..355ae48bd371 100644
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
@@ -657,13 +667,31 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	ct = flow->ct;
 
+	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
+	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
+		/* Only offload reply direction after connection became
+		 * assured.
+		 */
+		if (test_bit(IPS_ASSURED_BIT, &ct->status))
+			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		else if ((enum ip_conntrack_info)READ_ONCE(flow->ext_data) ==
+			 IP_CT_ESTABLISHED)
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

