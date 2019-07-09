Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AE8636A1
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfGINSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:18:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43553 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfGINSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:18:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id i189so9284226pfg.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 06:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cs9d0soWGLh6/T7TN+B8LVVSavg4gzWMJtBbuEQeH+w=;
        b=K8l/Oc/L33Pmxjo4lv7cnkrH3eRj9v/LYaVOVYreaTjpjBOBjA7SgWv6eLLxlzVStu
         7iqUu1YTEafT4c6BtPqBicYy89qTipvKJ4dE1X69/O+3jhK0Rb/8qXQC27akZodCNgHo
         WL11oFKGA1P9oiX+1jdp+3KTkGuMjTZcsAnc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cs9d0soWGLh6/T7TN+B8LVVSavg4gzWMJtBbuEQeH+w=;
        b=oaVTFxFsK7G+z6RCIqPa/dDNYjJyh8AK5Aek+T/wiBElOy5xdwcDxcRiMNeuzsq7oC
         hRnI8X2dSh2HohDnMu9bq/coU7ZKgONA3kYGWfzLeD4C6VwN7mnE/9AZorLClhSrjqvF
         /4yzxyFBdspsxab1QdwkarRo54HkmlRkKEhhiilaAbXeLqZgP3/SipsN2dgguFll9PSd
         U2fWi71qvZSxZcTlNF7ZhR7qgZ3FKHVe1Gf2eEOXX5LSY1E9KLF0E1+cUL/qFjEejwSN
         n87lrSAGAKtUGY+J+ZXjDuVY5IEwviD912J9bkfYJPn2B0vqklDrFm5L8sLprNTql4hx
         Gu9A==
X-Gm-Message-State: APjAAAXUbPa/rXnkaJ/695+YZc097+w6vhVJPT7yjWsGiUXVIScp27Gs
        LWib3DxeMqCt2TUnWSFU4SIE0RWeh+w=
X-Google-Smtp-Source: APXvYqyFbvEsAS1oTe02jXAE+GA8JobJygX26C7vhzoa0ZIsM3ZlL35xuO0Tm8K/f9XoyiST+Aeh+w==
X-Received: by 2002:a63:455c:: with SMTP id u28mr31483938pgk.416.1562678328090;
        Tue, 09 Jul 2019 06:18:48 -0700 (PDT)
Received: from C02RW35GFVH8.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id k22sm23310682pfk.157.2019.07.09.06.18.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 06:18:47 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 9 Jul 2019 09:18:42 -0400
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next] bnxt_en: Add page_pool_destroy() during RX ring
 cleanup.
Message-ID: <20190709131842.GJ87269@C02RW35GFVH8.dhcp.broadcom.net>
References: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 03:50:07AM -0400, Michael Chan wrote:
> Add page_pool_destroy() in bnxt_free_rx_rings() during normal RX ring
> cleanup, as Ilias has informed us that the following commit has been
> merged:
> 
> 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
> 
> The special error handling code to call page_pool_free() can now be
> removed.  bnxt_free_rx_rings() will always be called during normal
> shutdown or any error paths.
> 
> Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Andy Gospodarek <gospo@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index e9d3bd8..2b5b0ab 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -2500,6 +2500,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
>  		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
>  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
>  
> +		page_pool_destroy(rxr->page_pool);
>  		rxr->page_pool = NULL;
>  
>  		kfree(rxr->rx_tpa);
> @@ -2560,19 +2561,14 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
>  			return rc;
>  
>  		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
> -		if (rc < 0) {
> -			page_pool_free(rxr->page_pool);
> -			rxr->page_pool = NULL;
> +		if (rc < 0)
>  			return rc;
> -		}
>  
>  		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
>  						MEM_TYPE_PAGE_POOL,
>  						rxr->page_pool);
>  		if (rc) {
>  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> -			page_pool_free(rxr->page_pool);
> -			rxr->page_pool = NULL;

Rather than deleting these lines it would also be acceptable to do:

                if (rc) {
                        xdp_rxq_info_unreg(&rxr->xdp_rxq);
-                       page_pool_free(rxr->page_pool);
+                       page_pool_destroy(rxr->page_pool);
                        rxr->page_pool = NULL;
                        return rc;
                }

but anytime there is a failure to bnxt_alloc_rx_rings the driver will
immediately follow it up with a call to bnxt_free_rx_rings, so
page_pool_destroy will be called.

Thanks for pushing this out so quickly!

Acked-by: Andy Gospodarek <gospo@broadcom.com> 

