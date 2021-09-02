Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A683FE761
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 04:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhIBCG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 22:06:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15380 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbhIBCG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 22:06:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H0PLf2QtmzbgYH;
        Thu,  2 Sep 2021 10:02:02 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 2 Sep 2021 10:05:58 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Thu, 2 Sep 2021
 10:05:58 +0800
Subject: Re: [PATCH net-next] tcp: add tcp_tx_skb_cache_key checking in
 sk_stream_alloc_skb()
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>
References: <1630492744-60396-1-git-send-email-linyunsheng@huawei.com>
 <ba7a0854-6841-2ebc-c329-4c13f1a997df@huawei.com>
 <CANn89i+X_K2A1kepmLh1ySC_UE=+ov=Cya2mtW7R0LT68kyb2w@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b4c6f14a-31dc-f1e1-3669-5b6721a4c87d@huawei.com>
Date:   Thu, 2 Sep 2021 10:05:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89i+X_K2A1kepmLh1ySC_UE=+ov=Cya2mtW7R0LT68kyb2w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/2 9:13, Eric Dumazet wrote:
> On Wed, Sep 1, 2021 at 5:47 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2021/9/1 18:39, Yunsheng Lin wrote:
>>> Since tcp_tx_skb_cache is disabled by default in:
>>> commit 0b7d7f6b2208 ("tcp: add tcp_tx_skb_cache sysctl")
>>>
>>> Add tcp_tx_skb_cache_key checking in sk_stream_alloc_skb() to
>>> avoid possible branch-misses.
>>>
>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>> ---
>>> Also, the sk->sk_tx_skb_cache may be both changed by allocation
>>> and freeing side, I assume there may be some implicit protection
>>> here too, such as the NAPI protection for rx?
>>
>> Hi, Eric
>>    Is there any implicit protection for sk->sk_tx_skb_cache?
>> As my understanding, sk_stream_alloc_skb() seems to be protected
>> by lock_sock(), and the sk_wmem_free_skb() seems to be mostly
>> happening in NAPI polling for TCP(when ack packet is received)
>> without lock_sock(), so it seems there is no protection here?
>>
> 
> Please look again.
> This is protected by socket lock of course.
> Otherwise sk_mem_uncharge() would be very broken, sk->sk_forward_alloc
> is not an atomic field.

Thanks for clarifying.
I have been looking for a point to implement the socket'pp_alloc_cache for
page pool, and sk_wmem_free_skb() seems like the place to avoid the
scalablity problem of ptr_ring in page pool.

The protection for sk_wmem_free_skb() is in tcp_v4_rcv(), right?
https://elixir.bootlin.com/linux/latest/source/net/ipv4/tcp_ipv4.c#L2081

> 
> TCP stack has no direct relation  with NAPI.
> It can run over loopback interface, no NAPI there.
> .
> 
