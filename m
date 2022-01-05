Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19234855E6
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbiAEPd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241503AbiAEPdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:33:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC32C061245;
        Wed,  5 Jan 2022 07:33:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E903B81C27;
        Wed,  5 Jan 2022 15:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88FAC36AE3;
        Wed,  5 Jan 2022 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641396829;
        bh=eKaCrH/aeScTj/6kwS7Z5c1xsvpwcf3QZNxFtzniax4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtXFq1R5QavrEdOP/8fcODPyOMmU/zpBGaDSNIhtcDmi+XmpJIfCTaCulgTQiHOVy
         Gr9B3evhRxptwdIY4OgHAb/rspjd7z4gI9cBrWSdKtXxKEl+IsysQrdVU2IKl5Z5D2
         sBsOd6qFsheVoDiL2fB1E39AF5W1OjuH+LJv4UE0=
Date:   Wed, 5 Jan 2022 16:33:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 2/3] net: usb: r8152: Set probe mode to sync
Message-ID: <YdW6WuT0vcTkcW+0@kroah.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <20220105151427.8373-2-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105151427.8373-2-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:14:26PM +0800, Aaron Ma wrote:
> To avoid the race of get passthrough MAC,
> set probe mode to sync to check the used MAC address.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 2483dc421dff..7cf2faf8d088 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -29,6 +29,8 @@
>  #include <crypto/hash.h>
>  #include <linux/usb/r8152.h>
>  
> +static struct usb_driver rtl8152_driver;
> +
>  /* Information for net-next */
>  #define NETNEXT_VERSION		"12"
>  
> @@ -9546,6 +9548,9 @@ static int rtl8152_probe(struct usb_interface *intf,
>  	struct r8152 *tp;
>  	struct net_device *netdev;
>  	int ret;
> +	struct device_driver *rtl8152_drv = &rtl8152_driver.drvwrap.driver;
> +
> +	rtl8152_drv->probe_type = PROBE_FORCE_SYNCHRONOUS;

If you really need to set this type of thing then set BEFORE you
register the driver.  After-the-fact like this is way too late, sorry.
You are already in the probe function which is after the driver core
checked this flag :(

How did you test this?

thanks,

greg k-h
