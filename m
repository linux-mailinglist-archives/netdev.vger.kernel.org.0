Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF8468EDCD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjBHLVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjBHLV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:21:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF61AD29;
        Wed,  8 Feb 2023 03:20:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hzu+h/g/uEiGIiP0EjaA7uP3PfpIfYB+OY1P3b6uctqkNB/tq1bMnt0KIjAZ1tlrBDJesvaGCqgiIabxYyaPRQxlPRdyZGVaaAN43RMNyN3U5EIoecBQgY/sRnxQMOABmum3L1Da9Ka1ZjBJ4EiUYQsbKhU1faeDbI6UaxudD/slR3fO2CnZ00MGqLHnFdg5wtqy1/F1sNI/bUR2g4vxEQ4TISqadHQ3aS7yrrORw4mR1svWYzlVeCMv/GxHxsNGMJ8atf9T9ct/UyeQrGLO/lo3I3uSk3tpm3DOyqlF0gPKuwwvgS7KO7P6HUTum90x3hRoirmtw47lxNZvpxAadA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xs8dKtXkedy9pRV3TEHFVIf/uAMVkJs0xn8xc0F5iu4=;
 b=dvO1Tx70QR8y65eeLTz90SVCzg6/GBpLlhKG65vWe9QdvzTUZ3AdKyl1u5rr28qqReXQjuulhQZKO5Jvi1RDnSq9al+JQdhx3KnqxbcZuTtFMLwfeXlowhQ1NqEXPZBQLtLrUxjg9hODsLmZxLDSy+zas+64o1NHFsJKhHaTT7IAP34BZ3I6HG02oT63lwNpiGMkrk+EzZqG9QhkIHSrN2aZaNgiKx5fUe1UAy0E0vp9xjedNsDsanLp0vTjbwFRQgSQwHcJQJGyWk/smac3eC7HDVejrocB/P40rH5X/BPP9qiGoCd60Q03rEmJwecCBo9kSkKphipaWfFhFptdDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs8dKtXkedy9pRV3TEHFVIf/uAMVkJs0xn8xc0F5iu4=;
 b=Wc/mbJhyNRQUS7MRIP/G5j43O74tivi3T0pg7P9L5R/LBsG6No/88tiD+Ao0L0Nsg9WKqn4KhLwLjEeiE4CNnUJsg1ryOrMUfLcr+2T7S0roItyljrQxczKbLxjhS0StGBZ7MzskF5OzEjLD/1ZK/mmylXWGO/ogmiRDWZHjuKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4772.namprd13.prod.outlook.com (2603:10b6:a03:36b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 11:20:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:20:22 +0000
Date:   Wed, 8 Feb 2023 12:20:15 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>
Subject: Re: [PATCH net] net: mscc: ocelot: fix all IPv6 getting trapped to
 CPU when PTP timestamping is used
Message-ID: <Y+OFbz7iZ/8wEIZq@corigine.com>
References: <20230207183117.1745754-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207183117.1745754-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4772:EE_
X-MS-Office365-Filtering-Correlation-Id: a52ae91e-b1ab-4254-df85-08db09c67808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhTG4HWa9UakRReMYOfnCTVgNgoAtjTX8F6TFPa5VqgJgqDGzJJEsq1fhEZTZNYdJX8I0slxzxOD2wbu6/YkWmFtpXmN3ayM2pf/0jAtFjEzHOrovoHBi+W+iTH+/0sjrRpQs41mOq97I00hn3QbdFkrVhoHfN+UGWM5W8zNgToWRvF+uZmV7R7EnJmPMKZ8a6br46fEZKiOsCPlOiWkRncb7Mee2QNuZufatFwFtmpfJSfF/y8mVUegsHLzOIYCL3np1uOKcbxB5JVWVnQ+sLzN5K7hAItoEh0xS73g/xOmsu4SuKMpi9c7j3XFneTLKci92m7Ddy/VTZ7IIWiItEhGUIsRafHiJJ2MYxe7iwrr5Rovdn+ugdOlB+Rq/PRPylzBFdEUg4SWDRruewmxGj81+FpaD0NejyJ20QsESHz/EaImCkElC0SAK9ZepMFbU5VL+HlofWJaAVlPuz72cZh0PV2I6sM1OIWevO3vTOnp+ynSqjC5dVrEe9G8TX+xh81mSa3po+shqXfy4jC/6iZQcTNsQg+PuQFjUUXiORzyHubzYARckrSSwUXHWY5viT7OAU8eXMybCM6/nv5cVNvYsp27HIKoUN9cVnNBuKNC+RAKmU4rneG5B+szzla37GgF+eqj9Afq3md/nhKwvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39840400004)(346002)(136003)(396003)(451199018)(83380400001)(38100700002)(316002)(478600001)(54906003)(6506007)(7416002)(4326008)(36756003)(2906002)(6512007)(86362001)(2616005)(44832011)(186003)(8676002)(5660300002)(8936002)(6666004)(66556008)(66476007)(6486002)(6916009)(41300700001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DBsTmZKSTkzYRC437x/zR0a5+b11kbISvEXa47WuwlnMjuT7nPq+BJBVUabf?=
 =?us-ascii?Q?EzALfVDwNtPgd+bULNIIC5WMP9TRMEFtS5YiNQsoIDKQ7zyhV1GkF79J77sZ?=
 =?us-ascii?Q?s9r7sqAnFWxLirjgckIFB12c+Ip35VkOnIXBCTCkSbRBhQTKpQmCcF7eYcMZ?=
 =?us-ascii?Q?q3P358TqZ99dh75LEFT6RbSAtFneJ9WnTr136a/yKpyeNfazOidsAAjxyf1W?=
 =?us-ascii?Q?khZkzIG1kLO0AeRvUgEQ1kZo5TY/yOWPna/uaqGSMBHBeQ28wNU7Z9awIxb3?=
 =?us-ascii?Q?YgAi4K2gq4S39GweK4HGfXiTRdOV/3ow63cmfNP3D2v9uzk+Ixb5X2jm57+q?=
 =?us-ascii?Q?cUawdvU0Bo7D92Ohslfft+pnBZKn4rAF3qWsIXgQ8fGlOzAqrRBo7j1lEqoq?=
 =?us-ascii?Q?15hMGOwurI015CCsWaUxiYLZI2HoKu6Eq2MLbfMjb/w5gzz4JGMSzgVZcgbq?=
 =?us-ascii?Q?IUzoCi/cm6T7qQzSGYWrH2fORn8NEO/WHI5Ir9DJB6QBWhQCUkRe0r7/enMg?=
 =?us-ascii?Q?NhHohrP4gLbeEN86Qq0LwqmbCWhGo0DWpKvZkEEHiz7E1DZXSUAHYCzWF+kb?=
 =?us-ascii?Q?lLXLY97KAjG16sLcsZX8lD/Keh/LB2rszcRHlbdV6SYFm71PzThXoQPsyl2B?=
 =?us-ascii?Q?HO+JRd1ReHqxxXKmZVRKW0h8CsjBLdyG4JrHbxy/NDkT2yrX6kDNh7Uiu8u8?=
 =?us-ascii?Q?NW3vLLUozeC/PUyd14GzkLmQ08WcSakIoM/rZe02GteXICBhzFUUDgHAHRcr?=
 =?us-ascii?Q?PZdxRBXbYlDYYRj89y38AeOyR6GgXcLX5RhUGOJyOHJnmOFyTCp5qA5Rr7F4?=
 =?us-ascii?Q?Qk2JlFUEIAhVYlSCi7P5A9Yy2hARP9FyObJ5zBB6yd6V1PHOF0vG0x09TBfy?=
 =?us-ascii?Q?mP1UVeZDsY1id802jXqiYoDZ8t1mp1gNuPs7MsL5bN2EpqH10JmL8/4N+GRB?=
 =?us-ascii?Q?b5I9BgjvaCGm8AEHaGQ0IE04nWoHARiRcm39IKC2dCAQ56dlWlnpF3a1jww/?=
 =?us-ascii?Q?Mcwsav3fTR/73fVhFAr2xmNwkD1gDQN0/xYE6faLBX3ZfR3b1Xf+j7mI/wp2?=
 =?us-ascii?Q?JGdwBoxQYXiS/kS62iEPFUIn5MVaMG3vStsfxnOXLvidzotcCwB++HI8dQwW?=
 =?us-ascii?Q?MNvRItURMcktLBCW348cRU9v4EzuxlBbuBuLrIxoGE+i6xGNKw+Wifni9Knm?=
 =?us-ascii?Q?WqEpZczqA4WQ9mIpIkpPfrvVRk+T7JJWmZYPmsYHyNtFf8BwEfgfgmt3iq8f?=
 =?us-ascii?Q?emneLVvU+ScNvdr8zWf4zib9/aAi5tw/efBbZb8V/VdB88ztVTYKtUJ3vPtL?=
 =?us-ascii?Q?DSFOZyWaZajNZ7hOtCP/NoPmoEvCGQQ0qwD4tg4ed67rl96E7e2ueulmssUt?=
 =?us-ascii?Q?0kv4mLr5EoUiVdmQHtVdm4coPvg7FswF48zWqwYyPxUREcGK4ERD5wuA6Bbb?=
 =?us-ascii?Q?XzNLLOYdr2Ho/eiXPV+8Xk9FNz4+Uz2p2z6kLZja4oi67+KaxvxVxXRPXkUz?=
 =?us-ascii?Q?fo2pCoseAeL1t3M6/qGeTbl0eaqHsud9DSg86XYNklYn1m2uHOQ2YgT31Rq6?=
 =?us-ascii?Q?73jRewUsRMzxLvP7tP1fu6BnpKfLgZC5Dmfyfff1C41DRf2vNT9tKHDCbZGY?=
 =?us-ascii?Q?fTYYnd0u/W70K+Blw9XQcFXh0XecxKg7vCEuMgL5MxhNEYj2SqGEiAGGtb2w?=
 =?us-ascii?Q?aYAV4g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a52ae91e-b1ab-4254-df85-08db09c67808
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:20:22.7902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g9vAWfo1T3i2PIMJW1Cy9jk9HnwGhfVu32iF1WBojAErW5pvm8PAwIOnKPkVuIOtxtJKSVfikK0dWbkbGr3XCZ0Ak2U/IMPJdK0DcwoYx9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4772
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 08:31:17PM +0200, Vladimir Oltean wrote:
> While running this selftest which usually passes:
> 
> ~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
> TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
> TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
> TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]
> 
> if I start PTP timestamping then run it again (debug prints added by me),
> the unknown IPv6 MC traffic is seen by the CPU port even when it should
> have been dropped:
> 
> ~/selftests/drivers/net/dsa# ptp4l -i swp0 -2 -P -m
> ptp4l[225.410]: selected /dev/ptp1 as PTP clock
> [  225.445746] mscc_felix 0000:00:00.5: ocelot_l2_ptp_trap_add: port 0 adding L2 PTP trap
> [  225.453815] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_add: port 0 adding IPv4 PTP event trap
> [  225.462703] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_add: port 0 adding IPv4 PTP general trap
> [  225.471768] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_add: port 0 adding IPv6 PTP event trap
> [  225.480651] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_add: port 0 adding IPv6 PTP general trap
> ptp4l[225.488]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
> ptp4l[225.488]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> ^C
> ~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
> TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
> TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
> TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group                         [FAIL]
>         reception succeeded, but should have failed
> TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]
> 
> The PGID_MCIPV6 is configured correctly to not flood to the CPU,
> I checked that.
> 
> Furthermore, when I disable back PTP RX timestamping (ptp4l doesn't do
> that when it exists), packets are RX filtered again as they should be:
> 
> ~/selftests/drivers/net/dsa# hwstamp_ctl -i swp0 -r 0
> [  218.202854] mscc_felix 0000:00:00.5: ocelot_l2_ptp_trap_del: port 0 removing L2 PTP trap
> [  218.212656] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_del: port 0 removing IPv4 PTP event trap
> [  218.222975] mscc_felix 0000:00:00.5: ocelot_ipv4_ptp_trap_del: port 0 removing IPv4 PTP general trap
> [  218.233133] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_del: port 0 removing IPv6 PTP event trap
> [  218.242251] mscc_felix 0000:00:00.5: ocelot_ipv6_ptp_trap_del: port 0 removing IPv6 PTP general trap
> current settings:
> tx_type 1
> rx_filter 12
> new settings:
> tx_type 1
> rx_filter 0
> ~/selftests/drivers/net/dsa# ./local_termination.sh eno0 swp0
> TEST: swp0: Unicast IPv4 to primary MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to macvlan MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address                     [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, promisc            [ OK ]
> TEST: swp0: Unicast IPv4 to unknown MAC address, allmulti           [ OK ]
> TEST: swp0: Multicast IPv4 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv4 to unknown group, allmulti               [ OK ]
> TEST: swp0: Multicast IPv6 to joined group                          [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group                         [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, promisc                [ OK ]
> TEST: swp0: Multicast IPv6 to unknown group, allmulti               [ OK ]
> 
> So it's clear that something in the PTP RX trapping logic went wrong.
> 
> Looking a bit at the code, I can see that there are 4 typos, which
> populate "ipv4" VCAP IS2 key filter fields for IPv6 keys.
> 
> VCAP IS2 keys of type OCELOT_VCAP_KEY_IPV4 and OCELOT_VCAP_KEY_IPV6 are
> handled by is2_entry_set(). OCELOT_VCAP_KEY_IPV4 looks at
> &filter->key.ipv4, and OCELOT_VCAP_KEY_IPV6 at &filter->key.ipv6.
> Simply put, when we populate the wrong key field, &filter->key.ipv6
> fields "proto.mask" and "proto.value" remain all zeroes (or "don't care").
> So is2_entry_set() will enter the "else" of this "if" condition:
> 
> 	if (msk == 0xff && (val == IPPROTO_TCP || val == IPPROTO_UDP))
> 
> and proceed to ignore the "proto" field. The resulting rule will match
> on all IPv6 traffic, trapping it to the CPU.
> 
> This is the reason why the local_termination.sh selftest sees it,
> because control traps are stronger than the PGID_MCIPV6 used for
> flooding (from the forwarding data path).
> 
> But the problem is in fact much deeper. We trap all IPv6 traffic to the
> CPU, but if we're bridged, we set skb->offload_fwd_mark = 1, so software
> forwarding will not take place and IPv6 traffic will never reach its
> destination.
> 
> The fix is simple - correct the typos.
> 
> I was intentionally inaccurate in the commit message about the breakage
> occurring when any PTP timestamping is enabled. In fact it only happens
> when L4 timestamping is requested (HWTSTAMP_FILTER_PTP_V2_EVENT or
> HWTSTAMP_FILTER_PTP_V2_L4_EVENT). But ptp4l requests a larger RX
> timestamping filter than it needs for "-2": HWTSTAMP_FILTER_PTP_V2_EVENT.
> I wanted people skimming through git logs to not think that the bug
> doesn't affect them because they only use ptp4l in L2 mode.
> 
> Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

