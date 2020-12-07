Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712B72D1108
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLGMwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:52:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:19702 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgLGMwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 07:52:23 -0500
IronPort-SDR: QjMC47uG992J8/wVjty35SIJMUG5cEypDE1kv48AEewhRz+Pm+0virmtf2FNslfLRvIOR9Jg0W
 4dLU2ZAfGqqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9827"; a="237796407"
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="237796407"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 04:51:42 -0800
IronPort-SDR: 5p5nrHMpTloC8laThRTPvHcKamqfGrcL4HZrLstYKKwVhLhYGFW7GS1g8lXqdVT9JtZYHBG+Uc
 t10xFiwdCPTA==
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="363129111"
Received: from djrogers-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.45.105])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 04:51:40 -0800
Subject: Re: [PATCH 1/1] xdp: avoid calling kfree twice
To:     Zhu Yanjun <yanjun.zhu@intel.com>, zyjzyj2000@gmail.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
References: <20201208065036.9458-1-yanjun.zhu@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0fef898d-cf5e-ef1b-6c35-c98669e9e0ed@intel.com>
Date:   Mon, 7 Dec 2020 13:51:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201208065036.9458-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-08 07:50, Zhu Yanjun wrote:
> From: Zhu Yanjun <zyjzyj2000@gmail.com>
> 
> In the function xdp_umem_pin_pages, if npgs != umem->npgs and
> npgs >= 0, the function xdp_umem_unpin_pages is called. In this
> function, kfree is called to handle umem->pgs, and then in the
> function xdp_umem_pin_pages, kfree is called again to handle
> umem->pgs. Eventually, umem->pgs is freed twice.
>

Hi Zhu,

Thanks for the cleanup! kfree(NULL) is valid, so this is not a 
double-free, but still a nice cleanup!


> Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
> ---
>   net/xdp/xdp_umem.c | 17 +++++------------
>   1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 56a28a686988..ff5173f72920 100644
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
> +		return npgs;

I'd like an explicit cast "(int)" here (-Wconversion). Please spin a v2
with the cast, with my:

Acked-by: Björn Töpel <bjorn.topel@intel.com>

added.


Cheers!
Björn


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
