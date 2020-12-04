Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9A92CF6A0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgLDWMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:12:49 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:50100 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLDWMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:12:48 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcab4350002>; Sat, 05 Dec 2020 06:12:05 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Dec
 2020 22:12:05 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Dec 2020 22:12:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8Q3dZAzoQgCLc5P/x/lcQqvWDp+qPuOWw0xtoxYVe2tMAu2/Cbpb5EGrxEJVDQeykfyhVCH4wPCTZTfs6D7v1aGRu1tPezoyl3QTEqpftjAQQLoj+UJLhLQGkS2/LrW2bI9gdR0YuMHq9Ixrq/AoEieh/js9v1zclcWgAnztGLDheP8u2uh+7KaAIs8mJQSKxXp/avir6p8Y7pu/1yKhHDdtjWhijw/Z/t8S+a9K814nnxOPSq8QAiu1J3NfgoWDrj81vVQFqt/tuW+wsmhLbrtYs9K8UqsrGk5U8stwJOBd0UaR0FUyNYBzAUFE7xx9aAY52GMRhPJqY+WnZFx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIrXPGXC6Hwt8tTaGJT7TVNVxhsXQlzs9LLSzVMWLtw=;
 b=mK1Lv0xcGqJQmLW1SP5N+LrS4GDyKH02kJ7SX5hXGENuY9incOHDHkF6GNAy+Jwf6+7JuFXrhptIsG+4y/H+eU9kO1p8gIWwrUlsxWT7lCtnLBKn4uKiZAWLqZ6tl1pNyVMby9RGsLZFqifvrYhkjpvh34qBLUhvTielNgLcozBPzE5ea5MiJwownruAktNp6H+vyextlegTR+/QmQe8TJGIBoTa44oUkDt2sRF4TJtC56mgWbwRZ1+KSBeO4AEHKoLqjbM4DeYoHtM5TpmJOUTlDSYExjZ7rb0aZqNBhrufYryC132+aM0xubQRWcxO+xW0lJRjrzQTk1IuAg9GIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.22; Fri, 4 Dec 2020 22:12:02 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3632.017; Fri, 4 Dec 2020
 22:12:02 +0000
Subject: Re: [PATCH v2] bridge: Fix a deadlock when enabling multicast
 snooping
To:     Joseph Huang <Joseph.Huang@garmin.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
 <20201204213900.234913-1-Joseph.Huang@garmin.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f771d272-3146-2d8c-391d-87d1db8b8e76@nvidia.com>
Date:   Sat, 5 Dec 2020 00:11:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201204213900.234913-1-Joseph.Huang@garmin.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0087.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::20) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.129] (213.179.129.39) by ZR0P278CA0087.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 22:11:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61e793d8-7459-4878-b3d3-08d898a1a04c
X-MS-TrafficTypeDiagnostic: DM5PR12MB2470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2470F176ADDB440CDDB9146DDFF10@DM5PR12MB2470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcRRhCp5tRJdJ+WIN6Lu3NfdMTQUFYpMAYo3eGSZUa9mk+R2fXxOqm0u8DZwwa+/9d6rjfcEAsPTqUkExK1NugY8tlqn+sG6IHiOI6GJ5POc04mk1Hc4BOutmXw2mAKCVKQLs4reSI7sxWNYl72t0m5zRWXOrUJbQ4dnaCKYfoTtm3zGkIF8RSeaCypo+iSF7Ele78HVvhdRdBm8ccewAYis9wdcLJzXDNL02g92Qe/dzw6kAYCC79PNaABiATYT8VBjNv8YNIaTi+X7vDN2W72H3fsuZQ055uZ4VYQ+PCDvdXx5lpFkSg0+gANnHgp8gcDH8xs5oaLJC7O816/Swfkb9M8Cd6HY+8bSKuCcst0cePgp71AIDs1A7+EOXNtbR7JoBk3bjJ7zygdLf2Dz9VdNWGPNwxoUUZ/lJ70mgC6NZ01e0LPFtV2EE7bosLgC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(6666004)(16526019)(186003)(86362001)(8936002)(316002)(31686004)(83380400001)(110136005)(956004)(8676002)(36756003)(478600001)(2906002)(31696002)(16576012)(53546011)(2616005)(26005)(66946007)(66556008)(6486002)(66476007)(5660300002)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eGlUd1Z5N3FHdktJUWVDdFJuSy9qTytoenc5SE9ndk01Qy93ajVFR1NlSFda?=
 =?utf-8?B?ZTV6blg0amdzb0FleXpnSlhvemZFa0kwR3BWa2N4anIvbnBrcUtwbE1UQUp6?=
 =?utf-8?B?MnM4YU9ZbVI2THFDSm9lTEdjRDFvTzN0d0JxajNjcmNKUFd0dnkxeXJFblNo?=
 =?utf-8?B?WGhHS0gveDE1dG1MSFdSNWNWRkVhVGljZjFManlmR0xLcGlvNjZHZ3lHTjJH?=
 =?utf-8?B?Z25hTEpQVlNwZUphTmFYTzAxdjZRcFpiaDhlSWVSbkVVL2dpT0g2Zk1KeFps?=
 =?utf-8?B?UVVnU1ZKNk43bVh0OHVjSUhEWE9FMVBUTCtxVFlZZ0RNeCtBd1JSU29xYURi?=
 =?utf-8?B?UWxkeEZoM0YzZ3lDRnR6QjR0am9tRkNBZ2NGTFU0aDZLeTRVZkwrbldVaHlF?=
 =?utf-8?B?N1g0UXF1TGlSTjFLL1JhbWUzbGYwU1VYenBReDM0WlpBMTVnWDFXOU9BMFlj?=
 =?utf-8?B?eURTa3gzdmpXUytHMEVKYjk1YmZVRnRNUXdFTmIvbFArTzZFQmJId3krQkU0?=
 =?utf-8?B?RnVHZnFjektNMmlnVXVsOUhHQjR0V09qVlJmVnBSNEZKdFpJUWk2YzNCNVNY?=
 =?utf-8?B?QVFUU1BxL1k3VDN0bFh4U2Mrbk5qN2orMTFwMFJnQnlYanU1ZnNCeEhmNmVP?=
 =?utf-8?B?aS9DZDdvVklPdjJ6S0VUby9ZSkdNSlJwaUc5Y2phZEFpUGVtNi93VnVuMEx5?=
 =?utf-8?B?VHV5NDFnUFp3bzFSREtUekw2aFNSOUN1N3l4TlFBelZOUysrNXI5TkhBSElH?=
 =?utf-8?B?Zkd0a3A1dlNISjBRNXZvYTg2SG44NjV5QmszdHJPTUdsWTFWcGhRaVRmS1Vv?=
 =?utf-8?B?ZDRBS1M3bWpiTzZIK2Y0czVVMmJFMVRUZi94dERHRHM1RjBlWDFCMjJGMHVa?=
 =?utf-8?B?eU1pOUpBWVc1R2V3S0x3czR1VHQ3TXk5Z3dlb0g3ME9kcVhRbUZvbkFuK3k0?=
 =?utf-8?B?SHppSnM5OGgyQXhIc0JubnVxaUNzZzV1c05YN0N3NEZhSlp5NnZIUnRmcG5l?=
 =?utf-8?B?Z1kxL2lPenpPR2VQUmNwYWhFMFRYajk0QVczSUhwMmdCZDdhenV2THZubHMr?=
 =?utf-8?B?S0NJSmx1N0ZlNGJKSTg4S2h4bnEzTC92blg5TkVObnFHK2k1KzJYdXVtTlFD?=
 =?utf-8?B?SDFraVN0MmVIdVlBdzA4czJwOEJETGFCaUhnSTM0SVBZZlYramxORkJSYWdY?=
 =?utf-8?B?K0RUM3Y3NTlOZ0lTQTFLMWlVRk9zTjBVakxGVHpGMml3VS9oSWxSTENaVFF5?=
 =?utf-8?B?NnBvZWlveW9RWHMrTTVMZHJ5aWQ1V0FQQVpKdzF3cmRWTTQzakNBRkw1NFFy?=
 =?utf-8?Q?CLhdK857h/mmzrNyRh9stFQk3HsFSZMSLg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e793d8-7459-4878-b3d3-08d898a1a04c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 22:12:02.3241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BoF3I/PIM456Q6sXIORgsI175v0hCrpp5hMotxbAI2frFzlrmhUyM7yWw3b7wXu4rvCgf2Fg66IPk4uD63rnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2470
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607119925; bh=SIrXPGXC6Hwt8tTaGJT7TVNVxhsXQlzs9LLSzVMWLtw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:References:From:Message-ID:Date:
         User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Nyj65cjfR+DAw7oiiXJZKoTK3XLUmdryLntM7KISzcUGnZn1h1phv+rZ/Xs7fBwWm
         L0BAy2U+kFyVzbUx/LYgvRm+D5O3KelNZS5jZFep+rRgB+fiUpb5LMLEshlbtdzNYC
         bu9FqOlY95aUd8iS005ZfC7qv8ir/BsryO+27J+hCv92oCPsnR114hLCP7IpGhp8Ha
         vgiZcKo+DErRMt54TJLbSTtVoH1UxTyYZuRnHInpdnOZkxUpKHdwFmhgkT/rNPErjv
         nyeRqN5aZqZLYjaj4h08PU8Wb5LAJcj4toOG/+dNsu/YvhBwE28xmwhEcSERKerPsc
         sGv7jP5Ai43IA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12/2020 23:39, Joseph Huang wrote:
> When enabling multicast snooping, bridge module deadlocks on multicast_lock
> if 1) IPv6 is enabled, and 2) there is an existing querier on the same L2
> network.
> 
> The deadlock was caused by the following sequence: While holding the lock,
> br_multicast_open calls br_multicast_join_snoopers, which eventually causes
> IP stack to (attempt to) send out a Listener Report (in igmp6_join_group).
> Since the destination Ethernet address is a multicast address, br_dev_xmit
> feeds the packet back to the bridge via br_multicast_rcv, which in turn
> calls br_multicast_add_group, which then deadlocks on multicast_lock.
> 
> The fix is to move the call br_multicast_join_snoopers outside of the
> critical section. This works since br_multicast_join_snoopers only deals
> with IP and does not modify any multicast data structures of the bridge,
> so there's no need to hold the lock.
> 
> Steps to reproduce:
> 1. sysctl net.ipv6.conf.all.force_mld_version=1
> 2. have another querier
> 3. ip link set dev bridge type bridge mcast_snooping 0 && \
>    ip link set dev bridge type bridge mcast_snooping 1 < deadlock >
> 
> A typical call trace looks like the following:
> 
> [  936.251495]  _raw_spin_lock+0x5c/0x68
> [  936.255221]  br_multicast_add_group+0x40/0x170 [bridge]
> [  936.260491]  br_multicast_rcv+0x7ac/0xe30 [bridge]
> [  936.265322]  br_dev_xmit+0x140/0x368 [bridge]
> [  936.269689]  dev_hard_start_xmit+0x94/0x158
> [  936.273876]  __dev_queue_xmit+0x5ac/0x7f8
> [  936.277890]  dev_queue_xmit+0x10/0x18
> [  936.281563]  neigh_resolve_output+0xec/0x198
> [  936.285845]  ip6_finish_output2+0x240/0x710
> [  936.290039]  __ip6_finish_output+0x130/0x170
> [  936.294318]  ip6_output+0x6c/0x1c8
> [  936.297731]  NF_HOOK.constprop.0+0xd8/0xe8
> [  936.301834]  igmp6_send+0x358/0x558
> [  936.305326]  igmp6_join_group.part.0+0x30/0xf0
> [  936.309774]  igmp6_group_added+0xfc/0x110
> [  936.313787]  __ipv6_dev_mc_inc+0x1a4/0x290
> [  936.317885]  ipv6_dev_mc_inc+0x10/0x18
> [  936.321677]  br_multicast_open+0xbc/0x110 [bridge]
> [  936.326506]  br_multicast_toggle+0xec/0x140 [bridge]
> 
> Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
> Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
> ---

Hi,
Thank you for fixing it up, a few minor nits below. Overall the patch
looks good.


>  net/bridge/br_device.c    |  6 ++++++
>  net/bridge/br_multicast.c | 33 ++++++++++++++++++++++++---------
>  net/bridge/br_private.h   | 10 ++++++++++
>  3 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 7730c8f3cb53..d3ea9d0779fb 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -177,6 +177,9 @@ static int br_dev_open(struct net_device *dev)
>  	br_stp_enable_bridge(br);
>  	br_multicast_open(br);
>  
> +	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
> +		br_multicast_join_snoopers(br);
> +
>  	return 0;
>  }
>  
> @@ -197,6 +200,9 @@ static int br_dev_stop(struct net_device *dev)
>  	br_stp_disable_bridge(br);
>  	br_multicast_stop(br);
>  
> +	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
> +		br_multicast_leave_snoopers(br);
> +
>  	netif_stop_queue(dev);
>  
>  	return 0;
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index eae898c3cff7..426fe00db708 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -3286,7 +3286,7 @@ static inline void br_ip6_multicast_join_snoopers(struct net_bridge *br)
>  }
>  #endif
>  
> -static void br_multicast_join_snoopers(struct net_bridge *br)
> +void br_multicast_join_snoopers(struct net_bridge *br)
>  {
>  	br_ip4_multicast_join_snoopers(br);
>  	br_ip6_multicast_join_snoopers(br);
> @@ -3317,7 +3317,7 @@ static inline void br_ip6_multicast_leave_snoopers(struct net_bridge *br)
>  }
>  #endif
>  
> -static void br_multicast_leave_snoopers(struct net_bridge *br)
> +void br_multicast_leave_snoopers(struct net_bridge *br)
>  {
>  	br_ip4_multicast_leave_snoopers(br);
>  	br_ip6_multicast_leave_snoopers(br);
> @@ -3336,9 +3336,6 @@ static void __br_multicast_open(struct net_bridge *br,
>  
>  void br_multicast_open(struct net_bridge *br)
>  {
> -	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
> -		br_multicast_join_snoopers(br);
> -
>  	__br_multicast_open(br, &br->ip4_own_query);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	__br_multicast_open(br, &br->ip6_own_query);
> @@ -3354,9 +3351,6 @@ void br_multicast_stop(struct net_bridge *br)
>  	del_timer_sync(&br->ip6_other_query.timer);
>  	del_timer_sync(&br->ip6_own_query.timer);
>  #endif
> -
> -	if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
> -		br_multicast_leave_snoopers(br);
>  }
>  
>  void br_multicast_dev_del(struct net_bridge *br)
> @@ -3487,6 +3481,8 @@ static void br_multicast_start_querier(struct net_bridge *br,
>  int br_multicast_toggle(struct net_bridge *br, unsigned long val)
>  {
>  	struct net_bridge_port *port;
> +	bool join_snoopers = false;
> +	bool leave_snoopers = false;
>  

We use reverse xmas tree order, longest to shortest, so these two have to be
swapped, but one more related thing further below..

>  	spin_lock_bh(&br->multicast_lock);
>  	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
> @@ -3495,7 +3491,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
>  	br_mc_disabled_update(br->dev, val);
>  	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
>  	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
> -		br_multicast_leave_snoopers(br);
> +		leave_snoopers = true;
>  		goto unlock;
>  	}
>  
> @@ -3506,9 +3502,28 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
>  	list_for_each_entry(port, &br->port_list, list)
>  		__br_multicast_enable_port(port);
>  
> +	join_snoopers = true;
> +
>  unlock:
>  	spin_unlock_bh(&br->multicast_lock);
>  
> +	/* br_multicast_join_snoopers has the potential to cause
> +	 * an MLD Report/Leave to be delivered to br_multicast_rcv,
> +	 * which would in turn call br_multicast_add_group, which would
> +	 * attempt to acquire multicast_lock. This function should be
> +	 * called after the lock has been released to avoid deadlocks on
> +	 * multicast_lock.
> +	 *
> +	 * br_multicast_leave_snoopers does not have the problem since
> +	 * br_multicast_rcv first checks BROPT_MULTICAST_ENABLED, and
> +	 * returns without calling br_multicast_ipv4/6_rcv if it's not
> +	 * enabled. Moved both functions out just for symmetry.
> +	 */

Nice comment, thanks!

> +	if (join_snoopers)
> +		br_multicast_join_snoopers(br);
> +	else if (leave_snoopers)
> +		br_multicast_leave_snoopers(br);

If I'm not missing anything this can be just 1 bool like "change_snoopers" or something
which if set to true will check BROPT_MULTICAST_ENABLED and act accordingly, i.e.
if (change_snoopers) {
    if (br_opt_get(br, BROPT_MULTICAST_ENABLED))
         br_multicast_join_snoopers(br);
    else
         br_multicast_leave_snoopers(br);
}
 
This is not really something critical, just an observation. Up to your
preference if you decide to leave it with 2 bools. :-)

Cheers,
 Nik

> +
>  	return 0;
>  }
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 345118e35c42..8424464186a6 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -792,6 +792,8 @@ void br_multicast_del_port(struct net_bridge_port *port);
>  void br_multicast_enable_port(struct net_bridge_port *port);
>  void br_multicast_disable_port(struct net_bridge_port *port);
>  void br_multicast_init(struct net_bridge *br);
> +void br_multicast_join_snoopers(struct net_bridge *br);
> +void br_multicast_leave_snoopers(struct net_bridge *br);
>  void br_multicast_open(struct net_bridge *br);
>  void br_multicast_stop(struct net_bridge *br);
>  void br_multicast_dev_del(struct net_bridge *br);
> @@ -969,6 +971,14 @@ static inline void br_multicast_init(struct net_bridge *br)
>  {
>  }
>  
> +static inline void br_multicast_join_snoopers(struct net_bridge *br)
> +{
> +}
> +
> +static inline void br_multicast_leave_snoopers(struct net_bridge *br)
> +{
> +}
> +
>  static inline void br_multicast_open(struct net_bridge *br)
>  {
>  }
> 

