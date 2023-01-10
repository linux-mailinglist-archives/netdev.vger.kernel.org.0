Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33A16641EF
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbjAJNcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238564AbjAJNbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:46 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A9B395EE;
        Tue, 10 Jan 2023 05:31:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KR2egUJ2sUhjaPsaycKFfm5vPuEj63oS/qINYjdixh7WBrxUsVzjq69ZpuMjIF2+xNp+87z3vsPeprnvyeGsJkpOFQGKiQm+Qlia//idY/flinOQquI3Rt5oPNnXu9VX1JaYeoJHgq3ngdMeEhnaCUBcGXdd3S3GR72JHzmPzQI33uu6/jrT3vDSU1B1oLE9EdWiJlQ0/p9NZNaqJxkj9XT4psiBmgbFGQDGidnMxCdFupbnph/+FR+oG30zQ82W7YPZ8IcatdIUpJm+9NdABegK4Jm2GehceTMlHIMo8pOZZaS4Yt8LaarkzzVSv2ZqLxF+t9N9qouLd+nY76vkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=geTTWUTIV+v2uahBK7gHliXpeFOQSO+6GqBO0jmkcXc/Vv9sGxJFu168E9z3xTfd3g/5K1tDhgLinoVcWh/YuReUmyqUxmOhjKcly+Jn6nwjVaFuo6vBZeUx6dlCHV8PNQgIAFBufPMWXc1ZgIeqhxOqq5oBfdfmoRxHxzfZS4WF5yU15qgZUDlC/xkHzWf/BM+v377vCRmuRi3CRy+STxmaPx9zV0g3CGuNaFw5mBu6O+MSwl7Puj25O4+A19r2TZYk8DJmTF30p91mSOon9KEB++aLRUQn+Cs59g4DSKp56xpNaXsC6L7wTNjIM81lb9HrYZIuYAHRQZ4Cot+KPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=gfoPIMDd7z/T7Aq2giIUx7DtSB4X5Ac+5lDHqPTaO9fX5hxQ+x61BCMgFAfDgaTT3/opzWAv3oNx4HCYtom1xC0PSYYEUR7qd1Vz59nYuZs5f85nP4EsGQMld0PlYWPWK/UvsFgsXDmE0c5bCcO6YNOV9ATtAsp9Ph1EJKfaM86ic+EEThdgsFSqIwbQN7bpE24D8pQJNw44Aq3T3cnk7aP/FNfIm0+3Fg/yRlji6HcVerqpJumNtJ4yX/d5G5RGX24nLDoc2tf8E8PYFtpdybD3Cy9N27YM8fxxvUJjSqy03pFaX6wb83cX0lc9pFNu+y20IT/vI1N8oCf3kM1FGQ==
Received: from DS7PR05CA0069.namprd05.prod.outlook.com (2603:10b6:8:57::21) by
 SJ0PR12MB8166.namprd12.prod.outlook.com (2603:10b6:a03:4e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:41 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::2a) by DS7PR05CA0069.outlook.office365.com
 (2603:10b6:8:57::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 13:31:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:24 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:24 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:31:21 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
Date:   Tue, 10 Jan 2023 14:30:23 +0100
Message-ID: <20230110133023.2366381-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT011:EE_|SJ0PR12MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab66c2c-280d-465e-7998-08daf30f01d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LY9Zpw5FBqU+8lLXqNhzbU3pLBJmItt2356MoFq4fxpMz9DoxY6QkEoZszoI1/IXpBlzXgl8sYUcAqF36VP6dRM1q+eodpLt0HPYRJ7nWXAdiqHEGFYmczqKzb54skKeHE9MU9T6mPnrdtBQ3PiqaUnMggX6BJYDQfyVhGWrfDR0ylw+3PRMDDTK82g44pX2xa7F6l855e4Cnso/ZYzXPSaFfial1yC/8Ce+Y23a2ljarQKucE4GcRaCyir22goWTpK1VQH2wF0Pnj3aCWQHOPupQUTmtZ9szC0BC1ZtUSpU3GFguB1elrU8GwNztpHX1Et2dPYTykYabcvAKfvl32kkk2Z1jLp2fqOz3DohoQxBwluhbD+Pu4buOZLBjImWGLJEPn33VbfjurF93ZN6WVhrISJTpOMriMuJKi9s2ldNN7rQ+uHonofVERdBiD9INenJMzRZZ0wquHVgH5n60VGfSaD3YgvIYDZ3G8kkSljtAqP/EP2ZvdVwf5caC5xrzlFDPN1LYaWyHpGuyYBVMOpFnDZJLUCYpUcKzskKzpG4Iag/QclbFYJIyW4B7KIfpyxnYDHHWj3EKd32lttrQOKiltDVM+28yBzRG3Phr/iSvgdYOr0RdqyljHgeJpP5GrXQdDD1wXncJ27TussyWh0Sk29H6pnc9mWvp0iUc4/HEWfrgD/XvVhcMGrmiIPCR6yvB0vmvDMWrswCV+LI9J4JjUZEGfG43zUeqWZJ4zc=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(82310400005)(47076005)(83380400001)(336012)(36860700001)(426003)(2616005)(1076003)(7696005)(7416002)(5660300002)(40480700001)(107886003)(8936002)(26005)(186003)(36756003)(478600001)(7636003)(70586007)(110136005)(70206006)(54906003)(8676002)(41300700001)(356005)(86362001)(4326008)(316002)(40460700003)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:40.5348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab66c2c-280d-465e-7998-08daf30f01d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8166
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

