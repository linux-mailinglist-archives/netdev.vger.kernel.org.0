Return-Path: <netdev+bounces-5849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD46971323C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 05:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 787781C20F46
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A272F39E;
	Sat, 27 May 2023 03:54:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2D0389
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 03:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1899AC433EF;
	Sat, 27 May 2023 03:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685159651;
	bh=4VBv7cj0/3RmXKILqJxI8XT4lU0273xO3MquSuWGEwk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CyhrMX609RlDwkP1Ry9yaWcXvsO6Z/j8CnJT02pDXPXqBuEwqrAzgwokVRLvlGzLE
	 MhWQt633AyUyd37gALmn3Wy9bUXEqt7Me7dHABGZqxveHlritOulBu58dHzNmbA85j
	 09F5hm/8hG4J/jqTRpchwln0XD1QT8/DlDFPaVjAL6mzKThf/rOdvGBwY73AsbZZCb
	 0jbeBhIeRJwzSQWYTj2mIHUpRgosRlqStxfhmyGAmqHQ+jbBtZYrzGcsaaPK4+rJ3n
	 ibxPUB/gVAjV+dTTHk0H2Lx3HO1A9376maxeUN8FBnBRLVXUNPnXjFwu2H9czjeWU3
	 tYvV+k1pGhWfQ==
Date: Fri, 26 May 2023 20:54:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
 netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/12] net: skbuff: don't include
 <net/page_pool.h> into <linux/skbuff.h>
Message-ID: <20230526205410.3f849071@kernel.org>
In-Reply-To: <20230525125746.553874-7-aleksander.lobakin@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
	<20230525125746.553874-7-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 14:57:40 +0200 Alexander Lobakin wrote:
> Currently, touching <net/page_pool.h> triggers a rebuild of more than
> a half of the kernel. That's because it's included in <linux/skbuff.h>.
> 
> In 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling"),
> Matteo included it to be able to call a couple functions defined there.
> Then, in 57f05bc2ab24 ("page_pool: keep pp info as long as page pool
> owns the page") one of the calls was removed, so only one left.
> It's call to page_pool_return_skb_page() in napi_frag_unref(). The
> function is external and doesn't have any dependencies. Having include
> of very niche page_pool.h only for that looks like an overkill.
> Instead, move the declaration of that function to skbuff.h itself, with
> a small comment that it's a special guest and should not be touched.
> Now, after a few include fixes in the drivers, touching page_pool.h
> only triggers rebuilding of the drivers using it and a couple core
> networking files.

drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c

came in the meantime, and did not bother including page_pool.h.
-- 
pw-bot: cr

