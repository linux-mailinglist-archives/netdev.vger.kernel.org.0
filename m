Return-Path: <netdev+bounces-5835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8830713115
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04C952819DB
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F69A37F;
	Sat, 27 May 2023 01:02:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7339537D
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18C2C433D2;
	Sat, 27 May 2023 01:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685149331;
	bh=ZwOFaZCsGo5Z6NIy7+xs42xc8Amx32M/il4XYJjhbD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fc1jYAjBz04h3V8l4htX8rqAQJ7PLOdb2JvNQpK0YOjXOKXp1btTR69FHHfS2RMsH
	 TWLelyvSzOoucga78KhbNqg+T9KMUfMvD14ABNMLfviKBWEQn0op8ewHeXzb1OH8cf
	 QXEiYWrKiValrxacMzVe+xfy4a0SMfBj6lSrnsGkHPO6BMeQigISxOFjOUjm1xsVU1
	 yuK6nr6zEi1I71vC3v/GFVMLMmswCpXZ7H4PIdjGnwItwx8jz/IrFaaUbDMdNWwmQ+
	 wYisGm+TES66BOFTwuuFf95hMqee1x+CabpMF3pk8eH//byAghGAMNWJQaSOwdUmSK
	 rrmfwWQTNAu8w==
Date: Fri, 26 May 2023 18:02:08 -0700
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
Subject: Re: [PATCH net-next 06/12] mm: Make the page_frag_cache allocator
 use per-cpu
Message-ID: <20230526180208.3e617818@kernel.org>
In-Reply-To: <20230524153311.3625329-7-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-7-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 16:33:05 +0100 David Howells wrote:
> though if a softirq wants to access it, then softirq disablement will
> need to be added.

Pretty sure GVE uses their allocator from softirq.
So this doesn't work, right?

