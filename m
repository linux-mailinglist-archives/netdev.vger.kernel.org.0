Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BD8479DC6
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhLRVu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:27 -0500
Received: from mail-mw2nam10on2118.outbound.protection.outlook.com ([40.107.94.118]:19424
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234652AbhLRVuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SN3rSQ8818/pRaR6Yu2fSNBLOj1lk20kyZXzhasnCqz8a2DHTb4VcVRZemRvCPfYaVXf0kas8f8PTfYyz7h2STbBBbjU2pkAkBmjzSIJrrmPMHUpNwCchPVeNckjCpxkeGSqXX/o0covqVtaWUfOPNDhCmaZjQkKZ/iw95N8PSreDi/SR185mZbfTV0H1cuo94JApLQaDAAsu7NLtm0xXRZybrCtn15SopX0QQwcWK2tRrFar4kPURt+0TLboSVoc5ZFEays1LCYorhf4G+cNBN62/am96LNt+LoS6mwN/bhJoH+mTZ7GS0r6Vg1CI+a680323iKZLTPodc3MTLFVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5qPPLXRlba34TDiFxCp/SQqID2N+87bmQaMrWqNCnA=;
 b=ZHf4f+KHM4pLTIKlJJ6LZ//gEag+CRWcG4F9DGcRa9KhkJNqfQoPy0uU/MXIk++nnYz4lgORzkksuKmAfFXUxBF1MKKk9IhLxxLbadxm6vPy6AofAzO4/PxaJEDSBhEbDvCTeTVyl7Omy2ZFMQwXQa+8jbi1ydQjZfiCijmIusNqYoSxiclidO2W7SmihV2Gf/5XPwNdcdf9mwKsibjRSsa+pyJVfcYt09ivUglqO5oDaNVTJqcwFCjEtYSZk0YbNBRs7/3goHzcqlya8FCpdRNx6DvqacfS7A4jdJ8v8mTYHG/pFTsYaEF7Qyc8k+VS12lRjbvtaVPtkgyHgJbDjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5qPPLXRlba34TDiFxCp/SQqID2N+87bmQaMrWqNCnA=;
 b=nQvcEg9BxJoBOq1aPhlqNZ2XLMSDVPPGyB1CSc1XN5GlYJ27GAfApCbUTIsJmjMACCIgHRi8Y+jtTNg82Vhrw/SiwzO8CB6R42r2QlWkV1jeNVT//ZYQaBQD4hhA8Qt8xn/R2sTTeZnQLUl7M5XbaQengi7UdWI6BNQH5H9SeOk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:13 +0000
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
Subject: [RFC v5 net-next 10/13] net: mdio: mscc-miim: add MFD functionality through ocelot-core
Date:   Sat, 18 Dec 2021 13:49:51 -0800
Message-Id: <20211218214954.109755-11-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: e555cd5c-f406-45fc-bd84-08d9c2705eda
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633BB1B5D5FBAE9DF4F9518A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oNAHMqlU/NnoGp1bVthV6JxclUVjWr7DM5BiLyjLjJWNm8CxUBFMZeSQThLBF8g9WvxqA3yhUqyvBhzK2PFoV9AyjTy6sMYmvPPuYE0FL+him1ooMHjZTxB34N10bwVXLf/rvmwkq8ha2QNB7q9oIkafA6f41eO6Cit3xUIplt5MQ6joDv3GiImiNyMNyTCrd1++peKXE37O11YzPfjnWyp73zzgaAbyM8KC3nAuUT9S1G3cemHxuPAz8BeKu8i3537hcU62iEUpBkDggUI5ZEp+Zz8Hs+LSEHIG8/6aKMC9hv87VuMDDTMWnX4yEGmTN5JcAb+UD9qfVzsdM1pmCtAuZI9NjjC0TRh/YJLJETaLR3mOe3pmELf+enMZcFFK/PFu9/q0xWBaLHt9MFafsKXd07hEn1mpioObykmG++bW9IMaOhxT52akzynGUAnApUWonKrgEBpN69TMwtmLdyG8hTqM8f9KQ1g4npl7fNanQ/6oqBh+7yexKUcpwUPncv1i6+lbQV1YTbQ3KFiNs+tuwpI9RbWMxMrTTx9DsIhGvwgqX4Zbi84XWgggrtkO55Y1k53J9r/1jCJeB1n1PaALQk+DUTho1Cx1mYMqBOH/JyOlAm99p/RK+avIFe/9LO7WC1y1trSHmX1Dreo3k5I1YeCCl53xV4aYBjnPOICFCBXUesbJSu20XnGQHOaP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eNjJ6GO5V1gsxOBb3qWGOHMy8i+BtUJie07ib13udkwI2Dy5wGBKCu7IsxpY?=
 =?us-ascii?Q?lxpAz1CMTSnmo9NzZGhG2di+3/BATA8g23ZyXVwd4qx8JqePOGDCBL9sRMXT?=
 =?us-ascii?Q?uocAcIGKf4irEv9//eTpCPsgAVJKFMRvgwA1WkVTv5mR2a+LwX9kMEsUViKM?=
 =?us-ascii?Q?f5Rq2VCLLkYPOQ/qB4NPTa2psP0RWGWTyT5SXYhtuKJfKMeHeA4FmXEY3ibI?=
 =?us-ascii?Q?8Wpay83Ku9Ch1HlxekctJn0j5PNcCpnw86bbC6i2DMKB5EQajgAz0kcywZXX?=
 =?us-ascii?Q?KP7mNX9+O+55HxN8oTlpxqHLAEegpPXuA2JQ6Bt0hFwz63uPbDacZd1LkNaW?=
 =?us-ascii?Q?xyo2VKn8RjD/DXhY2UjzF2Mz3Fs2clFCWd0jVslVQ82rXAedF5Yp2NnpISX3?=
 =?us-ascii?Q?I9fHqmctH+o5gFl+mldv8v6JVQxxMpzSVHeu33s2fyxod00VUsjgBWO4U6Fi?=
 =?us-ascii?Q?j0lcMMfNJkkeiNpcxJOdGXyOQCAA64ePVLEQ2iYP0I69O2L+tWaOCP8Bb3Vq?=
 =?us-ascii?Q?U+F6+B50ccQKl/B4jOaDGfhdboE9IYjFKSABPKUQkk//dFhehCMweed5G24o?=
 =?us-ascii?Q?PgksZuq/ofkrTnZrTHTW4zrMcuBCMd5gAjlp+kHulDRFCLMlLXcASKC4Hbyp?=
 =?us-ascii?Q?CEFez4btbnsdbIoZLVb2tiiTP/on1fbzXL0mi6hHquE+YByqBgIgH2IZDY1o?=
 =?us-ascii?Q?eK1umUIehoVOR927/E6DYmjvhWX7PIfhdX1cR2oOhKFGzupX93udlGSP+ih7?=
 =?us-ascii?Q?99/mJdy2qKyXvyd46m7SgJwRkWmt92IR4Lsn8Jzl4OkmCav73npWHiw+9mdI?=
 =?us-ascii?Q?OwqiOPzVTUkVGmOLRcztX/oXYvd02fP7vBWetXaDTjMX4LPvLuOMBynHtNty?=
 =?us-ascii?Q?gEvi9N1d9Ewtos9m/500z7xEh5fwkGoWzzG6symNssLuGk+NIJxp/RJ3PMzF?=
 =?us-ascii?Q?OdfjPe18xVfIgET+hBYME1sLcsWfpS7qYppCRTS2nNOkuEveS+G/DJzMZuf0?=
 =?us-ascii?Q?Kd2Llgu275vOsVqLm6wlDdpQUnVeE/uEpDipFBvv/ZBQax1nRQfAw0a/CqI+?=
 =?us-ascii?Q?vzN1AzvtB/c4YjbKDrNMCwcb93xtpRFAwC0Ejw2XzEuxr3RwOgwDDnWjQgOu?=
 =?us-ascii?Q?Y+2PBy/DwS73nbC5xK+zgHyyz/B0tF6kQdxEXBOoJFpg0zM1OYrqaw4Fk7/+?=
 =?us-ascii?Q?gnX/sUKdcpEFRDtnIYCJAI818DVDzFjq8qp72Vyc2rZL4QbZBMw6o0QjcQaL?=
 =?us-ascii?Q?W9N5NhC24ZtlHOplosCytHEP4gH59b+JXrnEnXgv+KI2EYpAiWC2Wx9bTFSJ?=
 =?us-ascii?Q?xzbfBTVifwrrNKjmf1Kxma4ccQoNotE0e5+GW3uLtzMKnapcqvrHHOahRyIe?=
 =?us-ascii?Q?fQl54dM606ritI8iRW+ye1mBvrOfLf2SgH6AxSMBN1yD6BvIhc2mbGZvkQa5?=
 =?us-ascii?Q?xhbeX+JXTUHC6pnu98bi6uT63lLoYOIFlRhYmz1IYXm9e9SxEWBVTN7xvuZx?=
 =?us-ascii?Q?1GthKFMAvfXS5gaRHxws5LjVLPDMLDfIC3V30C4izhmDn8R775Sn4F9SsskC?=
 =?us-ascii?Q?l60Chc41Fh/1zUYN74dajDBSKELh7Cajjo6zhCFDvFrJdmt4R7ksFsXndE6T?=
 =?us-ascii?Q?g3MuIaIX0FPy6VMc54cCrLTSANVp7p5We3ni6DmpFVq+nrt/tX7MEFhJE0cD?=
 =?us-ascii?Q?2iGtsSFseAq2wlbNFbetlvEFcBU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e555cd5c-f406-45fc-bd84-08d9c2705eda
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:13.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THaj54JbtwCmbTLR81kqpBzPeo6K8MeeoqOEPn23HZP6pIAdmK7z1p7ZpP8wRGoN1h06wU3BYvr2wb358ktuh6DxTW1A/q4nvGusTe90330=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the MFD case we need to request a regmap from the parent device instead
of using mmio. This allows for the driver to be used in either case.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 00757e77fab0..d35cca4672b4 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -11,11 +11,13 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mdio/mdio-mscc-miim.h>
+#include <linux/mfd/core.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -230,13 +232,21 @@ static int mscc_miim_probe(struct platform_device *pdev)
 	struct mii_bus *bus;
 	int ret;
 
-	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(regs)) {
-		dev_err(dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(regs);
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!device_is_mfd(pdev)) {
+		regs = devm_ioremap_resource(dev, res);
+		if (IS_ERR(regs)) {
+			dev_err(dev, "Unable to map MIIM registers\n");
+			return PTR_ERR(regs);
+		}
 
-	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
+		mii_regmap = devm_regmap_init_mmio(dev, regs,
+						   &mscc_miim_regmap_config);
+	} else {
+		mii_regmap = ocelot_mfd_get_regmap_from_resource(dev->parent,
+								 res);
+	}
 
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
-- 
2.25.1

