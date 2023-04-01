Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129026D313A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjDAOHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 10:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDAOHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 10:07:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CABB45E;
        Sat,  1 Apr 2023 07:07:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkzCrEgO+hbA2ny2OBEbIAC9Gm5FwRxL6+uen1pc5Eoj+Ho9gOmQ1BbmgtvSjT5fitDu0Imwasibq851mOwtOM9VKJ8M3E+tbT5UfMpZ6XqUJG4m0SL3DisHHpIkAJTCzAkPG6B5jNpq0Gh5i+cJNwFVXVROrEXmCdmbj1m5rCx20v/LNW1ZzN1lgxH8RSx40xgLqz7sNSPP8OqOrQXGpuVpJaqZ+GFAlhV7No+6zF5BCAkbknwRvu1K/3rYtYhokn+TQqhX/C8hboKY6+B7eeuvSatlbP+fo5f1+PnMXdw025I84p2KlJTnDSJFz+ZBBTNMywdNJGmtK1bjSs4VEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6HSLH+qemdET5GE9MghUsEW51Y+mAvHps1v+/GlIV4=;
 b=QWcndvesbsYrLTeO+C4QQPkzcnC0XjV1ncwoeoR4UsCBEcpoAtRgeVFA27fuBsMQjNOUTFsnIou34M/BizgLptWew6wMQlOwzDekmd2WYAKMpfxzTwOPCn2vYNpbQ2GOT/uU4uiOxRKAPLib25ZrvBsFwYIuikC+nrx/sA57uMEN+SyWUWMzOvqGbws/9PkouK2pX5PNIZsGe9CKSaVg+/hA+hIgU5x5tSAqVjUMqXPUEWUr4h3fWK+GNhHoQgVpV34/FgQcR5BJByMejjlXJVOaNlfsBee1K50m1UQAMMZeEK2ORJQFqXM41ydmGpJbSq36M0ddPKFyXRxVsgqYtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6HSLH+qemdET5GE9MghUsEW51Y+mAvHps1v+/GlIV4=;
 b=GTAODcwDITRwOKxcEkLBL7XLuzFo+5VWw/xbMQS27J7CWugO9AmgRippGgOEZwTWhpQMCwAPBWEsSfrCgCII1RjUVpf/IlCK4RL6rGVwq0C1EMbU9DQkleOQvscGS0L2ogQRHjl+TvkMqDef4l04MFtp2QIje6zWqZyNWW3cbLI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5581.namprd13.prod.outlook.com (2603:10b6:303:195::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Sat, 1 Apr
 2023 14:07:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 14:07:28 +0000
Date:   Sat, 1 Apr 2023 16:07:19 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 3/4] soc: ti: pruss: Add pruss_cfg_read()/update(),
 pruss_cfg_get_gpmux()/set_gpmux() APIs
Message-ID: <ZCg6lzWMTuLa4gAC@corigine.com>
References: <20230331112941.823410-1-danishanwar@ti.com>
 <20230331112941.823410-4-danishanwar@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331112941.823410-4-danishanwar@ti.com>
X-ClientProxiedBy: AM0PR07CA0019.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5581:EE_
X-MS-Office365-Filtering-Correlation-Id: 90af6d0d-cfba-4dcc-3215-08db32ba6cdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3FFSobsitPqhzX2S3B0MyRYCiLSfD4HPhxb3T3vN7sKzCU9DVS8nTh+5SVF76wDicwt5Ii8bBWDjXhe4H6WWe5NgH44h4OISInoWF6rrnsElFdzDI8OdqyQH+AQL0FyrrkNtFsOn2IMdrP1/+8Gqn74TZg7qV3ZwDQEgaH33uMfy4VdGhO2mEmEVeaDy/a8ASn6vidg9Y+x1sXfltwQZ1DXthFUJQPs/+agA1rGgKJA2chRLtY0T4rwiDVy4o/NpjVbnvX1oxZaCO6mkibPB7utePLLSXfugX+5L+WJFItz2p1Who4IUQkXjaRk+qIkK02fHBWbChDJ0rKdX0Og8HyUf7EFLwM8HciUATpucKRdTtn8imkHDKY6eh/PZXZ+l9/aIn6Ylx5v4bOBm925mJtqy1jHJXtGAXfX7EpRS6LNcounwqApDrd2j0qJfn0mZJBl5V3NogFDw7gPgsRcnZKr+Vp7+1OZANsbHPn5f2kZVeTRFVvRCWC6yX/KuLW7o0LanMd+n5EYxR+2gXG93N2Tbuu2sYpWLN/AfOHHHuQqvlwLcB3tYjBV+rT3CbIJT1i5+uFqiDl1DidAaNucnQOCfGMwhtZ1YitCGVAw0x/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(346002)(376002)(136003)(451199021)(83380400001)(41300700001)(186003)(6666004)(6506007)(6512007)(44832011)(54906003)(478600001)(86362001)(66946007)(2906002)(4326008)(8676002)(966005)(316002)(6916009)(8936002)(66476007)(6486002)(66556008)(7416002)(5660300002)(2616005)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LVjeMEaQ91aISae1f1dY12k+hDzGjXC5T2l0NuIQuW0B1ql80YQNiX+2ZI5y?=
 =?us-ascii?Q?BW1/DEkgE/gn4qiT7hIs4LVfnfap37o2Kb8XmUjxPrnBZ4Ziu4zQYljHvuSU?=
 =?us-ascii?Q?5bejRyGkjMAN419In5KTTVBJSalbewjkz5bFPUpm5ebQVIeBpNCLNn+ZN+CT?=
 =?us-ascii?Q?hf60VuN2kDym+X4i98phvn2aYQMuJp00J4XNRvVK9obeNq68WJzpGSCgJnx9?=
 =?us-ascii?Q?zqgUuEtayDzHnDMzcsQn6YKfxwmojTTtTNe9NPIjkZpV/pEOXgowW6KJNi3Y?=
 =?us-ascii?Q?G5cDI0R5fGuOkj12mfq22nc60FmULlArPHF1ZUffMeYMJlg2jI92DAeqJfNX?=
 =?us-ascii?Q?5ILAUGNyNJzuc8MwkctYsehhv56VFhDuKoY0ftP+mRIbqC4LvXZlEOeK6JDD?=
 =?us-ascii?Q?xhUoXw8eRRn57z6OjBygiUd0Xfr7SDeS8lh4G9vLtPYDoID31JvQiRX5CHKb?=
 =?us-ascii?Q?/GWNs+6ysuy0ziVLJvdkkyOIIPux0Vhgsa/Y6xHapLv372Zx8/TWS1rzI3Qm?=
 =?us-ascii?Q?HV0FYp6woqM0ff7xr0n+mOFkH2cWQYXv3lUFeyzGClflUrsaDLj2u2adsnUA?=
 =?us-ascii?Q?2fWYVD8U05ZK18s60ZNYNFl1AXtC72PpGipGWCvfIMfDIGxhR71Y2kM0UlDc?=
 =?us-ascii?Q?7T7YrKjXiVG0eVWK7U6gvtxnkUomXGqbs4nNSAEzuAGh758n2FA7MHUiEiHR?=
 =?us-ascii?Q?YbSJQbQ2uZYKKOznil1KG2KrHzqZax8sjn2zNgBj1bFXgEF1YXnW/QbQsiuD?=
 =?us-ascii?Q?NbqE37BOuK7LJr5yiAL1ZhcTssL3KDyanYnEepaU16kUX7ySPAhV7Vp/FgQk?=
 =?us-ascii?Q?W82JFXP94kUm4zsTusaPM89Iodpj8kJgG4YKwsqPFFdb9Q9lS1Os1v7rqeYr?=
 =?us-ascii?Q?nwAQClxHl94FrlnPUKkkGINek0ERzJ/7nnGNSe8FvurkoKq+B3C9xsswCPDy?=
 =?us-ascii?Q?WW7xi1X8f09QWo8VHgr5gXxjsG8tdC7cY3K3oT7I4xMK8F1I4R8QtelVYl95?=
 =?us-ascii?Q?oVa9xxiWB907xz/+OT1+buoFzGLfwmIx7jPHbdKfv1Pu5tuGdmt9hYSBRpiR?=
 =?us-ascii?Q?V2/HDoF+PW31T7mVei8IaiaOVpr4fhER6WiXmeBA2KQykioA4zKn+wPOLHF5?=
 =?us-ascii?Q?7ai60eURBfexST+MkTcKVPiAFjVH47TxZcwAYXgp60ZVEFtzUxGiXLa0h5/4?=
 =?us-ascii?Q?TfLdBFFVsSdjYjw6DQwjoWLASsKyf6T9+5BdzGgt2j3M9K1iOkHaQvBu1dA/?=
 =?us-ascii?Q?ZryI+oUjLJSsWpx9t/BkH9vxaupF1VKan63p/luLYYR0pkiJ6kGxpSqsnr3u?=
 =?us-ascii?Q?TtcoCYuMG3LjhjyxrL15gMM4+YI3ihXvjjRgJ3RmYFwWIrftGsX+0FDJ955d?=
 =?us-ascii?Q?ohUA7LnFxhMnr3BmD9ul3oMUZPWFwRxtI/u0GvonZ8Q8Kh36T8rZhSDsco9+?=
 =?us-ascii?Q?XYgQ8OQpgfieKKzUQgVHQdZkxpCsbd8kZiQFOLHcXaeYLXkb3tOC/W5hvfgR?=
 =?us-ascii?Q?+ptcwZrm03UJF08D5A5dZb6h7orQTRmc0G8Yqx4LWQPQxS/oqhxjHyBhGSrr?=
 =?us-ascii?Q?vl75n7QlrOdvv/07ty8gK3Q+6mK01mRIIrzEZ6nqt7M4p7qd0p9QhuLPdD/5?=
 =?us-ascii?Q?j7EYMQZmH0GqC+2perGMWfra91VPzgbDCQrzUCc12ht5teJI+14zGZmLjH+s?=
 =?us-ascii?Q?Kbye5Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90af6d0d-cfba-4dcc-3215-08db32ba6cdd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 14:07:27.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KijjkyLB3U6R59MeAOrv5dLVttajV1FXjjQxdbT5G0q8mBqY3seEW7NFLREelhBthxw6a2KIN5khwwQpEnV1ccreRjGYuafoCYXghLb2/Gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5581
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:59:40PM +0530, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> the PRUSS platform driver to read and program respectively a register
> within the PRUSS CFG sub-module represented by a syscon driver. These
> APIs are internal to PRUSS driver.
> 
> Add two new helper functions pruss_cfg_get_gpmux() & pruss_cfg_set_gpmux()
> to get and set the GP MUX mode for programming the PRUSS internal wrapper
> mux functionality as needed by usecases.
> 
> Various useful registers and macros for certain register bit-fields and
> their values have also been added.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>

...

> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
> new file mode 100644
> index 000000000000..4626d5f6b874
> --- /dev/null
> +++ b/drivers/soc/ti/pruss.h
> @@ -0,0 +1,112 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * PRU-ICSS Subsystem user interfaces
> + *
> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://www.ti.com
> + *	MD Danish Anwar <danishanwar@ti.com>
> + */
> +
> +#ifndef _SOC_TI_PRUSS_H_
> +#define _SOC_TI_PRUSS_H_
> +
> +#include <linux/bits.h>
> +#include <linux/regmap.h>
> +
> +/*
> + * PRU_ICSS_CFG registers
> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices only
> + */
> +#define PRUSS_CFG_REVID         0x00
> +#define PRUSS_CFG_SYSCFG        0x04
> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
> +#define PRUSS_CFG_CGR           0x10
> +#define PRUSS_CFG_ISRP          0x14
> +#define PRUSS_CFG_ISP           0x18
> +#define PRUSS_CFG_IESP          0x1C
> +#define PRUSS_CFG_IECP          0x20
> +#define PRUSS_CFG_SCRP          0x24
> +#define PRUSS_CFG_PMAO          0x28
> +#define PRUSS_CFG_MII_RT        0x2C
> +#define PRUSS_CFG_IEPCLK        0x30
> +#define PRUSS_CFG_SPP           0x34
> +#define PRUSS_CFG_PIN_MX        0x40
> +
> +/* PRUSS_GPCFG register bits */
> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL              BIT(25)
> +
> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT              20
> +#define PRUSS_GPCFG_PRU_DIV1_MASK               GENMASK(24, 20)

There seems to be some redundancy in the encoding of '20' above.
I suspect this could be avoided by only defining ..._MASK
and using it with FIELD_SET() and FIELD_PREP().

> +
> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT              15
> +#define PRUSS_GPCFG_PRU_DIV0_MASK               GENMASK(15, 19)

Perhaps this should be GENMASK(19, 15) ?

> +
> +#define PRUSS_GPCFG_PRU_GPO_MODE                BIT(14)
> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT         0
> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL         BIT(14)

Likewise, I suspect the awkwardness of using 0 to mean not BIT 14
could be avoided through use of FIELD_SET() and FIELD_PREP().
But maybe it doesn't help.

> +
> +#define PRUSS_GPCFG_PRU_GPI_SB                  BIT(13)
> +
> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT          8
> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK           GENMASK(12, 8)
> +
> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT          3
> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK           GENMASK(7, 3)
> +
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE   0
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE   BIT(2)
> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE            BIT(2)
> +
> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
> +
> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
> +
> +/* PRUSS_MII_RT register bits */
> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
> +
> +/* PRUSS_SPP register bits */
> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)

...
