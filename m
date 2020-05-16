Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE091D5E41
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 05:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgEPDnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 23:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgEPDnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 23:43:05 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 773F320728;
        Sat, 16 May 2020 03:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589600585;
        bh=9Yr3NqlaT8J3yD/oIp4iOMhtlWnif5o5ocW4LHaILdM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gyBQnTy1kkqh/qqbQgXTvgoLZUb4vpkCq+qjNMxNfH2LO1uD/nFf2CQ93t2pqZ2HH
         Nvv3z8XinGroioseW6l362KaQNKI1k7UrzuUhEywWLMpAOhwLDsF/32qhs84qDVP/z
         cpTKthgjLlt17JXXUVZs8KirdFerSU19m7odBjKc=
Date:   Sat, 16 May 2020 12:42:59 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] maccess: allow architectures to provide kernel
 probing directly
Message-Id: <20200516124259.5b68a4e1d4670efa1397a1e0@kernel.org>
In-Reply-To: <20200513160038.2482415-15-hch@lst.de>
References: <20200513160038.2482415-1-hch@lst.de>
        <20200513160038.2482415-15-hch@lst.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Wed, 13 May 2020 18:00:34 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Provide alternative versions of probe_kernel_read, probe_kernel_write
> and strncpy_from_kernel_unsafe that don't need set_fs magic, but instead
> use arch hooks that are modelled after unsafe_{get,put}_user to access
> kernel memory in an exception safe way.

This patch seems to introduce new implementation of probe_kernel_read/write()
and strncpy_from_kernel_unsafe(), but also drops copy_from/to_kernel_nofault()
and strncpy_from_kernel_nofault() if HAVE_ARCH_PROBE_KERNEL is defined.
In the result, this cause a link error with BPF and kprobe events.

BTW, what is the difference of *_unsafe() and *_nofault()?
(maybe we make those to *_nofault() finally?)

Thank you,

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/maccess.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/mm/maccess.c b/mm/maccess.c
> index 9773e2253b495..e9efe2f98e34a 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -12,6 +12,81 @@ bool __weak probe_kernel_read_allowed(void *dst, const void *unsafe_src,
>  	return true;
>  }
>  
> +#ifdef HAVE_ARCH_PROBE_KERNEL
> +
> +#define probe_kernel_read_loop(dst, src, len, type, err_label)		\
> +	while (len >= sizeof(type)) {					\
> +		arch_kernel_read(dst, src, type, err_label);		\
> +		dst += sizeof(type);					\
> +		src += sizeof(type);					\
> +		len -= sizeof(type);					\
> +	}
> +
> +long probe_kernel_read(void *dst, const void *src, size_t size)
> +{
> +	if (!probe_kernel_read_allowed(dst, src, size))
> +		return -EFAULT;
> +
> +	pagefault_disable();
> +	probe_kernel_read_loop(dst, src, size, u64, Efault);
> +	probe_kernel_read_loop(dst, src, size, u32, Efault);
> +	probe_kernel_read_loop(dst, src, size, u16, Efault);
> +	probe_kernel_read_loop(dst, src, size, u8, Efault);
> +	pagefault_enable();
> +	return 0;
> +Efault:
> +	pagefault_enable();
> +	return -EFAULT;
> +}
> +EXPORT_SYMBOL_GPL(probe_kernel_read);
> +
> +#define probe_kernel_write_loop(dst, src, len, type, err_label)		\
> +	while (len >= sizeof(type)) {					\
> +		arch_kernel_write(dst, src, type, err_label);		\
> +		dst += sizeof(type);					\
> +		src += sizeof(type);					\
> +		len -= sizeof(type);					\
> +	}
> +
> +long probe_kernel_write(void *dst, const void *src, size_t size)
> +{
> +	pagefault_disable();
> +	probe_kernel_write_loop(dst, src, size, u64, Efault);
> +	probe_kernel_write_loop(dst, src, size, u32, Efault);
> +	probe_kernel_write_loop(dst, src, size, u16, Efault);
> +	probe_kernel_write_loop(dst, src, size, u8, Efault);
> +	pagefault_enable();
> +	return 0;
> +Efault:
> +	pagefault_enable();
> +	return -EFAULT;
> +}
> +
> +long strncpy_from_kernel_unsafe(char *dst, const void *unsafe_addr, long count)
> +{
> +	const void *src = unsafe_addr;
> +
> +	if (unlikely(count <= 0))
> +		return 0;
> +	if (!probe_kernel_read_allowed(dst, unsafe_addr, count))
> +		return -EFAULT;
> +
> +	pagefault_disable();
> +	do {
> +		arch_kernel_read(dst, src, u8, Efault);
> +		dst++;
> +		src++;
> +	} while (dst[-1] && src - unsafe_addr < count);
> +	pagefault_enable();
> +
> +	dst[-1] = '\0';
> +	return src - unsafe_addr;
> +Efault:
> +	pagefault_enable();
> +	dst[-1] = '\0';
> +	return -EFAULT;
> +}
> +#else /* HAVE_ARCH_PROBE_KERNEL */
>  /**
>   * probe_kernel_read(): safely attempt to read from kernel-space
>   * @dst: pointer to the buffer that shall take the data
> @@ -114,6 +189,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
>  
>  	return ret ? -EFAULT : src - unsafe_addr;
>  }
> +#endif /* HAVE_ARCH_PROBE_KERNEL */
>  
>  /**
>   * probe_user_read(): safely attempt to read from a user-space location
> -- 
> 2.26.2
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
