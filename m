Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C39E6DD70E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjDKJke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDKJkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:40:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946D33A82
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:39:55 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pwgkv3JG3znVYX;
        Tue, 11 Apr 2023 17:38:31 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 17:39:53 +0800
Subject: Re: [PATCH net v2] ipv4: Fix potential uninit variable access buf in
 __ip_make_skb()
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
 <64341d839d862_7d2a4294d@willemb.c.googlers.com.notmuch>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <ae16f222-86ad-af35-8a05-82d7a0e7f234@huawei.com>
Date:   Tue, 11 Apr 2023 17:39:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <64341d839d862_7d2a4294d@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ziyang Xuan wrote:
>> Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
>> __ip6_make_skb()"). icmphdr does not in skb linear region under the
>> scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
>> trigger the uninit variable access bug.
>>
>> Use a local variable icmp_type to carry the correct value in different
>> scenarios.
>>
>> Fixes: 96793b482540 ("[IPV4]: Add ICMPMsgStats MIB (RFC 4293)")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>> v2:
>>   - Use sk->sk_type not sk->sk_socket->type.
> 
> This is reached through
> 
>   raw_sendmsg
>     raw_probe_proto_opt
>     ip_push_pending_frames
>       ip_finish_skb
>         __ip_make_skb
> 
> At this point, the icmp header has already been copied into skb linear
> area. Is the isue that icmp_hdr/skb_transport_header is not set in
> this path? 
> 
Hello Willem,

raw_sendmsg
  ip_append_data(..., transhdrlen==0, ...) // !inet->hdrincl

Parameter "transhdrlen" of ip_append_data() equals to 0 in raw_sendmsg()
not sizeof(struct icmphdr) as in ping_v4_sendmsg().

William Xuan.
>> ---
>>  net/ipv4/ip_output.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>> index 4e4e308c3230..21507c9ce0fc 100644
>> --- a/net/ipv4/ip_output.c
>> +++ b/net/ipv4/ip_output.c
>> @@ -1570,9 +1570,15 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
>>  	cork->dst = NULL;
>>  	skb_dst_set(skb, &rt->dst);
>>  
>> -	if (iph->protocol == IPPROTO_ICMP)
>> -		icmp_out_count(net, ((struct icmphdr *)
>> -			skb_transport_header(skb))->type);
>> +	if (iph->protocol == IPPROTO_ICMP) {
>> +		u8 icmp_type;
>> +
>> +		if (sk->sk_type == SOCK_RAW && !inet_sk(sk)->hdrincl)
>> +			icmp_type = fl4->fl4_icmp_type;
>> +		else
>> +			icmp_type = icmp_hdr(skb)->type;
>> +		icmp_out_count(net, icmp_type);
>> +	}
>>  
>>  	ip_cork_release(cork);
>>  out:
>> -- 
>> 2.25.1
>>
> 
> 
> .
> 
