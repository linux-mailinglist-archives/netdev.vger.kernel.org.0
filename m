Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D522B2960DD
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507758AbgJVOYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:24:39 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:47417 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408628AbgJVOYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 10:24:38 -0400
Received: from mailone.linux-pingi.de ([109.41.193.78]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1N94FT-1kJiwH2pPj-01688x; Thu, 22 Oct 2020 16:24:02 +0200
Received: from pingi.linux-pingi.de (pingi.linux-pingi.de [10.23.200.1])
        by mailone.linux-pingi.de (Postfix) with ESMTPSA id 067CA72005;
        Thu, 22 Oct 2020 16:24:29 +0200 (CEST)
Subject: Re: [PATCH net] mISDN: hfcpci: Fix a use after free in hfcmulti_tx()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201022070739.GB2817762@mwanda>
From:   isdn@linux-pingi.de
Message-ID: <0ee243a9-9937-ad26-0684-44b18e772662@linux-pingi.de>
Date:   Thu, 22 Oct 2020 16:24:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201022070739.GB2817762@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:xYbNn1CfvF3/xLcSVcJ6ey7yuz6el4wRESkm7ImZj2JIuZhhOHX
 21rP9r0/jl3RHN4bqEx5bKlSidCwEFZ/6YhkZPGaPyb/6GynWRK2vax69WQHYt3c9mGp/wP
 PbgH/deny034/rK1z/z0Z5cawddE47Ygi7AoBkdNRQhq84VQtMU5yWKUMF41HOQZkgtKjsT
 s8pAnw1XZJS86T9ir0PUQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BPrxIjR+nDM=:ipkeTT+X8jxv+L32QNS+x8
 MAHjmxHm1PY+is7oUdcvDhieTWlPIJZ9Da5PPQXM7tcv7X8SvMxSOUXGlr0J8h4l9E1lYhoXU
 bOx0NH9No3BEDzbidmcTtILL/J36+BxSd6V9yPZG6V97tbgQLoOSOBmsoAAAEA+2D6lxP57Od
 S9ZYb6zu9xKEZGRzOwoVX/igsOK0L53rXRDJcr3Q+r/cZMfjkWAkgFJVP52z/5xFfs8cy4+ll
 YLmVlMOSYN1HKiaCUWYlClby/szWq0QujDmAkV7d2aU0i/GvtzLm+USXxrkNlxJNuRFhS4CeV
 +eZKNV7BXPWszIptXAg5lIeTTpvXhADzyjiQ5xrnDumf4j6NtAlqk311o3ZXng5CzDkj77Qln
 LG41MvzUfxy9SPkM7R+tM3pLAI0j0/UL4jLv+JoJFRhoCuAraeZBAtKi2U85ku7wA+hwp9qLc
 qlPlEchp4Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

that looks wrong to me and never was a use after free.

sp is set either to the address containing the pointer to the actual
D-channel SKB or to the actual B-channel SKB. This address is not freed
and will not change in this context. The dev_kfree(*sp) will delete the
old SKB and the call to  get_next_[bd]frame(), if returning true, will
place a new SKB into this address, so (*sp) point to this new SKB.
The len of course need to be the length of the new SKB, not the old one,
which would be the result of this patch.

Best regards
Karsten

On 10/22/20 9:07 AM, Dan Carpenter wrote:
> This frees "*sp" before dereferencing it to get "len = (*sp)->len;".
> 
> Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/isdn/hardware/mISDN/hfcmulti.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
> index 7013a3f08429..ce6c160e0df4 100644
> --- a/drivers/isdn/hardware/mISDN/hfcmulti.c
> +++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
> @@ -2152,16 +2152,14 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
>  		HFC_wait_nodebug(hc);
>  	}
>  
> +	len = (*sp)->len;
>  	dev_kfree_skb(*sp);
>  	/* check for next frame */
> -	if (bch && get_next_bframe(bch)) {
> -		len = (*sp)->len;
> +	if (bch && get_next_bframe(bch))
>  		goto next_frame;
> -	}
> -	if (dch && get_next_dframe(dch)) {
> -		len = (*sp)->len;
> +
> +	if (dch && get_next_dframe(dch))
>  		goto next_frame;
> -	}
>  
>  	/*
>  	 * now we have no more data, so in case of transparent,
> 

