Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1101DB0E2
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgETLDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgETLDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 07:03:02 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54C63206F1;
        Wed, 20 May 2020 11:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589972581;
        bh=utyPQ/u7bwlzb7x8dQEbcEoU71e3JC9vp1bcYs20I9U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rngQvLz2MUGKZpewOVsH0Gp996X30NtOhiZA6Cbl0hEqhTknZQkQtDQFiHZHAEToY
         fgDm7RfVUybJvMWZuXAQNFp0jtJjFgHde5QiBByfKknhdpkLQu8UBIfHPc464pgZrb
         8JcdoCjPSOev7Zt6WeeVeI+PkJexXjdwsOwSI3WI=
Date:   Wed, 20 May 2020 20:02:55 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/20] maccess: return -ERANGE when
 copy_from_kernel_nofault_allowed fails
Message-Id: <20200520200255.3db6d27304f0b4c29c52ebcc@kernel.org>
In-Reply-To: <20200519134449.1466624-21-hch@lst.de>
References: <20200519134449.1466624-1-hch@lst.de>
        <20200519134449.1466624-21-hch@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 15:44:49 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Allow the callers to distinguish a real unmapped address vs a range
> that can't be probed.
> 
> Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hi Christoph,

Can you also update the kerneldoc comment too?
Other than that, this looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> ---
>  mm/maccess.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/maccess.c b/mm/maccess.c
> index 1e7d77656c596..4010d64189d21 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -25,7 +25,7 @@ bool __weak copy_from_kernel_nofault_allowed(void *dst, const void *unsafe_src,
>  long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>  {
>  	if (!copy_from_kernel_nofault_allowed(dst, src, size))
> -		return -EFAULT;
> +		return -ERANGE;
>  
>  	pagefault_disable();
>  	copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
> @@ -69,7 +69,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
>  	if (unlikely(count <= 0))
>  		return 0;
>  	if (!copy_from_kernel_nofault_allowed(dst, unsafe_addr, count))
> -		return -EFAULT;
> +		return -ERANGE;
>  
>  	pagefault_disable();
>  	do {
> @@ -107,7 +107,7 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
>  	mm_segment_t old_fs = get_fs();
>  
>  	if (!copy_from_kernel_nofault_allowed(dst, src, size))
> -		return -EFAULT;
> +		return -ERANGE;
>  
>  	set_fs(KERNEL_DS);
>  	pagefault_disable();
> @@ -174,7 +174,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
>  	if (unlikely(count <= 0))
>  		return 0;
>  	if (!copy_from_kernel_nofault_allowed(dst, unsafe_addr, count))
> -		return -EFAULT;
> +		return -ERANGE;
>  
>  	set_fs(KERNEL_DS);
>  	pagefault_disable();
> -- 
> 2.26.2
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
