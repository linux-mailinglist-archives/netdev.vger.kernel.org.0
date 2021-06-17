Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DF93AB49D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhFQNZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhFQNZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 09:25:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 202D3613BA;
        Thu, 17 Jun 2021 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623936191;
        bh=J1OZ63WoZwmr/Ax4WnpUQzPNxGLbutVnezfNd0vafkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6hrbfjwmq/3vEpMQpyMOKAXVY2cLhRHXxnIkvLubsPUtkXPtq88YZgjy9cv3WEWS
         Swrtu6g8CUR4sFupACxDLwdJeHzBHn76+NDH5FVASgi6nok9PTDkbdII1dwTCaf6lA
         CBNkIcSB0N1w5SyDnWuRd4oDUPvQsvs0vIjA08pg=
Date:   Thu, 17 Jun 2021 15:23:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linyu Yuan <linyyuan@codeaurora.org>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: cdc_eem: fix tx fixup skb leak
Message-ID: <YMtMvYtUrgaM8m7d@kroah.com>
References: <20210616233232.4561-1-linyyuan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616233232.4561-1-linyyuan@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 07:32:32AM +0800, Linyu Yuan wrote:
> when usbnet transmit a skb, eem fixup it in eem_tx_fixup(),
> if skb_copy_expand() failed, it return NULL,
> usbnet_start_xmit() will have no chance to free original skb.
> 
> fix it by free orginal skb in eem_tx_fixup() first,
> then check skb clone status, if failed, return NULL to usbnet.
> 
> Fixes: 9f722c0978b0 ("usbnet: CDC EEM support (v5)")
> Signed-off-by: Linyu Yuan <linyyuan@codeaurora.org>
> ---
> 
> v2: add Fixes tag
> 
>  drivers/net/usb/cdc_eem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/cdc_eem.c b/drivers/net/usb/cdc_eem.c
> index 2e60bc1b9a6b..359ea0d10e59 100644
> --- a/drivers/net/usb/cdc_eem.c
> +++ b/drivers/net/usb/cdc_eem.c
> @@ -123,10 +123,10 @@ static struct sk_buff *eem_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
>  	}
>  
>  	skb2 = skb_copy_expand(skb, EEM_HEAD, ETH_FCS_LEN + padlen, flags);
> +	dev_kfree_skb_any(skb);
>  	if (!skb2)
>  		return NULL;
>  
> -	dev_kfree_skb_any(skb);
>  	skb = skb2;
>  
>  done:
> -- 
> 2.25.1
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
