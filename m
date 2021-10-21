Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099EC4361DE
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhJUMkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhJUMki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 08:40:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CED660E05;
        Thu, 21 Oct 2021 12:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634819901;
        bh=T3Ke85gRqLotKwqhbroI8pmVVoX9PeyZrn1+k6eWjUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YKMYU0PwspwDS5Hyjnwq2aYgtYS5mnQZQhrtFw/D5efF1Qz1eAh4VFW/1NYVcEn1W
         YPEV+rlIh45KoHiW5WUwongaCXWWylZPI+4SiyBtFgADsXj6vkQ+VU/sbGj9W68oM/
         BMgGNANxDSF/2onSHyFC7BT3D2tN8u37uTfXcDnGq7tpliq0K9q0x8kbvpnpZKK2d/
         Tk6FnP5Y64+jlsGJB9sjRj+KtIFK18GS7pUMCOXlgpSF9Rx6yw06vyKDOKGLL1+7aM
         88oj93sbargOT5fkPjTbdD/zmf7cCbJ4jwzT3EBUoHwIJdl9a+lSa7zBWhp/2lEN9H
         UDvjsJlQB0n+g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mdXKi-0005yo-4m; Thu, 21 Oct 2021 14:38:08 +0200
Date:   Thu, 21 Oct 2021 14:38:08 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Subject: Re: [PATCHv2] usbnet: sanity check for maxpacket
Message-ID: <YXFfMCZA3XHzHfgQ@hovoldconsulting.com>
References: <20211021122944.21816-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021122944.21816-1-oneukum@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 02:29:44PM +0200, Oliver Neukum wrote:
> maxpacket of 0 makes no sense and oopses as we need to divide
> by it. Give up.
> 
> V2: fixed typo in log and stylistic issues

Changelog goes below the ---

> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com

Again,

Reviewed-by: Johan Hovold <johan@kernel.org>

> ---
>  drivers/net/usb/usbnet.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 840c1c2ab16a..80432ee0ce69 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1788,6 +1788,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	if (!dev->rx_urb_size)
>  		dev->rx_urb_size = dev->hard_mtu;
>  	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
> +	if (dev->maxpacket == 0) {
> +		/* that is a broken device */
> +		goto out4;
> +	}
>  
>  	/* let userspace know we have a random address */
>  	if (ether_addr_equal(net->dev_addr, node_id))
