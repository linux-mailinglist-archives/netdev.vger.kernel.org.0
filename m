Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6486C7E70
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjCXNHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 09:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCXNHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:07:41 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F492310C;
        Fri, 24 Mar 2023 06:07:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGF8u3SpncgESskw3vAXwn+kcZ7t0piQSng/Ik4eqvV36ss7JmKazKKEYWT/lR1PMIWBAMDYDIYFPWpY1Zue4uCeCC8GTZ5unbmgJgpqWoE6itgyT67q2wOBHlryta/xBxqcGaoOgptIQDzxW3qXtCP9DUGO+T6NiqxKPLQ4eJ0fYCXCpu4OSYv2KhKlb/3SnC9nRy5GyU2XIf1fxlX5Si4VcDkNDZuQcHApebe/0b2hJxKk3uPE79pD/CSFpiSPEwTxzMmc6M0FSKxaPoxUzFOoxpxsogXlMDoSJei9ToIHA1iv2C3eUM4hRu09A37CHQDFXa91kxHd/Hl9+HjK+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gcGhqUWbOHoVi7npOCJwziSs+GvEIJ7LrHmgzHg7vA=;
 b=In4uL6WGwNmDNS9q5W6vqIDwtbI49xzJlx6gg81D7+NMvKWe3zvXa84ZffGM613XgEBofYltE0PQfgHdEpBG+4/xqETgN32/Qc8zxZKKlEYepOgvmXRDazZzO9Y04kI52bOqJzKpHqnJcaEguQCM0v1Gg8yulgaWIfPEErvH1YkkqAvhPXA7zc7R2s22U311TnYdsYJyr1F9/FbwhqCNHl7trJRuEDGmGCekNmWJoHYgci16Vk+PHM+IiiUCy5FB6Og0Fcua6pqpen2J+MqWPrfiTHEZp8vQ4me4Kqz2sF/t1jTIjocIftGklu1vuybyAJQ/UM3JEmedEmpWgvGESw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gcGhqUWbOHoVi7npOCJwziSs+GvEIJ7LrHmgzHg7vA=;
 b=py0UuhGgZmldPKhT+EZhyS86h7ysWO+ccT/nD4gXaKkFdCFlLlb5KOpG02KVwKs3l/lhEHNGHowbllJMlU9V50YsK72Ap9R/QfbX0WodqgFEcNyDdjS+bfSZQ0DOBouVWKi5TFBX77No9Uu1fGkC/kL4TdaUjCCdEMLx20y3Vo4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DBBPR04MB7515.eurprd04.prod.outlook.com (2603:10a6:10:202::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 13:07:32 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd%7]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 13:07:32 +0000
Date:   Fri, 24 Mar 2023 15:07:28 +0200
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Message-ID: <20230324130728.yqxqzny2jwvvslri@LXL00007.wbi.nxp.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
 <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
 <20230323152724.fxcxysfe637bqxzt@LXL00007.wbi.nxp.com>
 <d6900e52-ddd2-9334-3ed0-734b3e4a957a@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6900e52-ddd2-9334-3ed0-734b3e4a957a@seco.com>
X-ClientProxiedBy: VI1PR07CA0270.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::37) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DBBPR04MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dddf42-83e4-4914-9f19-08db2c68ba94
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6O5ooWDLHyv5AM2+CxxQ/3iW8HIUSyosQ9ve7IvUOzzM7fmWrqu6AKGjtHwZSUh7XoGcOYwZ9GitIXuQm6jvUK2and2AEAQZEx2DXNJE4Og8z8QgCvr5+O944kKOiR79076fNssLkPc3fyDY2Kl+js9zcAUDd0JeZJQSW7leKm/THs2nt/ee3WEqCCuLy9oJtm2sAjl7d2NPY4+HKlGfcWijrINgSIB2YImmHObEkcdQPsa62XFaeHZNI01N+/o9loCAAXFneZUuG794gsDRi70cUCrXMUumYewMlQ7GTBiesVxdIqruCyjXetX+GFfiwPxO3Wt/rPxZ40jRAiBLFIkoWQmovlqNWwszCkvgL9mQuX7uEINXyqUib8iPuO4ui+5ajM8QLQcJ+wJdb8ilij1O/zOE3z1jRARy1B9mO7CuLIJJrAoed0bSPJ6jRkrKZKjVp7kTg7TUcrOKqNKIhPMWR9nbn0eWFzhDv4WwKvYZJMsLwBr7j2299HmMI40tgFR8ldpH89HQDqTz+9Xq4EyXiFUxrsgvS47NpRfGO+Fxr/t+hrOUzdZm62LHSCjbs5qcdx1TfISfYbf/rOLjFNDvplOslecUR4PfCczSnF0/D+1E61ixWqBO21B6oLEcLvIHvQY7aG7mhL/ZAJzCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199018)(38100700002)(8936002)(4326008)(6916009)(8676002)(86362001)(41300700001)(66946007)(66476007)(66556008)(54906003)(478600001)(316002)(6486002)(5660300002)(44832011)(2906002)(6666004)(26005)(6506007)(53546011)(6512007)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzlFGfAGQiSLNAN0CkLGLS9VygLd19s+lbtcdeHkY61xpnOkkLLc+SIN/WUJ?=
 =?us-ascii?Q?sYDS94i8ljzeeh1eVZ4i+094vYYsUw1D6pt/GVyOOdomNeo504yCG/dNdj5H?=
 =?us-ascii?Q?WpJUn8KFE7cuAbdOCM4uHn6ZvwPYFy6IEa3Y4oa4XRV59/y18JJ0JmkeyYbj?=
 =?us-ascii?Q?unqGn53jw1P7NfrQTm8Ni9nTxdZLr6Bx9WxWnPMpPZ9nafR7X/nxWfGjl49q?=
 =?us-ascii?Q?UB3HGa6O8HecA/zSK5FKD4Y0ovc7igOHmBS24wN9LzEzZwTAP7rZW8tryAZW?=
 =?us-ascii?Q?GLL0auz2PqgS4OeGkBpzrphG76B56Fv/a+oBBb1lo987XUbtKoDE0FAQE29r?=
 =?us-ascii?Q?WrYnf/KjrVqwQmQFWqrD6SUG0D6WBUWSGWvX5q2hT2FGAtDVWY+30r35qkK4?=
 =?us-ascii?Q?cVGifl+nFAO/ky5SyeNGf/HBKJ0lU/0YphqYvsNLc9RBolMcVE0HQYR5iqXu?=
 =?us-ascii?Q?vl4KiCjk09FWLlDw/ptF2xhvMj4XJm8Jod7vw48nBAMPnwO7g+cUAm2IVT0v?=
 =?us-ascii?Q?PaQkpO6cVPv8bD4wvrzuaQrAyrGFgFVgwPBrWeERwMpmd/NarJinoMYurTBY?=
 =?us-ascii?Q?6eIlWjitbQtyiy7i4hwmOuek4bFd4TpDCCl+exaeuw4bQiJ31I8rwFrBX7wj?=
 =?us-ascii?Q?ZAxMdRWnCGEmp307klzBfgfjnejr3Dn+zesk+vGqpjkZr5uOiG7oyyTBmULz?=
 =?us-ascii?Q?STivh1xY1dqr8mGCie6ii68hkEFu8FaTrdi1A/JUUHaHLrylbcThZZ010MEc?=
 =?us-ascii?Q?tXY+7qaBbDvPa4eeKVf4BA02WyZ9dXXInl4bzSDo8jBWsut3+FcbHZEfpGDn?=
 =?us-ascii?Q?koz6X+MGDiXNPjyqflRCYropgvR/kXS2n1e04SgPuPhnnGSZnH6kMVRWEswV?=
 =?us-ascii?Q?lPEF7XNEeqRM6PP+cLcI1e4AJ+4I9kEcb8T6DDxFf6AITIeFvcuS//sd0PV9?=
 =?us-ascii?Q?cvko0FfXN+tMnASfKNwFFUO7SRJXw7hnI0hD7tjNTOIRoj/lZUuxL3QJ2qQb?=
 =?us-ascii?Q?V3P/ukOqRE58rB/acRtAAT9NVJBbWh/K5ja9kfGpQ8v5+gkhcGlMfCmBi4wm?=
 =?us-ascii?Q?gIUsj7BCSSnj8ffnrmcG6HEDc7GYJhSXFzqCOQK2VD3FTz6yAjAU5d3VmG6X?=
 =?us-ascii?Q?WqekjHPXCOgRwe9n2eMVcbFd/+W132KQV7fDI4s1WWmQmp87WM56AZ1fTt1x?=
 =?us-ascii?Q?ijamHQIEiEw6xelbICqpxz0D6JCgBMXFMsdPEoWff9Wtput1QVHI9dhJwsLx?=
 =?us-ascii?Q?TClMIGM727LM68p+8FCBDGLJfRWUZcODG12gFqUxuM/3Y/eR/KS4M/rXLNj/?=
 =?us-ascii?Q?w1TIgJIWFArZpEi+IhU3eXErzNjC/+2/YeHLa+cOYfhukq2DxkATCjYPfoT6?=
 =?us-ascii?Q?Y1WBN+z6cc6AF47VwVmdFbgKRgJpygKmDNzkN6REhU49rdqpVpj9ctu+OW71?=
 =?us-ascii?Q?RDwdyLqE7eBJgVD1533yR1V4ZrvUpaU5rysM6dljgWh3cp+9TnCbOJYjFhM3?=
 =?us-ascii?Q?94OyMZfAp12UOyd51KKgO6FEEJV6GT/hnGv5Mwf6wsTLdjXKiyC7OjdxLyhX?=
 =?us-ascii?Q?T1VSYh4v7mGz36RZm0E9wV0UNVKoACqiLuXLjPJ8rOihGOz1Gi1FF3YNnYxF?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dddf42-83e4-4914-9f19-08db2c68ba94
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 13:07:32.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMnbOtYktjTvEcH9bOMMMk1oSNPSZECApwaSWgNRT72cH7HHJ3PjxwY+4qPb5i1vSDs/tsGPG/R+HrIuykvXFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7515
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 12:30:34PM -0400, Sean Anderson wrote:
> On 3/23/23 11:27, Ioana Ciornei wrote:
> > On Mon, Mar 06, 2023 at 11:13:17AM -0500, Sean Anderson wrote:
> >> On 3/6/23 03:09, Ioana Ciornei wrote:
> >> > On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
> >> >> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
> >> >> add backplane link mode support"), Ioana Ciornei said [1]:
> >> >> 
> >> >> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
> >> >> > by Linux (since the firmware is not touching these). That being said,
> >> >> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
> >> >> > also have their PCS managed by Linux (no interraction from the
> >> >> > firmware's part with the PCS, just the SerDes).
> >> >> 
> >> >> This implies that Linux only manages the SerDes when the link type is
> >> >> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
> >> >> moving the existing conditions to more appropriate places.
> >> > 
> >> > I am not sure I understand why are you moving the conditions to
> >> > different places. Could you please explain?
> >> 
> >> This is not (just) a movement of conditions, but a changing of what they
> >> apply to.
> >> 
> >> There are two things which this patch changes: whether we manage the phy
> >> and whether we say we support alternate interfaces. According to your
> >> comment above (and roughly in-line with my testing), Linux manages the
> >> phy *exactly* when the link type is BACKPLANE. In all other cases, the
> >> firmware manages the phy. Similarly, alternate interfaces are supported
> >> *exactly* when the firmware supports PROTOCOL_CHANGE. However, currently
> >> the conditions do not match this.
> >> 
> >> > Why not just append the existing condition from dpaa2_mac_connect() with
> >> > "mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?
> >> > 
> >> > This way, the serdes_phy is populated only if all the conditions pass
> >> > and you don't have to scatter them all around the driver.
> >> 
> >> If we have link type BACKPLANE, Linux manages the phy, even if the
> >> firmware doesn't support changing the interface. Therefore, we need to
> >> grab the phy, but not fill in alternate interfaces.
> >> 
> >> This does not scatter the conditions, but instead moves them to exactly
> >> where they are needed. Currently, they are in the wrong places.
> > 
> > Sorry for not making my position clear from the first time which is:
> > there is no point in having a SerDes driver or a reference to the
> > SerDes PHY if the firmware does not actually support changing of
> > interfaces.
> > 
> > Why I think that is because the SerDes is configured at boot time
> > anyway for the interface type defined in the RCW (Reset Configuration
> > Word). If the firmware does not support any protocol change then why
> > trouble the dpaa2-eth driver with anything SerDes related?
> 
> It's actually the other way around. If the firmware is managing the phy,
> why try to probe it? Consider a situation where the firmware supports
> protocol change, but the link type is PHY. Then we will probe the
> serdes, but we may confuse the firmware (or vice versa).

And how is that conflicting with what I said?

Again, I agree that we don't want to manage the SerDes PHY in situations
in which the firmware also does it. And that means adding and extra
check in the driver so that the SerDes PHY is setup only in BACKPLANE
mode.

> 
> > This is why I am ok with only extending the condition from
> > dpaa2_mac_connect() with an additional check but not the exact patch
> > that you sent.
> 
> AIUI the condition there is correct because Linux controls the PCS in
> both PHY and BACKPLANE modes (although the RGMII check is a bit
> strange).
> 

I am not sure if we talk about the same check.
I was referring to this check which has nothing to do with the PCS
(which is why I don't understand why you mentioned it).

	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
	    is_of_node(dpmac_node)) {
		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);

Also, why is the RGMII check strange? RGMII does not use a SerDes PHY.

Ioana


