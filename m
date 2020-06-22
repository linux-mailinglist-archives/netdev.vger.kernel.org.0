Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52ED2034D6
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgFVKbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:31:02 -0400
Received: from mail-bn8nam12on2087.outbound.protection.outlook.com ([40.107.237.87]:6152
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727850AbgFVKa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 06:30:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgBGuUEef2jMbvFv3cBBdCf1Vjj7jzPgcwePsxL3blKOX3eKsJuK1lBYbpWwTomQyKH+ai97jN7mWGAXlrlRsKVI44CuiHIKfpzLg3ROL3DMxyCNUijTeZfAGHtc/UrIPhzJ9iYSR9YcscRK980haAIbfWKmRDvJAwsOR9s5e1hvOVbrBFbi0yqsUHagwvCq2et3WkuTdcqH5lIUUK+pW1HHoeiQ26ZwhVuYUHvP+xI/0keEW71FQ1N+11crtmMhRq78Juo5xj0BOOh1+4nyqvJO1QNfdSqWb5g3XWP1ANBFDk5/Q/AADxeQ3aSHVgyr8xluHfzOAUw/DF8vSaU3eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/8tfpNLv3m68/u/Q+4i8gjAt/u4U3HQ0vpQQ/jeQdQ=;
 b=Vag28LbFse2n5XDd0Yr/DDj5zMs+w9JTYW+FZGJm/NiEnODED/WYNiOe4YTjufKVMkCBnzxhG6pV/VRSznU2+9m0RWuR/ls/fPEgMzdMbXCwRMUCP03LUQWQLccdYj2BneLpMFRgeVoj/ZC7BKQVntdIxFMyfL0G8bFoYevUd35nkpM+OhM+NeRqRC0x892flLN/P81lia9QgDn62OoMLbuhvVzDPa0x3UCnEzqnm+cxAudpDa+bP5bAhPSCnYknxfAqbfu7gFuLRbG2sKwzKHi9NmtWNK/dvJm6/Tx3uuNmPnvRuorwa6tmShGXksLxFyEqGQ4qUqOC7r3/gx1tdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/8tfpNLv3m68/u/Q+4i8gjAt/u4U3HQ0vpQQ/jeQdQ=;
 b=En3y4wY+uU0vU5PQ2OIEWBSVs3mn0iBBV1Tkrd8TdVe2tAYe1sQnlnqqpHRJsj6nwzgmOQtcgW9YyezhhDXZeowVbla7gYNH13eh01+XOCy2HCnd44aI0hfSeHTTMipJWyXhb83+i8WtMCZIrxvMta7vsBqA8NWq0F2NzUVwT44=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4134.namprd03.prod.outlook.com (2603:10b6:a03:18::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Mon, 22 Jun
 2020 10:30:57 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 10:30:57 +0000
Date:   Mon, 22 Jun 2020 18:28:57 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200622182857.3130b555@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYBP286CA0043.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::31) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYBP286CA0043.JPNP286.PROD.OUTLOOK.COM (2603:1096:404:10a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 10:30:55 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6f0670a-2ea8-4104-4e82-08d816975980
X-MS-TrafficTypeDiagnostic: BYAPR03MB4134:
X-Microsoft-Antispam-PRVS: <BYAPR03MB41341D91410E3016DAD750CFED970@BYAPR03MB4134.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPLveM4qG3EMbCScWApFoDLj95JCcES51ZbRHBUzEW9sP7kKj9N8UG2bo67910hrnFz5PHec171hpSXi19RXXqa0/oKIsC0ByWQQAXtXcserrX8bLZbPf0ufNLg8k0NvVMDZnJkPluyZnhETMWQBJvHm5NcP/V4lgggWKhP0QibZJ0XT/jk/lsoJYvdw5GW2WLfV0HT2rffjnmyjVA6DJdvSmH/7/UGW2pQ1n5K7OmZwr82AX8GPE0pnLngA+JTnPSQHdmAFxl/8lIcTTGXpDzuuWZKhYL7E+URHDURjmOfl3wlQ4cvcpwQbYwylg1vj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(83380400001)(7696005)(66946007)(16526019)(186003)(52116002)(26005)(8676002)(956004)(8936002)(6506007)(4326008)(86362001)(9686003)(1076003)(5660300002)(55016002)(110136005)(66556008)(66476007)(478600001)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Uu5zKLKpeRizxY5Myswr2XrQMTsAp6yU5W0M0S51UHd9v91w2KNAASeReZf+Yu9HfkP2DOmykgzzx1TNhzllnG0zSVKn3Qjyexle4XrW7lWQ+won4wfDJJnAwp6EQ9zt1xCCzi5HWb96KGxRTY/mlT48YJCiiZiPYsjmtHfiDfMFKKWIUULaRlmZS9JPV453SaG7kYQqDUbD1VIXzt5E1sLG0KqSFxXnkMoDTAqcHcEQoWe0b70HSDEGmWrW7ueG9dC8lHnMbDL3tPX8jKsRnaxZI5Iz3EGZaRvcdbauCogZ7codV7BRBEhT1yVEx8Jwsz2Y3lbuvXGQ9N6T1SM6Wb2h+zKBHXIbkKnG6Rl+4XZ4iWdiJ4BLLd6mY6zQyzBEWDlnlVfyzD4MRHygpzXTd5UJPFaIaes74Z70/90jV/BTb09sKcx1jXpI+W6LLBcg6YWQeR/hAXjqtgIG9qfxpiGPnSpIZAAUZ0IMWnmwT/wce0rAuDLVE/eOkIn490hQ
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f0670a-2ea8-4104-4e82-08d816975980
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 10:30:57.2637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAnOi8l7fTYWTGwDpOuyqnA/58fZ9puZBJrYWkPATRX8a2cM3VD8r4k7QsqKSMPpxxeUQ5htZQ/65u611eEKvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4134
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

patch1 exports phy_disable_interrupts() so that it could be used in
phy_init_hw() to have a defined init state.

patch2 calls phy_disable_interrupts() in phy_init_hw() to have a
defined init state.

Jisheng Zhang (2):
  net: phy: export phy_disable_interrupts()
  net: phy: call phy_disable_interrupts() in phy_init_hw()

 drivers/net/phy/phy.c        | 3 ++-
 drivers/net/phy/phy_device.c | 7 +++++--
 include/linux/phy.h          | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.27.0

