Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED326BB44C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjCONRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbjCONRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:17:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D9723C60;
        Wed, 15 Mar 2023 06:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678886230; x=1710422230;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1DQUI8x1dGKooP+0g0BDBbXwwTxIZZOldlQJxrEvwLU=;
  b=R/C90hMxoiZz6riV/4R/kK2kXhWjO3m0Ol+nvNkBmumsL1ViECVDmONJ
   vCvwhJyxnDjiaNimArqA2i3MQYTV04yFv5HdjA0A0YeJYxbk7Vs5OllwP
   8DXNRKgZea/KmxlztwM4zsuePktpGzPup04nxkaRMmQACQK5rKbSYcpcH
   RKvEOq2YQOe4ZXrfbxuAXwD5btWuWGMQ+ItG8EGCYKviGW6JmdpSUa//p
   EP7pRDuior7axasmb3nzaSgwrMhj341BlH3v17+CvzutzKztkvKYSUON6
   emt4zfCL2Oy5NPGjzQTqgrT5xM/RyEbAejW+Qyv/6hKEJLJdhKwq3xXag
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317350732"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="317350732"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 06:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="743693190"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="743693190"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2023 06:16:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pcQzj-003q8i-1V;
        Wed, 15 Mar 2023 15:16:43 +0200
Date:   Wed, 15 Mar 2023 15:16:42 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZBHFOlwoLYn3xz2L@smile.fi.intel.com>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
 <ZBFeUazA9X9mmWiJ@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBFeUazA9X9mmWiJ@localhost.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 06:57:37AM +0100, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 08:18:24PM +0200, Andy Shevchenko wrote:
> > LED core provides a helper to parse default state from firmware node.
> > Use it instead of custom implementation.

...

> You have to fix implict declaration of the led_init_default_state_get().

Seems like users have to choose between 'select NEW_LEDS' and
'depends on NEW_LEDS' in the Kconfig.

> I wonder if the code duplication here can be avoided:

Whether or not this is out of the scope of this patch.
Feel free to submit one :-)

...

> Only suggestion, patch looks good.

Thank you!

-- 
With Best Regards,
Andy Shevchenko


