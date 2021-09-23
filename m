Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE3415CC8
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbhIWLZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:25:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:16378 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbhIWLZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:25:58 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HFXl05xFCzRQqh;
        Thu, 23 Sep 2021 19:20:12 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 23 Sep 2021 19:24:25 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Thu, 23 Sep
 2021 19:24:25 +0800
Subject: Re: [PATCH net-next 3/7] pool_pool: avoid calling compound_head() for
 skb frag page
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <hawk@kernel.org>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
 <20210922094131.15625-4-linyunsheng@huawei.com>
 <YUw78q4IrfR0D2/J@apalos.home>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b2779d81-4cb3-5ccc-8e36-02cd633383f3@huawei.com>
Date:   Thu, 23 Sep 2021 19:24:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YUw78q4IrfR0D2/J@apalos.home>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/23 16:33, Ilias Apalodimas wrote:
> On Wed, Sep 22, 2021 at 05:41:27PM +0800, Yunsheng Lin wrote:
>> As the pp page for a skb frag is always a head page, so make
>> sure skb_pp_recycle() passes a head page to avoid calling
>> compound_head() for skb frag page case.
> 
> Doesn't that rely on the driver mostly (i.e what's passed in skb_frag_set_page() ? 
> None of the current netstack code assumes bv_page is the head page of a 
> compound page.  Since our page_pool allocator can will allocate compound
> pages for order > 0,  why should we rely on it ?

As the page pool alloc function return 'struct page *' to the caller, which
is the head page of a compound pages for order > 0, so I assume the caller
will pass that to skb_frag_set_page().

For non-pp page, I assume it is ok whether the page is a head page or tail
page, as the pp_magic for both of them are not set with PP_SIGNATURE.

Or should we play safe here, and do the trick as skb_free_head() does in
patch 6?

> 
> Thanks
> /Ilias
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>  include/linux/skbuff.h | 2 +-
>>  net/core/page_pool.c   | 2 --
>>  2 files changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>> index 6bdb0db3e825..35eebc2310a5 100644
>> --- a/include/linux/skbuff.h
>> +++ b/include/linux/skbuff.h
>> @@ -4722,7 +4722,7 @@ static inline bool skb_pp_recycle(struct sk_buff *skb, void *data)
>>  {
>>  	if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
>>  		return false;
>> -	return page_pool_return_skb_page(virt_to_page(data));
>> +	return page_pool_return_skb_page(virt_to_head_page(data));
>>  }
>>  
>>  #endif	/* __KERNEL__ */
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index f7e71dcb6a2e..357fb53343a0 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -742,8 +742,6 @@ bool page_pool_return_skb_page(struct page *page)
>>  {
>>  	struct page_pool *pp;
>>  
>> -	page = compound_head(page);
>> -
>>  	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
>>  	 * in order to preserve any existing bits, such as bit 0 for the
>>  	 * head page of compound page and bit 1 for pfmemalloc page, so
>> -- 
>> 2.33.0
>>
> .
> 
