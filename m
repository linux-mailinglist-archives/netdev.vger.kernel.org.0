Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E815D16FDE
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 06:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEHEMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 00:12:54 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35172 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfEHEMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 00:12:53 -0400
Received: by mail-qt1-f195.google.com with SMTP id d20so4156819qto.2
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 21:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xwhy2yN3rc/R/GaGy+1UFq4MiREMOPekIWW9QNkmDr0=;
        b=tgAoBP8m6j3FR8dpXKrUiA/YFYg5cwIix6PJoO9oYjn3+FEZ3N3XNAgn8ZY+ubD77+
         zAOa8af+2QOxQ3FfTcw0JdVQDGs0FpjixyJVGWRuJeigb1YKjhV0wpYN0JosnwOL0JI+
         9V8j03SwqIwNio3TuGFD5Gp7VvqwQmibDmYsqovEDquEyFF9ANirHnB1iKi3VA/AzwdV
         vD6k9Z1TZrjZDGC84nsj38BSlDLErRsjI1ep+7nKNwLs7wSV8gnBl/sWnCmvF7Ln+Bmr
         g+afcDRbQrOL+HsSPgrAOQj9JXBSFb+340B2vhtgL7NaPCVSsv7UA338jb+e0dkDlRIJ
         ql2w==
X-Gm-Message-State: APjAAAVdEoqv8PhvIh6G9OshCUh/YCgyUMfM43qpjRPka3a7MrJk2/Dd
        OeD0RL3ViNrgbTWEmezSSRuCMw==
X-Google-Smtp-Source: APXvYqx0Vjhjwje7JRCwbHR2bgsffeWuD7uDRdzXBHVgbWnmt5fE0ab1QpEFLunM5VrcyQy1j/ZmKg==
X-Received: by 2002:ac8:65cf:: with SMTP id t15mr16582014qto.12.1557288772916;
        Tue, 07 May 2019 21:12:52 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id j25sm9725830qtc.24.2019.05.07.21.12.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 21:12:51 -0700 (PDT)
Date:   Wed, 8 May 2019 00:12:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH RFC] vhost: don't use kmap() to log dirty pages
Message-ID: <20190507220526-mutt-send-email-mst@kernel.org>
References: <1557195809-12373-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557195809-12373-1-git-send-email-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 10:23:29PM -0400, Jason Wang wrote:
> Vhost log dirty pages directly to a userspace bitmap through GUP and
> kmap_atomic() since kernel doesn't have a set_bit_to_user()
> helper. This will cause issues for the arch that has virtually tagged
> caches. The way to fix is to keep using userspace virtual address.
> 
> Fortunately, futex has a cmpxchg to userspace memory helper
> futex_atomic_cmpxchg_inatomic(). So switch to use it to exchange the
> userspace bitmap with zero, set the bit and then write it back through
> put_user().
> 
> Note: there're archs (few non popular ones) that don't implement
> futex helper, we can't log dirty pages. We can fix them on top or
> simply disable LOG_ALL features of vhost.

Or implement futex_atomic_cmpxchg using kmap if they don't have
virtually tagged caches.

> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 351af88..9c94c41 100644
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
> @@ -1692,25 +1693,27 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
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
> +	u32 old_log;
>  	int r;
>  
>  	r = get_user_pages_fast(log, 1, 1, &page);
>  	if (r < 0)
>  		return r;
>  	BUG_ON(r != 1);
> -	base = kmap_atomic(page);
> -	set_bit(bit, base);
> -	kunmap_atomic(base);
> +
> +	r = futex_atomic_cmpxchg_inatomic(&old_log, addr, 0, 0);
> +	if (r < 0)
> +		return r;

So I think this is a great idea!

However one issue here is that futex_atomic_cmpxchg_inatomic will fail if the
page is swapped out. I suspect we need a variant that blocks the thread
instead.

> +
> +	old_log |= 1 << nr;
> +	r = put_user(old_log, addr);
> +	if (r < 0)
> +		return r;
> +
>  	set_page_dirty_lock(page);
>  	put_page(page);
>  	return 0;
> @@ -1727,8 +1730,8 @@ static int log_write(void __user *log_base,
>  	write_length += write_address % VHOST_PAGE_SIZE;
>  	for (;;) {
>  		u64 base = (u64)(unsigned long)log_base;
> -		u64 log = base + write_page / 8;
> -		int bit = write_page % 8;
> +		u64 log = base + write_page / 32;
> +		int bit = write_page % 32;
>  		if ((u64)(unsigned long)log != log)
>  			return -EFAULT;
>  		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
> -- 
> 1.8.3.1
