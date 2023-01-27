Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5199C67EDBD
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbjA0SkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbjA0Sju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EB012F28;
        Fri, 27 Jan 2023 10:39:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kF8sUv88TnBAN7X8tTWI5NGok0Y4Kl1ea/D9n/dfkCfFIGiIsF5JzXqQLxsOb7y9NIL4AIiwPeJmSOM/LQv053Pj1M57DLJ3P2fi/KaGq5Q3tdpGlLU6N1p2hXVzBqjG83sjj+B1cloXs8ITbRzUNpi/NbME5+dM9QMjrvYm5N1DettCCAPBn9eTaqAj8tTXGoRg2pMi/kXYq/rnwVll09vtU6/Tg3JbUFABmS/9c0Jsrmg6/LYMGVf1Ndg8bhsR5a+6uPXHXHIIPQjathwQwM9GEef0iepe8nYd3HuLC/qTiEVNsqLxk0VOJ7XKGAuw0M6wbdhbb/4CI5KT1A7a+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=ZUkPj60lu2f/aZMXgUedUI/pngrCWP3tmmp+7dRkf8YrINeU9ZkTYHgRMNzEhmqAtip8w4Nq7oftZYWc3Cu4hoxARCcQ/mbBrUJigs/tobstcWmuFsPUp9TESR3nV9b6K73Ha8PZbojbSkKfkZpWd2OIAt4w1j2BmQNgyXtvrhk2ConLBhopA1FVI/Pi0EPZ6VHZzpWDtcHwWHA48a42njDqCaqJUVwh7m0tTF9l6icIz1puv+V2BgTi9TnR2d65dZCC8irOpVQxTN4lhnq2HmFg0pbyebvMOQfczy/pYZzEgQ1aGSI2DebidTwdWcK3AbsPnlnV9VvLJU/ezCtStg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=pO47+3wDP+A/dL8KjBR/ihEhfsy/7sZkC2xMMagUXZqRNzd97KngISq309SwL9OCGGD7/c3lStUJIO9LNmvklAY3c0JwJLfCr6nop8tG9xL4OYo8pxptGnYUt2bO97R2kCV94rZEs7j8jrJt/5wbIWOnaiyL1bEST19xQAYrbycF72GK71rVUdUhu7jHXYG2iuDatPWZ20txp4pzhwAtul87H8RIEDB2GVVX4r77Gvjka9EA9Zzm13xzlpV5tarHTKvUm2waH2sUZMTqyHH48Hh9dO2VwoGr8xWvOBKiwEdL2ooGNDzAuCiO7mvqcAgyEAx+6AwR8BEdY3NJ306B5w==
Received: from CY5PR10CA0029.namprd10.prod.outlook.com (2603:10b6:930:1c::27)
 by PH8PR12MB6795.namprd12.prod.outlook.com (2603:10b6:510:1c6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:39:32 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:1c:cafe::1a) by CY5PR10CA0029.outlook.office365.com
 (2603:10b6:930:1c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Fri, 27 Jan 2023 18:39:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:26 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:25 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:39:22 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
Date:   Fri, 27 Jan 2023 19:38:45 +0100
Message-ID: <20230127183845.597861-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|PH8PR12MB6795:EE_
X-MS-Office365-Filtering-Correlation-Id: b034ad7c-a3ab-4792-ea22-08db0095d4f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EngVKwAWIjaGdNsM7L3Cmlvqeh/84NFSZCClw0QNujtuppYGIldVoLiSTAGkZYZ4B+CZJVNQU4ViUPZWiAhifbDVv+9D5mxhTkZBQN5yuQgVJoTzf8CU8uUw7N/x/6bqIfJlyNjNH6riG5z0GkFhpFc40EUTjWY6tjEiEX7vja2jqBW/Y046SkaX+WaOKyW9573Lq/DiXip02ByTV7Q+bIgNogoehwxzCPEiv4fl7IDE4HqX9EFrEQa11EsmCpwS2gcaOI2o1tTDxsVppBztD8npM+YvQ+eDgxigMeBSJxWV3JqFe/KaCll+AACBxbluNs3xhsCltyHhiPxKEBZWPLxKS4pc7SwJkN3wu9RtUjDhj2D03FjRj9/mvpgbuSTpA8xEjFUSaWRf48yX/qbaJfimd+rYnYTfvJYywbtfq2VlFmHZB67iWLd1/tffIIdqKhh8JvZJRJ0ErHvCjKD01EKEvk49Wfz5YxkOPCMPM+WF1WAjArzzOh8UTsSp6SNHqiaorP52rs+WQZohD4VdNVQCViJnCcc+IvBu+evzDOD6j8HgHWdw6QnOR3PlYlqosOgOhqL3sHZfsm3h1m6Vxv5bGD0UPkZEFtfjnf0bd2v27CCa34TTfMUmTCt3Wgw9yxh/YM+xUr8fFIWO8Eu0aIS/bObM/sbcYmOwSGjRlweNcq4Hx9YwkxBeulVtKqxZ0/wfgBabHLpev6FqOhzaGAG13AUCi5JYUJcDt8+4yx0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(36756003)(86362001)(82740400003)(82310400005)(41300700001)(2906002)(316002)(83380400001)(47076005)(426003)(6666004)(107886003)(110136005)(26005)(8936002)(7696005)(54906003)(336012)(7416002)(40480700001)(186003)(5660300002)(478600001)(2616005)(356005)(1076003)(70586007)(36860700001)(7636003)(70206006)(8676002)(4326008)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:32.4911
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b034ad7c-a3ab-4792-ea22-08db0095d4f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6795
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

