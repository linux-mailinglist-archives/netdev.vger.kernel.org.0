Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2752F686BCD
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjBAQcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbjBAQcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:32:10 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC57922A;
        Wed,  1 Feb 2023 08:31:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YA4bP2aVODnw9s5Jy5vdZgn7733aoTc7PheUGfYIG/4U6J4FXTBhgNGmAiTIOhIMZLCqYKnDjfE6BkNkIG8Dvm6Sjl04gdlBK1v85XeiLLvyI3X5KGlEtTeVUDMfjaE2UQfE9thM+jSJ+pC31mQWtfvUZevRwprpSFf2wIpMLDhpdybTJEqMUu9TLbl6w+CENIAoSjJSSCoaoUB0rZdFVI3GfnaPooYl6c/FbXJe+E7eKBtCs+sh8Jo4tZjJvbeIfiY339tkVqKzRuEwquzIqjFs3E24NzqLZVV09wCKQmMwbAdxv7Rog3h5PoabjO1dVjK18Pv4atCAsgdysTxJOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=NeYEAPRRxUjQCkHroczDUzqvgxxrqURrciP5J1vLD/n3yMfW+WwjYF5DnNwvZcwXtZzYJeYpb9s/Pcxk6BlZ687408r4nYnJXr8QNe2LWIQgFElq95/uxC+phTTknxWjR1GQiP9yG/DjkBkAKIrZMILH2m7E7GhGCxPfZz96Tae90xGyDrYSpp4vVJG3PsUHmWTUyRhxWS8RnKhgsxRBLQavQmonSRydcP35Eli60sJRwg+yzfc1pTgzkbq0u6j8sK2Zmm3AydQZERncReZssT3li6wWEb/XKV7gsev/vuCf3oYflTAzkvCIlfGPRHWaoobSrRObipBOVpsVVYBLhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=FCHFAA3jYDjiweyabkfa2B7OAOdYpO1k+3BH77X2tXtqkzGeOYLqKS4CTb17bJvBAQEQPY3/diCWuZ0KafFzxUQQeXCmu3LleFg1lEQSFZIzr2wDr1oJ7TRMqJD/o9Hi4CgWJyW/u8UjmQpHCTwjA/rBhJKdVlF78Gg4Vr9C4BJupQ1uJoQjrTGt0Ja1h8c1iNuBPb6+8UoitgPxO/eEHixZPEBPObAwH81mawzQ8gzDN3z5BeeD6vLWftnxjnqcXqcO+qGs/mNr5MgkzxJubMoakh41ovVUpjj21OPxWbtiqwUFkqOnapjblsvJvNrMu4A8tAg8zb5Yw0K1PWeIng==
Received: from MW4PR03CA0250.namprd03.prod.outlook.com (2603:10b6:303:b4::15)
 by LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:31:52 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::e2) by MW4PR03CA0250.outlook.office365.com
 (2603:10b6:303:b4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Wed, 1 Feb 2023 16:31:52 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:43 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:42 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:39 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
Date:   Wed, 1 Feb 2023 17:31:00 +0100
Message-ID: <20230201163100.1001180-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|LV2PR12MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d3fb77-f093-472c-955f-08db0471d33d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWskWV++lYTLuDiw6aXJBlaxsGGx0lschae229+gFzQ+a+MVTP64pFeAGYcEo15QM/SPbk2bYAXdecIVatgcaPyT65rw+NTRML8T05lAAsvPykHeyr5pzxgqacd0jt0jNni5bIl4xkCdHG/FKoUD8V3R0JhotVgWzhOTA59jjMkgGmOhZUoNXyiO7QW+ExYpOiz9DC6OsJMnFoPxwJFAjyBGLhK1ysdEq7Vg+44Qhea8FncaQl6R59kXOIo/JviU2n7PryJstilQpneQ+Qeue6GP1CyQEJNnyYb0MeEgkXNtnZG5nueBlGpSk/gOCzyJCPedinzwejFR8Wr/0bfOnH7xFr0ODJuTVE9Ar4M65ZnEInSEQriTFNy2KCcZpip6ml2J2x9GC9yZtzBoCMUVk93yzIYTAYqOu2EIRF3keUnB7zY0yo6sk27vGDYUbstT/OCuhjsRoPH2kPeCeMUW/bCA3WWZxXynOjiijsEBssWKCA2dZCHjhLU82box0G9ZteE3vPZ303L2Gdru19oYUQ03pqIIY7f+acEIyZwFteYKn0g/k28zDoV8Ye+Sj9UZkceE/xF4q8sBbXROioKtwiaRs4/tSwVHMiRJGenvcJ8CvgbNa61jLimcwSoMIxVxiXAzMcdz4rGwudkVCIwSMuV2PqzjmKPFGfS/9EthIgDKwO75hja+cZjZiYdLyuBS+CNEBBBTKMBQUbWNNHrwpejr1vgW/khE1XPhsGgyaRzZT2zsyq7fa5hXq0ssqexQwScggE/Y3rKqK1JZ1cdT5Q==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199018)(46966006)(36840700001)(40470700004)(6666004)(41300700001)(336012)(316002)(5660300002)(86362001)(8936002)(7696005)(36756003)(40480700001)(83380400001)(82310400005)(8676002)(7416002)(54906003)(47076005)(110136005)(4326008)(70586007)(426003)(70206006)(478600001)(2616005)(186003)(107886003)(82740400003)(26005)(1076003)(40460700003)(7636003)(36860700001)(356005)(2906002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:52.4120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d3fb77-f093-472c-955f-08db0471d33d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both synchronous early drop algorithm and asynchronous gc worker completely
ignore connections with IPS_OFFLOAD_BIT status bit set. With new
functionality that enabled UDP NEW connection offload in action CT
malicious user can flood the conntrack table with offloaded UDP connections
by just sending a single packet per 5tuple because such connections can no
longer be deleted by early drop algorithm.

To mitigate the issue allow both early drop and gc to consider offloaded
UDP connections for deletion.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/netfilter/nf_conntrack_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 496c4920505b..52b824a60176 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1374,9 +1374,6 @@ static unsigned int early_drop_list(struct net *net,
 	hlist_nulls_for_each_entry_rcu(h, n, head, hnnode) {
 		tmp = nf_ct_tuplehash_to_ctrack(h);
 
-		if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
-			continue;
-
 		if (nf_ct_is_expired(tmp)) {
 			nf_ct_gc_expired(tmp);
 			continue;
@@ -1446,11 +1443,14 @@ static bool gc_worker_skip_ct(const struct nf_conn *ct)
 static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	u8 protonum = nf_ct_protonum(ct);
 
+	if (test_bit(IPS_OFFLOAD_BIT, &ct->status) && protonum != IPPROTO_UDP)
+		return false;
 	if (!test_bit(IPS_ASSURED_BIT, &ct->status))
 		return true;
 
-	l4proto = nf_ct_l4proto_find(nf_ct_protonum(ct));
+	l4proto = nf_ct_l4proto_find(protonum);
 	if (l4proto->can_early_drop && l4proto->can_early_drop(ct))
 		return true;
 
@@ -1507,7 +1507,8 @@ static void gc_worker(struct work_struct *work)
 
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
 				nf_ct_offload_timeout(tmp);
-				continue;
+				if (!nf_conntrack_max95)
+					continue;
 			}
 
 			if (expired_count > GC_SCAN_EXPIRED_MAX) {
-- 
2.38.1

