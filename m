Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC00632B89
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiKURzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiKURzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:55:13 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2063.outbound.protection.outlook.com [40.107.104.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943FC57B76;
        Mon, 21 Nov 2022 09:55:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdLpccEmwWVvMunB0ctAP1oo0kqYoomcMkfmb6i9RzbkEVtxRBzGw7b1BYwNlv8dce5845xdmTXNrLqPM8CvXiYiziq0GkVFZn71mmKKBxPzGxY5QjY+ccfNibsqRfCghnuPZ2iIRtILIFSP7DTRLAVpv54Vu6tA0KSfArl/TkiySK4edZ6OcP+7RRuzaSWSTwqMV8nG1nIYkDEBj60on+EjzPCwKZUc8GJ0zu2KHvrqCA7nFYkWFOFgSm0SZZGi57FatfgFYZvwD5aLh/DpzWYbN0GpwlQbHIo0Efnl8lcuWM5jd8+2TFWvW4tevkl+/R6INj/hy4xvSyUQHz7Y3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJjdEzIVahEdMgKKiRDoMsgzn2/iSi9OImgjND9f8rI=;
 b=b4DJMH9htp1dA8DV5Hqq0kBwWBDI8WCyvNFLuwyg8kC/r74n0AwbLI5rwpkN1QNvD/4sLnR4aL6z8fNLgxKl952L0GGvKPfkx2rHe9kvpFz3fC6oyFe15uUoysS1c06XrD1e9kGe8vByq2+VOVFfigg7DqUwI9AQY0xyknenvOtiq7hbxczhuRA4VbfIsGZ3HrqoX6KXVudpDwaE1tVjrieEgrrSyEst+LT7OyNmydC4ETWIR0IG6SbeezTu5oQmhNVyLTTn2feJxrSO554236UOyCMd0UC2V5e+vIY4sraU7RajpjwwKwujKDKAAZ3lfx3/b8WR4/f8oqaICNTazw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJjdEzIVahEdMgKKiRDoMsgzn2/iSi9OImgjND9f8rI=;
 b=nvnVOPp6mn0edIr4pHSHDwHZfzf6uG4NB8lUDjhGfP4e9uk7A+BNSThxWjUQlMpWC8QSCoJPTKSS6W+pqz1aOv60mLRy9yq6Ybv7V6wn5ECIeR11R2SqT+02sXy3BKir/z94Ey6Iftg3kcJQydLpdCZyG90A6YIWPMZzcUE0HmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7557.eurprd04.prod.outlook.com (2603:10a6:20b:294::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 17:55:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 17:55:08 +0000
Date:   Mon, 21 Nov 2022 19:55:04 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Message-ID: <20221121175504.qwuoyditr4xl6oew@skbuf>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-15-alobakin@pm.me>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119225650.1044591-15-alobakin@pm.me>
X-ClientProxiedBy: AM3PR05CA0110.eurprd05.prod.outlook.com
 (2603:10a6:207:2::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e1a49a4-40dc-4f2f-1938-08dacbe98721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ENW8uaWBN3aAQ6x0KwenIElSHtSHT/mYXoLtTe6A6aI4BodLHtVl9LGszurxPsaKEjVxYUh3kRJ9uqqvoErepElkzP2QH/IV3pX7UGQxA/AfwYzLowfpOvGjKU/wWOEgxGPpDhEgvNhZl0432GAiomUUElf/QxcHBU2GfMQjLzYBFdSVsNH8CS5yDZB33JN93ndUE+2Zi57NNQbsMCwYhtWXnPxBV1OpObyZgVrl8EM+hECfd3mZ87UkZh9sIdPYccvW3JrAtvidrlw/CKEjjdWkiMxBaLIIX08bVANMcpf3Gs/9z7OghWkYUebUZFwgn4C/GLwwXkg8lUqnAjZaLRMa60XKhiNJPK7OxjzP0RwIijdgC/4/XlDgrMEqKAYX5nqWyR45e2GGqs5DeYkfu9XNR9ekXnvbxycEaSZHrwBhFaoH4sqVjr1bhKqjXlE9sU90Pz+j+1MLoUn89LS4ow6MVcxP7LYRwDzPOyjMoObYBRhsw50WxwNUmVpGezPMngVPEf5vKgmi3mZmy9FpNf0c1sf39Zv4EAe0us01/QKEr/2qxybV48TfoIwC/JFF4I3c3QN2d8a1PZGLyipFpPN3KcuBbUPpK3/ZsVYpmrWWxk/nh7bje5Q/hp0bA9k4oulTOjFS8h29Vtwt2lfeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199015)(86362001)(66946007)(41300700001)(316002)(66556008)(66476007)(4326008)(8676002)(33716001)(38100700002)(83380400001)(6486002)(54906003)(478600001)(110136005)(44832011)(5660300002)(2906002)(8936002)(1076003)(186003)(7416002)(6512007)(9686003)(26005)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C0VTShUA7eqMKN6ZcE7/yCRTJrPn9O70G4+5eKGG60teNQH1Z7hBTn397NrM?=
 =?us-ascii?Q?e2HiHbNb0OkB0QS9KOHrZcBMk0c7UlAztzOwQKFu/vcUQ8Sn/By6uYm21IYS?=
 =?us-ascii?Q?W/HJwLxzo2bq2gWfFe18+ISRXHgR8gorwSC3nT1TafovohhcnO6WbOsCdFgR?=
 =?us-ascii?Q?L15Q6zgfaDXVw8sPvB+GOw9KxFyxRuylr4hBGu3HVLE4NPNCxcs0JiVio7We?=
 =?us-ascii?Q?BsbLLTQhhHS6ivYIlf6S/tYb6Fi0J+5cswxV0WlazG+L5TnBm84R8XPHnYSr?=
 =?us-ascii?Q?cWCQB80SBvj2bwsZqsQIY1lF0pQoqPGatSLRLFvIcW3TMf8lsOEYAHP3/D5O?=
 =?us-ascii?Q?hFitLbK+UyS1NwgCfTBZrW8pGFAf/wT7VuX5hYHvKjmlEdK6MVc+92s7Wq5l?=
 =?us-ascii?Q?C0+/snRjbavAVdiWddjE8I+1G9pe9j0vTvk9L3eaU4y9DmKy9duWJhqaoFwc?=
 =?us-ascii?Q?p3S62VslI07xGFb3riORZWk5iSO9oiTRwMe+TLDQDwOugy58FkwFoLzPWPjV?=
 =?us-ascii?Q?A42CsxKzAWZbDVHVdlZVT56TuZobFgApym2ENENk8WVXYMeHoVWUQFDZoB5k?=
 =?us-ascii?Q?WBK/f2PowUjYBJHwG/bl4SCXkqZNne5lqfo/JLhmZAFH9Pk280YLKlhUTrxh?=
 =?us-ascii?Q?TPY8vRprAcWakVAjqtnjpCV+7foto3yMy33lwcol5tN3CzcrEUchl8VeYEIX?=
 =?us-ascii?Q?on1IFTk7KaTTJLp8SjhntH3egZv5dhiZBD5v1TH6KzCBeH7IpdJDZW4AoiH9?=
 =?us-ascii?Q?1fbeVFdc4gSksh5333JgVdZxMbyUG1cylKUlUHbkxAl0AjRxFAjxHbQis8JM?=
 =?us-ascii?Q?PGR2N5XSksbVUijpIXR1X3RqYamYhnZXOW1//+MaJ4elS7C1H4QFZfqgXaOR?=
 =?us-ascii?Q?5ZsfdjkkHhsadgOiAZEQn7BfbO8oAzLNpSwVCG8HuRIZGrVnS6BapyXWFxDm?=
 =?us-ascii?Q?QA1cUNp2/6VUuJiy0oO2s6WYp+XIl4W/V80oeiU5upfxigiGXg/xESIV3X6B?=
 =?us-ascii?Q?sxX6sVjx0Ce6Sk7AxiFM9PjCyEXLjxMdDKcDPb2YrHUHW5kKryyDf777AZnO?=
 =?us-ascii?Q?oi6aprlvOMNJALOKSjBfrHF63Pm9TXwSxNRYSn79XVwYvDK5aFjmcRFBamEg?=
 =?us-ascii?Q?tBa3AB7PMuDXntkbSRRrmfUDetPBNNfdOiYrqUlzLLKuXXoYJxK7m/7vWxmX?=
 =?us-ascii?Q?0UFh1NM+cqJ21JiAPna0qAujHooKyExW5xklYIZsOPkpXejhG6O6ZhR+JyQV?=
 =?us-ascii?Q?dPcrctZyBGRiytpA3RFE3RPmfMp0npkzmwsK63J3G2EQFXNvAzU1jX3w6qgT?=
 =?us-ascii?Q?/SPY7NhkUPZ3VTC2W8Bto5ya+TcWFc8Ivkr7ibUWj6xHxn3CDpkasj6nILpb?=
 =?us-ascii?Q?alVxWAQ9Ud2OfvZUpEorVWbywHjB2h+ipGnxBUzYxMtdLVAgRPkbs4f5mh3y?=
 =?us-ascii?Q?NE7BvYue+k83/xvnoc6rv7Pi9BUaY6Imr8UWf2lJGDQ2qDPM4T/sE+R9ocRw?=
 =?us-ascii?Q?zZQwPZYJurbQx50+40kXcaaSHyv4I2FL0DeHV7G/DOXsVxYRwPxnZDRyBuHk?=
 =?us-ascii?Q?DfqCUi4rY1XS7MEbQAyffOqpEJtBfAHIhbvVuIvH5cQAFcKs9JbMXxWkUwPv?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1a49a4-40dc-4f2f-1938-08dacbe98721
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:55:08.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r97eXTyxxkF1wMyKVUQE+HTTUZDEOoPBzDAoURKCHA6eGdn38jRNtXalbbAol2bh8M0hQ6YHsqPZGwLk+AVrOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 11:09:28PM +0000, Alexander Lobakin wrote:
> With CONFIG_NET_DSA_MSCC_FELIX=m and CONFIG_NET_DSA_MSCC_SEVILLE=y
> (or vice versa), felix.o are linked to a module and also to vmlinux
> even though the expected CFLAGS are different between builtins and
> modules.
> This is the same situation as fixed by
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> There's also no need to duplicate relatively big piece of object
> code into two modules.
> 
> Introduce the new module, mscc_core, to provide the common functions
> to both mscc_felix and mscc_seville.
> 
> Fixes: d60bc62de4ae ("net: dsa: seville: build as separate module")
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---

I don't disagree with the patch, but I dislike the name chosen.
How about NET_DSA_OCELOT_LIB and mscc_ocelot_dsa_lib.o? The "core" of
the hardware support is arguably mscc_ocelot_switch_lib.o, I don't think
it would be good to use that word here, since the code you're moving is
no more than a thin glue layer with some DSA specific code.

Adding Colin for a second opinion on the naming. I'm sure things could
have been done better in the first place, just not sure how.

Also, could you please make the commit prefix "net: dsa: ocelot" when
you resend this and the other networking patches to the "net" tree?

>  drivers/net/dsa/ocelot/Kconfig           | 18 ++++++++++--------
>  drivers/net/dsa/ocelot/Makefile          | 12 +++++-------
>  drivers/net/dsa/ocelot/felix.c           |  6 ++++++
>  drivers/net/dsa/ocelot/felix_vsc9959.c   |  2 ++
>  drivers/net/dsa/ocelot/seville_vsc9953.c |  2 ++
>  5 files changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
> index 08db9cf76818..59845274e374 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -1,4 +1,12 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +
> +config NET_DSA_MSCC_CORE
> +	tristate
> +	select MSCC_OCELOT_SWITCH_LIB
> +	select NET_DSA_TAG_OCELOT_8021Q
> +	select NET_DSA_TAG_OCELOT
> +	select PCS_LYNX

Please keep PCS_LYNX selected by MSCC_FELIX and MSCC_SEVILLE respectively.

> +
>  config NET_DSA_MSCC_FELIX
>  	tristate "Ocelot / Felix Ethernet switch support"
>  	depends on NET_DSA && PCI
> @@ -7,11 +15,8 @@ config NET_DSA_MSCC_FELIX
>  	depends on HAS_IOMEM
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=n
> -	select MSCC_OCELOT_SWITCH_LIB
> -	select NET_DSA_TAG_OCELOT_8021Q
> -	select NET_DSA_TAG_OCELOT
> +	select NET_DSA_MSCC_CORE
>  	select FSL_ENETC_MDIO
> -	select PCS_LYNX
>  	help
>  	  This driver supports the VSC9959 (Felix) switch, which is embedded as
>  	  a PCIe function of the NXP LS1028A ENETC RCiEP.
> @@ -22,11 +27,8 @@ config NET_DSA_MSCC_SEVILLE
>  	depends on NET_VENDOR_MICROSEMI
>  	depends on HAS_IOMEM
>  	depends on PTP_1588_CLOCK_OPTIONAL
> +	select NET_DSA_MSCC_CORE
>  	select MDIO_MSCC_MIIM
> -	select MSCC_OCELOT_SWITCH_LIB
> -	select NET_DSA_TAG_OCELOT_8021Q
> -	select NET_DSA_TAG_OCELOT
> -	select PCS_LYNX
>  	help
>  	  This driver supports the VSC9953 (Seville) switch, which is embedded
>  	  as a platform device on the NXP T1040 SoC.
> diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
> index f6dd131e7491..f8c74b59b996 100644
> --- a/drivers/net/dsa/ocelot/Makefile
> +++ b/drivers/net/dsa/ocelot/Makefile
> @@ -1,11 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +
> +obj-$(CONFIG_NET_DSA_MSCC_CORE) += mscc_core.o
>  obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
>  obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
> 
> -mscc_felix-objs := \
> -	felix.o \
> -	felix_vsc9959.o
> -
> -mscc_seville-objs := \
> -	felix.o \
> -	seville_vsc9953.o
> +mscc_core-objs := felix.o
> +mscc_felix-objs := felix_vsc9959.o
> +mscc_seville-objs := seville_vsc9953.o
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index dd3a18cc89dd..f9d0a24ebc3a 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -2112,6 +2112,7 @@ const struct dsa_switch_ops felix_switch_ops = {
>  	.port_set_host_flood		= felix_port_set_host_flood,
>  	.port_change_master		= felix_port_change_master,
>  };
> +EXPORT_SYMBOL_NS_GPL(felix_switch_ops, NET_DSA_MSCC_CORE);

What do we gain practically with the symbol namespacing?

> 
>  struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
>  {
> @@ -2123,6 +2124,7 @@ struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
> 
>  	return dsa_to_port(ds, port)->slave;
>  }
> +EXPORT_SYMBOL_NS_GPL(felix_port_to_netdev, NET_DSA_MSCC_CORE);
> 
>  int felix_netdev_to_port(struct net_device *dev)
>  {
> @@ -2134,3 +2136,7 @@ int felix_netdev_to_port(struct net_device *dev)
> 
>  	return dp->index;
>  }
> +EXPORT_SYMBOL_NS_GPL(felix_netdev_to_port, NET_DSA_MSCC_CORE);
> +
> +MODULE_DESCRIPTION("MSCC Switch driver core");

Ocelot switch DSA library

> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 26a35ae322d1..52c8bff79fa3 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -2736,5 +2736,7 @@ static struct pci_driver felix_vsc9959_pci_driver = {
>  };
>  module_pci_driver(felix_vsc9959_pci_driver);
> 
> +MODULE_IMPORT_NS(NET_DSA_MSCC_CORE);
> +
>  MODULE_DESCRIPTION("Felix Switch driver");
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 7af33b2c685d..e9c63c642489 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1115,5 +1115,7 @@ static struct platform_driver seville_vsc9953_driver = {
>  };
>  module_platform_driver(seville_vsc9953_driver);
> 
> +MODULE_IMPORT_NS(NET_DSA_MSCC_CORE);
> +
>  MODULE_DESCRIPTION("Seville Switch driver");
>  MODULE_LICENSE("GPL v2");
> --
> 2.38.1
> 
>
