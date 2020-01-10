Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A7E13654C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgAJCTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:19:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34064 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730596AbgAJCTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:19:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so336698wrr.1
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 18:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/7Y6vHBhDcfuo0B3nVmmVJjH9+6KSaoEfTy2tqTJIhw=;
        b=J9jEGbemKJdizAvrnyJuTZjAl+1tG1DtF0mLqws24Pjj35b8hn4pw5HGi2f42HKaTx
         eQgOgloNWBb+fCaWYkZtg42Sywdttawe6gDnpOML6fJR1lo78D5s0+a18GvEgtDIefwG
         BIfhPD7KSfTsmBKVq9AHh64iD21/jNqB0Y9S4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/7Y6vHBhDcfuo0B3nVmmVJjH9+6KSaoEfTy2tqTJIhw=;
        b=KDqzL+r8jkXvF8wl3rEnLdImyON/SLCh4t15Enxq7qnVZ829pcYMYyKjoWUIglxtNI
         19fJF9LfbK4wTyMzFd+vNreTMYsB6JojpdEco2RTudiBZ/IIm4ukHOaiWvLZr2b6jCiU
         +zy1W1bAeYK+YfI4GjxeD8F2HCRyifYS+THCPup9SgGAxz0l0yXVpVMqOm1UPDP1xNbS
         gtKNp46+xDOCKPKIyiv41hAypkNIHke+XxSAXby/Ycpip9UgEorW3ivl6vKv1XX2HQ5y
         BLvj9WZHpiQNNz7fQAFjBmbQFAsbKMiwo6ICMFK24KJvR6VGeh9rqJoCXhdQaS/Aj9Q2
         RKdQ==
X-Gm-Message-State: APjAAAWgxipNCszQ6lgilF37TthXfnUAmqixhZXrrGVTK4A8f2GIRPcp
        omfpqWuAWrvf6oNFIN1hSj8Dlg==
X-Google-Smtp-Source: APXvYqwCV8wjU3XthzzuNAqBJL6IOBDVHOtjZ9fHDUft8R3okINxbsek4wf67NiGN9Nzz/2tusJeFA==
X-Received: by 2002:a5d:480b:: with SMTP id l11mr581751wrq.129.1578622785471;
        Thu, 09 Jan 2020 18:19:45 -0800 (PST)
Received: from C02YVCJELVCG ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id g7sm510260wrq.21.2020.01.09.18.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 18:19:44 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Thu, 9 Jan 2020 21:19:15 -0500
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next] bnxt: Detach page from page pool before sending
 up the stack
Message-ID: <20200110021915.GA13304@C02YVCJELVCG>
References: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 11:35:42AM -0800, Jonathan Lemon wrote:
> When running in XDP mode, pages come from the page pool, and should
> be freed back to the same pool or specifically detached.  Currently,
> when the driver re-initializes, the page pool destruction is delayed
> forever since it thinks there are oustanding pages.

If you can please share a reproduction script/steps that would be
helpful for me.

Since this is an XDP_PASS case I can easily create a program that does
that, so no need to share that program -- just the sequence to remove
the program, shutdown the driver, whatever is done and the error you
see.

Thanks!

> 
> Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 39d4309b17fb..33eb8cd6551e 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -944,6 +944,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
>  	dma_addr -= bp->rx_dma_offset;
>  	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
>  			     DMA_ATTR_WEAK_ORDERING);
> +	page_pool_release_page(rxr->page_pool, page);
>  
>  	if (unlikely(!payload))
>  		payload = eth_get_headlen(bp->dev, data_ptr, len);
> -- 
> 2.17.1
> 
