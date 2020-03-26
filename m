Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675D31938C6
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgCZGjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:11 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgCZGjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kn9KYWZ9FMSwUBSFyEOGiNHg0DJZLsGdNOESsfTtBt3j0tXZjb7wBQRIJ/HRcFb20H6qn0yiJ6A9tE8YJMDOC1d7oXLGVfL9G0gd8JLf8Q9QoFG7jtndn3tY4tq5AoslzVavNNrti1IgX4wCTTIouaWKt889TTI7NMDuTl29ZgMr/FkOcwbg0eyhgrLfhn1y9cX7ZCQNPCQeSm1tcngtzBHDOn0zqCfkjlnAXdCOahLh7aUADeXEoISgyXqDYvZBAFNgfXKy3LvUrwRbSFHa51YSrGMsHQ0k16CMepavg2ZLAsq+meF+ZUhb/hsO4hEaa2OqUx+k6G403D+WBJZLyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEmEZVRluVXwaJ8SZq7hruPiC/70FvrOKy/DMSlnUQQ=;
 b=RDx6NfjYYhhdEEGUXygz95KfbeAo3z7RG9yORP4p8tCZCD1KvCbRqrX6VnE+MiY+kne2xIy/9AN258jZ2Kzklvfy2V84dUcbzOOUaFBcGHs9sYHFKkpC2FXU4pvd9XJ+9Pp4/3CfL+w+Db+Ow9DULW4LB61AYCDDOYzQoZ9X+mYPU8kp/yqkaHB436FSmrGUBGdeGKc86IR1QJmub9NB6EkCs6b8FOiMXE4OVZtxbXdUhYjpnsClnxD1ByqC5PdGJnfMAaXnEw9vHn3Nz79Go6lPDtMy7+qx38gGgdkdB9NrHGMwJ/zOwwbbRive9jKdJQAeJ4V+9y+jSAXViBA6Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEmEZVRluVXwaJ8SZq7hruPiC/70FvrOKy/DMSlnUQQ=;
 b=uChmz50uS2w5dG3P5s3Z53DzhAiHD+89EecIxCCrLisK8mSLVVxb6ljaLGtJLYqQqathxh8RWP615mI7npW/3/lLOTJFgB2xAzc0FYy6+9inCCAb/Xbsac2mNxtzBembfuu9RZ58yxBfANgG7NjT0hfFZkVrg7/Bn7IkNthiizc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:39:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:39:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/16] net/mlx5: Split eswitch mode check to different helper function
Date:   Wed, 25 Mar 2020 23:38:07 -0700
Message-Id: <20200326063809.139919-15-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:39:02 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 23070855-be0f-4149-5741-08d7d15060f4
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479853251DE83852734FE86BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6RKgjN1Mim8/IVAsO4CYbfUYohePKWSjCc/PUwYKqvsoWOks2eijsEqFn93s2oqeyK86zzEnIYBrrrKFRVW8PywZBKP8QVyXA6WJxtDtG4QcqptSjHQdJc41f7srxAttq6SJr1GFn7tjZ8EK2Yp6dy7zbNXouF3o+SHqwSYJ0mJAiDfrl7HlxQaMp3fraC8Acdz3Ib5PoBLVtG/QzzZnRjV61S4nH5luscUD+xPwk+YbsxerXqNs//97Ww295Vx+mMk7R36kZYJGbeA4t9cLe7S8dJPd7IoykCvIkiNdDGDJridmuZW5sJsCA89kpXJgJyyMBZAzT9GdcsrMkc4OYfPVrN6fxqCdlktSTD+Dq+O9TuI0dYVw2ExjvGRbe99x0zeXzYl6DUXxNMtsBo8xn6ZybqqsN9AsR/MRUJ1zWAZpZG6ZIXUGpglLqKxnh93V19bzBAAIwL02X2NTRsn7N4xpTQyY69IPS34l6N6ux7dx2JCQ/BXtyY9gm7VU1w9
X-MS-Exchange-AntiSpam-MessageData: m5ydh4l+S8zBdi7U13cYkrMeUZDPRnsUWlQUgb3Iu6wwwcIpny+sHBRCbAQy/XshsNLKYWA62dG476Qq8hNdvM8g86y9QVxtoAsXqaOpnIhsCDW3DtoCpo0VzbBTrC2XRFmIohyTma/xitxBZveTMw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23070855-be0f-4149-5741-08d7d15060f4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:39:05.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YG5W9yAg2fqEiT3Vi2H1gsLnF7DUxB1kWmnWof1gcHUrBKa7Cy4L0pEvmNqpDWE0kdXlJIkPXbcXuhevh9TJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

In order to check eswitch state under a lock, prepare code to split
capability check and eswitch state check into two helper functions.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 37 +++++++++++++++++--
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 088fb51123e2..53fcb00ddbac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2506,13 +2506,18 @@ static int mlx5_eswitch_check(const struct mlx5_core_dev *dev)
 	if(!MLX5_ESWITCH_MANAGER(dev))
 		return -EPERM;
 
-	if (dev->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
-	    !mlx5_core_is_ecpf_esw_manager(dev))
-		return -EOPNOTSUPP;
-
 	return 0;
 }
 
+static int eswitch_devlink_esw_mode_check(const struct mlx5_eswitch *esw)
+{
+	/* devlink commands in NONE eswitch mode are currently supported only
+	 * on ECPF.
+	 */
+	return (esw->mode == MLX5_ESWITCH_NONE &&
+		!mlx5_core_is_ecpf_esw_manager(esw->dev)) ? -EOPNOTSUPP : 0;
+}
+
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -2524,6 +2529,10 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (err)
 		return err;
 
+	err = eswitch_devlink_esw_mode_check(dev->priv.eswitch);
+	if (err)
+		return err;
+
 	cur_mlx5_mode = dev->priv.eswitch->mode;
 
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
@@ -2549,6 +2558,10 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (err)
 		return err;
 
+	err = eswitch_devlink_esw_mode_check(dev->priv.eswitch);
+	if (err)
+		return err;
+
 	return esw_mode_to_devlink(dev->priv.eswitch->mode, mode);
 }
 
@@ -2564,6 +2577,10 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (err)
 		return err;
 
+	err = eswitch_devlink_esw_mode_check(esw);
+	if (err)
+		return err;
+
 	switch (MLX5_CAP_ETH(dev, wqe_inline_mode)) {
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
@@ -2618,6 +2635,10 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (err)
 		return err;
 
+	err = eswitch_devlink_esw_mode_check(esw);
+	if (err)
+		return err;
+
 	return esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 }
 
@@ -2633,6 +2654,10 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (err)
 		return err;
 
+	err = eswitch_devlink_esw_mode_check(esw);
+	if (err)
+		return err;
+
 	if (encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE &&
 	    (!MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) ||
 	     !MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap)))
@@ -2682,6 +2707,10 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	if (err)
 		return err;
 
+	err = eswitch_devlink_esw_mode_check(esw);
+	if (err)
+		return err;
+
 	*encap = esw->offloads.encap;
 	return 0;
 }
-- 
2.25.1

