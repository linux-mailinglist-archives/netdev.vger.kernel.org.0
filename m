Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BB11BF592
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3KeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:34:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:50128 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgD3KeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 06:34:06 -0400
IronPort-SDR: s0djCdIjweqheUKz0Ye+ae1N5syWT2mC1HDxrNMPJg/WKH168H342/GR7ckW2pIJomFmxN5U95
 lFoDc0myuRUQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 03:34:05 -0700
IronPort-SDR: oNSGShFgTIHLbK5FAXLFuSBJuQCzaR3qHIXy0kckPl8CstYgq8nfkf5yyCb731OYv0ajJXt2SV
 KYOSSGvqX7zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="scan'208";a="282817616"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004.fm.intel.com with ESMTP; 30 Apr 2020 03:34:03 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jU6W7-003tPY-1V; Thu, 30 Apr 2020 13:34:07 +0300
Date:   Thu, 30 Apr 2020 13:34:07 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Claudiu.Beznea@microchip.com
Cc:     Nicolas.Ferre@microchip.com, netdev@vger.kernel.org,
        davem@davemloft.net, alexandre.belloni@bootlin.com
Subject: Re: [PATCH v1] net: macb: Fix runtime PM refcounting
Message-ID: <20200430103407.GS185537@smile.fi.intel.com>
References: <20200427105120.77892-1-andriy.shevchenko@linux.intel.com>
 <75573a4d-b465-df63-c61d-6ec4c626e7fb@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75573a4d-b465-df63-c61d-6ec4c626e7fb@microchip.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 07:59:41AM +0000, Claudiu.Beznea@microchip.com wrote:
> 
> 
> On 27.04.2020 13:51, Andy Shevchenko wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > The commit e6a41c23df0d, while trying to fix an issue,
> > 
> >     ("net: macb: ensure interface is not suspended on at91rm9200")
> > 
> > introduced a refcounting regression, because in error case refcounter
> > must be balanced. Fix it by calling pm_runtime_put_noidle() in error case.
> > 
> > While here, fix the same mistake in other couple of places.

...

> >         status = pm_runtime_get_sync(&bp->pdev->dev);
> > -       if (status < 0)
> > +       if (status < 0) {
> > +               pm_runtime_put_noidle(&bp->pdev->dev);
> 
> pm_runtime_get_sync() calls __pm_runtime_resume(dev, RPM_GET_PUT),
> increment refcounter and resume the device calling rpm_resume().

Read the code further than the header file, please.

> pm_runtime_put_noidle() just decrement the refcounter.

which is exactly what has to be done on error path.

> The proper way,
> should be calling suspend again if the operation fails as
> pm_runtime_put_autosuspend() does. So, what the code under mdio_pm_exit
> label does should be enough.

Huh? It returns an error without rebalancing refcounter.

Yeah, one more time an evidence that people do not get runtime PM properly.

> >                 goto mdio_pm_exit;
> > +       }
> > 
> >         status = macb_mdio_wait_for_idle(bp);
> >         if (status < 0)
> > @@ -386,8 +388,10 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >         int status;
> > 
> >         status = pm_runtime_get_sync(&bp->pdev->dev);
> > -       if (status < 0)
> > +       if (status < 0) {
> > +               pm_runtime_put_noidle(&bp->pdev->dev);
> 
> Ditto.

Ditto.

> 
> >                 goto mdio_pm_exit;
> > +       }
> > 
> >         status = macb_mdio_wait_for_idle(bp);
> >         if (status < 0)
> > @@ -3816,8 +3820,10 @@ static int at91ether_open(struct net_device *dev)
> >         int ret;
> > 
> >         ret = pm_runtime_get_sync(&lp->pdev->dev);
> > -       if (ret < 0)
> > +       if (ret < 0) {
> > +               pm_runtime_put_noidle(&lp->pdev->dev);
> 
> The proper way should be calling pm_runtime_put_sync() not only for this
> returning path but for all of them in this function.

Of course not.

> >                 return ret;
> > +       }
> > 
> >         /* Clear internal statistics */
> >         ctl = macb_readl(lp, NCR);
> > --
> > 2.26.2
> > 

-- 
With Best Regards,
Andy Shevchenko


