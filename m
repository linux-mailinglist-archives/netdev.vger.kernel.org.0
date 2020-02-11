Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A80159C55
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBKWgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:41 -0500
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:49622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727747AbgBKWgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+UZwRcrBwjc5Br3qgqD91jOxwA4XLdsnivuhCdOqRuND2vgwWnJgzIKnjqZOIgEQFEOy66tfYxMMlJjTkdcNDvXGi/QUerWzLcrhJtSRtJ/CI/347EBn+VcFmGD610ZDF31FeJMfRoaH4OARRGmeXf5Dn0D5qegxzz2ZIswC8BKS+OhztyI8od3KEgI3ZgAiHF2oZf5dG5A+JbglgasIIMFQJeg08fnMiB6kFrS3SSWrB4VnisLVh/zo0XXRDeNMdgDkJ8pXUGfBWna1EI6kYbtj8ytiVuy63ZeYOUR21ne5Sfio6cu92gG5Y2AA6XwmsH3lri+NJIbq+xzLu4c+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXTTBq6AjOKavFKIlqXxAgbG4GJYPg/q77lPP88eeGo=;
 b=bAQ1ekDqFEXINVvvZm50eFFS24LCUqHOl+TqmlP1r3EwfwGeOIbXD/KEcEKaAhW+fipI84R7trowVGGNj0reRYc+TV6uqrVRH3lJNqRhPnmmdinC2zDPSdmHAR5wDAQQ+SNvvps0zY9oXCO7aoI4QXlHYrOUg9Cn5mKtwZRKjUwdpcs9kML4pibTNqPfYF4yPGGN9jebPMBLTLtpD+buxvYoPwvPj04joxIV/i9NopGgJY8kbUweshY09QNyD6IsL8DJeaUba/4QttqgecdlT6nNO7s+mkKzWQpbylkSec+Y7HxllEBTXjfbxjhi68lVWuv6xGYHqnaUJCJti5lQnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXTTBq6AjOKavFKIlqXxAgbG4GJYPg/q77lPP88eeGo=;
 b=W2EbQz6a7yfQFBud5BpwXtgXY7d1xHVz/X3nKTBhiydXo1TRHYohUqgDODN/XwXNfWjmi10Q6Hwqe8wtTkoKlBh2jnyAMB+5K2AHOd3b+JAOvzYeoA5lSEhbtbcrZtp2RYL5iGo97NCiwat6COzzAS6DtBJeqc+q60fd+AGlFWE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 10/13] net/mlxe5: Separate between FEC and current speed
Date:   Tue, 11 Feb 2020 14:32:51 -0800
Message-Id: <20200211223254.101641-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:56 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dfa8ff0a-de0d-49f2-7ea8-08d7af42c330
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43839F1F5E3995DFD4B038A3BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(6666004)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UtJ8oOk1/JOQ0uftkpp4GePOUA5/n+ubAJX9DDJPirrU5nIhSFMguGs1PuHZh6+PWLwjNG0K2+FnaF2kksAE5mNH/CDHG23ycWl7o8L3MHi16lelUkP9Ozh0CKmwl8SnovXKyt/eWg+Zk+TOm4Wor2ol+mUkjEgxtg5G6/Nzq8qGryKTpdiz4cjf8ZhWJfeigQlWFtJJ3672Vb/zQUE7Bhua+s4NzjLwLWwLTR46rpeDiUJ3bZCFP5eQ3GGvbSr8r7/he+yWk0bKIZRl9SkX9yLNZRhaX7wrD0tGpfuGBGrAoeXkLxzrcC16hFXKAazSSA1mQ7FbBckqVW1DmX5ZxEOtpMtZSroLhblUbz20AWM88ON2ul7e7oZUemiPM3UBCWDji001zFSbLaMHnCobIrARvDptDzsRACiI8y1Z0wMtLiPUej3k0ld86Sue5tuI6tNsONvc8FkV0EA6V+JGryAykrxz3gdMRLRB0MOoueZ/FIl4UrtLndBdX4Dhovf6E6LKKDS4m4XoDtiOIbkW15DPh06Upu+dGIFDXlxVQ0w=
X-MS-Exchange-AntiSpam-MessageData: J4AdArxBw5QeMPTfuNj9BxeCWRHsGhhKP8v5YI17caqWDV/rbCU1geckS7CAJUa90KZ1841YKqstN2/FteE82D+Fqaok28a6RVVfvYwcc66Quzh7qZReKaWms4QXE0ct8Rdch5xgy7Af0CMt46HW1g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfa8ff0a-de0d-49f2-7ea8-08d7af42c330
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:58.2746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BGFB+DYq8MLszJynLoqPbVtZ3eB4VXiOe+Al9Q7eHc/mVlgKqog/ZWqvJu/LsRzBTw65oVke36uwIlfqRewDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

FEC mode is per link type, not necessary per speed. This patch access
FEC register by link modes instead of speeds. This patch will allow
further enhacment of link modes supporting FEC with the same speed
(different lane type).

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 146 ++++++++----------
 1 file changed, 62 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 26c7849eeb7c..16c94950d206 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -343,64 +343,45 @@ int mlx5e_port_set_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer)
 	return err;
 }
 
-static u32 fec_supported_speeds[] = {
-	10000,
-	40000,
-	25000,
-	50000,
-	56000,
-	100000
+enum mlx5e_fec_supported_link_mode {
+	MLX5E_FEC_SUPPORTED_LINK_MODES_10G_40G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_25G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_50G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_56G,
+	MLX5E_FEC_SUPPORTED_LINK_MODES_100G,
+	MLX5E_MAX_FEC_SUPPORTED_LINK_MODE,
 };
 
-#define MLX5E_FEC_SUPPORTED_SPEEDS ARRAY_SIZE(fec_supported_speeds)
+#define MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, policy, write, link)			\
+	do {										\
+		u8 *_policy = &(policy);						\
+		u32 *_buf = buf;							\
+											\
+		if (write)								\
+			MLX5_SET(pplm_reg, _buf, fec_override_admin_##link, *_policy);	\
+		else									\
+			*_policy = MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
+	} while (0)
 
 /* get/set FEC admin field for a given speed */
-static int mlx5e_fec_admin_field(u32 *pplm,
-				 u8 *fec_policy,
-				 bool write,
-				 u32 speed)
+static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_policy, bool write,
+				 enum mlx5e_fec_supported_link_mode link_mode)
 {
-	switch (speed) {
-	case 10000:
-	case 40000:
-		if (!write)
-			*fec_policy = MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_10g_40g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_10g_40g, *fec_policy);
+	switch (link_mode) {
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_10G_40G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 10g_40g);
 		break;
-	case 25000:
-		if (!write)
-			*fec_policy = MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_25g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_25g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_25G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 25g);
 		break;
-	case 50000:
-		if (!write)
-			*fec_policy = MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_50g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_50g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_50G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 50g);
 		break;
-	case 56000:
-		if (!write)
-			*fec_policy = MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_56g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_56g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_56G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 56g);
 		break;
-	case 100000:
-		if (!write)
-			*fec_policy = MLX5_GET(pplm_reg, pplm,
-					       fec_override_admin_100g);
-		else
-			MLX5_SET(pplm_reg, pplm,
-				 fec_override_admin_100g, *fec_policy);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g);
 		break;
 	default:
 		return -EINVAL;
@@ -408,32 +389,28 @@ static int mlx5e_fec_admin_field(u32 *pplm,
 	return 0;
 }
 
+#define MLX5E_GET_FEC_OVERRIDE_CAP(buf, link)  \
+	MLX5_GET(pplm_reg, buf, fec_override_cap_##link)
+
 /* returns FEC capabilities for a given speed */
-static int mlx5e_get_fec_cap_field(u32 *pplm,
-				   u8 *fec_cap,
-				   u32 speed)
+static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_cap,
+				   enum mlx5e_fec_supported_link_mode link_mode)
 {
-	switch (speed) {
-	case 10000:
-	case 40000:
-		*fec_cap = MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_10g_40g);
+	switch (link_mode) {
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_10G_40G:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 10g_40g);
 		break;
-	case 25000:
-		*fec_cap = MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_25g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_25G:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 25g);
 		break;
-	case 50000:
-		*fec_cap = MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_50g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_50G:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 50g);
 		break;
-	case 56000:
-		*fec_cap = MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_56g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_56G:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 56g);
 		break;
-	case 100000:
-		*fec_cap = MLX5_GET(pplm_reg, pplm,
-				    fec_override_cap_100g);
+	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 100g);
 		break;
 	default:
 		return -EINVAL;
@@ -460,10 +437,10 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 	if (err)
 		return false;
 
-	for (i = 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
+	for (i = 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
 		u8 fec_caps;
 
-		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
+		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 		if (fec_caps & fec_policy)
 			return true;
 	}
@@ -476,8 +453,8 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
-	u32 link_speed;
 	int err;
+	int i;
 
 	if (!MLX5_CAP_GEN(dev, pcam_reg))
 		return -EOPNOTSUPP;
@@ -493,13 +470,16 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 	*fec_mode_active = MLX5_GET(pplm_reg, out, fec_mode_active);
 
 	if (!fec_configured_mode)
-		return 0;
-
-	err = mlx5e_port_linkspeed(dev, &link_speed);
-	if (err)
-		return err;
+		goto out;
 
-	return mlx5e_fec_admin_field(out, fec_configured_mode, 0, link_speed);
+	*fec_configured_mode = 0;
+	for (i = 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		mlx5e_fec_admin_field(out, fec_configured_mode, 0, i);
+		if (*fec_configured_mode != 0)
+			goto out;
+	}
+out:
+	return 0;
 }
 
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
@@ -525,16 +505,14 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 
 	MLX5_SET(pplm_reg, out, local_port, 1);
 
-	for (i = 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
-		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
+	for (i = 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 		/* policy supported for link speed */
 		if (fec_caps & fec_policy)
-			mlx5e_fec_admin_field(out, &fec_policy, 1,
-					      fec_supported_speeds[i]);
+			mlx5e_fec_admin_field(out, &fec_policy, 1, i);
 		else
 			/* set FEC to auto*/
-			mlx5e_fec_admin_field(out, &fec_policy_auto, 1,
-					      fec_supported_speeds[i]);
+			mlx5e_fec_admin_field(out, &fec_policy_auto, 1, i);
 	}
 
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
-- 
2.24.1

