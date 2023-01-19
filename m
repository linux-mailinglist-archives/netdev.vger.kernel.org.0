Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F36D674328
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjASTwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjASTwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:52:12 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3859DCB5;
        Thu, 19 Jan 2023 11:52:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcLXOwQw25y7H1fVDSRA9PZsEPH9yRoHY1NUrZVcpE4ACwbrHfIFyAVxBiW/MIQf3WWgmShAv9l0fXtNhfD5zR0T1O6NY3PD1mCah6Zo9KK0WhwHCuOZmt8tF6q0eaYP2GjOXOCl18FiOaZcbt8wjKiDkV91wkT4v2BflUisGVW3nO4WjhGAUfCq7yCdGi/i/spWwl5oTdAeutwxRmXTDPCQP/tuzU3gtZXgOUPTpTFgvoXNsKAijPwxYhYWC9UEdUHO0Kglkacu2QPU9j8qZLfm94a/Pu3DRhPLkB0C+zVeHlXL7C+cECYqScz6ttZMgX46MEvTFXxxgQTpZqNKVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEPOi1pksZf2VdFK2YD5/ZdJQ110wCkTe4yf3yKGfqg=;
 b=JlDpvqqAYtOYprlXRrqhu642mzBhsAtETI0/Tf3PtDvHUcfRMOtiOpHcRIQ3U7gQIvsvyVjuFCVy/h+fEN9LuFqWpyiwtPRlhEJU6If1iaH0yaAfd/yeXrGqEeFf/+K6NvzB7jEi5La1t/lCb9u6I/7TyAHdmoEbuBKkqXrVOq8vDxOaj/xStM5kQkBbnjnAo1wLG0H8Zd+184au85csSM/pJXJrzAzZzee1hPrqfYljHjPq7fUkpyyVlTZGzBIgnlxBx714Ei8o+pMPz7VmrfEZK8lgri/yAEmC4mR/bZVsUkWa/7bcpn7uazn5WpXEsEwp+kTSGXxP1DUTze3zsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEPOi1pksZf2VdFK2YD5/ZdJQ110wCkTe4yf3yKGfqg=;
 b=GPmCbSg6ZsF481tnAuV2OVDDvvZYdNKp/8vEoCt6mIvnxRjYF66iBsvfCopdp7I303XXcH7ZSvsR3WcIHqpPggObOT8EAs8nvHvisgQFE7dihAdzmpxByCiJQmTdsuj5n6TUKjsUrt4mgQ7IdGHtLheJ8BXjFAnjYH6EZNB77cHVPO6c2i+kXvCwcuUgJY+rIjxEdxsm0jobZb0HRyaN+O6T7wyllPWjjjO1Vpcl85qSjjRne8Lln8t7qWIE+7CQuvCbEOQ1vPVwHHUOnLWoVjqo5RH1zuzWLB1/CYpK8phA3W/8RCvgDD4QGPwHKxnZBLP5PZ71pK6ybgjeLBfNPA==
Received: from BN9PR03CA0630.namprd03.prod.outlook.com (2603:10b6:408:106::35)
 by IA1PR12MB6386.namprd12.prod.outlook.com (2603:10b6:208:38a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 19 Jan
 2023 19:52:01 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::4a) by BN9PR03CA0630.outlook.office365.com
 (2603:10b6:408:106::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24 via Frontend
 Transport; Thu, 19 Jan 2023 19:52:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 19:52:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:45 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:45 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:42 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 6/7] net/sched: act_ct: offload UDP NEW connections
Date:   Thu, 19 Jan 2023 20:51:03 +0100
Message-ID: <20230119195104.3371966-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230119195104.3371966-1-vladbu@nvidia.com>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|IA1PR12MB6386:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f78a5d8-5890-40dc-759a-08dafa56a1b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhNUMw/NkqV6o2jKw6zFy1b7JOjEC/JAKmm4l9k/7NCmjtuoFbkH6DiPFpBhk3EgnIBaQp6XGngodCZAX7nAZpkHHnUQ2LTdEJ684R0iu092iFh23jDc2SbcsemgbSgPWMrsUZw7qyWhzTKMioAfSK22C7t7W6gPq1WjiIi24yG2YELBa4M8KpUU+GB/d3Axn5XOizlHoaLFg/2FMqxrENiS80q/LESvImH8dBUvTPgcV775ifYMIvhowAn5uTGXi9A6KItQoEYt/kTY90MtWTvJLPdQbYSV3JRvRkM51MsVg0WR9cauHAKNZqLlQEGVHpOhmh5dwfBtmxFJeUbA9EkGF18iqVDwqXXaOLS0iqZW9zfGFcj3nbtoJWbOdG/RFMHvRRsuNLFZRGTTsoWe4W5oG8wj4XD13v6dsKbc9Q2Vxbqs9zczbk33zDHlIhO5wLFuoRFD3wFkbAK3yPzwG9M5i5Vp9T0CnwmtTWS4qRRcNnz3psTZOZjHBpiTepcDGHcMyk/OulJO/szcwwmROVDfcnxizilADiTjPD2x1odHlFQsywtjBwqElB9WiJ0mptzLIt3IyZvodw4JJ36llqJHGyVp9YRvep8uZsKY38zrb5mTdoyHzzaO1PPcexhcLeAA98cJ3Q+D7jDt7aFGbgQcVevKgmPq3JSq4BzTbK7hI5XPVb4Esl2lHwlj05XUKdJtniZ3a2s0pUvDXj+GeBoprjiyFkzQkf8R/a7xRH8=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(46966006)(36840700001)(40470700004)(2906002)(426003)(83380400001)(47076005)(82740400003)(36860700001)(8676002)(5660300002)(7636003)(7696005)(41300700001)(8936002)(356005)(6666004)(40460700003)(82310400005)(478600001)(107886003)(2616005)(316002)(336012)(186003)(26005)(4326008)(1076003)(70206006)(110136005)(86362001)(7416002)(40480700001)(54906003)(70586007)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:52:01.1430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f78a5d8-5890-40dc-759a-08dafa56a1b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6386
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
index 52e392de05a4..dca492eb0e22 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -368,7 +368,7 @@ static void tcf_ct_flow_tc_ifidx(struct flow_offload *entry,
 
 static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 				  struct nf_conn *ct,
-				  bool tcp)
+				  bool tcp, bool bidirectional)
 {
 	struct nf_conn_act_ct_ext *act_ct_ext;
 	struct flow_offload *entry;
@@ -387,6 +387,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
+	if (bidirectional)
+		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &entry->flags);
 
 	act_ct_ext = nf_conn_act_ct_ext_find(ct);
 	if (act_ct_ext) {
@@ -410,26 +412,34 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
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
@@ -445,7 +455,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	    ct->status & IPS_SEQ_ADJUST)
 		return;
 
-	tcf_ct_flow_table_add(ct_ft, ct, tcp);
+	tcf_ct_flow_table_add(ct_ft, ct, tcp, bidirectional);
 }
 
 static bool
@@ -624,13 +634,27 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
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

