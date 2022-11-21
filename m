Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE09632BCE
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiKUSNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKUSNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:13:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C766BC604E;
        Mon, 21 Nov 2022 10:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56CF4B80D34;
        Mon, 21 Nov 2022 18:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04FBC433D6;
        Mon, 21 Nov 2022 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669054430;
        bh=ZGb8HekwplHq8sWE2KIE4g+xtcd+XU+9iwrQzi0Zfhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uf4bYPv0IACt/u+/Qnm+G/wsfB/h2eNJf/2nroJ4RoeXxPB8+A0jRaAoxljRsNnQg
         6qLACc7NK4ygtA9LkgvTjdkKPhDL+W37pA2IHaKkw6ujw84QgKGAmCrS7OHJLFovdR
         wvYaqaMo7sOpkgbXnUJKIxDblbyxVp4MBtTVyQHI=
Date:   Mon, 21 Nov 2022 19:13:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Santiago Ruano =?iso-8859-1?Q?Rinc=F3n?= 
        <santiago.ruano-rincon@imt-atlantique.fr>
Cc:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/cdc_ncm: Fix multicast RX support for CDC NCM
 devices with ZLP
Message-ID: <Y3u/2gDlJFi9HB/x@kroah.com>
References: <Y3uXBr2U4pWGU3mW@kroah.com>
 <20221121154513.51957-1-santiago.ruano-rincon@imt-atlantique.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221121154513.51957-1-santiago.ruano-rincon@imt-atlantique.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 04:45:13PM +0100, Santiago Ruano Rincón wrote:
> ZLP for DisplayLink ethernet devices was enabled in 6.0:
> 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices").
> The related driver_info should be the "same as cdc_ncm_info, but with
> FLAG_SEND_ZLP". However, set_rx_mode that enables handling multicast
> traffic was missing in the new cdc_ncm_zlp_info.
> 
> usbnet_cdc_update_filter rx mode was introduced in linux 5.9 with:
> e10dcb1b6ba7 ("net: cdc_ncm: hook into set_rx_mode to admit multicast
> traffic")
> 
> Without this hook, multicast, and then IPv6 SLAAC, is broken.
> 
> Fixes: 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices")
> Signed-off-by: Santiago Ruano Rincón <santiago.ruano-rincon@imt-atlantique.fr>
> ---
>  drivers/net/usb/cdc_ncm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 8d5cbda33f66..0897fdb6254b 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1915,6 +1915,7 @@ static const struct driver_info cdc_ncm_zlp_info = {
>  	.status = cdc_ncm_status,
>  	.rx_fixup = cdc_ncm_rx_fixup,
>  	.tx_fixup = cdc_ncm_tx_fixup,
> +	.set_rx_mode = usbnet_cdc_update_filter,
>  };
>  
>  /* Same as cdc_ncm_info, but with FLAG_WWAN */
> -- 
> 2.38.1
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
