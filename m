Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADFB312B98
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBHIWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:22:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhBHIWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 03:22:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 440D164E83;
        Mon,  8 Feb 2021 08:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612772524;
        bh=AHqK70hwRArUPlmaNBqcB/l3xwgWWlC+IUF7sEqQJoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Euxtba8pgMfQVOo5vvJdqevmIr468+acgFi8a67qB4zqSVCugAzPaXlpN2CM1qcOs
         k8KiMQXs/GtnGjGeYDZuuJkt2T2slyvHkZpmUyxGoZF4Au2OhQgAz9KNG8uxl1OIGM
         WSTRUgpyNwvLKVjVdF4n6PaTu9DRYG+HldN9C41A=
Date:   Mon, 8 Feb 2021 09:22:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mei: bus: simplify mei_cl_device_remove()
Message-ID: <YCD0qdaOG1pb+gPM@kroah.com>
References: <20210208073705.428185-1-uwe@kleine-koenig.org>
 <20210208073705.428185-2-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210208073705.428185-2-uwe@kleine-koenig.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:37:04AM +0100, Uwe Kleine-König wrote:
> The driver core only calls a bus' remove function when there is actually
> a driver and a device. So drop the needless check and assign cldrv earlier.
> 
> (Side note: The check for cldev being non-NULL is broken anyhow, because
> to_mei_cl_device() is a wrapper around container_of() for a member that is
> not the first one. So cldev only can become NULL if dev is (void *)0xc
> (for archs with 32 bit pointers) or (void *)0x18 (for archs with 64 bit
> pointers).)
> 
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
> ---
>  drivers/misc/mei/bus.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
> index 2907db260fba..50d617e7467e 100644
> --- a/drivers/misc/mei/bus.c
> +++ b/drivers/misc/mei/bus.c
> @@ -878,13 +878,9 @@ static int mei_cl_device_probe(struct device *dev)
>  static int mei_cl_device_remove(struct device *dev)
>  {
>  	struct mei_cl_device *cldev = to_mei_cl_device(dev);
> -	struct mei_cl_driver *cldrv;
> +	struct mei_cl_driver *cldrv = to_mei_cl_driver(dev->driver);
>  	int ret = 0;
>  
> -	if (!cldev || !dev->driver)

Yes, anyone checking that the results of a container_of() wrapper can be
NULL is not checking anything at all :)

thanks for the cleanups, I'll go queue them up.

greg k-h
