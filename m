Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE666C6D1A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjCWQPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjCWQOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:14:42 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2135.outbound.protection.outlook.com [40.107.102.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43278305C0;
        Thu, 23 Mar 2023 09:14:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd9JDjZBVVCcP3WeN9oH3zp63E/U53qIYRMXyzDJIhLyehPzaYDW06kuQ5OQatZLZU+XRiNpvaUeWd2460SOqc8+8H9k2SLxVB4MqchEcB1Edex4WcMV3EVbiKeDWA4xvP904x3KOS2epYSj2QCZbofM4tV+T1XYfhkB4Muyvazi0fBR1fCirlJqHLDgOgXZK+iHCrAfV/827ORWPIX7J+5nj9vFco/Hzz/Pqe/3ERxKZn2uy6ytaWMK1cbaAS9c6J8U46kUW6Ee1Qsca4dSI1riFII6vJYlGrCA8WjcsokAB0wcgy4aEF0Omv00LN/89CWJLILNH+2LEOgj6Zkjew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vM4h2Vwnn6zRfRj6VN6YDqZh/eGhlP0Spy2dCaTjaJc=;
 b=eqE3rbmnR5sdQ/R3Hik2N41YzRZMhXVz56He+A6Un/u1JrmmnKhLd7dHSEWIcsaYasRIWQDk5MtFKRjlsVsRspP8KxxNhbdcf5JyZ27/GE8z+Ps8PSBIPP4ADTMJpq1/awq+eSwPVKlx1gdu1P6wN9t5lCjmSgU92h52GXGrryP5j7iRQ5RG3uK21juXn2Ws7B7RUDHuobbFz6oqE8nX4xpIWtF+woq+nIlIvlgqoElsWT+73gQZZy0AFs2ZFvcM30mz5+7NYgBiwTn0rIR204iP8IFRU6Vg2ECLoEcGXwLaaOof5unlcyApLh0+4VCCO+DGhmWdGY/umrPqsCgViA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vM4h2Vwnn6zRfRj6VN6YDqZh/eGhlP0Spy2dCaTjaJc=;
 b=wBEWZuWTUKYaoUrI61N035gAW7Tb1hVSjiLtwEUTCe35V1BYxD7kQjySZu/3mcSLAoism+5shezuLWqJZyp6SzZHdeDngJrZiImX1dW7bRGmQv8lr71rx3knWbxiG79ZOMnx3aKG5QzzS5YcJstFlkhXZPtzSGMW3IfPJBPlpTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6189.namprd13.prod.outlook.com (2603:10b6:a03:523::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 16:14:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:14:29 +0000
Date:   Thu, 23 Mar 2023 17:14:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 9/9] net: dsa: tag_ocelot: call only the
 relevant portion of __skb_vlan_pop() on TX
Message-ID: <ZBx63wbdoXnLlGMK@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-10-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM8P189CA0014.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d1d4ad-48f3-4a96-fa8e-08db2bb9add5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9vUfTtc3mH4yucVAe2/yO9lbWab5TFEPm00Z+wSRR7Zeh2pSTpcXLI06LJnbEzyzAY27eF/jnMAKcWhw1NAF8tFcivebGMuzH+B+8doAyPH6nMrhA5NGLbB/YpVQaqLDuNjBmy06ZnTwNKbozkZxKai2oQ93DCVsJqGBzyeUekwjqaHOtY99aDi/VRteeXi3vekgMbCK458M0dwhStb+eovLS0eNrM9htY+06ZBmoZoK9Q2LTRe6J4rHMcOguSliFs62WEEJ1M9PPc+MZJsBvAgyBNrMv42mauYr1v27+s99+agWIroCz1XDHqwOlSQlwPPdHTrjkAM1CGSA6qvUfi/WBzU+MFi5xvqXTH8Rp1+hbFCmNy3y6oapzgi7FbqWRn5zPPrlSZ7qcY6+DDKJScYfymcCWfbGOg8JfoTLLz23jdmjQrL1GDvyHkXpJzLLEnVe8od3SLh/W3g4kAxtPG71VYu6NUZV7WNX2kHNyyDPZtQ9PAUoi0XhkeKkYPwnhAQ8kYEVl3rY96uu7M/a3CW8G/SatJE05XlG8uulgOTekbSuEpD7YHwDYfnOImTxrCsWMbALZ925MMcYaepQAoYP+odtcLjcPy7Qv6N8DUMkRZddgrRR2/oKa0U2xP8RiJ1+TRR0cIHwCyEy0t4qkU4cXFuA1bOxIPbrmyNoM6dpI0Zz+Q5qhLmQUn3Ixez
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(136003)(376002)(39840400004)(451199018)(5660300002)(8936002)(316002)(86362001)(66556008)(66946007)(66476007)(4326008)(8676002)(6916009)(54906003)(41300700001)(478600001)(2906002)(6486002)(44832011)(6666004)(6506007)(6512007)(38100700002)(186003)(2616005)(83380400001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qfyCizwuGD8hkEt4k+K4OYlxNyxyz9GXgJHtP4r3lDO127M7RgnJWoDDYPgE?=
 =?us-ascii?Q?E+tkajwpR7OdSA2ox780VytZMzzsWuOhLCavOo+U9DveeKYhSF4h/8Ro124M?=
 =?us-ascii?Q?sn2CX3Lz1T0H5wlv1VJfLkQqxDAL6zGUbkikLZoNODeW6Gk17pamaYcj+309?=
 =?us-ascii?Q?HkWImEQ9oLQRFTgRLKS1JFkhI2Uvb0SGyIBXmmHRInkK6TGTMVY7JK2sZmPk?=
 =?us-ascii?Q?nInP4sL1Ednnbr7vi/lHZoMjwLigjdNyRozpX8eeZ1xwevEwOmJINF68/qgr?=
 =?us-ascii?Q?XtulC16LIPas5d5S/0vQrhyn/ZKkXUC1/CYdHMWCKwLR9lkorWwaSeau1jUX?=
 =?us-ascii?Q?fFatwt3wOuCo2z3NTeNDnbLCXUX+czDevGvhv6F7MioP6co1hAlQWlCVZRDD?=
 =?us-ascii?Q?bTU5sfLb5wAZfJIS9oWl3VuGFxqbc5CtH9falb/uYV7ZFWZaPTqr02q4DA2C?=
 =?us-ascii?Q?l4l3nFZvp5I+tfU124Wa2vCXey42LrdRZ+pYkNKdppOUPtD/XEOfvMUEuOte?=
 =?us-ascii?Q?sf2kiAMwOdMyLOQpVWpEqe9ZwqfgzX2Wl0oeFFQMriFTouhP4HrGg0PYkFps?=
 =?us-ascii?Q?LhE97jaBCL74yxI++LGE4R13CB20Q+W9hvZn7Db7lW/U3nPnyIlnW2lTN8RH?=
 =?us-ascii?Q?+g75AfjglTgYzxlRgB+Xvj5Xws6lWos16iXBBvEeBeF+ePWDqK22XPH5C40v?=
 =?us-ascii?Q?CZhuDtci+0z3VXLCJN+0+eoptuIpSiX0/QvPm5npuENUCOJ5HUNKNbyYXAwP?=
 =?us-ascii?Q?9PLbmiMZQmq7o1MPDN2QBb7aywXO7xnedhjG7CSn385dPsYU8sCfncghWVeY?=
 =?us-ascii?Q?pByNb+8RSW8ICmg/dtqBsjZTUnK625Lgvv8xrQquATK2+DKQ3cir+0dCK9TQ?=
 =?us-ascii?Q?w/ctVkyyKSY9mgSawn2o8aa7ZbyJ7FCfxVY39S6uvoZL7Dcv0iCJSsRehpna?=
 =?us-ascii?Q?NcsKoHZT4ePEgpvcsJ4oNS7H1/Ecew1I5jhyDBq7+ptEpYuz+FEDPXGCSKWX?=
 =?us-ascii?Q?ccN7j8A7tl0iwvGEtasBykBN0zxdG7dDkRZDKii/QWugXSKBqqpHLhlWVR/U?=
 =?us-ascii?Q?jESFW1RZMIr7HdugrmK8ysRDs4Ikneaf9bu09sRiGZBfl8Qvh61y1uENlnxe?=
 =?us-ascii?Q?DKLRYhmznldO+qjRUgyZV1oxQBScVP818TVmPKaBAAo70bV/7MgkVV/tEMRG?=
 =?us-ascii?Q?XyUkfXvvIvbQWQ+9VVssI3FkEalmul6hWUuezKYz93PDeLapm5+34Ai/eF0E?=
 =?us-ascii?Q?04n8DzI4kaquxo8mQzcs4uXztWk02DJuZWjuIgXdWAKFzipLrZ6pAnS3jzDC?=
 =?us-ascii?Q?COUoqdF+4on+Mc+1eZ9i0493PHZ9GlWdd7jrNNx0rwjayNmEy/oj9Lo4zsUM?=
 =?us-ascii?Q?V6dlRAjmQxxY3sYlw7XPY1EOGDf6RrNVQgfzg/UPViWJqTs/rG0VV209bEuW?=
 =?us-ascii?Q?uDqWMeZbR7YBQlhIXtm+C2m1O/0962ahihl+sinI7/LF/hZxDpOb/bXbI4b0?=
 =?us-ascii?Q?BQWWbwZl8HLo095oscXApRwGW3OM0OuGKOHFyA9rAES9/yVEdsJmQIttwR2P?=
 =?us-ascii?Q?cjiS62AimOz9BGdPC6PkmsZod24HkiRdzo+ha6zp895mZHE0tuTf309/PSwl?=
 =?us-ascii?Q?eTX3XDcOuJa8nvUuzGTJEICcOHn9S0933F9HfgrMXm4+ntsc6eEjAKGOEi5l?=
 =?us-ascii?Q?MGM+Mg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d1d4ad-48f3-4a96-fa8e-08db2bb9add5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:14:29.0670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7AzgxMyxC3mjfrSwsTBPI411FqFFFOLz1/iPBV1aUns24qPYNqbrulyJSjz75Vy7f/q4RS6inlirGn8mfBcSYWgv2RjQgbV8lgIA4lXkSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6189
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:23AM +0200, Vladimir Oltean wrote:
> ocelot_xmit_get_vlan_info() calls __skb_vlan_pop() as the most
> appropriate helper I could find which strips away a VLAN header.
> That's all I need it to do, but __skb_vlan_pop() has more logic, which
> will become incompatible with the future revert of commit 6d1ccff62780
> ("net: reset mac header in dev_start_xmit()").
> 
> Namely, it performs a sanity check on skb_mac_header(), which will stop
> being set after the above revert, so it will return an error instead of
> removing the VLAN tag.
> 
> ocelot_xmit_get_vlan_info() gets called in 2 circumstances:
> 
> (1) the port is under a VLAN-aware bridge and the bridge sends
>     VLAN-tagged packets
> 
> (2) the port is under a VLAN-aware bridge and somebody else (an 8021q
>     upper) sends VLAN-tagged packets (using a VID that isn't in the
>     bridge vlan tables)
> 
> In case (1), there is actually no bug to defend against, because
> br_dev_xmit() calls skb_reset_mac_header() and things continue to work.
> 
> However, in case (2), illustrated using the commands below, it can be
> seen that our intervention is needed, since __skb_vlan_pop() complains:
> 
> $ ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
> $ ip link set $eth master br0 && ip link set $eth up
> $ ip link add link $eth name $eth.100 type vlan id 100 && ip link set $eth.100 up
> $ ip addr add 192.168.100.1/24 dev $eth.100
> $ # needed to work around an apparent DSA RX filtering bug
> $ ip link set $eth promisc on
> 
> I could fend off the checks in __skb_vlan_pop() with some
> skb_mac_header_was_set() calls, but seeing how few callers of
> __skb_vlan_pop() there are from TX paths, that seems rather
> unproductive.
> 
> As an alternative solution, extract the bare minimum logic to strip a
> VLAN header, and move it to a new helper named vlan_remove_tag(), close
> to the definition of vlan_insert_tag(). Document it appropriately and
> make ocelot_xmit_get_vlan_info() call this smaller helper instead.
> 
> Seeing that it doesn't appear illegal to test skb->protocol in the TX
> path, I guess it would be a good for vlan_remove_tag() to also absorb
> the vlan_set_encap_proto() function call.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

