Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB80B206E7C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390242AbgFXH7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:59:55 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:6071
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390208AbgFXH7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 03:59:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PatnyKNVYedSetr6S1w+DFSFh745SpK2l13K+xeOc7oGaWbyrYGKTEooTtAYGDnLVFNq8IqUmcGBcS/XnlaHN0v9z0HWCte4D9RY9s790FlPsnz2V+M34hyogfu0hvFAGMmG919jsfoSR5FQyUKvd0G33+JRNDB0U/9QGrQxaW+mjMh/cwLf3c3pojGTywnMVr3YtV8kOInq7cJhMQ/+eoKG+2uDpHbDs5NegUVczO+wZddR9WFxopawVMQOSkmhl8rq/Hm0gP5dQAmN6L51eJaNSlayXktypZtgv8UZsiFN7fme36NHdvld4jlqMhnozS/MW/0h42czvdNwDH2b0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKx4A6oFrzoLb4x3AKuCDtzleTWR5GqPb2xzVNxr2lU=;
 b=hSt94VaEqIRCTtMtECqSMFOtuBu3vDQt7HlAM6OyELDt+FcojKd8kSIaCR3218q5NjC4UBWwuyYHAsPettQywLJfE94CePgw/BESg7oIKGOO7n35es3LhSqg+pidwj3Iink6cYbGmVBZxoyeCMaPmyZmurnHm9FYcnQOGkycClrG4JE9B5DHwK/K4/xl8carxhLoAX8sRsG8+SOymn3VdWJpWuKJRd6D6k9/olNjtd1ByZZD88tZI8Lhh5IKid9xXAlQe2V600xAOBXM1hlv8Yb7xZS7sGhO0+y63bH9Rmxy6zOkTiK3sWiIoI3WWhx4VWGUG1bRcISU9FznKknyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKx4A6oFrzoLb4x3AKuCDtzleTWR5GqPb2xzVNxr2lU=;
 b=nDG8ybH5Vh1v5KaKzaE4lkEFWUgSG3nQHWoHpjjc1AwAg8yVVdUNPJYvygf5r8LYgfYOZcTbxGy6RPJgFFzCgZ8nCpfBuI9vQA2E3EZCjyxOK5bYzAQN7m/B1cg1V+3AGvC0tRenqzgtU9erc4tuGnarHL0E5DonM6EKGLyska0=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5361.namprd03.prod.outlook.com (2603:10b6:a03:21a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 24 Jun
 2020 07:59:52 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 07:59:52 +0000
Date:   Wed, 24 Jun 2020 15:59:23 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200624155923.39ff9af0@xhacker.debian>
In-Reply-To: <20200624155757.6b2e82cb@xhacker.debian>
References: <20200624155757.6b2e82cb@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0190.jpnprd01.prod.outlook.com (2603:1096:403::20)
 To BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY1PR01CA0190.jpnprd01.prod.outlook.com (2603:1096:403::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Wed, 24 Jun 2020 07:59:49 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45d4f92a-cad0-46ad-2215-08d818149301
X-MS-TrafficTypeDiagnostic: BY5PR03MB5361:
X-Microsoft-Antispam-PRVS: <BY5PR03MB53616EDD98757BE28DAE2230ED950@BY5PR03MB5361.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNDcMyN9I2bbbwGqb3uZ6RjXPNO1rze5XISHbZ0n2QJHUUuYDllWcp62+kZ338Ez5yu5xvOb8JqWW3MU6Vnw8s6mlqP6B4XarpTVagclc+AdBw3LFXEOjg80q3LYKuCaHqNvWzoblVVnk9Lz6pumCBsxGtN/z1RFDZtYzrD4KRZjMV3uas5fyxElgTwc9kf7UtzOb3bx2+qAQNWclC0ovK49wB17MWeG/1GvhO69T+Ec4jRCuJNvrxbRMR5XCNQav3t9eWEO+uXbQRrkqJLERzI3dnfw4xM8EjjO2P5eeRsCj+7DiMq7qvKqommcoIta
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(6506007)(52116002)(26005)(186003)(16526019)(7696005)(8676002)(4744005)(66556008)(66476007)(110136005)(6666004)(8936002)(66946007)(9686003)(55016002)(1076003)(316002)(4326008)(478600001)(956004)(2906002)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: afJueQUOrg1hEq2socYYgHLh1OqRuYGlEAYCMf9IVP+j5xYaqy+oGJxVIGKfQnH/Ldaon+vbQS1PODi1Yxtq1oU3uoBUNfQ6drvunNnEDVAi5fR+JIqpQZkO96XNNjodX2HizqgjtKJ7A/gquNL0el8waE5kBfJwR9rbLjNgcT+sJFrOdIzUksLLxSBXQwnrmUW9dHAXq6Xhyyf6kwhjKqVHtzLcFHnb8EOIDfmOw9qJEVqJ/MFMPmd/VL6eqwa/vkbQBrTVA7pegDPAB0rrKLn38aOkVivXjiq0ZBa4AYBLeX0PzMAm3xb4lJu8NGHM3OoF4BGE/ukWx2uJwyg1Z++IKfyzWppQfwiuo6pHoBNstsVbf5ZtoejWGpIPk0SbX6DvQQqL1NHi2lWhEZV+0giur3AJhgyMeriLU/ttmHJtvYdr2XM1wrmlMs22Cy9rJbas/yHaLap1DFlxAB1I8LcbUghqag/ZoGwh4oQ3d6sgQWQfIRo38yEFuoEdVbpg
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d4f92a-cad0-46ad-2215-08d818149301
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 07:59:52.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GoYle6WmTNr/mmOElQJj41chryJ7g4rQqAZ/kgys8n6ZGIEfWL824wYKxMyogAwShCUcdP/X5Ie+DD2G3BPk0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5361
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
 drivers/net/phy/phy_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 04946de74fa0..6a5886202619 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1090,6 +1090,10 @@ int phy_init_hw(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	ret = phy_disable_interrupts(phydev);
+	if (ret)
+		return ret;
+
 	if (phydev->drv->config_init)
 		ret = phydev->drv->config_init(phydev);
 
-- 
2.27.0

