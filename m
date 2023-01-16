Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81366C059
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjAPNyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjAPNxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:53:31 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2139.outbound.protection.outlook.com [40.107.220.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498992367C;
        Mon, 16 Jan 2023 05:51:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLLWbf8sYJ7G45G3S4bTaSeqQnx30GtgTd/gNDNsjvEubmwCtTmfckyheD5z4LNRBGZ9kMLY9O6sZ14x9iusgXlD/bcUG0IZnZLOmzgLkmH8EekoVKwUT0eHBWzQw2dpvPQYdNmaiJE0BCnx8LRdTLERql/yZnuBQepoTdr1ZgoUj6vF7sMsYZsVj6/P5Ap4mUQXERXN/npq3kTOoY1YngxwbKoTxL6CODX2szzkQEpsmeoZJs6AixcKb8RuC8OaDJzHUwv63jsJtVcVOc/cSPoALkwqtmB7160cW8vvhiU/p+d4y0CT9fAowUojnkQg8qbetH8pXzJdV7oDCXrfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dd399+7Jevdfe4GmwFZOsb6kLJk1u2JylDxRrDuzK+Y=;
 b=WI2bbvQ1Jtrqxb0EjCXVl2U88kpOh9ycrCvH19TKUlDzHo13I4afkFeVTLOHhGt8ZvHcMApxVvm3vndFuCrEyBoQ2KdOjbywS+I8cltbWNSb2LEu3sFYDBL9eiPvo3QdSv4ePUYzUF3mWdMSmYOUgkbgiWRauzEX2CgsryWLLyTOrW5PuYAVvwz26xnqQNjMqwbIZOt0p6t72V/mcp10XfE+P23z8/OjLi+4noLwBqyH0esrNqfTiuzj4ZN5Ut/XInqe9Mgje10cdywxlsS/VUjvxgO4IcpV34wJ5ADY67pOXzjf+qfRFqkIp6TTHXOOP563kqZ/BkMocvtujgXmDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dd399+7Jevdfe4GmwFZOsb6kLJk1u2JylDxRrDuzK+Y=;
 b=X5jiGq9TnXsB+OespKKkuX4ZA4K78Y+rAnvwdexn8hhTIu1JMSNucLLGdqcJj+UvCBx/WLtMVjjvx100qFuWXr7Xwj9NTV87vK6gDH7q0pG7yw7Nu5KXI9Mnh0HhNy+ReGNmGJMojMikeMu1FESqGziz2jy7wenua3q/hi62vCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by MN2PR13MB3678.namprd13.prod.outlook.com (2603:10b6:208:1e2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 13:51:28 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882%5]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 13:51:28 +0000
Date:   Mon, 16 Jan 2023 14:51:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8VWWP53ZysENI7/@corigine.com>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
 <Y8U+1ta6bmt86htm@corigine.com>
 <1jk01mhaeg.fsf@starbuckisacylon.baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1jk01mhaeg.fsf@starbuckisacylon.baylibre.com>
X-ClientProxiedBy: AS4P195CA0017.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::8) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|MN2PR13MB3678:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f7c6429-9834-4bbf-5acc-08daf7c8c40a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EuFoUhMLNAhcJO1tYdGNFhmaLG2spK8smI4d9Cr839Vw+JbtJpjHn54TEw3cFc4P+YIS6NOOkhhOdbbQoNttvmuMt66tmg3jFnV58NPkBlgYLpJJiZcfPhZxsQ+937gpTXkE6ZwBgJLJZkjwdG0D6mhJgsc2hPgkoYCxvFPdnNNCdE1ZWLKNOftiLOCM1kxo/mKCG8BTAhPaiprDbuSwmvY3I4i5zqnsBL7P2HxjIdHh508zZ1hp/rgavqyTgUs5sDL4uWk2/c2gG7qTB0kGX7Fs2Q0tl5Ck4bOuTNMnzxZEyh2ordLdulACvNTS4yyHcgIxPT4fC3EwxpQTjO/HN6bodYADTDysDcKpuLYTzHfc46/f1w9UYWWcBMAeVRSv+sK4yBGMeERn6U7UAGeyeplcw2nH305JqbTfIDoz+RMNymKFQo5GMeJ/JT2VGNcyxRhGv3bC9PTl9lq8aIaVAXwF/C5dg0VQrsM3hh3aW8Kh4GXmY84vmk9/U9GbMlQYatZvZGPX7t/49qdF20RDXbrYn3m4HuepuCyzq9o/tYbZY0k2HX8l7CCFKPqgBO4vTf4KRqPPs9zcf/AXAyU7kyV8Pow1SJPR7jICnbotGoEOwLmJFaNfk3+dJ9jya/ha15zbkHNjX6YoABC/126SmdA2QLBu8MF3WtBEkLmDjUAmAk+BJyLgM+wFv1saHkcf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39840400004)(136003)(396003)(366004)(451199015)(66946007)(66556008)(41300700001)(2616005)(66476007)(186003)(6512007)(8676002)(4326008)(6916009)(86362001)(36756003)(5660300002)(8936002)(54906003)(6666004)(478600001)(6506007)(316002)(38100700002)(2906002)(6486002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3kvSIHVBKo+InUQ352tB26eTcnylKSm1xLRz3qLcVUDVxKi+Ke1etQwJlBEj?=
 =?us-ascii?Q?U+uR+CJVgS1+vDQjGNVahIUxa2VuTkhMSZQ67AdrIxHLYsOsitytZfoZMopx?=
 =?us-ascii?Q?D8IH3T2juWpHsbVIHaoBrDh1+Z/0TjiHkBwtw57Y92hxP0Unvbqy8PL50LDy?=
 =?us-ascii?Q?VPt4ugkKZ/mXNF+W4bt7LiZpkA+oAQ2Ybm36jC/O5C5yRNYFLtZjXn+7ciYP?=
 =?us-ascii?Q?5jM3GSNcuBDTYOERI+V1PE9R6R7ETdxIOzRCyZrqktFNgEw4m5nJOqb3YkGs?=
 =?us-ascii?Q?5Wuf7/S/Tk3ueSxyyIatcf1Pw5Kob486hXX/rS8PIIXQtTqyxgmeBZjCMVtH?=
 =?us-ascii?Q?2/F3jzMl9JgMFB3DWJ52GUcFk340u6vQriwRCLyM0ZFI7+G+Sq2ca76YLvyu?=
 =?us-ascii?Q?fGccy95KnE2UZtP1e+4HMJv5+JoPz6oT2HbVXDna52Lsg8h7GLTYVwFa2ext?=
 =?us-ascii?Q?FD7zw7TsGxbwE2EeUm3CvkaV2Dw62C0gvYFCt9wFVoB4VOP1fyKBT5XSvFLp?=
 =?us-ascii?Q?uqbdGAPL2oqA2hwG2pDO9LQv8w4J1C8vMObPMiLa+MPnSbrKxqp0/k6uoTxv?=
 =?us-ascii?Q?f/0L5ijOp7jabD8s+er0NwAjEGrYabbw8CoNxGE4JUY/ydJmkS+iEA1KnBLt?=
 =?us-ascii?Q?GtUk5dsSePaAmbzEyHoXnWsPd+26fHLteWQH/j9CCm/3+SwmEILFGcNMZby4?=
 =?us-ascii?Q?TdQSm1GEBCKCfR2O5XRvIJxyzU8J6HaRVk8wJzfPyJAWDYCZKJuC4dASd6ru?=
 =?us-ascii?Q?BpY8A3MWnlJOYNHQDFn3UzqmWAs2VyVzLzHrkmMFk2SDPSCEbsFOjjX/E83q?=
 =?us-ascii?Q?VgU9LWvqwRDW5HKkUfPH6H6cL2aagl1eIYRlTJoki6i4a0jRufWDLNF9t5eO?=
 =?us-ascii?Q?nArT7QMZ6sJxGfFkAXcvW9tM1LPQrWiZnb+q2SF7/rzXH9Ez7d52TUxKBnsF?=
 =?us-ascii?Q?LJ6hru5vEazGTmJ6zXLkutLiXEDcESquWvjKeAyuSQKANacGeNHUjKH8hWck?=
 =?us-ascii?Q?oDJdauqnlUGWIeMFZOjzUnCNrtcUe3FUjYbUIGk2AGEMIH0M1mrXYDbq+hMu?=
 =?us-ascii?Q?uE0xNMdpcY3Jl+x8FQlxzPcqEtLGRrPQKE/YXWuq5IIsXJ8eujOKZUwILC1d?=
 =?us-ascii?Q?gvs3WIAVfXVIt3QIEB1mYD+1GxltF818ztnHk0V0zhPusSLBXKHfcbmVQMcs?=
 =?us-ascii?Q?9f19BmmkeV7hLxDovDqUb0i4GrhB9e1oWPgq8hIcZWbwALtm0LwjheRzrMCM?=
 =?us-ascii?Q?h+DMj9UwpOSwCnAAQzXitWnTdyy71bbX8Zs7FBG8vWrDI4fGeLYDhZc/Noax?=
 =?us-ascii?Q?VKnFRyxta3sRAnieickFfo68z3clqalCv5osBUkmG5LWCjH4uJNYeY74aMSD?=
 =?us-ascii?Q?1QP05cdz/J+ZNKpizWb/WFEX4wm7QpzjvZYesvd3p/PVGZSDm6yVrGEcutsJ?=
 =?us-ascii?Q?Lbf+eDdgOdXY3LmLqCG38A9H4JM4eaZ/yTHh5NAeg6Nsvt8fjDAmyxB8k9e5?=
 =?us-ascii?Q?z+s3RSJ5pksblbk4dyiE8hfR6OsNEh8q8X9xRH0lzNYBca9SRywXqht3CMY6?=
 =?us-ascii?Q?W0beV5lcOQwRQp1NhDeJnrK/NVDDi1BtSfqQTrsuj2p6P39Ka8G15R8n1iEA?=
 =?us-ascii?Q?gu+gR4rjLpIjnCZ4F+7ZtLtd6SMhpA985pXQEq377tx09kyRTre+EFaWgyGb?=
 =?us-ascii?Q?b7VQEw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f7c6429-9834-4bbf-5acc-08daf7c8c40a
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 13:51:28.3066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cSiZ/yYrssCBYa14oq3ZIsmBq991BoGhsg6XlhI/45anRqJ0B6Gv0wxQfW+6wzTBkYQKQT57EhAVBydecMJMxFeiC4tlGsgGkc+w1LaxZI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3678
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 02:27:57PM +0100, Jerome Brunet wrote:
> 
> On Mon 16 Jan 2023 at 13:11, Simon Horman <simon.horman@corigine.com> wrote:
> 
> > On Mon, Jan 16, 2023 at 10:16:36AM +0100, Jerome Brunet wrote:
> >> Add support for the mdio mux and internal phy glue of the GXL SoC
> >> family
> >> 
> >> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> >> ---
> >>  drivers/net/mdio/Kconfig              |  11 ++
> >>  drivers/net/mdio/Makefile             |   1 +
> >>  drivers/net/mdio/mdio-mux-meson-gxl.c | 160 ++++++++++++++++++++++++++
> >>  3 files changed, 172 insertions(+)
> >>  create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c
> >
> > Hi Jerome,
> >
> > please run this patch through checkpatch.
> 
> Shame ... I really thought I did, but I forgot indeed.
> I am really sorry for this. I'll fix everything.

No problem, it happens.

> > ...
> >
> >> diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
> >> new file mode 100644
> >> index 000000000000..205095d845ea
> >> --- /dev/null
> >> +++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
> >
> > ...
> >
> >> +static int gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
> >> +{
> >
> > nit: I think void would be a more appropriate return type for this
> >      function. Likewise gxl_enable_external_mdio()
> >
> > ...
> >
> >> +static int gxl_mdio_mux_probe(struct platform_device *pdev){
> >
> > nit: '{' should be at the beginning of a new line
> >
> >> +	struct device *dev = &pdev->dev;
> >> +	struct clk *rclk;
> >> +	struct gxl_mdio_mux *priv;
> >
> > nit: reverse xmas tree for local variable declarations.
> >
> >> +	int ret;
> >> +
> >> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> >> +	if (!priv)
> >> +		return -ENOMEM;
> >
> > nit: may be it is nicer to use dev_err_probe() here for consistency.
> 
> That was on purpose. I only use the `dev_err_probe()` when the probe may
> defer, which I don't expect here.
> 
> I don't mind changing if you prefer it this way.

I have no strong opinion on this :)

> >> +	platform_set_drvdata(pdev, priv);
> >> +
> >> +	priv->regs = devm_platform_ioremap_resource(pdev, 0);
> >> +	if (IS_ERR(priv->regs))
> >> +		return PTR_ERR(priv->regs);
> >
> > And here.
> >
> > ...
> 
