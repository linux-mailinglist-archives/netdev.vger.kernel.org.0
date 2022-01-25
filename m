Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A2B49B969
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356278AbiAYQ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:58:30 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:56800 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbiAYQzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:55:07 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PBfHPh020266;
        Tue, 25 Jan 2022 11:54:39 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsyrhrj15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 11:54:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFeG3CmFWfX+I++Vqng5CJ7AO1vCjeF8nVCfdUwkSWdng49q827MSnigSa8RAef6v8CJWX8+LuxQ5f0BNNTEQkyM2fDm9F6NCnMra+wzRTzJEdM9/TsH5l8RIh6PJra/hSZZEY7eqtKBKkv4PgpEqtn/Q2FYB+URqpcrUmQg02rtUhNVKNc+SYgikJqAz+4GdrREqG2qWQE5G+oU328wg3cBAMcIHNuTcEmPsz7qkGa+A9/hQHdRiDD6yAexXmE1IOheLmMLbzccZlAP0WeuCRhmrrIxaG3+6pjCGK7JVqzcZglAiDcjUv6BAwYXAYntQnhmgAwxL+mYXR5KqDX9ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqCpLUeei2OgNC7ml3FC2a092V7OZpuFb6NcCys6+bg=;
 b=A/HjWIv3rDeuyp6qmwSjcUkHEv7jv50t4iFviWfAoAA64QPE/VFh7OxUxdq2RO8D6rrfIb8U65gL1aCy/uA4IEW8UoO5NX/P2cBa0nNueXxsHRjECdmtq6wBF+vLC6u3qP5uYCMTwn9ZfXUnVnkVqnCl+CRN1Ef72UKTJJZbSUeQlWizM2ZN/XJ2tylGM8E0Gk70io48HAhaDQaih41rAz3moxcepxd7A8gsZPJxcCUiN62SU4x8uDffuMiTO40rRP7Mc5blLeF+IpsIvZ4dzBJjkScgPy1fxlM+e/wx/JqcK57lnBxQIWEoRNejrtia+sOpsr6cmoPvIR9ldTuBLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqCpLUeei2OgNC7ml3FC2a092V7OZpuFb6NcCys6+bg=;
 b=T2DjAxb8yiNAj+FHxMTE7F031JWqAHEKHeXSwD6yTc3kbpg58s7MzcJykun415mD8UP0tiubJmgVeUbWEyxGIkBS9fpXdWE9ZWOiMLI61W1zQJhOLCgz39x2RbUoLFhTVLOr6JfP6LepgknGMEmDlH7t5VIfRUdwckNj/qQzvsM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB8631.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 16:54:37 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 16:54:37 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 2/3] net: phy: at803x: add fiber support
Date:   Tue, 25 Jan 2022 10:54:09 -0600
Message-Id: <20220125165410.252903-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125165410.252903-1-robert.hancock@calian.com>
References: <20220125165410.252903-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:303:b8::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ca14faf-886b-460e-8e24-08d9e0235f55
X-MS-TrafficTypeDiagnostic: YT2PR01MB8631:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB8631860899A3D7A961310978EC5F9@YT2PR01MB8631.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EyDac00YkfSK25iQ8188LX4F0fRIDkpLyWZ2z2vQk/deUd+lhZ/3d7HLYR9JhQtvaT0GXb1v6/85BiV4bs5IE5NlfUqKfKGXIRGdnVBZIsOBbsd8vSeYnPBSzosyl5sYpedX9d7lMbjGspwkQB05IBBPIKvaYV1V03YMdQrwOWIbe3Lf2B+Gr3dFQcEB/K5lwWbH1vObdPO7hI75nJBwSQEfcpzcUlFMFyHqNRBI8FAhLnxe2eTDo05t4yFQyNxPgF2uF5Sz8ha7DvRqr4ZTlZ+HVQtQDjesrmV5IYTBVIHlz2EP155tisGVrpuPRMD3QPassiBuwm39xQws8da4UKrU6JVkdqx6I6cuep/5xr+/RJoREy6mgyM4vGRDmYHJJ5XHop1XDw9TJITK//9sjAMWCbUTpv5Mp8JsG1LKDJU6Wo+l8wtKERI9VNn7sOZWtgAUYOmOFJXfC/jmjHjhoUbowj189ekyxhcvdRw9rsIDO4gd1hqWbti+Uy6BwH+ZSlhDCVbtvsAIz/CQpkejjPF8QQdP2yvOkLiIuJ7sxKNTlH+1CMKBMHBtgsn2rs4ghtwLvQIUjbjeZKCfqUMrBvNEZ7Hi6pRsOcJX8UfYm2MQrPgg2E6uE7FwH4PSI9UX1vx006fGjFJ9M17FAOjDYs18CfrxW9LIf04H1HTLgtE/hLzyboF/NAjUw8zY5H6CiGWPmCPjg6LOHfZZ7xDzVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(52116002)(6512007)(86362001)(66556008)(66476007)(6486002)(6916009)(2616005)(5660300002)(316002)(66946007)(44832011)(1076003)(38350700002)(2906002)(83380400001)(4326008)(38100700002)(26005)(508600001)(8936002)(36756003)(8676002)(6506007)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zmAOkooMWqMUAYUTD46sHh4OoNqINbi44YDQQ1qk0psL8E3qmcES2QnQV/Qq?=
 =?us-ascii?Q?lVmhsh/V4wetiOZ5Ez8Zzfo9XMpzFNNNNlzD0BwHqhuW3svlahOta6+Jxrof?=
 =?us-ascii?Q?MsFh1iIIa1Llac466nzJNv+ikukSySY6pueGRXkc1t2prTlWS8bKFtf+uXm5?=
 =?us-ascii?Q?co2kSh2cFXXD2eWekxn1hz+iWq3sDbvfZvH/OkptWkHsO0djgX96Kf1X++uP?=
 =?us-ascii?Q?kVzykzIKTwAiMnWwRbCRRFV1R//+37upJd94rPVuIf1zBs211a7nFMs1nw5s?=
 =?us-ascii?Q?VRWlTLqWEnh2qGGt6gLoA0m6RsRc0kC+yy8fY/V7Rx+qWobkH+QBo+132pO4?=
 =?us-ascii?Q?Zki5LBPkgLgDbewgaKgMvwoo4efghU/8onBiFDMSIOyrLZaoHwb8JPHX/AXz?=
 =?us-ascii?Q?sB7kaRCk3YaXOWRjfJnaLmW5IFjIdaFpQnQVYn3FZfDLxPjbKV50zL/h06ZQ?=
 =?us-ascii?Q?DIc/Adq8suWztaIvCZYfCGyyRG8yoNJm3ZBAp6WWLk7dQkhRCqun6zzuJLyk?=
 =?us-ascii?Q?v6Fiw8K/SkUY3xZ7g2sIsQYJ3K+xyW4fYqtlhwZFu9wp1UhCzgO1OJyCuatQ?=
 =?us-ascii?Q?Jdmp3JdhNZkfg8xC15SYsX7dgFrHKLVhx44MleWv7YP8jPA4iA2ihA9bgkrM?=
 =?us-ascii?Q?JxUX2Bon0zy3GT0q8r9HmMtA2nLId0aRIc22M6wLVb4eAUafqTrDoI0ON1B1?=
 =?us-ascii?Q?lhlh4abFxNVphaEPUvw5nHncGU8/zABX8LcedhmNf5Ed3Yb46JPhsdekvegG?=
 =?us-ascii?Q?ScXU6o04ur51HxIGoDccss0VQoX3b+HzeMGRHW0+qk3tSrLATIzpiwUHTxYx?=
 =?us-ascii?Q?/lqtK2oPiZI9IZuQ8+7DQEjiaoLiKT4l5f/u/VaTjVPe7oouMwYNbUqkXhCJ?=
 =?us-ascii?Q?W58hhgPjdXlNGw8d32VxbkDI5/O0gnnfnmfZ8gq/lNDNSWJG4/cwU3rFODtZ?=
 =?us-ascii?Q?SLCji3UdLYegkdDbJcwki1tiPXMZdB5Er2yohy4lxD7atExk4bImj4yz3FFa?=
 =?us-ascii?Q?gL1NX2AIxgCRlVVWUt0nsqjxE+oO7pOJqdu0Z+KSjeBiFttioyuiOHT9/Z5Z?=
 =?us-ascii?Q?FnTceFp/JZLVWYqbcRNUxgAw9NxEtvD5VFut4ukz9M5BbVmrU2zMXyJ+hQft?=
 =?us-ascii?Q?H91StGNr3W0Dg4cQzYNi7NYSqfGX9ra2yjCeIWBku9wI8K1Rgu3iIJfo3Bdu?=
 =?us-ascii?Q?QJcdTElEmyt2aUwM/UOmT2Op1SMPY4RNkc9cKdZQkmwQsXW1m1pSgsa3KiTL?=
 =?us-ascii?Q?ifKDyP1GQ51AfJCdvAds6QJAO2U68pyV2Oi2T9MPr28jzsx520TXe97ozGYO?=
 =?us-ascii?Q?PIQjnBw5baKNeIwVEzpgzh/BYv08dYRJKiGO5IF+iiVuhI5edxpn4QHeALGY?=
 =?us-ascii?Q?qmbuqYbJ1DZIhTeZ96VdWNOoE80x080Cbr9+t1wuSs0E6mvJy0zJ1PXBJbiX?=
 =?us-ascii?Q?NMadD4GpU420nMAJJn6bsd6U0kEYZb7Q+8RmBLYJs1UfwUMfUnXG2oG1WtOb?=
 =?us-ascii?Q?Qhp0AUxhCEsrJHL7aWMQFzjoCMaOTINVCKm65ZOgn/UG8RJVF8QPufxhNZjh?=
 =?us-ascii?Q?8yhgHBsXSZ9wj97/p+gInhHaymUgJyteXFBQeDA5Y72TrxSfrtUENWpAahiv?=
 =?us-ascii?Q?azovCPSUYhxvK2FcWcVfSGKKdDrMYcESLy+OkXTpi6kdifUDLRyTx9QWQZ+b?=
 =?us-ascii?Q?zTbbm1PiPCxswhjbaK6wH+taOgM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca14faf-886b-460e-8e24-08d9e0235f55
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 16:54:37.8961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoahYrlA+UQ4glUSsH8ajqELcy2qGexA2+PIRtaH54Gm7t7J3LQ0wOoI68nmofm91tNS47zqFhJBgyv35ZBKDJFeGrKWVmpFZyoRx4SAIl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8631
X-Proofpoint-ORIG-GUID: hGNwb0W6W7LU_JvJjmrxDz5jMve4czQl
X-Proofpoint-GUID: hGNwb0W6W7LU_JvJjmrxDz5jMve4czQl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
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
index 052b2eb9f101..3f3d4c164df4 100644
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
+#define AT803X_MODE_CFG_BX1000_RGMII_50OHM	0x02
+#define AT803X_MODE_CFG_BX1000_RGMII_75OHM	0x03
+#define AT803X_MODE_CFG_BX1000_CONV_50OHM	0x04
+#define AT803X_MODE_CFG_BX1000_CONV_75OHM	0x05
+#define AT803X_MODE_CFG_FX100_RGMII_50OHM	0x06
+#define AT803X_MODE_CFG_FX100_CONV_50OHM	0x07
+#define AT803X_MODE_CFG_RGMII_AUTO_MDET		0x0B
+#define AT803X_MODE_CFG_FX100_RGMII_75OHM	0x0E
+#define AT803X_MODE_CFG_FX100_CONV_75OHM	0x0F
 
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
+		case AT803X_MODE_CFG_BX1000_RGMII_50OHM:
+		case AT803X_MODE_CFG_BX1000_RGMII_75OHM:
+			priv->is_1000basex = true;
+			fallthrough;
+		case AT803X_MODE_CFG_FX100_RGMII_50OHM:
+		case AT803X_MODE_CFG_FX100_RGMII_75OHM:
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

