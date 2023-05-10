Return-Path: <netdev+bounces-1296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8466FD368
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 03:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B3A61C20C9C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEB837B;
	Wed, 10 May 2023 01:01:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6305362
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 01:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D20C433EF;
	Wed, 10 May 2023 01:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683680458;
	bh=UrItQrnIMs0ms+sPI5j1Hu3+52mp5ohTLkaAWkiKzsk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=czAzhJz1NBrHhvesrdhXOCzsPF9NJZpM9KBiimBJlbeaxSioAxPsw+6MiK98vLaIs
	 XdTCRCA86ZY++2JbcBUu3ufVxu+Lzbed6dWiINr+54ORspK4L3MyKg+ihC19tebi/W
	 Uq+0Ld0ShNXVeEJgzjwH3LV/5VzXqQT23pbAd2XMK/whPMnaNH/2ZNuj3wACoRaQOh
	 zuSp+a0x/1uQwTnjOhXQPdz1YC7sHLmFfEo45Io6eJvYKEzKnKWCgtp/CvllHKBJuJ
	 n1BsugIZieX0ezP4aa8h9AN7u773S8wvcu9vikdnCjKjY02f8O1bgteL/WPRNK13dW
	 GMx0ojJFX9J6g==
Date: Tue, 9 May 2023 18:00:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: <davem@davemloft.net>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v1 0/2] introduce skb_frag_fill_page_desc()
Message-ID: <20230509180057.1fc252c7@kernel.org>
In-Reply-To: <20230509114337.21005-1-linyunsheng@huawei.com>
References: <20230509114337.21005-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 9 May 2023 19:43:35 +0800 Yunsheng Lin wrote:
> Most users use __skb_frag_set_page()/skb_frag_off_set()/
> skb_frag_size_set() to fill the page desc for a skb frag.
> It does not make much sense to calling __skb_frag_set_page()
> without calling skb_frag_off_set(), as the offset may depend
> on whether the page is head page or tail page, so add
> skb_frag_fill_page_desc() to fill the page desc for a skb
> frag.
> 
> In the future, we can make sure the page in the frag is
> head page of compound page or a base page, if not, we
> may warn about that and convert the tail page to head
> page and update the offset accordingly, if we see a warning
> about that, we also fix the caller to fill the head page
> in the frag. when the fixing is done, we may remove the
> warning and converting.
> 
> In this way, we can remove the compound_head() or use
> page_ref_*() like the below case:
> https://elixir.bootlin.com/linux/latest/source/net/core/page_pool.c#L881
> https://elixir.bootlin.com/linux/latest/source/include/linux/skbuff.h#L3383
> 
> It may also convert net stack to use the folio easier.
> 
> RFC: remove a local variable as pointed out by Simon.

Looks like you posted this 3 times and different people replied with
their acks to different versions :(

Wait awhile, read:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
and repost with all the ack/review tags included.

