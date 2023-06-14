Return-Path: <netdev+bounces-10697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC15F72FDD3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 679B9281424
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C618C1B;
	Wed, 14 Jun 2023 12:04:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8318463;
	Wed, 14 Jun 2023 12:04:45 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6688E2109;
	Wed, 14 Jun 2023 05:04:42 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Qh3rH2Kqtz18KBZ;
	Wed, 14 Jun 2023 19:59:43 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 20:04:39 +0800
Subject: Re: [PATCH net-next v4 5/5] page_pool: update document about frag API
To: Jakub Kicinski <kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric
 Dumazet <edumazet@google.com>, Jonathan Corbet <corbet@lwn.net>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John
 Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
	<bpf@vger.kernel.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-6-linyunsheng@huawei.com>
 <20230613214041.1c29a357@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1dc9b2e3-65ee-aa33-d604-a758fea98eb8@huawei.com>
Date: Wed, 14 Jun 2023 20:04:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230613214041.1c29a357@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/14 12:40, Jakub Kicinski wrote:
> On Mon, 12 Jun 2023 21:02:56 +0800 Yunsheng Lin wrote:
>> +2. page_pool_alloc_frag(): allocate memory with page splitting when driver knows
>> +   that the memory it need is always smaller than or equal to half of the page
>> +   allocated from page pool. Page splitting enables memory saving and thus avoid
>> +   TLB/cache miss for data access, but there also is some cost to implement page
>> +   splitting, mainly some cache line dirtying/bouncing for 'struct page' and
>> +   atomic operation for page->pp_frag_count.
>> +
>> +3. page_pool_alloc(): allocate memory with or without page splitting depending
>> +   on the requested memory size when driver doesn't know the size of memory it
>> +   need beforehand. It is a mix of the above two case, so it is a wrapper of the
>> +   above API to simplify driver's interface for memory allocation with least
>> +   memory utilization and performance penalty.
> 
> Seems like the semantics of page_pool_alloc() are always better than
> page_pool_alloc_frag(). Is there a reason to keep these two separate?

I am agree the semantics of page_pool_alloc() is better, I was thinking
about combining those two too.
The reason I am keeping it is about the nic hw with fixed buffer size for
each desc, and that buffer size is always smaller than or equal to half
of the page allocated from page pool, so it doesn't bother doing the
checking of 'size << 1 > max_size' and doesn't care about the actual
truesize.

> .
> 

