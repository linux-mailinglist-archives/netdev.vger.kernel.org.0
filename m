Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D002034D5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgFVKax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:30:53 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:43947
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726905AbgFVKax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 06:30:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQVGVL51SZG1/YDQIi1GS85xb7xyOhc1ULuGR1NuuMzmudpwGQOuygQmfeHytqthNQKNe+a11cYY3Y/YKJUtp/nO1+rLNEtPG1rukHsJEPErOAQSr251gBuGz5T6c+nBt63SA3S1bZ4OY58XgWSgpch/hhmqrvLuhLu6HwonE0B9s1lDUcqS4cvbirRW9gXQfZ15mIK9MnhJM2vltKw/e53m6T4ePHU7iJzeq0pfIh4nudIiW5Io4yiLqMuN6HLUHjVSR2Xb4h0YY9uoZ/cqJvcQzrfP5FI656mcbu9gofQ0eY2vzuj91bHYiUnizIHzFyJcp7pBIOpvnyQJTOGSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAARXCDWVw/k6mgBlRNGXmLSZOUoss4oi3ce53G+E4w=;
 b=GTaKXKfOTQ7z8ojcLdGhVJ4IVeIGpsjXsLA442MzMF1uCPpBnOsNjZfNoabajlATWleynT3CGxRAyw2QzUsPwH9niuQ+iNNsaVdmJEGvc3gScSmvihnB8b30DI+pKsqIpJO3wk/lW6m8AzEJISwJaRV+nloK/DlR5snEcY/PfU4EbQNkI76mg5jnatYwJtoLEhq/QEUIMRWvwi0uq9XNALgBXMZs9hsrtNqaQ3D8mgVBDR6DsLroaJbnlR4uAky7+jR8ghYPZCxfu4TbfM+7C+j+lYVbDZ37X8UkJMwDNBXuePrU6Mbx7GgGN4raXCxsBoCB5JSTJq6PU8mhlZgLnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAARXCDWVw/k6mgBlRNGXmLSZOUoss4oi3ce53G+E4w=;
 b=ahWmozKKd0cnNaAmJWOB/3nRaNtuYTSiGCizEjNnSZrIWEpx21QPCfq1m/iHFJVFzkMpAqh6QXV1CTiGdLHwkQ4yxPmKz1fTTwIOmaSXFGk6gFp8Nbm2ciIhoa2f18Nh5eRVaEpU47EpU3k8PM82xy95dV568bMGuYbdiOHJWGA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4134.namprd03.prod.outlook.com (2603:10b6:a03:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Mon, 22 Jun
 2020 10:30:49 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 10:30:49 +0000
Date:   Mon, 22 Jun 2020 18:29:53 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200622182953.4d642e15@xhacker.debian>
In-Reply-To: <20200622182857.3130b555@xhacker.debian>
References: <20200622182857.3130b555@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYBP286CA0043.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::31) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYBP286CA0043.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:10a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 10:30:47 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a580005b-b185-4e41-5eb9-08d8169754a4
X-MS-TrafficTypeDiagnostic: BYAPR03MB4134:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4134472D792F711429561217ED970@BYAPR03MB4134.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ny7L9cxdlSvvPgRJrUU/51nN6JNeRlI9HPQwQnAxtLZJ8owffKiQzcUBbETMUjVjJ0cPWTqXjEgDvI+cd1Z7inuzDqn2nlCIPu1ePBUiUViQKDWfw88BeY1JEKumrbDnvOn7vWLNfR7UmCNIN9AJNGbXd4E12gBEQT9YMFp3ROWCkkxmCp+wNg9zdadCuOT6qKvKmTzXo6v6Mv0V807xsxhqSoNvbQZ/1mPioNK+/EIMA/YE17zGy3dHbP4eYSwFij/uELXe+QgFsACMvofK2lCldJRr75vRBAvGFFS4gvH2iuCGWx7Qsz0CWLtKwr69
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(83380400001)(7696005)(66946007)(16526019)(186003)(52116002)(26005)(8676002)(956004)(8936002)(6506007)(4326008)(6666004)(86362001)(9686003)(1076003)(5660300002)(55016002)(110136005)(66556008)(66476007)(478600001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Sp7I8JNIjMLAHsy0+7dQL5fg1B9yMeLOZ2O9UjcHSzrGNSujgMJcEM7mk/IQMi8aCqWuDxefp5lLdcrtDeY0LABrNWxDp9d8WbM1vxZy0QPfDeJXYQOc08c5EYOuPVzT5EPzS07bF+fS7YpLMuzzRfeB62e0Wrd54ugYW1KwnCq5gyd8XjJBgCWyuI7ZAfLmVmfRY7iWdM84lTdEblJ9QAbiYT+YSFHTKMd9Cs3DAgxYs4tVLZOUpoE+6B4ZbmCWfoRIZumtkcwdYMXA5A5OYSkkrzQdEWaPOoKkhT1VSUFvXj/OjJKjmfm0FIcCJbfe0lBqe+GNLcaTnqZB2xTOTFZvCFsjvHcKC4tWt4XmGXGNXrZf20nTXmZorQiR0OZEo+INSI8ZAXR6WmqO1umfXZchthTRbhYq9TOKamcxhVrxtNkXXdBHkv+3EqoYkhfmnX+cJIji8ZI+ZfjCjC2bqjI0sTzGhAiNuj8DccI7L2LvVYk/sqBwSnmglzj2hBup
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a580005b-b185-4e41-5eb9-08d8169754a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 10:30:49.1874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uu1+8LYMuYccyNlbxT6L/QU+HL9rZj+2WIXueLS2WcHHjhVIro8rScFBAj/KjSgSqvxMhqmUGmcTP/lk3prbIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call phy_disable_interrupts() in phy_init_hw() to "have a defined init
state as we don't know in which state the PHY is if the PHY driver is
loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
or boot loader could have changed this. Or in case of dual-boot
systems the other OS could leave the PHY in whatever state." as Pointed
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

