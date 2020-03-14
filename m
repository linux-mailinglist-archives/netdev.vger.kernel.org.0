Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C84191853BE
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgCNBQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:16:54 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:20602
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726893AbgCNBQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:16:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYYGY4AfZSu+uUWxpevpntm2EJL+rWlBg5nBmz73SX/mZejR+zvEQK8blmadvR3Kv9UN/cW8fImC7CL7voeTBbP3E+A9DgQUSjK5Md5mA8krvC5YrkwXzn6gPAZFZ5T+b/Q1j5HsGLhzd+Vay9VPf3boBMPVx8cv9MohCeLqgKtmAz8E+0AkI98J6bl6YpOar8tvy0rvw/jo1QpNK2b5gsVJj1kXNAAWsnUVd5rkYWv7GwwxSefAgDP3xL9umye5TfwqdNo55NW2JmcrcgYG7bot3ZHtHR8b5wNpSMVg2xTh5V+mNOacxdx9bpepqx8OVz7PRSq6//3ueaO9mBY50w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TwuNj+nkZmTQpq8SO93meNvBNBds/Fzs6y1hHfaAjE=;
 b=VGPFsL9biIGRPfqk9C5f5wKsW7vmFOxn+UFX/EAjkTX5JL3r147MUWuMszGG9ryLIxF8kGomouTT3u9XUCqtN1kEHPpt4aqRFLYGU/9EydNKNcSBZ8cdVNIv0giCOc1YnH01gE6vBysWsrfY7GpqWZbVJOF7FD9W59gC9pje7rzMlv8X4VztXDJVnmi+H8bMSmwg/YHvNBnvo4u+GuwknJ+PvY+zx1o8tu0DOX45T1bRCvdZGTmXYhyGwT1TOUQh4Sv/VSAKbQ6nJnT5R8v5OD1oGTejFJPPKx1EqTuftaj0/D2kxYWlSOk4f7tyw5He3Y6C8BZwjZ7PrMFsu0vs5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TwuNj+nkZmTQpq8SO93meNvBNBds/Fzs6y1hHfaAjE=;
 b=E01ivoyHBRhstkZfAffpc9OAiU6Txj21rfecQzNdXbeRhlbD/6OFbGqa4E8whWuAzLrOc3CCdufBSf5hjzZWJrcR3lFEl3VXWktE6nAjeo3c2wU8rzzvNUwxmVhSH06V3vDGTXOgsA55HEp4w1/0Nc/qKN5nCoib6B9rdKeKx0M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/14] net/mlx5: E-Switch, Prepare for vport enable/disable refactor
Date:   Fri, 13 Mar 2020 18:16:12 -0700
Message-Id: <20200314011622.64939-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:48 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c419e05-bc82-4d27-0b16-08d7c7b55f5c
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB684526E01B55468DC647FE66BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:287;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zW035lMfKWj/rybMW81HZeq+uPcSdMgFcL6v4AvcPhQIR5fDYeqoDCmKTILu8R03l8F4Cy3vASzZAlWu2TN7eACOOlZt1R0LTZYAhrdrNlhImWvH6QQwcBrBXREsGfPAPNxImEN2hlRlvxQi8iTwdw98jBqf7j59xOWdjFohzdDkv7oNaWdyBT4TG/GMxEP9bKh1miWbnbzKa+TqeRcrYl95NmBiCaZISyX6NryS9VZXDbi1pVA8eHLF6SLeiDCSKqDGOZX0rieO01YxkEw3QYnhiDD7LA6IXTJGVYxWmNIqxfvAUEriqpORpqgP7LuEZ3mwR70jPOkSNnZtPUW/A1wd1aJfmuhHIpsl4PI/GjkR/ZSPwmBWLgqsyOlQJK5HCJCxTuYqB/uM+OL7v1odExbxdcWMSXAB2+DQV7qxf5iYsHeVbdabRi5+vS8UOgh4ykE+epMGkWwQGUBVCg2l7zjUcqeNJsKT+9ndWrHUSol3IcMBm6uRFg9+cYvKPcUs5E3J5K0wdMkuc+GVguj5VRJ2ZYa6oJh7Jw8MiQF7q4w=
X-MS-Exchange-AntiSpam-MessageData: uFdkCYvrcNzhGWRv3JgRd6Lq1Z4AyUPZYAiYZoNHFQnor03Xsn8DT4L4jWMTewOUy/42orBdA1hN3yhliP4H37gutkflpUVNRx3KB4uo7YRb/1XyZcTQeqKamyjAsMkfV5U71Ed1utKtMm5rmRRARw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c419e05-bc82-4d27-0b16-08d7c7b55f5c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:50.0949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rRTsCWhe1v2OPqi12Ng4wNnkYERYB8isSC6q2xvLNX5BW3z5GzT/qLNs6y4qgCgdaPrHGnEF1hEORYnTOr2APg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Rename esw_apply_vport_config() to esw_vport_setup(), and add new
helper function esw_vport_cleanup() to make them symmetric.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 26 +++++++++++--------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index deeedf211af0..258141010b62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1670,8 +1670,7 @@ static void node_guid_gen_from_mac(u64 *node_guid, u8 mac[ETH_ALEN])
 	((u8 *)node_guid)[0] = mac[5];
 }
 
-static void esw_apply_vport_conf(struct mlx5_eswitch *esw,
-				 struct mlx5_vport *vport)
+static void esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
 	u16 vport_num = vport->vport;
 	int flags;
@@ -1698,6 +1697,18 @@ static void esw_apply_vport_conf(struct mlx5_eswitch *esw,
 			       flags);
 }
 
+/* Don't cleanup vport->info, it's needed to restore vport configuration */
+static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	u16 vport_num = vport->vport;
+
+	if (!mlx5_esw_is_manager_vport(esw, vport_num))
+		mlx5_modify_vport_admin_state(esw->dev,
+					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+					      vport_num, 1,
+					      MLX5_VPORT_ADMIN_STATE_DOWN);
+}
+
 static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 					      struct mlx5_vport *vport)
 {
@@ -1794,7 +1805,7 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 	esw_debug(esw->dev, "Enabling VPORT(%d)\n", vport_num);
 
 	/* Restore old vport configuration */
-	esw_apply_vport_conf(esw, vport);
+	esw_vport_setup(esw, vport);
 
 	ret = esw_vport_setup_acl(esw, vport);
 	if (ret)
@@ -1845,14 +1856,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw,
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
 	esw_vport_disable_qos(esw, vport);
-
-	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
-	    esw->mode == MLX5_ESWITCH_LEGACY)
-		mlx5_modify_vport_admin_state(esw->dev,
-					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-					      vport_num, 1,
-					      MLX5_VPORT_ADMIN_STATE_DOWN);
-
+	esw_vport_cleanup(esw, vport);
 	esw_vport_cleanup_acl(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.24.1

