Return-Path: <netdev+bounces-11185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6E5731E37
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CB611C20A8C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3F02E0CB;
	Thu, 15 Jun 2023 16:51:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75872E0C3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC4EC433C0;
	Thu, 15 Jun 2023 16:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686847862;
	bh=SA2pNBT9rXkOkMo0yrYksTMes4Qn7xpsHyRRGfSHrNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jauPT1FygcEqkemg87cpPo2q0s6WnGOR/z9X8SQIeQ2UOZtal0IEaMOZ1U6qMFJxi
	 8RvOBwTnfOM195A/XxTOVm9lg2OClPekxb+nwFewy0B/Eg1usS5/bI3sBpfoN4HP8d
	 f4EG3W6qKy4APMHvImUGOTMOmjcJmi1YCnb4RxYumDCQSMcDK90u9h9T+xf6zujQHO
	 jDe/5lsd5J7mhBtBaKtP0ugCcWTGi9pBLt4FwsDy5v5c015Y1TrbIMhz2fmFQ3B2ni
	 0ztYO5fqWx+Fy+mZKHK9Aedf+gD8zYbw0+JLr1y2JbYMGih/FFiIjIcjXFEbtQxYU3
	 jPlcCKwf/NIbQ==
Date: Thu, 15 Jun 2023 09:51:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>, Yisen Zhuang
 <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Eric
 Dumazet <edumazet@google.com>, Sunil Goutham <sgoutham@marvell.com>, Geetha
 sowjanya <gakula@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
 hariprasad <hkelam@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Felix Fietkau <nbd@nbd.name>, Ryder Lee
 <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean Wang
 <sean.wang@mediatek.com>, Kalle Valo <kvalo@kernel.org>, Matthias Brugger
 <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 <linux-rdma@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>,
 <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH net-next v4 4/5] page_pool: remove PP_FLAG_PAGE_FRAG
 flag
Message-ID: <20230615095100.35c5eb10@kernel.org>
In-Reply-To: <8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-5-linyunsheng@huawei.com>
	<20230614101954.30112d6e@kernel.org>
	<8c544cd9-00a3-2f17-bd04-13ca99136750@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 15:17:39 +0800 Yunsheng Lin wrote:
> > Does hns3_page_order() set a good example for the users?
> > 
> > static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
> > {
> > #if (PAGE_SIZE < 8192)
> > 	if (ring->buf_size > (PAGE_SIZE / 2))
> > 		return 1;
> > #endif
> > 	return 0;
> > }
> > 
> > Why allocate order 1 pages for buffers which would fit in a single page?
> > I feel like this soft of heuristic should be built into the API itself.  
> 
> hns3 only support fixed buf size per desc by 512 byte, 1024 bytes, 2048 bytes
> 4096 bytes, see hns3_buf_size2type(), I think the order 1 pages is for buf size
> with 4096 bytes and system page size with 4K, as hns3 driver still support the
> per-desc ping-pong way of page splitting when page_pool_enabled is false.
> 
> With page pool enabled, you are right that order 0 pages is enough, and I am not
> sure about the exact reason we use the some order as the ping-pong way of page
> splitting now.
> As 2048 bytes buf size seems to be the default one, and I has not heard any one
> changing it. Also, it caculates the pool_size using something as below, so the
> memory usage is almost the same for order 0 and order 1:
> 
> .pool_size = ring->desc_num * hns3_buf_size(ring) /
> 		(PAGE_SIZE << hns3_page_order(ring)),
> 
> I am not sure it worth changing it, maybe just change it to set good example for
> the users:) anyway I need to discuss this with other colleague internally and do
> some testing before doing the change.

Right, I think this may be a leftover from the page flipping mode of
operation. But AFAIU we should leave the recycling fully to the page
pool now. If we make any improvements try to make them at the page pool
level.

I like your patches as they isolate the drivers from having to make the
fragmentation decisions based on the system page size (4k vs 64k but
we're hearing more and more about ARM w/ 16k pages). For that use case
this is great. 

What we don't want is drivers to start requesting larger page sizes
because it looks good in iperf on a freshly booted, idle system :(

