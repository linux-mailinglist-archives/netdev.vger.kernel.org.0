Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D201C026D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgD3Q02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:28 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbgD3Q01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj59eP4f2q3XUdTYJ9v7KUkreVsxt13AcKa+rgnQcG/6mPQ0AXr+Vx4RP68Kyw1IB8DdRqZp4CMn794wdqkeL7Sq0bqfkaEYy79SZ/7TmRu+l2H+pl1yv8mUI9LfCfnTJ93ZnFd/C5Lgx2S8Wv/3DMhprQBQUiHlrKUpAcUzy8p+x4CtrrtDL8I5axqiyO22BrlC86gpgMB9b6uksJBtYc7VRHPMtfpoNUnjSzXUMSbAPbhOXNYh8oOGaRgevdgX5zG6Sajltp5knz8auz5lomFa4SD7QLndtcZp+AR4SlZKQP1ObR3/OYqdPe7Xs8vZ/0QvaCqt9v0tCpne4ilOwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnnRGl9JJjbJXFUaHUNhM5ruYj30IC5ttZn/9ec7tss=;
 b=lJD8shMYXNSoFLfuuU+dnQCqIgW9bK3NSk65mQQ3liRkNa3MgDevRavfeRmeo/RSs9iWSZIlaLh2KCiaiCzFB1hit8WmdV31V+q18ytttDO+h5ZnodWb697cyyeBGPTZ3D79gQNP/ryw7BXhshEeKXdbGrJRIzXAyb6beAcx/KL8V9s93oDrwngF6+2T8hEbkqTI9/tbFWGKRmySqoDm3p37Fg8pYsqUHWK4W63LyKmQ5Shs0PBiCyYENeUXSCaQGz42d7AQ02bh+Bjc10zmi5S1fHWh7uJTfcwTdprc+ITEavPP9iF2LGuzrR+0dKPKOWy3gB2uT9fCjpA53OE1FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnnRGl9JJjbJXFUaHUNhM5ruYj30IC5ttZn/9ec7tss=;
 b=Yt48PYOUnuprrc4iXOiIw+jg0w0UVvhhwrRoJJcmAhbDEcAcQzHImplBlCVesUZdjGHjnCNibzOC2dtcYnW7I751jGbuGM///lOwI045f29kScmGq2XDU9hTS/mp3A3ka9Pwo3GQNd9mrRghtdAVqbRjAKJMKoNbWX35fUVFQx8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 3/7] net/mlx5: E-switch, Fix mutex init order
Date:   Thu, 30 Apr 2020 09:25:47 -0700
Message-Id: <20200430162551.14997-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:20 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ff5cc14-bb39-4dbb-1891-08d7ed233885
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB537654CF1D94261B36D1D6D2BEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FD8B4XqKTPkiPiX251xHVDBbq99OfMnm4CbCEywZ6aJlnMUJYtB4q8aiQMf0vreawNyevb2Z3X77T87DyMeEG7QHloe8PWb+L7kuQm7t/uPCh+ALdZQowSyjiP12gljBf9KGTBvY9AMt60Iq5qcQt50uSScDj1P+1zuI2Ejnen9pH/bpB/hTSJFvaR+Iz+uWHY2KkzUrCcQ4BThGcVbzKo4cgLkLbLGBci9IzFGNDOAkrKHcxOJ4Im1jLjfx436MAinKVbb50pUJYnUTULM6Si2H/1PJ2IPUa8D36ekCJ4pbR8+3w947cBH0eoWsk2f4eAnF+WtDmUS0VWyGGITRtE1iSot8Xdm6q89qbrDZizJYiexitT8UAfbaFEUk7b+hZjlmZhyhl0zQ7ItB3uORXpEoH8LFG26vNq2i6bbdhlCMj+IUSxB8hM2E3/RgnSvcsywB5ZdkDjNBnaPm+si+jQK5u5pWA6ZHOzkU+F81VoIgBC+0TmBHes7MBhMckc9l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zIJTEjj68evwjb8N66mq7xUioJGPk5fB5wIOG1McmouIaHA7mEe4dDZYAOLFywOuqRcsLUP1KW+glPLRa0n9LhIJGMnYRqCVeOrN3/ubDAe1BZefGM1hERs8dURy3MEW+uPLNfJooFoi8/PBVW2WSe0Goc8pAL5ULoqVU21U0CsCtO6ywkr1znOP/4brpNbyZW45dntRk58O2BhCaE7e5Sqb3nMVUGu10/xGqceaiJQTW/LO7aYmf64fXpBrelxboTTYtBSA0X44O6VZjLO5DLJJM2EcSxSZQ/tScqLnv3OC8x+Twj8PD7zlY5lx0yOze9UA71NsAgoZUxmJmpUoZfPra7fN9pQ/LulcbUJZz9JRLYAQfPkYDtx2upIfbMWLj68r6NOreL9FUDblSrQNRsukK3M98l04B4eVs+0rwghw1VJcmCrNxub9kEC1/E8hy81h4aoWfZ6A04n6B3jpuoe+K5j6jLx5vwFPgZeIptSh2Nz7OYG0u7iIuOFfe50sWtyXfJ8ZTBefz0fVqfHo8NrKFC5GAUM01n7pshEhYoneRteciMrIkE5ko0To2pnqRJ5h0XriXInq736mLtYznpmwwYb3fiE4elxtjBXxyMjYtlNCyM35YcWEHgZOwb6I3UjqMaiGDZ6+Y5R5EU/PD5YXoy0yIGbVqI6bU7gVlaHPmnYBaWIq6gjfFNafyCEGiPcU6Xrb/66OTM66Ex4syIKalJL6xxMQO24rzUqVMU57rsd5xTXkiJM0Rsc4a7W56UFSc1MPcxRMxEDiNVwiLKOGSr3Fc8dbNth0UCWkyqU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ff5cc14-bb39-4dbb-1891-08d7ed233885
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:22.6238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYrZGhonmKuAU4/fAc+AEtyKuGnK0VTBhSNO/SR8ayE5iiW6zp6d3TFI30VHHFxfB1DmNff4pN7u2giZRqLdIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
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

