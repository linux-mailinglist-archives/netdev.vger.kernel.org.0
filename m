Return-Path: <netdev+bounces-2612-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE77A702B27
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AB72281242
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A17BE79;
	Mon, 15 May 2023 11:11:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B404279D7;
	Mon, 15 May 2023 11:11:16 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38C81FC9;
	Mon, 15 May 2023 04:10:55 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QKc7D2lSVzsRb1;
	Mon, 15 May 2023 19:08:40 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 15 May
 2023 19:10:38 +0800
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint using
 half page per-buffer
To: Lorenzo Bianconi <lorenzo@kernel.org>, <netdev@vger.kernel.org>
CC: <lorenzo.bianconi@redhat.com>, <bpf@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<hawk@kernel.org>, <john.fastabend@gmail.com>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
Date: Mon, 15 May 2023 19:10:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/12 21:08, Lorenzo Bianconi wrote:
> In order to reduce page_pool memory footprint, rely on
> page_pool_dev_alloc_frag routine and reduce buffer size
> (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page

Is there any performance improvement beside the memory saving? As it
should reduce TLB miss, I wonder if the TLB miss reducing can even
out the cost of the extra frag reference count handling for the
frag support?

> for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
> (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
> Please note, using default values (CONFIG_MAX_SKB_FRAGS=17), maximum
> supported MTU is now reduced to 36350B.

Maybe we don't need to limit the frag size to VETH_PAGE_POOL_FRAG_SIZE,
and use different frag size depending on the mtu or packet size?

Perhaps the page_pool_dev_alloc_frag() can be improved to return non-frag
page if the requested frag size is larger than a specified size too.
I will try to implement it if the above idea makes sense.

