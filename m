Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2028241CDF6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346440AbhI2VXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:23:47 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:55777
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232258AbhI2VXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 17:23:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zuqq2yon7XorWl7XQVpLzoXKcZb1TI4StW17gnNrHUqWWWbLlZYbcsQkn3y6JdfmZKv1UEcDLTEiF6F0geticTZde3nl+G/BxzvC9s3ic5JKM82RH+elprbmjaNUpkJECyGSbBUl8jaoGx/U7zRnt1SG0Y1qLODEphAhyAaiNrXEo3p2ATNIqNtpnShwd6UtOjYGXITT6Qtp453C0dd7CrqJX1lr84DWub/dprpvievRxdF4oHHKMXJrcERQaktAjaK7bN1cVyAbjhUHK+sHTICBqS/0HoE28obsyiWTPKqxOlNmBkmbaw2BZ1KcOFp2kDbpRFOGY1A6/0S7qrifKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4znpvH+yBbLNU9e83SSO+itNvhW7Vlq0MTpFdXC7g6U=;
 b=KmS6NvWOZKZMHSQzPqrbJNvNZIJDgqv3XJe8+V/VqXWt6a+WO2YNE69bsizcvWbvhf1F4kzVMczaH6Fi2QM4gG5vQBYWbI6hdW2jg6lmM4rNCp8MvF3GBWDuV46f+34KC/6AQB1gSphOOCysLSk1+a7DEeXKByL/KaUorNqtB3qxsd7I5WVzPVUmBlgFbFdILYPwekH49BpBOcF0T2PSgV/JB0yAsezOERbjgS3uMiflm6RL5bNt85QRl40QmJB1j742ercYh7HzgmOXXhaOMp/vtAXga2wH979jjdMPk/NCTPU6wwCNh0ENhL3z6jx9Uu0/09u8U2e51Cy6v5aBsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4znpvH+yBbLNU9e83SSO+itNvhW7Vlq0MTpFdXC7g6U=;
 b=P3j21FtMVWpTZ7xNHjithrlCPIYiCCaHrIJVPX6WFZb1OMg0O5zUSgsXt/p6K/cKkCXlasxyJb5Fy3KPSk5WbVNktGulCFuQPrOCP4KNXIdQryuykwitle0wV+bk/Z6vibszmr2P93cAOX5n1X7AlKBYtB3zCQMaSn+Nj4BxUgrksYht/CKXG9r5X80rNWvmQkFE3JLOBzsVlHpzwOSbW4wrMS+swoPEcBdGRv4+gE3N8xW4WAmjw5rChxD4xPiSSrK6jsrbaqCmNxT/mDwAfCpluGdYOlZcDNjWrBylgoT+XKiBp0pCLKRjt4h4+K3WHT9x3cz/cuJNrvfw/YOsjQ==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5118.namprd12.prod.outlook.com (2603:10b6:5:391::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 21:22:03 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c%8]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 21:22:03 +0000
Subject: Re: [RFC PATCH net] net: dsa: tag_dsa: fix suspicious
 rcu_dereference_check() with br_vlan_get_pvid_rcu
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        rcu <rcu@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <d22b1596-e9ba-307c-7033-20f6a074a9df@nvidia.com>
Date:   Thu, 30 Sep 2021 00:21:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210928233708.1246774-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0149.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.119] (213.179.129.39) by ZR0P278CA0149.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 21:22:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24e0ac28-b961-4c37-b4f2-08d9838f2e42
X-MS-TrafficTypeDiagnostic: DM4PR12MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5118A40E839A6AA597827FD6DFA99@DM4PR12MB5118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mI50z2CKkk3Za9YNKfikNGna2ALRoD1jcUzJSnobnz8I1iSyO2fhmiyhkQu0AM9ukZ9HPzbO3Of3aRO1WQkcgA6SaJxAO0pdAwlPCz9tZm6zmOUkL+2uZyKA9KUGpQKVPG2M+z6KmSuGDYK/lg+cBE5gzON+SVXc0NFQFJ7hqDlMaJyRR+JU3ZMVqLC80HBbLmMd8QVt+sZpLqUpCE2QTl2laSNcHLwQOTXpQiHFDLSvVbjwkg+s/pM2WCNtU5kthap7hvpThANB5S5VrkdENleaLi0y0AXvqICBTmi5+swkBufo120wvehR35HzVSlpRybaYOFRDncZ9mGHo/wQ5M43Vpfy67CcLum/Pe/WhlS0tOd/oRvkx3r2/KD/vXZYc1fISuz8OwlJq/3vHY2JwGa1g4yChPe41xggz1O5qxNZaBXIdcLZccAI1D7avTpg56D4lqnRRd7pPQV87FD7XREBb5S3x4YoRTjrGgUu/m/Z03kQyLymllFQROdKDrVJlxesK7p6v2y/iLIkixVHbqXMkEUKl88vQzIptVGFDIcIYal9e8ABsxozhT8sESwNfDGWvqzGM/LY1Yq+WAyphW+EjfIqJ2Ke4nzrMcAY0eujCcv7JVFofjoq5l4VGRFAlDPIBNiKD6YRm/k/qUbAQDaYa5LeccyTaamMEdYMC+0NWqvU7oSBM9Gzw2T6SZSM3SZc/d6IRPe/zX6tpIGu1eZ3ViMMudNUpc1bvFf8tMXH+71grijCtxizggdQQKsxllPs9qSl5hu10tKVXYBvVRXSb/XO9MoYsDEtBI/k2lILSc2KRThyIJjBcvDfyoSi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(2616005)(66946007)(2906002)(8676002)(7416002)(66476007)(66556008)(956004)(36756003)(8936002)(6486002)(966005)(86362001)(316002)(54906003)(16576012)(26005)(508600001)(6666004)(53546011)(5660300002)(4326008)(31686004)(186003)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlAxRko1Y0NidUZlb1c4WVJ3SEJpOXVFa1FkVGZMSlJpUkNKZzZDdUZMemJY?=
 =?utf-8?B?VHg1UGZjUjAvcitTdVExTDhYelVtOU01YUVJZ1FVYUlObFBHeVR1aHUyTnFn?=
 =?utf-8?B?bDlpb00xejdwb1hmditqc1prcmZkNTl6ei83MytwOS85Q3JrbkVGc2hXcURq?=
 =?utf-8?B?M2FPaFc0N21JNzdmc1YrOVZ6N2Fzc2t6enJ6NTltbWxNR3FkRjg4cFVuaThy?=
 =?utf-8?B?QnpIUHpWR0l1UU5Ja0h2OTkrSy9mK3d3OVRzWE1WZG0vNXhJbU8rOVcwZWVH?=
 =?utf-8?B?VDlPV2NlRnZVUmQvQWFqdGg5R3ArT3FWN2tucEhUOXpGSGp1aEpaRE1EUFVy?=
 =?utf-8?B?WU10U0l5ellSS0o4djIxVVZRODNzSTBUK2w0OWVVVVBtMlkwSE9LYjhNYWJy?=
 =?utf-8?B?UGUveXhORkZNUm81RTVzdWNYeUp3SmwrRXFsU3ZCUzJsbnJseDB6MDRqVk5t?=
 =?utf-8?B?WVhoczVtcTdXbFNwVVNDc0NRMTdCVkRIQ25yd1hsdkEvdVRNRDdwd2NZRFdV?=
 =?utf-8?B?anpiaG53cjBVR2ZMQ09oODM2S3doZWh6Rm9EL3RqRHlHRThjNXE3bVNaSkJi?=
 =?utf-8?B?djdzbkhERzY5TDA2bE5XL2ttSVhJeGJJYU00TWNBTzQwRTRQTEdTNmNzdVVL?=
 =?utf-8?B?U2tETmJoVzNrV001Z3k2WXIxbnJ1NFVicUFBVVFOcUlYVDdXeDJmcmlyZndh?=
 =?utf-8?B?NS9keHZVWGIyOWlUM05aU1FWb1gyTExGbWU0ZVRzemtGQnVXTzRlYVVEQmpS?=
 =?utf-8?B?ejJXTG5ieUh4b1I3ajQ5eWZxSk1yUCtNMG5EYnVOTE5QWS9mZFAxMEhuWS83?=
 =?utf-8?B?VnNwNEZoc3h6ZnhNbjJITVliazI2Q1lndCtjVW1IR1JDc0NIMmFoNUU5V2Q3?=
 =?utf-8?B?d3I0QkhCVGMzRlZFdzVZNTVVZWxTSVJsbjkycGJJcFFHL1pJUjJ1WHE4SWtF?=
 =?utf-8?B?ZjhUcmtudDkxWXYrVW5ZS1dXV2lpYXZrUkU2M0tuQTBRbUFJY3pCeXkxZDNJ?=
 =?utf-8?B?cXQydWhqeW42Yk9iQ2F3YTF1N1Rrd3RISmZhQ1FKN0FtU1N0cGlrbElLRU5Q?=
 =?utf-8?B?eXBZMjJkN2JEYUNadEZ6NG94cGI5eVo5RExsNXpuYnhkaTJRNVFBd1VMVEZh?=
 =?utf-8?B?Tng2TXBYK1dTd2VjbkU0S3o1ZzQ4NjBDSFpJem04eFFhelV3RUpzSThpSUcv?=
 =?utf-8?B?RDdUalJyYkJ0Q1ZVVmNpa0tUM3EyTEFyWm9wV2tqUVg1aS94UVNuK1FaVmJH?=
 =?utf-8?B?T0x3eExoT3BLYVNiVVdZbTRuY0NEdjFwNHZLUjEwRFN3SUdyTDE4ck1iZWVH?=
 =?utf-8?B?SHBGMXdjSTlDa3Vmdk8wd2NONDBUODJHaGNrTGhnUjlWakFNeUI2ZllIa1RZ?=
 =?utf-8?B?VHJoMFhIMTUyUGJaNzJtN0hoYjdqRTJJS1p3MWlzdk9YS2w3MHdyV3lOak5x?=
 =?utf-8?B?d0NIbWJrQ1J6SDN3ZjRaaXVVbERCdDRuRzdaUGtTVyszb093Y2hPTXdwLzVl?=
 =?utf-8?B?b01YUSswUEFOUkxtQkUxejNycXZBQzFTOUpZRWNIaGFtVWtSY1QwSHRQeXh2?=
 =?utf-8?B?WEQ3ZGw0WWg1MTBMM3c4aE14ZnV4UWs3c2RxYzNsRk9XbWVlUko4RGhQbDMy?=
 =?utf-8?B?RUV1aVFOTW1wU09qd2Iwd0ErUjFmZ1g1Y3MvbEJQVDFnM2NYSFRnYkpvU3dY?=
 =?utf-8?B?akhPeWVXRjRpVURsT05RaUk3UWVqNzZVMjhIWWhpTlVUeEFiV3ovR2dEcVlN?=
 =?utf-8?Q?lBAv43brxZpqqDtljEJ/Rwo8Nm1HckB0/1ueUwT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24e0ac28-b961-4c37-b4f2-08d9838f2e42
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 21:22:03.0416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fLADBorbW6N7kkZP3Pz433hFhTx4gGpbnmUz2dceD+i/9T31Hqd+EthXIsVcguD0ZGTdYqCfTbj2oVhLulp9hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2021 02:37, Vladimir Oltean wrote:
> __dev_queue_xmit(), which is our caller, does run under rcu_read_lock_bh(),
> but in my foolishness I had thought this would be enough to make the
> access, lockdep complains that rcu_read_lock() is not held.
> 
> Which it isn't - as it turns out, RCU preempt and RCU-bh are two
> different flavors, and although Paul McKenney has consolidated
> synchronize_rcu() to wait for both preempt as well as bh read-side
> critical sections [1], the reader-side API is different, the lockdep
> maps and keys are different.
> 
> The bridge calls synchronize_rcu() in br_vlan_flush(), and this does
> wait for our TX fastpath reader of the br_vlan_group_rcu to complete
> even though it is in an rcu-bh read side section. So even though this is
> in premise safe, to lockdep this is a case of "who are you? I don't know
> you, you're suspicious".
> 
> Side note, I still don't really understand the different RCU flavors.
> For example, as far as I can see, the core network stack has never
> directly called synchronize_rcu_bh, not even once. Just the initial
> synchronize_kernel(), replaced later with the RCU preempt variant -
> synchronize_rcu(). Very very long story short, dev_queue_xmit has
> started calling this exact variant - rcu_read_lock_bh() - since [2], to
> make dev_deactivate properly wait for network interfaces with
> NETIF_F_LLTX to finish their dev_queue_xmit(). But that relied on an
> existing synchronize_rcu(), not synchronize_rcu_bh(). So does this mean
> that synchronize_net() never really waited for the rcu-bh critical
> section in dev_queue_xmit to finish? I've no idea.
> 
> So basically there are multiple options.
> 
> First would be to duplicate br_vlan_get_pvid_rcu() into a new
> br_vlan_get_pvid_rcu_bh() to appease lockdep for the TX path case. But
> this function already has another brother, br_vlan_get_pvid(), which is
> protected by the update-side rtnl_mutex. We don't want to grow the
> family too big too, especially since br_vlan_get_pvid_rcu_bh() would not
> be a function used by the bridge at all, just exported by it and used by
> the DSA layer.
> 
> The option of getting to the bottom of why does __dev_queue_xmit use
> rcu-bh, and splitting that into local_bh_disable + rcu_read_lock, as it
> was before [3], might be impractical. There have been 15 years of
> development since then, and there are lots of code paths that use
> rcu_dereference_bh() in the TX path. Plus, with the consolidation work
> done in [1], I'm not even sure what are the practical benefits of rcu-bh
> any longer, if the whole point was for synchronize_rcu() to wait for
> everything in sight - how can spammy softirqs like networking paint
> themselves red any longer, and how can certain RCU updaters not wait for
> them now, in order to avoid denial of service? It doesn't appear
> possible from the distance from which I'm looking at the problem.
> So the effort of converting __dev_queue_xmit from rcu-bh to rcu-preempt
> would only appear justified if it went together with the complete
> elimination of rcu-bh. Also, it would appear to be quite a strange and
> roundabout way to fix a "suspicious RCU usage" lockdep message.
> 
> Last, it appears possible to just give lockdep what it wants, and hold
> an rcu-preempt read-side critical section when calling br_vlan_get_pvid_rcu
> from the TX path. In terms of lines of code and amount of thought needed
> it is certainly the easiest path forward, even though it incurs a small
> (negligible) performance overhead (and avoidable, at that). This is what
> this patch does, in lack of a deeper understanding of lockdep, RCU or
> the network transmission process.
> 
> [1] https://lwn.net/Articles/777036/
> [2] commit d4828d85d188 ("[NET]: Prevent transmission after dev_deactivate")
> [3] commit 43da55cbd54e ("[NET]: Do less atomic count changes in dev_queue_xmit.")
> 
> Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/tag_dsa.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

To answer the question about the patch - it is correct and ok, the dereference needed
is done inside the function and after that the value is copied. I'd only check how the
DSA bridge pointer is handled, it seems it is dereferenced directly and I don't know
the DSA locking rules (i.e. if anything is held by that time to ensure the pointer is
valid). As for the patch:
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Cheers,
 Nik
