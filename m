Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FE2D6BA2
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391449AbgLJXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 18:11:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:60676 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391369AbgLJXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 18:11:48 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knV5U-0002DG-Ep; Fri, 11 Dec 2020 00:11:04 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knV5U-0004o4-98; Fri, 11 Dec 2020 00:11:04 +0100
Subject: Re: [PATCH v3 1/1] xdp: avoid calling kfree twice
To:     Zhu Yanjun <yanjun.zhu@intel.com>, zyjzyj2000@gmail.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     Ye Dong <dong.ye@intel.com>
References: <20201211042610.71081-1-yanjun.zhu@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b3cd5ccb-e1cc-f091-8330-dba6c58b2fc3@iogearbox.net>
Date:   Fri, 11 Dec 2020 00:11:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201211042610.71081-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/20 5:26 AM, Zhu Yanjun wrote:
> In the function xdp_umem_pin_pages, if npgs != umem->npgs and
> npgs >= 0, the function xdp_umem_unpin_pages is called. In this
> function, kfree is called to handle umem->pgs, and then in the
> function xdp_umem_pin_pages, kfree is called again to handle
> umem->pgs. Eventually, to umem->pgs, kfree is called twice.
> 
> Since umem->pgs is set to NULL after the first kfree, the second
> kfree would not trigger call trace.

This can still be misinterpreted imho; maybe lets simplify, for example:

   [bpf-next] xdp: avoid unnecessary second call to kfree

   For the case when in xdp_umem_pin_pages() the call to pin_user_pages()
   wasn't able to pin all the requested number of pages in memory (but some)
   then we error out by cleaning up the ones that got pinned through a call
   to xdp_umem_unpin_pages() and later on we free kfree(umem->pgs) itself.

   This is unneeded since xdp_umem_unpin_pages() itself already does the
   kfree(umem->pgs) internally with subsequent setting umem->pgs to NULL, so
   that in xdp_umem_pin_pages() the second kfree(umem->pgs) becomes entirely
   unnecessary for this case. Therefore, clean the error handling up.

> Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")

Why do we need a Fixes tag here? It's a _cleanup_, not a bug/fix technically.

> CC: Ye Dong <dong.ye@intel.com>
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>
> ---
>   net/xdp/xdp_umem.c | 17 +++++------------
>   1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 56a28a686988..01b31c56cead 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -97,7 +97,6 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>   {
>   	unsigned int gup_flags = FOLL_WRITE;
>   	long npgs;
> -	int err;
>   
>   	umem->pgs = kcalloc(umem->npgs, sizeof(*umem->pgs),
>   			    GFP_KERNEL | __GFP_NOWARN);
> @@ -112,20 +111,14 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>   	if (npgs != umem->npgs) {
>   		if (npgs >= 0) {
>   			umem->npgs = npgs;
> -			err = -ENOMEM;
> -			goto out_pin;
> +			xdp_umem_unpin_pages(umem);
> +			return -ENOMEM;
>   		}
> -		err = npgs;
> -		goto out_pgs;
> +		kfree(umem->pgs);
> +		umem->pgs = NULL;
> +		return (int)npgs;
>   	}
>   	return 0;
> -
> -out_pin:
> -	xdp_umem_unpin_pages(umem);
> -out_pgs:
> -	kfree(umem->pgs);
> -	umem->pgs = NULL;
> -	return err;
>   }
>   
>   static int xdp_umem_account_pages(struct xdp_umem *umem)
> 

While at it, maybe we could also simplify the if (npgs != umem->npgs) a bit to
get rid of the indent, something like:

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 56a28a686988..fa4dd16cced5 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -97,7 +97,6 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
  {
  	unsigned int gup_flags = FOLL_WRITE;
  	long npgs;
-	int err;

  	umem->pgs = kcalloc(umem->npgs, sizeof(*umem->pgs),
  			    GFP_KERNEL | __GFP_NOWARN);
@@ -108,24 +107,17 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
  	npgs = pin_user_pages(address, umem->npgs,
  			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
  	mmap_read_unlock(current->mm);
-
-	if (npgs != umem->npgs) {
-		if (npgs >= 0) {
-			umem->npgs = npgs;
-			err = -ENOMEM;
-			goto out_pin;
-		}
-		err = npgs;
-		goto out_pgs;
+	if (npgs == umem->npgs)
+		return 0;
+	if (npgs >= 0) {
+		umem->npgs = npgs;
+		xdp_umem_unpin_pages(umem);
+		return -ENOMEM;
  	}
-	return 0;

-out_pin:
-	xdp_umem_unpin_pages(umem);
-out_pgs:
  	kfree(umem->pgs);
  	umem->pgs = NULL;
-	return err;
+	return npgs;
  }

  static int xdp_umem_account_pages(struct xdp_umem *umem)
