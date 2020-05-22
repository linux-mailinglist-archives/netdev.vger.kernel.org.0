Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA651DDB97
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgEVAE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgEVAE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 20:04:58 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 234A2207D8;
        Fri, 22 May 2020 00:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590105898;
        bh=nOzaaU4D0Dp728Lmp1J3pE4tiMfeddkJwOIqDp8fw7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KYkzfNVImZyFXO92ouqtFx4Wn+lahd/EenyTm9IWrUgKxLXTM7Mw4AaNfwE/cITko
         b+YC+mO7bXcilZnM+LaBWxom42ehoARofe5HFRsG96aBSpHIaegnxQtnKfkOS3J+AO
         Om4qy3Ilig1AZ97xiA9G4WIpQ+CrYDAPjondB7YM=
Date:   Fri, 22 May 2020 09:04:50 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/23] tracing/kprobes: handle mixed kernel/userspace
 probes better
Message-Id: <20200522090450.a6ef7a53878c61d10340949a@kernel.org>
In-Reply-To: <20200521152301.2587579-15-hch@lst.de>
References: <20200521152301.2587579-1-hch@lst.de>
        <20200521152301.2587579-15-hch@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 17:22:52 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Instead of using the dangerous probe_kernel_read and strncpy_from_unsafe
> helpers, rework probes to try a user probe based on the address if the
> architecture has a common address space for kernel and userspace.
> 

This looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  kernel/trace/trace_kprobe.c | 72 ++++++++++++++++++++++---------------
>  1 file changed, 43 insertions(+), 29 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 4325f9e7fadaa..4aeaef53ba970 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1200,6 +1200,15 @@ static const struct file_operations kprobe_profile_ops = {
>  
>  /* Kprobe specific fetch functions */
>  
> +/* Return the length of string -- including null terminal byte */
> +static nokprobe_inline int
> +fetch_store_strlen_user(unsigned long addr)
> +{
> +	const void __user *uaddr =  (__force const void __user *)addr;
> +
> +	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
> +}
> +
>  /* Return the length of string -- including null terminal byte */
>  static nokprobe_inline int
>  fetch_store_strlen(unsigned long addr)
> @@ -1207,30 +1216,27 @@ fetch_store_strlen(unsigned long addr)
>  	int ret, len = 0;
>  	u8 c;
>  
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +	if (addr < TASK_SIZE)
> +		return fetch_store_strlen_user(addr);
> +#endif
> +
>  	do {
> -		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
> +		ret = probe_kernel_read_strict(&c, (u8 *)addr + len, 1);
>  		len++;
>  	} while (c && ret == 0 && len < MAX_STRING_SIZE);
>  
>  	return (ret < 0) ? ret : len;
>  }
>  
> -/* Return the length of string -- including null terminal byte */
> -static nokprobe_inline int
> -fetch_store_strlen_user(unsigned long addr)
> -{
> -	const void __user *uaddr =  (__force const void __user *)addr;
> -
> -	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
> -}
> -
>  /*
> - * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
> - * length and relative data location.
> + * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
> + * with max length and relative data location.
>   */
>  static nokprobe_inline int
> -fetch_store_string(unsigned long addr, void *dest, void *base)
> +fetch_store_string_user(unsigned long addr, void *dest, void *base)
>  {
> +	const void __user *uaddr =  (__force const void __user *)addr;
>  	int maxlen = get_loc_len(*(u32 *)dest);
>  	void *__dest;
>  	long ret;
> @@ -1240,11 +1246,7 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
>  
>  	__dest = get_loc_data(dest, base);
>  
> -	/*
> -	 * Try to get string again, since the string can be changed while
> -	 * probing.
> -	 */
> -	ret = strncpy_from_unsafe(__dest, (void *)addr, maxlen);
> +	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
>  	if (ret >= 0)
>  		*(u32 *)dest = make_data_loc(ret, __dest - base);
>  
> @@ -1252,35 +1254,37 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
>  }
>  
>  /*
> - * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
> - * with max length and relative data location.
> + * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
> + * length and relative data location.
>   */
>  static nokprobe_inline int
> -fetch_store_string_user(unsigned long addr, void *dest, void *base)
> +fetch_store_string(unsigned long addr, void *dest, void *base)
>  {
> -	const void __user *uaddr =  (__force const void __user *)addr;
>  	int maxlen = get_loc_len(*(u32 *)dest);
>  	void *__dest;
>  	long ret;
>  
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +	if ((unsigned long)addr < TASK_SIZE)
> +		return fetch_store_string_user(addr, dest, base);
> +#endif
> +
>  	if (unlikely(!maxlen))
>  		return -ENOMEM;
>  
>  	__dest = get_loc_data(dest, base);
>  
> -	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
> +	/*
> +	 * Try to get string again, since the string can be changed while
> +	 * probing.
> +	 */
> +	ret = strncpy_from_user_nofault(__dest, (void *)addr, maxlen);
>  	if (ret >= 0)
>  		*(u32 *)dest = make_data_loc(ret, __dest - base);
>  
>  	return ret;
>  }
>  
> -static nokprobe_inline int
> -probe_mem_read(void *dest, void *src, size_t size)
> -{
> -	return probe_kernel_read(dest, src, size);
> -}
> -
>  static nokprobe_inline int
>  probe_mem_read_user(void *dest, void *src, size_t size)
>  {
> @@ -1289,6 +1293,16 @@ probe_mem_read_user(void *dest, void *src, size_t size)
>  	return probe_user_read(dest, uaddr, size);
>  }
>  
> +static nokprobe_inline int
> +probe_mem_read(void *dest, void *src, size_t size)
> +{
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +	if ((unsigned long)src < TASK_SIZE)
> +		return probe_mem_read_user(dest, src, size);
> +#endif
> +	return probe_kernel_read_strict(dest, src, size);
> +}
> +
>  /* Note that we don't verify it, since the code does not come from user space */
>  static int
>  process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
> -- 
> 2.26.2
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
