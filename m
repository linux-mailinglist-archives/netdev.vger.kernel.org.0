Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3C159C54
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBKWgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:19 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727640AbgBKWgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgLieKlNzX7ODIyScbJkyYFla0pnkP2YZ2ip19r1fhzPZNRviSxHiuYlnX4h+Ry8aF4NyVFBZI1oHgDRDar5nKVo2f7gle7wC5I5usiF+Xi8gRi2LxhpQJaVtYAnaRMEesIHbK4W5YC7B5yx3uXSyzIBT/i5BAB3klGe134vb/Ki9oOr3s+/OKDo56C4MKPL5VgbYyxU+E3EZ5PHnBcMf27nrkZDyJ3v+usIx3q1V8tVJJ/UVuyNBuzO218XV0vRi/XXvs/OI7PzLe4FC1iKeDm5G2ns1dn4ASlcIg7ZCvd95EtZ+vITPtwd/GGIrZXCWopJGy0YyHHrIq3Uz+83kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdtIVinwgRZviVuv8lurbbmBKMHA1L+WkX/QxHXeOLI=;
 b=E/syRi3Cn+u7S8R+oPAb0NfshckQnjDH9ZKF2pkZIcElWrjrimNBiwy68ljmpJcDRFAuEUOEvbf58tk+m6tUx8dyT3hg6jzDS3LL3BVdu1nkCB8Azx0UqZi9La1vbfPXcMpTSOPOJyDaocDy7vmzRJ2xD3cS105uCOFflWIubJdeSkVDMC8AfblmGQoeyWka1NXJezYZnOS0ArvxWdV1IRbZNHLAqTo6nrmT2eP2TPqA5AmTEKS7CmzRRThnNlN6WRNBlRlC4ibhBAsJcwkrMK2V0Y2NU+Z7Ej8ViYyaGEaQCnjuhFOtDX4Vu7UDRWFx+WeENM7XabzYAwnw8Jq0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdtIVinwgRZviVuv8lurbbmBKMHA1L+WkX/QxHXeOLI=;
 b=RfAQApIGu3hECRyWfWlilKPfORLxFFDOLo15P9/2cOXIiZbXlQIp+DZVcRE3eC/YM3bDEG/AaYtOamnu5onfFy1FMtCvK0mUiWV7NJlAezeHavmRCGAqmszeGGfsQXK3Z3DEqol/5cDJIN5A9l7gr8nl+gF/zutI5VSM5YwE4qg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:36:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:36:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 12/13] net/mlx5e: Add support for FEC modes based on 50G per lane links
Date:   Tue, 11 Feb 2020 14:32:53 -0800
Message-Id: <20200211223254.101641-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:36:01 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b7379aae-6ff2-49d3-6b8b-08d7af42c66c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43837A85BB03066841007A10BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(6666004)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(30864003)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/1efIaCggrmQ+uVKUpH6O2x9dvyaEcdg1MkYFaLtjzarXc7At754s8xxHcXc76ay9TvXB/Km36l121sNWwftmjf3X6Rl7jDazqwpeHBdAVhwi1JPrFeAfdtvaG2L/v01sFivJDIgmyMgkmxP3rzilrIWq1t5EVhjlWou6NurzxnC7ozdig6ZkQxMwbyUVm8fWULUKZpyM5Mxg5Eh3Q9ulNUNXjKUgTUndqOtUbD+Xdj/Or1Z3k9dx5VKHuPmEiicveMoIg+KKvDRR/ijQF07SNLfClNBs418X2+XtaFTIs5OI20g6fEXjqaLHSyB/gJerfHuJtAWv2i6Jtrh/vyJ08PWISX8u5J0tV+++Vp2kt3HGmY0u8k1FhXucR0DnZIcnaOBSJ2dbgOwN0tU/OakFlqYlexHXGdQIqkkbfYwcFxNMwzAx6HHqdmweaEbHffvtM4qwg1iKcunOI18eepwwm/L4jyZiHfvCmKZfS5f/2+ZuqVOB1/dbf2amxgGwku8szOL0kdE34VaYZ64A+t101v37N10OjIX7DwMSNjKQU=
X-MS-Exchange-AntiSpam-MessageData: CJWl1ACF9AdpMiHuuDSvh1oX1mxmICbiceAkIsghERLs32w2Wxgng6dbGxboXxJIyRHESOGCweJsSi8vVjqJtwisgXUkUSxuqYVPeg3OnJqCn153fx+lws/V/4ojI9XAzfKvsiKDgvqkV0nj/FLYTw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7379aae-6ff2-49d3-6b8b-08d7af42c66c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:36:02.9989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gfo6FzfDtu3dGbSjbVEcdAeAqkeX1+hFZ0vbUZoH+Ka8Y9SQpTMwT4wsfblXoGMHK6X/HGoFKZRNEqSoB5aJZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce new FEC modes:
- RS-FEC-(544,514)
- LL_RS-FEC-(272,257+1)
Add support in ethtool for set and get callbacks for the new modes
above. While RS-FEC-(544,514) is mapped to exsiting RS FEC mode,
LL_RS-FEC-(272,257+1) is mapped to a new ethtool link mode: LL-RS.

Add support for FEC on 50G per lane link modes up to 400G. The new link
modes uses a u16 fields instead of u8 fields for the legacy link modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 90 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 14 ++-
 3 files changed, 94 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 16c94950d206..2c4a670c8ffd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -349,12 +349,18 @@ enum mlx5e_fec_supported_link_mode {
 	MLX5E_FEC_SUPPORTED_LINK_MODES_50G,
 	MLX5E_FEC_SUPPORTED_LINK_MODES_56G,
 	MLX5E_FEC_SUPPORTED_LINK_MODES_100G,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X,
+	MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X,
 	MLX5E_MAX_FEC_SUPPORTED_LINK_MODE,
 };
 
+#define MLX5E_FEC_FIRST_50G_PER_LANE_MODE MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X
+
 #define MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, policy, write, link)			\
 	do {										\
-		u8 *_policy = &(policy);						\
+		u16 *_policy = &(policy);						\
 		u32 *_buf = buf;							\
 											\
 		if (write)								\
@@ -363,8 +369,21 @@ enum mlx5e_fec_supported_link_mode {
 			*_policy = MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
 	} while (0)
 
+#define MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(buf, policy, write, link)		\
+	do {									\
+		u16 *__policy = &(policy);					\
+		bool _write = (write);						\
+										\
+		if (_write && *__policy)					\
+			*__policy = find_first_bit((u_long *)__policy,		\
+						   sizeof(u16) * BITS_PER_BYTE);\
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, *__policy, _write, link);	\
+		if (!_write && *__policy)					\
+			*__policy = 1 << *__policy;				\
+	} while (0)
+
 /* get/set FEC admin field for a given speed */
-static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_policy, bool write,
+static int mlx5e_fec_admin_field(u32 *pplm, u16 *fec_policy, bool write,
 				 enum mlx5e_fec_supported_link_mode link_mode)
 {
 	switch (link_mode) {
@@ -383,6 +402,18 @@ static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_policy, bool write,
 	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
 		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g);
 		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 50g_1x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 100g_2x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 200g_4x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X:
+		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 400g_8x);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -393,7 +424,7 @@ static int mlx5e_fec_admin_field(u32 *pplm, u8 *fec_policy, bool write,
 	MLX5_GET(pplm_reg, buf, fec_override_cap_##link)
 
 /* returns FEC capabilities for a given speed */
-static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_cap,
+static int mlx5e_get_fec_cap_field(u32 *pplm, u16 *fec_cap,
 				   enum mlx5e_fec_supported_link_mode link_mode)
 {
 	switch (link_mode) {
@@ -412,6 +443,18 @@ static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_cap,
 	case MLX5E_FEC_SUPPORTED_LINK_MODES_100G:
 		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 100g);
 		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 50g_1x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 100g_2x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 200g_4x);
+		break;
+	case MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X:
+		*fec_cap = MLX5E_GET_FEC_OVERRIDE_CAP(pplm, 400g_8x);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -420,6 +463,7 @@ static int mlx5e_get_fec_cap_field(u32 *pplm, u8 *fec_cap,
 
 bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 {
+	bool fec_50g_per_lane = MLX5_CAP_PCAM_FEATURE(dev, fec_50G_per_lane_in_pplm);
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
@@ -438,7 +482,10 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 		return false;
 
 	for (i = 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
-		u8 fec_caps;
+		u16 fec_caps;
+
+		if (i >= MLX5E_FEC_FIRST_50G_PER_LANE_MODE && !fec_50g_per_lane)
+			break;
 
 		mlx5e_get_fec_cap_field(out, &fec_caps, i);
 		if (fec_caps & fec_policy)
@@ -448,8 +495,9 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 }
 
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
-		       u8 *fec_configured_mode)
+		       u16 *fec_configured_mode)
 {
+	bool fec_50g_per_lane = MLX5_CAP_PCAM_FEATURE(dev, fec_50G_per_lane_in_pplm);
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
@@ -474,6 +522,9 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 
 	*fec_configured_mode = 0;
 	for (i = 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		if (i >= MLX5E_FEC_FIRST_50G_PER_LANE_MODE && !fec_50g_per_lane)
+			break;
+
 		mlx5e_fec_admin_field(out, fec_configured_mode, 0, i);
 		if (*fec_configured_mode != 0)
 			goto out;
@@ -482,13 +533,13 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 	return 0;
 }
 
-int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
+int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 {
+	bool fec_50g_per_lane = MLX5_CAP_PCAM_FEATURE(dev, fec_50G_per_lane_in_pplm);
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
-	u8 fec_policy_auto = 0;
-	u8 fec_caps = 0;
+	u16 fec_policy_auto = 0;
 	int err;
 	int i;
 
@@ -498,6 +549,9 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 	if (!MLX5_CAP_PCAM_REG(dev, pplm))
 		return -EOPNOTSUPP;
 
+	if (fec_policy >= (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
+		return -EOPNOTSUPP;
+
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err = mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
@@ -506,10 +560,26 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 	MLX5_SET(pplm_reg, out, local_port, 1);
 
 	for (i = 0; i < MLX5E_MAX_FEC_SUPPORTED_LINK_MODE; i++) {
+		u16 conf_fec = fec_policy;
+		u16 fec_caps = 0;
+
+		if (i >= MLX5E_FEC_FIRST_50G_PER_LANE_MODE && !fec_50g_per_lane)
+			break;
+
+		/* RS fec in ethtool is mapped to MLX5E_FEC_RS_528_514
+		 * to link modes up to 25G per lane and to
+		 * MLX5E_FEC_RS_544_514 in the new link modes based on
+		 * 50 G per lane
+		 */
+		if (conf_fec == (1 << MLX5E_FEC_RS_528_514) &&
+		    i >= MLX5E_FEC_FIRST_50G_PER_LANE_MODE)
+			conf_fec = (1 << MLX5E_FEC_RS_544_514);
+
 		mlx5e_get_fec_cap_field(out, &fec_caps, i);
+
 		/* policy supported for link speed */
-		if (fec_caps & fec_policy)
-			mlx5e_fec_admin_field(out, &fec_policy, 1, i);
+		if (fec_caps & conf_fec)
+			mlx5e_fec_admin_field(out, &conf_fec, 1, i);
 		else
 			/* set FEC to auto*/
 			mlx5e_fec_admin_field(out, &fec_policy_auto, 1, i);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index 025d86577567..a2ddd446dd59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -62,13 +62,15 @@ int mlx5e_port_set_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
 
 bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy);
 int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
-		       u8 *fec_configured_mode);
-int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy);
+		       u16 *fec_configured_mode);
+int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy);
 
 enum {
 	MLX5E_FEC_NOFEC,
 	MLX5E_FEC_FIRECODE,
 	MLX5E_FEC_RS_528_514,
+	MLX5E_FEC_RS_544_514 = 7,
+	MLX5E_FEC_LLRS_272_257_1 = 9,
 };
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6624e0a82cd9..68b520df07e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -633,6 +633,8 @@ static const u32 pplm_fec_2_ethtool[] = {
 	[MLX5E_FEC_NOFEC] = ETHTOOL_FEC_OFF,
 	[MLX5E_FEC_FIRECODE] = ETHTOOL_FEC_BASER,
 	[MLX5E_FEC_RS_528_514] = ETHTOOL_FEC_RS,
+	[MLX5E_FEC_RS_544_514] = ETHTOOL_FEC_RS,
+	[MLX5E_FEC_LLRS_272_257_1] = ETHTOOL_FEC_LLRS,
 };
 
 static u32 pplm2ethtool_fec(u_long fec_mode, unsigned long size)
@@ -661,6 +663,8 @@ static const u32 pplm_fec_2_ethtool_linkmodes[] = {
 	[MLX5E_FEC_NOFEC] = ETHTOOL_LINK_MODE_FEC_NONE_BIT,
 	[MLX5E_FEC_FIRECODE] = ETHTOOL_LINK_MODE_FEC_BASER_BIT,
 	[MLX5E_FEC_RS_528_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_RS_544_514] = ETHTOOL_LINK_MODE_FEC_RS_BIT,
+	[MLX5E_FEC_LLRS_272_257_1] = ETHTOOL_LINK_MODE_FEC_LLRS_BIT,
 };
 
 static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
@@ -680,6 +684,8 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 				      ETHTOOL_LINK_MODE_FEC_BASER_BIT);
 	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_RS_528_514,
 				      ETHTOOL_LINK_MODE_FEC_RS_BIT);
+	MLX5E_ADVERTISE_SUPPORTED_FEC(MLX5E_FEC_LLRS_272_257_1,
+				      ETHTOOL_LINK_MODE_FEC_LLRS_BIT);
 
 	/* active fec is a bit set, find out which bit is set and
 	 * advertise the corresponding ethtool bit
@@ -1510,7 +1516,7 @@ static int mlx5e_get_fecparam(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u8 fec_configured = 0;
+	u16 fec_configured = 0;
 	u32 fec_active = 0;
 	int err;
 
@@ -1526,7 +1532,7 @@ static int mlx5e_get_fecparam(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	fecparam->fec = pplm2ethtool_fec((u_long)fec_configured,
-					 sizeof(u8) * BITS_PER_BYTE);
+					 sizeof(u16) * BITS_PER_BYTE);
 
 	return 0;
 }
@@ -1536,12 +1542,12 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
-	u8 fec_policy = 0;
+	u16 fec_policy = 0;
 	int mode;
 	int err;
 
 	if (bitmap_weight((unsigned long *)&fecparam->fec,
-			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+			  ETHTOOL_FEC_LLRS_BIT + 1) > 1)
 		return -EOPNOTSUPP;
 
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
-- 
2.24.1

