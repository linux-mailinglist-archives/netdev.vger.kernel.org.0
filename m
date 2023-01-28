Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD69767F3E1
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjA1B6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjA1B6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:58:50 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2052.outbound.protection.outlook.com [40.107.105.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1B4FF0D;
        Fri, 27 Jan 2023 17:58:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnRjNWd+e/fZc6iAsA4yX92cMp6lqSE78EU0PgzJ55w/cUfqBzrC8gKzs28kww0k0ZaNNkAF3a7KQlUT0qXnCNY0+KAbvEYmLGFcJCKC3gi0Hj64PhPm+vb0cdo/waoI/l4V4qkDRFOyGbGth+2j7aAerVM1LCoTdT3g0G5KzAI/s60ZwRDZq/1oi31AEI2ca+9vbnccq8MMy7m+0hkFHGfwbH4Nh/kYN8YFufHxlzKTsWebC3xvKnATDRNTwUqP35pPQDPi19JurvOYopfyfaNj4C7+Tw+eEW0hQYbZOXBR4iV8QTYR6mCe+LcWv8DC3yypRbJGzjA0nNa99BJgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y24ozpEcn88RGwVVcHw/OLmGComB9ngjIsCiFeZElj0=;
 b=ItqtaxbzYc2j636VbBSn+Ad+jryBD4qwNX4fYvqq4Gu6MNhfkzSsazTvqz1oy7B9Sc10UYVGovGBe+11AlfLWfYdjlH4nvohZZdQOaI+wXTZkyqzhraMGzAGJ8oPdxcSJ81gHnCZeW2mL6NgO8GhkvZU/yXiGI6uOYkAR8FVUYc/s0Ii6S1qRkmcn7JdDWd3lofKJzvDwzUvaJa8UA4piFqdXSVGOI/U2ZXLBUUfhYscSLpy2MrcPOYsHI2JukkU78C9NI/aKhU6w/IF/Tt0Wnz5R52lYLRNqJ2wUjgnTxQhG5kuDbC5I8ChMx0BETulS4+ZDewkhOvdlAIfktbfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y24ozpEcn88RGwVVcHw/OLmGComB9ngjIsCiFeZElj0=;
 b=KE+7s5vfIbU29tUESWVsbYctJC7k/3q6YyYjrrtL47eYrfu1tLqDhkv3X2Hmj0Gi34wnLD3v6OeRtq8gFEWHyJnM5Zb0TxYskTjDJRf2FDd2bWy0z1v4W8wDjS227IKfzQDzu6s8n+Im+er9+xMh3rM9iykS/inbQQr4oLAFacE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6827.eurprd04.prod.outlook.com (2603:10a6:10:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 01:58:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:58:45 +0000
Date:   Sat, 28 Jan 2023 03:58:41 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: pcs: pcs-lynx: remove
 lynx_get_mdio_device() and refactor cleanup
Message-ID: <20230128015841.rotwc2arwgn2csef@skbuf>
References: <20230127134031.156143-1-maxime.chevallier@bootlin.com>
 <20230127134351.xlz4wqrubfnvmecd@skbuf>
 <20230127150758.68eb1d29@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127150758.68eb1d29@pc-7.home>
X-ClientProxiedBy: BE1P281CA0038.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: b236e40a-2c01-44b2-dad1-08db00d33056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbqQeOBP1oOP4Vd/jG9ijBwM/eOE+TIDccp0qY/qBijA8DHVo4lrt4jQ7zLGyV6q6pZB2GG8Wu264ksJo+LsOs2pT4kH/BepzaQH+30pZFzLgFu05G5xwEYY5yiPN1zxN4y8EN8cTFDpaMAK6YBS8N2J29S2X4NnRtkixPRGUqGEbINDFDx+gMaVsnVVtfFOt3GRVLmyQ/s1UiOJiuAMpttxzZ6F7TJ/WLdUP4UAG3ky47E8bKM+HU+v6vB3s+Y5xB7fBijBnaZg1WeEMvafi/u8a3s1COubkMX+UEaIbu4Sm9nU4N0ZU8cB3Qzh3X+BtEHP/tHDXPTplT7Uxgsbw9/1gVmJmUFEzNJ6yCVOAuzl6BHdBrCwxMMypzQLmOKffzghBH9+0sh/V8uP5rB/Yq+aAiBHf9KJMNJCM/b+nFNqugJSEiA2afmQos6gz4faH2BPa9y0HtvfQggOWQ4i8wcJU6s0ehMJ+OTUcOCkxWNOfgrgP3RqDbmrclmtbYM6iqeWdu5MEo3SKId/xW/FLl5IT7eUds3MR9K0yYsraQ72A5Q+DQVD0BPD12AjNyXXHdsiwfEVTAdY3cjEPK0E98xyRInqAfKtuIVeH24vl62GvJTBRC//v6TJS7IDmdHW6LMUY2iujA8wjEBuMHDZVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(2906002)(7416002)(44832011)(5660300002)(8936002)(8676002)(4326008)(83380400001)(66476007)(9686003)(66556008)(66946007)(41300700001)(6666004)(6506007)(186003)(33716001)(316002)(86362001)(1076003)(6916009)(26005)(478600001)(6512007)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LLxdtuq6k+7YqDkHeiSRPKuVJ8BCdNZWstOQSHMUMmVx+n3YWF2AKdBkuMPA?=
 =?us-ascii?Q?ijIHnmCLSDJCjrmKr6wKDFY8i1VQ3pxv6qlGOlTqDu2TSTmefQaHb1Q3AJiQ?=
 =?us-ascii?Q?4K9l0jvl/xsaea6T77Tpfg3GeU5Duckw16jNXeENlyPqYVTAhg07d377WnWP?=
 =?us-ascii?Q?mcYmBuztXXiH8HhRR6uZNBFF1jJuhUs2hJx9fMIRtkCFq/U3ttIQABZVSZ9V?=
 =?us-ascii?Q?TAy2FqxLaA40SBxCQZhSE+LPS3bQ8dM0QxX71MbcB/YVbDIowzV5Wygbf7lA?=
 =?us-ascii?Q?ZBob2E4GjG54cJm0y+gAdcGOWcsF+PLAwKcCh5psQCU0h6ALjVDO12hBcHMW?=
 =?us-ascii?Q?zGfQqBpwkbXnK0MLPePXFsJcdNwaWwfV5Nu9Xnkyp/5vUZovqGoO9uwhdKuO?=
 =?us-ascii?Q?C2L8lw/L1Q9Hvb5VC+840AtMnXkvjywjh7sx7K96YPME1Fc3dj3CEGfIEGpH?=
 =?us-ascii?Q?3Cgar4SFt/5kijRh+Xma7oEsdxVq+0OX760rOJv6AGfbLMQ+5DTBvo6Gtyol?=
 =?us-ascii?Q?DkbRQ6ISI/Fjk3XoqmndR3Rk70xTPZ/CgPeZj0NNOXHyMxgR8nMhRg9Gku4U?=
 =?us-ascii?Q?BzaETm4Nqqi+Odyq5/EyQxH5bdjpJVTFsZ1mN2Td5TipX7MPJkTW9IcnPBRt?=
 =?us-ascii?Q?SM9uf4MSGN02ZrKzFWSR54qQq7JLYP3mTF219qqi83GA31qG+FJ6U/5u08sd?=
 =?us-ascii?Q?gdqyvoX0mOTnDMzcnNDCsTvE1j9VGoBw9ZVTfaP2UOA2sT/So1UPN14+ENnf?=
 =?us-ascii?Q?l+h12DBdrMYVXsup6HDi2LKOfEBr/tlNRs1874VgtZJEX23MwnZewTyOfD4g?=
 =?us-ascii?Q?9OrZK/r73yQdUk8GSI1I/iQgZDUMAyS0QFwvn8Xq0U/lbq263BOaxQ71fnfT?=
 =?us-ascii?Q?79AyfIk9CoroGl7NPF9sztXygqwAvHHuivKr4BYmayjA1H8Kz7f7p8nUB0Ef?=
 =?us-ascii?Q?I/eMADzGPMq9QwW8Rggjt/htrqcLKCkmGiYgEabrAh/qNIo5uyvdPfN/QcUv?=
 =?us-ascii?Q?oaXnJaagTqkWBezDl34WLUKbj2OqTcZW8l5mEHNy+3iZoS8JldVEd/J6y4FL?=
 =?us-ascii?Q?KUyzAx/XNqaEfCt76w8QWaLR0xIXFlcrw/VJFavo9/NGHVEakOdmnSlsqKs4?=
 =?us-ascii?Q?NCpc+4TwFnteJiab/43am/WPRR4ihVpv2nxWzoAc+uHfQFASW3oi1m5EKmsA?=
 =?us-ascii?Q?hdEy6U2Ly+lInQzQHNOiSGZruGRgKR4orCTKmujYmKW6mUsx8dbl4VrINBnQ?=
 =?us-ascii?Q?cpqRBHIlZEBVijw/0d7SPFygUSP7q90Ol+D3bNSvvFrpodh9OIA2BWRL6E03?=
 =?us-ascii?Q?5FwQ0Xe3FqiCPMgikl7QRjs5xI7xrT5uTtgmWDPFt7uU93X4fO6xuHVP3TPC?=
 =?us-ascii?Q?wA5hpqHgM1SYy4PJLAJ3fpgimWKUUunwcGjLwYFfRY6gwM9m8rinV23cpAJe?=
 =?us-ascii?Q?/BXn4ZU059BwQx7wEOQrkoP9FNWS5HLBGy8evujph+CaWi05f1/ydmTrzzKd?=
 =?us-ascii?Q?bHB68rxSRjS8riUibX4KVyMzmKXOpYgob0XgJRq7Xem+eWwKJ/NWlMA8SVY+?=
 =?us-ascii?Q?IcZfba55ISqovToxMko64EoYElW5wrjzt0VMeBMP2s/iGXCqZakwA063W/FG?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b236e40a-2c01-44b2-dad1-08db00d33056
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:58:45.4029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j71VsaGVC+VC22mewynXZr80kpo3UbzVzeC6n2xCkDeXnVCIoa6sV+9cGQvoLOgMGqAfSpZ8zlhvGaLFVzIh6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6827
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 03:07:58PM +0100, Maxime Chevallier wrote:
> However this current patch still makes sense though right ?

I have a pretty hard time saying yes; TL;DR yes it's less code, but it's
structured that way with a reason.

I don't think it's lynx_pcs_destroy()'s responsibility to call mdio_device_free(),
just like it isn't lynx_pcs_create()'s responsibility to call mdio_device_create()
(or whatever). In fact that's the reason why the mdiodev isn't completely
absorbed by the lynx_pcs - because there isn't a unified way to get a reference
to it - some platforms have a hardcoded address, others have a phandle in the
device tree.

I know this is entirely subjective, but to me, having functions organized
in pairs which undo precisely what the other has done, and not more, really
helps with spotting resource leakage issues. I realize that it's not the same
for everybody. For example, while reviewing your patch, I noticed this
in the existing code:

static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
					    int index)
{
	struct device_node *node;
	struct mdio_device *mdiodev = NULL;
	struct phylink_pcs *pcs;

	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
	if (node && of_device_is_available(node))
		mdiodev = of_mdio_find_device(node);
	of_node_put(node);

	if (!mdiodev)
		return ERR_PTR(-EPROBE_DEFER);

	pcs = lynx_pcs_create(mdiodev); // if this fails, we miss calling mdio_device_free()
	return pcs;
}

and it's clear that what is obvious to me was not obvious to the author
of commit a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver"), since
this organization scheme didn't work for him.
