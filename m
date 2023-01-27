Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AF767EDB3
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbjA0Sj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235078AbjA0SjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A24655A0;
        Fri, 27 Jan 2023 10:39:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V55jzXPuRdDoXlr7878pnX5Ho8WBvkBkEIDwEJ2Iv6k3UKMej6xYx45/ACWVi1DxKHZ2/CAM7mfMsjCOZhtFbzpj3R+rWit9qZ5YUrZUmF1TZhrZS7CX9WHmzU5HKdqmchwES2pfnqkhxPOMmHcTDnlRirBFt3UgBcE8B1JOOvmqnwS7Ezp0xS4TemIycF4wiRGMKFXDw17EbmcwDn6EL5KWSbxnPaof25VF7Ovu7Idhs1Kkl0ocv5ohl5erha0aLPqz9H+dmE5lJ0sC2dwV0k9V1nBk8ra500xpsvYY8spfAaEanqsVDeizyjFx1pLud+ypcHrbmZjG8bUEW347yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yCSI090vdvvgrXiokyByxwXHMggpZF2LwKEnNUtykU=;
 b=DYP/6EmZdYcH1c8NK44i/UTwwz8ouS+9FBDz7xHv4tF28A1fPXgl3L7En1d57ewmcAQszpnQjgoC96FMO0Vh3b9FyrYLOEZIzJ43ZseLMKx5xTDEX1L0D020KWtBE02FSPSu/ByOn2rU/C1USz2hfFWZ12AHiMFsDsKe/LO62ucOP2BrpuqC7vAOOfabLA7+4ZBocMaOJU754xnnrLvFAhEUKlkYVVim90sGKMbLhtZmgpDSKZZuPhHwN3+qEEzW7RrM4TXKsNVr5RHV0g44yYfKjCEKMz0scvLFLWAfJ8XK2LjgEMRA9mO5pbIKSKHWTqBaPBuuLVjSVMTGDh5Pgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yCSI090vdvvgrXiokyByxwXHMggpZF2LwKEnNUtykU=;
 b=pQ8DBLyFFJUTlCYGbdP7DDntL5BV1MhXHm2EmpMckV3ihmQww4xxle0KP+jK9Qybd5Yhsrm/HxVTuaoijjBsLf3HHkxtN8KoNI/WNQvD/6N9S11Lxh8ytbAw/dP03oKEOlaRs8UV4hLD108jBfuPczrMHp6uosX0KU20NClezMoymw31lE/AnoDerKREZLoRMLadrUhIqfsUQYS/egz/FzQR0CL59jqDQjrbPW93qZ+7Q05IpK4vKoJQiEXLOW5538W7jKYCLO3k9wWtzFkMALBM9LNbS5PE0Va6LKRySIZPVbFZ9E3QYLPAwhki5UDP63OQpOlZCPVF/3aDZwjgpg==
Received: from BN0PR02CA0058.namprd02.prod.outlook.com (2603:10b6:408:e5::33)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:39:10 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::76) by BN0PR02CA0058.outlook.office365.com
 (2603:10b6:408:e5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 18:39:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:02 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:02 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:38:59 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 1/7] net: flow_offload: provision conntrack info in ct_metadata
Date:   Fri, 27 Jan 2023 19:38:39 +0100
Message-ID: <20230127183845.597861-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: a78e6e38-b0d9-456c-095f-08db0095c801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K94/puq9VsuS6BNzX/QimMqo5+pBBMa8wF/BCydHz+fc+UNHU57RdnSE6vsw2JNv9cegheYlrzEOtROeD6vlbQobmudk8hqwXrIa4K1X3pD/qGnbhV/+Aj8CGA0VoIk4KC93HgU8a/q6j6PUBSgQsebBn0tRswVpsyRPWPWbKqKHMy661U8kYwmL6c5cbt+P0rQRmY6h9Jyj+G7mmSDXjHJMMzjuv1+NK1Cg6t6t/yhsYCs1cDmZcb681BESa7CIHeUeCd6A6GCIsAewmcQEruOjinG0M0dM1/irRyZsjnXqKln7QaTlDw5UCmLX8EjcEBiMGRLsx/1XRDEU7e+LdB/2R5z8blB+91pfKG+N+KWEWXRF0QSy9avPw1sLbjMN1O6UF51ip5Yn/poYQrZpigJkdRm2bU2cv8/W2C/ONvpleG1XyXTaD+g+QrA8beztqPeF+m0jSm2Md7Qbnq0YKvoux7aLI72V4XGDIRHC3AJHTMQZd+wc6K8VBTgUY61bMgyeBF8FMo11NHK4UeJ5cmNfJMOrLXbYbaKjX5cQauafanx59nhgkTlRT0WADg6gqUIuyDqQqswV73cuEQTT17kNscsjRBCSLS4JuR0hacJabgRBJRvVxrrBWL5tM3tagSk7F+W4AmPfnjgLGjCKYXsssRdEcJYk7IXRXHsk3XQQbTYW/fCdVrlaqHhCRi1veaICoynci5QRPjYloPjHpgaK1YIQgA29Ycbb2T7XyQk=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(36756003)(7696005)(8676002)(1076003)(86362001)(6666004)(54906003)(107886003)(316002)(110136005)(5660300002)(478600001)(7416002)(2906002)(4326008)(82740400003)(70206006)(70586007)(41300700001)(7636003)(36860700001)(40480700001)(356005)(186003)(82310400005)(2616005)(336012)(426003)(8936002)(26005)(47076005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:10.6664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a78e6e38-b0d9-456c-095f-08db0095c801
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to offload connections in other states besides "established" the
driver offload callbacks need to have access to connection conntrack info.
Flow offload intermediate representation data structure already contains
that data encoded in 'cookie' field, so just reuse it in the drivers.

Reject offloading IP_CT_NEW connections for now by returning an error in
relevant driver callbacks based on value of ctinfo. Support for offloading
such connections will need to be added to the drivers afterwards.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V3 -> V4:
    
    - Only obtain ctinfo in mlx5 after checking the meta action pointer.
    
    Changes V2 -> V3:
    
    - Reuse existing meta action 'cookie' field to obtain ctinfo instead of
    introducing a new field as suggested by Marcelo.
    
    Changes V1 -> V2:
    
    - Add missing include that caused compilation errors on certain configs.
    
    - Change naming in nfp driver as suggested by Simon and Baowen.

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 ++++
 .../ethernet/netronome/nfp/flower/conntrack.c | 24 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 313df8232db7..193562c14c44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1073,12 +1073,16 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
 	struct flow_action_entry *meta_action;
 	unsigned long cookie = flow->cookie;
+	enum ip_conntrack_info ctinfo;
 	struct mlx5_ct_entry *entry;
 	int err;
 
 	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
 	if (!meta_action)
 		return -EOPNOTSUPP;
+	ctinfo = meta_action->ct_metadata.cookie & NFCT_INFOMASK;
+	if (ctinfo == IP_CT_NEW)
+		return -EOPNOTSUPP;
 
 	spin_lock_bh(&ct_priv->ht_lock);
 	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index f693119541d5..d23830b5bcb8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1964,6 +1964,27 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
 	return 0;
 }
 
+static bool
+nfp_fl_ct_offload_nft_supported(struct flow_cls_offload *flow)
+{
+	struct flow_rule *flow_rule = flow->rule;
+	struct flow_action *flow_action =
+		&flow_rule->action;
+	struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id == FLOW_ACTION_CT_METADATA) {
+			enum ip_conntrack_info ctinfo =
+				act->ct_metadata.cookie & NFCT_INFOMASK;
+
+			return ctinfo != IP_CT_NEW;
+		}
+	}
+
+	return false;
+}
+
 static int
 nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
 {
@@ -1976,6 +1997,9 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 	extack = flow->common.extack;
 	switch (flow->command) {
 	case FLOW_CLS_REPLACE:
+		if (!nfp_fl_ct_offload_nft_supported(flow))
+			return -EOPNOTSUPP;
+
 		/* Netfilter can request offload multiple times for the same
 		 * flow - protect against adding duplicates.
 		 */
-- 
2.38.1

