Return-Path: <netdev+bounces-3673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A49F70847F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21A59281965
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FFE21068;
	Thu, 18 May 2023 15:02:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCDF21067
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E875C4339E;
	Thu, 18 May 2023 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684422141;
	bh=xi3asrp56sPf98pO0KbOLnYOqohykz8L/amW+nqIs+E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uW8OufCuNHQQ7nfswu1Ueu3ITdB0P2RTXIV9e6yfCUYIDzzIs3AoQlrpKZcZGpqWh
	 V+YSitL1FBM+xQuHfKelmMh0UPmtfcC10y1z8KpUA30dzcVtLVa5muOzq/vBv/ZL53
	 B0M0aYFzy4IFXn6VZ6dzQxsuaxvY1/citOAINEvMEllDeEz0JwybCwSoT7so4mAQCC
	 9/4uKTi4VsIcphyWitNBpkhy3t6vLF4bmPmeqTDLngrUoXPRWGOSJ9GJKAN6iezcc7
	 +hj15JkZaXQDQ0fLcg0MOXMXu6mPaLORXIqkWqzEj02mcTH9l/xAVgukySFQCfSd6x
	 r1KXwdCLXJQzg==
Date: Thu, 18 May 2023 08:02:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Maciej Fijalkowski
 <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, <netdev@vger.kernel.org>,
 <intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 06/11] net: page_pool: avoid calling no-op
 externals when possible
Message-ID: <20230518080219.109675cc@kernel.org>
In-Reply-To: <f7a082ae-5ec8-484b-b602-559f6104c9d7@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
	<20230516161841.37138-7-aleksander.lobakin@intel.com>
	<20230517210804.7de610bd@kernel.org>
	<f7a082ae-5ec8-484b-b602-559f6104c9d7@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 May 2023 15:34:44 +0200 Alexander Lobakin wrote:
> And seems like I didn't get the sentence regarding "allocate and throw"
> :s This condition just disables the shortcut if any new page suddenly
> requires real DMA syncs (and if it does, then the sync a line below will
> take way more time than 1 more `if`  anyway).

Right, I misread.

