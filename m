Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C3B47D079
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244376AbhLVLFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:05:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52842 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbhLVLFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:05:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB478B81054;
        Wed, 22 Dec 2021 11:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047BFC36AE5;
        Wed, 22 Dec 2021 11:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640171122;
        bh=oIEMPJqG6Sz4QaSjG0q59SBNmZpl8V/nkaSEyjzbxY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MPUykTABCnODbTPJ/xyPN7GoXK5qhA6vvBWOw52MZhS4lPSnSWPZ5Z9d43n6BuDZ5
         aFwYfjY3W4bnNOEfIDqrcYZ/QvewO8R29puVfD0YxZOEZuEQpoFj59NQ05I00Slb8D
         xKPmplG6Dxue9qIriVNJfTbPn5VJuZAQh2pd1V0E=
Date:   Wed, 22 Dec 2021 12:05:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] can: softing_cs: fix memleak on registration failure
Message-ID: <YcMGcBqkSaZzo7uq@kroah.com>
References: <20211222104843.6105-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222104843.6105-1-johan@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 11:48:43AM +0100, Johan Hovold wrote:
> In case device registration fails during probe, the driver state and the
> embedded platform device structure needs to be freed using
> platform_device_put() to properly free all resources (e.g. the device
> name).
> 
> Fixes: 0a0b7a5f7a04 ("can: add driver for Softing card")
> Cc: stable@vger.kernel.org      # 2.6.38
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/can/softing/softing_cs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/softing/softing_cs.c b/drivers/net/can/softing/softing_cs.c
> index 2e93ee792373..e5c939b63fa6 100644
> --- a/drivers/net/can/softing/softing_cs.c
> +++ b/drivers/net/can/softing/softing_cs.c
> @@ -293,7 +293,7 @@ static int softingcs_probe(struct pcmcia_device *pcmcia)
>  	return 0;
>  
>  platform_failed:
> -	kfree(dev);
> +	platform_device_put(pdev);
>  mem_failed:
>  pcmcia_bad:
>  pcmcia_failed:
> -- 
> 2.32.0
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
