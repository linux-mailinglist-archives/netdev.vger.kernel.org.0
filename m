Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12C26B3DF5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjCJLft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjCJLfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:35:45 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2072.outbound.protection.outlook.com [40.107.14.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7735C12CED;
        Fri, 10 Mar 2023 03:35:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzpWjwL+Z7rFnu28G4KzkhXpWIFu1JaNWFjeOZiKQxIOK/J8QtxWmAKo6qjIjxYrVLy+l1r/+sLSjgj3ro0NcoYUUvBfvz34oULG8nMevVHWmVotXKJYOMAhT1zw1+LWQS8WdWDi357WpUySqVXTZU1lqpAXqXV6T8ELczI+kR+jkuRzaTE2UpAKVl2zboA2BJS9ry8Msz2k2MPEgdcqQpQNSgBhsAdyr1nTCc861FjrSd9FM6jCDnFBuvrzeIfEA4k19h5Bv0+FRFknzizI3JDdOm8cXhZjUDMhBRNg4mDFth6siyHW+OyHNq0Z4U4W3O7lrnR/c+9ZRxi03xpXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gXr3YckMp+M5F1IEEQYLeHYc7nAzsU367XhVD3Cxso=;
 b=HM6omhrjpzTKmtK20yp7ZjwOS43dVtZEEoKUgldm2Vn8NbtfF5jNWszqhFjgkXyWz06AE8cWv0BFXkt3DryO7zatb1wLt3oHpIeqpYuGUEcl0wxiAGCBARwAJeFnTkrYTtWlTb2U3zwpXZKiRsrIIPwaaWMYheJiYMVyMhfMlsuvB1F9YIDhQDd81QA+dvhycEy8IWRbtehq0DTpBqrVZ2AXcdjdgpqYUAfUfgANSsjJF7lXfaUJ9qOZ2GygUn6KsF2aCWEVNTDF3+1bfPavpYXn1Icy/V5z9TD7iDAqfpvYF9F2kis/Vz4CTATPJu2PUWZtkdv2V9TBqnnSeDFTdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gXr3YckMp+M5F1IEEQYLeHYc7nAzsU367XhVD3Cxso=;
 b=RgsJvtXn/7AaZ1g6xgPFrgFuFUxfHNK9Gi48Zlerf2s02to+drSZIJ9QSJX3xOtbT3a5w0nztyI4lm7KgV0rhBtISnYAJqKd+QU7qUZg7OTzKMEdnOnblEXnYEM7rbf9GZZpKcU3+KEvsOPrDBZ+QQRLYjH6tOSugKg7Bq45f9o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB9836.eurprd04.prod.outlook.com (2603:10a6:800:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Fri, 10 Mar
 2023 11:35:38 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 11:35:38 +0000
Date:   Fri, 10 Mar 2023 13:35:33 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <20230310113533.l7flaoli7y3bmlnr@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310114852.3cef643d@kmaincent-XPS-13-7390>
X-ClientProxiedBy: FR3P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB9836:EE_
X-MS-Office365-Filtering-Correlation-Id: ab58a907-2c95-4034-d975-08db215b9231
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXZbHg4p3boiRG9jz9bOQTS2H3qvF58s7gZA6l0pedoOqO5sZ8XXTZKQIlZHESAgcXLBa+jpJwvkMPd89sJW1oTeRiaFOAR6el6/6o0+K5zTMI2sjFsdG90+g5VD5dqqd5DDWkHuDeMHYCG7HjPeycgXFKA8wUyz7cYXLZF74orBaSypDuZGfD7EpUeuWiqGZgeuPzbLZmfU3iT5Jy1hWJstt2bXIv8u5mQXRrpkuHSAQaVTTIUqIY8p12UEvK/US/evGNnCD9JeKOtgWieMfO4ce4Z5kJplWeZpV00bRMWPjpmYj77ERf+dfDEx8IwIi0BhuYhcdQQtYIlCU3HIdG8pNhJLbI5L2/mM9TCfKYRiRoeZjSolUiGLrAi1WCFyFnydwtbQN3Px6eQ6d/oUzyDoYxkgAIZ3Nbr4IDcVVp+cydciQ83Bk/ffxp26sMaxENq2IY4EVC4jYvSkoZU9yvwZKQ+ns6L2nqHchz9ExNzGhw6flD66m5jsB7RhhMHJ4Tn6x0eNM3WEjEOCTD8Dud30mIxgA0RE541H/Xde1ZzYZKLBVnYH6FMsjsyKYfsgVKnGskdkEBu2xsEl+GRiS+eEldQP4wGBa6GHXfGgsfLFwg4pVN3ZtiD6WJ53i0R0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199018)(2906002)(83380400001)(7416002)(8936002)(5660300002)(7406005)(44832011)(41300700001)(8676002)(478600001)(38100700002)(66946007)(4326008)(6916009)(54906003)(86362001)(316002)(66556008)(186003)(9686003)(6512007)(66574015)(66476007)(33716001)(6666004)(1076003)(6506007)(26005)(6486002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?7QKKIVyZIhrjNLlTciGVWvpcLdAe5Bz1cOSBs168KBTuhP6eKlFW0B44Gk?=
 =?iso-8859-1?Q?okuUuJqtjw2czP10UB8AXSuPs6i3zu5PlF6ok+0AiLBkTE6SZ2FXLyRBQT?=
 =?iso-8859-1?Q?3rdcXBy/guQPEU7cI6vsMjWDrSSUG8ydi3C5GmI6UU4BwCE1ciXzQ9pEC0?=
 =?iso-8859-1?Q?n162knWHlQ5i4CAXXsZFrn1ucHluvGF6cA4ji6Mw0pKtNhuDVRcODfQHx6?=
 =?iso-8859-1?Q?qg+Jb3FYwA4TxAoTNS/IvTr1tCzMD3spy8jiuaGY0gEcFQkuXNj4k3FkV5?=
 =?iso-8859-1?Q?5RZup6V9PRk6GQMdOntWG7UDEACoiPVV43lPI/8IWAdwIwRacbQXk29nKE?=
 =?iso-8859-1?Q?pWUMEAlRyOD5HCfxQucZASzmtCw/4JpTp5+ncmlaMa2mVeBq2FFPgGUv2+?=
 =?iso-8859-1?Q?Um3JwrWjCyT2+3OgFDaOwk31I8pRl1WSubkzmIYZqBYHJmj6ATJ9yoKqwh?=
 =?iso-8859-1?Q?cFwMe69u43LEQHqeii9N3q66Z6ab+5qQto716QVTgJeHneXNXXQ12feDkr?=
 =?iso-8859-1?Q?2B79+EGhw3GlK6qbbuRmLIg7mow5FIbSxHBS66TRbZgsHreYNmXm0y7qUF?=
 =?iso-8859-1?Q?7K/lRDVlS94TYYKZwD5wpmLog8z51raZVucc0x+aegcXjsDQzowiasfs3B?=
 =?iso-8859-1?Q?qVeWHfPrtCfQqE6sIrBHELNI1hBYHouZ6O2eUMxdfHWcUVBnw6io08FXjt?=
 =?iso-8859-1?Q?vHzlLGyFEcIThSRgPOIbz+/sIMgJPomGY9tr/58q5uOj1jQz/VpqKPafBK?=
 =?iso-8859-1?Q?QRDdqoENr/tsAf6CUHjmdN8R5ZETHSTZuPTdCO5vjgPHva/BFHH/dS4XFd?=
 =?iso-8859-1?Q?obc+stqr6N5SyQJ8kZogqT33lA03rtf8Lal/SjPJA88JEZvzvy9PPtxQEz?=
 =?iso-8859-1?Q?Ch1fszL9ftofDGDvbuMWz1rS2juHBFaOm3WtOgalU5FwbWCtyBd9KQivTO?=
 =?iso-8859-1?Q?2pnPCyc51GSNqyQ2VUwSEirGALzRN0i3VN7xwOc9vHuCtvEE8F8MuN8byb?=
 =?iso-8859-1?Q?UMZa4WNQ80W8sTavf/JU9VbWNdgQxL4D8DytsX3VRdcWPBar4hgYrBG2+h?=
 =?iso-8859-1?Q?Hw1+txg79k4QuAofxQRSCFzfQ9zUq0V5g26E0k0EUDbfANDimRcfKKC4rS?=
 =?iso-8859-1?Q?HrRU+gtZpYT0NkSp1FNN/XcJa9hbxEUxm+dn5X+gT+UhZT6u5IKuucNALL?=
 =?iso-8859-1?Q?YUcf7LIelag3yvX3tsZEub+nluF6iIQtMpRqmOsss/1UebeIrWDjhiDuX+?=
 =?iso-8859-1?Q?kb1BtZ/MHYp4tn+0f4oydim3W43iTdVtFwROR1RxBXcU0+768BxLNogGX7?=
 =?iso-8859-1?Q?HsmzEQa0k2J+yNeFRPlZpMcDShrO3/HPhRRMHQBBLIZsS+VdRgb4/LyjcE?=
 =?iso-8859-1?Q?14qzGj8k2JNMFrxsQOp72O+JojqH3pVytS/vTgDMxp5ZsD7cXOrfw7AhOc?=
 =?iso-8859-1?Q?tVNEzd76dQAYlu31afntMt7PkLQJbJK4xmp8M5ccYF4FwBQTGNuu8t0ZQF?=
 =?iso-8859-1?Q?oqam6M4REkLE5y3Rs0EzzwYOLS26zQsBxEQmDPgGecJ14XY3bo5yOAXysp?=
 =?iso-8859-1?Q?RR9HQekJp/xK52peOACY5chPEAxDYrwHDuamsdgmSuI7bSHVLLKz9TaXlL?=
 =?iso-8859-1?Q?Ygg75lxRKw1vIjmsOrL0meh36hCZp6SU0OBGduGp25IHLeW9VBDqPiMg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab58a907-2c95-4034-d975-08db215b9231
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 11:35:38.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8E/oNjPTqCzh68x/4wa4GffZTu1oz2eGhnBpZYgmhAGaOU3g3ebB+5ccYQGOEyivPvpVH6xIjmvmxz66HKl2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9836
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:48:52AM +0100, Köry Maincent wrote:
> > From previous discussions, I believe that a device tree property was
> > added in order to prevent perceived performance regressions when
> > timestamping support is added to a PHY driver, correct?
> 
> Yes, i.e. to select the default and better timestamp on a board.

Is there a way to unambiguously determine the "better" timestamping on a board?

Is it plausible that over time, when PTP timestamping matures and,
for example, MDIO devices get support for PTP_SYS_OFFSET_EXTENDED
(an attempt was here: https://lkml.org/lkml/2019/8/16/638), the
relationship between PTP clock qualities changes, and so does the
preference change?

> > I have a dumb question: if updating the device trees is needed in order
> > to prevent these behavior changes, then how is the regression problem
> > addressed for those device trees which don't contain this new property
> > (all device trees)?
> 
> On that case there is not really solution,

If it's not really a solution, then doesn't this fail at its primary
purpose of preventing regressions?

> but be aware that CONFIG_PHY_TIMESTAMPING need to be activated to
> allow timestamping on the PHY. Currently in mainline only few (3)
> defconfig have it enabled so it is really not spread,

Do distribution kernels use the defconfigs from the kernel, or do they
just enable as many options that sound good as possible?

> maybe I could add more documentation to prevent further regression
> issue when adding support of timestamp to a PHY driver.

My opinion is that either the problem was not correctly identified,
or the proposed solution does not address that problem.

What I believe is the problem is that adding support for PHY timestamping
to a PHY driver will cause a behavior change for existing systems which
are deployed with that PHY.

If I had a multi-port NIC where all ports share the same PHC, I would
want to create a boundary clock with it. I can do that just fine when
using MAC timestamping. But assume someone adds support for PHY
timestamping and the kernel switches to using PHY timestamps by default.
Now I need to keep in sync the PHCs of the PHYs, something which was
implicit before (all ports shared the same PHC). I have done nothing
incorrectly, yet my deployment doesn't work anymore. This is just an
example. It doesn't sound like a good idea in general for new features
to cause a behavior change by default.

Having identified that as the problem, I guess the solution should be
to stop doing that (and even though a PHY driver supports timestamping,
keep using the MAC timestamping by default).

There is a slight inconvenience caused by the fact that there are
already PHY drivers using PHY timestamping, and those may have been
introduced into deployments with PHY timestamping. We cannot change the
default behavior for those either. There are 5 such PHY drivers today
(I've grepped for mii_timestamper in drivers/net/phy).

I would suggest that the kernel implements a short whitelist of 5
entries containing PHY driver names, which are compared against
netdev->phydev->drv->name (with the appropriate NULL pointer checks).
Matches will default to PHY timestamping. Otherwise, the new default
will be to keep the behavior as if PHY timestamping doesn't exist
(MAC still provides the timestamps), and the user needs to select the
PHY as the timestamping source explicitly.

Thoughts?
