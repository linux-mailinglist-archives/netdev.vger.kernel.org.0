Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182B31C0B07
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgD3Xld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:41:33 -0400
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:34525
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726435AbgD3Xlc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 19:41:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbjC/IIGPBWt2x/2UlmAC/UpX1zprBOO29UcVO1VLAY6ds+5zyLqdwDAylm1vDltUKBbRuayAetaO+C+Td/voPzdCIYKvMml+vGEsxIE7xeUhXxW6lN0nUzbLPwZLPXEh/wsTNKQfk9vTxdMkwt6UR1hJ0PWg69HPkxERAUOdTUZhZYWfSq00UsMcErx7w3n+xkKdh/EgUre1lwtchrmgEy8vh/fqEWuYfOZdpF+Tjh+zktSA8SzzaAFvrFySgoVJw9VzubFWHwKPSjEifXtv6vCmIVg+QFPFaL4F9MBkRM75nu3mY+3XKnp0lkitO+mJjwfGlM2239IdGQrPH42ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJnvEi9Ilatzz5OBC9J7DEOTXcqbdBOIu1SW/9hsngg=;
 b=cFQnxWlkSYUmeYzzMxsLjuSq4tXm7GpWQZ7g8lei0fwFsxFCTK6C+SPKhRRbfgmN6DYbA6/pNcmImEdaDz+O1nROaoAhfCwvWKwcTVaZsnBKlJDiiVJgjsCbevJ/hgZkwTkKhzvtUoc1mm/bRTEyomdjynimE4A32k0qdS57qr5oEnrWHfKwrw1hdDrBrKBjuWW9j3Rwv4gMQuRGAa2UPHkKun1deLnWvFMB2PnBl76zMtZb18MoSVZtSjo/ftKprWaxysvdJpyCwj0KHbefT9tqiCN19z9JeFNvNKYPqABhxdWXF2C2aVjexmMFOhvwQbiOuAXJ3OwKYRNL9hp5Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJnvEi9Ilatzz5OBC9J7DEOTXcqbdBOIu1SW/9hsngg=;
 b=DepwJF5yfLM1cFwS7kDl05EVu9MOZAYeWNhEeT1pu7xg0KjBfz/xmupQJEDcD5IL5YyghyVf4vW9mgfBJqixwzM9+Ha0D9byN0HkWlXqN8RONADb8lUDmB+ZyNqu+PFSxqvFJ+O+ql2s4Ca6tEQ6PpCo/xBC/cdKTwE4gzTcGfQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3230.eurprd05.prod.outlook.com (2603:10a6:802:1b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 23:41:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 23:41:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane link modes
Date:   Thu, 30 Apr 2020 16:41:05 -0700
Message-Id: <20200430234106.52732-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430234106.52732-1-saeedm@mellanox.com>
References: <20200430234106.52732-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0026.namprd17.prod.outlook.com (2603:10b6:a03:1b8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 23:41:25 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d16d7e54-c36d-460f-8259-08d7ed600000
X-MS-TrafficTypeDiagnostic: VI1PR05MB3230:|VI1PR05MB3230:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32308DFD236527BC63A79805BEAA0@VI1PR05MB3230.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(36756003)(186003)(19627235002)(26005)(6506007)(2616005)(956004)(5660300002)(52116002)(316002)(1076003)(478600001)(16526019)(6666004)(6486002)(2906002)(6512007)(86362001)(4326008)(54906003)(8676002)(66946007)(107886003)(66556008)(66476007)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eX3XrFVQH5+hYI6+2NI2RcaI8IDnIUiOx3LjMAZPzXZviHJzS1OcwIzGQR1huybtvy6HpiBhOaxVqZa2aCWmYH2irGozwC2LukNoHJhyyfR0U9YGWsKY0UnrgTws/chjB8BLHXJ8RFusP1CSJrev6CyEn9H1eBe/a2VM94eElfLWIRlAncFfut20rM+9bAB/WthlCiAszJTEkKYBKzFtCTene6Zaod9gefhwAvvfYQAc/NJ3sTtGenwxB4IRAvg0hGkbxbrXoY377dHcwhwD29zO2Et0LK01BHftc2stHN80TYopB3tgR7fRggoIHPwtzHmKCebRB/Xt6kwYs/fOaM2zWwA/6eeArXx7MHpfvSCuS0/TCOu2WEBhBWoVlRyWDBR8NI9e0bYaD+yAtTUjeurl2Cme0kWe3f8AAWner8PwOszaReyKEssrz2wpnohideu6wvSEQkg4wQ+U5NfvUXr/1RMs1Vf9dmg5YqhoyiZiaRvvmqgoe25HK51BRDf0
X-MS-Exchange-AntiSpam-MessageData: gq0bmzzc0Tgx1RrrkKe8uYILH9GYddAC+DdB8QAE74HeSKA76ZGPNI11nEWNgRFvsOGSmaqS82Y0oDz1SfUBCHA+oNt1Mt+ZgDY4eQnIIhlTBA6vlAeXeROtCU4KpW1Khqcs2Txl39uh1TWj3xhr6+7aBde39v2O+B5i+4ot97V3kOv0BOxdY4fkj+cggXBMsnTJvAJLMzgh8LrTszj0nZEpww0F4LHq8B+gaDcoN0TGwfBIe4bsNylB83GTPGMqA+6Z78uhj2O/7RfuC3qNOXTfRJ9umWgpwnOHmGB3FxROlAw4kdz1RsGegzKWt20ioMlO8orfAYc81tFqAnqaj+5qS+pK188twY8I5+bBHSSEKzG76aU9m7uAm8dvAw5H03iaYNofshqkzmUGGQHFJmyIHTdHlq1aWAAlLOL9D4FOIa/raXJ1qk0ZNaS4aGiUP6nYs00hQQmrlxMSmZv2VKnDzKof88SrPDVqK4bqRJC0K9SYg6UTfb6h2ihI9qufc4DhTK0BPtrAN8JaG/HgDCPiZw3T3YN/mmP/X+jCDhm8hZrkJFNG5IhuGzeIbuyuDCTiXBUQ/AabOBMYT0L0ZfKbJeyPVsF9WSlv6FTr3jOWgyuq6fhS+dDyiAxLb2Kuyp58p0Zt2/D628tvHbjAKb4kwi1Ae3N7yAZO7mQJld3S5sIkofWSfHNQchhRY+QpPU1wQ94lbLZKr8mbPWEmIzhIBLSbFx0tHjvogj+s9I5MJGG3JZvYiFuhaWEYqgB+0/cNoDRB/CylPn6z4bcagffgw0thmkAN3hem8Dz5qGw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d16d7e54-c36d-460f-8259-08d7ed600000
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 23:41:27.0580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6HAIX4RuFwIewoj4zFNTwnJGMiRnLXO32lYb8wYSdetdmuB4dj/cNxafYMOPPK/X4wfGpXM+EXPfi4YpyDJYbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3230
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@mellanox.com>

Define 100G, 200G and 400G link modes using 100Gbps per lane

Signed-off-by: Meir Lichtinger <meirl@mellanox.com>
CC: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/phy/phy-core.c   | 17 ++++++++++++++++-
 include/uapi/linux/ethtool.h | 15 +++++++++++++++
 net/ethtool/common.c         | 15 +++++++++++++++
 net/ethtool/linkmodes.c      | 16 ++++++++++++++++
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 66b8c61ca74c..a71fc8b18973 100644
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
index 92f737f10117..a3829074a336 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1530,6 +1530,21 @@ enum ethtool_link_mode_bit_indices {
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
index 423e640e3876..ffb50ac66aad 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -173,6 +173,21 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
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
index 452608c6d856..ffa02b7c86d5 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -238,6 +238,22 @@ static const struct link_mode_info link_mode_params[] = {
 	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
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
2.25.4

