Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D89480F40
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhL2DXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:23:01 -0500
Received: from mail-bn8nam08on2138.outbound.protection.outlook.com ([40.107.100.138]:18785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238535AbhL2DWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:22:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oILe5HryjwqTxAZkMvzaNXxLh3bURsEwL+3mm7/VsxpgchJzv56IrZp8t0dV0q8psJZYuo10Png0H7pZqfdJEhb2XNpvF46w/AQFulSLKPPFjol5MMOXyvZ3FqRPfkudj1SGlzu9+v53EhmZPHdqvvV65ACy5xr7kDoaWX6hvFFuNLVNdV0gIhiTgrq2+OdTgFgoz0wnAfFNu2iKMGaUzDq43dBGBL/4ebK3iZzfeEjljE9GbUWmgrHD9ihuqBDSxm2S+hq6MVwhbHABYOtIN3c8w37mbDjavN0LB5NL41U0eP24GZeCIHdVxqXD1WcXsyKPuc8HWdEn//ACa4BvEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKYOy+jUiVJoV7CTmh++6Blxmov/ResMfYxBFE21h/0=;
 b=mt0yAAq/iBRYbVfx3l5jo5Dvs07Kkv/juG0VCkRkb8DU3E4+OyU34vbaZ1kHPJ/S9pd128mJV97DhJPwjYoTjlFNWtexthhjS8VI5VLRW+hqWnIMeKHGsZVtc5+NrONwbck1ZDQGOthcXbNO8Ylp5A2kjOsLbl/ldHCOskJ1XL0tiOSh/oGbO6rcZUmeZyph8rjcfqhq0ZeihFY68W7dZXoDl22RTSLJMmd0yMLnhLY7lL8jVl70PKzsjh26mXtaZpZjOKCkKTjjiNkwdjWDP1PoVaIKskFp2tX+XpncGHDprXGcqHWCYh1RYxpPkMsyXYgmIP/1bh2APHzKqcRZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKYOy+jUiVJoV7CTmh++6Blxmov/ResMfYxBFE21h/0=;
 b=FGkkkGb2sbyv+w9Be/6xqVG/LH5dwRfV3QuCHAUA+oRAHYXTH3vhmhpU5DYyPsYbzT+5Xhe2izLKRtJndC6ejpbf1jbxdOeYbqTSrd4wqSLmAvMI/DQ5EyZ719cfx2gQjtyiZpTMyj4CxUOUkfqRQM5UbGnjvKZ3ezb3IJinnBE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 29 Dec
 2021 03:22:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 03:22:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 4/5] net: ethernet: enetc: name change for clarity from pcs to mdio_device
Date:   Tue, 28 Dec 2021 19:22:36 -0800
Message-Id: <20211229032237.912649-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229032237.912649-1-colin.foster@in-advantage.com>
References: <20211229032237.912649-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 039bd8ad-1ee5-47de-50ba-08d9ca7a7e42
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB5521DE9BB4AAA053C1BC3FF3A4449@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9E4gyxBE3K3wrgRGZyMhd5KpszNypV9Ecuwoeh7vuiqF6DMLzp29b0WFLdwKkkQOW7Ymt04Iumkx/QsnmFHbdGipWrpOt00F5Ly4MtCqqKeEYDg9ZtHH2/uPrGxAXRG/rzPD9pIBkBMOJrrOTlr0E9AItHtev4rVLmoqUgobgweSW5rlFsUsdLr+9zQxQOFYobvEq0HhNEgELTeB6oRLsOJB+fVVoH4TRtkFSIAgMKZkA8AtIWt2sLcQh2JyJG+DxfiP5EePqzXoIO2HUS245H2/WX7u6+w4LFIH5Gc9pIKwbBbfADzGINfTWw53TInRx6Wk9TvnVXq5d5kq4T69+kbz8/MQ7IGXN2zllcbg7GAPU4X+q6us09GU1H6XRbb+yLXUUA0gZ2gZESucuhiV8DZ4k89mI/q6gzmLqerY2C/yacAA/OlClhYqio6fQepUinTJjHdb9/1BN5Vy8STZrocD4XxlxARxs5bXuHgj8NJGeEqZMBTQp2k87aa7vR68YMkB8ifW9UeAtATy837Ru97tHlKtgZF91lZXlj7sZSwVM/FoPgbEmdMKV5wJpnKMy3e35n+LlYcjqxdEBEWM/QzCy1mgtK0D6xoqAJn+KfnAbEn/tuHZdhEauOSyY9CXnsEBiD+LPF/YMhs8P0VPp9vNcHX7ykxehG99RwTnZR5lIBiLejkwkpxzTnKyCdrxgUHUEXu2M8MkgPgXWEsdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(42606007)(376002)(396003)(366004)(39830400003)(6666004)(316002)(66946007)(186003)(8676002)(4326008)(2616005)(2906002)(6512007)(44832011)(83380400001)(26005)(6506007)(508600001)(1076003)(86362001)(54906003)(5660300002)(8936002)(38100700002)(38350700002)(52116002)(66556008)(66476007)(6486002)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yx9XcMOH8rPRoxx0xfmI01CGewzBQxa3SBQ2hHZrLvPj2FJSYZw3VSZB6x0c?=
 =?us-ascii?Q?84S3msk7/ctLH9HfrUJOTpRBVNIUv/923F/Xi6jyTt5sHKSSWN/+e3Fzxv5x?=
 =?us-ascii?Q?lUwVxhqf+GuxZlvr7F0LdKa3UqU24+m1FuslZB8atCV5lcubz0G3x27Sb4DJ?=
 =?us-ascii?Q?Gw2jtzm+Ns5xmHqIGopmVTySwdYR+z7EX7MSueOphFTjbR5YIgg3gmX5zOX9?=
 =?us-ascii?Q?JsDFkT45ce/nMFQYZc/sVAx9cCj31hp2UcXzsLl5dsj3S7UI81ygrDuU6EZu?=
 =?us-ascii?Q?9cE3PhSUIBIP5E019p91mHuEr5Pnq7AD3sgeBBHTua8UDEnQUA/AC8/wry7W?=
 =?us-ascii?Q?/bNaPnh0y+saxH7+5rybeSMdpesOMnxQld6yA7xjr9w09TuSpcujBBvxO+7G?=
 =?us-ascii?Q?SIkN21gAyYCyn0hT1sWKpJtiDtQqQcxZiTlZeMu25A0g3ZYFODgsw9bwWncz?=
 =?us-ascii?Q?ZRPNFOx8S4Hxhc0DyNHwYBQcVt5eSjRGA3GXACrMQdU0Tw4Y53Zmvv6+A+DW?=
 =?us-ascii?Q?it9cQpWl2F8RQmdEgnu5Bn31fJzsu5NY+I1zIuCN3SwhwUlkZfRgoqMDeOIK?=
 =?us-ascii?Q?+IyC3ER4bGM97DhASEGQGKjcEONDWJ2g3h6iN87zt3K3t9S+WUmF3COiBLPK?=
 =?us-ascii?Q?fWQsdwQwjSF4lqeDb2dKb2jQZvzTxjy5kAvUfoMuVwInP9y9MiklX/iVqa5T?=
 =?us-ascii?Q?Xx1I9p/KbSl/JORSmMZCNSIuFXKSS8pkNCKfweenCrb3mdIt91k7wrFoCkU3?=
 =?us-ascii?Q?dFcXXvOGOS8Hj3P4Veggc0kt5jWv+0esQ5gtLmD4dnbtVnMw1mgc6YAwTzpe?=
 =?us-ascii?Q?De/Pf0/CsVauPaxpdRSEMw1cYao/swuA2+UaZB7037WDbVdDTDRYaYE8J8Hb?=
 =?us-ascii?Q?lPN3KpPnNKKyIIceqNlamgLUJNlO4pQCgHT20dbmJWLlgdLMnaIqA6gqfwU6?=
 =?us-ascii?Q?e1SIvJb3Yh7eDjXymOUfeVdc+UbqMS3K/W9v0IOtggTa+EFw/df+08WTFQWO?=
 =?us-ascii?Q?4ThRGB6qwl2Myb8kuuU2mzmm1/+WmvOIA0y834i3dKUv9mtlvVO2eBR0Yzrm?=
 =?us-ascii?Q?zBdGbBHYg18tzsKT49ewu97Bx/o67QLoydGecDtAiD6pxE3sbaA00YTEaZGs?=
 =?us-ascii?Q?f1hOnmOWi+64fQjF7ErzS0zYmAUO+bx+JUcyw3zaWpioOpdrBoVU7hMl2dwC?=
 =?us-ascii?Q?12H6DsRdoyl5vIkanxFegdPURwQ+S9JH6w/4lLr7Y8AkYfV7GQVCuX+8cgTH?=
 =?us-ascii?Q?TyGNASrSMtUt2Fl9gjKFEzEXWQuAFLW62Qxc+nWiaSCLHtpZyW0ru2LHdAo0?=
 =?us-ascii?Q?4nC7UD264RGmllmW5lzDIEo+HLWcROwg0tcNKHUfM9I347Yc2Hz4ZY2v0F/j?=
 =?us-ascii?Q?8/3G3QpRXWn53vzHHmW315H55089A3/3e8RFw65wMnv7QL0Es6fK+goAnviy?=
 =?us-ascii?Q?eivL3AEMP3mDOs3nfOxmC9jFzAhclkDgYZ+bmkHptw9luOlqm+FPY6NxPE8p?=
 =?us-ascii?Q?f54Slxg0vp8sIJwiZy/HVfkp/BMrv/0Zr5RgKzXVd6PIxghy2qrPkN9z+SoL?=
 =?us-ascii?Q?2ET+9vhfxk2AID5v0xRZUHz/jjnMWQNWnIhfnlC/aoaKIbRnoRS3iuJD4P4V?=
 =?us-ascii?Q?BjGDsrBCgSHEAp89ySuLzHTmrE/0L1lqWDnQsZqiw8zz1phcgO6Gujp3UvZE?=
 =?us-ascii?Q?ta5QHg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039bd8ad-1ee5-47de-50ba-08d9ca7a7e42
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:22:50.4138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XQuAGf29MgKOLVTouldiHZ4JVng2S8vGvoKwHvOU2YkLCViFqsxO/IudiFpJEKNmCdC/S5ycDZu7oU9iCWVHXmTbjnELpE/TEh3MRwZWZpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple variable update from "pcs" to "mdio_device" for the mdio device
will make things a little cleaner.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 38b285871249..0b6d366a04e7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -829,7 +829,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
 	struct phylink_pcs *phylink_pcs;
-	struct mdio_device *pcs;
+	struct mdio_device *mdio_device;
 	struct mii_bus *bus;
 	int err;
 
@@ -853,16 +853,16 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	pcs = mdio_device_create(bus, 0);
-	if (IS_ERR(pcs)) {
-		err = PTR_ERR(pcs);
-		dev_err(dev, "cannot create pcs (%d)\n", err);
+	mdio_device = mdio_device_create(bus, 0);
+	if (IS_ERR(mdio_device)) {
+		err = PTR_ERR(mdio_device);
+		dev_err(dev, "cannot create mdio device (%d)\n", err);
 		goto unregister_mdiobus;
 	}
 
-	phylink_pcs = lynx_pcs_create(pcs);
+	phylink_pcs = lynx_pcs_create(mdio_device);
 	if (!phylink_pcs) {
-		mdio_device_free(pcs);
+		mdio_device_free(mdio_device);
 		err = -ENOMEM;
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
-- 
2.25.1

