Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2614E612101
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 09:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJ2HZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 03:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJ2HZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 03:25:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39EC8B2E5;
        Sat, 29 Oct 2022 00:25:50 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MzrRs3rL4zVhqF;
        Sat, 29 Oct 2022 15:20:57 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 15:25:48 +0800
Subject: Re: [PATCH net] net: tun: fix bugs for oversize packet when napi
 frags enabled
To:     Eric Dumazet <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <peterpenkov96@gmail.com>, <maheshb@google.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>
References: <20221029033243.1577015-1-william.xuanziyang@huawei.com>
 <CANn89iLUMSHPZw0qNPxfoy3=Ao5JsRB8721L40YO48x9PDjWvQ@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <f9a94457-0b5a-8d13-4e66-1b3be0a52b02@huawei.com>
Date:   Sat, 29 Oct 2022 15:25:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLUMSHPZw0qNPxfoy3=Ao5JsRB8721L40YO48x9PDjWvQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Fri, Oct 28, 2022 at 8:32 PM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Recently, we got two syzkaller problems because of oversize packet
>> when napi frags enabled.
>>
>> One of the problems is because the first seg size of the iov_iter
>> from user space is very big, it is 2147479538 which is bigger than
>> the threshold value for bail out early in __alloc_pages(). And
>> skb->pfmemalloc is true, __kmalloc_reserve() would use pfmemalloc
>> reserves without __GFP_NOWARN flag. Thus we got a warning as following:
>>
>> ========================================================
>>
> 
>> Restrict the packet size less than ETH_MAX_MTU to fix the problems.
>> Add len check in tun_napi_alloc_frags() simply. Athough that makes
>> some kinds of packets payload size slightly smaller than the length
>> allowed by the protocol, for example, ETH_HLEN + sizeof(struct ipv6hdr)
>> smaller when the tun device type is IFF_TAP and the packet is IPv6. But
>> I think that the effect is small and can be ignored.
> 
> I am not sure about ETH_MAX_MTU being completely safe.
> 
> napi_get_frags() / napi_alloc_skb() is reserving NET_SKB_PAD +
> NET_IP_ALIGN bytes.
> 
> transport_header being an offset from skb->head,
> we probably want to use (ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN)

Hi Eric,

Thank you for your review. I did not notice the reserved skb space.
I will fix it in v2 patch.

Thanks.
> 
> My objection to your initial patch was that you were using PAGE_SIZE,
> while Ethernet MTU can easily be ~9000
> 
> But 0xFFFF is a bit too much/risky.
> 
> Thanks.
> 
>>
>> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  drivers/net/tun.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 27c6d235cbda..98d3160fcae2 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1459,7 +1459,7 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>>         int err;
>>         int i;
>>
>> -       if (it->nr_segs > MAX_SKB_FRAGS + 1)
>> +       if (it->nr_segs > MAX_SKB_FRAGS + 1 || len > ETH_MAX_MTU)
>>                 return ERR_PTR(-EMSGSIZE);
>>
>>         local_bh_disable();
>> --
>> 2.25.1
>>
> .
> 
