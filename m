Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18B769BA9C
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 16:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBRPUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 10:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBRPUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 10:20:30 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB7315561;
        Sat, 18 Feb 2023 07:20:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjhPoVxmn0/QLnrj+kJi/1fFksCMOqpnsBuvhLiyKQnYjnB5WshccawZ3DdV7ILsPT2tzwl5XPZ7/8mi0kp3Uo8AFDKQRC4iHlpv9QePqZafn4/s7AZ5I+uXCidiNQ/xPT7JpAl8GswxP7YekclLpZwwQH/kaVUoTukY1OpFiYx0TkiwWsp8fLOACaQvhJFCctQA2KoAI2SbMwks3DUxYnXfoV/qKV7EkQtcA0eaPWVOdYrdi5pzDu7x3UFHhistKZV9c5BK0WYDVY3vZQ4Roh7powDi80yLSO4oubbNfMbMYXc4+ebBkbDD8HLJ3FSGu8AmkD0rIT+nKlTE+w9YYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D63JMOIk46SWoyUU4q1LssnukiB5HAJBYbeEhKrfnmk=;
 b=Eeag83UliUJtfOwGvbqsdAp355dSH2Yvid1SJRf/AtZbvKdVFtY2Ssf//h7rrbzGt0i/lK23wP3HFFpR/G+Fs6mVBeTf4tpTCZhIvNBHuMQ4b3CVP+hLFnk/oxlJwcq6ozzsyJgBHQPTdeFLXFzSrQvt5YowHoL71QOOTl/B0JWc1uCY+K11M2oqQcVlywH3EajoYs39GcbWvbXFwY4qTdQxrQ+6KYo0L3+eJCFXDx+lQOTOmnJaxgnzXqgEjyaiYVFDGfcLKiK8FW5AX+TwzbspX6M7Xq9/RGCjBCk8C5MaldP+zhfW3WwXxFx7yux92dfy5s8kS+O4K0W7wnvDMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D63JMOIk46SWoyUU4q1LssnukiB5HAJBYbeEhKrfnmk=;
 b=kUbj1YT5Ipw8ceIxzbQKeSpQundY21cXLNVFyMSq/aN3Zf1vOn7ubFsG4JQ5iNqOftoLVRAd3MiBf1ng5OFN4PU72IVshJc42MV4RSBTlXwOfse9pqxHUv4QakSWpecq5VF1PoPXyLMF5x9wRvYkFW46f3SyOXZ5N13IFNZvp5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PAXPR04MB8444.eurprd04.prod.outlook.com (2603:10a6:102:1db::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sat, 18 Feb
 2023 15:20:26 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::926f:44b4:bd2a:80ea]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::926f:44b4:bd2a:80ea%4]) with mapi id 15.20.6111.018; Sat, 18 Feb 2023
 15:20:26 +0000
Date:   Sat, 18 Feb 2023 17:20:21 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>
Subject: Re: [PATCH net-next 00/12] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230218152021.puhz7m26uu2lzved@skbuf>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR03CA0044.eurprd03.prod.outlook.com
 (2603:10a6:803:50::15) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PAXPR04MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: eb1b5f2a-ec5b-48e8-441a-08db11c3a954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2pGCmEL0C3luy2vHUCCXi59PkJc01Wmi2gsJyPJbMCWCe7nbY3KG5sZ6iLARWtCv1ai9AYBwZRAW4khO0jmBRtDqKp29KokirUhCZWb9UU2zgKEuE2FPjHh9BVvREQ8rEdehq6Lo431Lelg8ZBtPNsLTU46A8h94fufBH+IPxsOpm7imi4mUhrDkXj2RFfDt+/+w6pswINyzUvsrg7h4Hq1Wd6/pYxpuQ5aOadgLPgGqzzSGQoGEIvCfsUCAImQ4Y8zzXC20eq4fJriqDfef2W9ArTpPhgh0EPaDuz2Xw+hYttbXntqvaHRvQiVGAJCO0G/rc5K/dHe0BzR7Pr2L+9rZw0hzNWJ0e2vPOFeYasBTTubogsATXTPvD/s7S5Z99XLw2odnN2BLc9u6RemZn7DNbtMN6uG4M/Rk8a09gGSztF4sS9tcyxPXRi8MCN1ubCplYogR+WoWBlV7/2X1KJEu8HRjJVvqRd0eo9+P5bbvR2JUOS/Lnh4xeCciC8hyCOdcVZLfJ/ofpHtpWVVwX8qRFAsD0HyOZqJgBBFSZv1Ozc9HZmkWX9V3mvS71wsiI0hXjfRmTsNDrNBvsmnofMuRyw0oMHTA0ZI5826oh56Qp13l8rykSlMyPtVGggehWg2AbSsymBP8W2btkSLDxCV4No5ooVtg6ci1OuCxVgY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199018)(86362001)(33716001)(478600001)(83380400001)(316002)(54906003)(1076003)(6666004)(6512007)(186003)(26005)(9686003)(966005)(6486002)(6506007)(44832011)(7416002)(5660300002)(2906002)(38100700002)(41300700001)(66946007)(66556008)(4326008)(6916009)(66476007)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hsFCxtPvEMDn7QnqPgTYT8ZIMjZYV3X42bUiDlXmQ0eLkHzDNNj4VaLM4LwZ?=
 =?us-ascii?Q?6aIHR6DJvCNfj37WzPTYrM49rtKE66Vt64bh8xwziyLF/tz6nthacKvWlLPk?=
 =?us-ascii?Q?6EdmhIrN6cBR8LOtf0HbB4/Bydmsdw9N5dW8lVogXPpMpuz9+kV2BS+sS0xv?=
 =?us-ascii?Q?jxXsdXe4uyrI1+x0YmpoBN1Qk7EItmy8SekftT0QeXCVN6yF3pDaBIeoVis5?=
 =?us-ascii?Q?9AQvQEYoTRKo2M8nrpFxFGdLcA7KTngcI1UzrJ4mNaIEgcYdPTIA1lsvIfvg?=
 =?us-ascii?Q?QGjX0rl22pHzuUiz1e9Tme+nb1UnfKOUrbu8xBOgzuanz7HmX9cbNMEAhUX+?=
 =?us-ascii?Q?ndRELdMgPExQvsoMrHSnXSDMaIr795/VrekeO0tOU+oviWMoRFz9HcDP4r51?=
 =?us-ascii?Q?KmBYwM16bA7ch28gWehgD22HpZ0KY8Jhe1i8vhUqHmr7OxvETR8GhdE3Cf6I?=
 =?us-ascii?Q?LSAop0q5SJ63BXQ1wy5MFIpfZlTIvGMS0lpgmjNxlbbe4I62Jd4Qo2p0cyso?=
 =?us-ascii?Q?WEh7/HMVgYCWfo6qY9TxkwLBRL90VqUwmNOJcUp/u3t1XRfwTzR4Pioeucuj?=
 =?us-ascii?Q?sUtoozymenDHGhm2kTznGccfoPZRZXH3rxpHeGpCmikbPxyUR1AWU7XBG5j4?=
 =?us-ascii?Q?2wkoDZhyg5jOsthascDBZXs8NkxnnQbz/okOzNrEnAY35ygu8bDnTjOTLDkt?=
 =?us-ascii?Q?gyC0sz+ayJAkm2HQ0LVa+xoHVRU7lqxXjbUduIxsQMwTAJsWdGNWow9Qwd77?=
 =?us-ascii?Q?Iodr6LJxqvBZHHok61vXcn/h1Xs9bH1zoYoyntpugUiYnEDagWBhEEsKisDo?=
 =?us-ascii?Q?9EWmrtwqQE3Kil2B0ZJSWc18Q0YXvGyABzhrXQniYdcmMlrJJwr1VoLoI5di?=
 =?us-ascii?Q?AIfzaes4VXj5zQaZm9mdtdGO4XmYUahR5KK0qPvr9larW2pB9KdGTqR+NP5G?=
 =?us-ascii?Q?UXEaod3dvfcKptadtGBtArbeb4MqiwuBYFYsocb5CEQsIUg1MzD6uzPb9g4B?=
 =?us-ascii?Q?XZPLOzdOP6vgi9y+JmaANTbdMdAsNM6Hr85DtbTDMcGBV0JIzgfaaWOm2VRj?=
 =?us-ascii?Q?rtq/15K/nq880KQCmc+BM+5B2V58z4gAM/I2TmLiS2P9q7nJqfW3jnbJL9ie?=
 =?us-ascii?Q?K00hOTbI/fZGFX1M0AAf6b1bIzPJQ7GSz6+9guACiWNv2TOOXWAHxBg/lGC6?=
 =?us-ascii?Q?tZOQcW6+AL2v1IWyjFOxV/WnEc5xZw+sxHGo3iLWrSfooppXKD0HlMmgsXgW?=
 =?us-ascii?Q?eeRFOqc4GJWtDEJtDM/BT5Ga4z3o31CmNpX8yj092+E+rr+p4YKMYiJDL5Bh?=
 =?us-ascii?Q?YCPzzLaxb9nHIkm/JGnhMS+/tXRhBBIj3HdJUwFtHc2KtCh6icahJofJ6g9U?=
 =?us-ascii?Q?ejpDlE8k3wckrGSxPwTJC/KZ/k03TOQtGI0E+vpWVSJE7MbLpDP7Iv+a4zNZ?=
 =?us-ascii?Q?srUdIVxbhN+K6e45DK8GZ7yaC9aQ8X3tkiF/RiA6QpchtamCzTDbY+3tEuhe?=
 =?us-ascii?Q?/5lrKJtWPBZIBFNxEXlDc3CyVRRLeyiWyKfi36tydFHaLWD7iiThIN+EmzlJ?=
 =?us-ascii?Q?wDe5EYaB5KQvEDFnLnbyxjCM9WMI5CNHJO7m5oOEceGVhj3BlS0hR/6nf9he?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1b5f2a-ec5b-48e8-441a-08db11c3a954
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2023 15:20:26.2723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1ram4op6p+PNDYek9iBhp3t7YtqJY+Q9G6V2fZ1I86UUgfoFMt7vKDhM06k+La+U0TPxgtzvOtiQV7fRXWVVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8444
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:21:14AM +0200, Vladimir Oltean wrote:
> The last RFC in August 2022 contained a proposal for the UAPI of both
> TSN standards which together form Frame Preemption (802.1Q and 802.3):
> https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/
> 
> It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
> should be exposed via the tc qdisc (mqprio, taprio) or via some other
> layer (perhaps also ethtool like the 802.3 portion).
> 
> So the 802.3 portion got submitted separately and finally was accepted:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230119122705.73054-1-vladimir.oltean@nxp.com/
> 
> leaving the only remaining question: how do we expose the 802.1Q bits?
> 
> This series proposes that we use the Qdisc layer, through separate
> (albeit very similar) UAPI in mqprio and taprio, and that both these
> Qdiscs pass the information down to the offloading device driver through
> the common mqprio offload structure (which taprio also passes).
> 
> Implementations are provided for the NXP LS1028A on-board Ethernet
> (enetc, felix).
> 
> Some patches should have maybe belonged to separate series, leaving here
> only patches 09/12 - 12/12, for ease of review. That may be true,
> however due to a perceived lack of time to wait for the prerequisite
> cleanup to be merged, here they are all together.
> 
> Vladimir Oltean (12):
>   net: enetc: rename "mqprio" to "qopt"
>   net: mscc: ocelot: add support for mqprio offload
>   net: dsa: felix: act upon the mqprio qopt in taprio offload
>   net: ethtool: fix __ethtool_dev_mm_supported() implementation
>   net: ethtool: create and export ethtool_dev_mm_supported()
>   net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
>   net/sched: mqprio: add extack to mqprio_parse_nlattr()
>   net/sched: mqprio: add an extack message to mqprio_parse_opt()
>   net/sched: mqprio: allow per-TC user input of FP adminStatus
>   net/sched: taprio: allow per-TC user input of FP adminStatus
>   net: mscc: ocelot: add support for preemptible traffic classes
>   net: enetc: add support for preemptible traffic classes
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |  44 ++++-
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
>  .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
>  drivers/net/ethernet/mscc/ocelot.c            |  51 +++++
>  drivers/net/ethernet/mscc/ocelot.h            |   2 +
>  drivers/net/ethernet/mscc/ocelot_mm.c         |  56 ++++++
>  include/linux/ethtool_netlink.h               |   6 +
>  include/net/pkt_sched.h                       |   1 +
>  include/soc/mscc/ocelot.h                     |   6 +
>  include/uapi/linux/pkt_sched.h                |  17 ++
>  net/ethtool/mm.c                              |  24 ++-
>  net/sched/sch_mqprio.c                        | 182 +++++++++++++++---
>  net/sched/sch_mqprio_lib.c                    |  14 ++
>  net/sched/sch_mqprio_lib.h                    |   2 +
>  net/sched/sch_taprio.c                        |  65 +++++--
>  16 files changed, 459 insertions(+), 47 deletions(-)
> 
> -- 
> 2.34.1
>

Seeing that there is no feedback on the proposed UAPI, I'd be tempted
to resend this, with just the modular build fixed (export the
ethtool_dev_mm_supported() symbol).

Would anyone hate me for doing this, considering that the merge window
is close? Does anyone need some time to take a closer look at this, or
think about a better alternative?
