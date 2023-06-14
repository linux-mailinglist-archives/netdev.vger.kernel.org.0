Return-Path: <netdev+bounces-10586-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA7D72F34C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27D1B1C20A9D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9B264C;
	Wed, 14 Jun 2023 03:55:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18697363
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFFBC433C0;
	Wed, 14 Jun 2023 03:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686714919;
	bh=PAwp8P6P+bo9ED/GohZphvO5u0BbH5QkU+e6HYEe9V8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h1pkU99e7ldbnbGhCLIzgn4hvR9OkW0h9xABQQwEqSkKgKDwkimLQz01NWRBFGQKg
	 CA0mSiOEPJ1x0s2NsRL+Jd2Y4xcyGeHEKrYIohTwVUjz40zuUasrd5HFbuh/tdRV8H
	 kYn9lTKWs0kOY6g2+Pr6aoxdGlR8+gRQUnqwpCXzitqvn0yM6yI9DEyQs2ejFHYUYY
	 M35Alj7TaVuQkYuscsiGwDlcIxwchQfGyyFRAIchghxfvk53VztjwBs/qHPCUpWdtw
	 t9ZLh17rOtCPF4HN8qFevTf/D8KWmcgbO7DOqH0KvsghbfXpLWC2C7FGRMH1//Gyu6
	 Ja8A+5PiUJUTw==
Date: Tue, 13 Jun 2023 20:55:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>, <davem@davemloft.net>,
 <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next v4 1/5] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
Message-ID: <20230613205518.56c61170@kernel.org>
In-Reply-To: <6db097ba-c3fe-6e45-3c39-c21b4d9e16ef@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-2-linyunsheng@huawei.com>
	<483d7a70-3377-a241-4554-212662ee3930@intel.com>
	<6db097ba-c3fe-6e45-3c39-c21b4d9e16ef@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 11:36:28 +0800 Yunsheng Lin wrote:
> > As Jakub previously mentioned, this involves including dma-mapping.h,
> > which is relatively heavy, to each source file which includes skbuff.h,
> > i.e. almost the whole kernel :D  
> 
> I am not sure I understand the part about 'includes skbuff.h' yet, it seems
> 'skbuff.h' does not have anything related to this patch?

$ git grep net/page_pool.h -- include/linux/skbuff.h
include/linux/skbuff.h:#include <net/page_pool.h>

> > I addressed this in my series, which I hope will land soon after yours
> > (sending new revision in 24-48 hours), so you can leave it as it is. Or
> > otherwise you can pick my solution (or come up with your own :D).  
> 
> Do you mean by removing "#include <linux/dma-direction.h>" as dma-mapping.h
> has included dma-direction.h?
> But I am not sure if there is any hard rule about not explicitly including
> a .h which is implicitly included. What if the dma-mapping.h is changed to not
> include dma-direction.h anymore?
> 
> Anyway, it seems it is unlikely to not include dma-direction.h in dma-mapping.h,
> Will remove the "#include <linux/dma-direction.h>" if there is another version
> needed for this patchset:)

The point is that we don't want commonly included headers to pull
in huge dependencies. Please run the preprocessor on
linux/dma-direction.h, you'll see how enormous it is.

