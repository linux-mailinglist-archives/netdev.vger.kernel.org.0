Return-Path: <netdev+bounces-4391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA2570C530
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA09F280F4E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:29:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B040A168A9;
	Mon, 22 May 2023 18:29:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBD1642C
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AEEC433EF;
	Mon, 22 May 2023 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684780170;
	bh=1pIk7qKCV3k7ad3IrhBKJD+/2aFoOjWYJGEBijpFyxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hPfD5jA7QPUWyCotXeV6JPibYzrKGgel3zs8ZqrRpFmMzMnBkwf+HHsc+GQjBHVGo
	 lOi5r9y9WDVEY3cuSmEalzWXOS9QxKbTIJbiEQhOZzhpQh7WGjh56rKfEyRprjYbqJ
	 OarIP9Ysz8pYEEq59HcdpwRAqyTWH/J1ctcll9Kw=
Date: Mon, 22 May 2023 19:29:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: Sasha Levin <sashal@kernel.org>, linux- stable <stable@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	ndesaulniers@google.com, rientjes@google.com, vbabka@suse.cz,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: Stable backport request: skbuff: Proactively round up to kmalloc
 bucket size
Message-ID: <2023052222-kung-catchy-0044@gregkh>
References: <CAEUSe78ip=wkHUSz3mBFMcd-LjQAnByuJm1Oids5GSRm-J-dzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe78ip=wkHUSz3mBFMcd-LjQAnByuJm1Oids5GSRm-J-dzA@mail.gmail.com>

On Mon, May 22, 2023 at 12:23:50PM -0600, Daniel Díaz wrote:
> Hello!
> 
> Would the stable maintainers please consider backporting the following
> commit to the 6.1? We are trying to build gki_defconfig (plus a few
> extras) on Arm64 and test it under Qemu-arm64, but it fails to boot.
> Bisection has pointed here.

I do not see a "gki_defconfig" in the kernel tree, is this just
out-of-tree stuff?

If so, why not just add this to your out-of-tree stuff?

> We have verified that cherry-picking this patch on top of v6.1.29
> applies cleanly and allows the kernel to boot.

So what is breaking that requires this to fix the problem?  What is the
problem?

> 
> commit 12d6c1d3a2ad0c199ec57c201cdc71e8e157a232
> Author: Kees Cook <keescook@chromium.org>
> Date:   Tue Oct 25 15:39:35 2022 -0700
> 
>     skbuff: Proactively round up to kmalloc bucket size
> 
>     Instead of discovering the kmalloc bucket size _after_ allocation, round
>     up proactively so the allocation is explicitly made for the full size,
>     allowing the compiler to correctly reason about the resulting size of
>     the buffer through the existing __alloc_size() hint.
> 
>     This will allow for kernels built with CONFIG_UBSAN_BOUNDS or the
>     coming dynamic bounds checking under CONFIG_FORTIFY_SOURCE to gain
>     back the __alloc_size() hints that were temporarily reverted in commit
>     93dd04ab0b2b ("slab: remove __alloc_size attribute from
> __kmalloc_track_caller")
> 
>     Cc: "David S. Miller" <davem@davemloft.net>
>     Cc: Eric Dumazet <edumazet@google.com>
>     Cc: Jakub Kicinski <kuba@kernel.org>
>     Cc: Paolo Abeni <pabeni@redhat.com>
>     Cc: netdev@vger.kernel.org
>     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Cc: Nick Desaulniers <ndesaulniers@google.com>
>     Cc: David Rientjes <rientjes@google.com>
>     Acked-by: Vlastimil Babka <vbabka@suse.cz>
>     Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221021234713.you.031-kees@kernel.org/
>     Signed-off-by: Kees Cook <keescook@chromium.org>
>     Link: https://lore.kernel.org/r/20221025223811.up.360-kees@kernel.org
>     Signed-off-by: Paolo Abeni <pabeni@redhat.com>

This feels like a new feature, why would a 6.1.y system need it?  What
commit id does it fix?

thanks,

greg k-h

