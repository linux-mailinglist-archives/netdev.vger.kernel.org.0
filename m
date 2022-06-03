Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925C353CDB5
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 19:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiFCRFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344221AbiFCRFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:05:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F8F51E4D;
        Fri,  3 Jun 2022 10:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654275909; x=1685811909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cyKQTmlb0QCRYTmE5OMWOU0sKSOShEX69kWs2+Ah3Ho=;
  b=BIEGXGgzQkqVdvUJdIhbeNrky90d922gAphN16IXWpRXKOsbbTLvcTWy
   d//rLEzA/MxliRmjrKXOh9SmgUhFO2qulK/11mUJ4KkzNBi+Dv9OaVD/N
   L/CzjXuQIeUVPlNJ8o1hiBqg71V39qAVokRGdGO67pfjFKq0Ief7y/Ucn
   3UraaBmXLAubFJEc8qNH7RfpiwrrtE+gHmex65BBvUlZUcGk1t+IlaDD/
   KEtFnR+IbMLkHCU4UebfscoFdaw8R6EyP+hd+zTFHKkFADQZRVeQlvIlQ
   cMyWYc6r5NXAIn2gqQJB2XY2h5+ilg2vqjdyN43pKodggEkPQbvdkfO72
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10367"; a="276045773"
X-IronPort-AV: E=Sophos;i="5.91,275,1647327600"; 
   d="scan'208";a="276045773"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 10:05:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,275,1647327600"; 
   d="scan'208";a="613354138"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2022 10:05:06 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nxAjP-000Sca-Lp;
        Fri, 03 Jun 2022 20:05:03 +0300
Date:   Fri, 3 Jun 2022 20:05:03 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Joe Perches <joe@perches.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v1 1/2] wireless: ray_cs: Utilize strnlen() in
 parse_addr()
Message-ID: <Ypo/P1LpcGEGDT1/@smile.fi.intel.com>
References: <20220603164414.48436-1-andriy.shevchenko@linux.intel.com>
 <b59b922f96603468cbbe69b6359ec417083c526b.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b59b922f96603468cbbe69b6359ec417083c526b.camel@perches.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 09:50:55AM -0700, Joe Perches wrote:
> On Fri, 2022-06-03 at 19:44 +0300, Andy Shevchenko wrote:
> > Instead of doing simple operations and using an additional variable on stack,
> > utilize strnlen() and reuse len variable.
> []
> > diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
> []
> > +	while (len > 0) {
> > +		if ((k = hex_to_bin(in_str[len--])) != -1)
> >  			out[i] = k;
> >  		else
> >  			return 0;
> 
> could be reversed and unindented
> 
> >  
> > -		if (j == 0)
> > +		if (len == 0)
> >  			break;
> > -		if ((k = hex_to_bin(in_str[j--])) != -1)
> > +		if ((k = hex_to_bin(in_str[len--])) != -1)
> >  			out[i] += k << 4;
> >  		else
> >  			return 0;
> 
> and here

It might be done as a follow up. Thanks!


-- 
With Best Regards,
Andy Shevchenko


