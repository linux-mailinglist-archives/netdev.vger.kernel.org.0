Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99D21B15BE
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgDTTRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:17:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:37954 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgDTTRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 15:17:07 -0400
IronPort-SDR: fMI7/mdWCQJ0FMiLZJatti7d4Xr5n/KPX0CL6aRIWyYaegEEnu3Bz64B6hJ/G3mWN+bjZpQUoA
 KwrvPdKSZ/Lw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 12:17:07 -0700
IronPort-SDR: FogFN+UwXkNp5mBUPgbO//e3Ajk9w6cvCNNPDvOXHaFVKsdTZ/f2RLOohcF+zoVn+EgZIEai2j
 U3bndUTloCKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="245460787"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2020 12:17:03 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jQbuk-0026vi-Gw; Mon, 20 Apr 2020 22:17:06 +0300
Date:   Mon, 20 Apr 2020 22:17:06 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v1] net: bcmgenet: Use devm_clk_get_optional() to get the
 clocks
Message-ID: <20200420191706.GB185537@smile.fi.intel.com>
References: <20200420183058.67457-1-andriy.shevchenko@linux.intel.com>
 <c8d2dfb4-2833-7b68-3641-4f3ce2139cb2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8d2dfb4-2833-7b68-3641-4f3ce2139cb2@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:33:07AM -0700, Florian Fainelli wrote:
> On 4/20/2020 11:30 AM, Andy Shevchenko wrote:
> > Conversion to devm_clk_get_optional() makes it explicit that clocks are
> > optional. This change allows to handle deferred probe in case clocks are
> > defined, but not yet probed. Due to above changes replace dev_dbg() by
> > dev_err() and bail out in error case.
> > 
> > While here, check potential error when enable main clock.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >   .../net/ethernet/broadcom/genet/bcmgenet.c    | 25 +++++++++++--------
> >   1 file changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > index ef275db018f73..045f7b7f0b5d3 100644
> > --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> > @@ -3487,13 +3487,16 @@ static int bcmgenet_probe(struct platform_device *pdev)
> >   		priv->dma_max_burst_length = DMA_MAX_BURST_LENGTH;
> >   	}
> > -	priv->clk = devm_clk_get(&priv->pdev->dev, "enet");
> > +	priv->clk = devm_clk_get_optional(&priv->pdev->dev, "enet");
> >   	if (IS_ERR(priv->clk)) {
> > -		dev_dbg(&priv->pdev->dev, "failed to get enet clock\n");
> > -		priv->clk = NULL;
> > +		dev_err(&priv->pdev->dev, "failed to get enet clock\n");
> 
> Please maintain the dev_dbg() here and likewise for the rest of your
> changes. With that:
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Ah, I see, actually dev_err() will make too much noise in case of deferred probe.

Perhaps
	if (err != -EPROBE_DEFER)
		dev_err(...);
?

-- 
With Best Regards,
Andy Shevchenko


