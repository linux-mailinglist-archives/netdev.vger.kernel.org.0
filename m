Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697523DEB89
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhHCLFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:05:01 -0400
Received: from mail-vi1eur05on2103.outbound.protection.outlook.com ([40.107.21.103]:38241
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234156AbhHCLE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:04:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i57yNRdjKr3jLQVPH2U7Y0x2i4r01nIprGGr2W/WEYkUNkT0t3LGMuDWbfcYlQuDXcKZ2T8vGxwmxzuseZR+0tSHXIRIvbRdWmey1X6el1F4KcaQSyKsme2QBg0J0+MbFIzXKfP8V+sRDpJOKHfn76o5W++NRNAmdo3naAKVjSFvLK8zCF0OydTHvIdFA8ZmZ0wQ/WNq/vaIG6L5u5HBl34/wvbwvVj7SpKeA/bcFsro6soY9dGQ01dqaBgEz3V/xNEe/VghM/OdEpWYmyyaDmJ98JagkjNNefBxS0lc2OiVO/oL+y0k+mNlfRymVzE0ymDBzd6fFuEj1BBH4O7iIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZZ6Hw3s6A2fuRmruc6nHo93ffBWQnRXeN7+5UVYY5o=;
 b=OqAy/Y0VKxuOURD3FusBgnwTR3lSC1ygpuc31ptvRs01VGoS1AeXiDMs+fUsTYMPJsAqWyGZoboFW1U04J3CqyNYMsNP1VHhkXM7CJERpNbY626jUtdNitr0dIU3Zr81x/eYyPl2R3OXi+g8NxnEF+2m5Tx6jbjHtQE7WEp0w2I5cW/6f2UO7BfhZ8HkmKmRpkWIqFPOSFrAhxvHQP/uvLrA8P1+7saCr+kmoZBXPiwlBDBW917gq9tQxHMgGSsCWMUQT9IaZsGUAvkpvQXAyuVjpkeDIvdbo5PyztNUXHiFL4cQQUq2sSDI7pkmmJHRpKjAQAS+AXzguTFBIY0GLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZZ6Hw3s6A2fuRmruc6nHo93ffBWQnRXeN7+5UVYY5o=;
 b=h2rUDMXltejK1eLv/P9P/cFyGBf14bkldpKt+qwzbVT7EGSLGXXDgca2POZ2IfYHewdZMJ+RjhITJMuemmGZ5gU2lDcwSFnUlo31Tdn2vMy9J8v6fCdKxPpabxj+Gpc+L5ZzW+zSolnogzwRTTMuHPKI8w8iyytNmFyhzl4QmeQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR08MB3085.eurprd08.prod.outlook.com (2603:10a6:803:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 11:04:44 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 11:04:44 +0000
Subject: Re: [PATCH v2] sock: allow reading and changing sk_userlocks with
 setsockopt
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
 <20210730094631.106b8bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9ead0d04-f243-b637-355c-af11af45fb5a@virtuozzo.com>
 <20210802091102.314fa0f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <ffcf4fe5-814e-b232-c749-01511eb1ceb7@virtuozzo.com>
Date:   Tue, 3 Aug 2021 14:04:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210802091102.314fa0f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0064.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::28) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.100] (46.39.230.13) by PR0P264CA0064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Tue, 3 Aug 2021 11:04:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f0cd14c-779e-40b9-db6b-08d9566e7ff4
X-MS-TrafficTypeDiagnostic: VI1PR08MB3085:
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR08MB308591EDD8504AA41D724EA2B7F09@VI1PR08MB3085.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 744v08q1jJlpIiwGglO8eBOPrRh5/8mJ7CTLb9LXA8wZfid3rpWj7NER3ZG3ZwoeTyTX0rqv4wGzzgAa94Qnhqx85PFHbRs8glZw4813/YnP8pDtPYQpMEqFWMIdP1Mr4KA17YleiqM2o0/s+FLP9XeZqcR19XOXa0GZ0cs+FmzyuUcI7Zz064UI+u334/Myvl1pShqR5X1Vtk5RE7Ex21yzUcIHyJMYLe5nOmgzU80CjAcrpjagJtSKiEiiphm/cQitrNrgbwu6JUSW/W6G4YQ/dfsRF6EObCWMoOJwjJ/3yzawz112G9AJ06Gn36QeZB5rBBXuuFQqt23RZQDFJSFJUtDUDzlCK/dX5wnGysD8/8sl9da+DNpPrO0xC0a5QuM/7HOj87Lt5XZGxUPOnTEvpw3g74vMfWvuAt9t039Q8so6s6BMJhkalj0gyr6UO4FT6HHgyH0hbKJ4g/I1axhOPC3GysMWRVASNV4O4vYnkxmOkc/SwhNiBJ/lP23cf2cgjNhCsh6n9mv695kdwpPVr/cyKj9HG7aJtIXbCJkoyFPu9Yytj3YZccytGfqbzYRBr/fe6LgLLhbJf37um1RToJY/4xo+IHvcpjhznfnUE+P+nLWnYPDLRj41yy2zITd/8fqVOI86nERR2Uaf+6HHAlcChPRHjmAu4NG2yhu86WNFiBTxIOn+6hhHzIBHouheVsZ+ofTvx3/61cLCdcODR/SZEMYKsrD6ykpd/wGClzuFyHdQ2T3/UtGOkyQURqpno5TQ7M/Ifk1HF6M1Uit2OCWQZ/m8A9FwOxCT4Wg3EBQ1dtrErO4OaZB1Q/RMRZ3ppUXrFvjuLijSHobVPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(39830400003)(136003)(66556008)(66476007)(31696002)(478600001)(66946007)(36756003)(86362001)(966005)(6486002)(6666004)(31686004)(7416002)(5660300002)(6916009)(4326008)(52116002)(26005)(956004)(2616005)(186003)(2906002)(8676002)(8936002)(38350700002)(38100700002)(16576012)(83380400001)(54906003)(316002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WS81My9HUXN5SGpGdlU1bkhMUmJCcTNVcUFEdFMwWFhqNWoxekRtNVQvcTB5?=
 =?utf-8?B?YnNtTjFTOFBKelRFb0xweG5PcG5VZGNxWTZHcXpsM3B0MTRUWWVoN1p6d2pW?=
 =?utf-8?B?MWZBOHhnL01QMXA4cDdJWkpoTkVHb3JjSDhrTUx6Q25VbkNVZXFzK3NmTzdM?=
 =?utf-8?B?M1pBMnJzMi9pN2h2Rm1zU3BEVEtsdTFWcG5SU0JteXYwZHF1NURRSWt3Yjhu?=
 =?utf-8?B?Z1lCZDlmcEVIcmw2Nnh3bUVmcVRYOWtRL2hXUGozeTl3b3VGVW4rVllyanFL?=
 =?utf-8?B?VDV3NTdnL0JRTW5PbTU4enZXaW80Z2hSRFR0Q2NnejN4Tk8wbVZ6cjRwUS82?=
 =?utf-8?B?eUNLQXhJM21HeTVyT1BKR3A1MmkzOGw2ZCtSMmx4NWRHTXI3V1dQaHpTS250?=
 =?utf-8?B?ZzYvbTMwdHFTbXc1am5BdnE4ODhKdUpNUW51ZjJZKzFQQlFIQXNZNEFscStJ?=
 =?utf-8?B?SDY0cFVidG1hTEhXQUgySi95MThibkdEQ3pSS011UHdLaHVWL1kzV1pqWDlZ?=
 =?utf-8?B?TmhFR3g5TUY5ZzlLcFl3NW5DVzVvbFl2NVdwbHJZNGtvckJwK1JUUGZCYlhW?=
 =?utf-8?B?eTVrTXNDR3JnZGc1c3c1L2RjWkVuOEZyWW9WS2pYVFRhOGp0U3lsaVZXUUJZ?=
 =?utf-8?B?cW9EbnRFUjd1YTJmYlNVekZlZ1IvUFN1UHVqdnJpenppdTJaWVB5TUVWZGc5?=
 =?utf-8?B?Sk1nYjdQWGR3QkVYSWsvSlh5THl2ZU5nOFo4YmVmZUtDb3ZRWjZoenJuWno3?=
 =?utf-8?B?aGZpQWw5Sk40QzJvQk5NWUJna2w0UjNkNmlJekhIenNjNkhLdWxtdjdsN1hY?=
 =?utf-8?B?ZkUrcW0wOWJpeW80TTV4bTk3LzVRRE0rUVhGQ2NkR3c2OXFFekRPYk5VUTVV?=
 =?utf-8?B?VXUwc2pwOFA5TWlvOG5yc1ZTMTdLRDRxTTBxUUFHcThBL2tpcW5lbGZBZWtP?=
 =?utf-8?B?cDk3ckpzOFduWWVWcG0yRTJJamloM2JZMlU1RDY5Ukc1NnkxdHlzcGozZktD?=
 =?utf-8?B?L1FuS1RVd1Y5MmU3MDR2NUZGSHpPOTZ5WEFnODhaNVJBSWEvT1FiMXk3Y3Ew?=
 =?utf-8?B?VzZDcnZSY1RWcWxvUWR5blg0MWRkaTJFeTZNQWNLQmlBVVBMYkErSTlldHor?=
 =?utf-8?B?bFo2TndMRkFkVGYzSllEeklZTVJWcmZ4eUJ6WWhCNVhXb1BTMk56NHdtWllI?=
 =?utf-8?B?Qk5sbFpFdjR5SVZmUkNjY012MjE0RG8vaUxSVVU0Rjlld2NWYWc1YkU2WWZZ?=
 =?utf-8?B?NUhTTmQxWUg3cjhBZGcvd1FZOVgwNkpSMHFvZ3pPd1hrbnpUeTBtQUVrb1Zp?=
 =?utf-8?B?NGh0MC9NUnRqVGMxVmNmNHduQ3pFbmNNa1h2bzRYMzNVcW5VelhqWkd0cDFm?=
 =?utf-8?B?S0VsTlQvWTNhUGpwOXMyUTJLOEdsM2o5aiswUDdoNlFQK28wcWZSZllnR1BI?=
 =?utf-8?B?Y3FheGkvTFVMeGxWY012S2R1c2tTdSswc3V2YmJVa1RJMXdyVFJGS0dES1hM?=
 =?utf-8?B?MlZjRkZteTNDdG5ESW5CazBLVTk1ZlozdkRHNVZOVlVjYm1vWkpnNXpSTERq?=
 =?utf-8?B?OWFFOE5ZRnNXYWJ4VWViTlZYN3N3V3NHRWJYQ1BheVNLQm1NbVhaRTMwa05Z?=
 =?utf-8?B?UFl4M1JLS0crWk5jd0xCLzJqWEhnU2UyV3ZWWWpHY0RFNit0UERrTTYxeWVk?=
 =?utf-8?B?UDNLQnk1eG96WnM3V0xhUWRqc25uYkVKc2orOEJiaFR4bkxQek1JbzdHd0R6?=
 =?utf-8?Q?RFsHq3rvWp6IN15wSJO7gy0y1Fnkzi0gpMz/g6m?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0cd14c-779e-40b9-db6b-08d9566e7ff4
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 11:04:44.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AyLODHWLC/+jv6cvS4kXPgN3AsRIjercvcmfGekem++hhKE6sMFEZCnAlHDu0xMAqJuBpeEDzy4AOeBBUpzwTQcwcz6fCpX4aQqQZnItM9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.08.2021 19:11, Jakub Kicinski wrote:
> On Mon, 2 Aug 2021 11:26:09 +0300 Pavel Tikhomirov wrote:
>> On 30.07.2021 19:46, Jakub Kicinski wrote:
>>> On Fri, 30 Jul 2021 19:07:08 +0300 Pavel Tikhomirov wrote:
>>>> SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
>>>> buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
>>>> tcp_sndbuf_expand()). If we've just created a new socket this adjustment
>>>> is enabled on it, but if one changes the socket buffer size by
>>>> setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.
>>>>
>>>> CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
>>>> restore as it first needs to increase buffer sizes for packet queues
>>>> restore and second it needs to restore back original buffer sizes. So
>>>> after CRIU restore all sockets become non-auto-adjustable, which can
>>>> decrease network performance of restored applications significantly.
>>>>
>>>> CRIU need to be able to restore sockets with enabled/disabled adjustment
>>>> to the same state it was before dump, so let's add special setsockopt
>>>> for it.
>>>>
>>>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>>>
>>> The patchwork bot is struggling to ingest this, please double check it
>>> applies cleanly to net-next.
>>
>> I checked that it applies cleanly to net-next:
>>
>> [snorch@fedora linux]$ git am
>> ~/Downloads/patches/ptikhomirov/setsockopt-sk_userlocks/\[PATCH\ v2\]\
>> sock\:\ allow\ reading\ and\ changing\ sk_userlocks\ with\ setsockopt.eml
>>
>> [snorch@fedora linux]$ git log --oneline
>> c339520aadd5 (HEAD -> net-next) sock: allow reading and changing
>> sk_userlocks with setsockopt
>>
>> d39e8b92c341 (net-next/master) Merge
>> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
>>
>> Probably it was some temporary problem and now it's OK?
>> https://patchwork.kernel.org/project/netdevbpf/patch/20210730160708.6544-1-ptikhomirov@virtuozzo.com/
> 
> Indeed, must have been resolved by the merge of net into net-next which
> happened on Saturday? Regardless, would you mind reposting? There is no
> way for me to retry the patchwork checks.
> 
> And one more thing..
> 
>> +	case SO_BUF_LOCK:
>> +		sk->sk_userlocks = (sk->sk_userlocks & ~SOCK_BUF_LOCK_MASK) |
>> +				   (val & SOCK_BUF_LOCK_MASK);
> 
> What's the thinking on silently ignoring unsupported flags on set
> rather than rejecting? I feel like these days we lean towards explicit
> rejects.

Will do.

> 
>> +	case SO_BUF_LOCK:
>> +		v.val = sk->sk_userlocks & (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK);
>> +		break;
> 
> The mask could you be used here.

Sure, missed it...

> 
> Just to double check - is the expectation that the value returned is
> completely opaque to the user space? The defines in question are not
> part of uAPI.

Sorry, didn't though about it initially. For criu we don't care about 
the actual bits we restore same what we've dumped. Buf if some real 
users would like to use this interface to restore default autoadjustment 
on their sockets we should probably export SOCK_SNDBUF_LOCK and 
SOCK_RCVBUF_LOCK to uAPI.

> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
