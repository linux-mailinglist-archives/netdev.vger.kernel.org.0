Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B716DA6B5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 02:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDGAyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 20:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDGAyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 20:54:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEB693E4
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 17:54:12 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pt0CL2Dp1zSqxD;
        Fri,  7 Apr 2023 08:50:22 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 7 Apr 2023 08:54:10 +0800
Subject: Re: [PATCH net] ipv4: Fix potential uninit variable access buf in
 __ip_make_skb()
To:     Eric Dumazet <edumazet@google.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <dlstevens@us.ibm.com>
References: <20230406031136.2814421-1-william.xuanziyang@huawei.com>
 <CANn89iL5HUHTC19nCQLYhAExss_j2sHP4jjmZDJR4+4raaWg8w@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <3e2d1cf6-080c-b766-d143-e505205c6c1c@huawei.com>
Date:   Fri, 7 Apr 2023 08:54:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iL5HUHTC19nCQLYhAExss_j2sHP4jjmZDJR4+4raaWg8w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

> On Thu, Apr 6, 2023 at 5:11 AM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
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
>>  net/ipv4/ip_output.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>> index 4e4e308c3230..57921b297a8e 100644
>> --- a/net/ipv4/ip_output.c
>> +++ b/net/ipv4/ip_output.c
>> @@ -1570,9 +1570,15 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
>>         cork->dst = NULL;
>>         skb_dst_set(skb, &rt->dst);
>>
>> -       if (iph->protocol == IPPROTO_ICMP)
>> -               icmp_out_count(net, ((struct icmphdr *)
>> -                       skb_transport_header(skb))->type);
>> +       if (iph->protocol == IPPROTO_ICMP) {
>> +               u8 icmp_type;
>> +
>> +               if (sk->sk_socket->type == SOCK_RAW && !inet_sk(sk)->hdrincl)
> 
> What is the reason for not using sk->sk_type ?

sk->sk_type is more concise. Thank you!

> 
>> +                       icmp_type = fl4->fl4_icmp_type;
>> +               else
>> +                       icmp_type = icmp_hdr(skb)->type;
>> +               icmp_out_count(net, icmp_type);
>> +       }
> 
> 
>>
>>         ip_cork_release(cork);
>>  out:
>> --
>> 2.25.1
>>
> .
> 
