Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06322632A01
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiKUQua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 11:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiKUQu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 11:50:28 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272683FB96;
        Mon, 21 Nov 2022 08:50:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuIZpNL9CppH1xlqrBmuZ7N+Ao2KsKj7rnrL+2FQQdfMm2K71Y3r3C72PvZhbnOkoVAIgavB16bZXQhbbjUELbx74HCrHdghnwl9SNuMwPa1knXyfqzYA4O+2i3twzs1y+iaVOVPQHfgKzJ22WARNKUKjPJen0vjQUlNkw3nQxzxF362+b7TWCkM7Dxv0RPNyixIYEYNPde+17r7w8oayX9uRT/PI9Gwa1Mcfl6OBQSUf7IdBi4Z/JdW7SWR4StDh1Cb7uDsJkTK3NTZhiWYn/FCcrld5rmuJyT9DqDF3kwoGbu/10v/PQRWlrJBzzHCPhygFGWG5FwK4oOGK6O16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lnyde7oKhQ0Eb5CDmCTgUrxkBI7yy9OihQmvMaNZnCY=;
 b=IOOJM4rWgsTt4Qtv6mmZ+ZVgsYaXkyFDOQKOcI1fSIP9BEffAGl5WZF8BNt5sEoBn08E9Bt/FAgJH0OGMJ5ZGnkSqja0+SSc6DOWn+yQ/Fubo3vguSriIRCmaLUEzXV80yJJZmIasXLI7/12ksJi5jE/xGin/9YmJAoaT+TSaeHBSokkg8h9K3Fy8y7tMgVQbPL5D0eAJYdn0ollihENUSKRmMSJz4AT5Z510FVRGnwzQ7vEeQZcY4+2PYtc59vCBDyuW/XxAdDpdc6Orxsz7MyZszo7RnhBmsQGdKmPJ+0yQfkEm+HJ305IoJ8YgbU15VD4MVuffG0KzUyurzPNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lnyde7oKhQ0Eb5CDmCTgUrxkBI7yy9OihQmvMaNZnCY=;
 b=fbuNQcbUlBPH62bV8OxghEWGJGpKHzpCSKyWkvvG3nrjt11avYZqh4fiWcp+o+GAKYYw7M/AYPYdTX3Eo/1dB5o0RUutewTYeNq+YMzULP+1sGwyU5JSXwxywyoD5fJ3z8TL6AVseAWIEj6lQodjh0Xc69YYKpS+nVuQsGWGQug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7356.eurprd04.prod.outlook.com (2603:10a6:102:8d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 16:50:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 16:50:25 +0000
Date:   Mon, 21 Nov 2022 18:50:22 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v2 net-next 2/3] net: mscc: ocelot: remove unnecessary
 exposure of stats structures
Message-ID: <20221121165022.bdljyrwwhalgzpsa@skbuf>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
 <20221119231406.3167852-1-colin.foster@in-advantage.com>
 <20221119231406.3167852-3-colin.foster@in-advantage.com>
 <20221119231406.3167852-3-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119231406.3167852-3-colin.foster@in-advantage.com>
 <20221119231406.3167852-3-colin.foster@in-advantage.com>
X-ClientProxiedBy: AM0PR02CA0120.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 632b01df-11fa-4659-cff5-08dacbe07d07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWQPTDDKtd3Nh93IMH/dg7ziAiDPhjhYDwYEZbxlD53IFusZm0vC4CmEoD8FTkKdM8wB2IPhyH9WCJtA86KMh/GmaadL3knhmZUpXwDeAF4Qjg8V8ikLYzo+xuB/I06eVlOniV4C/1oSpi4Iysf9/pI/bGiKFuogjTZBqxfkKkGCeYASe6midR+sfxdwplG74po8fYmQ86ynyfpvAtaFbdzMbYbaSlp/CxkJ0jMy/KPa1VGGn+/Y8pVM13UyqCOyVgcBOryd9oeL/X1AZEwrEhbKSwQU4c4cckRK6szuhws3w5GVBkkv/XiWbQsC+s0x6RBtRFF2pDf2eg5DrVYtVTpj6JJ7ewk4VAe52klc3jtlNQjA6n/tnaG1oOCBh4Kh2qzFZ6N5mbThFU59EYuim02A/82Qb5ogsnQllP5clUVN6I+a3jfcVq8abh5YlYN8ylzK0cYz5SIDklf9VBGAy+6e9C9gYSN8kwZd5LGFZa7AqhJbXMiJTLtIKj4oAgZd5CSgiDmCk/PCip8tSlOuGZVVXtiN0oD1zOIFJUKtULprEdXVePaU/LyhTZLp6FP03jiCLoE3G4be8wQy13Xs3Gq93Sj8KPachfiNDCkthid+VEQ49Pqaxjm/DRfxKSTCM75HtMQ1LPSUe7EvVY6QBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199015)(86362001)(38100700002)(26005)(33716001)(4744005)(186003)(1076003)(6512007)(6916009)(44832011)(9686003)(2906002)(54906003)(3716004)(8936002)(7416002)(6666004)(5660300002)(6506007)(478600001)(6486002)(66476007)(41300700001)(316002)(4326008)(66556008)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gK6xuVCPeKdr+oH79exK8+2tZbr9p7vLgRhgDmP1KbzkEJ7VvGiOB/h1G2FJ?=
 =?us-ascii?Q?yqBGCJ9cfYxSp+ncHEP+vdfaVtPrLBUnSwR6kmRf7IVwh5Qos8MmMBuszbHw?=
 =?us-ascii?Q?H0UkudY/oAvVWEGEg8UYBOgEyNSPpMol6qR7u9pY/GORvPEu+XJrRvBDRLd6?=
 =?us-ascii?Q?+gcsK4JbLMPhV6Ahj7tQDEAenxgmOTVbsTt0X1UVAQezk2fsaCxp/Dn78y6u?=
 =?us-ascii?Q?gZlYwh3ZSeNiIbRFiGOF/oJF4ocRT0szH/R7TTGlrdmiBi6CKWybqcro4rG3?=
 =?us-ascii?Q?W+S2XRj6ny0VkbVyk5Sa78YAsPiKxmuRkDQgzFKxwVxVXJoV47bzjeEcOP+F?=
 =?us-ascii?Q?K0goMgFVBaDackFUWPy5m/9sxaPdDPfrSoVZuj/OxlEVhBONwzr8s5NT8WOo?=
 =?us-ascii?Q?vqUaMQaO/Y0myZYmJoJxUn6y1uoa/29QRvrOT4zh0fDExuNd+M/EKXX2p4hy?=
 =?us-ascii?Q?ODiVFqgPEhi3JtZmxe/LGUpNT3NzHbyBEcEkBSQixv2i/G+tk+vUYPcHPlZ5?=
 =?us-ascii?Q?+/qQGUOOnL9568PwnNblrozGqOBcQ6Qa8LZNchWuMorruu5emqHwjQeBmTwd?=
 =?us-ascii?Q?FENAAZfeQ6qpfvxjJNWSdpVsESwmlTiMdPmml/E4BigkIa7suBe/BBzClOBk?=
 =?us-ascii?Q?kfT6pnRpn0yHVeif3o/UJGaE/XRIZc/YBQRU72uloRdcLsSPFKVKVu2KW0IM?=
 =?us-ascii?Q?24BNwydax47Qe5BHOIF+rNmp1sVIxAyGSq2x7M5KXJPOclhktXuQDevIcqw6?=
 =?us-ascii?Q?aVK8Mo8SNcFQeO+TQuPzlgcaLaPttuRozN0AH+sGY/KdZBcfneNhdTJwMGo8?=
 =?us-ascii?Q?IPLln3WfegICl/OeTEhyCd82Ei/XcTt/XaudJpwqjAJw4olJ5yeKaBg4BVvg?=
 =?us-ascii?Q?yt55tWX20fHZIS2HVNZ4tThahT7HDf7LbwhLkGx/llI3n5p1hj8vjUnxPiMf?=
 =?us-ascii?Q?CqSXWSK3v1NYsodE9FIQ9mMPhoxb9bFBc450BY+jc12BdkYGJQnxQxMvF/bd?=
 =?us-ascii?Q?p/bSLFe5vEniVH4vgR7nBUZ15WUa/bREjHuMijiJahTx+jGuZRmelM4g1BO6?=
 =?us-ascii?Q?HiBI3kdHc45gv6C1/n7KEG/8hw0nonDHC6tEwYXe44Bdbm3XwfrhDZdj5/Xk?=
 =?us-ascii?Q?MUhh3grybOxyknR0m+dXhCytAKHE7zxQFPjFA7KrLfAPJYLGccI76EvE01+0?=
 =?us-ascii?Q?dt5Qzjk9m2RKYBquGbuz84aWlUI7+1ZytEBgY6ksc/Fi1xIPIQQHtYuxykyS?=
 =?us-ascii?Q?9SgwpWewU5X+MCJiCUo7zrtGhWd4lTf2GfXBNkliR434e6BJBGzrfZq4ysse?=
 =?us-ascii?Q?wavMZFGHX+LLU7nv4JW5W3kxQzyj0jDXm4e2cu6OwBvkc+6QDpfByUZtYiHb?=
 =?us-ascii?Q?iVfl8jwuc0JdTdtZQw220N15dHpUspLhSTNxB8lXuHp9/0/9YORqtJ6eGItq?=
 =?us-ascii?Q?pn+EQ1tKjm5LgtK9Wnx3OTm3tLcn4AH7bUpKmDxwHTjbGVG+5DqrQaj2kXm7?=
 =?us-ascii?Q?QxCfpJLc35zClK1KG8a78Q0rinZZd0xGY8CzPAkd5bdie0hym6qwdLAVOhV6?=
 =?us-ascii?Q?sUWLRkqCRxyweJGk+2emP+Hobd16HNflzS1LEzUAD6gm9t8JNJtSTIP+fdSe?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632b01df-11fa-4659-cff5-08dacbe07d07
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 16:50:25.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gjKIfk4Wt+kw15nhBe7+VZ9IPPBcAUzfT8OaYlLNHIck0x1mIDZsyR8Ttt8vxAv0LOuvqJjApyX3yJOLASfeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 03:14:05PM -0800, Colin Foster wrote:
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index 5dc132f61d6a..68e9f450c468 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -460,3 +675,4 @@ void ocelot_stats_deinit(struct ocelot *ocelot)
>  	cancel_delayed_work(&ocelot->stats_work);
>  	destroy_workqueue(ocelot->stats_queue);
>  }
> +

There is a stray blank line at the end of ocelot_stats.c which this
patch adds and which doesn't belong. Either you keep this patch set
and fix it up later (I don't see another reason to resend except for
this), or you resend it. If maintainers don't complain about the new
line while the patch gets applied, I'm okay either way.

Anyway,

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
