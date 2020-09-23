Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D4F27561B
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIWKWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgIWKWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 06:22:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CFC21BE5;
        Wed, 23 Sep 2020 10:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600856557;
        bh=XWz+vZF1g9LHOoSDkcsY0DgfgY9ECKBeXlo0tAjLp3E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2i1jUvoLRFBz01yCEMI3AOBl7f7kw3YeK1wDQAayGCIXdpUkkkYqac305/pA+Xk2t
         rz8XlHaWtW2W13ht3sKCDS3XCKPPmcTSwwMVrPaFlfp9A5sW4wbcJ1BozSbPzVhOsl
         2czFjN+d/NXfHtVMK4ZP3O4jv8B36hSznoXXwG7Q=
Date:   Wed, 23 Sep 2020 12:22:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH 4/4] net: rndis_host: use usb_control_msg_recv() and
 usb_control_msg_send()
Message-ID: <20200923102256.GA3154647@kroah.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-5-himadrispandya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923090519.361-5-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:35:19PM +0530, Himadri Pandya wrote:
> The new usb_control_msg_recv() and usb_control_msg_send() nicely wraps
> usb_control_msg() with proper error check. Hence use the wrappers
> instead of calling usb_control_msg() directly.
> 
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> ---
>  drivers/net/usb/rndis_host.c | 44 ++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 6fa7a009a24a..30fc4a7183d3 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -113,14 +113,13 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
>  		buf->request_id = (__force __le32) xid;
>  	}
>  	master_ifnum = info->control->cur_altsetting->desc.bInterfaceNumber;
> -	retval = usb_control_msg(dev->udev,
> -		usb_sndctrlpipe(dev->udev, 0),
> -		USB_CDC_SEND_ENCAPSULATED_COMMAND,
> -		USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> -		0, master_ifnum,
> -		buf, le32_to_cpu(buf->msg_len),
> -		RNDIS_CONTROL_TIMEOUT_MS);
> -	if (unlikely(retval < 0 || xid == 0))
> +	retval = usb_control_msg_send(dev->udev, 0,
> +				      USB_CDC_SEND_ENCAPSULATED_COMMAND,
> +				      USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +				      0, master_ifnum, buf,
> +				      le32_to_cpu(buf->msg_len),
> +				      RNDIS_CONTROL_TIMEOUT_MS);
> +	if (unlikely(xid == 0))
>  		return retval;
>  
>  	/* Some devices don't respond on the control channel until
> @@ -139,14 +138,11 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
>  	/* Poll the control channel; the request probably completed immediately */
>  	rsp = le32_to_cpu(buf->msg_type) | RNDIS_MSG_COMPLETION;
>  	for (count = 0; count < 10; count++) {
> -		memset(buf, 0, CONTROL_BUFFER_SIZE);
> -		retval = usb_control_msg(dev->udev,
> -			usb_rcvctrlpipe(dev->udev, 0),
> -			USB_CDC_GET_ENCAPSULATED_RESPONSE,
> -			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> -			0, master_ifnum,
> -			buf, buflen,
> -			RNDIS_CONTROL_TIMEOUT_MS);
> +		retval = usb_control_msg_recv(dev->udev, 0,
> +					      USB_CDC_GET_ENCAPSULATED_RESPONSE,
> +					      USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +					      0, master_ifnum, buf, buflen,
> +					      RNDIS_CONTROL_TIMEOUT_MS);
>  		if (likely(retval >= 8)) {

retval here is never going to be positive, right?  So I don't think this
patch is correct :(

>  			msg_type = le32_to_cpu(buf->msg_type);
>  			msg_len = le32_to_cpu(buf->msg_len);
> @@ -178,17 +174,11 @@ int rndis_command(struct usbnet *dev, struct rndis_msg_hdr *buf, int buflen)
>  				msg->msg_type = cpu_to_le32(RNDIS_MSG_KEEPALIVE_C);
>  				msg->msg_len = cpu_to_le32(sizeof *msg);
>  				msg->status = cpu_to_le32(RNDIS_STATUS_SUCCESS);
> -				retval = usb_control_msg(dev->udev,
> -					usb_sndctrlpipe(dev->udev, 0),
> -					USB_CDC_SEND_ENCAPSULATED_COMMAND,
> -					USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> -					0, master_ifnum,
> -					msg, sizeof *msg,
> -					RNDIS_CONTROL_TIMEOUT_MS);
> -				if (unlikely(retval < 0))
> -					dev_dbg(&info->control->dev,
> -						"rndis keepalive err %d\n",
> -						retval);
> +				retval = usb_control_msg_send(dev->udev, 0,
> +							      USB_CDC_SEND_ENCAPSULATED_COMMAND,
> +							      USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +							      0, master_ifnum, msg, sizeof(*msg),
> +							      RNDIS_CONTROL_TIMEOUT_MS);

You lost the error message that the previous call had if something went
wrong.  Don't know if it's really needed, but there's no reason to
remove it here.

thanks,

greg k-h
