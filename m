Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E56D1E1B67
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 08:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgEZGfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 02:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgEZGfY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 02:35:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9752068D;
        Tue, 26 May 2020 06:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590474923;
        bh=lT4rvAif71IsjSUrxQMACsE1/IWSMB9YtdoebR/hi/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TnaP6H+bfcIwQM2DdB81Z/y15ftt9v8BASFf0zYe1DVE1SWw2uZEVX4B8sm9OKNVL
         U7W1SxfUlTqITkqwa7Wl9DLBh4VenSSpH0PyygxmtomnmGeuy8dcfzNYBZgXv408qp
         NGe5za7/QN+ohkAa6M6oqOsAotjw69NQ2c+RPcMk=
Date:   Tue, 26 May 2020 08:35:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 8/8] net/iucv: Use the new device_to_pm() helper to
 access struct dev_pm_ops
Message-ID: <20200526063521.GC2578492@kroah.com>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-9-kw@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200525182608.1823735-9-kw@linux.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 06:26:08PM +0000, Krzysztof Wilczyński wrote:
> Use the new device_to_pm() helper to access Power Management callbacs
> (struct dev_pm_ops) for a particular device (struct device_driver).
> 
> No functional change intended.
> 
> Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
> ---
>  net/iucv/iucv.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
> index 9a2d023842fe..1a3029ab7c1f 100644
> --- a/net/iucv/iucv.c
> +++ b/net/iucv/iucv.c
> @@ -1836,23 +1836,23 @@ static void iucv_external_interrupt(struct ext_code ext_code,
>  
>  static int iucv_pm_prepare(struct device *dev)
>  {
> -	int rc = 0;
> +	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
>  
>  #ifdef CONFIG_PM_DEBUG
>  	printk(KERN_INFO "iucv_pm_prepare\n");
>  #endif
> -	if (dev->driver && dev->driver->pm && dev->driver->pm->prepare)
> -		rc = dev->driver->pm->prepare(dev);
> -	return rc;
> +	return pm && pm->prepare ? pm->prepare(dev) : 0;

No need for ? : here either, just use if () please.

It's "interesting" how using your new helper doesn't actually make the
code smaller.  Perhaps it isn't a good helper function?

thanks,

greg k-h
