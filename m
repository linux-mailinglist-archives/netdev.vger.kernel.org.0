Return-Path: <netdev+bounces-4468-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A727B70D0E2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76F251C20BFF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B64D1FA9;
	Tue, 23 May 2023 02:13:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCC21C31
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:13:19 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1EDCA;
	Mon, 22 May 2023 19:13:17 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QQHmb1vQNzqSHT;
	Tue, 23 May 2023 10:08:47 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 23 May
 2023 10:13:15 +0800
Subject: Re: [PATCH net] page_pool: fix inconsistency for
 page_pool_ring_[un]lock()
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>, Jesper Dangaard Brouer
	<jbrouer@redhat.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<brouer@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend
	<john.fastabend@gmail.com>
References: <20230522031714.5089-1-linyunsheng@huawei.com>
 <1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
 <CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
Date: Tue, 23 May 2023 10:13:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/22 19:45, Ilias Apalodimas wrote:
>> On 22/05/2023 05.17, Yunsheng Lin wrote:
>>> page_pool_ring_[un]lock() use in_softirq() to decide which
>>> spin lock variant to use, and when they are called in the
>>> context with in_softirq() being false, spin_lock_bh() is
>>> called in page_pool_ring_lock() while spin_unlock() is
>>> called in page_pool_ring_unlock(), because spin_lock_bh()
>>> has disabled the softirq in page_pool_ring_lock(), which
>>> causes inconsistency for spin lock pair calling.
>>>
>>> This patch fixes it by returning in_softirq state from
>>> page_pool_producer_lock(), and use it to decide which
>>> spin lock variant to use in page_pool_producer_unlock().
>>>
>>> As pool->ring has both producer and consumer lock, so
>>> rename it to page_pool_producer_[un]lock() to reflect
>>> the actual usage. Also move them to page_pool.c as they
>>> are only used there, and remove the 'inline' as the
>>> compiler may have better idea to do inlining or not.
>>>
>>> Fixes: 7886244736a4 ("net: page_pool: Add bulk support for ptr_ring")
>>> Signed-off-by: Yunsheng Lin<linyunsheng@huawei.com>
>>
>> Thanks for spotting and fixing this! :-)

It was spotted when implementing the below patch:)

https://patchwork.kernel.org/project/netdevbpf/patch/168269857929.2191653.13267688321246766547.stgit@firesoul/#25325801

Do you still working on optimizing the page_pool destroy
process? If not, do you mind if I carry it on based on
that?

