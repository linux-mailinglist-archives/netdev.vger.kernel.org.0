Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8307D1CD142
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgEKF1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgEKF1X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 01:27:23 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA0D20708;
        Mon, 11 May 2020 05:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589174842;
        bh=naBkUaw9VrDl+DgPshY12bmlu/oIWsku411Vy2BSpyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWilgrdg8wTHncZwHfpEXq8GbOgJcNEbreHE9CP41Ck01bq33bW98rZY08mOd0fNS
         TkHo7k0T7K5TZKJjhJjgL86PVsFnN1Cb/gTF34itRdAezhJzri0x5zqn9sO0RC8rFd
         myUCNHrXLsXZLKyYqQEfdNL+tRt2r8tZhYrVn0sA=
Date:   Mon, 11 May 2020 14:27:16 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] maccess: always use strict semantics for
 probe_kernel_read
Message-Id: <20200511142716.f1ff6fc55220012982c47fec@kernel.org>
In-Reply-To: <20200511140536.a15f3f15c71309fdf219c2e4@kernel.org>
References: <20200506062223.30032-1-hch@lst.de>
        <20200506062223.30032-13-hch@lst.de>
        <20200511140536.a15f3f15c71309fdf219c2e4@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 May 2020 14:05:36 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hi Christoph,
> 
> At first, thank you for your work on cleaning up these functions!
> 
> On Wed,  6 May 2020 08:22:20 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Except for historical confusion in the kprobes/uprobes and bpf tracers
> > there is no good reason to ever allow user memory accesses from
> > probe_kernel_read.
> 
> Yes, thus now trace_kprobe supports "ustring" type for accessing
> user space memory. (If the address spaces are overwrapped, we have
> no way to distinguish whether an address is kernel or user)
> 
> >  Make the tracers fall back to a probe_user_read
> > if the probe_kernel_read falls to keep the core API clean.
> 
> For trace_kprobes doesn't need to fall back. User must specify
> the probe should be read from user space or kernel space. This is
> because it has  fetch_store_string_user() and probe_mem_read_user()
> variants.

Hmm, wait, I changed my mind. The "string" type currently supports
kernel and user (on some archs, e.g. x86), there is no reason to
restrict it. So let's keep the behavior.
Only if users want to trace "user" data, they can use "ustring".

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,


> 
> Thank you,
> 
> 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  arch/parisc/lib/memcpy.c    |  3 +--
> >  arch/um/kernel/maccess.c    |  3 +--
> >  arch/x86/mm/maccess.c       |  5 +----
> >  include/linux/uaccess.h     |  4 +---
> >  kernel/trace/bpf_trace.c    | 20 +++++++++++++------
> >  kernel/trace/trace_kprobe.c | 11 ++++++++++-
> >  mm/maccess.c                | 39 ++++++-------------------------------
> >  7 files changed, 34 insertions(+), 51 deletions(-)
> > 
> > diff --git a/arch/parisc/lib/memcpy.c b/arch/parisc/lib/memcpy.c
> > index 5ef648bd33119..9fe662b3b5604 100644
> > --- a/arch/parisc/lib/memcpy.c
> > +++ b/arch/parisc/lib/memcpy.c
> > @@ -57,8 +57,7 @@ void * memcpy(void * dst,const void *src, size_t count)
> >  EXPORT_SYMBOL(raw_copy_in_user);
> >  EXPORT_SYMBOL(memcpy);
> >  
> > -bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size,
> > -		bool strict)
> > +bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size)
> >  {
> >  	if ((unsigned long)unsafe_src < PAGE_SIZE)
> >  		return false;
> > diff --git a/arch/um/kernel/maccess.c b/arch/um/kernel/maccess.c
> > index 90a1bec923158..734f3d7e57c0f 100644
> > --- a/arch/um/kernel/maccess.c
> > +++ b/arch/um/kernel/maccess.c
> > @@ -7,8 +7,7 @@
> >  #include <linux/kernel.h>
> >  #include <os.h>
> >  
> > -bool probe_kernel_read_allowed(void *dst, const void *src, size_t size,
> > -		bool strict)
> > +bool probe_kernel_read_allowed(void *dst, const void *src, size_t size)
> >  {
> >  	void *psrc = (void *)rounddown((unsigned long)src, PAGE_SIZE);
> >  
> > diff --git a/arch/x86/mm/maccess.c b/arch/x86/mm/maccess.c
> > index 5c323ab187b27..a1bd81677aa72 100644
> > --- a/arch/x86/mm/maccess.c
> > +++ b/arch/x86/mm/maccess.c
> > @@ -26,10 +26,7 @@ static __always_inline bool invalid_probe_range(u64 vaddr)
> >  }
> >  #endif
> >  
> > -bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size,
> > -		bool strict)
> > +bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size)
> >  {
> > -	if (!strict)
> > -		return true;
> >  	return !invalid_probe_range((unsigned long)unsafe_src);
> >  }
> > diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> > index 09d6e358883cc..99e2c2a41164a 100644
> > --- a/include/linux/uaccess.h
> > +++ b/include/linux/uaccess.h
> > @@ -301,11 +301,9 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
> >  	return 0;
> >  }
> >  
> > -bool probe_kernel_read_allowed(void *dst, const void *unsafe_src,
> > -		size_t size, bool strict);
> > +bool probe_kernel_read_allowed(void *dst, const void *unsafe_src, size_t size);
> >  
> >  extern long probe_kernel_read(void *dst, const void *src, size_t size);
> > -extern long probe_kernel_read_strict(void *dst, const void *src, size_t size);
> >  extern long probe_user_read(void *dst, const void __user *src, size_t size);
> >  
> >  extern long notrace probe_kernel_write(void *dst, const void *src, size_t size);
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index ffe841433caa1..f694befe8ec9b 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -183,12 +183,20 @@ bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_ptr,
> >  	int ret = security_locked_down(LOCKDOWN_BPF_READ);
> >  
> >  	if (unlikely(ret < 0))
> > -		goto out;
> > -	ret = compat ? probe_kernel_read(dst, unsafe_ptr, size) :
> > -	      probe_kernel_read_strict(dst, unsafe_ptr, size);
> > -	if (unlikely(ret < 0))
> > -out:
> > -		memset(dst, 0, size);
> > +		goto fail;
> > +
> > +	ret = probe_kernel_read(dst, unsafe_ptr, size);
> > +	if (unlikely(ret < 0)) {
> > +		if (compat)
> > +			ret = probe_user_read(dst,
> > +				(__force const void __user *)unsafe_ptr, size);
> > +		if (unlikely(ret < 0))
> > +			goto fail;
> > +	}
> > +
> > +	return 0;
> > +fail:
> > +	memset(dst, 0, size);
> >  	return ret;
> >  }
> >  
> > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > index 525d12137325c..1300c9fd5c755 100644
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -1203,6 +1203,9 @@ fetch_store_strlen(unsigned long addr)
> >  
> >  	do {
> >  		ret = probe_kernel_read(&c, (u8 *)addr + len, 1);
> > +		if (ret)
> > +			ret = probe_user_read(&c,
> > +				(__force u8 __user *)addr + len, 1);
> >  		len++;
> >  	} while (c && ret == 0 && len < MAX_STRING_SIZE);
> >  
> > @@ -1275,7 +1278,13 @@ fetch_store_string_user(unsigned long addr, void *dest, void *base)
> >  static nokprobe_inline int
> >  probe_mem_read(void *dest, void *src, size_t size)
> >  {
> > -	return probe_kernel_read(dest, src, size);
> > +	int ret;
> > +
> > +	ret = probe_kernel_read(dest, src, size);
> > +	if (ret)
> > +		ret = probe_user_read(dest, (__force const void __user *)src,
> > +				size);
> > +	return ret;
> >  }
> >  
> >  static nokprobe_inline int
> > diff --git a/mm/maccess.c b/mm/maccess.c
> > index cbd9d668aa46e..811f49e8de113 100644
> > --- a/mm/maccess.c
> > +++ b/mm/maccess.c
> > @@ -6,36 +6,14 @@
> >  #include <linux/mm.h>
> >  #include <linux/uaccess.h>
> >  
> > -static long __probe_kernel_read(void *dst, const void *src, size_t size,
> > -		bool strict);
> > -
> >  bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
> > -		size_t size, bool strict)
> > +		size_t size)
> >  {
> >  	return true;
> >  }
> >  
> >  /**
> > - * probe_kernel_read(): safely attempt to read from any location
> > - * @dst: pointer to the buffer that shall take the data
> > - * @src: address to read from
> > - * @size: size of the data chunk
> > - *
> > - * Same as probe_kernel_read_strict() except that for architectures with
> > - * not fully separated user and kernel address spaces this function also works
> > - * for user address tanges.
> > - *
> > - * DO NOT USE THIS FUNCTION - it is broken on architectures with entirely
> > - * separate kernel and user address spaces, and also a bad idea otherwise.
> > - */
> > -long probe_kernel_read(void *dst, const void *src, size_t size)
> > -{
> > -	return __probe_kernel_read(dst, src, size, false);
> > -}
> > -EXPORT_SYMBOL_GPL(probe_kernel_read);
> > -
> > -/**
> > - * probe_kernel_read_strict(): safely attempt to read from kernel-space
> > + * probe_kernel_read(): safely attempt to read from kernel-space
> >   * @dst: pointer to the buffer that shall take the data
> >   * @src: address to read from
> >   * @size: size of the data chunk
> > @@ -48,18 +26,12 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
> >   * probe_kernel_read() suitable for use within regions where the caller
> >   * already holds mmap_sem, or other locks which nest inside mmap_sem.
> >   */
> > -long probe_kernel_read_strict(void *dst, const void *src, size_t size)
> > -{
> > -	return __probe_kernel_read(dst, src, size, true);
> > -}
> > -
> > -static long __probe_kernel_read(void *dst, const void *src, size_t size,
> > -		bool strict)
> > +long probe_kernel_read(void *dst, const void *src, size_t size)
> >  {
> >  	long ret;
> >  	mm_segment_t old_fs = get_fs();
> >  
> > -	if (!probe_kernel_read_allowed(dst, src, size, strict))
> > +	if (!probe_kernel_read_allowed(dst, src, size))
> >  		return -EFAULT;
> >  
> >  	set_fs(KERNEL_DS);
> > @@ -73,6 +45,7 @@ static long __probe_kernel_read(void *dst, const void *src, size_t size,
> >  		return -EFAULT;
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL_GPL(probe_kernel_read);
> >  
> >  /**
> >   * probe_user_read(): safely attempt to read from a user-space location
> > @@ -180,7 +153,7 @@ long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
> >  
> >  	if (unlikely(count <= 0))
> >  		return 0;
> > -	if (!probe_kernel_read_allowed(dst, unsafe_addr, count, true))
> > +	if (!probe_kernel_read_allowed(dst, unsafe_addr, count))
> >  		return -EFAULT;
> >  
> >  	set_fs(KERNEL_DS);
> > -- 
> > 2.26.2
> > 
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
