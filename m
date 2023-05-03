Return-Path: <netdev+bounces-51-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A06A06F4ED2
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 04:33:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C04E1C20A0D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B971A7EA;
	Wed,  3 May 2023 02:33:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773597E9
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818BBC433EF;
	Wed,  3 May 2023 02:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683081191;
	bh=buveVOwFOebuwLuyDRCX6PdscONvgUosbbXfzhd3W2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iIJPFXex4+ouazaqpf+lM5PNzTtuWJnALfMGpQrgzBy3P4dcBM1GP5cTFQL44ukql
	 DfaI3KMZxCupVg9YtoRyNSYuo8nbZdy6Mp4RX3+wXAK71MbPE/t2ZT9LUMX6Fkewun
	 U0rWMCXjNWfW39cHNDJ9of3/vZX7K1FcZQcOcFckmLrQHj9xHB77cgVMh8T70AxcCm
	 7ec7T9eVowrwNks7ZCiHqFzdh7Bmg3THf9lJfTJiGS0WJ4shjhT5R9neMiHBuFcyFd
	 hNRFctxjGQ6rCVBN6kkGqnhir9X29nfrygJf4/n4UtXEPJGb0oMjONvlrPtfkZy1Ac
	 STkUAyLXD9OLA==
Date: Tue, 2 May 2023 19:33:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, netdev@vger.kernel.org,
 Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org, Mel Gorman
 <mgorman@techsingularity.net>, lorenzo@kernel.org, Toke =?UTF-8?B?SMO4?=
 =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
 linyunsheng@huawei.com, bpf@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V3 1/2] page_pool: Remove workqueue in
 new shutdown scheme
Message-ID: <20230502193309.382af41e@kernel.org>
In-Reply-To: <168269857929.2191653.13267688321246766547.stgit@firesoul>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
	<168269857929.2191653.13267688321246766547.stgit@firesoul>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Apr 2023 18:16:19 +0200 Jesper Dangaard Brouer wrote:
> This removes the workqueue scheme that periodically tests when
> inflight reach zero such that page_pool memory can be freed.
> 
> This change adds code to fast-path free checking for a shutdown flags
> bit after returning PP pages.

We can remove the warning without removing the entire delayed freeing
scheme. I definitely like the SHUTDOWN flag and patch 2 but I'm a bit
less clear on why the complexity of datapath freeing is justified.
Can you explain?

> Performance is very important for PP, as the fast path is used for
> XDP_DROP use-cases where NIC drivers recycle PP pages directly into PP
> alloc cache.
> 
> This patch (since V3) shows zero impact on this fast path. Micro
> benchmarked with [1] on Intel CPU E5-1650 @3.60GHz. The slight code
> reorg of likely() are deliberate.

