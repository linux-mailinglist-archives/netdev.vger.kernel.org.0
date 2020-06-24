Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A35206A8C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388637AbgFXD0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:26:52 -0400
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:16576
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387985AbgFXD0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 23:26:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbJUWY++zN5FPAvIkp79kwz3p72r/1YEWid+iim28VjuDD5A1DKYt86NKCRjsTsguevahTkJhWC4SfGDiVb+oF1tG31jJVcVd2B+SOun32XTaGaWUqvCJEZ6Z9NyPTelROjikJExexSNrHWSo5/y1N+TRlPSjYf4eUZ2FU5JJfFhLgJxi1HGIGOHigNMvV2PXnBpyIzQVdvNHb50ohkjkBH3GuTlRVHNcYR8Le/Ym9OnNSS1hg62B2iEQI5oiiIr4eKjC3deAcwE/tmbpsABPWvOPqHpzmwr83k2FdWEdLJeuWymqlzcVqmqvDtk2cA4vu88aCBlnOSmqOhvcdNrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jsUm8FmdOgJ5yqiPkE96nVksapvuMuO0NI/a0XLaKo=;
 b=MZjKoA9cK6vcLQ2aoy2sn9Pyg/Ubcw2/t18LqTaLbZZaU3k/c3d24FfCskAMXvrhOpplpvXrS3wSLAVOWUZOyUovtjAgbjvVlyEeAlvFbk2YqsvYdLviiBlW28/XkrYPTagLrm7U38bhpcx4RT7vBMrjGYVyibO/xJ7PL9JFRrrAuXXJfViOEPrsvWA24g4WbIW+5tUuPfv3tPXeGndHYEQfdw3VynMP5fPfPyxUq3fZgRVUkMQYr8/M/Udy9/hnMogebCy5G0At/qvuRbct6+Ifbx67iAtvTc2wI9TjWlUAs3d6Fig0B7oxg7nATpZGmIo5920ntN3k8d2rSk6AFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jsUm8FmdOgJ5yqiPkE96nVksapvuMuO0NI/a0XLaKo=;
 b=CtzMmOg6v2+HmbRGZUS+MsRIjTVVauBRppTnm1RNSDUQxZgF7yTvCZmCOxPXIHClk6E8vNItcvtvsbjbyBtGPV9CoEq4vBhBlsYmLylODsfR8LoetFvkdaCrv+v01spe4dwZEFIcnwyXmipLBgbG20rWigoF1m3aTKCMm/OI0Xo=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5143.namprd03.prod.outlook.com (2603:10b6:a03:1f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 03:26:47 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 03:26:47 +0000
Date:   Wed, 24 Jun 2020 11:26:24 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200624112624.200306ac@xhacker.debian>
In-Reply-To: <20200624112516.7fcd6677@xhacker.debian>
References: <20200624112516.7fcd6677@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0025.apcprd06.prod.outlook.com
 (2603:1096:404:2e::13) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR06CA0025.apcprd06.prod.outlook.com (2603:1096:404:2e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 03:26:45 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f575c748-3166-4f35-8a1e-08d817ee6d13
X-MS-TrafficTypeDiagnostic: BY5PR03MB5143:
X-Microsoft-Antispam-PRVS: <BY5PR03MB514360087C487A30F5DD33C5ED950@BY5PR03MB5143.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RR95okbT8SEAX/MbhOHZpShBoUMQDkxBxSQJoheFPQKitj5hJf6a9l8ho9iGLbjqCy24Zo2ClfHHSJUcovNczNnQrqQVVj2cvN9wnt/aRqoYQkeZ+39Xn24U5OJWXHpyPsJx6Y7Lkgzk4yfqjn5cyDWP4SxiDu1Q/DE6A7BPcakmvtmFbFGqRzraACkZWj6BJCFU5zYOR+wCIMn5hszDYC5tJIwclf5kCC8clLtzC5lW7f4YiFBzyhKlXYDNC+NejQRi5vmO6g11jVrjiz+OFIikYIrxk3LQ6iI00F0FbWndNALlBOceAd8Sux8JPRiT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(396003)(346002)(366004)(376002)(956004)(6506007)(6666004)(86362001)(186003)(1076003)(16526019)(5660300002)(26005)(66946007)(83380400001)(66476007)(66556008)(2906002)(110136005)(478600001)(4326008)(8676002)(9686003)(7696005)(55016002)(316002)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Rjdc9N1ka9mDT6XWjWREB2t6RP+Tq/CWwGsgHGncU7JWF5d3yZTZpCgfyTdfTYLvOPRor1eMcQ8eRBqRQsr1aXC5iiJ/XZIT1rVGiJQAwlcKfHZPP78En4OwRwgZhr1+qroGWpfhKQXKDccOdjXrEbMlCcJq/6JuHfkXZXxrWNe9vpX/v1B/lzmroaV2ZjvJNzhPw4TqQ+yl9mkPKstPPyKZ6/VrAcul4ahyu3/qbPaeVg6t8pYAaiK4PuFkV1fMLzXojsUfzS2OQCZKyE0CYTThH0xbJbfWaBSdVVxfsHBCQPmbFwZtRjFPMg0HqdSBdPvZuAAjYqvq5S8BQNqnE6nhh9s7GGxVqWKRYpUP+vNLH25WWaj/HRIhRROyEqVio2CAK9sML58F76Kwa7YPbydIaPEJ8G8S5dUORQ/2GpZz2Wa78bhj1PC8pE57GH/fOVm8eni8EqfRd2bXG0tL6LAF0UWGZwclIw+th6f1cTGKE6ZgQaCjUDhSMlxXdgzL
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f575c748-3166-4f35-8a1e-08d817ee6d13
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 03:26:47.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PwD0j6AGvOEl8dZPeVWgk+TlNZOFmfPhNY7uHhzZT8v7aJ2WmcSEaQjWyh6/9U0SSghGmSoyxYdix0CNDh4o5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call phy_disable_interrupts() in phy_init_hw() to "have a defined init
state as we don't know in which state the PHY is if the PHY driver is
loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
or boot loader could have changed this. Or in case of dual-boot
systems the other OS could leave the PHY in whatever state." as pointed
out by Heiner.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/phy_device.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..f17d397ba689 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1090,10 +1090,13 @@ int phy_init_hw(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->config_init)
+	if (phydev->drv->config_init) {
 		ret = phydev->drv->config_init(phydev);
+		if (ret < 0)
+			return ret;
+	}
 
-	return ret;
+	return phy_disable_interrupts(phydev);
 }
 EXPORT_SYMBOL(phy_init_hw);
 
-- 
2.27.0

