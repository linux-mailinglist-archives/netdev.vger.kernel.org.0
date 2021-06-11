Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2A33A479C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhFKRS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:18:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59722 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhFKRSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 13:18:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TvM1tGh9c3xs7mHGT3XCOu41VC7yHDCxbSRhbqeUah4=; b=GaCUOtlRRYolMt+/zTVtDYsfLC
        LfhOc9v8xu4fRDyMfMJi+kR1KOUFbDhXca/lkPitQMB+ALcljQh63uIn80PWHYp9uhBaGLn0YPPIU
        WTm4NuUv0Ap+Hnjfou1PJ416+Lc6EdS0tnYtHPlw2kDOsfsLBdCuutoaHd3c4YE23mS4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrklY-008t5y-AG; Fri, 11 Jun 2021 19:16:20 +0200
Date:   Fri, 11 Jun 2021 19:16:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
Message-ID: <YMOaZB6xf2xOpC0S@lunn.ch>
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

Module parameter are not liked in the network stack.

It actually seems like a udev problem, and you need to solve it
there. It is also not specific to USB. Any sort of interface can pop
up at an time, especially with parallel probing of busses. So you need
udev to detect there has been a race condition and try again with the
rename.

     Andrew
