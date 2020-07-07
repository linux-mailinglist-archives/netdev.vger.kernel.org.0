Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A132E2164CF
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 05:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgGGDop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 23:44:45 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:6065
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbgGGDop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 23:44:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv76Xy1KGcIROEbgP1KNqqkYUF98HVXyyqudhCsVOuEs+VxYSXJTrzdshsDhKyFkPvS1OVJVBnBPx82GbVkyLA6HLNYkaYnT4G7W+JWUEKnsLTGf1s5VpFZ7PMCmG3lFoHqxqlbMZ8Go2NDVRoFkAharwp4l/9bwilh8PtczIVnUZP4iwZdmlasV+zK+JeKQ0MiKriGiX2bFm+WwnFH2kN8nLaXUML6ZnJebHR8IJ9jsvZ6E0AFnOS6Ljj1rDOjmk16GeYmCSu23jGsGhnf583qbZ5BfY8vswG0U7pkMyA0KzJf85jpI5LGKlakFq2v8KhomHc1zoeultUJGZ6cvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FGmulvsKvgtbN2LdRB8U8LxLdO6c0tQflDdqjKK4ww=;
 b=aDs+XRk1ktr7QMdOUsXLsbqJTLFa2GXlso7IdxT1EvDB7RijuUKgYTdUOHrVaUgTdfGprJLVV4mp3Y3pB9C0Ph6hHeCt6TIrTFz0fXC6ctpbTIpLgc1R9yzHKTQp3LMr9KsgWSVvcwhpXA4rw6h2PqahEMdJfx3sOAelMMF3r2cnOOtocycz+yrXn759ueEknXAA1o0SfPlu7b205UZrZddHLfVwDrqu+X8k3ePUWsld2qj/gNqhOUt2tZxB7G5Uxn6LOek/Hk933Utedlojz/SpcZ6Ep7W75dtM2PnzrND1UbOyhe+GGF4C2PMR/wizIbJtfxeu0kGRqJnKxYLYAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FGmulvsKvgtbN2LdRB8U8LxLdO6c0tQflDdqjKK4ww=;
 b=MgNDs0UwsABmoKHUf23ci1eDhSeGsQkT3rKEhI9l64TqxMHcZZ45i2Ww9W1NlbARfIBKeu85cPaxuHS2U/+JBomXarg2xl861oaEFN9Vx/jQq98qEtPD4A3a3TqCBdHZ32+LDeyKWU1wYM7jaV3F4PeH+V7Hb3N+/zip4hFGINk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Tue, 7 Jul
 2020 03:43:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 03:43:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next V2 1/2] ethtool: Add support for 100Gbps per lane link modes
Date:   Mon,  6 Jul 2020 20:42:32 -0700
Message-Id: <20200707034233.41122-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:a03:40::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0023.namprd04.prod.outlook.com (2603:10b6:a03:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Tue, 7 Jul 2020 03:43:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b0f9670-3497-4d69-e197-08d82227dc96
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5376767DFF9C58C020807B34BE660@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5UdL14/nYnvkl3FeUFTsDdJB75MFe6D+o8RU97ZyuUri5tdBuYdxALOj2Ji2vXaaAfN++JmD8/OTUMn5KP7md7k1QLntmc9KpnwGTdWSQej9QMNH5Pi4t+ida6IR8P5RNGT4taBny6MIWrsjHHby659ebcmt8Z+bagV0aQxm+ivWjBaCoVJu5QFyRRpZRtzTnpEpTGFRFy3izMCKpuC6bCeO8eJj2bfEkI8yvMyUiVoVZe0FrYPeHXo9gl7zAFP9Pmth34n1XJe5NnRXjU9XyjCdCzLPJb5rSOnTZMw08kKr/cAmrEHE7/iUjSzDoeW7BNA7K6Gxz+TTarrpEqdKKy4LUawj5gduPXCyRp+d8mLto45uzoNdJavYitdw9zR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(110136005)(6486002)(54906003)(1076003)(19627235002)(6666004)(36756003)(8676002)(5660300002)(478600001)(8936002)(6506007)(956004)(2616005)(16526019)(83380400001)(52116002)(316002)(186003)(26005)(6512007)(4326008)(107886003)(66556008)(86362001)(66946007)(2906002)(66476007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dymTCo7kh5jbTouP0DBuLeMT4oKiza8DH3Dl+0a0aw991puWlyNL2K8PK4qIptosK/Z+csr18+Djx4Y7QNOG2aXjFinxJFYPFAyk1+HbFHET4dwt7bA4ayltyUwQxL/IVZ8Z+/rL2wJ2sHSLSMVN/0c6+1LQgEjBYMyDNGgCNnrK96J7JDDhC2noFyijYFOYFdezDRvO02k3yXGRW0IaNZa3ZseVU4pdyRvQpUAPU5NolW3uGLNJbegKUcfalh5tnBv54wU8rssh8zkNiii27lFPGa4louGRExluIyf+Sku9W85blMxWWZlLceukeft4FbSgFAadlmyEEHl9jhkNJuNCFpOX5W5mr9n16QZw8tuzsjcrCEJ6Y+y/uZpoI7eQoDmAPd0SWJYfNaP55vtFA0rLLlUS3VyRya/Lekeas/5RCVGmXoQH7702udMuwnHb5FPUdxT4vSkhgVUKtnE/KDwGf+XO+S9yvvcnS96SKXU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b0f9670-3497-4d69-e197-08d82227dc96
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 03:43:07.5748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugy/lSI65Ko3+0hNW1tTqmO1oHTd211Y/UX8JMcQt5g533+qNPOk8abkwIiKEnCy+e5TJmx/K1PMuJmjNcvemA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Define 100G, 200G and 400G link modes using 100Gbps per lane

LR, ER and FR are defined as a single link mode because they are
using same technology and by design are fully interoperable.
EEPROM content indicates if the module is LR, ER, or FR, and the
user space ethtool decoder is planned to support decoding these
modes in the EEPROM.

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
CC: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
v2: Improved commit message according to Andrew's comments and questions. 

 drivers/net/phy/phy-core.c   | 17 ++++++++++++++++-
 include/uapi/linux/ethtool.h | 15 +++++++++++++++
 net/ethtool/common.c         | 15 +++++++++++++++
 net/ethtool/linkmodes.c      | 15 +++++++++++++++
 4 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 46bd68e9ecfa..ff8e14b01eeb 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
 
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 75,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 90,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
@@ -78,12 +78,22 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING( 400000, FULL, 400000baseLR8_ER8_FR8_Full	),
 	PHY_SETTING( 400000, FULL, 400000baseDR8_Full		),
 	PHY_SETTING( 400000, FULL, 400000baseSR8_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseCR4_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseKR4_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseLR4_ER4_FR4_Full	),
+	PHY_SETTING( 400000, FULL, 400000baseDR4_Full		),
+	PHY_SETTING( 400000, FULL, 400000baseSR4_Full		),
 	/* 200G */
 	PHY_SETTING( 200000, FULL, 200000baseCR4_Full		),
 	PHY_SETTING( 200000, FULL, 200000baseKR4_Full		),
 	PHY_SETTING( 200000, FULL, 200000baseLR4_ER4_FR4_Full	),
 	PHY_SETTING( 200000, FULL, 200000baseDR4_Full		),
 	PHY_SETTING( 200000, FULL, 200000baseSR4_Full		),
+	PHY_SETTING( 200000, FULL, 200000baseCR2_Full		),
+	PHY_SETTING( 200000, FULL, 200000baseKR2_Full		),
+	PHY_SETTING( 200000, FULL, 200000baseLR2_ER2_FR2_Full	),
+	PHY_SETTING( 200000, FULL, 200000baseDR2_Full		),
+	PHY_SETTING( 200000, FULL, 200000baseSR2_Full		),
 	/* 100G */
 	PHY_SETTING( 100000, FULL, 100000baseCR4_Full		),
 	PHY_SETTING( 100000, FULL, 100000baseKR4_Full		),
@@ -94,6 +104,11 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING( 100000, FULL, 100000baseLR2_ER2_FR2_Full	),
 	PHY_SETTING( 100000, FULL, 100000baseDR2_Full		),
 	PHY_SETTING( 100000, FULL, 100000baseSR2_Full		),
+	PHY_SETTING( 100000, FULL, 100000baseCR_Full		),
+	PHY_SETTING( 100000, FULL, 100000baseKR_Full		),
+	PHY_SETTING( 100000, FULL, 100000baseLR_ER_FR_Full	),
+	PHY_SETTING( 100000, FULL, 100000baseDR_Full		),
+	PHY_SETTING( 100000, FULL, 100000baseSR_Full		),
 	/* 56G */
 	PHY_SETTING(  56000, FULL,  56000baseCR4_Full	  	),
 	PHY_SETTING(  56000, FULL,  56000baseKR4_Full	  	),
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index d1413538ef30..60856e0f9618 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1600,6 +1600,21 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
+	ETHTOOL_LINK_MODE_100000baseKR_Full_BIT		 = 75,
+	ETHTOOL_LINK_MODE_100000baseSR_Full_BIT		 = 76,
+	ETHTOOL_LINK_MODE_100000baseLR_ER_FR_Full_BIT	 = 77,
+	ETHTOOL_LINK_MODE_100000baseCR_Full_BIT		 = 78,
+	ETHTOOL_LINK_MODE_100000baseDR_Full_BIT		 = 79,
+	ETHTOOL_LINK_MODE_200000baseKR2_Full_BIT	 = 80,
+	ETHTOOL_LINK_MODE_200000baseSR2_Full_BIT	 = 81,
+	ETHTOOL_LINK_MODE_200000baseLR2_ER2_FR2_Full_BIT = 82,
+	ETHTOOL_LINK_MODE_200000baseDR2_Full_BIT	 = 83,
+	ETHTOOL_LINK_MODE_200000baseCR2_Full_BIT	 = 84,
+	ETHTOOL_LINK_MODE_400000baseKR4_Full_BIT	 = 85,
+	ETHTOOL_LINK_MODE_400000baseSR4_Full_BIT	 = 86,
+	ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT = 87,
+	ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT	 = 88,
+	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index aaecfc916a4d..d3f2e0de215a 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -175,6 +175,21 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
 	__DEFINE_SPECIAL_MODE_NAME(FEC_LLRS, "LLRS"),
+	__DEFINE_LINK_MODE_NAME(100000, KR, Full),
+	__DEFINE_LINK_MODE_NAME(100000, SR, Full),
+	__DEFINE_LINK_MODE_NAME(100000, LR_ER_FR, Full),
+	__DEFINE_LINK_MODE_NAME(100000, DR, Full),
+	__DEFINE_LINK_MODE_NAME(100000, CR, Full),
+	__DEFINE_LINK_MODE_NAME(200000, KR2, Full),
+	__DEFINE_LINK_MODE_NAME(200000, SR2, Full),
+	__DEFINE_LINK_MODE_NAME(200000, LR2_ER2_FR2, Full),
+	__DEFINE_LINK_MODE_NAME(200000, DR2, Full),
+	__DEFINE_LINK_MODE_NAME(200000, CR2, Full),
+	__DEFINE_LINK_MODE_NAME(400000, KR4, Full),
+	__DEFINE_LINK_MODE_NAME(400000, SR4, Full),
+	__DEFINE_LINK_MODE_NAME(400000, LR4_ER4_FR4, Full),
+	__DEFINE_LINK_MODE_NAME(400000, DR4, Full),
+	__DEFINE_LINK_MODE_NAME(400000, CR4, Full),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
 
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index fd4f3e58c6f6..317a93129551 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -257,6 +257,21 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR2, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
 };
 
 static const struct nla_policy
-- 
2.26.2

