Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185BF1CD14D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgEKFeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgEKFeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 01:34:25 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C3D20820;
        Mon, 11 May 2020 05:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589175264;
        bh=kJeeoG5B4GJ20AKrkDh4g08qYgdhU/B7Z2q3qT5KBO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1ZLquqNbdRM35ixYt8goE15L+L0zW7urVMSquV2381Iy2xMXhen8mFe4x78yq0hiT
         iOuA7G0/2/IUZA5afnkyKXZz0ZS4YwiZxEfUqKYGdiLjjw6OydvLziYsImwAhLiSIV
         jQrtSyuYsHcqevnI6GxJKR00aaE1S3dlApsCSjKA=
Date:   Mon, 11 May 2020 14:34:19 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/15] maccess: remove strncpy_from_unsafe
Message-Id: <20200511143419.7511026ba60cbf9f6843a153@kernel.org>
In-Reply-To: <20200506062223.30032-12-hch@lst.de>
References: <20200506062223.30032-1-hch@lst.de>
        <20200506062223.30032-12-hch@lst.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 May 2020 08:22:19 +0200
Christoph Hellwig <hch@lst.de> wrote:

> All three callers really should try the explicit kernel and user
> copies instead.  One has already deprecated the somewhat dangerous
> either kernel or user address concept, the other two still need to
> follow up eventually.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> ---
>  include/linux/uaccess.h     |  1 -
>  kernel/trace/bpf_trace.c    | 40 ++++++++++++++++++++++++++-----------
>  kernel/trace/trace_kprobe.c |  5 ++++-
>  mm/maccess.c                | 39 +-----------------------------------
>  4 files changed, 33 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index f8c47395a92df..09d6e358883cc 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -311,7 +311,6 @@ extern long probe_user_read(void *dst, const void __user *src, size_t size);
>  extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
>  extern long notrace probe_user_write(void __user *dst, const void *src, size_t size);
>  
> -extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
>  extern long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr,
>  				       long count);
>  extern long strncpy_from_user_unsafe(char *dst, const void __user *unsafe_addr,
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e4e202f433903..ffe841433caa1 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -229,9 +229,10 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
>  	int ret = security_locked_down(LOCKDOWN_BPF_READ);
>  
>  	if (unlikely(ret < 0))
> -		goto out;
> +		goto fail;
> +
>  	/*
> -	 * The strncpy_from_unsafe_*() call will likely not fill the entire
> +	 * The strncpy_from_*_unsafe() call will likely not fill the entire
>  	 * buffer, but that's okay in this circumstance as we're probing
>  	 * arbitrary memory anyway similar to bpf_probe_read_*() and might
>  	 * as well probe the stack. Thus, memory is explicitly cleared
> @@ -239,11 +240,18 @@ bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsafe_ptr,
>  	 * code altogether don't copy garbage; otherwise length of string
>  	 * is returned that can be used for bpf_perf_event_output() et al.
>  	 */
> -	ret = compat ? strncpy_from_unsafe(dst, unsafe_ptr, size) :
> -	      strncpy_from_kernel_unsafe(dst, unsafe_ptr, size);
> -	if (unlikely(ret < 0))
> -out:
> -		memset(dst, 0, size);
> +	ret = strncpy_from_kernel_unsafe(dst, unsafe_ptr, size);
> +	if (unlikely(ret < 0)) {
> +		if (compat)
> +			ret = strncpy_from_user_unsafe(dst,
> +					(__force const void __user *)unsafe_ptr,
> +					size);
> +		if (ret < 0)
> +			goto fail;
> +	}
> +	return 0;
> +fail:
> +	memset(dst, 0, size);
>  	return ret;
>  }
>  
> @@ -321,6 +329,17 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
>  	return &bpf_probe_write_user_proto;
>  }
>  
> +#define BPF_STRNCPY_LEN 64
> +
> +static void bpf_strncpy(char *buf, long unsafe_addr)
> +{
> +	buf[0] = 0;
> +	if (strncpy_from_kernel_unsafe(buf, (void *)unsafe_addr,
> +			BPF_STRNCPY_LEN))
> +		strncpy_from_user_unsafe(buf, (void __user *)unsafe_addr,
> +				BPF_STRNCPY_LEN);
> +}
> +
>  /*
>   * Only limited trace_printk() conversion specifiers allowed:
>   * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
> @@ -332,7 +351,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>  	int mod[3] = {};
>  	int fmt_cnt = 0;
>  	u64 unsafe_addr;
> -	char buf[64];
> +	char buf[BPF_STRNCPY_LEN];
>  	int i;
>  
>  	/*
> @@ -387,10 +406,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>  					arg3 = (long) buf;
>  					break;
>  				}
> -				buf[0] = 0;
> -				strncpy_from_unsafe(buf,
> -						    (void *) (long) unsafe_addr,
> -						    sizeof(buf));
> +				bpf_strncpy(buf, unsafe_addr);
>  			}
>  			continue;
>  		}
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index a7f43c7ec9880..525d12137325c 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1238,7 +1238,10 @@ fetch_store_string(unsigned long addr, void *dest, void *base)
>  	 * Try to get string again, since the string can be changed while
>  	 * probing.
>  	 */
> -	ret = strncpy_from_unsafe(__dest, (void *)addr, maxlen);
> +	ret = strncpy_from_kernel_unsafe(__dest, (void *)addr, maxlen);
> +	if (ret < 0)
> +		ret = strncpy_from_user_unsafe(__dest, (void __user *)addr,
> +				maxlen);
>  	if (ret >= 0)
>  		*(u32 *)dest = make_data_loc(ret, __dest - base);
>  
> diff --git a/mm/maccess.c b/mm/maccess.c
> index 11563129cd490..cbd9d668aa46e 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -8,8 +8,6 @@
>  
>  static long __probe_kernel_read(void *dst, const void *src, size_t size,
>  		bool strict);
> -static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
> -		long count, bool strict);
>  
>  bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
>  		size_t size, bool strict)
> @@ -156,35 +154,6 @@ long probe_user_write(void __user *dst, const void *src, size_t size)
>  	return 0;
>  }
>  
> -/**
> - * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
> - * @dst:   Destination address, in kernel space.  This buffer must be at
> - *         least @count bytes long.
> - * @unsafe_addr: Unsafe address.
> - * @count: Maximum number of bytes to copy, including the trailing NUL.
> - *
> - * Copies a NUL-terminated string from unsafe address to kernel buffer.
> - *
> - * On success, returns the length of the string INCLUDING the trailing NUL.
> - *
> - * If access fails, returns -EFAULT (some data may have been copied
> - * and the trailing NUL added).
> - *
> - * If @count is smaller than the length of the string, copies @count-1 bytes,
> - * sets the last byte of @dst buffer to NUL and returns @count.
> - *
> - * Same as strncpy_from_kernel_unsafe() except that for architectures with
> - * not fully separated user and kernel address spaces this function also works
> - * for user address tanges.
> - *
> - * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
> - * separate kernel and user address spaces, and also a bad idea otherwise.
> - */
> -long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
> -{
> -	return __strncpy_from_unsafe(dst, unsafe_addr, count, false);
> -}
> -
>  /**
>   * strncpy_from_kernel_unsafe: - Copy a NUL terminated string from unsafe
>   *				 address.
> @@ -204,12 +173,6 @@ long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
>   * sets the last byte of @dst buffer to NUL and returns @count.
>   */
>  long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
> -{
> -	return __strncpy_from_unsafe(dst, unsafe_addr, count, true);
> -}
> -
> -static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
> -		long count, bool strict)
>  {
>  	mm_segment_t old_fs = get_fs();
>  	const void *src = unsafe_addr;
> @@ -217,7 +180,7 @@ static long __strncpy_from_unsafe(char *dst, const void *unsafe_addr,
>  
>  	if (unlikely(count <= 0))
>  		return 0;
> -	if (!probe_kernel_read_allowed(dst, unsafe_addr, count, strict))
> +	if (!probe_kernel_read_allowed(dst, unsafe_addr, count, true))
>  		return -EFAULT;
>  
>  	set_fs(KERNEL_DS);
> -- 
> 2.26.2
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
