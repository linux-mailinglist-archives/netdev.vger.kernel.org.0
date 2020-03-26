Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4E51938BB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgCZGil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:41 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727683AbgCZGij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQ+0P6hhsX91JyMqaYm3CcR+szqYFQQ+MwfxEdnT3f2h5IK0ZFBbo7tgz8nqJK0cpiFs8uqDbk/mKW09eZ47YJekn0rGyksA2vHwUvqfx7FcWI4gtMx0igX3AXupXkeulRsIvDb9pZGFiBrhjchWI0a1CoVBq8TlO0F88vwjX+rU9qLg8ZF4VUTZ0lchFPxKVM9SFus5glwFoKD7w/67ZvbdUhBNtMCF2mUxZTisbPiiEMnI3RDN1aNMZoStVvyuw//WLZbivHZAzbhsuSd6YSy4XTjLTnoiqYctTg0oW8SgLbDHxa5BphW9kB6e3A2bF8+cPSxcLdHxnTfpSiEVdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb57oRtK9EQghMGG+s/3k4PTZcyfPh5B9PBSecITJQg=;
 b=LPfTcVkX4gjYF+MZpVObrpwDScGXVA7ckH2pVJndof/sLI3uj/Qm2msCC5F/xWYZQdC3aPRybGAc9yXuEZuw7rhJuPruHFwroeH/HQfr1wL+FbI5Rk5dPSnqRMAPMtHU2XBowMatHDlMhZvEkKWAi1Dvc1nzLhfMspooulDgZRi+AdGAz7mEoK0SvrLrIf2O8CzyU72Pls6s0i7nVW8DK9wrW+u3L8MkbB6DFm7qDurJMt+XeJYVPRY0xR8FTz6M5PB55gn6kEUdqaWENYDFp7Vng1h3w2k4DK7sP1T75AHIvb5dycjgZTWNa3RhzTddWelyRFLeVKhH//uYP+vCXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb57oRtK9EQghMGG+s/3k4PTZcyfPh5B9PBSecITJQg=;
 b=gfWqFj797P50X07L+My/cpNOcglfdlJDlnfKWBNpSKHin/dDNZGwxummn9kUnuGzD09bSQXfBaBwSO9VGPocgwZO1m80tF0YylelFg8h2e78cm4ysLtMlXezTgW4oLpywi8sW2Je9e05DHw7RXvKEys6NPNJV2IacT/9RSJ2aRY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/16] net/mlx5: E-Switch, Enable restore table only if reg_c1 is supported
Date:   Wed, 25 Mar 2020 23:37:56 -0700
Message-Id: <20200326063809.139919-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:33 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77a7033d-79ac-4243-0bbd-08d7d1504f28
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64793F39111EE85F3E40F85ABECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpjO4C79mMKo0HUCP6HBQJG20q7/XwgovzXiAUxx8ED7R+xx/oY2jf3msqplImmrsgNAlzve+hAnCrdJVQl4noDV2qmwBpzQ0BADAJWSpNSQLASjay9fRWoZvU9cT1FvvV5J8dmoAVm0WRd1cA1E0YLFQAY+0D06S1XyI61ufj+T9VvXOTdgWJh6fXBosUS+IyReTGl6YBzBD7wVx6U9MRcwLcobz6cOfvIgdUFtUmsSk1YrD3ouvufbolAZnsQsuuxgjaJ6zmiec65cnYUrnmFOCePc/z6Zpg3pwn1u6mtzwYKzCxHUi2Bpt89UXDDxZMNcfcBT8lz7DobnQM14Wdyiwk6F6HHAfNn8q8q/AV8B/jvlFNoTlXaptpJfXoATrv//kX50UqEKDNpjpFA3RSP5aGMzLldtofWaJqCaDZYH1mSP7k2HZOgB+nNQawzq+Rp68vZ3X6YnBza3kzSU6VolhrOytoFPznuGQK8FA5g/cDkqSk7F96W9ic2hZVKd
X-MS-Exchange-AntiSpam-MessageData: YwbQ2WEOFdf5RwYpokegKXHLKmhyuNG9SjrjpWCxRi60bkS6cycwRyB+Cno+qbNDpbiWTzNKBUdXkd3S1ET6Og5DSPoGB1GAqCJbETbd/EVL0ZZt3q8gEZ/mwwxCqYDwTfdqurSAul0IoCbtN+kyWg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a7033d-79ac-4243-0bbd-08d7d1504f28
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:36.0343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbkXmT4+HrsfZ0YC00cpI7ym392QZdW9YwHilnlY2avBBh/bs2FSVi1TFc/h5suyLnGt4nkA0iOhREEieM5M0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Reg c0/c1 matching, rewrite of regs c0/c1, and copy header of regs c1,B
is needed for the restore table to function, might not be supported by
firmware, and creation of the restore table or the copy header will
fail.

Check reg_c1 loopback support, as firmware which supports this,
should have all of the above.

Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0b4b43ebae9a..cba95890f173 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1069,6 +1069,9 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 	struct mlx5_flow_spec *spec;
 	void *misc;
 
+	if (!mlx5_eswitch_reg_c1_loopback_supported(esw))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return ERR_PTR(-ENOMEM);
@@ -1477,6 +1480,9 @@ static void esw_destroy_restore_table(struct mlx5_eswitch *esw)
 {
 	struct mlx5_esw_offload *offloads = &esw->offloads;
 
+	if (!mlx5_eswitch_reg_c1_loopback_supported(esw))
+		return;
+
 	mlx5_modify_header_dealloc(esw->dev, offloads->restore_copy_hdr_id);
 	mlx5_destroy_flow_group(offloads->restore_group);
 	mlx5_destroy_flow_table(offloads->ft_offloads_restore);
@@ -1496,6 +1502,9 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 	u32 *flow_group_in;
 	int err = 0;
 
+	if (!mlx5_eswitch_reg_c1_loopback_supported(esw))
+		return 0;
+
 	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_OFFLOADS);
 	if (!ns) {
 		esw_warn(esw->dev, "Failed to get offloads flow namespace\n");
-- 
2.25.1

