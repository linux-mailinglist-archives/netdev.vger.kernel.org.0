Return-Path: <netdev+bounces-3377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98034706BE2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C7D41C20D7C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BF0524E;
	Wed, 17 May 2023 14:58:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AF328FC;
	Wed, 17 May 2023 14:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0FCC43326;
	Wed, 17 May 2023 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684335531;
	bh=kIz5xBLEXhifyZ8N2dcqqiMB6KkgKiXZDcg0Thxukbs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y8bEvVr9TOEYWKn3dRGMIkaww+aDG+iIH/5UHJxfgMA/FNG7t5qvnwsfJNYTck1QO
	 Fw+RdSmYqGD05qZ+8Z8w9iyS2KWgkXhw9kml6Aeyg6Jy66sJsKRuUJTENAPY1fWP6q
	 83CPQIxjt3iMZBfCRcp/ekJey0p1ZeH7gNUzAdgar+cAOWmWCffxGDicBjuoQA24IE
	 vtRxIpqdU0WYjqyx6q02MfydQiHP+zPaRAUOiaqmuIH3ad7hoQZ6j542Rx5fFdadx7
	 TDoqt2p3UmOWX6f3WiiREycHDemtODkHZEbhwa44goIrbmlXGPDxJfkxQB1bLiFyvJ
	 tBzYmBIQrv09w==
Date: Wed, 17 May 2023 07:58:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Lorenzo Bianconi
 <lorenzo.bianconi@redhat.com>, Yunsheng Lin <linyunsheng@huawei.com>,
 netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint
 using half page per-buffer
Message-ID: <20230517075849.2af98d72@kernel.org>
In-Reply-To: <ZGQJKRfuf4+av/MD@lore-desk>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
	<62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
	<ZGIWZHNRvq5DSmeA@lore-desk>
	<ZGIvbfPd46EIVZf/@boxer>
	<ZGQJKRfuf4+av/MD@lore-desk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 May 2023 00:52:25 +0200 Lorenzo Bianconi wrote:
> I am testing this RFC patch in the scenario reported below:
> 
> iperf tcp tx --> veth0 --> veth1 (xdp_pass) --> iperf tcp rx
> 
> - 6.4.0-rc1 net-next:
>   MTU 1500B: ~ 7.07 Gbps
>   MTU 8000B: ~ 14.7 Gbps
> 
> - 6.4.0-rc1 net-next + page_pool frag support in veth:
>   MTU 1500B: ~ 8.57 Gbps
>   MTU 8000B: ~ 14.5 Gbps
> 
> side note: it seems there is a regression between 6.2.15 and 6.4.0-rc1 net-next
> (even without latest veth page_pool patches) in the throughput I can get in the
> scenario above, but I have not looked into it yet.
> 
> - 6.2.15:
>   MTU 1500B: ~ 7.91 Gbps
>   MTU 8000B: ~ 14.1 Gbps
> 
> - 6.4.0-rc1 net-next w/o commits [0],[1],[2]
>   MTU 1500B: ~ 6.38 Gbps
>   MTU 8000B: ~ 13.2 Gbps

If the benchmark is iperf, wouldn't working towards preserving GSO
status across XDP (assuming prog is multi-buf-capable) be the most
beneficial optimization?

