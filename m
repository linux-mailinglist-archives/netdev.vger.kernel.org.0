Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E02204B70
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731585AbgFWHnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:43:01 -0400
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:61473
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731202AbgFWHnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:43:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niTRV8NdELmARNbfDdv/xdbSB0BIR/kZV+X+nIo+YWlq9MzuLfF7E0L1fRHrjNNUxrvq4T7zBTLwddtPeV0EEWqp2Z1alyAWnfm5seLuUu/Pt0str+eAWt0RcGU6aaMk+MuSTRTJGLi+eaZdLyWw5KEk4uB0wpsDa1tN4pZ6i+zeql/ffhntI0ElrDp9kAXgGn3hszA09L6l454FYnBojvg91u5JlyLfa6Kq7+pd/dmzuiMnfVgCfgmpZcAa8tWLiy00piaMcBfIlYum7OPEgEWGcabqYP2MK3M9TVNnsALargX0fR5cvl2iMUA8cJKxudrmgUIK3b4LmtjeBWmHNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+6Aut4x5USxjqZpIM1tSTqyH+zSJWndUMIYTKAYafM=;
 b=HuCfXNLEQipBDUGjKJPPh2mNraGIy0OO7O5D+OaqeHOvsiMxQQ0A7uhZUn3810GerD+3su9zfciG/HU/ACBJl1ScuCQguNoim5ne1xnLKKC7+u202W7a2NEUg9k5GKqQBCtr+j2hPYhb1tg6ky+g9xmbp9sNaSWApubzRrssC/Xf8bEILibwTrzKIgaHsAwP3R9k4glEuSyexR/eeqWVyJwrCEIaAFkkC4NBVfQ5jEelptESvUN3zBCLosu63pV6D/OXkImPbTlkadzEDAdmfzOQVFh5yzO5GG6NuM1KkzF+uUqk3jgRyCkS8tQYPFQQ4AspscAWz618PG6YRoWMJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+6Aut4x5USxjqZpIM1tSTqyH+zSJWndUMIYTKAYafM=;
 b=Yvdfst3Q0c78WY/5sXW84PCpFLXGYi9XTZMI+aausMiqArs3r6AXnStra9BO5Hunpm8O9AvE3HI8fgYhvtr4kOkvl1F5TyIydgSE+bySkip1tpaQRidsuLtX0zK+sfpI6iJ6IPc+D2idVGrUV6PqDmDrvcgFYPKC+YQjW3EEN5w=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5141.namprd03.prod.outlook.com (2603:10b6:a03:1e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 07:42:56 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:42:56 +0000
Date:   Tue, 23 Jun 2020 15:40:31 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200623154031.736123a6@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0205.jpnprd01.prod.outlook.com
 (2603:1096:404:29::25) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0205.jpnprd01.prod.outlook.com (2603:1096:404:29::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 07:42:53 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fc45758-a606-4078-1be8-08d817490b28
X-MS-TrafficTypeDiagnostic: BY5PR03MB5141:
X-Microsoft-Antispam-PRVS: <BY5PR03MB51414D8E4FC430A31C2D3677ED940@BY5PR03MB5141.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDxL2+NDkGAY9BzzpPqarjTGXjq0Mk8f6QDg+IyaWRUztSZsed8nIeIS80vjUujQyBwAErgkDlJcEI+fuKXzh6sixBOzn/HBPz72Ebdc9PzVis4y/PTFpxb4RJI12JTbGb75CNCA0sGfvkZavtSbzZ13ahjsnzqauv0Q1HyS86FcRlTpuShZADQNuR0aDFLFlK6pECB5WNxUaE9qeULfiaBoPBhmwI0UM5ZvDc2APlTstKva/MwR4iwM6hUOuIEQ31TaGpYP9SRTs3KiJFvuCZsBZtXMm7BdVyZwpjCUFDFB7EWsJ2owf3cuX7k+Ea5t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(83380400001)(66476007)(66556008)(5660300002)(8676002)(55016002)(86362001)(6506007)(66946007)(9686003)(7696005)(52116002)(8936002)(316002)(2906002)(110136005)(478600001)(26005)(1076003)(186003)(4326008)(6666004)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P1P1UHVcPp5dAV4FYAgppYKidSkUFERV3WauaU8eFVupEVKONQj2O85gTrFn71mG8tvx0dx3Zfa1YWRx7XIKRVLMQZZiauyAhzRuTphgzG9qRNlbPX9syk9EyBoWS5kPFPincP19QngcyzXUgkDL58XarMkknYRTdW9vrQAYaJbY8yzqqfHIlP3sMR0DURAvOnRJMck+NPMELtGEcWiKPjG+2oYuQo+4DWT8opIyi4H8FC077S5pwKTNancsm1+Gh/8v1WzEbK4OtCw0n3yxL6OMbLnFxfAGp/cp/CMCK0Ema/mET2WGbggrVdcYrm8/KjBJd6U3wSFgYNxFlzwu+78QemDwZKlTD27NNC3YroKUqy1Qd9YrNc+XQJakjvefStzb91eHkTaxAW/T3KfmPNwy6ufrNmW1DISU9FKzqYWoDMcfDsCtInR9Yz1uQo9fRQCTj4iLMn8AZxnkNmKnJwqnvKEoMGUpcPBk70LxVSo2sjTUUciiH25SgchBtZAi
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc45758-a606-4078-1be8-08d817490b28
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 07:42:56.2952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrJvVCzE0wUYUQvqWYRJwk8QR9XZHii832S+HHEyBEv0EaWfaiAngkGMIp4yWMEHtryulVarQC3o9rhQyXr0BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5141
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

Since v1:
  - EXPORT the correct symbol

Jisheng Zhang (2):
  net: phy: export phy_disable_interrupts()
  net: phy: call phy_disable_interrupts() in phy_init_hw()

 drivers/net/phy/phy.c        | 3 ++-
 drivers/net/phy/phy_device.c | 7 +++++--
 include/linux/phy.h          | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.27.0

