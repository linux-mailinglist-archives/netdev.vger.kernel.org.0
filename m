Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3E55B8698
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiINKut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiINKur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:50:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB61A4661B;
        Wed, 14 Sep 2022 03:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663152646; x=1694688646;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FJYMs62ascLSw9OHOfFlHvVTgyDpbA2c8qbkQOb1Nks=;
  b=Ivb6PcF/NUgvu7ZigV/+XyLR54nCeiGMWXmpwgBBwY3AF2SiAL1lf9To
   1AYNOynCya0x2Ah4ApyxuFxerysMDylHcyLUHlBf0uqp0z47PxLJci62L
   LdKQ69iQKeLbZXvxqhUQa2NTatLqeqRGUsk/sptJe3lzy72218FgFhn3Y
   CWU8sUtcdrcebLOv+zWcv9Jr24nM8CupSG4uAuOBKbOlhmE7pJ2GfQHAn
   QCX/5mwoGfxL48p0cOg9MDJhW9VssQTeaRFSezuaGGFzQutzMRychMlaG
   5Wg6k1M8/jaKfdcbrh99815bs7V3eIOPFvnvfdzr3pASjTWzVpPJon0zV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="297127793"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="297127793"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 03:50:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="705918476"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 03:50:42 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oYPyY-002A7j-1g;
        Wed, 14 Sep 2022 13:50:38 +0300
Date:   Wed, 14 Sep 2022 13:50:38 +0300
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
Message-ID: <YyGx/t8rLY59HXju@smile.fi.intel.com>
References: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906135004.14885-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

Can this be applied now?

Lee, Pavel, what do you think?

> Changelog v3:
> - added tag to patch 11 (Kurt)
> - Cc'ed to Lee, who might help with LED subsystem maintenance
> 
> Changelog v2:
> - added missed patch 2 and hence make it the series
> - appended tag to patch 7
> - new patch 1

-- 
With Best Regards,
Andy Shevchenko


