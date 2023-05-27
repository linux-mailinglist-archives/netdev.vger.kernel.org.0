Return-Path: <netdev+bounces-5859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C2071332F
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B449281805
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 07:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD06742C6;
	Sat, 27 May 2023 07:56:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223657E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 07:56:35 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9C2BB;
	Sat, 27 May 2023 00:56:32 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QSvG735P5zLmNn;
	Sat, 27 May 2023 15:54:55 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 27 May
 2023 15:56:26 +0800
Subject: Re: [PATCH net] page_pool: fix inconsistency for
 page_pool_ring_[un]lock()
To: Jakub Kicinski <kuba@kernel.org>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet
	<edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>
References: <20230522031714.5089-1-linyunsheng@huawei.com>
 <20230526123438.3d3e7158@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <71fbd23c-ad5d-472b-bdc9-be3176f3c272@huawei.com>
Date: Sat, 27 May 2023 15:56:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230526123438.3d3e7158@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/27 3:34, Jakub Kicinski wrote:
> On Mon, 22 May 2023 11:17:14 +0800 Yunsheng Lin wrote:
>> page_pool_ring_[un]lock() use in_softirq() to decide which
>> spin lock variant to use, and when they are called in the
>> context with in_softirq() being false, spin_lock_bh() is
>> called in page_pool_ring_lock() while spin_unlock() is
>> called in page_pool_ring_unlock(), because spin_lock_bh()
>> has disabled the softirq in page_pool_ring_lock(), which
>> causes inconsistency for spin lock pair calling.
>>
>> This patch fixes it by returning in_softirq state from
>> page_pool_producer_lock(), and use it to decide which
>> spin lock variant to use in page_pool_producer_unlock().
>>
>> As pool->ring has both producer and consumer lock, so
>> rename it to page_pool_producer_[un]lock() to reflect
>> the actual usage. Also move them to page_pool.c as they
>> are only used there, and remove the 'inline' as the
>> compiler may have better idea to do inlining or not.
>>
>> Fixes: 7886244736a4 ("net: page_pool: Add bulk support for ptr_ring")
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> I just realized now while doing backports that the Fixes tag is
> incorrect here. The correct Fixes tag is:
> 
> Fixes: 542bcea4be86 ("net: page_pool: use in_softirq() instead")
> 
> Before that we used in_serving_softirq() which was perfectly fine.

From the comment around in_serving_softirq() and in_softirq(),
you are probably right as in_serving_softirq() is always false
no matter if bh is enabled or disabled.

> This explains the major mystery of how such a serious bug would survive
> for 10+ releases... it didn't, it wasn't there :) It only came in 6.3.
> We can't change the tag now but at least the universe makes sense again.

Yes, it makes more sense now:)

> .
> 

