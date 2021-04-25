Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF09536A86E
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhDYQqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 12:46:19 -0400
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:46656
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230359AbhDYQqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 12:46:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNJkIeTFVS5jRAemNft1rJx2077dnW7a8sfp8IvAq7wu28gRQwRisU+x9djhfuCJbnZAxk0nAih49rfozEUJSDZ5cfyBDjdtcijcql6PB81YooYIC8YoDDLFjbLXASvgGK7avY4Ao7MMZ46PZTIipezRYUDZqSeDbYMiRxiS8a0amKYUQvRevQkseyAaRIjYbTvLqp+FcCfxBxypNYmxnbCo1OdoSlpGs3k975EZHtUoMGH0VUQkA4htX+9AdDjcRCvN159VoS+E6nn7/FTPipPactcnEgipyClsBFi7rkaSMGXT1UDoDOQDWcXQPNze6OxsEv8z9bSI/Vw23wo+oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEkoeTyegjO1k7XOGHDcE5f8uOI/emx6l/0U6mSNdOM=;
 b=HabVDNMlooKPfdhOeUarTfr5MIk8hjO3rZce4rmVjv0pH73lvitmz35bp0/eVUo2YTh/zg8jtmHpxCwNflYtIXvD4UgHkjyDlLqLZn+tYhJ5TZFHVgsVa/R29eL5JLP4XTHdYRvkgrel9v4yrlf/JFRgn60Ztv+VAzX2jAiwheO0XDrNIMAizJp8NwjfIro+hr+9HjLIVKQlBqoF7I3yKJBgEENLJeew87zHy5VJ8ZrEtWUBVNtVmW69pr/aZO1VVSCHYLOFeG9p/s0Lus6+F+PioMdEgRWFKyiqrKiWSp8r44CKZzzZwJT2nWQnNYSM1P1qCVNn0dAoWLGJw543Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YEkoeTyegjO1k7XOGHDcE5f8uOI/emx6l/0U6mSNdOM=;
 b=Ux+JF9biQFDKB25CT9H6kTMylUZ2/+nhTstXvlezTPkXdPCooCDpsk81TlaeyJobjQWcLkkz8hcGd4ZeBlLbEei6PeNSZA1DmyGo2kUJSsZSrSjbIgMNkPmhYMNX5NH0Yuom31PMOxIo4Prl4rjJVl8Qz6BK+wwQA8VutBUZFkDv/sHd7M9Z8lCEjGYhzDPaKdXZX/ReR3F03lNc6Exqlerx2GCkx8x01np+tkDrmmU8uziZ1o/C38R130DwYxdoaEN9Y89gKrBz9bM6L7VQQJrdZ8i8EUv5Opt70vvTWbi4z9u2+VejfP8kkBX/xW001tbUBuZnveY5ATWfivwJKw==
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Sun, 25 Apr
 2021 16:45:35 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.025; Sun, 25 Apr 2021
 16:45:35 +0000
Subject: Re: [PATCH net 2/2] net: bridge: fix lockdep multicast_lock false
 positive splat
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, roopa@nvidia.com, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, weiwan@google.com,
        cong.wang@bytedance.com, bjorn@kernel.org,
        herbert@gondor.apana.org.au, bridge@lists.linux-foundation.org
References: <20210425155742.30057-1-ap420073@gmail.com>
 <20210425155742.30057-3-ap420073@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ed54816f-2591-d8a7-61d8-63b7f49852c1@nvidia.com>
Date:   Sun, 25 Apr 2021 19:45:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210425155742.30057-3-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.78] (213.179.129.39) by ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sun, 25 Apr 2021 16:45:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85b8758d-982c-4c5c-9895-08d908098c8d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5214095CC88B7C92A3C69BADDF439@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MvU7KVPyMpdOsKpeXsZOvT101oIyWGVk9ZS++QU0hv75Oqn6lK/epE/UImtnrcPtxAgfO+5ta9gvK18yf/UHXvdY4lfLOsMq5qsCsxprP+jVvnBwWjiFYKfz9pEWugDaQ14cg4cCTg5FC4QUFHB/u3OIEWxmjW0D5O6GpH3KDec6d6JrebyWdiobfcWlJ26CPFFyAOGyPjareSzw611696V5wNi380hN1oAi0XzLfggbJGJIURDvTC4UAjwTnz06C7eWG/swtR6kNWDxs45GA4bW+4tvhkYqaVeE7a8I2RbRNTEdA3OgToGFpVOckLIE7CgCYKqN4zkuFk030/bMHLLIvBezwd6oxB9oOkNJtLU5tusbijfslClpFxMSoAjaJZbyT8qyjJD+WM3RAWU+bNpcxwDVaeN9QWhGBZU6LMpy17xCrlVK9raEb85zfyk2UEoIuZMo5yjmHuwt0PgrO4tmL8Jcou3jYHtU4b6nKlGfayE34ts0bL8BQbGA0W8JQyx7XRxbg4Ry5lab1RaLRxVAmzIe9l/AvL18AMFCQkA5zZcD7yASil5c57dp7fY9BtqXy0/uvM8GxkorzuYpG6K6kfN6CguW2Ar8YlFj5F3KgKBE/Lmj/rF/xZ0tndIbPcENPxE+FGRkLGKEpQV8pMU4N9+HpWS95n1WNwUZw6KL8bOgRnW74SSoticFO7QHDCTX4cu8L66FNXR62Q0cwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(26005)(186003)(66476007)(66556008)(2616005)(6666004)(31696002)(16576012)(316002)(8936002)(53546011)(921005)(2906002)(7416002)(16526019)(956004)(66946007)(478600001)(38100700002)(8676002)(86362001)(66574015)(36756003)(6486002)(83380400001)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QXZnZThGVUFSaStxVHVNbFVKUHJqVWZaUGZNZm1OckRidnhTT1NEbU5wU2Zk?=
 =?utf-8?B?NE5jdzZsWGd1dDZFbXBOZjQ2RCtBbS85akFIWUM0eGU2aE0ybDN1NEY1OTVT?=
 =?utf-8?B?Y0x1TWt5QmtEYjc2Y2RIRDZoZ3lFZ0JoaFpFU2NtdXV5b1hxcFFWUDNNMFQ4?=
 =?utf-8?B?eUJaQlpsL21lLy9hcXlSaEdPeU12S1liekNIZ0lqSG4zM0hQY0ZOME1JMlNo?=
 =?utf-8?B?VUNJQkVKcVBVQXM1R2wycHltQ1lQbER3Z0NvVFhOUzk4RmRKNnVDSGNtYmtF?=
 =?utf-8?B?Sno0ZXdkdGVBTXlhaEVtSkhjNXMvbkJ4QU53WUFsM3RnMFF5L1NnTGVhZ052?=
 =?utf-8?B?SGFncWR2TEp2MEkrR09BelNqTFYyRmg0cHdqWHRBT2F3Q3FlQ2s4Z2VPd0My?=
 =?utf-8?B?K2ZpekZrSHc3WGxqYzRkRWVuTitrZytlRFYvYUVLeVZzMkNhUnpleHhiS21T?=
 =?utf-8?B?MCtlOTZHbDlFOEg1RTJSR0U2ejZyMklLYUV6WXB1clI4bFp4Y0cwR1ZUS3J1?=
 =?utf-8?B?ZE1ZQ3ViMUVCVXNHQVpFb053REJwNXJDckVlTGp6eVdzMnltdVdEeTJYeFh3?=
 =?utf-8?B?T0RUb1o5KzFSTm5kUTV1YjRUYTMxMDdCdzZselVGaTZSM1pRVkxTT3RFUlA0?=
 =?utf-8?B?b3dvQmpNakZFR1B0aFFSTG8xRnBaOUVGYTJNQTRKWVpUWG45Z21Icnh1SzRW?=
 =?utf-8?B?cm0wb3JkakVzZ284Z1VCT0VLczNuTGRzbDJWYWNqamN1SVdNdklja3lHYUNX?=
 =?utf-8?B?ek5yK1FvRms4VjdSZDFUL1pMWFRuT3VWemR1RWNUQ0gxeU9sc2dGdG9JQUcz?=
 =?utf-8?B?SDF5OWZFOWJqbk52TE96ajRWK1RleUg1ZHV0b0VORnpUbVpmWEVKSThuN3pL?=
 =?utf-8?B?U0xXTzUvTVpaNE9oMEV0aE94VnIzR2xDZ1QzYlI1RkVrN1lpb1I2RUFiSUM4?=
 =?utf-8?B?eHZIZ3ArQ2IrYTFvSVNCMjNSZFVEQ2FlaUVtQklDTng5a2VkV3RDY2tYbzgw?=
 =?utf-8?B?Q1R1U2NXZjdpZ21vNjd1OFFrTDNJYlF0TnovdTFqZlpLZ0lzaG8zR0hQMTdY?=
 =?utf-8?B?ZzdkQ0NFUk5EcmlvdWZXY2s3dTM3aDRTc0JUb2RTbndoWUhtc2o5N25RTjVV?=
 =?utf-8?B?Wmw5UmZmMis4S1hXZDVWY3hTemU0RWhISzZMb1I5SWJHT0NKb3VJQ09uOHM4?=
 =?utf-8?B?YmJEcmJyeXFaaWRodmVHMy91VmpjQmY3ZUMzdTNaN05ZR0YrSHZzK3JoRFZF?=
 =?utf-8?B?c2x2M0lnWVZXSlZsU0treVM2Nmg3bnlleDZJSjZvYjZxMUp3ejRENXpRS1pN?=
 =?utf-8?B?QldEOE83YnN4cm53YnNQemh6MFJMcWcyQ2pQYk5YeU9hMTlMZjFZY25DSmJt?=
 =?utf-8?B?TDl1dVNEMVE0cDd4VkNnNERIT3hxS1JzS09IMHozU2tqQ09xZDhCNnZha0sy?=
 =?utf-8?B?SDdMV1FoNTRHMEhFOVJTV3JmSjBjL1RsWHlHOE9uN0UvYm1FakkvbGxQUWFv?=
 =?utf-8?B?cjYyZzlRU0tVTW14cHFDbEttTlZvRGZESG0xbWZCRnZYOVY3RjFvYjR2YU5I?=
 =?utf-8?B?bTN2TUdpb2ZXT29acElzMmhaaUl0eit1K0c1b2VJemJHdWsyYzBOMVdKaTQ2?=
 =?utf-8?B?aHJIcFBGUDBSMVlkbXZYMGN5UVIzZSt5ZWFFSVFHVSt4VjdaNXJsRjRqOUIy?=
 =?utf-8?B?NmoySGJiQjcvR2phQVBlSUdZcEF3T1JFKzdtRGJsaTVlQUM4Z3Z2UmtvVUxB?=
 =?utf-8?Q?eQByvX7QBSfU2pM12f/B6ud0uqUsLMLFZz8FZOH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b8758d-982c-4c5c-9895-08d908098c8d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2021 16:45:35.7643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rd+Z/UVq38Ol0ARxNi/XqLCkc0ofRagxoeOyw2oi3LeabP+RjX1EbA0UEDd/yeRLcpfYrm1Z0e6ZoFNuBeJe1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/2021 18:57, Taehee Yoo wrote:
> multicast_lock is a per-interface(bridge) lock.
> This lock can be used recursively because interfaces can be used
> recursively. So, it should use spin_lock_nested() but it doesn't.
> So lockdep false positive splat occurred.
> 
> Some inline helper functions are added.
> These functions internally get 'subclass' variable, which is used as
> parameter of spin_lock_nested() and use spin_lock_nested() with a
> subclass parameter.
> 
> Test commands:
>     ip link add br0 type bridge
>     ip link add bond0 type bond
>     ip link add br1 type bridge
>     ip link set br0 master bond0
>     ip link set bond0 up
>     ip link set bond0 master br1
>     ip link set br0 up
>     ip link set br1 up
>     ip link set br0 type bridge mcast_router 1 mcast_querier 1
>     ip link set br1 type bridge mcast_querier 1 mcast_router 1
> 
> Splat looks like:
> ============================================
> WARNING: possible recursive locking detected
> 5.12.0-rc7+ #855 Not tainted
> --------------------------------------------
> kworker/5:1/56 is trying to acquire lock:
> ffff88810f833000 (&br->multicast_lock){+.-.}-{2:2}, at:
> br_multicast_rcv+0x1484/0x5280 [bridge]
> 
[snip]
> 
> Fixes: eb1d16414339 ("bridge: Add core IGMP snooping support")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v2:
>  - No change
> 
>  net/bridge/br_mdb.c           |  12 +--
>  net/bridge/br_multicast.c     | 146 +++++++++++++++++++++-------------
>  net/bridge/br_multicast_eht.c |  18 +++--
>  net/bridge/br_private.h       |  48 +++++++++++
>  4 files changed, 158 insertions(+), 66 deletions(-)
> 

Hi Taehee,
Ugh.. that's just very ugly. :) The setup you've described above is by all means invalid, but
possible unfortunately. The bridge already checks if it's being added as a port to another
bridge, but not through multiple levels of indirection. These locks are completely unrelated
as they're in very different contexts (different devices).

At the very least please push the rcu_read_lock() calls in br_multicast_lock_rcu/_bh() 
as they're needed only to get the nest level for netdev_get_nest_level_rcu(), we don't need
them for the whole code paths (right ?), we could save a few lines in the process and
avoid confusion about the locking rules for those code paths.

I wish there was a better solution.

Thanks,
 Nik

