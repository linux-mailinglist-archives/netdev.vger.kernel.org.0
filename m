Return-Path: <netdev+bounces-7301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1F171F94C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 025B92819D1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83631867;
	Fri,  2 Jun 2023 04:26:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C6515BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95771C433D2;
	Fri,  2 Jun 2023 04:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685679965;
	bh=vgxmM8gee8RtCXtFTzRUQO/G6A58vACvmzt68NVAX0M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vPY4GJLe4C6DKwW6+F76+SWbGzw6pL2FETk4Dxjy2SieGjJZ8eH7CgJ53nv/dp1M9
	 n+WC1eogQzHQWmgdY85qqy2nWrZUtI+Uh+oRX9nJ050YCqJEVO5zehMcIusL2RauO2
	 HiXSycaKjk5Rp7FGBW7oAHH9OeiYQ+BTC1chdtZ6O7xkZjCge/lQxYzbpXGlykTFxN
	 WDyPTsEvV6vLE5FgEg9LTXkCBsW4TKoVgvocnDwXoHBT3aGABj2Or121agigD/DBM+
	 B0PrldVEOWtYnveQMb09VUk1Y6BI6q9eni9n8OwhBBAQ+3kjYOzX9ovpTLJ5c2B9LT
	 1xKjuvASKagRw==
Date: Thu, 1 Jun 2023 21:26:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stefan Roesch <shr@devkernel.io>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <20230601212604.3f5e2342@kernel.org>
In-Reply-To: <qvqwedmuv6mu.fsf@devbig1114.prn1.facebook.com>
References: <20230518211751.3492982-1-shr@devkernel.io>
	<20230518211751.3492982-2-shr@devkernel.io>
	<20230531103224.17a462cc@kernel.org>
	<qvqwleh41f8x.fsf@devbig1114.prn1.facebook.com>
	<20230531211537.2a8fda0f@kernel.org>
	<qvqwedmuv6mu.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 01 Jun 2023 21:12:10 -0700 Stefan Roesch wrote:
> The problem with checking need_resched in loop_end is that need_resched
> can be false in loop_end, however the check for need_resched in
> napi_busy_loop succeeds. This means that we unlock the rcu read lock and
> call schedule. However the code in io_napi_blocking_busy_loop still
> believes we hold the read lock.

Ah, yes, now it makes sense. 
Yeah, that's a race, scratch the workaround idea then.
Let's work on revising the patches, we'll see where we 
are in the development process when they're ready.

