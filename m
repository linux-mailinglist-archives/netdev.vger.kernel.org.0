Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47452CE2C1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgLCXfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:35:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5866 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbgLCXfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:35:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc9762e0000>; Thu, 03 Dec 2020 15:35:10 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 23:35:10 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 3 Dec 2020 23:35:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b27aU+eKxQE+iwJ+baUWXaS6DKZnZ81UsCHvAsRA6n3W5010t8c17ZdZXRi+27Y0wmaIRROPrHTIh87sUd8NayaBL8CxH1r7J3UFT9THfMu29p90RJLrUFDhITsdPHo/iHNgHvd3BIImqEVBBEFkiA8q407Hp/hYi198Q8kTaQ9SaOcLbLrJPuzlfMntQNroL+eQe7mVoTmRYBdi7flWbNeAVC5hcLrb/75v+WJjDqYn0nLUbeyHkt33CPSa/Xz5jvyXC9p4X+tPjIhgI7RhmWaWpL5QlXbFzaOCStsBWWC9ZSiL7uX+f4UUF9rArdAdDJMUIT3ZJYlK/hGeaS/Wkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sFmlMV8TuZ8eatqfFT5iKKp9xTyyhKzKg8y7yeTAqU=;
 b=Ag563nFoIbUTq3n5l8bYeFeJZDeH9cXKB+BYNddH5+oNxvvhgEbvBoXXCpEB9SYrzMyszNHERDhEgx6V+gpXXxTzaHLU6U14vvi1lB9nEJMWX3PZ8sLYxdHB8cyrVzKuv/kA+WewNHS7ZhdP7TZJMyQfdKpUch2F64db9BhVVUY2vYJmIcOpHZDb98HNqRNwUT0uFF2o0LogqAK98QUmWIFRGrGX8nqMwPjXhHMy+l+f2C0ty2UML9RnoRGClzqLDVj+gq/s++OG84QeHnA4myRxS5e199ZZjpnumkN8FWye9icSb8eCnf9s+4+lSIXT7et69TAvU4ntucOymDx31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: c0d3.blue; dkim=none (message not signed)
 header.d=none;c0d3.blue; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB3276.namprd12.prod.outlook.com (2603:10b6:5:15e::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3611.25; Thu, 3 Dec 2020 23:35:06 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3632.017; Thu, 3 Dec 2020
 23:35:06 +0000
Subject: Re: [PATCH] bridge: Fix a deadlock when enabling multicast snooping
To:     "Huang, Joseph" <Joseph.Huang@garmin.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
 <20201203102802.62bc86ba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <bd84ca4c-c694-6fd2-81ef-08e9253c18a4@nvidia.com>
 <c82ce96d74ed4d3897d2e68a258f7834@garmin.com>
 <2b96b845990e4a84a3b3fd46f4138ac6@garmin.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <75cf7844-8df7-0ea2-1980-ff868a1bc34e@nvidia.com>
Date:   Fri, 4 Dec 2020 01:34:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <2b96b845990e4a84a3b3fd46f4138ac6@garmin.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0033.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::20) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.129] (213.179.129.39) by ZR0P278CA0033.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 23:35:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 012087b5-49cc-46b6-a403-08d897e4109c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3276:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3276901DC09F88856057233FDFF20@DM6PR12MB3276.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/nTgdFSP4rDVgWpVO6r2/rAGLKIKwm93SEvleUI04fqC1uG/035s7sJXxMVLdVxPV+k96WfE2At2mm0uCDGTXXAT+bBl/kPqaO7t46btCiIqw/EyxKmTsqLYeYUvi0whIVhCv9rYNisxrr6a5+Ix0wd4aA9lOjWGWkaccPfSvB4lnoFrmKoSEaiuGG+hcSWyWUTf439AcBI4DGfAdFn2DMY2g/90SpcogAACyMsh5shMlqtIg/hqrvoKs/vSIS6NG168+QQOBZ0Yc0GtfG+qVm6yFOdnPeKKAMCTFqIIrl8l8OuCzzwm2oRrgQeMNah9I416WFYsPGkmK2mcMo568gyWocWIiyTRB2j+7vyfVmlI3DF25XQrUTrOCGhmeI/AustM4lEjPWglQhPT8f00TQI0hZklSVBOm6hiFsQu5mRlMd+JsNA02vGXNkyZ5Je
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(2906002)(6666004)(4326008)(53546011)(316002)(31696002)(5660300002)(26005)(36756003)(16526019)(186003)(956004)(83380400001)(6486002)(86362001)(478600001)(8676002)(2616005)(66574015)(54906003)(66946007)(110136005)(16576012)(31686004)(66556008)(8936002)(66476007)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eFpYZHhvak84M3R5Q2xRVDNlRFgxOVlXN3FoZHB5ZFRBWVhnQ0toV2x1c0NN?=
 =?utf-8?B?cWxHUHNURHArSUNQMTJmaklmRnJvc1lMUzYxVVZIZmVsN1pzeHhxWTlLbyt6?=
 =?utf-8?B?WjdkbUZuOHd3c3czTjhOVWRJcndPMzdiRHRuNE9pYWpTNVNWTGpHZkZMdCtK?=
 =?utf-8?B?QmJTekpNQ3ZGbldoYjREU01NZzdBeGxpSFUvY0ZCemZSOW4yR2doVThLNXp2?=
 =?utf-8?B?VWQ0dTYzTFd1UUVZOFZ6UlRHWTRBdWFvR0UrT3F4WjN5cVZJVk1lTStMY3c2?=
 =?utf-8?B?cVNGbEwyTndMMC9QS0VENUM1Qk1veUtyT0drVHdrdlRjeDlBeEU3Qk5tYU83?=
 =?utf-8?B?Q3A5MGpQWS85MVdrQWVVSjd2REpBZUxzdC9aRkNUY0Voblk0ZjVLZDNVTy9r?=
 =?utf-8?B?QWh1YU9nRUgrb1JzcmVxd21mOWl1ZmxwQkEwbjUvQ1p2SWM2bHdTYTNSN1Bj?=
 =?utf-8?B?L3k4N203Wlkycm9qdU1wSXhud2JlUWdMWDlYOEJxNE55cGpJSHdDTnZ4dFRk?=
 =?utf-8?B?MzdkQW40VnQvc0RBUDJJM1B6dkxWRzRZZnR6YkVoTnAyM2F5Tm0wdyszK3NR?=
 =?utf-8?B?WXhXS2JuWFlNQVE4TWtwakhkOWxtTkNHVjMyZ2ZjWHp1WmR5WE1FQzB0MTNL?=
 =?utf-8?B?cnJWRlRzaDhlMG1OZUpkNlNxWnYwendTRGh0OWErNzVxZ3R2UElHeGlySXl2?=
 =?utf-8?B?SlNlYkRlRDlMTU85VVJRTDNmcENrdmZXSGJUVkEvVGJpZmxDSG1yMkFqMSsy?=
 =?utf-8?B?Y01jVEtNZVdYTFNyS05kaWdSakNSRVZEbHhYbGtDRFhWbU11T29id1RLcFY0?=
 =?utf-8?B?enBQNkF3R0RxN1dHK0VTMitVQ1J2SUk0MXhaSmtaNGQwNFp1MTJtengvbmZV?=
 =?utf-8?B?aVo5blhIdEticytPdWt4VXRGRGkxcFFiR1dmbk8xempORVZWYmtmdDNqYnNG?=
 =?utf-8?B?c2xoeGdsb01IZlJFOEU0Mzd4SDBNMHd4OTJxNHRkWFFZUytoajdlYkxkcUlu?=
 =?utf-8?B?V2hXdEVzcHh0WEI4eko0OHVWdk5MU1dpSXdqc3hvbHhZV0dQODJ3MytkbWJa?=
 =?utf-8?B?UzdkS0R6RWFOemdMQWJjWGg3SVIzZmlnZkJzVCtpNnFIdnl6ZldWQ0NFUjND?=
 =?utf-8?B?VEZ5NEpSRkladFp6YjV3TjBiWkRYb2hTZXcyZzlqbGswZTFHRUowSHNSNUlV?=
 =?utf-8?B?WXY2T09CTDBZenYwM09jU05SaDhOZyt5Uk9Rc1E4cE96TWk4Tk1IVksySXdl?=
 =?utf-8?B?WnAzYkRaRWJaMFpWS3FIU3ZuamRlQ3ZyNTlNWVk2d0VENmhZdWJGQnVxNnNi?=
 =?utf-8?Q?te7gOY8Dqk5uGOkDQKBArMpTgnXo/F3eTk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 012087b5-49cc-46b6-a403-08d897e4109c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 23:35:06.3522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSfsxNFzuT3R32hDigyqY/5FCgJRAIWLRRJw5mqU2EOgoG/sPqCbwa4qUuTsg+BAqmf1DFfni12jdY5BoZOnHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3276
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607038510; bh=Cn2qwSbJ1wuPSE71xW6agvI9EPtzEZzffNBaWR1UZfw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
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
        b=D95zEBhJlBlB7Oq+zoaGcKix8QnMrqiv/RKcUsyoyhSe3wPmZYSNFeDLc7NG2qZyp
         AYxQ1HP7eRrC2XLZrzHtJVxDE0unDqIis8KzTDpCVTQ+j8vPjJjpKn0mjiWkqXuKD7
         I/NLrcG8SaxwWNak3x8zze3EOfgAjF81JZ9LXqEopbytj/AvPKsNObrgabkUKieads
         2K3wqmWEQL9Vxi3a/nQvr5qjKKez6MIeYgdVZ8d7ZnX31CG+oyC72tXKTj8SpEyiCL
         TdXNpZoibYaaZoOJmNPImjmtMEeZmUJGlshCoJK9e5j2niwQ5RINvpDlK/LR10NG+b
         GwuhEjnQaO9Fw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12/2020 00:42, Huang, Joseph wrote:
>> From: Huang, Joseph
>> Sent: Thursday, December 3, 2020 4:53 PM
>> To: Nikolay Aleksandrov <nikolay@nvidia.com>; Jakub Kicinski
>> <kuba@kernel.org>
>> Cc: Roopa Prabhu <roopa@nvidia.com>; David S. Miller
>> <davem@davemloft.net>; bridge@lists.linux-foundation.org;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Linus L=C3=BCssing
>> <linus.luessing@c0d3.blue>
>> Subject: RE: [PATCH] bridge: Fix a deadlock when enabling multicast snoo=
ping
>>
>>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>> Sent: Thursday, December 3, 2020 3:47 PM
>>> To: Jakub Kicinski <kuba@kernel.org>; Huang, Joseph
>>> <Joseph.Huang@garmin.com>
>>> Cc: Roopa Prabhu <roopa@nvidia.com>; David S. Miller
>>> <davem@davemloft.net>; bridge@lists.linux-foundation.org;
>>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Linus L=C3=BCssin=
g
>>> <linus.luessing@c0d3.blue>
>>> Subject: Re: [PATCH] bridge: Fix a deadlock when enabling multicast
>>> snooping
>>>
>>> On 03/12/2020 20:28, Jakub Kicinski wrote:
>>>> On Tue, 1 Dec 2020 16:40:47 -0500 Joseph Huang wrote:
>>>>> When enabling multicast snooping, bridge module deadlocks on
>>>>> multicast_lock if 1) IPv6 is enabled, and 2) there is an existing
>>>>> querier on the same L2 network.
>>>>>
>>>>> The deadlock was caused by the following sequence: While holding the
>>>>> lock, br_multicast_open calls br_multicast_join_snoopers, which
>>>>> eventually causes IP stack to (attempt to) send out a Listener Report=
 (in
>>> igmp6_join_group).
>>>>> Since the destination Ethernet address is a multicast address,
>>>>> br_dev_xmit feeds the packet back to the bridge via br_multicast_rcv,
>>>>> which in turn calls br_multicast_add_group, which then deadlocks on
>>> multicast_lock.
>>>>>
>>>>> The fix is to move the call br_multicast_join_snoopers outside of the
>>>>> critical section. This works since br_multicast_join_snoopers only
>>>>> deals with IP and does not modify any multicast data structures of
>>>>> the bridge, so there's no need to hold the lock.
>>>>>
>>>>> Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
>>>>>
>>>>> Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
>>>>
>>>> Nik, Linus - how does this one look?
>>>>
>>>
>>> Hi,
>>> Thanks, somehow I missed this one too. Need to check my email config. :=
) I
>>> believe I see how it can happen, although it's not straight-forward to =
follow.
>>> A selftest for this case would be great, and any traces (e.g. hung task=
)
>> would
>>> help a lot as well.
>>> Correct me if I'm wrong but the sequence is something like:
>>> br_multicast_join_snoopers -> ipv6_dev_mc_inc -> __ipv6_dev_mc_inc ->
>>> igmp6_group_added
>>> -> MLDv1 (mode) igmp6_join_group() -> Again MLDv1 mode
>>> -> igmp6_join_group() -> igmp6_join_group
>>> -> igmp6_send() on the bridge device -> br_dev_xmit and onto the bridge
>>> -> mcast processing code
>>> which uses the multicast_lock spinlock. Right?
>>
>> That is correct.
>>
>> Here's a stack trace from a typical run:
>>
>> echo -n 1 > /sys/devices/virtual/net/gmn0/bridge/multicast_snooping
>> [  936.146754] rcu: INFO: rcu_preempt self-detected stall on CPU
>> [  936.152534] rcu:   0-....: (5594 ticks this GP)
>> idle=3D75a/1/0x4000000000000002 softirq=3D2787/2789 fqs=3D2625
>> [  936.162026]        (t=3D5253 jiffies g=3D4205 q=3D12)
>> [  936.166041] Task dump for CPU 0:
>> [  936.169272] sh              R  running task        0  1315   1295 0x0=
0000002
>> [  936.176332] Call trace:
>> [  936.178797]  dump_backtrace+0x0/0x140
>> [  936.182469]  show_stack+0x14/0x20
>> [  936.185793]  sched_show_task+0x108/0x138
>> [  936.189727]  dump_cpu_task+0x40/0x50
>> [  936.193313]  rcu_dump_cpu_stacks+0x94/0xd0
>> [  936.197420]  rcu_sched_clock_irq+0x75c/0x9c0
>> [  936.201698]  update_process_times+0x2c/0x68
>> [  936.205893]  tick_sched_handle.isra.0+0x30/0x50
>> [  936.210432]  tick_sched_timer+0x48/0x98
>> [  936.214272]  __hrtimer_run_queues+0x110/0x1b0
>> [  936.218635]  hrtimer_interrupt+0xe4/0x240
>> [  936.222656]  arch_timer_handler_phys+0x30/0x40
>> [  936.227106]  handle_percpu_devid_irq+0x80/0x140
>> [  936.231654]  generic_handle_irq+0x24/0x38
>> [  936.235669]  __handle_domain_irq+0x60/0xb8
>> [  936.239774]  gic_handle_irq+0x5c/0x148
>> [  936.243535]  el1_irq+0xb8/0x180
>> [  936.246689]  queued_spin_lock_slowpath+0x118/0x3b0
>> [  936.251495]  _raw_spin_lock+0x5c/0x68
>> [  936.255221]  br_multicast_add_group+0x40/0x170 [bridge]
>> [  936.260491]  br_multicast_rcv+0x7ac/0xe30 [bridge]
>> [  936.265322]  br_dev_xmit+0x140/0x368 [bridge]
>> [  936.269689]  dev_hard_start_xmit+0x94/0x158
>> [  936.273876]  __dev_queue_xmit+0x5ac/0x7f8
>> [  936.277890]  dev_queue_xmit+0x10/0x18
>> [  936.281563]  neigh_resolve_output+0xec/0x198
>> [  936.285845]  ip6_finish_output2+0x240/0x710
>> [  936.290039]  __ip6_finish_output+0x130/0x170
>> [  936.294318]  ip6_output+0x6c/0x1c8
>> [  936.297731]  NF_HOOK.constprop.0+0xd8/0xe8
>> [  936.301834]  igmp6_send+0x358/0x558
>> [  936.305326]  igmp6_join_group.part.0+0x30/0xf0
>> [  936.309774]  igmp6_group_added+0xfc/0x110
>> [  936.313787]  __ipv6_dev_mc_inc+0x1a4/0x290
>> [  936.317885]  ipv6_dev_mc_inc+0x10/0x18
>> [  936.321677]  br_multicast_open+0xbc/0x110 [bridge]
>> [  936.326506]  br_multicast_toggle+0xec/0x140 [bridge]
>>
>>
>>>
>>> One question - shouldn't leaving have the same problem? I.e.
>>> br_multicast_toggle -> br_multicast_leave_snoopers
>>> -> br_ip6_multicast_leave_snoopers -> ipv6_dev_mc_dec ->
>>> -> igmp6_group_dropped -> igmp6_leave_group ->
>>> MLDv1 mode && last reporter -> igmp6_send() ?
>>>
>>> I think it was saved by the fact that !br_opt_get(br,
>>> BROPT_MULTICAST_ENABLED) would be true and the multicast lock won't
>> be
>>> acquired in the br_dev_xmit path? If so, I'd appreciate a comment about
>> that
>>> because it's not really trivial to find out. :)
>>
>> That's a really good point. Leave should have deadlocked as well, but wh=
en I
>> tested the patch, I was able to turn on/off multicast snooping multiple =
times
>> without any problem.
>>
>> Is it because this line in igmp6_leave_group?
>>
>>               if (ma->mca_flags & MAF_LAST_REPORTER)
>>                       igmp6_send(&ma->mca_addr, ma->idev->dev,
>>                               ICMPV6_MGM_REDUCTION);
>>
>> Perhaps MAF_LAST_REPORTER was not set, so igmp6_send was not called?
>>
>>>
>>> Anyhow, the patch is fine as-is too:
>>> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
>>>
>>> Thanks,
>>>  Nik
>>
>> Thanks,
>> Joseph
>=20
> Would it be advisable if we move br_multicast_leave_snoopers out of the c=
ritical
> section as well? Even though I can't really verify that if this is helpfu=
l since I haven't
> seen it deadlock when disabling multicast snooping.
>=20
> Thanks,
> Joseph
>=20
 The reason we're not seeing a deadlock is because the multicast snooping b=
it
is not set and the lock is never acquired when sending the packet through b=
r_multicast_rcv().
Anyway I'd move it out for symmetry and it would be less confusing as you'd=
 just have a standard
if/else in the end. By the way now that I looked again the patch is not ent=
irely correct as you'll
do multiple joins/leaves on every br_multicast_toggle(), i.e. with the patc=
h you bypass the check
for the same value and actually try to change state each time (the
if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) =3D=3D !!val) check).

We also lose the symmetry between br_dev_open and stop, and expose otherwis=
e
private multicast code, so I'd pull out the snoopers leave for br_dev_stop(=
) as well.

Please add a comment why it's needed, so we won't wonder about it later. An=
d also include the
trace in the commit message so we'd have it.

Edit: I just tried it and it's very easy to reproduce, steps:
1. sysctl net.ipv6.conf.all.force_mld_version=3D1
2. have another querier
3. ip link set dev bridge type bridge mcast_snooping 0 && ip link set dev b=
ridge type bridge mcast_snooping 1
< deadlock >

Thanks,
 Nik

