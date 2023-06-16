Return-Path: <netdev+bounces-11411-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03DA733087
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:57:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 199231C20C77
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0213E1640A;
	Fri, 16 Jun 2023 11:57:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50741427C;
	Fri, 16 Jun 2023 11:57:25 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED28030EA;
	Fri, 16 Jun 2023 04:57:16 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QjHcx0gb6zMpB5;
	Fri, 16 Jun 2023 19:54:09 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 16 Jun
 2023 19:57:14 +0800
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
To: Jesper Dangaard Brouer <jbrouer@redhat.com>, Alexander Duyck
	<alexander.duyck@gmail.com>
CC: <brouer@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>, Jesper
 Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Eric Dumazet <edumazet@google.com>, Maryam
 Tahhan <mtahhan@redhat.com>, bpf <bpf@vger.kernel.org>
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
 <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <dcc9db4c-207b-e118-3d84-641677cd3d80@huawei.com>
Date: Fri, 16 Jun 2023 19:57:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/16 0:19, Jesper Dangaard Brouer wrote:

...

> You have mentioned veth as the use-case. I know I acked adding page_pool
> use-case to veth, for when we need to convert an SKB into an
> xdp_buff/xdp-frame, but maybe it was the wrong hammer(?).
> In this case in veth, the size is known at the page allocation time.
> Thus, using the page_pool API is wasting memory.  We did this for
> performance reasons, but we are not using PP for what is was intended
> for.  We mostly use page_pool, because it an existing recycle return
> path, and we were too lazy to add another alloc-type (see enum
> xdp_mem_type).
> 
> Maybe you/we can extend veth to use this dynamic size API, to show us
> that this is API is a better approach.  I will signup for benchmarking
> this (and coordinating with CC Maryam as she came with use-case we
> improved on).

Thanks, let's find out if page pool is the right hammer for the
veth XDP case.

Below is the change for veth using the new api in this patch.
Only compile test as I am not familiar enough with veth XDP and
testing environment for it.
Please try it if it is helpful.

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 614f3e3efab0..8850394f1d29 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -736,7 +736,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
        if (skb_shared(skb) || skb_head_is_locked(skb) ||
            skb_shinfo(skb)->nr_frags ||
            skb_headroom(skb) < XDP_PACKET_HEADROOM) {
-               u32 size, len, max_head_size, off;
+               u32 size, len, max_head_size, off, truesize, page_offset;
                struct sk_buff *nskb;
                struct page *page;
                int i, head_off;
@@ -752,12 +752,15 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
                if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
                        goto drop;

+               size = min_t(u32, skb->len, max_head_size);
+               truesize = size;
+
                /* Allocate skb head */
-               page = page_pool_dev_alloc_pages(rq->page_pool);
+               page = page_pool_dev_alloc(rq->page_pool, &page_offset, &truesize);
                if (!page)
                        goto drop;

-               nskb = napi_build_skb(page_address(page), PAGE_SIZE);
+               nskb = napi_build_skb(page_address(page) + page_offset, truesize);
                if (!nskb) {
                        page_pool_put_full_page(rq->page_pool, page, true);
                        goto drop;
@@ -767,7 +770,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
                skb_copy_header(nskb, skb);
                skb_mark_for_recycle(nskb);

-               size = min_t(u32, skb->len, max_head_size);
                if (skb_copy_bits(skb, 0, nskb->data, size)) {
                        consume_skb(nskb);
                        goto drop;
@@ -782,14 +784,17 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
                len = skb->len - off;

                for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
-                       page = page_pool_dev_alloc_pages(rq->page_pool);
+                       size = min_t(u32, len, PAGE_SIZE);
+                       truesize = size;
+
+                       page = page_pool_dev_alloc(rq->page_pool, &page_offset,
+                                                  &truesize);
                        if (!page) {
                                consume_skb(nskb);
                                goto drop;
                        }

-                       size = min_t(u32, len, PAGE_SIZE);
-                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
+                       skb_add_rx_frag(nskb, i, page, page_offset, size, truesize);
                        if (skb_copy_bits(skb, off, page_address(page),
                                          size)) {
                                consume_skb(nskb);


> 
> --Jesper
> 
> .
> 

