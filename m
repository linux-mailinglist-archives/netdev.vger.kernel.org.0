Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FA46EF00F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbjDZIQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbjDZIQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:16:29 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48353591;
        Wed, 26 Apr 2023 01:16:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBqfv8dDdN/0VxIroxEBB05nbMJDCoZ0nn6zrlOonx8CNWp6heNWQKswdhhFC/ilkSl15xwLmgoorp0SM7R5+U+1oVBhT1U3//Cg6krXvV3z4/PimSLZ7cdHLhPWt1LMdRkfhNaTUjm9RmC7Eq5Dk+v9u5N3cWcNxsTRdDmXRR06fTDBMRJvvgOOeWqcsFQRBRgUtHiCwGUfGtPzf1UX6Hi9VwEABMRNANn3x69YdujwEV9fghl1cnsGrq8soXPaqKJoj0feV8m5DybMoTxrjXAkfvFszsEXLDtrq3MIMzLsc7BbLUoYym9UTmib9vcecmv05cPFCnXbOJXinnpHCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7i4ZMtRZearweFOKxtZ24s9ivPxM111cuJqX/PEaXz0=;
 b=UL6kZjzi7WmyRpnFX9IlBWPKtOKGMfkqMlm6iH5k9T9YuTH0iGsR+Lw5BaQ96O1IgEigKvLzyLP9YMLHWmJkhV/a2mnNwxnMPt50i8bwAhEHQtpLY6FUt8NcOcuXkMlhq7aQQsJ8UI3xlPOuO0DYfNpT+i8i6Zb4WGRavZymmDePpWkBEY6Jv37kyt5kAulz3M5TyKDvoH0vi48hSi7rqxJSKAYda+JbkAguHurBypqlZ20zqesrE6D1Z38eJ232xp7pjgcrXloCpMHjM14A+B9pCPIengRMbQVOiCLKq3p9qNPICMApg++EesJokUirgDDuKa+C761rOWnROv/pEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lunn.ch smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7i4ZMtRZearweFOKxtZ24s9ivPxM111cuJqX/PEaXz0=;
 b=iHKXtk94fVzpFTWVQ3s+QxocLiAt+2UFKMQ/l1V2oSAfxkOfprWn1lRJv9vVnvIVX9D4QsHqWAAo5tR8glWK6yQo4VDLQzSVlTOtFgSxxN8PyifmqFca10JJQCc2HAZU/pTufKmjV6P+V0zahnsZrrjLGNNUmqmncisJ6KFQGpU=
Received: from DS7PR06CA0053.namprd06.prod.outlook.com (2603:10b6:8:54::8) by
 DM6PR12MB4530.namprd12.prod.outlook.com (2603:10b6:5:2aa::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.34; Wed, 26 Apr 2023 08:16:24 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::ee) by DS7PR06CA0053.outlook.office365.com
 (2603:10b6:8:54::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21 via Frontend
 Transport; Wed, 26 Apr 2023 08:16:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 08:16:23 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 03:16:23 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 01:16:22 -0700
Received: from yocto-build.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 26 Apr 2023 03:16:20 -0500
From:   Devang Vyas <devangnayanbhai.vyas@amd.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Devang Vyas <devangnayanbhai.vyas@amd.com>
Subject: [PATCH] net: phy: aquantia: Add 10mbps support
Date:   Wed, 26 Apr 2023 13:46:12 +0530
Message-ID: <20230426081612.4123059-1-devangnayanbhai.vyas@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT060:EE_|DM6PR12MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: 020237c4-9e59-4b5c-b139-08db462e8621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dgc9k9gUJq+3Htcc4Ib74O0/OxE0rJPFgDmxRbZds9tYQKVVFG1zmIyr5E0PzWBtIodUhTQA4C/qiZOSXQ/nF/oK8jvmR6zHRCE6lPx8lan4E+sda8+GAKkNNHFolv6Y/v5XWiQelhmU7c02K9yTW2phvJvvQHUNIeFZYCNmoYmtw8Y/FDtG3bX3+4CTZEkX6tkOEo5tsmsAwiHfqIm/Qkz/KOQalKFZX7eAz60Xd4a0wi3xcG5qKR5DR+j06jgAv8R6ZYov9huCOhUxsgo0sjwdJvnJCO3wxWOqHXkAE3YE+pgYX+eQanzhvGX/EUK/MC8xUTJc6a0U846gB1M9SZR5UkLuVdl7VBr/QEXNfAJQelf2rm14miS1M8tuNLe8oIKWJgT9iEbv99utiewLnAxBHizK0n0DDLW47uOdsd+0CzqGzOI7rUjH4rOB1KgMU2WAK2VNV7OfeVi/K6qUwg1paliiQSqCEYACK9kva+0MacDd2TAuyI7BvtKWij1uMfPP6AJ7MWyo9JJkIGfoNoR1uiafLwOkWCS5cIoIBRvgPxTUkUvKk26jf8bgIIXGBGeA+crbyv8EQPHzA7Va/PoZUnEjNkGsAAMpZqKCs1Jg8KEqOYWdZZQL0WaHe6m9vhXnAX9ssZGW3+BqtRlhlcZD/z3iyGud/L2G992PPkbY7p7Rv18gtw4g4eupb+Ydo3LVejBVWfRhnXP6GJF420t6Qg8swlUbW+3MJjH2BQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(36756003)(110136005)(82310400005)(478600001)(86362001)(41300700001)(81166007)(8676002)(8936002)(2906002)(4326008)(40480700001)(316002)(356005)(82740400003)(70586007)(70206006)(5660300002)(186003)(1076003)(26005)(426003)(83380400001)(47076005)(336012)(36860700001)(2616005)(7696005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 08:16:23.5070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 020237c4-9e59-4b5c-b139-08db462e8621
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4530
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for 10mbps speed in PHY device's
"supported" field which helps in autonegotiating
10mbps link from PHY side where PHY supports the speed
but not updated in PHY kernel framework.

One such example is AQR113C PHY.

Signed-off-by: Devang Vyas <devangnayanbhai.vyas@amd.com>
---
 drivers/net/phy/aquantia_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 334a6904ca5a..fed0a4cea651 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -556,6 +556,9 @@ static void aqr107_chip_info(struct phy_device *phydev)
 	build_id = FIELD_GET(VEND1_GLOBAL_RSVD_STAT1_FW_BUILD_ID, val);
 	prov_id = FIELD_GET(VEND1_GLOBAL_RSVD_STAT1_PROV_ID, val);
 
+	if (!test_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, phydev->supported))
+		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, phydev->supported);
+
 	phydev_dbg(phydev, "FW %u.%u, Build %u, Provisioning %u\n",
 		   fw_major, fw_minor, build_id, prov_id);
 }
-- 
2.25.1

