Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ADB26BCC4
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgIPGWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgIPGVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 02:21:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1419A2067C;
        Wed, 16 Sep 2020 06:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237312;
        bh=uJRg3V5jemoM77QzifyzTeMiwLxju00kO9REccN1WMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DujFdqAhT1OQ3IRITXYlfsxdYOZL2VkULfVuEtbvzYXPW/m7rri6WMT2RUJjzFf6b
         eTQtttNQmPq5MX9cyCYupPwWkn9T5Q1EBSBt/mh82kezqtg+pW35+r9TK/Egnxy1F3
         x/tXW4WOzOHx+Yx7GuP8z3svgmc6aeMtJvg315zo=
Date:   Wed, 16 Sep 2020 08:22:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees][PATCH] rtl8150: set memory to all 0xFFs
 on failed register reads
Message-ID: <20200916062227.GD142621@kroah.com>
References: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916050540.15290-1-anant.thazhemadam@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 10:35:40AM +0530, Anant Thazhemadam wrote:
> get_registers() copies whatever memory is written by the
> usb_control_msg() call even if the underlying urb call ends up failing.
> 
> If get_registers() fails, or ends up reading 0 bytes, meaningless and 
> junk register values would end up being copied over (and eventually read 
> by the driver), and since most of the callers of get_registers() don't 
> check the return values of get_registers() either, this would go unnoticed.
> 
> It might be a better idea to try and mirror the PCI master abort
> termination and set memory to 0xFFs instead in such cases.

It would be better to use this new api call instead of
usb_control_msg():
	https://lore.kernel.org/r/20200914153756.3412156-1-gregkh@linuxfoundation.org

How about porting this patch to run on top of that series instead?  That
should make this logic much simpler.



> 
> Fixes: https://syzkaller.appspot.com/bug?extid=abbc768b560c84d92fd3
> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> ---
>  drivers/net/usb/rtl8150.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
> index 733f120c852b..04fca7bfcbcb 100644
> --- a/drivers/net/usb/rtl8150.c
> +++ b/drivers/net/usb/rtl8150.c
> @@ -162,8 +162,13 @@ static int get_registers(rtl8150_t * dev, u16 indx, u16 size, void *data)
>  	ret = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
>  			      RTL8150_REQ_GET_REGS, RTL8150_REQT_READ,
>  			      indx, 0, buf, size, 500);
> -	if (ret > 0 && ret <= size)
> +
> +	if (ret < 0)
> +		memset(data, 0xff, size);
> +
> +	else
>  		memcpy(data, buf, ret);
> +
>  	kfree(buf);
>  	return ret;
>  }
> @@ -276,7 +281,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
>  
>  static inline void set_ethernet_addr(rtl8150_t * dev)
>  {
> -	u8 node_id[6];
> +	u8 node_id[6] = {0};

This should not be needed to be done.

thanks,

greg k-h
