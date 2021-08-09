Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB393E421F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhHIJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:10:05 -0400
Received: from mail-dm6nam10on2087.outbound.protection.outlook.com ([40.107.93.87]:47841
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234127AbhHIJKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:10:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrFkTvUuIzaOPdlJio4jl6L2QQg3fFDELHUVSO/iUdLeAvbyEN/mlzgiiOjeODd+kJ4WdHnlDohs566eSe1VWVEfnCv2oX55XISNlFuGV3awc8Y/EQtF8y8kgyYN2Z9VQ62yenAm3txlQP3DPGcADwMmmgEc3TuawXPdSbUFi9BJ855VTEkbxdvStGyyAgzKSiE7cgJsphbfuXHN7rXogRsMp3w5uuh9RAJKa14Tc11MUe/Zur1vXmGr17jmCwr7EnNSL8pVvA7TZryxXdxuTeLHJizvM6ZxkhfIyG6cLv12ZQWo4aKnqmZChZ3A9AVyTcc3cLDkRfSGst8mOa104Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7tvrWFyrba3jBCmQsFCnSm4A6B49OjV7l0aeQrL3mo=;
 b=NL7lgMnEV0Ax8n4lovQkO9xhMPqLZ/AAiC3LTZHKMbWsmdP9Tz5kStcc8dfEojyf4JdTzBksRiEZ224nS16U7gJauDU45djVACbW9Wd2qvvq2GV5oZYGLo61bWrrI8NOJy6QSz9gAdms2FI9kn/kcnHsnvbqxY7nGe/irhgeXDI6nyQZiHlWVCvyGc2isT+9VHgv8VJxRKcmrxPQE1B0dmaFi+yjJIYprRQJ+/Ckb0pBzv13wm7OJW/T2s0AqMu1CnIiKSXdWovYGZ5nt32fskVNCpoFERJzAbznBzKk+0t1WXzdvcecgg3iu7xVjOSxQOr3tcz1F3EbcMEpj9LEjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7tvrWFyrba3jBCmQsFCnSm4A6B49OjV7l0aeQrL3mo=;
 b=VgepStQJvZiRmcW/k5CGwNEScDhx4MF5IevKpW72+ZDWBrTTofFUwO7XYFUGqRpCmLPxOk1q5jZNslERmio88+svIZcK705mrbT9QJWjQ4PNib6o1OOxEyJgcBejSMxv83vjELaHlEW2pKsFPV5xTec8l9hikT4baKHs9DFcFgdW3gaEFobH3bkRBzZeAPhYw9A8nVz1Xxh6N1Hh8GFzuugS3jP35zDiXW/egvSCmFfuQ5Ba7PyMKQI7vqL9QZ5LDT4CawBplDRo3AfI450rZ0HVy23YUYziNnQkVmlfp/uzk//rInz589tmFBsfBaa6GT4WK4Ci2NROwVn8OD4rqw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 09:09:42 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 09:09:42 +0000
Subject: Re: [PATCH net v2] net: bridge: fix memleak in br_add_if()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org
References: <20210809090211.65677-1-yangyingliang@huawei.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <8af55b8a-0844-3fb2-8dd4-f6818c2675db@nvidia.com>
Date:   Mon, 9 Aug 2021 12:09:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210809090211.65677-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0098.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.187] (213.179.129.39) by ZR0P278CA0098.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 09:09:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fa8e32f-8eb4-4dae-b0fd-08d95b156c63
X-MS-TrafficTypeDiagnostic: DM8PR12MB5462:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB54624427E3487219F3A681D1DFF69@DM8PR12MB5462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZdfCA3EEBEvy5Sjplu/hd7JRLU2iRy9PRqVGYGGn7e7yFgTd9VOfBw8yUnmH2JDv6MZGZiNJSUAdzBe6XOOsUWS9j+xzXRmTBeSuPUwUNSQjcWJJq0HfUn+PXg1644FMWns8OESEntVhSboMR8DGrXb/1rNVGvaE6pgf36fZ642qoLYTgcqDiRzJIkAXIf4tpEpMkiiF75zHA3mcQ/Qne/N9oW+CTAwy2bpuIsc8vBzwJW9SJjDcZkfY6Mb976Asrv+r269oY+mf1VnhW5S1Rc59SzzpNMF1o/vBxODwDF+70yUXABEnjOP7nq4KqUaUd9QDZB46o1RRtVSZnBM+Iz/u4H9zPPR28rdpEEMmy2xg4llHED8qSAupbhiivl7zrEmyOIvvKca/6olkJdksC+5uTVm90+CEiRUwr+m4V7RiPduL6HBZszVRWlrFjA39+R1N0uQPJ4HaGdAY/Xl0ixOPecFk9BU6meFRqLXn75bv6vozrOPpIPZcWNHcqvumZ6qJY9UsRhDJF3BVwS0uHgacrSbCMUpHH1NRYG9GkA2QJo6E7E0K+R5jrQBNMZnfCnflMuvJIU5qUHQQcivxU+m19mYRmG7bKAsPwSUlht1Sij7PP3daYUzraev1iICY9y1IpA7x5O7imncGFD16ryjUADasJ/ivNGoWWyc0XC6ME1ZA1oVIgsvsnIpkrhRJWqax7TZrq4W+jINFZuzAk32LliKZP2M6Ylc2CQOeZjxO8s03qgSJzYskMvEI9a2EeTjjHIAd/QZP+MnQdOYyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(31696002)(186003)(38100700002)(5660300002)(316002)(16576012)(478600001)(26005)(36756003)(66556008)(31686004)(8676002)(83380400001)(66946007)(66476007)(4326008)(8936002)(2616005)(6486002)(6666004)(2906002)(956004)(53546011)(86362001)(43740500002)(45980500001)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmJBUGhrTklqbkF2aWlaZm1VWlhVQTJWTmVqK0ZRbWNJQVpSZVlMTDVHaFhG?=
 =?utf-8?B?K25UaENVYUJObTkvMVhreFJyVi9YVGVMV1pxTWxtVjNxN3QweWh2TlBhZUM4?=
 =?utf-8?B?UzN1L3pyUnFkd3ZlWDQ2a2NyL0JGd1h1QW9TdXJGbzRQM2pxNW1RTlV3dUlK?=
 =?utf-8?B?OUdnNE05OU8zamZsSklOaFhlSFRaMFZYMEhPbTY5cHB3ZDdpa0NpcHAxNkpp?=
 =?utf-8?B?RjJxR0VnQnJKb2hTQ1ozbjFteTFrUFhWMlJNclJTL0ZDcFFnL1pqRXo2M0NU?=
 =?utf-8?B?THdlOE9wV216Qm51QVBHRDdDem0yaCtoUitGei9BVm11RXhRWWJyNVAxQ0x1?=
 =?utf-8?B?N1VkMGNWMXd2Vk1LL2hIbnNBSjB0NnN4ZStQdTMwWDhhZEFwdTVIdVd3a1hp?=
 =?utf-8?B?MlJHVy9zRlQrcFJBN29QMDFNd3k0T2lTMitIUVhuU3BrNmtGMExxUVdRaWFG?=
 =?utf-8?B?Mnk1aFNpNGtyc3FyZHZ1NmNmOE9xSHdrdnJVKzMwRkJ2dmpBL1A0OWJ2RjFz?=
 =?utf-8?B?M1dDOFBjUEw1V1VjZCtlcHlIbkFPcy83aS8yY2xUa1cwS2dhS1NMN3B3TmV0?=
 =?utf-8?B?VThwM1J2MmNuWUNISFljZ0tXNzFFZTZoZDN5bnRYbDRhQW81aENIUlRFSkdx?=
 =?utf-8?B?aW1oMnZqbXJKOHVqdVNXeGY3RkQrSEJhZTlBdHlJc0hNYTA1WG4wQWxSUGNS?=
 =?utf-8?B?a0ZVeFRKWXZFbndMNlZBQ0FBSmJqZDlwWFV0NXZKUnRRSHNRT1ZSV0pBN1NY?=
 =?utf-8?B?V3hpNGlHU0lEeFhkSHZuakRodkR5NCt3N0lYdWZHRnlUL01vMUtTbm9OQW1u?=
 =?utf-8?B?TWYwVGhYZk0rWXdjUUl4ckhWU3o5OTFTdi9Nd2VXZDBTV2JmSDI5eXpCSTFn?=
 =?utf-8?B?OXdxYjJiZURXZHJ6d2hJNGxTZnVnVTFsTHJYRDFseFlYUGdVNXZUTGk1MVQ1?=
 =?utf-8?B?VGMrdzNJeVFBNHkyKzhZZ053UmNWb0trbmlYbWJuVjg1QUVKbVZHUTErUnE3?=
 =?utf-8?B?YjhYR0FLUVJMbE5qbm5rbXZORHMxV3R2UTdkVHZUWXFRNys0aG9HVUFkKzdW?=
 =?utf-8?B?ZEt2TG1BT1pEQ2JoQUhwTVhFZUZXOFZHVkM5SEVhMVVRaXBFV3JMcmpENVk1?=
 =?utf-8?B?QkFpTVk4NkxuWVRrY1VYL1lhTEFlQURnWkl2c2g3RHZqdmxkNFJURm5scWo4?=
 =?utf-8?B?TlFJN0FYejBhd1JBVFplRmp0Z3J0dis5MlBRK1cxdkp6clFKZXR2U2JQOFlx?=
 =?utf-8?B?eE1Vd0xzOHhrVEowbHJsYjk0SGlYM2dBU0lvOFN6ZnlkSUk0d1pTdTRMaVFU?=
 =?utf-8?B?WDFCRFhIWnZCNGp6S3RhUHpRbDdTK21BT0lSQWxiNGI3aDA0NXZXaWZKTGt6?=
 =?utf-8?B?ejdlVE5DQWpHRm1PcEpBcGZZVVcvTHNuaTl0c04vZGM4MGtFUHBEUDg1UUdR?=
 =?utf-8?B?WVFFbW9WdUVOaTROQWd1T2VTRWtXaGRlRndmZXRpYkFvRllWYTJiSE91RnFs?=
 =?utf-8?B?WStOQll4emhwckpsT3ltbVd3YTFzeE1ha1FDVlZMdUJVMGU5TWlEbjFuN3Fz?=
 =?utf-8?B?QkthOXg3QXNkZHB3MTE4V2tmRGVKMGZMRXJ5aXg2R3R6MENSbFgwL0Q0RFF6?=
 =?utf-8?B?S2U3RUhiSFdLdCticGJNZ0JyQmw2R2M2UUFkekhtSng5Wk9yZ3dFejZieHkr?=
 =?utf-8?B?d1d0SFlJUlhsNkNIemtLaVVLS3RlcElZcmRiSndCQkdsOWxBVnpOWVdVZ1FR?=
 =?utf-8?Q?mnYEwri+JFwIkwAneUWCqBWVM/e/S5mHloYIiOC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa8e32f-8eb4-4dae-b0fd-08d95b156c63
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 09:09:42.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tR4L2DIvGNtNYR83GA6x4dxmLzP22Co03zSgNlXezcglp5QuQA/QtiLf4AJ3MhTIxn3W8YocQvIxI9R0mbRxyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2021 12:02, Yang Yingliang wrote:
> I got a memleak report:
> 
> BUG: memory leak
> unreferenced object 0x607ee521a658 (size 240):
> comm "syz-executor.0", pid 955, jiffies 4294780569 (age 16.449s)
> hex dump (first 32 bytes, cpu 1):
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> backtrace:
> [<00000000d830ea5a>] br_multicast_add_port+0x1c2/0x300 net/bridge/br_multicast.c:1693
> [<00000000274d9a71>] new_nbp net/bridge/br_if.c:435 [inline]
> [<00000000274d9a71>] br_add_if+0x670/0x1740 net/bridge/br_if.c:611
> [<0000000012ce888e>] do_set_master net/core/rtnetlink.c:2513 [inline]
> [<0000000012ce888e>] do_set_master+0x1aa/0x210 net/core/rtnetlink.c:2487
> [<0000000099d1cafc>] __rtnl_newlink+0x1095/0x13e0 net/core/rtnetlink.c:3457
> [<00000000a01facc0>] rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3488
> [<00000000acc9186c>] rtnetlink_rcv_msg+0x369/0xa10 net/core/rtnetlink.c:5550
> [<00000000d4aabb9c>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
> [<00000000bc2e12a3>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> [<00000000bc2e12a3>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
> [<00000000e4dc2d0e>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
> [<000000000d22c8b3>] sock_sendmsg_nosec net/socket.c:654 [inline]
> [<000000000d22c8b3>] sock_sendmsg+0x139/0x170 net/socket.c:674
> [<00000000e281417a>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
> [<00000000237aa2ab>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
> [<000000004f2dc381>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
> [<0000000005feca6c>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
> [<000000007304477d>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> On error path of br_add_if(), p->mcast_stats allocated in
> new_nbp() need be freed, or it will be leaked.
> 
> Fixes: 1080ab95e3c7 ("net: bridge: add support for IGMP/MLD stats and export them via netlink")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   move free_percpu(p->mcast_stats) in release_nbp() and
>   fix the compile error when CONFIG_BRIDGE_IGMP_SNOOPING
>   is disabled.
> ---
>  net/bridge/br_if.c        | 5 ++++-
>  net/bridge/br_multicast.c | 1 -
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 

You can add a helper to free mcast stats and use it in the error path.
I'd like to keep the port dismantling code as it's currently done, moving
multicast stats freeing away from br_multicast_del_port is wrong.

In fact I think you can directly use br_multicast_del_port() as it's a noop w.r.t the
other actions (stopping timers that were never started and walking empty lists).
You'll have to test it, of course.

For this patch:
Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Thanks,
 Nik

