Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE49479DB6
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhLRVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:18 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234593AbhLRVuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0BmOf1P3SO0BeRz3qMZRp7S9MkE86NaKg6qsFRI3eDQeHVyamIDWcvZjjm+CZSPF+e64hN5JzdSKn33tdc6+adXE24zWLHVwWoVJSGsAos0shjsr1DPBLjw7OMRsinqRpPeh/zcz+elef3GTh27NvmULCODRJuhQbhbUsOYiYPM5py+cdPUOPGrOaLWleB9c3RtrHmyu4N6P90SMNJt94LkN2pwcs5BI7QY/4D1El4RoQgzD9LEWyDmV2OqHIVBhYmWMGovUo2oWT453MwnXRasRg0qatHvrLCDomVJ+WCB4Uxbafzd7RPOCDvqLxu72OtrrXb+N3GXxtcBp1o1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orYlgVepX2TzvbBiuzCvrQ30xZBjX9RHGuownUsY77Q=;
 b=UgrN+6XPbEEvXSgtUYN4U9T3d7H10AogTIxyb0YlP6U2ztTcE0iZhbDJKykW7msDeHbfugBwsdEtTCWx8FznzNpZXBXv9s/lPrQkeZVXcPbTt5A6Pr26NpaMRL3soozE5h9ZXUMsi5lhCcGiQkDH0JH+wKPZ2XgM6cZUvVVsFN0KhpewEJm9xZGbRgpcYzeGQ0tgbafYWv1Oz9JnZLEdVVyzUq+viKshurEeTJlZi0w/Q4t2EaIirFa9/FrtNa9zq7skzzCiTdeSI1xcoNMwqDuvNbKSZiLYOGPvYBqPcCVACTPWTiVItUnCg+nw0mj8ymgitXvxhy84kPGql0O5vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=orYlgVepX2TzvbBiuzCvrQ30xZBjX9RHGuownUsY77Q=;
 b=aRgOUBZcTNtMtPxhjrR/ORiMaOPxtGtDjlpOo4LmdhMNFATUTxagmcyBAnrjMkCMhmuX4+rriQEFa/QZ/hTc1apN+PGO8jUcwhU2I8p01vNiP3KLoULkN7+AEQOx0uwJSRiQXM23zstf7h0CdyKju3VwUCR/4uH3FbaV818kQnM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:09 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 05/13] net: mdio: mscc-miim: add ability to externally register phy reset control
Date:   Sat, 18 Dec 2021 13:49:46 -0800
Message-Id: <20211218214954.109755-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d3c8fae-3ec8-4617-0c15-08d9c2705c76
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB563309C2CFB01C672CE5C4BBA4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUgJqvW41icO08e6VFz4+v6ZtiSTKUtmcWyVqesF5yjNqgaqR/BZTS24C0zA3v6uGmf5W26p3NDnWMGI82FibhCdikjER6VTNRvdTyaQWgm6aD4UHYGHrVa5BSjihWGdmUVO1ou/f7SPFo9RlWZ92NVRcB/GKX8FcsIErWS3d8FzN/UlC1jJI7+8TlDFelqc24ZdORreECN1p8JmEPAWbiRp/vHbYagYYP4ZyvufocHI+yhtsYEuoAlyg4roijZo3gBwbu44azbqQHqbg8Gh2FBl4JVeNtkiwtLQGR2nByb6867PZYdkskMbHHoKn8xg5VsGvq2oOM4g+W398ktHB7xj7vxrVpCx9ZwMgAQXBjM8jf4r0h7UZ37XB7hM55zvQlIE0iZk/q91lqPSuI0VCwH2Ka3WuUwFf/qC7/XshGsXtMT2GbMNHx/sgi7V9yOqMfIocEKPcl9J5Btvl/ZlFyZhu14gYHHqmMEX/MNBvaXOreLJbRIAY7P8F6cj29QZ3tyeNHnTo51Ny6Xy/koPScb28PErQanQZzKdtFmweMHnJk3/UnZ0rFR8gSYxRc7r+aov9kGjzwKcgoxZGr9XeZHxkCcVmwy5lhoT98zp37otKXRm93QxYiMVydqNdLVXQK9tVpHmNdCKM1X2IVC7rAFv0es360XyNRR/numNXR56iE3QOxeQWJz6rtVyq69IOYHFYt1NMRGh8nLTIBc6XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pFjbkToS+uWBGtkUyOUS7TgHY5RMAexs7XEmAntpnD5vmyh0QaQ4msrHdYpj?=
 =?us-ascii?Q?x3E3fEebwRpudXNq02oifDDgj14yNf3LH6BZfaVcPAI01lSGJeMwMPCCQv8x?=
 =?us-ascii?Q?JhFvPmHJS88NicKecJDoyMzJjGzD7T1n8Iq9y8qWoJY4fgQPc5CILrSeN3f5?=
 =?us-ascii?Q?PJRrOnPPMzn8M1zOVCG0kPDFttEkRO81U7DyEHZUOoEixX1h9xwZfkdJW/ng?=
 =?us-ascii?Q?PExDEkZgM2RxHV+HZYe8imFdr3i+/jhfzLn8FnAhgFOapQex9c/gzwIOgvrs?=
 =?us-ascii?Q?d7PQAymRPy8I/m1Xb5C3J/ZIo8n5QJNqyfhqe9IJOCP/yfdMrRyvr4oHdviR?=
 =?us-ascii?Q?LEZgk4PddSoSydSOE/tfWkFkGgr+qMoqIfIWErQPxPgsEWdiuBKChYCNzKKR?=
 =?us-ascii?Q?FCPwoRBfoupCEuQe9NykC5lcQoCg7D8h/YCo/z7uQMW0LyGymviehNjkLCyy?=
 =?us-ascii?Q?8OSQgtF6reVCHj9weJP9315Doh8trgFD6iJQtrUE+Qm68sTFwH6h4FelCP09?=
 =?us-ascii?Q?+kSgZndyND540rOx6bxxZW3QT5nanVvJEz0q7Ggd0uueOGtxmY5Ot/7QXlgf?=
 =?us-ascii?Q?h/5blvt5mQ1+cddii3Q9ZAn+O3sBlLDUEMbhQPQ6LEsqP3TLJWZRcepjeMJV?=
 =?us-ascii?Q?62UEGL0ytKmqFhVNVhNgpY102zLd9LBBUxz30l+MJmBLF0ZT85p7Ibu8IVe1?=
 =?us-ascii?Q?ayzbcrr04ewxXOo0YyWdZP1Hc9hKgeKxVaokaZaTZ+7leYlWNlsD/XGhtdGN?=
 =?us-ascii?Q?BPJp3QY07fLvWD/nni1vEL/jeLzQCmAB7pYr4uf83WM4w3SC0EiuQMILyq7G?=
 =?us-ascii?Q?4zmrmS/EueUiuF1pO5DC0BC7+zu09U0X3Dn1xcWi4+0Ny8xptOeNjWeJvBzG?=
 =?us-ascii?Q?qn5i6GvE4zBqjw3BQvBBM/5jeuRTyxfUpldRgfSKdgwWNxJRb9VrVq0yQQg5?=
 =?us-ascii?Q?gcNJgTLMzB+1eaGbVITm6MUe4cnuOMJ16N9J7AD2B8O7cNmpAijM+RQF8BoT?=
 =?us-ascii?Q?JEmLqImUl7d/s7GuArEjAKyMrTtTyBWyzuHIcJcnrFkzBlsE3NasnJKPhGil?=
 =?us-ascii?Q?iJozHAxQuDichq9D2EvWdq0LNolqcwZ/4euMiaO6oAJJ6gV8IID9Xva62KYg?=
 =?us-ascii?Q?x1tmdx9cNA6NBSNxt8eVCaUyJ9g+Nv5raKj/Kw+gEVQ0BOFbSdvOtfo84NM1?=
 =?us-ascii?Q?w6NyvsmioHwykafSoHh6xDcVfPPzsSvrNskZmXnyO0GaJWERlA/7rTCLIuPA?=
 =?us-ascii?Q?9yltWwc4k+5oB/rKVuvHTTELdtElVjvzFyXl64STOH11c3PCvZogFFazmrMp?=
 =?us-ascii?Q?tE3V/J35U7VxDBYyp8gEh6B3GJkWD3dE7WbGB43Tl4ecQd6tdl2x4jimWg3q?=
 =?us-ascii?Q?TKempXCVofTXNWjy6wD4duheFrboZy6oIg7Ite1SCz9zzx5T5D3L6VHbThQV?=
 =?us-ascii?Q?4UGVJKifIQewfM3iFlJIqBsYenYDwVSOWons+hoVJDH/bW5XAGjTvVuHgC03?=
 =?us-ascii?Q?2Xmh4D1F0srJd5uCj1TwpWK3x7BTf1ByfdVByJsIdSB5nyUZjJGMpXjKqKio?=
 =?us-ascii?Q?PjtmC/NnOtz8q2Pg2zjxt4tUPBfsUY7dyx5Javy/JzFiNTO33DmBFWr3tyFc?=
 =?us-ascii?Q?fDF9xUbzglmuI+5/yDC/G5+bsLmoDkfTtToNf4dtsk6c6BlynXxu1xXU6TA6?=
 =?us-ascii?Q?qfw+cw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3c8fae-3ec8-4617-0c15-08d9c2705c76
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:09.5345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ey8rrtUci4aOxaS9AgnfmoiiiOeWh1YM+90q9iCUaVrc9nfo9zpTnZm6CsEi3nqpzdQWnY8doIERWXWF6HkV/HwGyROJvLOetz8qd4iyKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-ext driver requires the phys to be externally controlled by an
optional parameter. This commit exposes that variable so it can be
utilized.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c |  3 ++-
 drivers/net/mdio/mdio-mscc-miim.c        | 10 ++++++----
 include/linux/mdio/mdio-mscc-miim.h      |  3 ++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index a7db8781310b..95619705e486 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1021,7 +1021,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
-			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			     NULL, 0);
 
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 7d2abaf2b2c9..e16ab2ffacf6 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -188,7 +188,8 @@ static const struct regmap_config mscc_miim_regmap_config = {
 };
 
 int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
-		    struct regmap *mii_regmap, int status_offset)
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int phy_offset)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -210,6 +211,8 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 
 	miim->regs = mii_regmap;
 	miim->mii_status_offset = status_offset;
+	miim->phy_regs = phy_regmap;
+	miim->phy_reset_offset = phy_offset;
 
 	*pbus = bus;
 
@@ -257,15 +260,14 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
+			      phy_regmap, 0);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
 		return ret;
 	}
 
 	miim = bus->priv;
-	miim->phy_regs = phy_regmap;
-	miim->phy_reset_offset = 0;
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
 	if (ret < 0) {
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
index 5b4ed2c3cbb9..5a95e43f73f9 100644
--- a/include/linux/mdio/mdio-mscc-miim.h
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -14,6 +14,7 @@
 
 int mscc_miim_setup(struct device *device, struct mii_bus **bus,
 		    const char *name, struct regmap *mii_regmap,
-		    int status_offset);
+		    int status_offset, struct regmap *phy_regmap,
+		    int phy_offset);
 
 #endif
-- 
2.25.1

