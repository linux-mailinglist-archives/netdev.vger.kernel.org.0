Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B073D48CA0C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355772AbiALRpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:45:12 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:62794 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355882AbiALRpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:45:08 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGTfDb011851;
        Wed, 12 Jan 2022 12:44:44 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:44:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnWuVZnK7Rh5oQ+IgeGwdWw/Ba2VjYppjkddI/MPWcyafQWoeKupXk4zw44ofK1rHWnA6Kxi6YX3BwtGyfEZ5j4slEI1VWsDrT73TiZal7rFIel6wf1M1O+JPll/FyYcdX+ID4us2p1303Q/AYp/uxguq8RINGu9YZvDciHhQ1By4nWNKIlYL+9mry/XQmIihgDgZYn4L63jEj9zCn0mpE9U2cmSpsoH/8pMCmw8+BfI+8nPWcC1AscLaBdvc43fe4Ycx53lFPbuZ558/5T2toRHwxFFWAkNNpXPbNaB06dOnToY3SoizZP9PSFSsshyP40Obvt92w2l+k2R8RdGBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVJOkig9QGwWZQUgg3Fhko0kVzyV2cGqWNLIij2MbIw=;
 b=BzeMYreNOOimLadwmOLeZzzSGJZkgEaPc7SxJk9k66GaWxccBitSu+Q1YN3z8CreZqoVyv2mwi67xf3h43ttX3uoo2VRSCHAzmoa+nwOIC1WWY3KVjRKHRSj5PtTnpD0Cj7IvS4I0rosOtTZrnU9gxxUtOLqjWVaKEZ04KcGJqZVtdS/mpwfGAm3aUZIGTtLmDfcVEpVv9lvhqM/nF0LKE3ewCkD4mRhQ5nkb49MJtGq2tR0QEwG3a7HhsOF8Tdm66tdayWMFWQCcFpYeEDenrhdVfDGpqFvkKk+g1k8EafIFMIOCUHOhEXzspsMZkQMIngClXK7NB977tIrIUjAOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVJOkig9QGwWZQUgg3Fhko0kVzyV2cGqWNLIij2MbIw=;
 b=XHpsyqYtL2rhBd9s2yjhpWR9l4yIrzeMEFHjMjC57sK4WAN0oRPfr6bNR4aIBEZgXVkuIf90blKtatnmLxQuL6LD+pxSQLE1ukzLZd948KaGUDZyr9bVV+lemLVQkiDBc3f+KyPxwOaR7tRHs3iGF50d1fjaoGcwacI9VTPsBx8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Wed, 12 Jan
 2022 17:44:43 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:44:42 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 2/3] net: phy: at803x: add fiber support
Date:   Wed, 12 Jan 2022 11:44:17 -0600
Message-Id: <20220112174418.873691-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112174418.873691-1-robert.hancock@calian.com>
References: <20220112174418.873691-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acf964f9-f248-42d2-c126-08d9d5f3371d
X-MS-TrafficTypeDiagnostic: YTXPR0101MB1215:EE_
X-Microsoft-Antispam-PRVS: <YTXPR0101MB121535417B365C07E2E13D34EC529@YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F7P5AquL77re6E5Lr4tdQC/gn0GTrjC/9dsH1rQrSzItjl9aDYDrARRXW7YpTsM67LkAOcOzHZoXTmjatDnBAnFO5Akkr2ASBzQH6al+1pO3gSPiTRXlWsIhYXh+Ow/B/RRaimLeQLYqr9d8UyQF/IS3kAAyY9lAFdjiYQXD8kNZwbfJQj+DnbL3vXtHuCGVfEsf1zhRctvANK8PdpfWJN+E4zyGrt6sEFfCuLDv45f38EaIeuYrBO2Ft+MvN/d79MU6LcTeUN7jul5aBgzE9igvy3RN5qjCM5CayIOPimvQ/+YH5Pd9ETMcbrRFDRsTYSip+zGhfUA0Er6QOnXLS4uAM7I1DgDXareboGfjsVC8xQTBjtR/eSGI5xhjy8Y4HJehoWAXz3zO5bUT9xWTlUgEpc/TTT+ZOkv1Uskcx2/2JcSOgjsHSxJ0SkYhD3sOef9ys5yzFHA4cVZBXf8rzOYYDKjYpp8sg/TnTTh1CfrXE7wx1NwCqnJzpy6roEwIvqUFk9RJebccN2tcOGbuEJk/uNGBwceYE/579uwDBUGsk4mV+CS6ZcHCpanTKcjEBNyyft32ik5tpzufLesY9ChiBsy2v9pmS34s/6U7WInEAjXcJ1otZapvJY0Exg+e6P8T2Yi+Jp/GnDeuQN/gvEla2atOhLTv4pcdVBwpknkYKp60luo8C32QhT6qok0rdC4NIWJdqnRuyQbsdG1MqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(107886003)(66476007)(6486002)(26005)(5660300002)(8936002)(2906002)(83380400001)(6666004)(508600001)(66556008)(186003)(1076003)(66946007)(6916009)(2616005)(316002)(38350700002)(6512007)(38100700002)(4326008)(52116002)(44832011)(6506007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u2Gfps1NMzw4K+lM0/UpYi2kF7qn8xkJaCPz8hgnxPGHoIqU5RWqspvNNjLd?=
 =?us-ascii?Q?ythpEk6toITE1znrzAhy+3xwt6r5MKvfRjoneO3XshBLcvoeksJ8Rcu8Spbm?=
 =?us-ascii?Q?CtN/qaclmbhUgIoFnJe0PqF0jL6bHNL9T6l/g4TtYqVRIlNCfw1JgG1ZXxhz?=
 =?us-ascii?Q?j+0aa8sA8SLT6yIunihimxWJXthZgVcihlewz/5UbIx3C/moS49j3cY2/sJ0?=
 =?us-ascii?Q?1+Hu61Kc5VpRTkr+nYeR5i5IBe7Yvd0tF1EUT0ldL5Ri+YAOE75P/FRsjAOe?=
 =?us-ascii?Q?PMJGWNx/YBOm5KHqg2F1aiMJ7/ZEaPZtio7ROEf8I0cH8VaggMIxOCwFHmCB?=
 =?us-ascii?Q?pJQPsoXxU5X7wToxsgKn+9GlKZLSEPPyvIeaYf1kr5uIImFBacUg6nEfsEUV?=
 =?us-ascii?Q?fPSZMLvZ/bvpYhwQu2eCprtFMILzVan8RJ6U6eeiC3B5V0HZnUTqvCvJz/MZ?=
 =?us-ascii?Q?azAitquGtvXS9090vFScO7uD2aj27/hPNLdtxhUGpuNWPnjkD04VQwt4Ltfz?=
 =?us-ascii?Q?P4dEVAjD1RJ8wmXBW9okli+3yZq8vR6eZfjYlj3UEU8tSNlJ9N4QQYU0A9kw?=
 =?us-ascii?Q?ESisDIUz7b2Sm9hAr3wBoeDDWyvuhSuC5AO8ciS3zqWszz48NlM1Sg8IpEhe?=
 =?us-ascii?Q?W8+Z8wATLS4GtrKMjZwJ6RldaEX5XMzEJJT860iWmo5YiRx2y9L3pYYtvXkj?=
 =?us-ascii?Q?6XPOrOeVbLXeG9dLlovIqAEdUbunagHgoPRBaJd1GIm3IlJc7e70NxNXxTzm?=
 =?us-ascii?Q?sOG4pTVJUwVbvQCK1pkGITNxL5FigLptCepeWj7caYm7JHy5lBgt9vO7gpBj?=
 =?us-ascii?Q?Xn84IEIOh7AUkDcHlfWKoNVXRw7yysvWdJNgO0uj5Jl7hxG8Ti1QMN/vNOQI?=
 =?us-ascii?Q?0EBHbKkjAxUT7slgWvYU3VrW4ZU3pAlFiJanqWhCIMdIZD21deqqsidzr+ko?=
 =?us-ascii?Q?eWVg2K5uGMMZjd5kHYY3zxHiqzkf6YKQFmC8FOdaKdFC6xThZOqoo2GaX8WU?=
 =?us-ascii?Q?zDM7nAIUeV517AiteyB3Gv2rfri2vCAUwK4uCP/BDhhE1z9CMxXdhjrKYJvc?=
 =?us-ascii?Q?HnxrR0kc/8WmmVEGGxL+G8fWo8lTuw3V4WzR/f8rYSS8dEWOOxISSfmaKC68?=
 =?us-ascii?Q?dd/4CPLApTOmxO/Qu+6n3YeM8+XWfBsjWAwLIJqD3bRPNm4HKSFjsrsoYrN6?=
 =?us-ascii?Q?ivo6bxNhwDKe2ZxA5n8cpGUxSkZtpSrn7LUSwpLdyzVfndEa51vcwiiRp4VQ?=
 =?us-ascii?Q?PvE2vB5+GeQfw+4u6ozalN3vMlWG0ZQBokYFAYS056a9L+c1AovOL7FYcYwq?=
 =?us-ascii?Q?HAvZH6EWOUDUXzPi/aYF1zk2FXjqC2MysAZNUJCvWhS7R/9z1xr6zWr4wybW?=
 =?us-ascii?Q?ACk10AY+E4GbByLwXvJHx/wj0ZfKzy4cyr3o9Sp6smhE+ySWvrUrFOHuDdUH?=
 =?us-ascii?Q?b/SUrnlM021+h2docym7fkTtfHJfR+caGfdISDzZMGoRDYiS8IxoHQ0BaQXj?=
 =?us-ascii?Q?kNWAidk+D9/ItUjIUAg6jAgrLwCw50eR+l8Q8ctG+Oby21AMFu7qawfjmmQJ?=
 =?us-ascii?Q?v6Iu+lR9kDv/JhkqxCUdKSaz36dROnoSKSDejI/jWW0BFU1PxHNGMA+f3OoI?=
 =?us-ascii?Q?Fq96wmAVdRlAh+kcPvmB7abFUTHWu9z/EQpKeVUciIyfvdHGchHfEp+MSD+P?=
 =?us-ascii?Q?OuD9C8gXhPh+T4af+CATYPO/9jM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf964f9-f248-42d2-c126-08d9d5f3371d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:44:42.9195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbGgOZZarQ3/DJeia0F3oGbtdv69Sj+jjElhreZMtbPB+BlsLHbDqDfaFMp/oQejzBWllIsfOWp4x+SmqzSbDdCSIzYUdkck8tDACp4crx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1215
X-Proofpoint-GUID: bhNo9WacvieUKGMlGPNlJebP88zrITY_
X-Proofpoint-ORIG-GUID: bhNo9WacvieUKGMlGPNlJebP88zrITY_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously this driver always forced the copper page to be selected,
however for AR8031 in 100Base-FX or 1000Base-X modes, the fiber page
needs to be selected. Set the appropriate mode based on the hardware
mode_cfg strap selection.

Enable the appropriate interrupt bits to detect fiber-side link up
or down events.

Update config_aneg and read_status methods to use the appropriate
Clause 37 calls when fiber mode is in use.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 76 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 67 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3d7eeb572be8..63d84eb2eddb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -51,6 +51,8 @@
 #define AT803X_INTR_ENABLE_PAGE_RECEIVED	BIT(12)
 #define AT803X_INTR_ENABLE_LINK_FAIL		BIT(11)
 #define AT803X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
+#define AT803X_INTR_ENABLE_LINK_FAIL_BX		BIT(8)
+#define AT803X_INTR_ENABLE_LINK_SUCCESS_BX	BIT(7)
 #define AT803X_INTR_ENABLE_WIRESPEED_DOWNGRADE	BIT(5)
 #define AT803X_INTR_ENABLE_POLARITY_CHANGED	BIT(1)
 #define AT803X_INTR_ENABLE_WOL			BIT(0)
@@ -85,7 +87,17 @@
 #define AT803X_DEBUG_DATA			0x1E
 
 #define AT803X_MODE_CFG_MASK			0x0F
-#define AT803X_MODE_CFG_SGMII			0x01
+#define AT803X_MODE_CFG_BASET_RGMII		0x00
+#define AT803X_MODE_CFG_BASET_SGMII		0x01
+#define AT803X_MODE_CFG_BX1000_RGMII_50		0x02
+#define AT803X_MODE_CFG_BX1000_RGMII_75		0x03
+#define AT803X_MODE_CFG_BX1000_CONV_50		0x04
+#define AT803X_MODE_CFG_BX1000_CONV_75		0x05
+#define AT803X_MODE_CFG_FX100_RGMII_50		0x06
+#define AT803X_MODE_CFG_FX100_CONV_50		0x07
+#define AT803X_MODE_CFG_RGMII_AUTO_MDET		0x0B
+#define AT803X_MODE_CFG_FX100_RGMII_75		0x0E
+#define AT803X_MODE_CFG_FX100_CONV_75		0x0F
 
 #define AT803X_PSSR				0x11	/*PHY-Specific Status Register*/
 #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
@@ -283,6 +295,8 @@ struct at803x_priv {
 	u16 clk_25m_mask;
 	u8 smarteee_lpi_tw_1g;
 	u8 smarteee_lpi_tw_100m;
+	bool is_fiber;
+	bool is_1000basex;
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
@@ -784,7 +798,33 @@ static int at803x_probe(struct phy_device *phydev)
 			return ret;
 	}
 
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
+		int mode_cfg;
+
+		if (ccr < 0)
+			goto err;
+		mode_cfg = ccr & AT803X_MODE_CFG_MASK;
+
+		switch (mode_cfg) {
+		case AT803X_MODE_CFG_BX1000_RGMII_50:
+		case AT803X_MODE_CFG_BX1000_RGMII_75:
+			priv->is_1000basex = true;
+			fallthrough;
+		case AT803X_MODE_CFG_FX100_RGMII_50:
+		case AT803X_MODE_CFG_FX100_RGMII_75:
+			priv->is_fiber = true;
+			break;
+		}
+	}
+
 	return 0;
+
+err:
+	if (priv->vddio)
+		regulator_disable(priv->vddio);
+
+	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
@@ -797,6 +837,7 @@ static void at803x_remove(struct phy_device *phydev)
 
 static int at803x_get_features(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err;
 
 	err = genphy_read_abilities(phydev);
@@ -823,12 +864,13 @@ static int at803x_get_features(struct phy_device *phydev)
 	 * As a result of that, ESTATUS_1000_XFULL is set
 	 * to 1 even when operating in copper TP mode.
 	 *
-	 * Remove this mode from the supported link modes,
-	 * as this driver currently only supports copper
-	 * operation.
+	 * Remove this mode from the supported link modes
+	 * when not operating in 1000BaseX mode.
 	 */
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-			   phydev->supported);
+	if (!priv->is_1000basex)
+		linkmode_clear_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				   phydev->supported);
+
 	return 0;
 }
 
@@ -892,15 +934,18 @@ static int at8031_pll_config(struct phy_device *phydev)
 
 static int at803x_config_init(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ret;
 
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		/* Some bootloaders leave the fiber page selected.
-		 * Switch to the copper page, as otherwise we read
-		 * the PHY capabilities from the fiber side.
+		 * Switch to the appropriate page (fiber or copper), as otherwise we
+		 * read the PHY capabilities from the wrong page.
 		 */
 		phy_lock_mdio_bus(phydev);
-		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		ret = at803x_write_page(phydev,
+					priv->is_fiber ? AT803X_PAGE_FIBER :
+							 AT803X_PAGE_COPPER);
 		phy_unlock_mdio_bus(phydev);
 		if (ret)
 			return ret;
@@ -959,6 +1004,7 @@ static int at803x_ack_interrupt(struct phy_device *phydev)
 
 static int at803x_config_intr(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err;
 	int value;
 
@@ -975,6 +1021,10 @@ static int at803x_config_intr(struct phy_device *phydev)
 		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
 		value |= AT803X_INTR_ENABLE_LINK_FAIL;
 		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
+		if (priv->is_fiber) {
+			value |= AT803X_INTR_ENABLE_LINK_FAIL_BX;
+			value |= AT803X_INTR_ENABLE_LINK_SUCCESS_BX;
+		}
 
 		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
 	} else {
@@ -1107,8 +1157,12 @@ static int at803x_read_specific_status(struct phy_device *phydev)
 
 static int at803x_read_status(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int err, old_link = phydev->link;
 
+	if (priv->is_1000basex)
+		return genphy_c37_read_status(phydev);
+
 	/* Update the link, but return if there was an error */
 	err = genphy_update_link(phydev);
 	if (err)
@@ -1162,6 +1216,7 @@ static int at803x_config_mdix(struct phy_device *phydev, u8 ctrl)
 
 static int at803x_config_aneg(struct phy_device *phydev)
 {
+	struct at803x_priv *priv = phydev->priv;
 	int ret;
 
 	ret = at803x_config_mdix(phydev, phydev->mdix_ctrl);
@@ -1178,6 +1233,9 @@ static int at803x_config_aneg(struct phy_device *phydev)
 			return ret;
 	}
 
+	if (priv->is_1000basex)
+		return genphy_c37_config_aneg(phydev);
+
 	/* Do not restart auto-negotiation by setting ret to 0 defautly,
 	 * when calling __genphy_config_aneg later.
 	 */
-- 
2.31.1

