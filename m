Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C037F312ADA
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 07:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBHGoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 01:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhBHGoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 01:44:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F203C64DF2;
        Mon,  8 Feb 2021 06:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612766620;
        bh=oYA/AVn+bfGJm7qXi8MLW81hB0Q1yDAasV3aGEfz8Gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HhCKyalGYu6UD8SFq73v95j8lCl9wscEJZhOvKK4v9ZxxiIejhYXsiY1fwF2Jx86l
         BUlGaDmiCGsKgVzXjfvobzob86Hk80fBDZtre9RGiorAw43JqohtZ3bYQMAEPHcHkz
         qS/LccR3vu1EPFSnrvbVTiGPSBq0ZOgU/iFHUumRBoUHA3sAZVV2BTMu+RBmgm524J
         fDmkM9B97RFMqOI6SyDtno0BOCNVdzB2yeYXWC1OPKY7yTlbQ0jA4EKD+kqthiPio4
         aKIWCR4CvTfxNT/OH7ffvIj81C024wbsuA2lYuCJOvXjDTWjllNjLhyy3AM3EZ45Up
         9zUEdbx0skX2A==
Date:   Mon, 8 Feb 2021 08:43:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     wanghongzhe <wanghongzhe@huawei.com>
Cc:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] seccomp: Improve performance by optimizing memory barrier
Message-ID: <20210208064336.GA4656@unreal>
References: <1612183781-15469-1-git-send-email-wanghongzhe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612183781-15469-1-git-send-email-wanghongzhe@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 08:49:41PM +0800, wanghongzhe wrote:
> If a thread(A)'s TSYNC flag is set from seccomp(), then it will
> synchronize its seccomp filter to other threads(B) in same thread
> group. To avoid race condition, seccomp puts rmb() between
> reading the mode and filter in seccomp check patch(in B thread).
> As a result, every syscall's seccomp check is slowed down by the
> memory barrier.
>
> However, we can optimize it by calling rmb() only when filter is
> NULL and reading it again after the barrier, which means the rmb()
> is called only once in thread lifetime.
>
> The 'filter is NULL' conditon means that it is the first time
> attaching filter and is by other thread(A) using TSYNC flag.
> In this case, thread B may read the filter first and mode later
> in CPU out-of-order exection. After this time, the thread B's
> mode is always be set, and there will no race condition with the
> filter/bitmap.
>
> In addtion, we should puts a write memory barrier between writing
> the filter and mode in smp_mb__before_atomic(), to avoid
> the race condition in TSYNC case.
>
> Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
> ---
>  kernel/seccomp.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 952dc1c90229..b944cb2b6b94 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -397,8 +397,20 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
>  			READ_ONCE(current->seccomp.filter);
>
>  	/* Ensure unexpected behavior doesn't result in failing open. */
> -	if (WARN_ON(f == NULL))
> -		return SECCOMP_RET_KILL_PROCESS;
> +	if (WARN_ON(f == NULL)) {
> +		/*
> +		 * Make sure the first filter addtion (from another
> +		 * thread using TSYNC flag) are seen.
> +		 */
> +		rmb();
> +
> +		/* Read again */
> +		f = READ_ONCE(current->seccomp.filter);
> +
> +		/* Ensure unexpected behavior doesn't result in failing open. */
> +		if (WARN_ON(f == NULL))
> +			return SECCOMP_RET_KILL_PROCESS;
> +	}

IMHO, double WARN_ON() for the fallback flow is too much.
Also according to the description, this "f == NULL" check is due to
races and not programming error which WARN_ON() are intended to catch.

Thanks
