Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24D696C28
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfHTW0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTW0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 18:26:09 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AE5222DA7;
        Tue, 20 Aug 2019 22:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566339968;
        bh=NeDjxyqAFNWxNPg4sXdwlX8ljdi6fC+V0/ljpy8i1sU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DfMxh3yl4quSp3++D9aXdp31fH/0Y5HqDGtU/X6iQ5rl4Myp/6mBTnukwu83jEnJs
         TRVWg8pLxgyBIeem+RoESsiek9Ug++W7N3xQcimXWFSL0tUm/y7PrE5STFdnjrTf+A
         oeyVGarWAqdly+d2UwnBjzv9lcOge8vwG1j5r9gA=
Date:   Tue, 20 Aug 2019 15:26:02 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Charles.Hyde@dellteam.com
Cc:     linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        Mario.Limonciello@dell.com, oliver@neukum.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
Message-ID: <20190820222602.GC8120@kroah.com>
References: <1566339522507.45056@Dellteam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566339522507.45056@Dellteam.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 10:18:42PM +0000, Charles.Hyde@dellteam.com wrote:
> The core USB driver message.c is missing get/set address functionality
> that stops ifconfig from being able to push MAC addresses out to USB
> based ethernet devices.  Without this functionality, some USB devices
> stop responding to ethernet packets when using ifconfig to change MAC
> addresses.  This has been tested with a Dell Universal Dock D6000.
> 
> Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>
> Cc: Mario Limonciello <mario.limonciello@dell.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/core/message.c | 59 ++++++++++++++++++++++++++++++++++++++
>  include/linux/usb.h        |  3 ++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
> index 5adf489428aa..eea775234b09 100644
> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c
> @@ -1085,6 +1085,65 @@ int usb_clear_halt(struct usb_device *dev, int pipe)
>  }
>  EXPORT_SYMBOL_GPL(usb_clear_halt);
>  
> +/**
> + * usb_get_address - 

trailing whitespace?

No description of what the function does?

> + * @dev: device whose endpoint is halted
> + * @mac: buffer for containing 

Trailing whitespace?

> + * Context: !in_interrupt ()
> + *
> + * This will attempt to get the six byte MAC address from a USB device's
> + * ethernet controller using GET_NET_ADDRESS command.
> + *
> + * This call is synchronous, and may not be used in an interrupt context.
> + *
> + * Return: Zero on success, or else the status code returned by the
> + * underlying usb_control_msg() call.
> + */
> +int usb_get_address(struct usb_device *dev, unsigned char * mac)
> +{
> +	int ret = -ENOMEM;
> +	unsigned char *tbuf = kmalloc(256, GFP_NOIO);
> +
> +	if (!tbuf)
> +		return -ENOMEM;
> +
> +	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +			USB_CDC_GET_NET_ADDRESS,
> +			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			0, USB_REQ_SET_ADDRESS, tbuf, 256,
> +			USB_CTRL_GET_TIMEOUT);
> +	if (ret == 6)
> +		memcpy(mac, tbuf, 6);
> +
> +	kfree(tbuf);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(usb_get_address);

This is a VERY cdc-net-specific function.  It is not a "generic" USB
function at all.  Why does it belong in the USB core?  Shouldn't it live
in the code that handles the other cdc-net-specific logic?

thanks,

greg k-h
