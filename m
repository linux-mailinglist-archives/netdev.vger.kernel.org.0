Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0796E6DC4D9
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDJJIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDJJIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:08:11 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0553ABD
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DP2tnUfMv8WJ9euYWXiLrxdJ7lDOfXjZ5wN3NcSuxhuPog8HaqywV3KNpeY26Wsqq7zWUcDzx+tPDLsTh40tzBIChQaK6n12yRiZ11LkHEkOZKJGg4cDq+1rHHhCcB5smaV+ftdUKoY6FPa+a3MJfib3kjgHMn0KFKQfiY5LUUVB0fL3r0k+FLFZxOsk8TpRQqNTWC2uh0OTkijF938GiNgbJQ1uVtGq/xoylZGfMqN9o7lgD0+0W89gG9724LShR+2wiIB+ggk8pXE8y06eIuGO6BeRWlNBddPo8b3oNmpu0AUKD3bLCQezUOhbN0G0Wtfrscn8ws5DwNRld9AZzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCxlvHQhu5ytInKEcMbVk2zcnyM1ohZ5ej6YZ0BYTYU=;
 b=UHK2KOFyArcSQVWr2j6OLD+1BdyT/vjpJauDkJ6k75Z+jRsvWnc8t0IsIFEUDSbqo9/B4wc2/2j1JkON2aDqGGDi9sniOxn7TUmDQzOjx3SbZobUKYA3hb73uuhV0mkkzOnyGKcBC0C3uuwTuCQ1gNdq6531dw5yu4YoafvIobZZzZUADzaxDDPl0ESy01SkXddvOttW4nYZIspFTx8/J2a0Po1sHOqnzgEsDQ0UmRILLacuEIfzur9ZWqr5/Hpjq9tOcKqTM1EUXyCIlpMOZRdkWxY5FSImXOovyWmh4eT2+27POCkb3zV5w6+5VxSaKSgdh6R7+zUfG1GKWaZCbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCxlvHQhu5ytInKEcMbVk2zcnyM1ohZ5ej6YZ0BYTYU=;
 b=lsdzcPulGCxNd2mjO+c068vQM6PsnUHtvd8FbDRkJI1OsxGLXUDFj1ibWjKcYWBW8KhrWN1N34bYLp3eDPeC8J8DhHJYiZ6ODuyp/ZpIAh9pKa6pcLKa1PYlyyGwdy0R7QMmi1sFQKCBtfCDuivQ0K/YFeLvsVj4Qt2cYIs6yaA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5761.namprd13.prod.outlook.com (2603:10b6:510:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 09:08:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 09:08:06 +0000
Date:   Mon, 10 Apr 2023 11:07:58 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH] net: ethernet: Add missing depends on MDIO_DEVRES
Message-ID: <ZDPR7sQj3Mpatici@corigine.com>
References: <20230409150204.2346231-1-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230409150204.2346231-1-andrew@lunn.ch>
X-ClientProxiedBy: AS4PR10CA0011.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 11899a64-9099-49a8-6901-08db39a318e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8aJhaDNrwzmy8/DPfWLRGyQkwn40VQ/0YaiXfmQvPWOtDob68GUrcTmoj5la6zUp9dijNI75gViEmuzA+73VFfJyJJ8Kifkq0zDV3TsNB9H+OjnLrO3+VIby4i8X+1IM+KTSsxnLPZl0Os3+di9cg/ZyOxKBgbA5x/Up00cJSONm2gegZFPEwlJLcNTQ20hDwzQFt5FemWOqFyS7VJBKzoPUt9Wk9Vl1Ta2rgReGVBFYEzncZvW28Z6hQXDnjOSJL1wJsshaRGt4xKnCziHJpWowFLPq67ZeXAwgWAfLVehZKZdGtWiANdlay41+viscC/UMWk4HgDNM9X1JCM/+CORCq0KIr1jmvTA25je0/khY6r8MEdbwg/sE2mvCVE69sBQ4/vMpXU95CkwAcRsAcs+Vx9Gk8iYNvgsqp4kvjF83wRI6fRwcEsdxB88UBaBjmGH6VLpHGG4scgIX1ShFjAo0oe5gXZG06S4mbe2iKudyHz3JAG8277SX4JRdlYduPbBCmT+VG+cDwAlwdq8ZkXvMzxhOvRpMzRuJC8r3Daz8/iAkctZhYcMAU8CDINVfAYx0pFH2yIgBJKf27iHJIe0PqI7khGM2oWondwCtsN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39830400003)(366004)(136003)(376002)(451199021)(478600001)(316002)(54906003)(6512007)(6506007)(186003)(6486002)(6666004)(2906002)(44832011)(66556008)(4326008)(66946007)(41300700001)(8936002)(6916009)(5660300002)(66476007)(8676002)(38100700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTuzWu2jTy0In65qNTJtmX/bFdW7vqA6BtyxMdbhpYizObLbHGWRGZZCZc4+?=
 =?us-ascii?Q?jtQGBYOSiUteJ6vkiY96JpWbKV3e62e2V+bwxASb1S+XV0kmLG+5/mPnQLiI?=
 =?us-ascii?Q?qP3dI/lakYAV+bDN2/qH9rqCSGEvE8k2RXtuMMyMqcuvWJ4FkP36uwpPtevr?=
 =?us-ascii?Q?SSXW7RK8fPy0rz9VOshScXjqc9YBhzN0YC6GsCpWK/rzm/22r2N7Z5ZjUlCa?=
 =?us-ascii?Q?GiNlpWpoyKa71BBABW4Rv+mblPbICbFl/EatEcCnir103t4wUlzoFtBO3eqM?=
 =?us-ascii?Q?B4hliYGs7BUG8kIOGluZNa8pkkYykqJu/9KaOvl9D3QxGS+KeMLyZSBoQyDn?=
 =?us-ascii?Q?io4h06LHNFvLiSxKEZWCT37jTcYJVOLypao2WPEPrPFx3icH7t1FspdTUExh?=
 =?us-ascii?Q?yw6eG7zT7bU7ZVKTcF5sRDdk3URcG9C2uD9doNAy7t7Q/P8zzwOyngNAZmA2?=
 =?us-ascii?Q?o2Hpw2aEKky0cTsQOQw3UMnLjpAHe4D7wV1Sre9RZmb1sDeIe8tr/lLleWvV?=
 =?us-ascii?Q?aP4VbhCiGB6OoU8u6pi8IZlIAZQWfMwWMYdEowKdQqYPbcHZ1X/PfqZLQ4J2?=
 =?us-ascii?Q?5WW41TDY8+jtUtSFF6pmKI40vh0NOgH/E9CJPjWnU4oY4goOiJ4pYf0pqPDg?=
 =?us-ascii?Q?epD2LNVnOLOAbpirsXFGyOP6yE9Qdhk1cn9CghklzYeoK3LXGW8qaCgjaqqk?=
 =?us-ascii?Q?fYolYvgquaowIuwpT5UD2wgLuNFCia9H2Oydx/dvOUleLUUR6fB6joYLlQZf?=
 =?us-ascii?Q?IZaT147K58f5aPvaSJrcC1IG2w6/qPAOp1oGABdXQrWji20ZBPPevSmzeJ1a?=
 =?us-ascii?Q?VxjcAml8BnMvv0w+mn6sebyNFZB26PQ9B7Oe+hbtbPD6P4IHKoFv8bPvMp49?=
 =?us-ascii?Q?79TqluPejgp+YObObawhQgYKc0E1MFOsLCX0T7i48M0rh4DMtHiX9SbMThTI?=
 =?us-ascii?Q?PCPWzfN/2WQC6ACNv+dpIFCAUUwoqa3gyWz7QQZo6oPwDpOR9lqzwZHPRGXG?=
 =?us-ascii?Q?Zox54cdSQZYgOa7Thrp4cN3qHpZ+OVG014UPXeCYkCgZdgvZp7PVFynz0o34?=
 =?us-ascii?Q?687IWZAvxvG1WOZMavgnUUTiLII/E/b589rrErFfxYxzF/v3MOc8mfO3GFkO?=
 =?us-ascii?Q?nM4uhCb+Nl2ecnbgtUwFQHQj7AzEmMLwsgGTLS24S1FO23Zi9Qcpea8TTwxj?=
 =?us-ascii?Q?HZ/NvsBtQnvdPmUwVO+1SNavMNzMF7YNHuWfJuwkyWHY4o21shyrnhhXNGZ2?=
 =?us-ascii?Q?gkHt5D54i6cyWeV3eNdD7a6ldo16e12fiA3Rs4PGI6LIlITlKgONUf9h4SUh?=
 =?us-ascii?Q?4XHPn9LSU+No558F0BmvdDcwaB/5cf5Z+hsPP1VZRoKaCwAGYP21mm+IuSD7?=
 =?us-ascii?Q?XZbPL4ffJQ1Hw+jbcG8DTY5mGW+6CX1ugkHM5R/ULf2bKjQ00i9ZvRNzWu5T?=
 =?us-ascii?Q?YWr8x7HrwE/To+TInY7l0L5QDGddlj8FzOFavaRgAqtK8OgtDKFnqgXQlPxx?=
 =?us-ascii?Q?UCRBNIkqLj9frdd0O1SFRK8Ovq1+uxEMyU9ogpxjfJ/UlL2MbQejGMdNKQ4n?=
 =?us-ascii?Q?E3Vdq0a91pBsUsyH5ViXfbiPWgpehk2ZhpLOWMH3Xbsu9PvVQsyUmrxjqKjq?=
 =?us-ascii?Q?YBCwN7CEP+qXaDYrymwlbpbFNxAa5U7P+sgVSehU6sgl0ZhnfMo2HGInAvxC?=
 =?us-ascii?Q?j/lukQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11899a64-9099-49a8-6901-08db39a318e0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 09:08:06.5254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmrV0IZDj/i7cuZgszVe1r2byulIwdyo5dWmOc0zjz06+L5ObLikk+yjZmMaeBIYinNQwDWa/QV3kH0jG8Uhd0Y5HIBITmV47xb7S870Bts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5761
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 05:02:04PM +0200, Andrew Lunn wrote:
> A number of MDIO drivers make use of devm_mdiobus_alloc_size(). This
> is only available when CONFIG_MDIO_DEVRES is enabled. Add missing
> depends or selects, depending on if there are circular dependencies or
> not. This avoids linker errors, especially for randconfig builds.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/ethernet/freescale/Kconfig       | 1 +
>  drivers/net/ethernet/freescale/enetc/Kconfig | 1 +
>  drivers/net/ethernet/marvell/Kconfig         | 1 +
>  drivers/net/ethernet/qualcomm/Kconfig        | 1 +
>  drivers/net/mdio/Kconfig                     | 3 +++
>  5 files changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> index f1e80d6996ef..1c78f66a89da 100644
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -71,6 +71,7 @@ config FSL_XGMAC_MDIO
>  	tristate "Freescale XGMAC MDIO"
>  	select PHYLIB
>  	depends on OF
> +	select MDIO_DEVRES
>  	select OF_MDIO
>  	help
>  	  This driver supports the MDIO bus on the Fman 10G Ethernet MACs, and

Perhaps this is a good idea, but I'd like to mention that I don't think
it is strictly necessary as:

1. FSL_XGMAC_MDIO selects PHYLIB.
2. And PHYLIB selects MDIO_DEVRES.

Likewise for FSL_ENETC, MV643XX_ETH, QCOM_EMAC.

Is there some combination of N/y/m that defeats my logic here?
I feel like I am missing something obvious.

> diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
> index 9bc099cf3cb1..4d75e6807e92 100644
> --- a/drivers/net/ethernet/freescale/enetc/Kconfig
> +++ b/drivers/net/ethernet/freescale/enetc/Kconfig
> @@ -10,6 +10,7 @@ config FSL_ENETC_CORE
>  config FSL_ENETC
>  	tristate "ENETC PF driver"
>  	depends on PCI_MSI
> +	select MDIO_DEVRES
>  	select FSL_ENETC_CORE
>  	select FSL_ENETC_IERB
>  	select FSL_ENETC_MDIO
> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index f58a1c0144ba..884d64114bff 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -34,6 +34,7 @@ config MV643XX_ETH
>  config MVMDIO
>  	tristate "Marvell MDIO interface support"
>  	depends on HAS_IOMEM
> +	select MDIO_DEVRES
>  	select PHYLIB
>  	help
>  	  This driver supports the MDIO interface found in the network
> diff --git a/drivers/net/ethernet/qualcomm/Kconfig b/drivers/net/ethernet/qualcomm/Kconfig
> index a4434eb38950..9210ff360fdc 100644
> --- a/drivers/net/ethernet/qualcomm/Kconfig
> +++ b/drivers/net/ethernet/qualcomm/Kconfig
> @@ -52,6 +52,7 @@ config QCOM_EMAC
>  	depends on HAS_DMA && HAS_IOMEM
>  	select CRC32
>  	select PHYLIB
> +	select MDIO_DEVRES
>  	help
>  	  This driver supports the Qualcomm Technologies, Inc. Gigabit
>  	  Ethernet Media Access Controller (EMAC). The controller
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 90309980686e..9ff2e6f22f3f 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -65,6 +65,7 @@ config MDIO_ASPEED
>  	tristate "ASPEED MDIO bus controller"
>  	depends on ARCH_ASPEED || COMPILE_TEST
>  	depends on OF_MDIO && HAS_IOMEM
> +	depends on MDIO_DEVRES
>  	help
>  	  This module provides a driver for the independent MDIO bus
>  	  controllers found in the ASPEED AST2600 SoC. This is a driver for the

Again, I'm not sure if this is necessary:

1. MDIO_ASPEED depends on OF_MDIO
2. OF_MDIO depends on PHYLIB
3. PHYLIB selects MDIO_DEVRES

Likewise for MDIO_IPQ4019 and MDIO_IPQ8064.

> @@ -170,6 +171,7 @@ config MDIO_IPQ4019
>  	tristate "Qualcomm IPQ4019 MDIO interface support"
>  	depends on HAS_IOMEM && OF_MDIO
>  	depends on COMMON_CLK
> +	depends on MDIO_DEVRES
>  	help
>  	  This driver supports the MDIO interface found in Qualcomm
>  	  IPQ40xx, IPQ60xx, IPQ807x and IPQ50xx series Soc-s.
> @@ -178,6 +180,7 @@ config MDIO_IPQ8064
>  	tristate "Qualcomm IPQ8064 MDIO interface support"
>  	depends on HAS_IOMEM && OF_MDIO
>  	depends on MFD_SYSCON
> +	depends on MDIO_DEVRES
>  	help
>  	  This driver supports the MDIO interface found in the network
>  	  interface units of the IPQ8064 SoC
> -- 
> 2.40.0
> 
