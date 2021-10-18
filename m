Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D778C43295B
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhJRV5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:57:17 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:24544
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229529AbhJRV5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:57:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJDA1TeVhx+0Tdt+txGcwgCZWu9sNn60ihNTFWXhS756mBSDTDlAzOKVhenQTWAvL+bjaDVCvNFiFh6fUxL7E5QF6bJIjKZLFc9JQZ1LacFpnmOz+3lYG4yzeZvESsFByRFwxn/nVM5260e6MF9QuoaxbANM0thCeeuZXaP6vCangS4rYVAtGBX0qGzYWhYGZcrPSHWchJyKwVKyEnfHQroWc7D4LBhSIc9uoR04aM7g2arwgrGUGpccuuSslNkToTkraSCm1MujXOzWSY/cFFDWvd9DHwPGKS0dMRM1X3q9umiqzTzfpfWOuwUALZ2ca6CMe3XKv80SAwapSz0hSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaNqg4SLqEbF0k6uAvpxThwQVIK9te7xE70uEeTzfL0=;
 b=hwyUnj3hZUMoUDbf7fFCOz6GjqU8UZWcv+PrfTGZsd2U/660wptcmFQRIOkXFLxsArB2XQV78R6xoL2puiclQLmW2JwhNIpyMqdqrK/LEJTByPXQEul1w8EW68nUqxFcX5s+iYYY6GfamrIeyLzICQxfRfUCmr7rsSqV+V2xjbt7Hat+nclM1l3f5usTKdRhLjk4gysQiw/zeNYIiOGlLfPvvbxvPPXxEW/t5SQxMDy9uxc13ZkVVq9kqIJ09ZLMGA/Pm/oykU3Z8MY1OziRpraxg+hiXsBwWYevS+Cu1MT/5TKgs8/1/3IZ+T1Fhvi6vzJHmT9K8AWdvXIms05d5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaNqg4SLqEbF0k6uAvpxThwQVIK9te7xE70uEeTzfL0=;
 b=eYaP9fYU8Cer9kSqg4wLaNsDHe31VIEXF+c4EFp2lQfY+u+mvdxJDa/0JAmkP2RmgIKkqjOUggO6KQDbpiSsfNdmx+v+bN1pCQ5FiA44UM/N+mmRE5VEw6SzQOTztirMTCkwl0e0J35CS61yfzPdkBfemsIOUZRjinvRXZS+/6c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (20.176.234.91) by
 DBBPR03MB5366.eurprd03.prod.outlook.com (10.255.79.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Mon, 18 Oct 2021 21:55:02 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 21:55:02 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 1/3] net: mdio: Add helper functions for accessing MDIO devices
Date:   Mon, 18 Oct 2021 17:54:46 -0400
Message-Id: <20211018215448.1723702-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0003.namprd19.prod.outlook.com
 (2603:10b6:208:178::16) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR19CA0003.namprd19.prod.outlook.com (2603:10b6:208:178::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 21:55:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49a1bdc4-d292-4fd5-4d76-08d99281effb
X-MS-TrafficTypeDiagnostic: DBBPR03MB5366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR03MB53665AC4CC8045DB464B64CD96BC9@DBBPR03MB5366.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LIokGSpRCdZTD+RxOoU75IsxuT2vE3EY5bFAyQ31Zw8h2iSXx+mO/2EIVIGcJ9uHxK/tABH4aqgPGYoBxWjuyGfRFXJ/IP2uuTThX9D7xEYbm9HwNgVyqbhWoLnaNX/kvr0Gix8dM0Khhwrme0sysEHCf340RJQTZFZiLOWwYtKo+qOpmXEfd3pe9JQl/HO1vY1o6SnKn9cuqfRsWXexKGzb9bQoxp2mDdVHa+NoJ3wAjTp6Bt7NXH71Wl+h0cPp3yOVlbJgh/HLyWWqTx842Rg1tasF1ECvPWQ+9bfMH/Ydnycf524Eza+6IQVMHpuHgPz80oQq6kXzmDjmRfyJWEtemlkWV0TQy5pF5YC1NJw5W8FffksvvoW47cM05qlNgb1EicLaZ6bkpXF2PwF/OzMikrXasPoLDOAgBsTKtxtqMihp3R+3VvnJP57Pr2zGT5F4gfyTa2YX8jGWhbablgyusggH/7BTNydP28ea/AVA/a5Xlxs97kVgtKQ/tzlDp+vpDFiwUHA7Mmmly9VyU9TRWexNzM1ljHU2iiS3WxG7+oe7Ewkmgd+RMhiInUHXAVVE0S4hI9UPO1ZjV+KMFqOHAB3KqBx+4Xqu/fx299GgxE7c9k4o5V1DEoOyydYXKYOGAv3akEBvcLPf+7Ld2Lh4G1YnlXjgv/LzaOPk2FzQKIOuDXNXOSFlVdJ/je9nR4ku+x4PCNNXfPA7HS1SFBIhf6gSguVHn9fRXNUtgFlyS3QNCV1u1oXNxabbLGKyX0ScnnEB4YOYkFvRSBNmlOFBvMCkPkC+996ntkHelSI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(83380400001)(52116002)(6512007)(186003)(1076003)(38350700002)(4326008)(966005)(110136005)(6506007)(8936002)(66556008)(66476007)(107886003)(956004)(6486002)(2906002)(8676002)(86362001)(66946007)(44832011)(6666004)(316002)(54906003)(36756003)(26005)(508600001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?esGudIiGy/XxekTdhxerP9pVHkWglB0S5abbKYTF+fSidQoenk0t0tDM0FSG?=
 =?us-ascii?Q?lMvhFdWN3uLV/eMszKj5GgzcyunbFVqu3Dtu1r0nc+mplNX9xD3HJ1NG49+u?=
 =?us-ascii?Q?o1d88UN4COq+aYgmeqB3fXGj4yST/tBwJDi3Ug9Y85Y131pd9SnGU0Z0uWZJ?=
 =?us-ascii?Q?rIC+Xp6lVam4vRQnO5OYwWmrF3O80wQ58l80ifGzExrWG4hMEHnqg2o4Ely1?=
 =?us-ascii?Q?t+wQ9DHMR4m8CQgxROx/sBf4flWj6bK3iP+qqaLhG8XU1+j7aQuPsbsf8HXO?=
 =?us-ascii?Q?xe4ExKfyJP3f/Z0m1SdkJ3Urs6DbrzzRbBEYms0+Ul0x9qBbP4fTm6VaUHND?=
 =?us-ascii?Q?lCz+bg+nO0CVbMpNkizmSa/rpl7Uzl7w6uIfTETIeEGqT8cKs5XOC1YGMH5u?=
 =?us-ascii?Q?cSpbRmkhiE8BSxV/b2+paTQBCWMzwGuxU8mQmnUrMZBIZs8CL5HxJw0zV7qu?=
 =?us-ascii?Q?XZ9zphRItyBNTKwVYhF3wrBS6dK+Ecbaq4LAEEqUClRgzuPj1+nzkKIiTEr4?=
 =?us-ascii?Q?h+eXwoZz/jOGWnFsi7v5Y5OLIAtrC7iMdKvokgyLH3aCB3mPK5m/69idVOZD?=
 =?us-ascii?Q?juI2baPFrZgcuDx9+oFj7qUb6yfS09axyF2gNuviTaH4M07aF0jFmPRIKf5r?=
 =?us-ascii?Q?jtvp1o7AYJcgmLs3redoBTySwK07xlr56GwA06enIxOFz7t+dNs2M81YgFZP?=
 =?us-ascii?Q?ZAzdPQ5gcjpCx6Da1qCC+aKlMz8/g7JdyDnVSqc3GCITfhhhTs5bclXog77b?=
 =?us-ascii?Q?xE3gC3PiSvISX0hoIJ0BtXCfUf0RtGicGpn94UKEBWSt1+ZHPVYmSswz3GLO?=
 =?us-ascii?Q?txkAOKBg5du7trRAe/lAP9vRjQ2GbTcNy9Gzxwwd2JxFoTSLP7DpG0K0n+nt?=
 =?us-ascii?Q?aGuTq7wwblIuJUdfm4kPvKzUpiTfajL5FDlVB5rnXusTTFnY6lMKLUhNgndI?=
 =?us-ascii?Q?r4/oMx2wwERr1tRtM7KU9fZsnE9xPvx3f4YbBP7roDVU4gPHvRJTrndgU0xb?=
 =?us-ascii?Q?UF5MDx5KzY3J8j9qhFG22MBCayauUOo3d/P2N13HZ2leVzvwWFRI1IN46qCT?=
 =?us-ascii?Q?zkxU1jvazba2bYJnIoZ+7aa+4xDXhIktnrIIEToy8zMbfuB06z6MKorlYBKd?=
 =?us-ascii?Q?PJ0FSsKtNOK9APVtaUHysMY/PAjU0+ji/La7H4BNNBPuSX0VSZI96HCii8tc?=
 =?us-ascii?Q?/FZhFQNNLG00rxJ4ai4D7v3bTWHqZ+rAajiKiU+7qseXqLETgr5BFnid/xfO?=
 =?us-ascii?Q?/r5p8xUlC4VZMLfZUGjzDbLFfjmIwCFvScQMglIIl29Lc43ll+VOl3I0+J59?=
 =?us-ascii?Q?r0T9LxueUJaHLtYIxPrUsNIS?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a1bdc4-d292-4fd5-4d76-08d99281effb
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 21:55:02.5995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kKDj7K/UiMNfIQ3KtP8eUWBLYPDDzfJ4hi59GH7Rn+fe/qvnzMGkh29g5y3raGXPi24fYiI6oBjzNG7aLKWr/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some helpers for accessing non-phy MDIO devices. They are
analogous to phy_(read|write|modify), except that they take an mdio_device
and not a phy_device.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This patch was originally submitted as [1].

[1] https://lore.kernel.org/netdev/20211004191527.1610759-15-sean.anderson@seco.com/

 include/linux/mdio.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index f622888a4ba8..9f3587a61e14 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -352,6 +352,30 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			   u16 mask, u16 set);
 
+static inline int mdiodev_read(struct mdio_device *mdiodev, u32 regnum)
+{
+	return mdiobus_read(mdiodev->bus, mdiodev->addr, regnum);
+}
+
+static inline int mdiodev_write(struct mdio_device *mdiodev, u32 regnum,
+				u16 val)
+{
+	return mdiobus_write(mdiodev->bus, mdiodev->addr, regnum, val);
+}
+
+static inline int mdiodev_modify(struct mdio_device *mdiodev, u32 regnum,
+				 u16 mask, u16 set)
+{
+	return mdiobus_modify(mdiodev->bus, mdiodev->addr, regnum, mask, set);
+}
+
+static inline int mdiodev_modify_changed(struct mdio_device *mdiodev,
+					 u32 regnum, u16 mask, u16 set)
+{
+	return mdiobus_modify_changed(mdiodev->bus, mdiodev->addr, regnum,
+				      mask, set);
+}
+
 static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 {
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
-- 
2.25.1

