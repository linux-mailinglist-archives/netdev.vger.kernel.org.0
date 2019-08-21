Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF619975F6
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfHUJXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:23:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:35050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbfHUJXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 05:23:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 18942AD22;
        Wed, 21 Aug 2019 09:23:02 +0000 (UTC)
Message-ID: <1566378498.8347.6.camel@suse.com>
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
From:   Oliver Neukum <oneukum@suse.com>
To:     Charles.Hyde@dellteam.com, linux-acpi@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Mario.Limonciello@dell.com, gregkh@linuxfoundation.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org
Date:   Wed, 21 Aug 2019 11:08:18 +0200
In-Reply-To: <1566339522507.45056@Dellteam.com>
References: <1566339522507.45056@Dellteam.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 20.08.2019, 22:18 +0000 schrieb
Charles.Hyde@dellteam.com:
> The core USB driver message.c is missing get/set address functionality

This should go into usbnet. The CDC parser is where it is because
it is needed for serial and network devices. As serial devices
do not have a MAC, this can go into usbnet.

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
> + * @dev: device whose endpoint is halted

Which endpoint?

> + * @mac: buffer for containing 
> + * Context: !in_interrupt ()
> + *
> + * This will attempt to get the six byte MAC address from a USB device's
> + * ethernet controller using GET_NET_ADDRESS command.
> + *
> + * This call is synchronous, and may not be used in an interrupt context.
> + *
> + * Return: Zero on success, or else the status code returned by the

Well, I am afraid it will return 6 on success.

> + * underlying usb_control_msg() call.
> + */
> +int usb_get_address(struct usb_device *dev, unsigned char * mac)
> +{
> +	int ret = -ENOMEM;

Initialization is unnecessary here.

> +	unsigned char *tbuf = kmalloc(256, GFP_NOIO);

If you intentionally picked a safety margin of 42 times, this
is cool. Otherwise it is a litttle much.

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

You cannot ignore the case of devices sending more or less than 6
bytes.

	Regards
		Oliver

