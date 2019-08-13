Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A565A8BFCD
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfHMRmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:42:24 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:29416 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbfHMRmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:42:24 -0400
Received: (qmail 31791 invoked by uid 89); 13 Aug 2019 17:42:23 -0000
Received: from unknown (HELO ?172.20.41.143?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzc=) (POLARISLOCAL)  
  by smtp8.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 13 Aug 2019 17:42:23 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Ivan Khoronzhuk" <ivan.khoronzhuk@linaro.org>
Cc:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] xdp: xdp_umem: replace kmap on vmap for umem
 map
Date:   Tue, 13 Aug 2019 10:42:18 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <9F98648A-8654-4767-97B5-CF4BC939393C@flugsvamp.com>
In-Reply-To: <20190813102318.5521-3-ivan.khoronzhuk@linaro.org>
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org>
 <20190813102318.5521-3-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Aug 2019, at 3:23, Ivan Khoronzhuk wrote:

> For 64-bit there is no reason to use vmap/vunmap, so use page_address
> as it was initially. For 32 bits, in some apps, like in samples
> xdpsock_user.c when number of pgs in use is quite big, the kmap
> memory can be not enough, despite on this, kmap looks like is
> deprecated in such cases as it can block and should be used rather
> for dynamic mm.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Seems a bit overkill - if not high memory, kmap() falls back
to just page_address(), unlike vmap().
-- 
Jonathan

> ---
>  net/xdp/xdp_umem.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index a0607969f8c0..907c9019fe21 100644
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
> @@ -167,10 +167,12 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
>
>  static void xdp_umem_unmap_pages(struct xdp_umem *umem)
>  {
> +#if BITS_PER_LONG == 32
>  	unsigned int i;
>
>  	for (i = 0; i < umem->npgs; i++)
> -		kunmap(umem->pgs[i]);
> +		vunmap(umem->pages[i].addr);
> +#endif
>  }
>
>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
> @@ -378,8 +380,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
> struct xdp_umem_reg *mr)
>  		goto out_account;
>  	}
>
> -	for (i = 0; i < umem->npgs; i++)
> -		umem->pages[i].addr = kmap(umem->pgs[i]);
> +	for (i = 0; i < umem->npgs; i++) {
> +#if BITS_PER_LONG == 32
> +		umem->pages[i].addr = vmap(&umem->pgs[i], 1, VM_MAP,
> +					   PAGE_KERNEL);
> +#else
> +		umem->pages[i].addr = page_address(umem->pgs[i]);
> +#endif
> +	}
>
>  	return 0;
>
> -- 
> 2.17.1
