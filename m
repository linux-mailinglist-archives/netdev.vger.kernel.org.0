Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14C25B6CC0
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbiIMMHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiIMMHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:07:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D2F5F211;
        Tue, 13 Sep 2022 05:07:50 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MRhxl2TlKzHntp;
        Tue, 13 Sep 2022 20:05:47 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 13 Sep 2022 20:07:47 +0800
Subject: Re: [PATCH net] net: tun: limit first seg size to avoid oversized
 linearization
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Petar Penkov <peterpenkov96@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>
References: <20220907015618.2140679-1-william.xuanziyang@huawei.com>
 <CANn89iKPmDXvPzw9tYpiqHH7LegAgTb14fAiAqH8vAxZ3KsryA@mail.gmail.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <efc3708e-47d8-b3e8-08a9-40031d11b8ff@huawei.com>
Date:   Tue, 13 Sep 2022 20:07:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKPmDXvPzw9tYpiqHH7LegAgTb14fAiAqH8vAxZ3KsryA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Sep 6, 2022 at 6:56 PM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>>
>> Recently, we found a syzkaller problem as following:
>>
>> ========================================================
>> WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
>> ...
>> Call trace:
>>  __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
>>  __alloc_pages_node include/linux/gfp.h:550 [inline]
>>  alloc_pages_node include/linux/gfp.h:564 [inline]
>>  kmalloc_large_node+0x94/0x350 mm/slub.c:4038
>>  __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
>>  __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
>>  pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
>>  __skb_grow include/linux/skbuff.h:2779 [inline]
>>  tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
>>  tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
>>  tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036
>>
>> It is because the first seg size of the iov_iter from user space is
>> very big, it is 2147479538 which is bigger than the threshold value
>> for bail out early in __alloc_pages(). And skb->pfmemalloc is true,
>> __kmalloc_reserve() would use pfmemalloc reserves without __GFP_NOWARN
>> flag. Thus we got a warning.
>>
>> I noticed that non-first segs size are required less than PAGE_SIZE in
>> tun_napi_alloc_frags(). The first seg should not be a special case, and
>> oversized linearization is also unreasonable. Limit the first seg size to
>> PAGE_SIZE to avoid oversized linearization.
>>
>> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  drivers/net/tun.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 259b2b84b2b3..7db515f94667 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1454,12 +1454,12 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>>                                             size_t len,
>>                                             const struct iov_iter *it)
>>  {
>> +       size_t linear = iov_iter_single_seg_count(it);
>>         struct sk_buff *skb;
>> -       size_t linear;
>>         int err;
>>         int i;
>>
>> -       if (it->nr_segs > MAX_SKB_FRAGS + 1)
>> +       if (it->nr_segs > MAX_SKB_FRAGS + 1 || linear > PAGE_SIZE)
>>                 return ERR_PTR(-EMSGSIZE);
>>
> 
> This does not look good to me.
> 
> Some drivers allocate 9KB+ for 9000 MTU, in a single allocation,
> because the hardware is not SG capable in RX.

So, do you mean that it does not matter and keep current status, or give a bigger size but PAGE_SIZE (usually 4KB size)?

Would like to hear your advice.

Thank you.

> 
>>         local_bh_disable();
>> @@ -1468,7 +1468,6 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>>         if (!skb)
>>                 return ERR_PTR(-ENOMEM);
>>
>> -       linear = iov_iter_single_seg_count(it);
>>         err = __skb_grow(skb, linear);
>>         if (err)
>>                 goto free;
>> --
>> 2.25.1
>>
> .
> 
