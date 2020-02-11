Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B23DD159C53
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgBKWgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:15 -0500
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:38926
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727743AbgBKWgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkJKmjzvrelT5OBY8AG15dXszCSZxwjsVh0Vk2jkHHYbgFcRHKC4lm8v3+209lj9hB1/GVX9jNU2FKw85haf9ORoTUxfLKoxeifJ/A/WdMogYaLSkRGE1MSl/cEMCvERugplBAKH32cqZKmbCKEkRPhwA2Bg0sPVz4wIYLD2jS3rhh2r2HdDP1pXAjkdZHGj7M9xYQzn2fkJZz+zwi5uiuzCThFp7hE0eCbritnozdgK7YZlj9IfOavk8RNep8ZFzSTfZaMUGIJ+023A2nwxifwWRRMwGS0omOg4/CJFMvWofTc3xhdH1VHxFhsQWiphWBIDYetzA4gVc0l+BOpM/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2ayTwjvc1C7sUUwLvjatNXjB82VI9+1Zqo4m+HxZ9M=;
 b=VPrODk+JZwcAfbX7wXYWZQzStTAEKjVi5gfi7MQ2+cDUVMnW3QPUtD93WPIVYluBCLUFIJWdnXRqztI4Cr0lVRBUZYH/xpj6LdJb9HBtCC10vxHQ/wJYbB17miz3I8Bnwbs3cvTWXIinz6eQ4RAq4M0PW6IdQdVvbI0tsOZLwIEx9JEaYu/xl7LiDmdcXJ1+32JIiVUr62L/b7sxVrJDKOCldSMUVTOCnTBxpfbecdRV/yPcKmwNz1dmfI33n9F/yHq+W32RYLkLFnZyArgwiSx7MUtKL7mFaeDsJOC90GB+T6EI9PAJxOmv5IT4kyOi15Tlp0iaVp2mDG6Cjghdgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2ayTwjvc1C7sUUwLvjatNXjB82VI9+1Zqo4m+HxZ9M=;
 b=eYCVmqKpJwomDaASh2W4D9OAtvWi+YawaFvRyW5Nw+PUrOxRow9KkeZn8mfKfqwXXfpeCyiPNrVo2SZXgLgMC2cIsDxfXAezTSq9HapAUXwHFxTNTCGqf7eo9LipIOMCUoFZkAgMElSs4vtI5cwbaVxUj5TcenrXC3ESzVlsB+g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:36:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:36:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 11/13] ethtool: Add support for low latency RS FEC
Date:   Tue, 11 Feb 2020 14:32:52 -0800
Message-Id: <20200211223254.101641-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:58 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4d942e47-e66f-46dd-c759-08d7af42c4ef
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43833D4755922CDD61E90DB1BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(6666004)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(19627235002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZLblrAK4j4BjCJjGnXlpMkAyVQutN4TWNueXwPGnk1ZLyt1Je2QP/ATXDdYgdAprS8PPELIgM1RPRpOlOaXzE4d83FAXyj5x4AQuGSOy6pvHfitmm9smdX9c1fTglSvGLhTGOGjl+Gn6bIjCGsxYs8dOvE7S1rJ7Pe3ltXkN8/sL13pHZDa1Z/kaBC2qZswETmvrLUpCs2gYdMd4KGncjzjxSG2OCKRBizYoXPe9jva5aPbLc5fx1vHsq+0yQj8m1xCwndoWvCBQjJE3FkgZ8ZgKJmeeEaRJCVu7PfSS4m5l6/XbxFiF7FeckPvbG13yc78Uv4GShT4MzDQ2L8ZD5SlIWdcw33kgMOICyg3ofszRco7h5uFqZfqLDoapA1/h097ZjwvMqSQFuknUoEDELhxj77ArpbPqT5eWs37j7rnVYLwfCiGoPP0o5iXlZiugTb4JFgeuuO/Ul07adtENNY5DsVRXgq62JAapnw7Brpk+TtVyEAcNl+Utd5azMUaUD9JBvi5J418uUmiLQ6LnsE90wUFLlw4CEeq1iAnLqkI=
X-MS-Exchange-AntiSpam-MessageData: D+Eyh+e59qHn38LJnMgJKTXPMnYns/qzxyW9DnVrjVKEkPr32zab3Bv7dAaZPPlUKdd6GkgLxvK8/p7WEM+zzR7Qilz3ExNaGunqo+8xXRt9IeH0jCqQSCpH1dlyEtJRUfE3aqUjyizIESYiwimOig==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d942e47-e66f-46dd-c759-08d7af42c4ef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:36:01.3109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gi8I2ZCu4uC6vc0/uK6kDajRpbDgJ7DR9Coym+huGqVslsxv/WHVLENcX6a3VcFBDqQWZVI7xrTk2BGUOLXfGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for low latency Reed Solomon FEC as LLRS.

The LL-FEC is defined by the 25G/50G ethernet consortium,
in the document titled "Low Latency Reed Solomon Forward Error Correction"

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
CC: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/phy/phy-core.c   | 2 +-
 include/uapi/linux/ethtool.h | 4 +++-
 net/ethtool/common.c         | 1 +
 net/ethtool/linkmodes.c      | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a4d2d59fceca..e083e7a76ada 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
 
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 74,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 75,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 4295ebfa2f91..d586ee5e10a1 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1330,6 +1330,7 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
+	ETHTOOL_FEC_LLRS_BIT,
 };
 
 #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
@@ -1337,6 +1338,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
 #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
 
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1521,7 +1523,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
-
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 636ec6d5110e..7b6969af5ae7 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -168,6 +168,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_LLRS, "LLRS"),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 96f20be64553..f049b97072fe 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -237,6 +237,7 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
 };
 
 static const struct nla_policy
-- 
2.24.1

