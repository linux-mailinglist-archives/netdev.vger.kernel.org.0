Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D06160D250
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 19:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiJYRQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 13:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbiJYRQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 13:16:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3085B157F55;
        Tue, 25 Oct 2022 10:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666718216; x=1698254216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tWI0CC/wYBfwZBoYYtn6VEm9PD6POSQYRocuvbf90tQ=;
  b=TkI/nSaj1OZJ1Gsd8EHSz7QId2rmeJeb1B4u3SvyOegvh1EUoeOky7nF
   NwWBvvKyFZESujTnRFTUx1ZD6jhLGIFIC0RglJBmTi6xjiVv7rfe3nAU8
   nvUtT7vfL2rO/w/pPDR7lCrlXklTd3O135tMw7FuU5Erd48NHR7PGxbn/
   C0nVo32LOfTHKZCpldxkQmZq7v25hFJZP6L1pG099n0u7Qe6f1phTkCo7
   z6rJYYb4sRlGcFIive4gP39DKKm9Dp7ilXEyJzbZxNWki8JArj56swlrk
   zejMB3qZBO1HBFt/TCbhU7TkpXCAFFM5T7RkTzRq3t72X7wTM7pzUSOtU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="288136398"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="288136398"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 10:16:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="609646608"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="609646608"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2022 10:16:50 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1onNXj-002Aw0-1l;
        Tue, 25 Oct 2022 20:16:47 +0300
Date:   Tue, 25 Oct 2022 20:16:47 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Message-ID: <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> There are several users of LED framework that reimplement the
> functionality of led_init_default_state_get(). In order to
> deduplicate them move the declaration to the global header
> (patch 2) and convert users (patche 3-11).

Dear LED maintainers, is there any news on this series? It's hanging around
for almost 2 months now...

> Changelog v3:
> - added tag to patch 11 (Kurt)
> - Cc'ed to Lee, who might help with LED subsystem maintenance
> 
> Changelog v2:
> - added missed patch 2 and hence make it the series
> - appended tag to patch 7
> - new patch 1
> 
> Andy Shevchenko (11):
>   leds: add missing includes and forward declarations in leds.h
>   leds: Move led_init_default_state_get() to the global header
>   leds: an30259a: Get rid of custom led_init_default_state_get()
>   leds: bcm6328: Get rid of custom led_init_default_state_get()
>   leds: bcm6358: Get rid of custom led_init_default_state_get()
>   leds: mt6323: Get rid of custom led_init_default_state_get()
>   leds: mt6360: Get rid of custom led_init_default_state_get()
>   leds: pca955x: Get rid of custom led_init_default_state_get()
>   leds: pm8058: Get rid of custom led_init_default_state_get()
>   leds: syscon: Get rid of custom led_init_default_state_get()
>   net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
> 
>  drivers/leds/flash/leds-mt6360.c           | 38 +++--------------
>  drivers/leds/leds-an30259a.c               | 21 ++--------
>  drivers/leds/leds-bcm6328.c                | 49 +++++++++++-----------
>  drivers/leds/leds-bcm6358.c                | 32 +++++++-------
>  drivers/leds/leds-mt6323.c                 | 30 ++++++-------
>  drivers/leds/leds-pca955x.c                | 26 +++---------
>  drivers/leds/leds-pm8058.c                 | 29 ++++++-------
>  drivers/leds/leds-syscon.c                 | 49 ++++++++++------------
>  drivers/leds/leds.h                        |  1 -
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++----------
>  include/linux/leds.h                       | 15 ++++---
>  11 files changed, 143 insertions(+), 192 deletions(-)
> 
> -- 
> 2.35.1
> 

-- 
With Best Regards,
Andy Shevchenko


