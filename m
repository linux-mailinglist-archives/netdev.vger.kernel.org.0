Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6E53665D
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351209AbiE0RI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 13:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbiE0RI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 13:08:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1E613F937;
        Fri, 27 May 2022 10:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653671337; x=1685207337;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b3q39SUBMABRtjA5ofr43J/nm2AXC7Vx1cy/yv6Brqo=;
  b=UJrJp2gLfJNtqZsdcpdndTsaJBQKGBWQLmNM7bgDl9j/5L12vivzzx2R
   NiPfRdIP3PZadTsCeMOWlN88V8SqBS2qxzdgLIqdFQRzNK1LFKksiEDnp
   X/pSY6cwq5IYEdAYlYVIRv607o39qEROx4yC83rq3mUjrbjx4D2m+9ctH
   KJlHH9+BR8jMhhmtEUa7CTv9mAEfRmobbZOd1A08TaPYKN6JE+pm7C+od
   zG+SfGGYf2GqQ0rKztx6hBT+q6ykl8k+mGZ8D1cf2OC5s7hWrAoGcrvub
   3Doe/oqKx+um7BzYDr36Qb4BkdQcDS0Akk2J6JkefMmTBnCMjvau7xh5/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="254406396"
X-IronPort-AV: E=Sophos;i="5.91,256,1647327600"; 
   d="scan'208";a="254406396"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 10:08:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,256,1647327600"; 
   d="scan'208";a="665547883"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 27 May 2022 10:08:53 -0700
Date:   Fri, 27 May 2022 19:08:53 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     keliu <liuke94@huawei.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xdp: Directly use ida_alloc()/free()
Message-ID: <YpEFpVkxRRFi+Cs8@boxer>
References: <20220527064609.2358482-1-liuke94@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527064609.2358482-1-liuke94@huawei.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 06:46:09AM +0000, keliu wrote:
> Use ida_alloc()/ida_free() instead of deprecated
> ida_simple_get()/ida_simple_remove() .
> 
> Signed-off-by: keliu <liuke94@huawei.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

For future AF_XDP related patches please specify the bpf-next tree in the
patch subject (or bpf if it's a fix).

Thanks!

> ---
>  net/xdp/xdp_umem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index f01ef6bda390..869b9b9b9fad 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -57,7 +57,7 @@ static int xdp_umem_addr_map(struct xdp_umem *umem, struct page **pages,
>  static void xdp_umem_release(struct xdp_umem *umem)
>  {
>  	umem->zc = false;
> -	ida_simple_remove(&umem_ida, umem->id);
> +	ida_free(&umem_ida, umem->id);
>  
>  	xdp_umem_addr_unmap(umem);
>  	xdp_umem_unpin_pages(umem);
> @@ -242,7 +242,7 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
>  	if (!umem)
>  		return ERR_PTR(-ENOMEM);
>  
> -	err = ida_simple_get(&umem_ida, 0, 0, GFP_KERNEL);
> +	err = ida_alloc(&umem_ida, GFP_KERNEL);
>  	if (err < 0) {
>  		kfree(umem);
>  		return ERR_PTR(err);
> @@ -251,7 +251,7 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
>  
>  	err = xdp_umem_reg(umem, mr);
>  	if (err) {
> -		ida_simple_remove(&umem_ida, umem->id);
> +		ida_free(&umem_ida, umem->id);
>  		kfree(umem);
>  		return ERR_PTR(err);
>  	}
> -- 
> 2.25.1
> 
