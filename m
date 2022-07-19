Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F563579899
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 13:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbiGSLg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 07:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiGSLg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 07:36:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155571BE96;
        Tue, 19 Jul 2022 04:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C00D615BE;
        Tue, 19 Jul 2022 11:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6088EC341C6;
        Tue, 19 Jul 2022 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658230584;
        bh=xBrLo9QF5cL6M7jmKAJ0xi8a6rhrrtgs5eRGsYwW2I4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qn0BTCTp7SuHU4WK2ouM+S5EZYdF8zRi2m/7BktIeWDCGw5Uth9YGqUergj5Xw62d
         4ttTAj5W/WOoaPFTRMCmOsMem0nJJbXPSPNSoawO+C4soMjDiKfhmHJZ41Q2Lh8bDj
         X+oz+MkbWa9s94NG6LVQILJBUZLtEBzXtUP/to1c=
Date:   Tue, 19 Jul 2022 13:36:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com,
        Bernice.Chen@synaptics.com
Subject: Re: [PATCH v4 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
Message-ID: <YtaXNVTlkO4P7Nhv@kroah.com>
References: <YtVw+6SC7rtKDzaw@kroah.com>
 <20220719062452.25507-1-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220719062452.25507-1-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:24:51AM +0200, Łukasz Spintzyk wrote:
> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
> 
> This improves performance and stability of
> DL-3xxx/DL-5xxx/DL-6xxx device series.
> 
> Specifically prevents device from temporary network dropouts when
> playing video from the web and network traffic going through is high.
> 
> Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index d55f59ce4a31..af84ac0d65c9 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1904,6 +1904,19 @@ static const struct driver_info cdc_ncm_info = {
>  	.set_rx_mode = usbnet_cdc_update_filter,
>  };
>  
> +/* Same as cdc_ncm_info, but with FLAG_SEND_ZLP  */
> +static const struct driver_info cdc_ncm_zlp_info = {
> +	.description = "CDC NCM (SEND ZLP)",
> +	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
> +			| FLAG_LINK_INTR | FLAG_ETHER | FLAG_SEND_ZLP,
> +	.bind = cdc_ncm_bind,
> +	.unbind = cdc_ncm_unbind,
> +	.manage_power = usbnet_manage_power,
> +	.status = cdc_ncm_status,
> +	.rx_fixup = cdc_ncm_rx_fixup,
> +	.tx_fixup = cdc_ncm_tx_fixup,
> +};
> +
>  /* Same as cdc_ncm_info, but with FLAG_WWAN */
>  static const struct driver_info wwan_info = {
>  	.description = "Mobile Broadband Network Device",
> @@ -2010,6 +2023,16 @@ static const struct usb_device_id cdc_devs[] = {
>  	  .driver_info = (unsigned long)&wwan_info,
>  	},
>  
> +	/* DisplayLink docking stations */
> +	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
> +		| USB_DEVICE_ID_MATCH_VENDOR,
> +	  .idVendor = 0x17e9,
> +	  .bInterfaceClass = USB_CLASS_COMM,
> +	  .bInterfaceSubClass = USB_CDC_SUBCLASS_NCM,
> +	  .bInterfaceProtocol = USB_CDC_PROTO_NONE,
> +	  .driver_info = (unsigned long)&cdc_ncm_zlp_info,
> +	},
> +
>  	/* Generic CDC-NCM devices */
>  	{ USB_INTERFACE_INFO(USB_CLASS_COMM,
>  		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
> -- 
> 2.36.1
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
