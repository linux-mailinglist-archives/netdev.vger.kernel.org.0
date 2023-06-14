Return-Path: <netdev+bounces-10590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F0672F3A4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EA8F281301
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 04:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DACD389;
	Wed, 14 Jun 2023 04:40:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07232361;
	Wed, 14 Jun 2023 04:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4107C433C8;
	Wed, 14 Jun 2023 04:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686717643;
	bh=0ucmmW3adV4+eqQVBYgvmKckBTOl6NDz0Ul52vNk6IM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dg5101Tl455j/arfoVjzrVjaCZJ819UcB4X9QiFmxupTrdGqx1Dqyyu0LzxEjeSgQ
	 bgdUJ+70vxtma18+RsVJ0os0UTx/4PnxmeQJjDfraBHIkaOCUPK2KFcudlKy46vMHD
	 jYPxoEWIB1RnzC9hoIbnBXX63RaKo4mkzvlj1yVqpmbtuPP1j1kDwPRgoKltNymPi5
	 dDy8BM78W/Tsxmcpl3HuV9Sux36JiZIb5qtTHEOOazDoSlftFhRcXNzDW2yVdAStsB
	 LLmwm8OEhXtnYN0V75Pl0o5YInS/HjzxIkDWfq2I/XtBH01g+SaFykQCa8kBEKI888
	 oBw+xT+d8oG0Q==
Date: Tue, 13 Jun 2023 21:40:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric
 Dumazet <edumazet@google.com>, Jonathan Corbet <corbet@lwn.net>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John
 Fastabend <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
 <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v4 5/5] page_pool: update document about frag
 API
Message-ID: <20230613214041.1c29a357@kernel.org>
In-Reply-To: <20230612130256.4572-6-linyunsheng@huawei.com>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
	<20230612130256.4572-6-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Jun 2023 21:02:56 +0800 Yunsheng Lin wrote:
> +2. page_pool_alloc_frag(): allocate memory with page splitting when driver knows
> +   that the memory it need is always smaller than or equal to half of the page
> +   allocated from page pool. Page splitting enables memory saving and thus avoid
> +   TLB/cache miss for data access, but there also is some cost to implement page
> +   splitting, mainly some cache line dirtying/bouncing for 'struct page' and
> +   atomic operation for page->pp_frag_count.
> +
> +3. page_pool_alloc(): allocate memory with or without page splitting depending
> +   on the requested memory size when driver doesn't know the size of memory it
> +   need beforehand. It is a mix of the above two case, so it is a wrapper of the
> +   above API to simplify driver's interface for memory allocation with least
> +   memory utilization and performance penalty.

Seems like the semantics of page_pool_alloc() are always better than
page_pool_alloc_frag(). Is there a reason to keep these two separate?

