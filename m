Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE73613A0D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbiJaPc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiJaPcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:32:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF311180C;
        Mon, 31 Oct 2022 08:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667230373; x=1698766373;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=njbyewzlB0I61UcEx1gvn+c62w1UHRxU4mCpMpRMQrs=;
  b=BGjKoZZzymt0S+u2dDNjrPIjUxF9104QNVg9JNSr5aCsrBOuUT+g6vnT
   Clc5CFiQ/Z/6oTmVLo+ZRQFqBCZpYIuDTRCRKcSj+JGnqK99IPVVEtwpO
   HDSzSHijiAh0iHitSlTYc+iGAoVUl5/9/pxJGQpRsZ0JSfyucGR4wAkdS
   77n2Sn+hY8UedT+o77sT+dnQla1dQFwxwPNq8wyzPH49scuK2OuAzn30i
   /ROPn2gZARyuoNpPbxp6gP7oO4NkedZCR4C6FeMdRPH+kUr6nvBFXhuDJ
   vc25iYuEka0yQX+Ho35pP08+p23gz0yEw/G3q0s1xMU5B4HDMgEt8DVMc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="292220951"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="292220951"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 08:32:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="611527071"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="611527071"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 31 Oct 2022 08:32:29 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1opWm2-005Av2-1x;
        Mon, 31 Oct 2022 17:32:26 +0200
Date:   Mon, 31 Oct 2022 17:32:26 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Lee Jones <lee@kernel.org>
Cc:     Gene Chen <gene_chen@richtek.com>,
        Andrew Jeffery <andrew@aj.id.au>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
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
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 00/11] leds: deduplicate led_init_default_state_get()
Message-ID: <Y1/qisszTjUL9ngU@smile.fi.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
 <Y1gZ/zBtc2KgXlbw@smile.fi.intel.com>
 <Y1+NHVS5ZJLFTBke@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1+NHVS5ZJLFTBke@google.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 08:53:49AM +0000, Lee Jones wrote:
> On Tue, 25 Oct 2022, Andy Shevchenko wrote:
> 
> > On Tue, Sep 06, 2022 at 04:49:53PM +0300, Andy Shevchenko wrote:
> > > There are several users of LED framework that reimplement the
> > > functionality of led_init_default_state_get(). In order to
> > > deduplicate them move the declaration to the global header
> > > (patch 2) and convert users (patche 3-11).
> > 
> > Dear LED maintainers, is there any news on this series? It's hanging around
> > for almost 2 months now...
> 
> My offer still stands if help is required.

From my point of view the LED subsystem is quite laggish lately (as shown by
this patch series, for instance), which means that _in practice_ the help is
needed, but I haven't got if we have any administrative agreement on that.

Pavel?

-- 
With Best Regards,
Andy Shevchenko


