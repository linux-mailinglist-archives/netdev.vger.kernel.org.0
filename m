Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070D68F334
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732860AbfHOSXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:23:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42423 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729565AbfHOSXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:23:19 -0400
Received: by mail-pf1-f195.google.com with SMTP id i30so1719828pfk.9;
        Thu, 15 Aug 2019 11:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=l7ROvwBmxyo8/D3YRRi0Igp8QJbgJTkQ4GmMpySCWJw=;
        b=hpm1cOi18/fG/NCX5oXTspgxisZB91yz5SIdJ02JxUbw/62uEAeqLtdoNBJRGFRYor
         ku4lr4oiVTFODDWfudvhhBIsqWBYHYhtAYHiIbHlaozuOtyg8o37i7DC3tbD9CqxD/L3
         EiuCHQFVoeGVDJM7/BE+PACPExAbF8lHmZSJwKPR0gfBMNEuiUSJbFUa2oeQxzgSQ7eP
         m1R2fLOQgmv8QSFPhFGQSroZ7hJSVKP7ZlzcGJ2yjezmqxkXcuIEymlzQOS8tWg5ydKj
         yO6j+6roOJEInH2iZSpMzcpS/5RbOah+Czx0HKl1aveFzlklWDiIqZWIAgIkIXVzxbQ8
         4LCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=l7ROvwBmxyo8/D3YRRi0Igp8QJbgJTkQ4GmMpySCWJw=;
        b=GCA3ZlxFfZDSv4qwTZAmLH2KtB0Wjv8xcQgZ/UtNbAD4uDEV11do9ZaOt2yNABbJZh
         KM+OWkqtHp0OzglYhspJiS83v4jJSypgnCV4A1tZXiHnUBSsOlmdCpQz+Aa32Law7X5J
         u9NwwGejZS+xEEFdPPuqwDUWPmKZAAD5PqqXT+HfP59c0SOAT7XiZ/XPz0MmtYriGLgk
         zA6JvkppDV83wJZf4LVjddjN2+CeKiO1BfAPbjpdrEVrTjKwduNr5E1OA29jXMkPq+Lw
         Qeik3Nk9b46Ml57KFoFZQROYn3B5yKC5MaynrD2LhPZz6nwu4lt3F8fRqHdrNt74hTMM
         ctuw==
X-Gm-Message-State: APjAAAU8QwL/cINb/PvAB/+CG5+nyiL0J4uBfgHYsasFTBySgxydI5GE
        GV+tTFoXsqBQOqwKKTm0E+M=
X-Google-Smtp-Source: APXvYqwgna4XblK6OdGHyhlLPS69ayd9Afhl6vvTAwfLAjyGRADSZs4VsLbGeinUJvzxhf9FCCdshw==
X-Received: by 2002:a63:5550:: with SMTP id f16mr4717026pgm.426.1565893398599;
        Thu, 15 Aug 2019 11:23:18 -0700 (PDT)
Received: from [172.20.53.208] ([2620:10d:c090:200::3:fd5d])
        by smtp.gmail.com with ESMTPSA id ay7sm1948348pjb.4.2019.08.15.11.23.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 11:23:17 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        yhs@fb.com, andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for
 umem map
Date:   Thu, 15 Aug 2019 11:23:16 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <5B58D364-609F-498E-B7DF-4457D454A14D@gmail.com>
In-Reply-To: <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
 <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Aug 2019, at 5:13, Ivan Khoronzhuk wrote:

> For 64-bit there is no reason to use vmap/vunmap, so use page_address
> as it was initially. For 32 bits, in some apps, like in samples
> xdpsock_user.c when number of pgs in use is quite big, the kmap
> memory can be not enough, despite on this, kmap looks like is
> deprecated in such cases as it can block and should be used rather
> for dynamic mm.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  net/xdp/xdp_umem.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index a0607969f8c0..d740c4f8810c 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -14,7 +14,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/idr.h>
> -#include <linux/highmem.h>
> +#include <linux/vmalloc.h>
>
>  #include "xdp_umem.h"
>  #include "xsk_queue.h"
> @@ -170,7 +170,30 @@ static void xdp_umem_unmap_pages(struct xdp_umem 
> *umem)
>  	unsigned int i;
>
>  	for (i = 0; i < umem->npgs; i++)
> -		kunmap(umem->pgs[i]);
> +		if (PageHighMem(umem->pgs[i]))
> +			vunmap(umem->pages[i].addr);
> +}
> +
> +static int xdp_umem_map_pages(struct xdp_umem *umem)
> +{
> +	unsigned int i;
> +	void *addr;
> +
> +	for (i = 0; i < umem->npgs; i++) {
> +		if (PageHighMem(umem->pgs[i]))
> +			addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
> +		else
> +			addr = page_address(umem->pgs[i]);
> +
> +		if (!addr) {
> +			xdp_umem_unmap_pages(umem);
> +			return -ENOMEM;
> +		}
> +
> +		umem->pages[i].addr = addr;
> +	}
> +
> +	return 0;
>  }

You'll want a __xdp_umem_unmap_pages() helper here that takes an
count of the number of pages to unmap, so it can be called from
xdp_umem_unmap_pages() in the normal case, and xdp_umem_map_pages()
in the error case.  Otherwise the error case ends up calling
PageHighMem on a null page.
-- 
Jonathan

>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
> @@ -312,7 +335,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
> struct xdp_umem_reg *mr)
>  	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
>  	unsigned int chunks, chunks_per_page;
>  	u64 addr = mr->addr, size = mr->len;
> -	int size_chk, err, i;
> +	int size_chk, err;
>
>  	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) 
> {
>  		/* Strictly speaking we could support this, if:
> @@ -378,10 +401,11 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
> struct xdp_umem_reg *mr)
>  		goto out_account;
>  	}
>
> -	for (i = 0; i < umem->npgs; i++)
> -		umem->pages[i].addr = kmap(umem->pgs[i]);
> +	err = xdp_umem_map_pages(umem);
> +	if (!err)
> +		return 0;
>
> -	return 0;
> +	kfree(umem->pages);
>
>  out_account:
>  	xdp_umem_unaccount_pages(umem);
> -- 
> 2.17.1
