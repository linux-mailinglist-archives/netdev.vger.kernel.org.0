Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC11BEC37
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgD2Wz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:26 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726921AbgD2WzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFaxs+nHBb1AlIwJ2CaoNITP8yAt0NT8/iFh+1YFwbO70OMH7un/IU2qCAk5HQNuMMBzV2oMfnwf2LH9nvbc8FFa2hkPNO3AnWhXGvXxinijwSdPWx6yLn7RSK/UUQuqxjgbndSwcs26GvwFHAuC7eexYlYlB2NG7pR/qmruUOJH6ZQIWOLtVTEHe9JMwwFAsv4Q10TJi+rGn2mKcNaJBAe/QA1SUkV2MTaxCCxCzl5iFxngHzYAg5Fa6+UyDnhBuybUtopztZK5xi4S+PFJYQ81EUzkdckzSdE2pDc482lEFMKJi5qfSHrLGT9oQbfAjTO+S3J8ybDO3xvHjVT5nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnnRGl9JJjbJXFUaHUNhM5ruYj30IC5ttZn/9ec7tss=;
 b=nM8M4OTkD0zv6u0Ptlg3NZmDc+P8ayWJ9K9wXiqHevnKe6weZCogPxqUysIfAzStgzyQElyXn472ahj9c7CWuljMeKQOYSwveA2GqOirIQQQRt2zypcXf7MytUAdzm30ioawnQhDGcMkMwVDk9QLruOMGiXD+yLV0D1mAOr/eg2zQms119D+Ao8uYEkMbXfaSb/+cAnnpDKl7YPVVeHmQYKbdrLDxAaijwTiuBeqXwyaMCEs3l/XM8eDO4f63eBnA9c7YnaLyeIoC3qu3kuD2zAO6tnLWH2FaWNv7FhEGzST95cluzSTXq0KksQNZvfQSwY80nx86MG6gndhCfR0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnnRGl9JJjbJXFUaHUNhM5ruYj30IC5ttZn/9ec7tss=;
 b=Kciuv5l0LTVSRRxyDhPbfB6AWuKT4/1oSOOTmBouZ69kmauh7soGoDJHASZEE1FCccuRin6V9Gi8yykcnHFzX7o2/iru0EAhHoHlUCsFDBv+D+G401lePY512Iui54UcoC8CovKnxuI7KGqGhvxwawx9OK9hPFnnnoToQCbDC4k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/8] net/mlx5: E-switch, Fix mutex init order
Date:   Wed, 29 Apr 2020 15:54:44 -0700
Message-Id: <20200429225449.60664-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:15 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dde5075c-3e46-4e31-914c-08d7ec906282
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB52471C30B7D725F7F12517D0BEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9XsMEJJIuNIRl/6/gPIIouJIlaYcDKwjcUngU6pDg47ucrh+SusWD6QEZ7t1RWugMCR08jv27New7WkUL7JZiv+UiW9rIfW6I12ETQ32bNfA61co1t1pNe2cqvgAEfjgqm0O9YZRNxnhzVtX3SHXpDB1/nmHDb0VFEwgDtcx0J+ZlonQNuHykZKGgFBFJYJPOAN2unY3c1VcPyMM6x9tw/07nJXSvqyvaCNn4cY6oo9IZQniK8nVMZusOyUppWIvZN5wP/YlUVolpPVObzP07c+J7ai7pTDZNru7pgX0JtZhY/93x9GsasnZaauH/PzbAApOzGSVQf4Te+7wfkoBwtxpfGDLTUbmAxw1Wn5BnbSnPWY8jXYLJMqO1FxnvFvGKIqmCyTGfl9WQJKOQkSZ/Y+XK9yVMmLoUA6qQtQ602mc0yUEy7+aPXU/cdw+TQujQx/yF/WjwwM3CVhP3MTRu575ADYKpQG49p6J77Eyzt8C+ZXXqhaGYSCitMxS0q1
X-MS-Exchange-AntiSpam-MessageData: a+YeogfRYlf+wzsFbxa6F+aZlH6x47uegrs9dwWi8CRQXCManF10GR3xZEOuGgloII3bPB67hYhOO4KklmcLM6dx68XEI4DCfj/YPNsMa/U2T6RlZiu819HGWWeL9SxLdgS+vs73uEK2iOoV25HSp1fmS9d+laq4sBZZLNDsJRi0jz9oqn4X1Z0dAzWmbrMEn9ykMfUa8S65fl7WOYWrE5zwdXapiJmb2jIz75vJGXRXiEhFcrb7TaMw+pTT3iuWOnNtr/MeTZvSpTUk3/+47b+GeEa0FAPM3jCTyfRyI6HtnV9Uz6L2wRGU2kaKIPPwmEVFYgiZpzxeeqg4VcZYY+qao38Rfi++GRoi4Ud1q/1tOUInLCAz3sTJa0fmmRJ8vNTq4rNyyeOx1+w6GtDtdfEAPNzJPu8JfkOUPZ6DLkYWGGwnSGiOe+5ziLg3EBurDeZ+9paxpJuBfuD0LNOx24QBkpqH8NBu39Oy962qaAF8fI8iEhtjfTZpM2fMHJckBzaTt8f/H8q+O6QsZ38LRf4exQKM/7Zu6McAHQYYtw3MLTIKbAOZmoKSxZpyjhD9Ypir7om4DRQNpgzXQ/U3CSf4hi/nQVICCLtICXkEdBRpUABbFpesRA/kd4UYp5hunxeckpLANw2oRf8l6HNe6kiAAcHnqHzn+b+7dDzPv58eOmISATzC1P2kpLrN35OBBV3yqo/3epy7S0TMXlR5yRe+yJ+ilqqwWtrRKn21dXSfrB4dFPekfGEs3KR7eeCEq5DAToJynvjnO0pRkyTaAx319RLQlCbIHja4ab9rt5A=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde5075c-3e46-4e31-914c-08d7ec906282
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:17.0483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Setb+W4C81N+lU4xI4zKOF8FdoUk+NxIeBulDfL4Goy76v9E0uyJ1HsfwcWwQcGUQ6c3lu0/ko+CzBaBkEy+cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

In cited patch mutex is initialized after its used.
Below call trace is observed.
Fix the order to initialize the mutex early enough.
Similarly follow mirror sequence during cleanup.

kernel: DEBUG_LOCKS_WARN_ON(lock->magic != lock)
kernel: WARNING: CPU: 5 PID: 45916 at kernel/locking/mutex.c:938
__mutex_lock+0x7d6/0x8a0
kernel: Call Trace:
kernel: ? esw_vport_tbl_get+0x3b/0x250 [mlx5_core]
kernel: ? mark_held_locks+0x55/0x70
kernel: ? __slab_free+0x274/0x400
kernel: ? lockdep_hardirqs_on+0x140/0x1d0
kernel: esw_vport_tbl_get+0x3b/0x250 [mlx5_core]
kernel: ? mlx5_esw_chains_create_fdb_prio+0xa57/0xc20 [mlx5_core]
kernel: mlx5_esw_vport_tbl_get+0x88/0xf0 [mlx5_core]
kernel: mlx5_esw_chains_create+0x2f3/0x3e0 [mlx5_core]
kernel: esw_create_offloads_fdb_tables+0x11d/0x580 [mlx5_core]
kernel: esw_offloads_enable+0x26d/0x540 [mlx5_core]
kernel: mlx5_eswitch_enable_locked+0x155/0x860 [mlx5_core]
kernel: mlx5_devlink_eswitch_mode_set+0x1af/0x320 [mlx5_core]
kernel: devlink_nl_cmd_eswitch_set_doit+0x41/0xb0

Fixes: 96e326878fa5 ("net/mlx5e: Eswitch, Use per vport tables for mirroring")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8289af360e8d..5d9def18ae3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2219,10 +2219,12 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 		total_vports = num_vfs + MLX5_SPECIAL_VPORTS(esw->dev);
 
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
+	mutex_init(&esw->fdb_table.offloads.vports.lock);
+	hash_init(esw->fdb_table.offloads.vports.table);
 
 	err = esw_create_uplink_offloads_acl_tables(esw);
 	if (err)
-		return err;
+		goto create_acl_err;
 
 	err = esw_create_offloads_table(esw, total_vports);
 	if (err)
@@ -2240,9 +2242,6 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto create_fg_err;
 
-	mutex_init(&esw->fdb_table.offloads.vports.lock);
-	hash_init(esw->fdb_table.offloads.vports.table);
-
 	return 0;
 
 create_fg_err:
@@ -2253,18 +2252,19 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	esw_destroy_offloads_table(esw);
 create_offloads_err:
 	esw_destroy_uplink_offloads_acl_tables(esw);
-
+create_acl_err:
+	mutex_destroy(&esw->fdb_table.offloads.vports.lock);
 	return err;
 }
 
 static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 {
-	mutex_destroy(&esw->fdb_table.offloads.vports.lock);
 	esw_destroy_vport_rx_group(esw);
 	esw_destroy_offloads_fdb_tables(esw);
 	esw_destroy_restore_table(esw);
 	esw_destroy_offloads_table(esw);
 	esw_destroy_uplink_offloads_acl_tables(esw);
+	mutex_destroy(&esw->fdb_table.offloads.vports.lock);
 }
 
 static void
-- 
2.25.4

