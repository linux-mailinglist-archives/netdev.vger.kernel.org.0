Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AC42691C5
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbgINQjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:39:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:48711 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgINPhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 11:37:24 -0400
IronPort-SDR: ptISQzS4NZrVMZm4wYayRSAQZMQ+rhFZssFTk91ksbFqV2YgJsZdQlVZ7fvv2Tq1uD+gBIMa/U
 P0OB5kW/1Deg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="160028590"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160028590"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:37:24 -0700
IronPort-SDR: 6oWlcVa5PyiofNGc7GlZ8h0/bXIV2kNQRQ8PpkxM7QYiuLOS3fq0+LlJZZLWrOHvFE8rVqVv+m
 jBOw67EONqFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="335319296"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga008.jf.intel.com with ESMTP; 14 Sep 2020 08:37:22 -0700
Received: from andy by smile with local (Exim 4.94)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1kHqTT-00GdDZ-5G; Mon, 14 Sep 2020 18:32:59 +0300
Date:   Mon, 14 Sep 2020 18:32:59 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2] net: phy: leds: Deduplicate link LED trigger
 registration
Message-ID: <20200914153259.GJ3956970@smile.fi.intel.com>
References: <20200826152223.56508-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826152223.56508-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 06:22:23PM +0300, Andy Shevchenko wrote:
> Refactor phy_led_trigger_register() and deduplicate its functionality
> when registering LED trigger for link.

Is it good enough now?

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2: fixed build error (lkp, David)
>  drivers/net/phy/phy_led_triggers.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_led_triggers.c b/drivers/net/phy/phy_led_triggers.c
> index 59a94e07e7c5..08a3e9ea4102 100644
> --- a/drivers/net/phy/phy_led_triggers.c
> +++ b/drivers/net/phy/phy_led_triggers.c
> @@ -66,11 +66,11 @@ static void phy_led_trigger_format_name(struct phy_device *phy, char *buf,
>  
>  static int phy_led_trigger_register(struct phy_device *phy,
>  				    struct phy_led_trigger *plt,
> -				    unsigned int speed)
> +				    unsigned int speed,
> +				    const char *suffix)
>  {
>  	plt->speed = speed;
> -	phy_led_trigger_format_name(phy, plt->name, sizeof(plt->name),
> -				    phy_speed_to_str(speed));
> +	phy_led_trigger_format_name(phy, plt->name, sizeof(plt->name), suffix);
>  	plt->trigger.name = plt->name;
>  
>  	return led_trigger_register(&plt->trigger);
> @@ -99,12 +99,7 @@ int phy_led_triggers_register(struct phy_device *phy)
>  		goto out_clear;
>  	}
>  
> -	phy_led_trigger_format_name(phy, phy->led_link_trigger->name,
> -				    sizeof(phy->led_link_trigger->name),
> -				    "link");
> -	phy->led_link_trigger->trigger.name = phy->led_link_trigger->name;
> -
> -	err = led_trigger_register(&phy->led_link_trigger->trigger);
> +	err = phy_led_trigger_register(phy, phy->led_link_trigger, 0, "link");
>  	if (err)
>  		goto out_free_link;
>  
> @@ -119,7 +114,7 @@ int phy_led_triggers_register(struct phy_device *phy)
>  
>  	for (i = 0; i < phy->phy_num_led_triggers; i++) {
>  		err = phy_led_trigger_register(phy, &phy->phy_led_triggers[i],
> -					       speeds[i]);
> +					       speeds[i], phy_speed_to_str(speeds[i]));
>  		if (err)
>  			goto out_unreg;
>  	}
> -- 
> 2.28.0
> 

-- 
With Best Regards,
Andy Shevchenko


