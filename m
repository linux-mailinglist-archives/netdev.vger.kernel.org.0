Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C6655111
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiLWNpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 08:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiLWNpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 08:45:08 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2071.outbound.protection.outlook.com [40.107.20.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D99379FF;
        Fri, 23 Dec 2022 05:45:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoHx4nxiJolcxTNPRe/99d/YgM3CUbmp4e6fwmaaif1r8XyLEGQDT0N+yiwUFyjnjHzqKTMj2INJ4damUW+D14mUVa2rSlOykf/Vc4EdshE7U0AMJudf6us6KwCdtaInCfOcOJR0J9e1B9v9nc8aYvdl761plirDEH+FVcpqXlEmISgw0WyFwLWcZQp52GExCniNETFNWXfKlBWG5wZRy2KaNus+rTVnL65lbVQIc7iyAZzKB0YH3+xTL9O0en/Fou6OPAGmtPyZrUJ3Px9mhbcYtsSYUP1tPlqHNBTjf2uO86o1YOXGJhaywPLhX0V1Y4NKJyO71S1cDzTk9yl+CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtEiLivQwp/fioFvoNRgX+n/ZMzXRoL+d+sFvEnGxo0=;
 b=NIB97VfnzbhJPhrirkMvP093oGgfY4P1raBVoLUGzYz3E0a3W76o2D1W0DhkBkTnN5qhLC1YfiXT/KhmERam/A+dE9zGRBfm3cm9p1+sWeaz3R06uKqJZiGIEStIT0tJAOfEgUaHRQ/d4vj0fROV+c6IuAKlckp9QFJ7Tcx8/wzdTbx7v5fzt0vKxMB+lLTS5DL9hLUuYmjrRg/EwRqiEiWzyj/mNq/HZi0b7obTp2OtlryQI/9cx9LzN8yDpArXo0cT85WN9zOwxR84M/1MtH0opnQnDsdU8eLSghdhqizkyAXUKri8Kgl04MZ1NDZgPK9+eYBGZvwE4xxil4udrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtEiLivQwp/fioFvoNRgX+n/ZMzXRoL+d+sFvEnGxo0=;
 b=LK9xrFEHf+Wvyg7wlbhoiCLRbsr6A1DrTQ6O+vS0ItTryAcayJ9999NJu9FRNHl5yfzycvPt7udgZ81UiSF/b92h4dqT7n4gOo/jUaSTR965qHzSLeDZPQm+3youKYdakRnROnX1uf+MlNieC1VxaTI0d+AdBCxAbipgJDTHieY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by VI1PR04MB7200.eurprd04.prod.outlook.com (2603:10a6:800:12d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.12; Fri, 23 Dec
 2022 13:45:05 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::2101:60dc:1fd1:425c%7]) with mapi id 15.20.5924.016; Fri, 23 Dec 2022
 13:45:04 +0000
Date:   Fri, 23 Dec 2022 15:44:59 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <20221223134459.6bmiidn4mp6mnggx@skbuf>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
 <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
X-ClientProxiedBy: BE1P281CA0097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::18) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|VI1PR04MB7200:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d1e3b5-496c-43ce-1943-08dae4ebe4fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+wXTH2ay+IPmv2dQNhSV7CoO3ncxjmSCaVxgM+U+V7fiwPU877GynyrMrbtiarXsybZCwGz2UxDqVodAK7ZiJevOomS+3o72i/9UdV7V/RYHOeau9C7572UbgmORKvCHIsiIJziv80+0TynVMZ9mZGlnkrozBkXqlpCnj4+l86kdVmnUL4TyI+3/pm0T6GsulMkRpAyHpltB+h1D3Z55OGDc20u/KSQDYWh/zIOKwqplpjHEAR4B0pRgorxvKkuHUwpeQrLJys+90M1+MUKkltAnVjA682mGxURp77jnOXBYe+LvMwm7BkxtS9UYjRXBIVJVswAbVvwQUnYoHyZsegu9ogO2eZs5/oWcletRPoqCfyn1a7mP7pyHeywrhKIelNAzJlBSkGkT4J72AbjGZuxp6Iuz1nxyV0Vq43d/TkwsOHuuGkWPwms2qzYU1oOohQpQhaqW3c0RF6TNLyo1mfaCoCKt2zrr7XYL+doOLJq+qzvRnSxxpMLDsc2QiKUvQMZR3kJVFXmKTVsiYklxI9G0DJAabH3b32HdL26G7RNP4ZKDD1+U3ec/ylU+/M1vZzxo2qpPT03wTla10G2JDh4GdR0Tg1cojAMeSRipH1MLsBxi3oHh6j+FDvjx2JJaPZVOtft4hrOwhb2GiHPN4zJ/ui67WNI5eMCIF6SFFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(6029001)(4636009)(7916004)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199015)(478600001)(966005)(6486002)(6506007)(186003)(6512007)(9686003)(26005)(6666004)(66899015)(316002)(6916009)(54906003)(33716001)(38100700002)(1076003)(66556008)(4326008)(8676002)(66946007)(66476007)(8936002)(7416002)(5660300002)(44832011)(41300700001)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?29sovAKvC5jYWOfZjBgbwsWZTS+j/p/ymdwmOFKb3JkOzZelP/8YLAB5IzgJ?=
 =?us-ascii?Q?tO3HwbNvf50mXZ8CDETs4eo1aZq0BLTNB/SnjdJiAjZY4oGpUDgCRIx0fxwU?=
 =?us-ascii?Q?rYh3dcPccfX+UdPRIPInqlMNYJQzlK3IuMO/WwjQeo8LkiMSUa/zOWCL2Tte?=
 =?us-ascii?Q?q1IlfUm/5XbrXsBFTJYbNnWoykCKn0aqYEKk2fkFaIbDkQZSnhJPBe+aTGeT?=
 =?us-ascii?Q?bZ4+80MdeN+fxSnh0uW6R+eUuzbEEnb0ROo12rmTS1otR5nw/amjLlnArpeF?=
 =?us-ascii?Q?7bM0NC99KPmTPXoRRZoGCGcKtVr7m8kLQJ1K2nfigEQwNTc9K+vvOaj0VYXT?=
 =?us-ascii?Q?mPS+bNRgBARb8ExLctkXv4MezxPvvkrvYE6XtcjPgdrcq86zDK2Q8Wa+QyF+?=
 =?us-ascii?Q?qOz540fUOoXZP9nBbWA/FGYZWTWs3gGIKHvb4GuOBAoyNOJJo41hDkX4ZhvP?=
 =?us-ascii?Q?nhIiNNMxoqR48XOEyrJ9JaB2FIaxGmrIwBG4xfoFBgHcGOwkXMxqq4B15S+I?=
 =?us-ascii?Q?XkHuOIivlHZoGWnXgP51eFjnTr7IxSwpnQUx0vw3FUphOJ8+/B9EWiIvvipE?=
 =?us-ascii?Q?2Lm4zVy0ZJ3QEQUyd7A94yybgqndKcYR/WbtNXtUnUyRQRLbJfUop4HFSl1F?=
 =?us-ascii?Q?GVOwIBDGs+4IqzOwvWqcfRpwtXBgaMygFmr5oIGVRXiHYABUIYYHadJjHuNC?=
 =?us-ascii?Q?RThEEJkjkWgEkySgXJ7TEtlqJpMTq4Yn4S+Um9OG7CxWyjWg/Wxv1w4LEaoB?=
 =?us-ascii?Q?O/9L/wIQcfHbIWLVC3SKMsnkZFwQmqHTTb0htyjcK9Y+05CkXXmqrKcxJrtR?=
 =?us-ascii?Q?Ye/McG2JqeYTvY6i/jCEqTD1hjdss36paOEDoH0/3HKYVLNyVX9Rqy1xTcfL?=
 =?us-ascii?Q?JCxFCzSlJPSDnMP+npIdAuUuRnSaZlM0Ni8swM22/nS3fB0oLWeieEt19hWO?=
 =?us-ascii?Q?h7TARS69n7UqvihHnIbA04RA+nmpbUnvd2mx9t7DOhNBy3YU3wjPotXj6gQA?=
 =?us-ascii?Q?WfmlBXByjnoM/k1+WF2xyENSNCiYlNAVFOifxtINTv1dNs3viSlHrr90i/dw?=
 =?us-ascii?Q?lqisnJ9oUtPcb7ZuoAYRG8OvTZqsz3QP6pYpL/AUie6pY6rdJnkwB9eIoEus?=
 =?us-ascii?Q?wi4CR4Zt9K6Mb13k3jk8lhrkieVLbSIl8r4j//E2ijNcz4RE0V+BdC9DW1P0?=
 =?us-ascii?Q?pGzsx9+Tz/IllAF063I2zaM6C8Rr5MbagAAOTEpM6/Cuz39c6XpUc2IDjYKQ?=
 =?us-ascii?Q?mib/C4sS1vX6RKhOhnls5TfSWMy+a6sf5jx1dPsXHvzAWIJcxBrbzecWZuor?=
 =?us-ascii?Q?/ndcYfQFYMseuqXdiJUt8MJFPeoUUw6o3ApT7FD2NWEHhaDD+wmc9NocJS2S?=
 =?us-ascii?Q?NdF14oT/YSd6q3dIX8P5Nbq11LQw5WmShPNdX0H64lz3jfLPNVIhYqS30uCt?=
 =?us-ascii?Q?b5uqT5vi3SgBiVpbmoIQ249aEjw8W8XFrBPyACLCG9tA5JLUqOCV46L30n00?=
 =?us-ascii?Q?kLXGK/6/mgNhgv+7J1Awv5mUGqqmqGm9/C43W86Iz6aevZEV4/OhrL6WOn4n?=
 =?us-ascii?Q?/Cshj91nTCuNj1zNJAuKkO7TQQ503Znyj3n9TpSwbmErHwiSiTKuSxCHXp/0?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d1e3b5-496c-43ce-1943-08dae4ebe4fd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 13:45:04.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tS6crX1oiphmW9glu4s3XMWK++gp5zl+3IUNnlaYL88gXJFsw7rH6T8SHxlGVyqjScVRME7awsPivuJ/VbGt2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7200
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 09:44:14AM +0100, Krzysztof Kozlowski wrote:
> just trim the code... we do not need to scroll over unrelated pieces.

ok

> > However, the irq_domain/irqchip handling code in this case will go to
> > drivers/net/dsa/, and it won't really be a "driver" (there is no struct
> 
> Why? Devicetree hierarchy has nothing to do with Linux driver hierarchy
> and nothing stops you from putting irqchip code in respective directory
> for such DT. Your parent device can be MFD, can be same old DSA switch
> driver etc. Several options.

True, in fact I've already migrated in my tree the drivers for
nxp,sja1110-base-tx-mdio and nxp,sja1110-base-t1-mdio (which in the
current bindings, are under ethernet-switch/mdios/mdio@N) to dedicated
platform drivers under drivers/net/mdio/. The sja1105 driver will have
to support old bindings as well, so code in sja1105_mdio.c which
registers platform devices for MDIO nodes for compatibility will have to
stay.

But I don't want to keep doing that for other peripherals. The irqchip
is not a child of the ethernet-switch, not in any sense at all. The
ethernet-switch even has 2 IRQ lines which need to be provided by the
irqchip, so there would be a circular dependency in the device tree
description if the ethernet-switch was the parent.

fw_devlink doesn't really like that, and has been causing problems for
similar topologies with other DSA switches. There have been discussions
with Saravana Kannan, and he proposed introducing a FWNODE_FLAG_BROKEN_PARENT
flag, that says "don't create device links between a consumer and a
supplier, if the consumer needs a resource from the supplier to probe,
and the supplier needs to manually probe the consumer to finish its own
probing".
https://patchwork.kernel.org/project/netdevbpf/cover/20210826074526.825517-1-saravanak@google.com/

That patch didn't really go anywhere to my knowledge, but I'd prefer to
sidestep all that discussion about what constitutes a broken parent and
what doesn't, and here, introducing an irqchip driver which is a fwnode
child of the ethernet-switch driver seems like a big mistake, given past
experience.

I omitted this because I wanted to give you a bit of context, but I felt
like some of it was outside the scope of my real question, which is
mostly about how to deal with IORESOURCE_REG resources through generic
OF address code.
