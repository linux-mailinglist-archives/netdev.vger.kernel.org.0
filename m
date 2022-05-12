Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241AF5254D5
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357513AbiELS2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245317AbiELS2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:28:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DBD246D88;
        Thu, 12 May 2022 11:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi7yH240/QUW2y0n09JuAHS4r3QOBSTSrlrzg6OgDYkpa2vBkhJllDj2FFkO8b0FEY03KltbHz1u7D5zGtDHAlJN43wk9vow8HZ2AU7vfSElmKp44ga70PdhXVlG510XFlDwYtoL/oEMDRtDsCrzXUT3xlmZSCSVyyUxtdcmd+egkQucuczoJSPU7XgVbLMkojaUWcx1yUZJQ1tsuItOTmP7Vz3HRHfTMB4mQngxEcuE/2H1xvkFwjqwlGgWqzbC+XCCRrmcf5/dratzrIJBUfF7dR9Nk0pgP7h5o3we5PdxXGS0U4hRBQBH+mcxWRex7yO0WQ+ScBBubHuiHgUXkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gQpyH3bauStaXBVgygbwylngXGKt4RdO2u6Rx+vZvo=;
 b=oetdg7ORLBuUYgWG8wtatObRs3j2caibcoS5gW94n7zoFL4iOThURNcKK8zbFJhc31i7RCw4OjQOl7qAgvtJUWRloBtjUU8c+KCqQlcT0S9U1G1TIHZP5swsig9+Ur21Q4GixfkWPrLu6JaZCM1IyQiLHdVS6hL0dKD8qBqbxFIrQXX6wnjm4FRUeIkg78So3KHxRBeq2/5aYEihpuIoWV99no2KFx4YdO7mBmxZA7l+RzLw5jaZoCgohICrpGufG8YcUoqlbaH/BQ3/f4kc9q5yu1/fK87TRE3ibm/npi2c7CLOWNYG1NwE43V+DB+3K6LgKJWqAOgy1nS7SqCd/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gQpyH3bauStaXBVgygbwylngXGKt4RdO2u6Rx+vZvo=;
 b=tqbC6tYw7RrBDtOWuU9C7aoJXU0cgmR3OYe/kvpGVQYd0mhRsE/4kXLiKHLc88UE27WBmEqdAlq3KL4jLRiHMCKWSucP6tV17IOgfYqhwHiBR46ZkZv7ZjO0FSzMcJoSaO7+gcsvVqhRojCncj3ilzwCLrXbJDVlsBJArLD5T9wCBbwASj9sFDzSYaexGAFFnL9s+FEtu++PN+gTEauDLaNdcmzoiSdeCnigeCNlD2IE93ZlpwTmStdzKaKhv9ghRCiMnnnEUjpnXTdyeSkHo0hstp9r8tjNUr8f38M4lZd09OpzOGqsizKKtHSPQkKsE+tcpoyCvQ7RIUtohTIH6w==
Received: from BN9PR03CA0498.namprd03.prod.outlook.com (2603:10b6:408:130::23)
 by DM6PR12MB4372.namprd12.prod.outlook.com (2603:10b6:5:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 18:28:36 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::e3) by BN9PR03CA0498.outlook.office365.com
 (2603:10b6:408:130::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Thu, 12 May 2022 18:28:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 18:28:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 12 May
 2022 18:28:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 12 May
 2022 11:28:34 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via
 Frontend Transport; Thu, 12 May 2022 11:28:31 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Felix Fietkau <nbd@nbd.name>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        "Florian Westphal" <fw@strlen.de>, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [PATCH net v2] netfilter: nf_flow_table: fix teardown flow timeout
Date:   Thu, 12 May 2022 21:28:03 +0300
Message-ID: <20220512182803.6353-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262a4f78-aaa2-4c73-8322-08da34453a4b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4372:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4372E9460ADB5C6CFA3117C2A6CB9@DM6PR12MB4372.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avf+4+35AYtGsFSwJCiRmp/o3tHtuJGXTCWtFIod4XBbXVcOHEDz7B+nyjWfrVotZKwJvxY1q2dP5+BSA2eUaNVyCARS61vJw0ILUwzHwtJU/DlfHBKjEOr5oGyV71bp9rKu2FIoEq7tZMVROCI0k/irL24BJcqsgpxyWWOz87WoeXuqG0zxHgz2vDHAs/RLRmF3HBBVaPl41JSJNLn/8lA1gIBxlA29R74UWx89IfArUP3SIW9M1ooYmiTcIEgTbgp2gU+/7w4kHxy68gAqJxZNM+oMLgAAPQavNje6eNSBH2U+dLc24zHjEwNVm+pEacYt2W2ishCosMUgviWxtROjnU3HMfpsfFHH1PaoJurC3LDbjatZoy/L8kJD+JHIJ5V3QJsjql8u7LRuc3vdaBlkBiA+hQp/baiyyyYxg745UBj2FQMyuEnH0h5FQNPTK9RlO17s9kQdL/GdvcdiApkB+zy/ZnOknGHSwCmBfNwFOKg95CJ/9/1QTZNqxEzV/LFxXLdC6p8hXTg1pk33OxllJhT9Klglwwct//N6GMtEGjltAS5BhDBrDgEiWyp2+oqm1jFlT8uHyc/1i7D9m9Lk6DochlTGdWhZn56XL3TpJlB0RQEnaeXniza42UVT3tpTYnuEqbzz6H3WH6MA3yqoHT712gHpLCl0oiH+mYZtYLq+1U9OhEQe4dM1ET0s3ROhCAIHQbT6QcT9HVuv6w==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(81166007)(2906002)(54906003)(110136005)(316002)(8936002)(5660300002)(70206006)(356005)(4326008)(8676002)(70586007)(83380400001)(107886003)(508600001)(26005)(336012)(40460700003)(1076003)(426003)(47076005)(186003)(2616005)(6666004)(36860700001)(82310400005)(36756003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 18:28:36.0042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 262a4f78-aaa2-4c73-8322-08da34453a4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4372
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connections leaving the established state (due to RST / FIN TCP packets)
set the flow table teardown flag. The packet path continues to set lower
timeout value as per the new TCP state but the offload flag remains set.
Hence, the conntrack garbage collector may race to undo the timeout
adjustment of the packet path, leaving the conntrack entry in place with
the internal offload timeout (one day).

Avoid ct gc timeout overwrite by flagging teared down flowtable
connections.

On the nftables side we only need to allow established TCP connections to
create a flow offload entry. Since we can not guaruantee that
flow_offload_teardown is called by a TCP FIN packet we also need to make
sure that flow_offload_fixup_ct is also called in flow_offload_del
and only fixes up established TCP connections.

Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>

------------

v1 -> v2 changes
- Add flow_teardown flag
- Add nftables handling
- Fixup timeout according to the current ct state
---
 include/uapi/linux/netfilter/nf_conntrack_common.h |  6 +++-
 net/netfilter/nf_conntrack_core.c                  |  3 +-
 net/netfilter/nf_flow_table_core.c                 | 42 +++++++++-------------
 net/netfilter/nft_flow_offload.c                   |  2 ++
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 26071021e986..bb06202a4965 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -118,6 +118,10 @@ enum ip_conntrack_status {
 	IPS_HW_OFFLOAD_BIT = 15,
 	IPS_HW_OFFLOAD = (1 << IPS_HW_OFFLOAD_BIT),
 
+	/* offloaded conntrack entry is marked for deletion. */
+	IPS_OFFLOAD_TEARDOWN_BIT = 16,
+	IPS_OFFLOAD_TEARDOWN = (1 << IPS_OFFLOAD_TEARDOWN_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
@@ -126,7 +130,7 @@ enum ip_conntrack_status {
 				 IPS_SEQ_ADJUST | IPS_TEMPLATE | IPS_UNTRACKED |
 				 IPS_OFFLOAD | IPS_HW_OFFLOAD),
 
-	__IPS_MAX_BIT = 16,
+	__IPS_MAX_BIT = 17,
 };
 
 /* Connection tracking event types */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0164e5f522e8..324fdb62c08b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1477,7 +1477,8 @@ static void gc_worker(struct work_struct *work)
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
-				nf_ct_offload_timeout(tmp);
+				if (!test_bit(IPS_OFFLOAD_TEARDOWN_BIT, &tmp->status))
+					nf_ct_offload_timeout(tmp);
 				continue;
 			}
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 3db256da919b..aaed1a244013 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -177,14 +177,8 @@ int flow_offload_route_init(struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
-static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
-{
-	tcp->state = TCP_CONNTRACK_ESTABLISHED;
-	tcp->seen[0].td_maxwin = 0;
-	tcp->seen[1].td_maxwin = 0;
-}
 
-static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
@@ -192,8 +186,12 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+		struct ip_ct_tcp *tcp = &ct->proto.tcp;
+
+		tcp->seen[0].td_maxwin = 0;
+		tcp->seen[1].td_maxwin = 0;
 
-		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
+		timeout = tn->timeouts[ct->proto.tcp.state];
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
@@ -211,18 +209,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
 }
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
-{
-	if (nf_ct_protonum(ct) == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
-}
-
-static void flow_offload_fixup_ct(struct nf_conn *ct)
-{
-	flow_offload_fixup_ct_state(ct);
-	flow_offload_fixup_ct_timeout(ct);
-}
-
 static void flow_offload_route_release(struct flow_offload *flow)
 {
 	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
@@ -353,6 +339,10 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
+	struct nf_conn *ct = flow->ct;
+
+	set_bit(IPS_OFFLOAD_TEARDOWN_BIT, &flow->ct->status);
+
 	rhashtable_remove_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
 			       nf_flow_offload_rhash_params);
@@ -360,12 +350,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
 
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-
 	if (nf_flow_has_expired(flow))
-		flow_offload_fixup_ct(flow->ct);
-	else
-		flow_offload_fixup_ct_timeout(flow->ct);
+		flow_offload_fixup_ct(ct);
+
+	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
+	clear_bit(IPS_OFFLOAD_TEARDOWN_BIT, &ct->status);
 
 	flow_offload_free(flow);
 }
@@ -373,8 +362,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 void flow_offload_teardown(struct flow_offload *flow)
 {
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
+	set_bit(IPS_OFFLOAD_TEARDOWN_BIT, &flow->ct->status);
 
-	flow_offload_fixup_ct_state(flow->ct);
+	flow_offload_fixup_ct(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 900d48c810a1..9cc3ea08eb3a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -295,6 +295,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 					  sizeof(_tcph), &_tcph);
 		if (unlikely(!tcph || tcph->fin || tcph->rst))
 			goto out;
+		if (unlikely(!nf_conntrack_tcp_established(ct)))
+			goto out;
 		break;
 	case IPPROTO_UDP:
 		break;
-- 
1.8.3.1

