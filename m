Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5083679B0F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbjAXOEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbjAXOEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:04:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73449166F4;
        Tue, 24 Jan 2023 06:03:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bOKHN7G9BTK1GskV3FNEzd/oDZ0dbISqg+wP29pMwzeK0/BqsK1pgznb1mjOLuP1IjGlcb/wcbbCH1hpbLlrmtoALcC7XTtQ0+o1GkBldNakG2oN/JantovAIWq1ds5GqzDsy8OfZ6kao4wfT+gTXHH6D9gfR+aOiJ55Viv6e1XIv7EUuUR3tGX/9xZmRAWGxuugCVpasCUi49Qs2yij4jsdE95hKZCMahC/Eh0Usvb0bByOUzsJts2o+71RgMzScg5+TzAhWqFPxH3MhO/QR5xlUfNPsAZjk1pr4I9Fm1K+3BIYE/Uka3vKZPXt2YCZsbEtvL1TSRdAbQqvltmY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=V3Ib0n8cimV+9C88QEcc+spydU5xnjmmMVtsXA3M34KiawgCIaeqGnhModghoffVSgjMmybAu6NZdrw75xj4EPVyWnfa/RIWvVddaHMKTXR7E6dorUlJyrRO3pgnDK8cMYyN2Zp1Frm9jqzUwne7ESaZsfY+Mv0H0ZEZuRoTdi2YJbrUEY7ls2XDD2o+ekQdTf6aEPKZwgfikINjzvJj53+bJRUbeYK1ML7C9fG65XFps3PJFpbZRHA4sDPaN3x+5P/0uAKv4JJt4rL7ohW6A6gvQlEXgYS/gm1LuwVL6v5qniMQLFGvo0jUB3bTswC6rsP3DoLTdKRk7OSfpNq7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=oz06saRn7xf1dRi+BZWsOFAWD2WjzqzgYE4IvmYQ+kPYR4bVLXOHZwmdvwLbLiavGiBgFNA3CbnIjevencL9UT975lEe8aRPSBE+Sy2WeW3YKVnYmQd5t0WBlhQWQRVrOSKKO63Q6P+eg2yBhF4TKADQlbSOQ+H7tdNPJ7QpHc0sJU/fJ91eu6d5nL9ZHskloQTc4LdOjimD3uABh2tg/YDQ1On/m9go8Geoc4abewkgfZiDSDFq7sYJpO37NVzuL7o4FvQy/m6t+1tyuFVs13YOoz2gdy6i1ErYC+V8sgioY4GuIbi44bmL7fa83hvJiM4B9jpEpQO02Rg6HDte+A==
Received: from BN9PR03CA0254.namprd03.prod.outlook.com (2603:10b6:408:ff::19)
 by SJ0PR12MB5456.namprd12.prod.outlook.com (2603:10b6:a03:3ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:37 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::23) by BN9PR03CA0254.outlook.office365.com
 (2603:10b6:408:ff::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:36 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:16 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:15 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:03:12 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
Date:   Tue, 24 Jan 2023 15:02:07 +0100
Message-ID: <20230124140207.3975283-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|SJ0PR12MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: 48a9ff5e-590e-48d1-ba67-08dafe13c98f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDn0/USuMWwHYIPJZLAhPhu0Aa9zDFhSx1H+TvAu2OU0zwpTEmMobZuOgpqlVUcerL4kPR0BYz1UT9gjWJzJLSXzsZ/F91n+Izn0t7rBX1OCyTXOzVBBqzJBY3jsdFXKh4KDI3/EWmgwBuhokB6j+5VCwuNjzCNz8QuzrfJJtN7itC7NaMFPgyaa75XQVOx9wjI8qjt6EsvtKWL/ep2HS/MmYfL8mdP+tJ/1Td6DmJgkMoN7x5XzLHItjLT5xffgWTeSbY9Sxs1durwPryU+oaCBEjeUyGsODAJYYvKgDu/XUPaE+OuRRi0XkjqfdCitlcBCeXc8WWTZOtO9hJqm61gI0UtyM70LKA/pPsjf4+gfo23wkj3GZMPQv3LMb1yBCh9CCPq2kUGkZ76MX3HKS94G1059Z2KLxNxqpxNy/72zbTpSqhlmTEfstaJcrJmnt/CmEE1trGM1ENLiEdYo1niB0ZGzAUa7ZPxgfMnY3vrZAkXoX+aQA4guQr6a9oTKaM/iXrC8EEnO6fQDmBIxLy4vxxH8FY4HHLJIR5gOHXOOR/gFnKQ4thisHSUK1dfomM8VQALP/92vFNojyt/1E1rzpBRqGhg9cMf26OHgSGmYCrpgpYsdEDTM/su4nSWrnk9Bsb9A0UEuGld07a8DSZ3YquPCec5uYE6saveWEoT3341RNit8euclfjkoew3mXXxV3w6TU/MJowA3uavb2Mbugyb7G0LSxgPKPR10Y9Y=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(36860700001)(4326008)(83380400001)(41300700001)(5660300002)(8936002)(7636003)(86362001)(356005)(2906002)(82740400003)(7416002)(82310400005)(40480700001)(40460700003)(316002)(8676002)(26005)(6666004)(47076005)(426003)(107886003)(336012)(1076003)(70206006)(70586007)(54906003)(2616005)(7696005)(186003)(110136005)(478600001)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:36.3788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a9ff5e-590e-48d1-ba67-08dafe13c98f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5456
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

