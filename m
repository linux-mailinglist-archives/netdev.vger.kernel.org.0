Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71CC275642
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIWKYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWKYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 06:24:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86EF521BE5;
        Wed, 23 Sep 2020 10:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600856646;
        bh=4axLnYFaEHtr9+q27LR9CjkX1jMW8YKOSTMnO3OD97o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QaY6iA3xkR5TGJx2K7V/+m5EtdlK9/Fu/ZBAOuocOaJy3KikVsEt/NfipxIsN+KVk
         XcJGR+N15eWXOgxJ+xF6P8Edsu1vbtiUGfcJeEINxQnvOsmq5C5VStjK9T2r3RuHlH
         7NkOmNhwoViSSUm97fxeC28Hzl/9eCFGd8Zvgx9w=
Date:   Wed, 23 Sep 2020 12:24:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH 1/4] net: usbnet: use usb_control_msg_recv() and
 usb_control_msg_send()
Message-ID: <20200923102425.GC3154647@kroah.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-2-himadrispandya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923090519.361-2-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:35:16PM +0530, Himadri Pandya wrote:
> Potential incorrect use of usb_control_msg() has resulted in new wrapper
> functions to enforce its correct usage with proper error check. Hence
> use these new wrapper functions instead of calling usb_control_msg()
> directly.
> 
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> ---
>  drivers/net/usb/usbnet.c | 46 ++++------------------------------------
>  1 file changed, 4 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 2b2a841cd938..a38a85bef46a 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1982,64 +1982,26 @@ EXPORT_SYMBOL(usbnet_link_change);
>  static int __usbnet_read_cmd(struct usbnet *dev, u8 cmd, u8 reqtype,
>  			     u16 value, u16 index, void *data, u16 size)
>  {
> -	void *buf = NULL;
> -	int err = -ENOMEM;
> -
>  	netdev_dbg(dev->net, "usbnet_read_cmd cmd=0x%02x reqtype=%02x"
>  		   " value=0x%04x index=0x%04x size=%d\n",
>  		   cmd, reqtype, value, index, size);
>  
> -	if (size) {
> -		buf = kmalloc(size, GFP_KERNEL);
> -		if (!buf)
> -			goto out;
> -	}
> -
> -	err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> -			      cmd, reqtype, value, index, buf, size,
> +	return usb_control_msg_recv(dev->udev, 0,
> +			      cmd, reqtype, value, index, data, size,
>  			      USB_CTRL_GET_TIMEOUT);
> -	if (err > 0 && err <= size) {
> -        if (data)
> -            memcpy(data, buf, err);
> -        else
> -            netdev_dbg(dev->net,
> -                "Huh? Data requested but thrown away.\n");
> -    }
> -	kfree(buf);
> -out:
> -	return err;
>  }

Now there is no real need for these wrapper functions at all, except for
the debugging which I doubt anyone needs anymore.

So how about just deleting these and calling the real function instead?

thanks,

greg k-h
