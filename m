Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420B8206E75
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390169AbgFXH7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:59:45 -0400
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:15424
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730725AbgFXH7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 03:59:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcXtviuu0p4kWagMUKQdbhNo57hzXAaP2Qu9FsFcZnbvH3EFYDFIlpIiNfromoKFb7R4w3VwxTpdJhhjR5o3IKuyBqqF/ZGBzoWDChnJVH4ozZkH+Fz0CGwDd28YFPXQHVRxxIfoB5+xJxZ806GnoIEgNiZqXoQozXTPbrLXzl7g86ft43tD6gNxRhhwnVs806S45YueCkBtHNP3xbSkdM1OtgDsoqdQ4o+QxT95Ph1ywUlVUYgkTdCVKX856inTcrGQef1PKzgMpWXkLw/6uM81oIt0KjTKmhfaeOSk6qWF5J8KS8jEUWduoj2DRjWW9bfqoMy16Sicm+CD3y4Nqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGlJtn7z7N+QqE6Jj/osPqWiDFjODbFTV7v4VUQsmBE=;
 b=Pno9nZctmc7MxMARSGin8eODdW07xUe4If4IwO2JUs7ADnKnkG3OaDyyJdIeCSka16Q1XrHr5X8mHBoLV/5H/z1EFCgiDuhPtttEXHgS+B0msawwi98pywfL4E0bCmUDvlce4VEQsXCq/K9ScP123HSKpI7GglppBxUzkWFuveWV7FTr9x5dDh/EhAnlzyM1diTKkS9o1jPJ/P1XyBtBqVwOoIIsOglq9FzfbFdII5G5LDk3ojWkYE/fd2PNfmY5cpXPACXPbfUJvEaqvdFFZhNjqfZ6ynr+n1PMsw18VVffSlLvUq6ZtsHLY2HmfWDdPDlevqk0Ocbt74Gih3Mf7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGlJtn7z7N+QqE6Jj/osPqWiDFjODbFTV7v4VUQsmBE=;
 b=NtYAzUCQb5o4hNepPUQyFl7YgPv4ICrL/5FDWHwjQLmzbiD3TmlGcNkFeiClwIHRvY29JeYiTyy8lvFYMf6ULnOKT/uViM0AI+Qdk5MBLc7sd6M4MWdDEYBRJ3a9PHMlsxRxbq0biFr7Z/VKKnk1CazaXmiE++HS0tGOn6O/q9g=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5361.namprd03.prod.outlook.com (2603:10b6:a03:21a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 24 Jun
 2020 07:59:42 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 07:59:42 +0000
Date:   Wed, 24 Jun 2020 15:57:57 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200624155757.6b2e82cb@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0190.jpnprd01.prod.outlook.com (2603:1096:403::20)
 To BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY1PR01CA0190.jpnprd01.prod.outlook.com (2603:1096:403::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Wed, 24 Jun 2020 07:59:39 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d37ca31b-3eba-49c4-c237-08d818148d2d
X-MS-TrafficTypeDiagnostic: BY5PR03MB5361:
X-Microsoft-Antispam-PRVS: <BY5PR03MB5361EBBEB730E06A116E35D8ED950@BY5PR03MB5361.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0Bozvb+YhH4dpuINDqv71m3EA+gbYQ+A7hP1CKLjOzS9hgfzUNwdeVTwL0oIqdo5ARN/iayG8Lmx4U3P5Z1N7CDh1545gb2wzXzsugxJXmwYkR4ccWrV2h9KnOdgOjhhWM7aSzX2a221+HP4jbxID95+QwrtktRCw2gdfXAsV5TCwEj/NVNmtBVxzYHHi+y6Kbl2qSFVkQ2zTzZby5cbX97k17Gr5hHgKFGeP6triGJvuG4MidJUbPeZ2PMZ1FES+BFsiVvewhWMez5izLQPFMejFudd7UGY8dV+oy/QUulhpdtAXgttTUsUHcXutnEaSwws44rEU1kVa8k976dXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(6506007)(52116002)(26005)(186003)(16526019)(7696005)(8676002)(66556008)(66476007)(110136005)(6666004)(8936002)(66946007)(9686003)(55016002)(1076003)(316002)(4326008)(478600001)(956004)(2906002)(83380400001)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U7DdQ1bornl+IjZ5Do+zaOKMpTeNwOZFNmPn/kHWQFMxUt+/+qKwZw2bC1Wsv8KzxQkoWnLnHabu5TO9QTlNS5sxbsExcMQC7jRJBUi6JPWvtQ3FSVZ9sUOU6P5sYy9r5+3zlgbWthS0WxZx/1xqxyCWB5Z9IgQvVE6hqP1mFA7hk/3Kmi5FtNtObshnsnb7sDEfpMYr+6GawISJ3dZJZXhTEGb4/WfO/jqfR0/FXVc3H2CiwO3mOuMxXOd3p+GW9gJS/px4thUSYUQwZiT5+Okh8atqHs9sfE4wgjlrqJqb3ZK2zX2Vo5bxQZFLEkQEoc+7dBurEVrGubE0UpJfbyB5SuQSEYQUuFwR0oLUIaTLHlaV8TDrXvbVh6zlmzKTRyDIrCaEV3u1T6YNRygVcBUqePn18X89Djkbyl3pcFyZN68wFjW/vwvkzQWycjZJNUbFUY5YyqIFBsyN3+peoj5ToJ7y6FRj4xEMZ9E+QxVp9A4oW8LlG52pZlMVXB2T
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d37ca31b-3eba-49c4-c237-08d818148d2d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 07:59:42.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VTkv4ZoGQ2Q0vdlf8cSMnZopyUgmlMS7H7byhTdmII21XzkviMpGqfMKM65iHkrMYxkYTgN3lovZiW+T/ipfsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5361
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We face an issue with rtl8211f, a pin is shared between INTB and PMEB,
and the PHY Register Accessible Interrupt is enabled by default, so
the INTB/PMEB pin is always active in polling mode case.

As Heiner pointed out "I was thinking about calling
phy_disable_interrupts() in phy_init_hw(), to have a defined init
state as we don't know in which state the PHY is if the PHY driver is
loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
or boot loader could have changed this. Or in case of dual-boot
systems the other OS could leave the PHY in whatever state."

patch1 makes phy_disable_interrupts() non-static so that it could be used
in phy_init_hw() to have a defined init state.

patch2 calls phy_disable_interrupts() in phy_init_hw() to have a
defined init state.

Since v3:
  - call phy_disable_interrupts() have interrupts disabled first then
    config_init, thank Florian

Since v2:
  - Don't export phy_disable_interrupts() but just make it non-static

Since v1:
  - EXPORT the correct symbol

Jisheng Zhang (2):
  net: phy: make phy_disable_interrupts() non-static
  net: phy: call phy_disable_interrupts() in phy_init_hw()

 drivers/net/phy/phy.c        | 2 +-
 drivers/net/phy/phy_device.c | 4 ++++
 include/linux/phy.h          | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.27.0

