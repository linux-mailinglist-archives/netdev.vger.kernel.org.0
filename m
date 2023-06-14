Return-Path: <netdev+bounces-10809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BADE7305F5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07082281475
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 17:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1532EC3A;
	Wed, 14 Jun 2023 17:19:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925BF7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C177C433C8;
	Wed, 14 Jun 2023 17:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686763196;
	bh=FBPLlXJTl5oVPIOPzrt5kTOhHK/0WZZMZVMLcsH1ZH8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bqiLkMyQonScWxAcXtXXhd1qcoUafJ6eL0nHPu3TUwujOOG4LpGv2rjcQ/FMv593s
	 EsSCAoScxOeGSMMHD3r0PDfR9+anVV1dNoxh9twPpXpF11DtXyva8n7FLHbbnkpJy5
	 QObKzf/hPoHPr+rEdTZVFyCcilZhx5BniQehCirpuKcBm5kjgQ/aBk1vh18vJ01Z0G
	 gfXyH8HKchL6NXt/5SJLcdaSpj6YHufR1kHDx6K1F/34lxFLKfcPksvz46/UEELH4z
	 DWZGAVdOk7aWP3+lyo/0d/5ENzEBG5/ig3VIIIGIQZk1XPUsZ+RN+er8ucNVV2HRM2
	 xBlvXCCDubMZA==
Date: Wed, 14 Jun 2023 10:19:54 -0700
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
Message-ID: <20230614101954.30112d6e@kernel.org>
In-Reply-To: <20230612130256.4572-5-linyunsheng@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-5-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 21:02:55 +0800 Yunsheng Lin wrote:
>  	struct page_pool_params pp_params = {
> -		.flags = PP_FLAG_DMA_MAP | PP_FLAG_PAGE_FRAG |
> -				PP_FLAG_DMA_SYNC_DEV,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>  		.order = hns3_page_order(ring),

Does hns3_page_order() set a good example for the users?

static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
{
#if (PAGE_SIZE < 8192)
	if (ring->buf_size > (PAGE_SIZE / 2))
		return 1;
#endif
	return 0;
}

Why allocate order 1 pages for buffers which would fit in a single page?
I feel like this soft of heuristic should be built into the API itself.

