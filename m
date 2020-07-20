Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8145F226AF8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389011AbgGTQhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730889AbgGTQhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 12:37:51 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9248320734;
        Mon, 20 Jul 2020 16:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595263070;
        bh=smDDaCk04kMr6EUzVkdVBl94CFmKvpleITLelmvA8+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JJC8sbphJDydEPEmQ9bsAOdVV0pki83XX29vWiTOyf6AsmPXVOTyRrnnrci7D6Bhd
         g+Lq7h/M7GIp2Q3yjvb33D7hXLYV7+QkF/cJUlgxrp5Jsp6dTPG3ALVp7AD8PFZTTR
         fVVidPSEdf7dnCSggZDPP0jvSNjJIbQpG4SHFy4k=
Date:   Mon, 20 Jul 2020 09:37:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 03/24] net: add a new sockptr_t type
Message-ID: <20200720163748.GA1292162@gmail.com>
References: <20200720124737.118617-1-hch@lst.de>
 <20200720124737.118617-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720124737.118617-4-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 02:47:16PM +0200, Christoph Hellwig wrote:
> Add a uptr_t type that can hold a pointer to either a user or kernel
> memory region, and simply helpers to copy to and from it.  For
> architectures like x86 that have non-overlapping user and kernel
> address space it just is a union and uses a TASK_SIZE check to
> select the proper copy routine.  For architectures with overlapping
> address spaces a flag to indicate the address space is used instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/sockptr.h | 121 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 121 insertions(+)
>  create mode 100644 include/linux/sockptr.h
> 
> diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
> new file mode 100644
> index 00000000000000..e41dfa52555dec
> --- /dev/null
> +++ b/include/linux/sockptr.h
> @@ -0,0 +1,121 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2020 Christoph Hellwig.
> + *
> + * Support for "universal" pointers that can point to either kernel or userspace
> + * memory.
> + */
> +#ifndef _LINUX_SOCKPTR_H
> +#define _LINUX_SOCKPTR_H
> +
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +typedef union {
> +	void		*kernel;
> +	void __user	*user;
> +} sockptr_t;
> +
> +static inline bool sockptr_is_kernel(sockptr_t sockptr)
> +{
> +	return (unsigned long)sockptr.kernel >= TASK_SIZE;
> +}
> +
> +static inline sockptr_t KERNEL_SOCKPTR(void *p)
> +{
> +	return (sockptr_t) { .kernel = p };
> +}
> +#else /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
> +typedef struct {
> +	union {
> +		void		*kernel;
> +		void __user	*user;
> +	};
> +	bool		is_kernel : 1;
> +} sockptr_t;
> +
> +static inline bool sockptr_is_kernel(sockptr_t sockptr)
> +{
> +	return sockptr.is_kernel;
> +}
> +
> +static inline sockptr_t KERNEL_SOCKPTR(void *p)
> +{
> +	return (sockptr_t) { .kernel = p, .is_kernel = true };
> +}
> +#endif /* CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE */
> +
> +static inline sockptr_t USER_SOCKPTR(void __user *p)
> +{
> +	return (sockptr_t) { .user = p };
> +}
> +
> +static inline bool sockptr_is_null(sockptr_t sockptr)
> +{
> +	return !sockptr.user && !sockptr.kernel;
> +}
> +
> +static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
> +{
> +	if (!sockptr_is_kernel(src))
> +		return copy_from_user(dst, src.user, size);
> +	memcpy(dst, src.kernel, size);
> +	return 0;
> +}

How does this not introduce a massive security hole when
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE?

AFAICS, userspace can pass in a pointer >= TASK_SIZE,
and this code makes it be treated as a kernel pointer.

- Eric
