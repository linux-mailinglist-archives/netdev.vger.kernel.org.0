Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3AD686BCB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjBAQcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbjBAQb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:59 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DBB79CB2;
        Wed,  1 Feb 2023 08:31:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPwTQCxSoWWEyWqHawK+UmffKJ5buPDaFMh8FPCetsraZxNEP1qC5iBTt/NvjfmP6yDPYl0+kShAIgYQShGZc/LTcAFu+gb9uM51gA11uIVohg2z6VEjOb5lYj9YGMTZdpmMKTgvRxgTGl8BQkmqIprOosdF8uQrinbO2C3kfV0IvEgugK8HHwzkZ3NoAYp9KNvhXvKd5KqLM4dSvOIMylKzsF+XCYzW4PVJmwh+CUh3PwDhtE5fvDhnmzbBW+zgCu3lqz54TvLqLmSdeaIGkv3CWloPc4s4rTIQIQk3hqbIbf8eH4rgy9HsOOknx0ThjlyZcMyvLU3Z/P160qV1sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDAw9eo0GbfLw3OiOJNjmjnZyypHYbmdswfjx3MAkbk=;
 b=lR+tM4lOEZjEeFEsI1AsETVPQlv3Al8zUQ1Xnev54Ods2sjRO+fbw0naIWZWAfp9JcWkVht6YDfwxg8BfjTzIYLKBRxjhXmha/imkK/nY9ectLnpY3S+ulokRv7AVpdfSqS06i2d897bw+H6jFEE0Uk7hM314V5cOVx8I9xC092OaCydAnGgSrdudy5wnjqfQn714jg2y+juuf36/bc21hpbJqFAeMC4iL27TwQYUMZ4SkYlW/u5CJedaTYfhBBtH2tfLtTNcdkblJJ5Vt22Q4U8zyvzEF/TyNCwXdVFNlglGzfFNhH/7/fA2uVuhCMPVNJwHq4KPELNy4iB0amhFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDAw9eo0GbfLw3OiOJNjmjnZyypHYbmdswfjx3MAkbk=;
 b=cwnHFBwScvklrVxMgUwhY6UH5RbtPmyTAft0l9f7LyAzmC2+MX99hoDElZIEpY83vGi7EI3woYnNSaaONJRTTKvb6Qr4qOV9v2dhXbMG8lUEWoc/18waQrusmA4c4H9jyKYSofd7O9iKSE+WhsOGYnQYMTzHvKqgrNZMcuo2i4Gq2blI6Yo4sR/fVH+ly2/bzUHL7crK6BosEI/r9s7R3+3T3SdCGJB2lU5nlC0ZY3RxKbf6BmFNOX2K6EKx1LBGOr1FR+fcx9FlxmNvalezy2HA0we4vTKEXGzLzuVKyl3hWqBV1SIBaaTMG2oegZu1k3v4JdzQPZGUMohK4rWntA==
Received: from MW4P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::12)
 by IA1PR12MB7638.namprd12.prod.outlook.com (2603:10b6:208:426::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:31:50 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::d3) by MW4P223CA0007.outlook.office365.com
 (2603:10b6:303:80::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Wed, 1 Feb 2023 16:31:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:39 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:39 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:36 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 6/7] net/sched: act_ct: offload UDP NEW connections
Date:   Wed, 1 Feb 2023 17:30:59 +0100
Message-ID: <20230201163100.1001180-7-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|IA1PR12MB7638:EE_
X-MS-Office365-Filtering-Correlation-Id: c55594de-7e1b-42e8-928d-08db0471d1ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMiHgbed3pQmoPOc/gU5T74V1i9unrSIEE/ySYbbaULPhoWFmsa+wVn5v7wxTCrX0fiXxh5mwfTxxctxYQyFW48Jb/+r8MzJh6NQIsfgmisnbOXKDx9AaY3bxtY3jX9NcO07HQ+pwnybOgZIWfNucZgHil105geCSdvDxpanNSZokiOBfsU3YSkiqR1spYYA17SleIPybSKoyYx6M3C+CYEas+xMQq+xYUVAnJAYwfn0gbH9nZQf0QS8Iri9rPF+vI/EHJknf00WRsh6EP9JpHBWDw20qtgOF10S2RzqVVdf4qqtQkE1cKoFZSZKJbBlsH62iN1Ys8vXOQCSGHa8b6sQucnpgjF/n3zsk/FhrXkY+pQqIvE3LJ4k2gPOwlvOu9vUXZGq+zg1HQxecOGI7C9lq8ps00doxtX/ujoKfvuPjjIcxHU8TT3I1kEau5gmP/bbPtWYSbsizmnSRbOBufZSkXfv6AkQ/WR2V+fSfXfWCKtEotmAgEfexspVRt6uinURaVYx9N+3vRtEIE1kpBd23MokbQsmJU9/mt8w1c1jTgeb2Oxi1biBn9hBAk/08Vssd41Lsr7jLtv5en+bd8jAuy+ziTSV6guDAX06Dfco2j1Cmy6roLGS1SqnzFVXSzlFUHo/DvqeuEDNVKpsHM1E2uqv2BGmQisRU6L9KFQhc9+6jnnQfiIi/xN5sTxRQOdeJv+hJMEHxQruS5i9/YUS7AXRsuKP/t0COU7e5QI=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199018)(40470700004)(36840700001)(46966006)(6666004)(107886003)(1076003)(478600001)(26005)(186003)(8676002)(4326008)(70586007)(70206006)(7696005)(7636003)(336012)(2616005)(47076005)(426003)(41300700001)(83380400001)(2906002)(40460700003)(7416002)(8936002)(86362001)(82740400003)(36860700001)(82310400005)(36756003)(40480700001)(316002)(356005)(54906003)(110136005)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:50.2074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c55594de-7e1b-42e8-928d-08db0471d1ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7638
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
flow 'NF_FLOW_HW_ESTABLISHED' flag and doesn't schedule the refresh for
reply direction packets when the offloads have already been updated with
current ctinfo. Second, when 'add' task executes on workqueue it always
update the offload with current flow state (by checking 'bidirectional'
flow flag and obtaining actual ctinfo/cookie through meta action instead of
caching any of these from the moment of scheduling the 'add' work)
preventing the need from scheduling more updates if state changed
concurrently while the 'add' work was pending on workqueue.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V5 -> V6:
    
    - Use NF_FLOW_HW_ESTABLISHED bit instead of ext_data pointer to determine
    the ctinfo of last offload call.
    
    Changes V4 -> V5:
    
    - Make clang happy.
    
    Changes V3 -> V4:
    
    - Refactor the patch to leverage the refresh code and new flow 'ext_data'
    field in order to change the offload state instead of relying on async gc
    update.

 net/sched/act_ct.c | 51 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 4dad7bf64b14..38095524d98b 100644
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
@@ -625,13 +635,30 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	ct = flow->ct;
 
+	if (dir == FLOW_OFFLOAD_DIR_REPLY &&
+	    !test_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags)) {
+		/* Only offload reply direction after connection became
+		 * assured.
+		 */
+		if (test_bit(IPS_ASSURED_BIT, &ct->status))
+			set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
+		else if (test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags))
+			/* If flow_table flow has already been updated to the
+			 * established state, then don't refresh.
+			 */
+			return false;
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

