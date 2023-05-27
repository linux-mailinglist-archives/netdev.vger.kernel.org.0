Return-Path: <netdev+bounces-5833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6127E7130F2
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 02:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C47A71C2100E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DC837E;
	Sat, 27 May 2023 00:50:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F58F37D
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 00:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CF1C433D2;
	Sat, 27 May 2023 00:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685148604;
	bh=PctGZlrrzibp7UAnk07C/sOmUfyQ9mUKgJg38V2xuBU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b5IVwgYRE/2EVTpq7191D0vqSuCOLDLA9yxTg8kzF2RTtrFlASvkrFmPLaJtaVukQ
	 dx5NKWsr6CkQoGLe9DVthIsfhGRUMLCIhOM3QVgrl7be2FWaDy+DnfW190vcVwTJ2s
	 zU16jMx+fgyZWf833+TKCK1dS9ojn0TwISpmHXXc4A6MxBBQ/0mOPvMaIk698Velpj
	 TprITEm52LvMpvY15nmUsfSBRWn/PIGwebDUf9F7yPhJw536eOoYIVLCUc4Fu6rjuw
	 5mKxlb8geTfkhmlqwBdxW8lU1ju4L3hTlb8r95qR77Md4eoESwaMNVfTOzd1VQdYKQ
	 4GtDL57/Vxi2w==
Date: Fri, 26 May 2023 17:50:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jeroen de Borst
 <jeroendb@google.com>, Catherine Sullivan <csully@google.com>, Shailend
 Chand <shailend@google.com>, Felix Fietkau <nbd@nbd.name>, John Crispin
 <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>, Mark Lee
 <Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Matthias
 Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH net-next 04/12] mm: Make the page_frag_cache allocator
 use multipage folios
Message-ID: <20230526175002.2591ccae@kernel.org>
In-Reply-To: <20230524153311.3625329-5-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-5-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 16:33:03 +0100 David Howells wrote:
> -	offset = nc->offset - fragsz;
> -	if (unlikely(offset < 0)) {
> -		page = virt_to_page(nc->va);
> -
> -		if (page_ref_count(page) != nc->pagecnt_bias)
> +	offset = nc->offset;
> +	if (unlikely(fragsz > offset)) {
> +		/* Reuse the folio if everyone we gave it to has finished with
> +		 * it.
> +		 */
> +		if (!folio_ref_sub_and_test(folio, nc->pagecnt_bias)) {
> +			nc->folio = NULL;
>  			goto refill;
> +		}
> +
>  		if (unlikely(nc->pfmemalloc)) {
> -			page_ref_sub(page, nc->pagecnt_bias - 1);
> -			__free_pages(page, compound_order(page));
> +			__folio_put(folio);

This is not a pure 1:1 page -> folio conversion.
Why mix conversion with other code changes?

