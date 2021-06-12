Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24513A4D37
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 09:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhFLHDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 03:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLHDO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 03:03:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 104C561009;
        Sat, 12 Jun 2021 07:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623481275;
        bh=iKKyGp0fUDKDEcJ9RZ05rQW+0YvDlhXFzxPG/BdB7KE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0I63GfFvAYt0uAA2pS1BDbGxuAsn5MfkmsuAmA9dpSGAvePJOH49D8iUzi7o7ZXEm
         arMa95ZzYmBqT1pqnb0j7UICbMD+ejJkIp2Z4FWDQP4LbJxryPD5lkEDHWMkMNhuKN
         4OtaaFAUP5nTa5o5jJaz1C17jSKDeh6re6Kd5HmY=
Date:   Sat, 12 Jun 2021 09:01:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
Message-ID: <YMRbt+or+QTlqqP9@kroah.com>
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611152339.182710-1-jonathan.davies@nutanix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:
> When the predictable device naming scheme for NICs is not in use, it is
> common for there to be udev rules to rename interfaces to names with
> prefix "eth".
> 
> Since the timing at which USB NICs are discovered is unpredictable, it
> can be interfere with udev's attempt to rename another interface to
> "eth0" if a freshly discovered USB interface is initially given the name
> "eth0".
> 
> Hence it is useful to be able to override the default name. A new usbnet
> module parameter allows this to be configured.
> 
> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
> Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
> ---
>  drivers/net/usb/usbnet.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index ecf6284..55f6230 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -72,6 +72,13 @@ static int msg_level = -1;
>  module_param (msg_level, int, 0);
>  MODULE_PARM_DESC (msg_level, "Override default message level");
>  
> +#define DEFAULT_ETH_DEV_NAME "eth%d"
> +
> +static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
> +module_param(eth_device_name, charp, 0644);
> +MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
> +				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");

This is not the 1990's, please do not add new module parameters as they
are on a global driver level, and not on a device level.

Also changing the way usb network devices are named is up to userspace,
the kernel should not be involved in this.  What is wrong with just
renaming it in userspace as you want to today?

thanks,

greg k-h
