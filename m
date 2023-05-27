Return-Path: <netdev+bounces-5860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37982713344
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 10:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA8781C2106C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 08:18:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92D717E9;
	Sat, 27 May 2023 08:18:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF387E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:18:32 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188D8F7;
	Sat, 27 May 2023 01:18:30 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QSvkm6V72zsRQX;
	Sat, 27 May 2023 16:16:16 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sat, 27 May
 2023 16:18:27 +0800
Subject: Re: [PATCH net-next 1/2] page_pool: unify frag page and non-frag page
 handling
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20230526092616.40355-1-linyunsheng@huawei.com>
 <20230526092616.40355-2-linyunsheng@huawei.com> <ZHCgJxTnm37qu3aY@hera>
 <5640bab0-d2f9-50ee-f3e2-eb0f86b144dc@huawei.com> <ZHDSblXIPvJhuZV5@hera>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a9d63917-27c2-b16f-ace5-ab26686a64b7@huawei.com>
Date: Sat, 27 May 2023 16:18:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZHDSblXIPvJhuZV5@hera>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/26 23:38, Ilias Apalodimas wrote:
>>
>>> If that's the case isn't it a better idea to unify the functions entirely?
>>
>> As about, page_pool_alloc_frag() does seems to be a superset of
>> page_pool_alloc_pages() after this patchset as my understanding.
>> If the page_pool_alloc_frag() API turns out to be a good API for
>> the driver, maybe we can phase out *page_pool_alloc_pages() as
>> time goes by?
> 
> Looking at patch 2/2 it seems a bit wasteful.  At the moment only hns3 uses
> fragments and the length of the allocation seems static.  But if someone
> else chooses to allocate a > 2048 packet why should it allocate a page?

It is based on the fact that if user requests a > 2048 frag, then it will
most likely requests > 2048 frag again, for example, when mtu is changed
or xdp is enabled/disabble, at least for veth case, the frag size is likely
changed.

Allocating a page for the above case avoid the frag count draining overhead,
and unify the interface for the driver so that driver don't need to choose
which API to use.

> 
> I just think it's a bit confusing since we have a flag on the pool for page
> fragments, but then we violate it when it suits us.

Yes, we can remove it as mentioned in the cover letter:
"PP_FLAG_PAGE_FRAG may be removed after this patchset, and the
extra benefit is that driver does not need to handle the case
for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT when using
page_pool_alloc_frag() API."

> 
> Thanks
> /Ilias
> .
> 

