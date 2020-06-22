Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65C8203C78
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgFVQYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:24:47 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:19938
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729479AbgFVQYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 12:24:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6F7DUsxmLjvvTRLXyggYg8vUcjaipCsDdVOQqblwPU7pPhJ+MddmKhgZHJvS2TezPTGR27NyfxzO2ZVhRCa6NeqMuNm82p0wUu6JuxcaPNwpU+WB4gDcgTkww2sS9Hy0C3wB8YnyXdzi1wSsTPDWDxdlAZtGIWetgoy0oHP6V+jwgjVE/1pFkTr6v/6DHka4AotvzDGzsXzXaENJD1oyrm2rnYOSavlpcGnPF9x0ydsqIb61XpXvsGC4t+pTTKK0Hlpk2x+UVGX6pl8exyI4y5tcakzEe//qtYNClA4tcaJboiSv03GCFDMrt4MUhR+HIDGMDm7ZbaPJd+bNg4kIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCaUrXnIs4hD9q6ElEISCdyre7jZ+oFWKWxmBF8tIKI=;
 b=drq4GsRnhxWjJkduggFtBafkitQU/CQDEWY+YtorYns8QIpya+vGM0/X8fdkPz7ET3INpA/FW4MRlSYuKc3xvM8oKNX5xAV2zwQop8kc78CNskZqyH3oxv7o8ku2cXePNEbOlGW56JF/UZiE7M+D0B+MzvP5fuMXR1VjmbDYDvmR/t32zikYAw2rPeVWOC4bQvvvLX0P1kHag/CrtCbah5eJHNU4CRJ6LeEG/PdXq0AsJefDtLXh6MQFTVxOrWBwJl6HT9pDn7XZ/9hezMxsWAseM79LxSK4XQtMYR/rA70tZSVbnEGDiAn+Y4JZpnUP2VdjVcXZLsDkKUrMwc9Zog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCaUrXnIs4hD9q6ElEISCdyre7jZ+oFWKWxmBF8tIKI=;
 b=R37hMWK5xpvTJ9K3Ra9kHDf1iFUTMZz5qqPc9yx8pCvVARr23o13YAT2vXw6UNJKCOQfdMUjZ5issBA+TRjLVn0tXh0aZL+FChfhJMppSTEu8Ts0IZFIrJMUjoElsDbOcZFJiZnGGe9ZW0ix6exP4+IQNH2PewMrv0kOmKqgfcE=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2781.eurprd05.prod.outlook.com
 (2603:10a6:800:99::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 16:24:42 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 16:24:42 +0000
Subject: Re: [PATCH net] net: Do not clear the socket TX queue in
 sock_orphan()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <1592748544-41555-1-git-send-email-tariqt@mellanox.com>
 <4254dfec-0901-73c4-a1f5-c6609db2baec@gmail.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <d5d84b99-0ee4-b03d-d927-d9dcb8d36326@mellanox.com>
Date:   Mon, 22 Jun 2020 19:24:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <4254dfec-0901-73c4-a1f5-c6609db2baec@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0102.eurprd05.prod.outlook.com
 (2603:10a6:207:1::28) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.126.75.30) by AM3PR05CA0102.eurprd05.prod.outlook.com (2603:10a6:207:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 16:24:41 +0000
X-Originating-IP: [77.126.75.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c79a1021-58cf-42c6-4543-08d816c8c48c
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2781:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB27816DC4F40C6729294B7D2EAE970@VI1PR0501MB2781.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QUJTk4YqQs+zO6bh+PM95YVTnSt3ZPrW0MFonJN8IKNbekzLSN/GSg+3lvGaA/w5ACEi9xXe+dMTpXOdMCS+rb6d4k1oGbDYUuUPjcwn/ONtWOXG6ETY5vT0a9aoVtE47U0rVFh08eKEwL2f73SjQnIBpILlRQJkIVg8UTxaK/YD7mQBHPAUgHtdMLU1yMPowdmF0k/YfmqKiP7PHN17U4uBVSBBsUX5YZ9wu/8DcGVzf5GXKEc9KzS7r8HDZF2l3g2Qss0alA6VFtMMaC75k+vLo7wjXF8lpJtpV0U+D4zUopvu0skCqq2cOLeS0ekgw4cUMirETtRR1DtjjiNxAKLldWAWCvBAxVjZzrflRtJOIwomIYuKnTud1yf/XKen
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(66556008)(66476007)(110136005)(107886003)(186003)(16526019)(8676002)(52116002)(2906002)(26005)(53546011)(4326008)(8936002)(478600001)(36756003)(6486002)(316002)(16576012)(31696002)(5660300002)(83380400001)(54906003)(66946007)(31686004)(6666004)(2616005)(956004)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ybt7N9+7yubb0JR0vjL2dCX3AQ8hU4vsrCOaZMDs9FOT07a41jfY2Siffs1wgk1yXQPExSHKSxBMFEo0/XCSDjTEGXEOlllewzwxAEXG0aU2cCjjoO988wAETFs6cqKOYdWu/pH5Wpv+91+cGxyaGeUjmsLtgS2Mw3Jd5UV51T1RVMzyNV0idL1YrFFn6zWAXd7Cut3gARpGw+dxnc+pTXux7yyC6jdQMERrlviBzA6sgR+rkUXyOt1VaKk6ToUI1nlfdtDz7kj5klszmsJtt9SKgkMomgScsUxdYTxqv8Y5qvB5OtFjYuGVaBtyvNBSBIPTvl1GP0wmyQKYqUFQDr5sxOr3zaMkMLmDK3h3de0bZZHrBEw9nNo9U2vsF0twN1hHEJdRJbsUAJMXZNgDukJAA+6OtP/V91XR4zChXqtRwYJ/+gUCK0rTbC0y+W/zeMmuajQgDzDH7kldV4A+cVw0C7ewJu2YGM7xCR7Kz38=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79a1021-58cf-42c6-4543-08d816c8c48c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 16:24:42.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vj81ZGY+byE85ps1FCYHPTU/rxiUAr+O1oAZfLeQL1n+rk6il+ddNzRcrTw9w8NF1KwPU/f0Y6vuKu//m2FKIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2781
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/2020 6:53 PM, Eric Dumazet wrote:
> 
> 
> On 6/21/20 7:09 AM, Tariq Toukan wrote:
>> sock_orphan() call to sk_set_socket() implies clearing the sock TX queue.
>> This might cause unexpected out-of-order transmit, as outstanding packets
>> can pick a different TX queue and bypass the ones already queued.
>> This is undesired in general. More specifically, it breaks the in-order
>> scheduling property guarantee for device-offloaded TLS sockets.
>>
>> Introduce a function variation __sk_set_socket() that does not clear
>> the TX queue, and call it from sock_orphan().
>> All other callers of sk_set_socket() do not operate on an active socket,
>> so they do not need this change.
>>
>> Fixes: e022f0b4a03f ("net: Introduce sk_tx_queue_mapping")
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
>> ---
>>   include/net/sock.h | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> Please queue for -stable.
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index c53cc42b5ab9..23e43f3d79f0 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -1846,10 +1846,15 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>>   }
>>   #endif
>>   
>> +static inline void __sk_set_socket(struct sock *sk, struct socket *sock)
>> +{
>> +	sk->sk_socket = sock;
>> +}
>> +
>>   static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>>   {
>>   	sk_tx_queue_clear(sk);
>> -	sk->sk_socket = sock;
>> +	__sk_set_socket(sk, sock);
>>   }
>>   
> 
> Hmm...
> 
> I think we should have a single sk_set_socket() call, and remove
> the sk_tx_queue_clear() from it.
> 
> sk_tx_queue_clear() should be put where it is needed, instead of being hidden
> in sk_set_socket()
> 

Thanks Eric, sounds good to me, I will respin, just have some questions 
below.

> diff --git a/include/net/sock.h b/include/net/sock.h
> index c53cc42b5ab92d0062519e60435b85c75564a967..3428619faae4340485b200f49d9cce4fb09086b3 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1848,7 +1848,6 @@ static inline int sk_rx_queue_get(const struct sock *sk)
>   
>   static inline void sk_set_socket(struct sock *sk, struct socket *sock)
>   {
> -       sk_tx_queue_clear(sk);
>          sk->sk_socket = sock;
>   }
>   
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 6c4acf1f0220b1f925ebcfaa847632ec0dbe0b9b..134de0d37f77ba781b2b3341c94a97a1b2d57a2d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1767,6 +1767,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
>                  cgroup_sk_alloc(&sk->sk_cgrp_data);
>                  sock_update_classid(&sk->sk_cgrp_data);
>                  sock_update_netprioidx(&sk->sk_cgrp_data);
> +               sk_tx_queue_clear(sk);

Why add it here?
I don't see a call to sk_set_socket().

>          }
>   
>          return sk;
> @@ -1990,6 +1991,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
>                   */
>                  sk_refcnt_debug_inc(newsk);
>                  sk_set_socket(newsk, NULL);
> +               sk_tx_queue_clear(newsk);
>                  RCU_INIT_POINTER(newsk->sk_wq, NULL);
>   
>                  if (newsk->sk_prot->sockets_allocated)
> 

So in addition to sock_orphan(), now sk_tx_queue_clear() won't be called 
also from:
1. sock_graft(): Looks fine to me.
2. sock_init_data(): I think we should add an explicit call to 
sk_tx_queue_clear() here. The one for RX sk_rx_queue_clear() is already 
there.
3. mptcp_sock_graft(): Looks fine to me.

Regards,
Tariq
