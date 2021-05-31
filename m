Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC1E3958AF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhEaKE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:04:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:3574 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEaKE4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 06:04:56 -0400
IronPort-SDR: qJDjOufhdBRywiJM2WMUKgSRaCmk5yIztGsTT4+DtzH2IsXJxIK0h1jx8zpcr25x2X+87XXit3
 L5YBEDR/yOBQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="264523616"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="264523616"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 03:03:17 -0700
IronPort-SDR: R7TmoirUKoi5vXYZAGmOoI85Ey9fXqwPm7EYyUmaa7ResZBLfCTlzJULqeTZC0imwG27GsS7fw
 22ixxb1exIzg==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="398924173"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 03:03:14 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1lnelL-00G47N-El; Mon, 31 May 2021 13:03:11 +0300
Date:   Mon, 31 May 2021 13:03:11 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 1/2] can: mcp251xfd: Try to get crystal clock rate
 from property
Message-ID: <YLS0XwpFme+LFBAx@smile.fi.intel.com>
References: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
 <20210531084720.6xql2r4uhp6ruzl6@pengutronix.de>
 <YLSzRdpp9EWsLeFy@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLSzRdpp9EWsLeFy@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 12:58:29PM +0300, Andy Shevchenko wrote:
> On Mon, May 31, 2021 at 10:47:20AM +0200, Marc Kleine-Budde wrote:
> > On 26.05.2021 22:33:26, Andy Shevchenko wrote:
> > > In some configurations, mainly ACPI-based, the clock frequency of the device
> > > is supplied by very well established 'clock-frequency' property. Hence, try
> > > to get it from the property at last if no other providers are available.
> 
> > >  		return dev_err_probe(&spi->dev, PTR_ERR(reg_xceiver),
> > >  				     "Failed to get Transceiver regulator!\n");
> > >  
> > > -	clk = devm_clk_get(&spi->dev, NULL);
> > > +	/* Always ask for fixed clock rate from a property. */
> > > +	device_property_read_u32(&spi->dev, "clock-frequency", &rate);
> > 
> > what about error handling....?
> 
> Not needed, but rate should be assigned to 0, which is missed.
> 
> > > +	clk = devm_clk_get_optional(&spi->dev, NULL);
> > >  	if (IS_ERR(clk))
> > >  		return dev_err_probe(&spi->dev, PTR_ERR(clk),
> > >  				     "Failed to get Oscillator (clock)!\n");
> > >  	freq = clk_get_rate(clk);
> > > +	if (freq == 0)
> > > +		freq = rate;
> > 
> > ... this means we don't fail if there is neither a clk nor a
> > clock-frequency property.
> 
> The following will check for it (which is already in the code)
> 
>   if (freq <= MCP251XFD_SYSCLOCK_HZ_MAX / MCP251XFD_OSC_PLL_MULTIPLIER) {

Even before, actually,

             /* Sanity check */
             if (freq < MCP251XFD_SYSCLOCK_HZ_MIN ||
		 freq > MCP251XFD_SYSCLOCK_HZ_MAX) {


> > I've send a v3 to fix this.
> 
> You mean I have to send v3?
> Sure!

So, I am going to send a v3 with amended commit message and assigning rate
to 0.

-- 
With Best Regards,
Andy Shevchenko


