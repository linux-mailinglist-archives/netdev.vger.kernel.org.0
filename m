Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E09266BD86
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjAPMLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjAPMLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:11:13 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2104.outbound.protection.outlook.com [40.107.96.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3006914EA0;
        Mon, 16 Jan 2023 04:11:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwGCRPtLEo11GWvmvy3guAPoIRQSFmYVtlVWYJfeevk64mmDv5nevjZHfgaKF66OjiGynMjhzVc8dOTWn0fgkEfTWJuTvhV6ubSFduc6KYqPYav/nDBH8hlMpTnhvCgBAMPgbOtwqceQ7i3715e5ZMIHB2Mmx6pXUoFGUQT22b4rsphznDUjx2OoF1rwFeK7NQWprJ1igZKuTu0Ya5/F8/cafv5A4/kZ93HOi/X6/saZFr7WRauoExw8K/Qt33pq19FuR4RC1UyDJPdKADzy7e+UPdqoxLne+aVVWDQ9gvhGYKq5wnHe/BcpYwTppkcjAd2BaIaM2ETzsdi5I1L8dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbT3v03wVtxq5WyMY9pRfGgDNkulkQWqHmFn1Dyz0mI=;
 b=UxudDfUfIaJllvSsNs9GisnSNQND8Sd+yA8v7imTVvoHh0f0jI2yax1K1nP+CoIjnMi4IBtbBJdh61QspGxWh9LlvbIhZtPzYxFXP31wTS3OKf2oeyp+YlbM5NOGVx6ZdQsgImP/CgzBYaGvPoEfXbaZ36t3Ri020lYexzWT5ZE3ym15edxeobXHAgy2VCAYGf5QpGBLKBRxCZCSFN6nH1LedmXCsfpoEbr5IXVHLRGElP3Er87Nt6gHCobSYlHBgjtjJsXR7Yso+vpo5pU4ugTScIB7eCntV5XqNZC/iriovlDOv16j5U5oLUb2m042iZbAd1TkdJ8Rl0QQ0bC35A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbT3v03wVtxq5WyMY9pRfGgDNkulkQWqHmFn1Dyz0mI=;
 b=ngXEpyz2o4Ny1cf34HiDJKCyu5W9h0ERQJaTezLKt18537beDUzm2HGcSftk6bUbkJpF10SEx0uniY0XBDJ+56CrTK2pYSoA8usRQSXF/ZSPLeK4EMTBHbgQfwUwVeJDxyxmXh8moPK6jbikhTq1Ekc+mZajmIPpjk/dpbhB28Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BN0PR13MB5230.namprd13.prod.outlook.com (2603:10b6:408:159::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 12:11:09 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882%5]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 12:11:08 +0000
Date:   Mon, 16 Jan 2023 13:11:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8U+1ta6bmt86htm@corigine.com>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116091637.272923-3-jbrunet@baylibre.com>
X-ClientProxiedBy: AM0PR03CA0081.eurprd03.prod.outlook.com
 (2603:10a6:208:69::22) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BN0PR13MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ed052fd-3587-44bd-677b-08daf7babfc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RptjIrTqiNqxBd7CS8ZOaLer39/MxPABMYPEpYJN19gKF+M+qvTSpRfrThIKeKdzoJYk41F55Pp9mwpFaDtFLo7K7JEMYguP7axev63gvhn+YamNvDIG6mqREcKmF+cCKNDxe01GbBrWH6F3vz4TYZKA6lmYFktGY39qMOaV788zZI3WSkOQWSzUH9Zm+VYM8cfss5IINKk7SSGl/5tCHLSyk3MI8CKhUxmWw8yGBuRBpja37DsG3jT/lghBA2ZzJ1YoeZVak3vJptXzNoLTWuCRMIfFveBXbbTSEgz48PURhCQi+NxCEKwO4Mxihx2kh1m7wgvAgxpctqrY5eorNk3NxCrOBxnYztWAc0xgqPKQlk5rl7CGe1xBQjSExw4RM5qAZpVwGEhk7E5uq2zufzyqFejfOJw/fH/s7vzNMXPXGHmXt3Wu1FAGB6SMfgKvJ4jh/zPmOnladrncW+CB7PpsqGyeQ3BW41lBFOeI2+487BQq8MYgeSbgO5kPIWxud0LP9gcyqCnsBO8oNGNuznuiZrBG9qPnf3lrKXaHTceuz6WhbEQPxGUAUCidGnZMDZkG6YPjkwpN013VCPF8HUUoIiYHFTGBqFyUrmN85T6uFGUQ+hijwkpiRoi6ENQUq2YVQ+yCGt7ncWFAUKjixcJtIDVccp38jqUqL+DeVpj93/6jb9h3mdxP8ozgsECg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(366004)(376002)(39840400004)(451199015)(36756003)(2906002)(6506007)(6666004)(5660300002)(8676002)(44832011)(4326008)(8936002)(6916009)(38100700002)(6512007)(478600001)(41300700001)(6486002)(186003)(66476007)(66946007)(66556008)(2616005)(86362001)(54906003)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/7ukMpQa1kdgmXwOZzhilXFYbbn1D6B8qDYTX+Qhj68TcznBWvrtivCAOGIs?=
 =?us-ascii?Q?uPA+fT+xrXSg2vr3zMdzB4HYVG3FyysCgKj14YN9Cz4uTrkO97OJ5X+26M4v?=
 =?us-ascii?Q?2jKxrv1K3OH3oDuTCgm050xG0YeTEbWSWH8U7m9Kjk5g+1sQNeLhPMerF2lv?=
 =?us-ascii?Q?1ThxYx36Js72eeI4rzngkIfJRQ/hw+mpg7gkMtQjdiC9uByx8mJortXymalP?=
 =?us-ascii?Q?8vpobK9XIDk34ibAciC6LwvGbVKkyoHxUCc6VslAzBYKdEmhyRQSFjvI82s5?=
 =?us-ascii?Q?oyAxs7gw0r4oStuksn1GixvEyv6iPF2Zvi2VcBjVShUJ2t5bi/VIaNXYKIM1?=
 =?us-ascii?Q?IK3zRSeCEDumnuvTiBX3kh4LEHy0RF28DFVFH7MAIri5Z5PJ2AbfC2A4V7f4?=
 =?us-ascii?Q?Ig7F/Xa/7JgeLtmh4rJ5bXyA+fDsvrtlEfGX/90i0kHM69o27uONAuLPBk7L?=
 =?us-ascii?Q?kcuse7WyiuNAZKteDYASxUgoFD/x9cb3rHnExrwO8FWIH7VxZp39zWZw2q/0?=
 =?us-ascii?Q?3lsL9KVWyL1uKeOdyVqcYRppTAEkL+N+ZCUjkyvJdtoFiZHdsITW+Usg3Lo2?=
 =?us-ascii?Q?/YGwpK/qB/FDDzJxw7k1wGR75bQanhNjBi6/+8oxPZ/nEne/rBIiSOHdkYCY?=
 =?us-ascii?Q?DSbZkZt/W37lxCP8yfC2oeMQEo0y/yHWp8FC44BWyQABHvvNetFLcit/2ZHo?=
 =?us-ascii?Q?B/xgAJ6E6oDMrME+TKWFhBg9NEK6AxPeJgXTOv0bcNHzGQyr/d+6nw06KRfZ?=
 =?us-ascii?Q?AJY8y/vcFQssov6oxFp10OyjywGsSIkLCc6QNQbX5AcQyx1W94TWMZNmTMad?=
 =?us-ascii?Q?4C3giq/DyXRzw04LHHwHEKCMGcKtw+9AHZ4qSWWJyIXayuQYcFYCMU8/68qj?=
 =?us-ascii?Q?y6F7owKd358GsGbqb29Tc2mvjgcL1iVyqXUJ27b//MFilrcBXGOCcuTC9oHr?=
 =?us-ascii?Q?Yp7mRO3NWvTsdolJemLXp81n+++WRz1VDlWMDkkNe189hhYni1JrdsBOj2Kj?=
 =?us-ascii?Q?RdTDbz5yoWHG3Lmg0GeA0PkQMAREecyDSBe+LKdfVgJqDeHFNAF+9a8pogxZ?=
 =?us-ascii?Q?CFljJwExdJTkepnhaxYJtg0gVArtm9/69bIzobbHnhX8zZQVxQW2KFv6pvy3?=
 =?us-ascii?Q?/UDba8QADA5LDahSxP95p8wd99CLnbwJ+ihFokHFEJYvHvrAxLi5dTfmvjvS?=
 =?us-ascii?Q?X+BMmU6KSKwfieRKXtDLkh200DQclLMGuH6S9tNlS+bxH7qA6+CWDWUGYdhE?=
 =?us-ascii?Q?lw7Z/MkM2sPmHEV8NC8b0DKRMyzvSyjk8wT1puQbIws3gh3BfR7X/iBOPvpp?=
 =?us-ascii?Q?VjTYByg6+AZaYnzaJc5/GuiFXMK0XSb8QHlcb0rl+qIW8XOUMNH/3o7xR9O6?=
 =?us-ascii?Q?x+ZsOajyt7PeFNPwzbROmZdmepy1UtYWiTWZ7Du7WekXnsH4G8JMIMmPst2l?=
 =?us-ascii?Q?zJOl4V7Z43jKnA2ZPf6l3+xpGQ2SAjLZ3lNRrsvHYF3Qgo/OQNBXeyL2vjbY?=
 =?us-ascii?Q?8yZ3+JKZnixpZeVWxu0NMMLlclxUQ2hPvcU+QVwPbwgC5KLXIKztGNB5W2VD?=
 =?us-ascii?Q?XvsZhnaIQXDcJGDv2xQxLEaNAkgNeb9OnnmobnT+V/rt8yipHQIgXVRvVj+r?=
 =?us-ascii?Q?XjSfT7Ktc1Oqa/ozusll6IuUORGbEAiJXDN4psH06g24oNSQYTsk1NtV0dSc?=
 =?us-ascii?Q?jt6QhA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ed052fd-3587-44bd-677b-08daf7babfc5
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 12:11:08.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+20h9rANB9rvDQjw6apKfzudvxUX9stvYaFTSn6Y1b4vFoZSM5BBjg6qKJiaf2coOmYDZrl349BvJIqZpeUt6AKPn4BbsysDcb11A+XCPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 10:16:36AM +0100, Jerome Brunet wrote:
> Add support for the mdio mux and internal phy glue of the GXL SoC
> family
> 
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
>  drivers/net/mdio/Kconfig              |  11 ++
>  drivers/net/mdio/Makefile             |   1 +
>  drivers/net/mdio/mdio-mux-meson-gxl.c | 160 ++++++++++++++++++++++++++
>  3 files changed, 172 insertions(+)
>  create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c

Hi Jerome,

please run this patch through checkpatch.

...

> diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
> new file mode 100644
> index 000000000000..205095d845ea
> --- /dev/null
> +++ b/drivers/net/mdio/mdio-mux-meson-gxl.c

...

> +static int gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
> +{

nit: I think void would be a more appropriate return type for this
     function. Likewise gxl_enable_external_mdio()

...

> +static int gxl_mdio_mux_probe(struct platform_device *pdev){

nit: '{' should be at the beginning of a new line

> +	struct device *dev = &pdev->dev;
> +	struct clk *rclk;
> +	struct gxl_mdio_mux *priv;

nit: reverse xmas tree for local variable declarations.

> +	int ret;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;

nit: may be it is nicer to use dev_err_probe() here for consistency.

> +	platform_set_drvdata(pdev, priv);
> +
> +	priv->regs = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(priv->regs))
> +		return PTR_ERR(priv->regs);

And here.

...
