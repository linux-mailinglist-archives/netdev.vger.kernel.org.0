Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A337D669EDA
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjAMQ5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjAMQ5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:57:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7428D3AB1D;
        Fri, 13 Jan 2023 08:57:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/fd3kjGGmgZKqGVlvsya057rbgx59tXhaMcOqFT2P9dF5QYHGNzw4GinQXug5tazgPAFfcs6SBS04nPy+2YquOBfLXa64wNynUY7fX1fec1/iY3g0ZFrrKyWrKLwXsjAkSuZJke3wCWBV9B/0TUl500dD/96d3u0C8aOH1LtkCoe6DZuoatPLw7xyZxztc4pcftpmQtcEoyck9U1/FRStIgC/E8skIRhwFCRxdrAji5vo4qIQ96q6MVAsMWO17INGhOS/D3lmEReYXoYwbraFwe+GnQxDfBG05IDDUeBgBO4si06SNd6wWzGEd97E85Lq+pY3vKBTd+hXrIL6vWfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=keKxuBxru32qQc5ia6IrqVLYkVUGNb7QmAoK9BnrUzFyCzprv3xybyq9IOx0iIAPIYjxc/f1FHW1LuFTZuxNNMNTQC5DQovVCYCXRI/j8M9bkxCvJHNV02s0LVa9/gY5N7JPDuD8EGBD9PNPIWfDAg174ZS38eJB2jS0cSss5C9APPy4F3zcl4tcKB8mex4ny03x1sjnDpTCGey0XgcCaClQmsjaHYwu6TzRf3p7ZhukKXwR9FUy8rKtKYhM/mYjKnIN2pQ65afHzJ0O9hZs/EobyIcdaHHLR/pTK4xC+Hn4DgErE2VwKBfvw6RjxZRQPezZ/XYou7WnjHUpR8tHpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLcQDuTm7f0BQbsr+DZXqTDP8Fsw23ph80Ixl7U15/8=;
 b=DXlXLO7Bmv6409z5gbpU/XwcU1vW9qtb+iCL9UoEl1bT0NObKZJMK9zOCxfZrqmtaczdhKm5Lto5xAgfaP7gQT6Nd6/Y1XNG4SyU5IrjJ6qTSrj7+HTp0MvFeuJwgdSxGyQuy2C3QZC6A/mAKt8bFtDSEXQYmR+mWMUSBR0hKrSRI5gAOi3VE8KEa1B3zqasDRMKssT4lh0adFlCMrnVRTMp+H2mQj55ei9kKJ0N4KtZYGcjN8fC9JpaKe483jOurBDx/NPGfjreLXflQZ2fFuu2ShH3C9YvFaR5/tcJ+lLuOJzRgZO73QipZhuZjD9F+RNkR3aKZ2/V7kRPGNmCgA==
Received: from DS7PR06CA0028.namprd06.prod.outlook.com (2603:10b6:8:54::33) by
 IA1PR12MB6235.namprd12.prod.outlook.com (2603:10b6:208:3e5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 16:56:59 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::e0) by DS7PR06CA0028.outlook.office365.com
 (2603:10b6:8:54::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:51 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:50 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:47 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 7/7] netfilter: nf_conntrack: allow early drop of offloaded UDP conns
Date:   Fri, 13 Jan 2023 17:55:48 +0100
Message-ID: <20230113165548.2692720-8-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|IA1PR12MB6235:EE_
X-MS-Office365-Filtering-Correlation-Id: 215b8433-3deb-44c1-ffc2-08daf5872f80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OAA6YB9elCgV6W0cgS+JAIVNw8RmMWQETD4VKpi1psmjYpIME2OB/U+CXBwO7u1lO+kAHr9OQYeMuhLJRdAPgnQwWExY58Hd85/bYSPnPVRiWONYwSAQ1reMPuX0wkF5JSyxNuXUVyCj8UzgseKtUdrBq/ndlZLJg6kZp9c1uvaYlBpIR+7v+1vMysGz6Jvl7hBZTv/mBm2iZXtPQbeL1dcprEoDC+0SeUaN1eov/2CrlY5383q9sz9f5wj6nGX2fqqT2ip2OvW5Hyq+D+hS/ja/vKNdzsetW8hC1hIAfMrdXpx+dXxeYpuEl6WaY1ZqZYcCOVtuvnsGdDbWLfIW2OWXIWGMqeL+g7TOypC8y1rJ12t7FdfsuIEhOCvl+EKruS/sLnMXLX8jCY61xDLnMmQOYe0mMiXm0JxUTtY5VtbsMezNWcxmBnxigHc7+HzOEqkXcZjzfJ3/rUixnFqA97NzT4qekXRrZCj6dN/yryLVVLcwZzLO3hqcv033cTOC6p31MSihYzdl8vlhTZeyYZJWyeY30U5VewEecYYl9SKDL1o5CpejLR1Ms9KSyi7wxn/cS9xFcYDBQO98/Gm8AQPPhjSI5xnBr6MGZBMfuLmcaFpKfPF/WD3E4elUOnOuNN4W6sYq+NXs5i9SITmrWXrnDN7OP7D0Rj/drrrIrejHm0OPROginssR5DmA9nHsZKSD7tZmaposYbwCs5aX0KrYHZFz7r8xvNSWjbFK3bg=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(2906002)(107886003)(26005)(7696005)(478600001)(186003)(8676002)(40480700001)(83380400001)(2616005)(70586007)(110136005)(36756003)(1076003)(316002)(54906003)(336012)(70206006)(40460700003)(47076005)(426003)(4326008)(41300700001)(82740400003)(7416002)(7636003)(86362001)(36860700001)(82310400005)(8936002)(5660300002)(356005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:59.1313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 215b8433-3deb-44c1-ffc2-08daf5872f80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6235
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

