Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0660260E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJRHpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJRHpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:45:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2CC2018D;
        Tue, 18 Oct 2022 00:44:59 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ms5Qr0PG3zpSsn;
        Tue, 18 Oct 2022 15:41:40 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 15:44:56 +0800
Subject: Re: [PATCH -next] tcp: fix a signed-integer-overflow bug in
 tcp_add_backlog()
To:     Eric Dumazet <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221012103844.1095777-1-luwei32@huawei.com>
 <CANn89iL3iWQkhbJ1-YgJ_DQErkhB6=rOD_JuJBiJaEb+36QrkA@mail.gmail.com>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <15e10efe-f357-ac99-6733-3aefa9bd9525@huawei.com>
Date:   Tue, 18 Oct 2022 15:44:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iL3iWQkhbJ1-YgJ_DQErkhB6=rOD_JuJBiJaEb+36QrkA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/10/12 8:31 PM, Eric Dumazet 写道:
> On Wed, Oct 12, 2022 at 2:35 AM Lu Wei <luwei32@huawei.com> wrote:
>> The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
>> in tcp_add_backlog(), the variable limit is caculated by adding
>> sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
>> of u32 and be truncated. So change it to u64 to avoid a potential
>> signed-integer-overflow, which leads to opposite result is returned
>> in the following function.
>>
>> Signed-off-by: Lu Wei <luwei32@huawei.com>
> You need to add a Fixes: tag, please.
>
>> ---
>>   include/net/sock.h  | 4 ++--
>>   net/ipv4/tcp_ipv4.c | 6 ++++--
>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 08038a385ef2..fc0fa29d8865 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -1069,7 +1069,7 @@ static inline void __sk_add_backlog(struct sock *sk, struct sk_buff *skb)
>>    * Do not take into account this skb truesize,
>>    * to allow even a single big packet to come.
>>    */
>> -static inline bool sk_rcvqueues_full(const struct sock *sk, unsigned int limit)
>> +static inline bool sk_rcvqueues_full(const struct sock *sk, u64 limit)
>>   {
>>          unsigned int qsize = sk->sk_backlog.len + atomic_read(&sk->sk_rmem_alloc);
> qsize would then overflow :/
>
> I would rather limit sk_rcvbuf and sk_sndbuf to 0x7fff0000, instead of
> 0x7ffffffe
>
> If really someone is using 2GB for both send and receive queues,  I
> doubt removing 64KB will be a problem.
> .

thanks for reply, I will change the type of qsize to u64 in V2. Besides, 
how to limit sk_rcvbuf and sk_sndbuf

to 0x7ffff0000, do you mean in sysctl interface? If so, the varible 
limit will still overflow since it's calculated

by adding sk_rcvbuf and sk_sndbuf.

-- 
Best Regards,
Lu Wei

