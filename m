Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3252718F6
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgIUBO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:14:56 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:23676
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgIUBO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 21:14:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gO1ohXaxMUhQx17sh5RqiHzGgxclNTct6jPWu+BR6Wp1HKdaknq+O1rJq12yOUOuWeullPwxMeoP9SdhVhvHMtrlshec5nBO80r9IaltQVvAVgedepc69rsNLiH8Q+vfT6Hlo2Kks2SEw5BqfIbCCNAtlG4G9PjERd73OtqYBU9UXELhXpM1JxhVNzo0DLK5vzkhNhs91QoyViMTEHVPEdKQcmlOrLVtDTRlEwlibMxBQqRrBuItoJ51Ykk0IlnJiMT2tO4qwdgtmjhrFaxEmzw94dHUWIG9ivlCFqWBZ/TrqsqKKFdICpGlpfEjYqzZDJClN1pvw00dr2zDpnEi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAKEvVNFerSkMGAQazu+pc9uib62Mx1apPzjuqDdTPg=;
 b=UMzKQ4TQe9eaGONkcxZRPGMNZhAhsjZm6gMmjqQeVJ4cKvhozwqu9WIvA2yoq30PjMQXbjvjhYaJ5HEbLNNehb5Va3TTUGWrVc+nIvWx9fc40yMCzOqqJufp3rNtxnHsLQURvptmo443G3HCggHb6PIE1AEDrDEBTQH8XxyeWh8gJMmCHO4ase/wPQlt6vG7X3CMVCkahQWwAb1BPmOEo+rV6vPDlhW+OB0CB33AA0sZtCiYsjFs7CmZeCUXx+6oNtYlt+TXrMEusAPY3BI7G3uzCP2eXYnDN14DOdd1a2O/iRlPm4ZxAWeYi+OcQpgAb7Oc/jQ/KwNgrXH1lTI6/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WAKEvVNFerSkMGAQazu+pc9uib62Mx1apPzjuqDdTPg=;
 b=L528jfM11MtUJ0lMVwSaY7/Yr7CTa7Ew+0AG0vn3IZ3O0WVg5wwyPpmN9o52U9g1dcG8LbHYMo+o0k4wE0OsfWhPz9WuoMUY0t2SHXk3t4Afvy60Se/F9q75lSG15ZZJX8+2oy98gnGMsdVZvwbxUZj2t/aQqs94i34hf/3Iu9Y=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from DM6PR03MB4555.namprd03.prod.outlook.com (2603:10b6:5:102::17)
 by DM6PR03MB3802.namprd03.prod.outlook.com (2603:10b6:5:50::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Mon, 21 Sep
 2020 01:14:53 +0000
Received: from DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38]) by DM6PR03MB4555.namprd03.prod.outlook.com
 ([fe80::e494:740f:155:4a38%7]) with mapi id 15.20.3391.019; Mon, 21 Sep 2020
 01:14:52 +0000
Date:   Mon, 21 Sep 2020 09:13:54 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: phy: realtek: enable ALDPS to save power
 for RTL8211F
Message-ID: <20200921091354.2bf0a039@xhacker.debian>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0155.jpnprd01.prod.outlook.com
 (2603:1096:402:1::31) To DM6PR03MB4555.namprd03.prod.outlook.com
 (2603:10b6:5:102::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY1PR01CA0155.jpnprd01.prod.outlook.com (2603:1096:402:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Mon, 21 Sep 2020 01:14:50 +0000
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98081720-114a-41d8-40a3-08d85dcbbe33
X-MS-TrafficTypeDiagnostic: DM6PR03MB3802:
X-Microsoft-Antispam-PRVS: <DM6PR03MB3802D63D97D951849E551EF8ED3A0@DM6PR03MB3802.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBn1YSW0+5I/bhceJXG6g3VokaY+lLRiyP/ZHDyb4tqZcjGfaBfNaMQ7GSX842kjXzlsPJZFEPKs6VzqtE5d5O+7BWgp1giI/vwrCvXKouNFB9Qy+Y3FqRWaqg7/yh7AorU8WzMd3rjWJXjdn2SNWwhRAy4ODz41th0eZeti/4DAL0dmfrD5bpvIndm7qEVmdd+tuKXs6qqUCutKtN8dd6cIhWt0y40Hpuca8RkyLm+TqtzYcTimgukHrACfBJbVeOeS0LsJPwr9Se9pHIFoZyYeq68YXSPG1Sa+JEkYzXs0xa84V1PI5wFS5iNz12UU51V4KtoljL4cXhW2cTfkTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB4555.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(39850400004)(366004)(26005)(8936002)(110136005)(4326008)(956004)(478600001)(8676002)(7696005)(186003)(16526019)(52116002)(9686003)(66556008)(86362001)(2906002)(55016002)(66946007)(1076003)(6506007)(66476007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wIZ9x8Eao3plOi2Moz4/Xj/XIM/qoS97GjMCy/8pnRE7eQKVhSuO0sdjR1iSE+vZHvKesG+rRlwyEl9jxeeC0s0P8gVlShfi1R9wrdoXnzYmE6Qy3VV1y5dQzvFTgnp/w0wp7+skxuvp5of8gH2D7zpJ7x6mpo8k0wnTVRqwY+5scMu9AvYnxNCzAMJbdloZnYLbIN0JtrdISKwpvxT/WUCAl2FTRWQ+JFTKh8MAwoS/KmVydg5E7lCtzR2rzM3fBNHB/QvU/tVlxz8cpmXdJ//ETBCxKlNRv56BcfCEtuXRCy/jwx26tkjDo9RnBZ+vf5dBOewB7Ui23Xbu9jwr++VzePVZlXwwQWaMc2qOtq8NfHrtiNQQgfaBX0stz+a/8GRctViuiCCDkl+JX6HOWsHZydqoXhlSg1sO62oE8eeo0T4QOeukpKZU+rGwTEGDylaUoVCWFKSLucP8uA1LraMa3yonmmQjPOLYY/REWSFGlWqbiuXCsEsDeFVu3xOf9G23GGUv8ONIcxDseKJHTXw6/vEFOvWxGCF0fMMR83AyliXEAjBq4iT+37w57djYbAEQ/8hOQjMrLfPKgDWMjB0o40VNuLwnW9yTtK8hBdNJm78UqC/8pz89PB3xsXV36wRs+7xMT26esLcBEGO1Tg==
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98081720-114a-41d8-40a3-08d85dcbbe33
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB4555.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 01:14:52.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kU+3HucTwjUq00iVWjm26lSz59foh4yg2fk01hQYxL/8E+SzBxNsfC2WgNNDyQMdlFomXbym0SeJUQ1Ius/hnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable ALDPS(Advanced Link Down Power Saving) to save power when
link down.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
Since v1:
 - add what does ALDPS mean.
 - replace magic number 0x18 with RTL8211F_PHYCR1 macro.

 drivers/net/phy/realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 95dbe5e8e1d8..4bf54cded48a 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -27,11 +27,16 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+#define RTL8211F_PHYCR1				0x18
 #define RTL8211F_INSR				0x1d
 
 #define RTL8211F_TX_DELAY			BIT(8)
 #define RTL8211F_RX_DELAY			BIT(3)
 
+#define RTL8211F_ALDPS_PLL_OFF			BIT(1)
+#define RTL8211F_ALDPS_ENABLE			BIT(2)
+#define RTL8211F_ALDPS_XTAL_OFF			BIT(12)
+
 #define RTL8211E_TX_DELAY			BIT(1)
 #define RTL8211E_RX_DELAY			BIT(2)
 #define RTL8211E_MODE_MII_GMII			BIT(3)
@@ -178,8 +183,12 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
+	u16 val;
 	int ret;
 
+	val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
+	phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
+
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		val_txdly = 0;
-- 
2.28.0

