Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA9F633942
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiKVKBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiKVKBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:01:14 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2852B60B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:01:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO+hFXUvp45+FhQ0sTtzxI85cvGxt9r/ycdPts5zJOyWk3YQzxa8YgeNc/5jrLlmpVqv4/jG5ybw/HbUs34m+4y5d/vO5sF2v7NOAY6B0jiOlNFQjt+AyaSwxWmE994FR36XtHPc4unvlBZpEeMGrJuNr9PpDXQdneh3eTPh/Yus0AX+SkVw4iIXNyjc3hEOvIbwq+WHrwb8VkRAlI/hIACZDel1gn1cotXz9wV+pfx/qq96cH5iwu6rd5FwCNMEGVKXRcZsNs7NkJdeUwEoVW5vUMY/+RINoZHbtJIrGX0/aWLV34mYN8XtQHcOBABZbcZ2Or2mIxcgDpC/8XztAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IL5AuZPdFOUmm5lChj+qDSMO+ml+UOb1z8NjKpfOqA=;
 b=haTTtoq7kMSU5Y10wd6ex3qW5zaRzsii2HYclDb0WCTFIERQ9S8ExY9IQgBiEeFT2GMoVQ3GUrkyrsqz2tJYRDj4bB8PzYDKCX2LLEjUqazNkwY0y2zHPflhjUfkyz0vbO89ZrVux2jw3Z4U36KD06HJWLs1iQN5MrTlzTpE1sqTDFNJL7g74dlWTP6M+GFEp5Ni72co9v9Y1m0NPNvImnCE6jzOmR15LVM4JcRG3sbI4qWydIkkJMbOgwmFWSh4LV2z5yTUtAXuiI3WCWGwV07CfBnqJDxTMFrUxNbXX0o3PBQlw+KfoRdQAwFN6j/aqSyiHJ8IlpiU/8tBAtRdyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IL5AuZPdFOUmm5lChj+qDSMO+ml+UOb1z8NjKpfOqA=;
 b=EpqkdOSiVgKteLA14nj1nPzyLQ5VFjjtYjPVUcoYIrsbnET0jtRe1HcENdNEO253tCV6Y4mlrwjIDFitJQ3dVHUE84jYxVlHbDCZ86pkSiaLdm8M7ZqJ0wcnCOjYPHo12USFkh2PmF0kmHoeJZvaBKZCCuc+fny81GBLSTiIkLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8208.eurprd04.prod.outlook.com (2603:10a6:102:1c7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Tue, 22 Nov
 2022 10:01:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 10:01:09 +0000
Date:   Tue, 22 Nov 2022 12:01:06 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <20221122100106.likrl6rg3crydrh3@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
X-ClientProxiedBy: BE0P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: c67d2b3c-81fd-41c3-bb53-08dacc707ad7
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTRgTKU1YU87LBZ9SC4OaXsmAehyesO5b8NSORC+7Ahv+JHtpR26XGIoYjQZGwYqR/IkVwxBDxYwtvQU3MB/10nlTA42nfnNEKiO7HDLdmeayhOX8oVlPSVI53hozDLM1WAHVj0QJrz1W8DCtJKbSmFMMLT2wsdy0Ci6bwke2mwe4S3rdQK+csstbvDfrjxJIVOC9y56YFTnsD5pdKoZgw7cNzQ9jTn7im7fVKMncyjN20aOZiz7yFG6QNPpkmRVWiJns/fdr3rpsmEing9h2xgurdYtRHliUbr7rpvrUr0hDXc/H/bjli1zfrjQk0qbRlNs5xYKpCjVpqEnimCgs1ZRIFFsKxmwaG73+GANsSh7yEA4QO/cDdPhAVR1vokFY6z1IRO809UPK+HGaxL2OXK+ql0b7ohPrrdMquHYpy+MMPi/6drJZ79ZWNNBiSZYywXq9CP0fPMKvM6aEQHkJk3iD1UqyRn2P/A7oRAbqk0tHDLyqBLiMNfYveQwnbHAHcjSPzWbU4TUDegPQpWYOXUGirnwS9d+W7X4f7e9I0vARPLhbXPJawHsTXIK2QZJWXx/YJbsR1NCav6+KozdjbmbVtNaTR4/VNdL0p5pumevfF4I6zdmQsGKuVbSSkhCslOxsmJgR5BNgqO8OSw+jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(83380400001)(86362001)(41300700001)(38100700002)(44832011)(2906002)(66476007)(7416002)(33716001)(5660300002)(478600001)(8936002)(6916009)(1076003)(6666004)(6506007)(6512007)(4326008)(6486002)(9686003)(66946007)(66556008)(8676002)(316002)(54906003)(26005)(186003)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gGDQhfUI69OsolwkL8yRHB5F9UYnCsj6R+66q3Qk7G8dHyM3PpJyLS+p10iY?=
 =?us-ascii?Q?rvRADK4uhjKXqBvIahQSVESj+8/4ahfND4E1sbP6mvgt5aBVzVMauNDEXfWF?=
 =?us-ascii?Q?vzmWExjBTCFkU/bPUfzeVQRyae5sw+80h4VrXh+edsrpH7KFTnKpcSJVkI/4?=
 =?us-ascii?Q?Cyeqdw9rPzC8p3pAcuq5WZYdjwwAl/KIWORqINrmzy+E9QpRIdAp+roriM78?=
 =?us-ascii?Q?0zLQI8/hRu+NPjx6mal+ROF3FUdBTcPyjBUUxfZXeVa+opbgHucJFt0R8gVP?=
 =?us-ascii?Q?6r6yl+uh8y+j/s5f9YzIUxeT1pL8rD4IiwIVQmg4VFey7RZwz2p1DrqfZ4Lu?=
 =?us-ascii?Q?PY7RGfnjGXEbLo+MyZTls/Opra3+5+sZZP4tl5A5DiKV2ozOCJrDmVWXCSm0?=
 =?us-ascii?Q?8z4RzAK2Kg2y9Zn2nQSTd+hBWHbAqzXV04ZPvOp4RN5obimtl/ixOefF/sSQ?=
 =?us-ascii?Q?cQVTQqurIG0zlLtL4CAiG4ulIn439278HJe1lIXf5swtygFoQSh5gSlPCpCs?=
 =?us-ascii?Q?iDtTXpBOg0veu5ivCypAthcovQO/GM1WrOE35yxAMOw+adsZiSMI4fyJaG4j?=
 =?us-ascii?Q?1IrcEf19cHQ3+lJJ5D3KJugvGrx+Z8pkBrD1sV4aAwuyDahDOuVc3pa9p/UL?=
 =?us-ascii?Q?WZpzy5uB0QmU4N+jlKkkW4DKjA4HWw/cGpYCqHYozbcMs2HqeyqOIBgYNDFo?=
 =?us-ascii?Q?4PHKDIFnvDLR+HurUiH7UmukSNGoxC8VL8M2s05ksFHAlr1X613gcFqlV/H3?=
 =?us-ascii?Q?3/xYuRoAoBZYt+KxutwwxRGeq8VcwQcgR+R61dd1DR/urZUXjYGVT5GKyCfd?=
 =?us-ascii?Q?fJy1SXg8u6tPOrTznT7/AhmEO4//w+3a/Vj2C5L9uLPUnAwsDYFJrMP2o4p2?=
 =?us-ascii?Q?1XwPesfy/aPa6cFeQQ+SAofFhFbF0WA8vGI79nHpuonqHL4kFxEtx2nPAGd9?=
 =?us-ascii?Q?1mEGU3qu4QTYx2IuAGjvL4p7ndMsUVr2R2Of5bFt6oJLpxu9JkZYJ65Wx+Vs?=
 =?us-ascii?Q?RbLlTR4iXAsJelIeU1AeAftpO6Nl4Xnh3joGoyqXTDfMxsNSZa0I93yMFzqS?=
 =?us-ascii?Q?+4QEiDxhDdJAKXEjbGs2YIiaWmRvBvkm2AIcgTHOZKR6uor+y5kYTkt5mRe3?=
 =?us-ascii?Q?6/xIRqGX2N8NtIpJmcbcSq4/FMCADRRxMJXeq+4/Db8AulT9I2YT4MU2N8Zz?=
 =?us-ascii?Q?p96Pa0nkn1UveYwkPuyKni7IxOPooKxFpOjF28+SZ6FXM1FTdD1KEXNS45Uu?=
 =?us-ascii?Q?6n/4VDbgYb7KKwvff+cIBuwR15LfYuU/E4e5Je3qtZ1Pl1OHIgh6AQ/dHPqm?=
 =?us-ascii?Q?J/qUvZKQC2eHRFFGnGpx0wmDszs6CCc4PunSwq9CayL+htpYFuzPwlhQdZ0n?=
 =?us-ascii?Q?ZqEj5kGp8OZFLd8KktSbIDYjQnIdlMRSQbK+ElcwqVHtKSNG0xD65leh43o1?=
 =?us-ascii?Q?10klz1ioEh5HmDz8RmuN9yQAnbGLKIw5hy2roy3EFQ9jFKyUu5iDel0+GIlG?=
 =?us-ascii?Q?Q9MGxOYjiQPZ2D3+5f+z1tb1Lv7s8GStti+bwx3a7h3zyGJaGhMEBEmxwVf6?=
 =?us-ascii?Q?GP1pCmyzX013+Bm5ELBdo2T1B7EXXCIS+YT0AeSrwwtEYC0UMV3VrS5IPymt?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67d2b3c-81fd-41c3-bb53-08dacc707ad7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:01:09.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDMc0uuj9BwMe9b2zNBun3q9XsI/SSQpvEfSfb1W3e6FYfcQUIOpOM7AfBizYSKKRsjpCHUgolDtNr2OrGugBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8208
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:38:43AM +0000, Russell King (Oracle) wrote:
> Also, if we get the Marvell driver implementing validate_an_inband()
> then I believe we can get rid of other parts of this patch - 88E1111 is
> the commonly used accessible PHY on gigabit SFPs, as this PHY implements
> I2C access natively. As I mentioned, Marvell PHYs can be set to no
> inband, requiring inband, or inband with bypass mode enabled. So we
> need to decide how we deal with that - especially if we're going to be
> changing the mode from 1000base-X to SGMII (which we do on some SFP
> modules so they work at 10/100/1000.)

Not clear which parts of this patch we could ged rid of, if we
implemented in-band AN reporting/configuration for the 88E1111.
Based on your previous description, it sounds like it would be just more
functionality for software rather than less.

> In that regard, I'm not entirely convinced that validate_an_inband()
> covers the functionality we need - as reading the config register on
> Marvell hardware doesn't guarantee that we're reading the right mode -
> the PHY may be in 1000base-X, and we might change it to
> SGMII-with-bypass - I'd need to go through the PHY datasheets to check
> what we actually do.
> 
> Changing what the PHY driver does would be a recipe for regressions,
> especially for drivers that do not use phylink.

I believe that currently, the "interface" passed to phy_validate_an_inband()
and phy_config_an_inband() is always also the phydev->interface.
We could strive to keep that being the case, and put a phydev_warn() in
the Marvell PHY driver if we get a query for interface != phydev->interface,
and report PHY_AN_INBAND_UNKNOWN.

It's also one of the reasons why I didn't yet want to jump right into
figuring out what should be done with PHYs that change SERDES protocols,
and when exactly we query the in-band capability for the new one. Right
now, phylink will assume that the in-band capability reported for the
first SERDES protocol will continue to be the same for all subsequent
protocols. Obviously this might not be the case.
