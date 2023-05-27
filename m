Return-Path: <netdev+bounces-5834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BF671310B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 02:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7CA11C20D09
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 00:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E497837F;
	Sat, 27 May 2023 00:57:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A6C37D
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 00:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E64BC433D2;
	Sat, 27 May 2023 00:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685149058;
	bh=3vBQ3hNzB1htnPz205IbCSBNbcAAWMD/jc/FlGUItp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aLfMMwQjdwdNcKtVFIzBBfhEKhzY8608s+2D5qjQ0I+cctckwK72Fr7Ero4sCyOay
	 M/qiFF+9oqlrfB5lFVHgvB/IQFsOfaf9ms4w4pJrRSwroXILirP80J7tw+IvtlmrB6
	 C+axsiXhIPb8oG6HjqUu7w30SCHCFMI12quWVnGd07HNn5WSmjsVZ80qw6vSUhzlYV
	 EFiVNxsX5sNgu7rqArJbv4j1C2nsqWjTEvKw/tWgLNDZQKKWCIFaxsDirhg7FmbgbK
	 bcJ2BPiFi68edlfm+RtL/oOWB1hkdQHSRtYO/JKM041QmrEIOMfmOFV+oB8n4stFXo
	 EfbKoqmE3Uf6w==
Date: Fri, 26 May 2023 17:57:36 -0700
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
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
 Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 05/12] mm: Make the page_frag_cache allocator
 handle __GFP_ZERO itself
Message-ID: <20230526175736.7e75dcf9@kernel.org>
In-Reply-To: <20230524153311.3625329-6-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-6-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 16:33:04 +0100 David Howells wrote:
> Make the page_frag_cache allocator handle __GFP_ZERO itself rather than
> passing it off to the page allocator.  There may be a mix of callers, some
> specifying __GFP_ZERO and some not - and even if all specify __GFP_ZERO, we
> might refurbish the page, in which case the returned memory doesn't get
> cleared.

I think it's pretty clear that page frag allocator was never supposed
to support GFP_ZERO, as we don't need it in networking.. So maybe
you're better off adding the memset() in nvme?

CCing Alex, who I think would say something along those lines :)
IDK how much we still care given that most networking drivers are
migrating to page_poll these days.

