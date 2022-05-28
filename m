Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B585369F7
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352891AbiE1B61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352313AbiE1B60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:58:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED174D9D7;
        Fri, 27 May 2022 18:58:25 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L94Ys4TGQzjX1D;
        Sat, 28 May 2022 09:57:37 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 09:58:22 +0800
Subject: Re: [PATCH net-next v2] ipv6: Fix signed integer overflow in
 __ip6_append_data
To:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220525020827.1571021-1-wangyufen@huawei.com>
 <dddf715df453e9d3bc56bc74b8e6de05cffc9e45.camel@redhat.com>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <1b6745e9-a5cc-86e4-b94c-0506ca781ee7@huawei.com>
Date:   Sat, 28 May 2022 09:58:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <dddf715df453e9d3bc56bc74b8e6de05cffc9e45.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/26 17:41, Paolo Abeni 写道:
> On Wed, 2022-05-25 at 10:08 +0800, Wang Yufen wrote:
>> Resurrect ubsan overflow checks and ubsan report this warning,
>> fix it by change the variable [length] type to size_t.
>>
>> UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
>> 2147479552 + 8567 cannot be represented in type 'int'
>> CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
>> Hardware name: linux,dummy-virt (DT)
>> Call trace:
>>    dump_backtrace+0x214/0x230
>>    show_stack+0x30/0x78
>>    dump_stack_lvl+0xf8/0x118
>>    dump_stack+0x18/0x30
>>    ubsan_epilogue+0x18/0x60
>>    handle_overflow+0xd0/0xf0
>>    __ubsan_handle_add_overflow+0x34/0x44
>>    __ip6_append_data.isra.48+0x1598/0x1688
>>    ip6_append_data+0x128/0x260
>>    udpv6_sendmsg+0x680/0xdd0
>>    inet6_sendmsg+0x54/0x90
>>    sock_sendmsg+0x70/0x88
>>    ____sys_sendmsg+0xe8/0x368
>>    ___sys_sendmsg+0x98/0xe0
>>    __sys_sendmmsg+0xf4/0x3b8
>>    __arm64_sys_sendmmsg+0x34/0x48
>>    invoke_syscall+0x64/0x160
>>    el0_svc_common.constprop.4+0x124/0x300
>>    do_el0_svc+0x44/0xc8
>>    el0_svc+0x3c/0x1e8
>>    el0t_64_sync_handler+0x88/0xb0
>>    el0t_64_sync+0x16c/0x170
>>
>> Changes since v1:
>> -Change the variable [length] type to unsigned, as Eric Dumazet suggested.
>>    
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   include/net/ipv6.h    | 4 ++--
>>   net/ipv6/ip6_output.c | 8 ++++----
>>   net/ipv6/udp.c        | 2 +-
>>   net/l2tp/l2tp_ip6.c   | 2 +-
>>   4 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
>> index 5b38bf1a586b..de9dcc5652c4 100644
>> --- a/include/net/ipv6.h
>> +++ b/include/net/ipv6.h
>> @@ -1063,7 +1063,7 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr);
>>   int ip6_append_data(struct sock *sk,
>>   		    int getfrag(void *from, char *to, int offset, int len,
>>   				int odd, struct sk_buff *skb),
>> -		    void *from, int length, int transhdrlen,
>> +		    void *from, size_t length, int transhdrlen,
>>   		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
>>   		    struct rt6_info *rt, unsigned int flags);
>>   
>> @@ -1079,7 +1079,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk, struct sk_buff_head *queue,
>>   struct sk_buff *ip6_make_skb(struct sock *sk,
>>   			     int getfrag(void *from, char *to, int offset,
>>   					 int len, int odd, struct sk_buff *skb),
>> -			     void *from, int length, int transhdrlen,
>> +			     void *from, size_t length, int transhdrlen,
>>   			     struct ipcm6_cookie *ipc6,
>>   			     struct rt6_info *rt, unsigned int flags,
>>   			     struct inet_cork_full *cork);
>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>> index 4081b12a01ff..7d47ddd1e1f2 100644
>> --- a/net/ipv6/ip6_output.c
>> +++ b/net/ipv6/ip6_output.c
>> @@ -1450,7 +1450,7 @@ static int __ip6_append_data(struct sock *sk,
>>   			     struct page_frag *pfrag,
>>   			     int getfrag(void *from, char *to, int offset,
>>   					 int len, int odd, struct sk_buff *skb),
>> -			     void *from, int length, int transhdrlen,
>> +			     void *from, size_t length, int transhdrlen,
>>   			     unsigned int flags, struct ipcm6_cookie *ipc6)
>>   {
>>   	struct sk_buff *skb, *skb_prev = NULL;
>> @@ -1798,7 +1798,7 @@ static int __ip6_append_data(struct sock *sk,
>>   int ip6_append_data(struct sock *sk,
>>   		    int getfrag(void *from, char *to, int offset, int len,
>>   				int odd, struct sk_buff *skb),
>> -		    void *from, int length, int transhdrlen,
>> +		    void *from, size_t length, int transhdrlen,
>>   		    struct ipcm6_cookie *ipc6, struct flowi6 *fl6,
>>   		    struct rt6_info *rt, unsigned int flags)
>>   {
>> @@ -1995,13 +1995,13 @@ EXPORT_SYMBOL_GPL(ip6_flush_pending_frames);
>>   struct sk_buff *ip6_make_skb(struct sock *sk,
>>   			     int getfrag(void *from, char *to, int offset,
>>   					 int len, int odd, struct sk_buff *skb),
>> -			     void *from, int length, int transhdrlen,
>> +			     void *from, size_t length, int transhdrlen,
>>   			     struct ipcm6_cookie *ipc6, struct rt6_info *rt,
>>   			     unsigned int flags, struct inet_cork_full *cork)
>>   {
>>   	struct inet6_cork v6_cork;
>>   	struct sk_buff_head queue;
>> -	int exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
>> +	size_t exthdrlen = (ipc6->opt ? ipc6->opt->opt_flen : 0);
> Is this the above line change needed? Why?

No need， I'll change.

Thanks.

>
> Thanks!
>
> Paolo
>
> .
