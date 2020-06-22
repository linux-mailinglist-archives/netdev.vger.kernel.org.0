Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C76D203F1A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgFVSZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:25:28 -0400
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:56406
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730139AbgFVSZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:25:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNZcmyhgeXk1OrWCU16/fUT35r5tLFxxpKvihFP91SamAqQGRQCO6XkqdM70BlvX/BwYsPUjVwcGJ/qFa9xfhoghYLZn0ns8zebnM2/HxpxLrDLAgFy4r4lv/Ozz+TWr9nGDNrWkoh/Hr5Q1NGpU9J5Tdd1iRoShKZ8DycWnpAONHDEpzQ9CzKgQOi/EouZLIZgAx7Yds90jI1jbt7giCVjF6wahHVntYMzxrtcDDDVBIR6dVSGHRkXnkbh4QsDYW5tKZMgL9ZRPiySLtRxfwFtLm0foeJsZONhdMaI+37cmVPGosp0DTFNKCiSscsmy+mrTJIFCgtnZZ+/9+OnXAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60F5CKoKEITDS8gYraUVzuRes/TjuiHQq/ISNAnJUaQ=;
 b=emcVX/0AmHjuzcLs4RK+qOK9rzFU2XhXSRT/Hn1Gdn4U+riPE0MT+uNpbeU6zz5ohr62NS/aip3lfg/gLBQSxj2GKojmem7k6q3yK/e0kG/vt6ovmHN7VxDQ1soQ8EkpABLX0ZiTinc6Nad4oQMrnc3EyVdmKMXmEcY9c+5Uo9ChmMoabZSMkUuvARfYzmufRt9NjpVJMGHOGj7qYoBcz57TE3HOiABahJ+6t2pycOCHUuHK0R3rST9ki85gbXutkOOa+L+x96JEmyRek8IamFkwI6cnSaPX790E9QIIztb1kZnKFcyCYt+Ofe6fp1uylnOEMawSKtMKhVXroqu8aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60F5CKoKEITDS8gYraUVzuRes/TjuiHQq/ISNAnJUaQ=;
 b=B0qjtmBw3zprNXjJ5S67vJ8AaNazT6a/U6urySC9EuBP8VX5XLxdskYPVE/1n69GqM1JV8+31WQQlrhnzzXQOKUxGsE6VWjQaEcOGTFgx+axSjFm5wlyJvQ7UkXgeeitYwo0xO6gKE+0yx5Bkwsv2YWpz55YKZFQIWVrnU2fa8o=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2703.eurprd05.prod.outlook.com
 (2603:10a6:800:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 18:25:23 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 18:25:23 +0000
Subject: Re: [PATCH net] net: Do not clear the socket TX queue in
 sock_orphan()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <1592748544-41555-1-git-send-email-tariqt@mellanox.com>
 <4254dfec-0901-73c4-a1f5-c6609db2baec@gmail.com>
 <d5d84b99-0ee4-b03d-d927-d9dcb8d36326@mellanox.com>
 <8c810aec-b715-6fe9-2f33-f9f815e67fa7@gmail.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <a1032873-1729-c0c6-4ee1-531cbe5e3030@mellanox.com>
Date:   Mon, 22 Jun 2020 21:25:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <8c810aec-b715-6fe9-2f33-f9f815e67fa7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0010.eurprd03.prod.outlook.com
 (2603:10a6:208:14::23) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.75.30) by AM0PR03CA0010.eurprd03.prod.outlook.com (2603:10a6:208:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 18:25:22 +0000
X-Originating-IP: [77.126.75.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49645f0c-506b-4238-e857-08d816d9a0a7
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2703:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB27031EEFCD95D1F184C31663AE970@VI1PR0501MB2703.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UbjOK0syC5wjJgWD3nEzSNtVNr6+/SsdUa7YyubxoJg4QUcI8pfIsOs2rgGagDAnMMAUdAU84aSh7EzXOtI/boSzRH/JwTppW88e4/duk4Yf6hKjuY7HhBzWZl/e55FSKEQvLJj0lqi8a/l1jdyZ27WgwLGywHJQiP8hPbFyYm0XoSNbEeNMUzCkCdCKUQgtPWCoZVwRWtBuIO3lmwWnCZpyRNb6ZqOI1bsWUlFVnPdOpc+9NFHt37E3xH1dXjdn5QIXjpkpZIsg/dtVW8MNBZNzXj3ZkBk2njYF/EJrlEXDp14kdiZzrSktAqyaIBkwOW4P24gQFtfP4K9w8YptoODRYMmPUKcBRkQ74fxkE/X3kAXpoLs18wyxVEsrCDeq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(316002)(5660300002)(478600001)(8936002)(36756003)(31686004)(110136005)(4326008)(83380400001)(54906003)(8676002)(52116002)(66556008)(31696002)(26005)(66946007)(66476007)(2616005)(16576012)(186003)(16526019)(2906002)(107886003)(6486002)(53546011)(956004)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sl5qpDJm2mt1O5dIW4EaZtBx8MXlul07lzMiOrJgfIIfUrD7DWO8TPD7E225mRiG6COnO1Cm6RykSCqp/FTvknhUKxuCcnbBVxaSOjO8e20J7ZrUX1vHnX4V7X3d3gQmm8wxpq7b776ZhhGknEjQYnKWg+t8x80f07KN2hPumX9nKxEIFFT6Vt0MfItqduf+Rme95vLmAOmFE2P+wUIeKffd8VwlN4BHCz89+847ClpGlIUDKwc5/g2l96wd2eB2s1zHT9sZ42Rdorm67sv3wDrpf+82WEqksBCJDHO2eASCWYcdDee0pa/kNMJp5V4LUTEpkKbSSzideWORS9kc3qkmDQdI/NlYnQ/01Ec3mn0cJ7NgyKR2vPWt+xudR0hp9UWe6exHf5fPMTziNlxv4PqJZXLMCMUakvDv69Jc5wD/KTpu3KRrawDrFqNMeDEvcIxf0R3LsRjWypVboQNh+hLZpAjCf+MGN7KZhOJPoFU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49645f0c-506b-4238-e857-08d816d9a0a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 18:25:23.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HILo7+TvmSYe2e0gz0ts3RIHBTUyG8c+AjKD/Ac18EmUsVoU0N2e3BsqJ/4KD6AUeBZ50xEKelcyRkKMBywylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2703
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/2020 7:56 PM, Eric Dumazet wrote:
> 
> 
> On 6/22/20 9:24 AM, Tariq Toukan wrote:
>>
>>
>> On 6/22/2020 6:53 PM, Eric Dumazet wrote:
>>>
>>>
>>> On 6/21/20 7:09 AM, Tariq Toukan wrote:
>>>> sock_orphan() call to sk_set_socket() implies clearing the sock TX queue.
>>>> This might cause unexpected out-of-order transmit, as outstanding packets
>>>> can pick a different TX queue and bypass the ones already queued.
>>>> This is undesired in general. More specifically, it breaks the in-order
>>>> scheduling property guarantee for device-offloaded TLS sockets.
>>>>
>>>> Introduce a function variation __sk_set_socket() that does not clear
>>>> the TX queue, and call it from sock_orphan().
>>>> All other callers of sk_set_socket() do not operate on an active socket,
>>>> so they do not need this change.
>>>>
>>>> Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
>>>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>>>> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
>>>> ---
>>>>    include/net/sock.h | 9 +++++++--
>>>>    1 file changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> Please queue for -stable.
>>>>
>>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>>> index c53cc42b5ab9..23e43f3d79f0 100644
>>>> --- a/include/net/sock.h
>>>> +++ b/include/net/sock.h
>>>> @@ -1846,10 +1846,15 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>>>>    }
>>>>    #endif
>>>>    +static inline void __sk_set_socket(struct sock *sk, struct socket *sock)
>>>> +{
>>>> +    sk->sk_socket = sock;
>>>> +}
>>>> +
>>>>    static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>>>>    {
>>>>        sk_tx_queue_clear(sk);
>>>> -    sk->sk_socket = sock;
>>>> +    __sk_set_socket(sk, sock);
>>>>    }
>>>>    
>>>
>>> Hmm...
>>>
>>> I think we should have a single sk_set_socket() call, and remove
>>> the sk_tx_queue_clear() from it.
>>>
>>> sk_tx_queue_clear() should be put where it is needed, instead of being hidden
>>> in sk_set_socket()
>>>
>>
>> Thanks Eric, sounds good to me, I will respin, just have some questions below.
>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index c53cc42b5ab92d0062519e60435b85c75564a967..3428619faae4340485b200f49d9cce4fb09086b3 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -1848,7 +1848,6 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>>>      static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>>>    {
>>> -       sk_tx_queue_clear(sk);
>>>           sk->sk_socket = sock;
>>>    }
>>>    diff --git a/net/core/sock.c b/net/core/sock.c
>>> index 6c4acf1f0220b1f925ebcfaa847632ec0dbe0b9b..134de0d37f77ba781b2b3341c94a97a1b2d57a2d 100644
>>> --- a/net/core/sock.c
>>> +++ b/net/core/sock.c
>>> @@ -1767,6 +1767,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
>>>                   cgroup_sk_alloc(&sk->sk_cgrp_data);
>>>                   sock_update_classid(&sk->sk_cgrp_data);
>>>                   sock_update_netprioidx(&sk->sk_cgrp_data);
>>> +               sk_tx_queue_clear(sk);
>>
>> Why add it here?
>> I don't see a call to sk_set_socket().
> 
> Yes, but the intent is to set the initial value of sk->sk_tx_queue_mapping (USHRT_MAX)
> when socket object is allocated/populated, not later in some unrelated paths.
> 
> We move into one location all the initializers.
> (Most fields initial value is 0, so we do not clear them a second time)
> 
>>
>>>           }
>>>             return sk;
>>> @@ -1990,6 +1991,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>>>                    */
>>>                   sk_refcnt_debug_inc(newsk);
>>>                   sk_set_socket(newsk, NULL);
>>> +               sk_tx_queue_clear(newsk);
>>>                   RCU_INIT_POINTER(newsk->sk_wq, NULL);
>>>                     if (newsk->sk_prot->sockets_allocated)
>>>
>>
>> So in addition to sock_orphan(), now sk_tx_queue_clear() won't be called also from:
>> 1. sock_graft(): Looks fine to me.
>> 2. sock_init_data(): I think we should add an explicit call to sk_tx_queue_clear() here. The one for RX sk_rx_queue_clear() is already there.
> 
> Why ? Initial value found is socket should be just fine.
> 
> If not, normal skb->ooo_okay should prevail, if protocols really care about OOO.
> 
>> 3. mptcp_sock_graft(): Looks fine to me.
>>
>> Regards,
>> Tariq

Thanks.
I prepared the patch, will test it against the bug repro I have and submit.

Tariq
