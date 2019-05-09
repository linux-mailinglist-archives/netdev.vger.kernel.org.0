Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB6B18A74
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfEINSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:18:33 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41106 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfEINSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:18:32 -0400
Received: by mail-qt1-f194.google.com with SMTP id c13so2382327qtn.8
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 06:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uCSIDRtIChXyP2xLf4vlTl4TN+QeSJxgQq5xMSigZ5w=;
        b=M6vrSV4QLxR+V6U/r+ca2/B403jFheZI8ZaBlf+ACOn+Euslum3JF8mOw95C4/tDOk
         2X7a2cVjCw8p0uWq7Y+JqxUBC37Zjd/ZV4DE32I+UW9JIWgZZDkUhPWQF3hsrgx6PViK
         KpQUoF5YkVunDMmjLzQg1T0UDV+tkG1GT3x+PdpuLAP0t/qMWcsLcqWv0rjWEnbj8azA
         OhVatc7Ddd8nm/yBlY3ZfJ1rm30bGCnw6NN9vzGjfYqx1fhriVLkLIOuXCHKPRnwtdlS
         YDcMi6bPjydxg2tHNZ9LokihY2YxR2Zp7/Cb1hVGleGHAyyRupCB7kKm21Ls/ZZukjH/
         GF5w==
X-Gm-Message-State: APjAAAUwQcJjpk7h2cBrQUxgQFxmp2ZOQONGsJb4sPjs2PBb+3IiLnTb
        kiPj0nYv3HAnPYfArVBS4YIHXQ==
X-Google-Smtp-Source: APXvYqzuWDrp1vNxFhHyIepZh0BlL6Sk73vH5vDNAOlEraLrudzljNETMnRhgraKr8XDV4OMSkjv+w==
X-Received: by 2002:ac8:610f:: with SMTP id a15mr3462116qtm.257.1557407911523;
        Thu, 09 May 2019 06:18:31 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id x3sm1232202qtk.75.2019.05.09.06.18.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 09 May 2019 06:18:30 -0700 (PDT)
Date:   Thu, 9 May 2019 09:18:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
Subject: Re: [RFC PATCH V2] vhost: don't use kmap() to log dirty pages
Message-ID: <20190509090433-mutt-send-email-mst@kernel.org>
References: <1557406680-4087-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557406680-4087-1-git-send-email-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 08:58:00AM -0400, Jason Wang wrote:
> Vhost log dirty pages directly to a userspace bitmap through GUP and
> kmap_atomic() since kernel doesn't have a set_bit_to_user()
> helper. This will cause issues for the arch that has virtually tagged
> caches. The way to fix is to keep using userspace virtual
> address. Fortunately, futex has arch_futex_atomic_op_inuser() which
> could be used for setting a bit to user.
> 
> Note:
> - There're archs (few non popular ones) that don't implement futex
>   helper, we can't log dirty pages. We can fix them e.g for non
>   virtually tagged archs implement a kmap fallback on top or simply
>   disable LOG_ALL features of vhost.
> - The helper also requires userspace pointer is located at 4-byte
>   boundary, need to check during dirty log setting

Why check? Round it down.

> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Darren Hart <dvhart@infradead.org>
> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - switch to use arch_futex_atomic_op_inuser()
> ---
>  drivers/vhost/vhost.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 351af88..4e5a004 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -31,6 +31,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/interval_tree_generic.h>
>  #include <linux/nospec.h>
> +#include <asm/futex.h>
>  
>  #include "vhost.h"
>  
> @@ -1652,6 +1653,10 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
>  			r = -EFAULT;
>  			break;
>  		}
> +		if (p & 0x3) {
> +			r = -EINVAL;
> +			break;
> +		}
>  		for (i = 0; i < d->nvqs; ++i) {
>  			struct vhost_virtqueue *vq;
>  			void __user *base = (void __user *)(unsigned long)p;

That's an ABI change and might break some userspace. I don't think
it's necessary: you are changing individual bits anyway.

> @@ -1692,31 +1697,27 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
>  
> -/* TODO: This is really inefficient.  We need something like get_user()
> - * (instruction directly accesses the data, with an exception table entry
> - * returning -EFAULT). See Documentation/x86/exception-tables.txt.
> - */
> -static int set_bit_to_user(int nr, void __user *addr)
> +static int set_bit_to_user(int nr, u32 __user *addr)
>  {
>  	unsigned long log = (unsigned long)addr;
>  	struct page *page;
> -	void *base;
> -	int bit = nr + (log % PAGE_SIZE) * 8;
> +	u32 old;
>  	int r;
>  
>  	r = get_user_pages_fast(log, 1, 1, &page);

OK so the trick is that page is pinned so you don't expect
arch_futex_atomic_op_inuser below to fail.  get_user_pages_fast
guarantees page is not going away but does it guarantee PTE won't be
invaidated or write protected?

>  	if (r < 0)
>  		return r;
>  	BUG_ON(r != 1);
> -	base = kmap_atomic(page);
> -	set_bit(bit, base);
> -	kunmap_atomic(base);
> +
> +	r = arch_futex_atomic_op_inuser(FUTEX_OP_ADD, 1 << nr, &old, addr);
> +	/* TODO: fallback to kmap() when -ENOSYS? */
> +

Add a comment why this won't fail? Maybe warn on EFAULT?

Also down the road a variant that does not need tricks like this is
still nice to have.


>  	set_page_dirty_lock(page);
>  	put_page(page);
> -	return 0;
> +	return r;
>  }
>  
> -static int log_write(void __user *log_base,
> +static int log_write(u32 __user *log_base,
>  		     u64 write_address, u64 write_length)
>  {
>  	u64 write_page = write_address / VHOST_PAGE_SIZE;
> @@ -1726,12 +1727,10 @@ static int log_write(void __user *log_base,
>  		return 0;
>  	write_length += write_address % VHOST_PAGE_SIZE;
>  	for (;;) {
> -		u64 base = (u64)(unsigned long)log_base;
> -		u64 log = base + write_page / 8;
> -		int bit = write_page % 8;
> -		if ((u64)(unsigned long)log != log)
> -			return -EFAULT;
> -		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
> +		u32 __user *log = log_base + write_page / 32;
> +		int bit = write_page % 32;
> +
> +		r = set_bit_to_user(bit, log);
>  		if (r < 0)
>  			return r;
>  		if (write_length <= VHOST_PAGE_SIZE)
> -- 
> 1.8.3.1
