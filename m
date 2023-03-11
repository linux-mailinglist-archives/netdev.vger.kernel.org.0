Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA26B5B55
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 12:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCKLuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 06:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCKLux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 06:50:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72C8113888;
        Sat, 11 Mar 2023 03:50:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kag6z5Uirzciws4nEQJd3TgbkOJBNaXYN+gR/XCcfbwLGVBwRaOTTuNhqRuTPONhxpbfNnJ1SIerNhgVEhm9b9MPjgseasjpqO+iV41XhWjlaqy5zb/R/44QkBzlMwB7gigflahdSD/6eQ7oFaQZV20DO7MIPYMa8+zPC2oM8vaXMLfB8kPZZv65caN5GJxjG2vcy2U84kGY+gdTFbi6x9CEOEa9Gs63Pk4uoETUs45WX3YYU+Vj6eFyLozwMx9uZYdfAbEcg2xcVYhy+8p3BFYi3lvc9CfqCoPAlEJABAly/XHsopmlU60fe7tPldlMIhlsJMoctkFMexmjn5/91A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LAPuUMNN/pyrWUcMpJ1tl15Jt0/Lq5Jnz65GeyrtiCI=;
 b=VkDN+9bv4EyMcaYxV8cso8mqO9Wkzx8lcugFEwkw+zQ+/KtHABXqxkygnyBk3OV+Sb12/J2c4fFfS0jRhG5euGPnpE/TZFiZOtkPD82ctJXXx0FRVKHDCsVIgNrGNEmNCdGGNezjjEjprLfLVo/TAukn/vJzftwreHVRtwr2Oqd+0U4GhLkBRlW4t1Eqh1W8V+kf2wJkUDr6VwDsPRbKuPZqaMEre2hGxeJ5xeqAQdfHh84USfNDGDiO43yXfZQtDLSMeZuzvCL9rIVHYD8fndj6SnOx+qNpbMKaqe4G5oQk0wThVNWhOOUm1CORm7j0UTZa3XbPci//ct/4dFG6Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LAPuUMNN/pyrWUcMpJ1tl15Jt0/Lq5Jnz65GeyrtiCI=;
 b=EzmX2aDL9uRDpeHOQ547gRxk73ietKvb68t/jGf+KMcbsUsLPtEJn6vjIG63V54mnX695o+9qGNYBDPdMzHg2QNK/TZzADRhfCpOIzu3AXxudFzeYZPk8OuaOqojfGiFgdEcakItmBnYAPjjTKoHkDlcdxjV+e6pk6CdomgCiPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5121.namprd13.prod.outlook.com (2603:10b6:208:350::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Sat, 11 Mar
 2023 11:50:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Sat, 11 Mar 2023
 11:50:42 +0000
Date:   Sat, 11 Mar 2023 12:50:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhao Qiang <qiang.zhao@nxp.com>, Kalle Valo <kvalo@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: Use of_property_read_bool() for boolean properties
Message-ID: <ZAxrBtNdou28yPPB@corigine.com>
References: <20230310144718.1544169-1-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310144718.1544169-1-robh@kernel.org>
X-ClientProxiedBy: AM0PR01CA0098.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5121:EE_
X-MS-Office365-Filtering-Correlation-Id: 300f51b5-03a4-4d69-f2f7-08db2226d74a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YxKzWDfaCiJLc++Qw0BB2RYxLP+p3eh2jp+z/O1JGmtteZXktxSta8AB8WqhCCFE6qdTtfEyPxkOz//bEEK5T85vdi4eM3eZdco+wieWFnhd3jBh9rfbV9MS4PmE8D6KHaYfPIJr6Cvk/Gb6/b8Mryo/Dm18XGa+ymPPNy4Ei1J/GZ89tRIXHxZSkDOKMrptgDfNIl0a+2xXZTkY9Q8ruwarBQvNL/WhF/INuozhdO/iJYltR/dT5x8wFM72qQhYbtSe1Uh1m+nhVFm4/2EXVzumLuMDq7/yYlLkiYiatRTusbb1BICQbHvfQQhxbYAbxdqWJvwoO12l3bcGCtXS4PLWtSbbZ61x/Q9TrYdwKxEXamyMzXWc5SUdPFlS9W1bsUcxcVZ5/JlcEtlfzafMmpTxyt36uCwm67k0gnRDeDfxWN5KOeOWeyKm/YtgBB6FIjdHXESlONr1RtSwMmQmW64vvpw8HR4xSEkjgDTfl9ELY6FIkK2afHb3vPntn2aHGSTvQoVA0+h9mnBDxIVSZrrweYuQL8d9ivw3TBQM7ma7AAOF/wpTyITHdqh2wWjOaEVC5lg9IH5XdFM81Dha+UgMU3M74A2i+emcTMoNfTT4/5Lw5YMxXaPcoa90M+Nnm/YxZewV3N0cfM8ZP47d16SyIHjUUZ4NVFqwClKgXC9WW3j0EG+PNw1hNEJX0auF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(39840400004)(396003)(376002)(451199018)(36756003)(86362001)(83380400001)(38100700002)(8936002)(478600001)(41300700001)(7416002)(2906002)(5660300002)(7406005)(6486002)(44832011)(6916009)(66556008)(66946007)(66476007)(8676002)(316002)(4326008)(54906003)(186003)(2616005)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pzN5DVG29kX2M9Xa9Ub6RXXfUKSzW+Bfvk3cGi1Kh/KzqPt6a5GLgNqPQ2mY?=
 =?us-ascii?Q?rKBHHKUy8Uzob9I4VbOON8CU/N3WP2xE5JEtnjAVKqCg1q30C4V9/XJS5zH+?=
 =?us-ascii?Q?Byvam1h112E58yu+KfmrwFuAuHFNqhc15QOt37BCFVjfOIRBxhHMLXmJBftC?=
 =?us-ascii?Q?9bWVvDYYIkDD4Ws8dx2BhthFx643uaSnZ7mfcGRyrrxeURrfnwx3zSZVeLS/?=
 =?us-ascii?Q?gajnTXcMj/Ysi8yjoTg7IXhIo86V3ojSfyh1U49XwZR9QGVczr3ZBnTGJBcu?=
 =?us-ascii?Q?qgaU4iwQh1e+nOK0OyPpi38unk2q3hjcjF2cZ0bJDqI3Zu3vNIOZZWJaqO2I?=
 =?us-ascii?Q?feRdE7q1lkFFxwxf+KuGu2/UfR3JnQ2bnmFN2xkyzoIQ0NIT3oVZe7J0TR2I?=
 =?us-ascii?Q?viHt+JhRrlajTosuPpmfz0S5vsY8ax9mqFCwqDi7r4TPePTfPBcZhaYDGSL/?=
 =?us-ascii?Q?oVW+5aW2yNRMzh1aaADgaF+D3eQXFizQ34M1UU/mF/SipvF3kDPjhHB474HU?=
 =?us-ascii?Q?96mIXHme80LJPEs/AO490ZA8Shud/PaxjVWQetv8neulmWpOF/3UeUcc+seb?=
 =?us-ascii?Q?bbRImFU1LP+Lp4LRrJNCK2pQt/nxzUa161+X83iQ35gSEt3iFh9XgTU0Pphz?=
 =?us-ascii?Q?tBUUR29izugrA3jZZU9cU1j97gjKKyKt4MhA+2YYPtdumppPCYP6hhkdTIPo?=
 =?us-ascii?Q?8htHou63Sh+d3K2e3um8IImd6OuK07gRbrVS+uAYh53dooBn6K85X0UmLuhf?=
 =?us-ascii?Q?2TcKqgBCBKyrjKLsJzPjJVIqz3i2PIz/PN4XAFt7pHKPqsNrpaPKZsq3A97s?=
 =?us-ascii?Q?RhvoVM5wtx8E6/VDFttI6gOZ6wxP1+85H97PTvQUkuFTIFso0Nn/Vz39geYf?=
 =?us-ascii?Q?X9j2Tb9Plu46+AL+BaWIz/xzslZsJ1yiH6K90vGsOMjKo+cX3/ug5HoerAni?=
 =?us-ascii?Q?XUrrrckohB2Y9QjOy1OsUWBvEyT87YLVjM8ot8xOU7x1/gbx/wkS2LK3SpIj?=
 =?us-ascii?Q?Y/y5LL7XtVkCrAUbua1/6Hu9mN1mKOpEQ4KJ5mRmPtHt5YvU31+svygGn4BT?=
 =?us-ascii?Q?BKANpk2zJT9RqGQW466z1T8gtlxRw7o1UV8YrUlGxaMbLii/nU+si1umeqQQ?=
 =?us-ascii?Q?MZClcPe+Pc0h9FI8Vax04tjvbsk3VADdNUIX+B0c5dFYtKZvdOkHx9tI6dFN?=
 =?us-ascii?Q?SBMruHbZMF5WG/6S+3+zL1f8sx9HgVqd8MZa/NCzwdI/+x0V7Lv3dMadY/d6?=
 =?us-ascii?Q?yozjtriVWQkudT86xUHLs0TC+EaC4ak/YvcE60SbyemNjhdQqtt3KDD1BplS?=
 =?us-ascii?Q?DCjrsONVbdPqYUxoPxW0YYf7yTtZxYRsQwuboCP3Tu59zgIu4PpNQZeCZAMj?=
 =?us-ascii?Q?1tktAySmxTfmfun4aVBngxncmcnlaZz8/w771PphV0mQcEICvqxnTz+hYkmY?=
 =?us-ascii?Q?1hBb3RP8jW7IJJUW2mUp3y4FhHPf+vyMVaaxYX9JJxhZ3NvlUzEw3nwdQxcD?=
 =?us-ascii?Q?WCRVqUFtHMtKZR844sGP9R6woik6/3821Ov1AmLJNm/fzodmU2bW7SjGAGdH?=
 =?us-ascii?Q?RnDSRlwZC77oEBCL/aCm2zIBXB2bzbens56imOQFeezuc6g3ceePmRXxsyUp?=
 =?us-ascii?Q?wtKsRsR2XXdeJxet0hFNvvhhbAVKXWV2AEX3hwJx4sNU2U5dIXixo/lexmpC?=
 =?us-ascii?Q?QiEo6w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300f51b5-03a4-4d69-f2f7-08db2226d74a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 11:50:42.3702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bZDklU53lRpr3xCoY58QZy7nlMvpDDoaMZm507OpZ+skdhpHsSdZhisf3vMwwVNmXm+ALGT1o9AFPjoOHbSWZSeYM+bfqdI4kd7W1CTA4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5121
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 08:47:16AM -0600, Rob Herring wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
> index a502812ac418..86f7843b4591 100644
> --- a/drivers/net/ethernet/via/via-velocity.c
> +++ b/drivers/net/ethernet/via/via-velocity.c
> @@ -2709,8 +2709,7 @@ static int velocity_get_platform_info(struct velocity_info *vptr)
>  	struct resource res;
>  	int ret;
>  
> -	if (of_get_property(vptr->dev->of_node, "no-eeprom", NULL))
> -		vptr->no_eeprom = 1;
> +	vptr->no_eeprom = of_property_read_bool(vptr->dev->of_node, "no-eeprom");

As per my comment on "[PATCH] nfc: mrvl: Use of_property_read_bool() for
boolean properties".

I'm not that enthusiastic about assigning a bool value to a field
with an integer type. But that is likely a topic for another patch.

>  	ret = of_address_to_resource(vptr->dev->of_node, 0, &res);
>  	if (ret) {

...

> diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
> index 1c53b5546927..47c2ad7a3e42 100644
> --- a/drivers/net/wan/fsl_ucc_hdlc.c
> +++ b/drivers/net/wan/fsl_ucc_hdlc.c
> @@ -1177,14 +1177,9 @@ static int ucc_hdlc_probe(struct platform_device *pdev)
>  	uhdlc_priv->dev = &pdev->dev;
>  	uhdlc_priv->ut_info = ut_info;
>  
> -	if (of_get_property(np, "fsl,tdm-interface", NULL))
> -		uhdlc_priv->tsa = 1;
> -
> -	if (of_get_property(np, "fsl,ucc-internal-loopback", NULL))
> -		uhdlc_priv->loopback = 1;
> -
> -	if (of_get_property(np, "fsl,hdlc-bus", NULL))
> -		uhdlc_priv->hdlc_bus = 1;
> +	uhdlc_priv->tsa = of_property_read_bool(np, "fsl,tdm-interface");

Here too.

> +	uhdlc_priv->loopback = of_property_read_bool(np, "fsl,ucc-internal-loopback");
> +	uhdlc_priv->hdlc_bus = of_property_read_bool(np, "fsl,hdlc-bus");
>  
>  	if (uhdlc_priv->tsa == 1) {
>  		utdm = kzalloc(sizeof(*utdm), GFP_KERNEL);

...
