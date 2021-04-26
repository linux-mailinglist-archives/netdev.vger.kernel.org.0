Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C814336B02A
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhDZJEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:04:52 -0400
Received: from mail-eopbgr130049.outbound.protection.outlook.com ([40.107.13.49]:40686
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232068AbhDZJEv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 05:04:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewj+Oohjht3w+3STd7dTYr19mkQlEyJUPOYCnfv3LEd+3OPmRU0QKgh5rkKXRr+KA4HquETKSAheiM5qiHPOp2Fi9AMn4kM6AMABnYlbStDbOgxyjCSJ7jkemLDlVFtsP4Fky7m3NQjkxPXUY6ePJd+3iZaeqU4LZ8UblzvykAzy10p8DoeYieXcVtsE5to8F1OP1x1pue0ttmkNeKvaszIEtSsAJa2/pjN/wZZ/93jodf8SafLiZEFO8CjQ0ov0cWIKWulpCt5GHtFQbcUju25yKdZm4Vf7WF8W2RNOzVX23/vyK2Nt0rs8qBpuEovlO/z3XsxZSoG40/tBc/n+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hx6odzQp/65JNVYj6t55TP+aFJgLs39KADt4VXJ3lLY=;
 b=IzLooIOGxVHeObi9fPK0j8Bq3NTOXfwBZADYTAeSUpPg+2z9MqMEDluJj7H5wXlxCUV28TF/IpPbtHpahPUmLc6h8BNWobhQWOtbYPnhwEss/t+BqW4iRY5acfGrn1MX5lleKdPUo0Ff6yZILBZZSVXybli60nlaIO8LoY/wx3LcDiUdQMPYiEmR4aTVY3Y/63l/n3+9YXfKn6Cm/jwMz2WMLi9LjAQvivfE0URQlPf1hWKhRBStQ3ZG81NffWgIz0kui0i8or5AvrcSWSIu8KBLquwyF040kQaBf1Rsh5/U91tb32PMXCngabGsKBnnhqAylmcSWsDxjLlu9CjQow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hx6odzQp/65JNVYj6t55TP+aFJgLs39KADt4VXJ3lLY=;
 b=WOxqs4Dw8AgxK+uYVxiXZF4EVSZWjiBUEQHTZDN3zmndEc6bYmJwOyT+V0QXgM7KDg2HeBSCRG5AVfQGiV/kjTfvbDmtBn+JQTqjb5XXEqYq2HvV3+PXcMl/126CkSPqjA/VBtc3WPXI7qSxt875pIHfYd+rhD0QnTxe7SkWgHI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5307.eurprd04.prod.outlook.com (2603:10a6:10:1e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 09:04:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Mon, 26 Apr 2021
 09:04:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     Jisheng.Zhang@synaptics.com, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V2 net] net: stmmac: fix MAC WoL unwork if PHY doesn't support WoL
Date:   Mon, 26 Apr 2021 17:04:47 +0800
Message-Id: <20210426090447.14323-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:202:16::20) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0136.apcprd02.prod.outlook.com (2603:1096:202:16::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 09:04:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df6133c6-ab6b-4122-ec4e-08d908923f7e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5307:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5307858B0524CBC1053A61CAE6429@DB7PR04MB5307.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LCiIrXHZ1Hs5j1p6qYjnJCw/XINNt+mkqa8eUdPV1oWDi6Y0RkQqq0MuMXAzMsA2OwBZAtcBfJ5QMU/6mPG53ExJPtywuK5dvyutvvO0+3tvgBfCyJ4zbUMTjY9BxI0n/IvwpveRM4hYeO02XOxTpZPV//F+JzTjYrPWanQMJkXlaDpqKsmE00suSxJ9zvr832wz3Mp5JT6C9dWPG2nSYofUeyDWg/m6puEtU65lMssECWHLJZaXv3hKHAQsmRQnyRy6CXuIwd+Ao++dLc6KCKWuiGXcz+fJjgMkHub15I3EK7Yy+1u9Pb0vsFrFM6nGu4Tw2+9hBNksvtKdcoh0iDHXrDPre570imiBBvz6LFIjiNQpZKkiuPC9M/6Ac2Qgi4ivFJiFExj4IOAJsPiMRWOrClrptGSydisiKZK0bdKW+nt8IWkjKF4wy4uD6//gcN5frbYJmH/sXDOYTGcD+cnppnQtAx6rGNjNKeIFPnhUL/2vhUkCQ/Wiq1VkCi/aQB9aEsJU+P9ZJnFreUbKOsSeMEAjm5F2PaCyG43h6VcisPuXMQqb24ft/1vArJPD9kisZoJ0Cw+h1lt/AKA60Q/2oFUvbzxO0sZdil44T+xb1Nszl85R3Lo4A+fUS7foApgE8eWmX+ZvMd/urZUUlMfsRXpahKsoZ4wQNcHAuDx+ojoktMY5oNB8jMtCPtoDJVfq5ENw0buQ0WHiHJXcQ2B9eyIs6Qje2k5xUJZURC8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(38350700002)(36756003)(38100700002)(16526019)(186003)(83380400001)(2616005)(8676002)(956004)(4326008)(6512007)(478600001)(26005)(5660300002)(1076003)(86362001)(6506007)(66556008)(66946007)(66476007)(6666004)(6486002)(316002)(52116002)(2906002)(8936002)(69590400013)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?r+ok09D/tc3WVvep1R1nFNlPE/VfVEYAe1pmabm/JnZDs7GlYrZAP6QWqSgy?=
 =?us-ascii?Q?/NDs36Idk2GexfHTtoGukPj5Jo8iJedadNtsLM2wvTks+D5mpAMU8Ccrv3w4?=
 =?us-ascii?Q?Asd9D3+wSjqUk/B3A7qGoae/DN365VJyJKmRPp2GhbWvB/d7xyoWcNoTW2K9?=
 =?us-ascii?Q?TeBz8Ii0QN7E46IvOO4kS4hkUNY3t5T97TPRSx1Z8Ma/Vkks1gIM/9ngn5xe?=
 =?us-ascii?Q?/HPQFk5h05o05sRoo3xej6tVjSXU3bCokzyyOIZS77APkZ55ZZlM5TnxA6kO?=
 =?us-ascii?Q?oYCAOJaMsbNnkBSSrSDxZs6L0YKDYwe89T7l41dVYnKZJc4AQ0reAbJhURUs?=
 =?us-ascii?Q?Kb5GdK/vXzPdgrVn90bg0jZhZt3Iw2pyg1s/is2tK4Zw3nE54njewHp5Pz7l?=
 =?us-ascii?Q?T0EYkwpPwaUTlhnXVk/+uq2Z0qeUObY+59tCIgsp8DCsmDJdaEpKIsk/Eym4?=
 =?us-ascii?Q?yYjn59PTFdS3kapn9aVolWhIBOMzQPVHtND74Ak2GKQ4n3YdMq96n6lI7UIm?=
 =?us-ascii?Q?Wh9eyUyRUY3ukEZ4xMyyWkCBvT2ivpSqAmNNlydlMDH5+4sntVvIl4Vws8aJ?=
 =?us-ascii?Q?PNsMv6NGf8DB+HQCq3jyU9xeGxyInXABwuyFgaYaoim1U0VtIYY3pgOtX9Xn?=
 =?us-ascii?Q?HcvcOYPAZcuqC0T5MMb5NH99PFlfNnm1xoSv69ApGO6XQKrY5EDR4NL/XKQB?=
 =?us-ascii?Q?79CZe9x6f+p8pl4TlPnCWXnpAjufeiSArLRt8flh0Qy/o3fc9Q/pPJtkx3Rf?=
 =?us-ascii?Q?EsVS4tfw5LhFjJyo8Uzu0L3etxv2NIcaxmLGp26DtdUY1t4wro0pfoDvPPcz?=
 =?us-ascii?Q?Ozv6MfinAs4ISA/km1yUCrV5I+/NpUN4mJFuxkEtZEdDvsMgnij7ytSLLQu9?=
 =?us-ascii?Q?lo/vxQsB0PT2p5x8fjk63C3k37JSwhKZKep96/UUIKidU6L7UNP3DzE7KEXE?=
 =?us-ascii?Q?nwosmcetVrGWlMIqlLITceNSDbslg3fbc/Qfjmd6aFu+3BKO2ZD0DFMmVs/e?=
 =?us-ascii?Q?KAVe3BQPAVINgpX9896Ge4pkOQ+UvlgYVVeaqax080sdJirIaPqQ3LnlyE8y?=
 =?us-ascii?Q?ZgUGcjDfSh0GNq7zn0DrS8jt1TSlG5j8Dut9Dz7U9pJlGPDo/cYvkQv2zEkT?=
 =?us-ascii?Q?1bGV3R3FhCxwL8xQV/dn7z8DyrHyyGdHbPBOd7v6PGKH4+5GPkfPzQljRYlc?=
 =?us-ascii?Q?7lPjrUdf/F+LoTqiEkPS07NppfEFGgDL6wI+ZueIn/I9YOizx/s9zGYL/8FW?=
 =?us-ascii?Q?VfPvTgOuwwR4f0kSdu7uZKcnNmv6lwBZbpOjCV2Hr3q6OxX6rzLR7aeEIE+J?=
 =?us-ascii?Q?ocqggenbOVgVgNqcS5+Rka8h?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6133c6-ab6b-4122-ec4e-08d908923f7e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 09:04:07.4928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0ks5OWl4nlz99P05rJEUd0MsL61d/9Ll78PZAi5TB2rqtQcUnNcHKK92Xc1wPbS6bGoPfVyTthXTDb2Ge3mqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5307
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both get and set WoL will check device_can_wakeup(), if MAC supports PMT,
it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
stmmac: Support WOL with phy"), device wakeup capability will be overwrite
in stmmac_init_phy() according to phy's Wol feature. If phy doesn't support
WoL, then MAC will lose wakeup capability.

This patch combines WoL capabilities both MAC and PHY from
stmmac_get_wol(), and set wakeup capability in stmmac_set_wol() when
enable WoL.

Fixes: commit 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 38 ++++++++++---------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 +---
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index c5642985ef95..13430419ddfd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -629,36 +629,28 @@ static void stmmac_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 /* Currently only support WOL through Magic packet. */
 static void stmmac_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
+	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (!priv->plat->pmt)
-		return phylink_ethtool_get_wol(priv->phylink, wol);
-
 	mutex_lock(&priv->lock);
-	if (device_can_wakeup(priv->device)) {
+	if (priv->plat->pmt) {
 		wol->supported = WAKE_MAGIC | WAKE_UCAST;
 		if (priv->hw_cap_support && !priv->dma_cap.pmt_magic_frame)
 			wol->supported &= ~WAKE_MAGIC;
-		wol->wolopts = priv->wolopts;
 	}
+
+	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
+
+	wol->supported |= wol_phy.supported;
+	wol->wolopts = priv->wolopts;
+
 	mutex_unlock(&priv->lock);
 }
 
 static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	u32 support = WAKE_MAGIC | WAKE_UCAST;
-
-	if (!device_can_wakeup(priv->device))
-		return -EOPNOTSUPP;
-
-	if (!priv->plat->pmt) {
-		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
-
-		if (!ret)
-			device_set_wakeup_enable(priv->device, !!wol->wolopts);
-		return ret;
-	}
+	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_PHY;
 
 	/* By default almost all GMAC devices support the WoL via
 	 * magic frame but we can disable it if the HW capability
@@ -669,11 +661,23 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (wol->wolopts & ~support)
 		return -EINVAL;
 
+	if (wol->wolopts & WAKE_PHY) {
+		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
+
+		if (!ret) {
+			device_set_wakeup_capable(priv->device, 1);
+			device_set_wakeup_enable(priv->device, 1);
+		}
+		return ret;
+	}
+
 	if (wol->wolopts) {
 		pr_info("stmmac: wakeup enable\n");
+		device_set_wakeup_capable(priv->device, 1);
 		device_set_wakeup_enable(priv->device, 1);
 		enable_irq_wake(priv->wol_irq);
 	} else {
+		device_set_wakeup_capable(priv->device, 0);
 		device_set_wakeup_enable(priv->device, 0);
 		disable_irq_wake(priv->wol_irq);
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6f24abf6432..d62d8c28463d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1076,7 +1076,6 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct device_node *node;
 	int ret;
@@ -1102,9 +1101,6 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-	phylink_ethtool_get_wol(priv->phylink, &wol);
-	device_set_wakeup_capable(priv->device, !!wol.supported);
-
 	return ret;
 }
 
@@ -4787,10 +4783,8 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->plat->tx_coe)
 		dev_info(priv->device, "TX Checksum insertion supported\n");
 
-	if (priv->plat->pmt) {
+	if (priv->plat->pmt)
 		dev_info(priv->device, "Wake-Up On Lan supported\n");
-		device_set_wakeup_capable(priv->device, 1);
-	}
 
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
-- 
2.17.1

