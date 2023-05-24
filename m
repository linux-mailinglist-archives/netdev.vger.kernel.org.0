Return-Path: <netdev+bounces-5008-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C2770F6C8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BFC228139E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98AD60851;
	Wed, 24 May 2023 12:43:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BFD60847;
	Wed, 24 May 2023 12:43:28 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC95FA3;
	Wed, 24 May 2023 05:43:17 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QR9j00blWzqT2m;
	Wed, 24 May 2023 20:38:44 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 24 May
 2023 20:43:13 +0800
Subject: Re: mlx5 XDP redirect leaking memory on kernel 6.3
To: Dragos Tatulea <dtatulea@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"ttoukan.linux@gmail.com" <ttoukan.linux@gmail.com>, "jbrouer@redhat.com"
	<jbrouer@redhat.com>, "saeed@kernel.org" <saeed@kernel.org>, Saeed Mahameed
	<saeedm@nvidia.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "maxtram95@gmail.com" <maxtram95@gmail.com>, "lorenzo@kernel.org"
	<lorenzo@kernel.org>, "alexander.duyck@gmail.com"
	<alexander.duyck@gmail.com>, "kheib@redhat.com" <kheib@redhat.com>,
	"ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
	"mkabat@redhat.com" <mkabat@redhat.com>, "brouer@redhat.com"
	<brouer@redhat.com>, "atzin@redhat.com" <atzin@redhat.com>,
	"fmaurer@redhat.com" <fmaurer@redhat.com>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "jbenc@redhat.com" <jbenc@redhat.com>
References: <d862a131-5e31-bd26-84f7-fd8764ca9d48@redhat.com>
 <00ca7beb7fe054a3ba1a36c61c1e3b1314369f11.camel@nvidia.com>
 <7a0bd108-ba00-add9-a244-02a6c3cb64df@huawei.com>
 <6de64ad1fa9c4c82de190d4f71923984979782d8.camel@nvidia.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <791ed915-ca7d-ef7c-04ce-999caa899e95@huawei.com>
Date: Wed, 24 May 2023 20:43:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6de64ad1fa9c4c82de190d4f71923984979782d8.camel@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/24 20:03, Dragos Tatulea wrote:
> On Wed, 2023-05-24 at 19:26 +0800, Yunsheng Lin wrote:
>> On 2023/5/24 0:35, Dragos Tatulea wrote:
>>>
>>> On Tue, 2023-05-23 at 17:55 +0200, Jesper Dangaard Brouer wrote:
>>>>
>>>> When the mlx5 driver runs an XDP program doing XDP_REDIRECT, then memory
>>>> is getting leaked. Other XDP actions, like XDP_DROP, XDP_PASS and XDP_TX
>>>> works correctly. I tested both redirecting back out same mlx5 device and
>>>> cpumap redirect (with XDP_PASS), which both cause leaking.
>>>>
>>>> After removing the XDP prog, which also cause the page_pool to be
>>>> released by mlx5, then the leaks are visible via the page_pool periodic
>>>> inflight reports. I have this bpftrace[1] tool that I also use to detect
>>>> the problem faster (not waiting 60 sec for a report).
>>>>
>>>>   [1] 
>>>> https://github.com/xdp-project/xdp-project/blob/master/areas/mem/bpftrace/page_pool_track_shutdown01.bt
>>>>
>>>> I've been debugging and reading through the code for a couple of days,
>>>> but I've not found the root-cause, yet. I would appreciate new ideas
>>>> where to look and fresh eyes on the issue.
>>>>
>>>>
>>>> To Lin, it looks like mlx5 uses PP_FLAG_PAGE_FRAG, and my current
>>>> suspicion is that mlx5 driver doesn't fully release the bias count (hint
>>>> see MLX5E_PAGECNT_BIAS_MAX).
>>
>> It seems mlx5 is implementing it's own frag allocation scheme, it there a
>> reason why the native frag allocation scheme in page pool is not used? To
>> avoid the "((page->pp_magic & ~0x3UL) == PP_SIGNATURE)" checking?
> 
> mlx5 uses fragmentation of the page from within the driver instead of the pre-
> partitioning of the page using page_pool_alloc_frag(). As shown in commit
> 52cc6ffc0ab2 ("page_pool: Refactor page_pool to enable fragmenting after
> allocation")

page_pool_alloc_frag() API does allow driver to allocate different number of
frag for the same page by specifying different 'size'.

> 
> The exception is however the following optimization:

The below rfc may be able to allow the following optimization using frag API
too.
https://patchwork.kernel.org/project/netdevbpf/cover/20230516124801.2465-1-linyunsheng@huawei.com/

> page_pool_put_defragged_page() can be called for XDP_TX directly to avoid the
> overhead of fragment management. That's because mlx5 currently supports only one
> packet per page for XDP.
> 

it seems almost everyone is doing the only one packet per page for XDP, but it is not
very memory saving for ususal case with 1.5K mtu with 4K page size if we reduce the xdp
headroom a little bit, and not to mention the 64K page size case.

