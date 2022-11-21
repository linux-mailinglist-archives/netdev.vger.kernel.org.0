Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D7F632C7D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 19:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiKUS7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 13:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiKUS73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 13:59:29 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACEB61B96;
        Mon, 21 Nov 2022 10:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669057168; x=1700593168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PdQeEPQACxdtbMm4JoWuf4jaaBJQPj9l5dZd+iPVQdo=;
  b=NzjW5/C97Dw8ZRmlwlBiP60Kwi+fMD6RsUXNSX3LO0/BjWi4+SqRjOvf
   XToJgfsXGOsaISKBq+b9ITGxfFcHT4ZetNH4OvW+6WFXPx5aHcuZbrNM4
   E6grQ53x8UZi3ue62UPwHv47gPq3vbgyxJJzfhfRBHCGwefKBGQxw9wgJ
   5Kb8pcitSUHtfllw8Nk/zIFZ6h9uaShBrCw9L2nWRI94OiNF+tIkBAP8F
   xW6gAJVZFLVda0D2CDqNbjKDXEHpoSE53Ki07tx1wte6ouIX2ui8vWUSO
   tdsgp3gfpx3GbzFLsC5bSp7CeMri5/NNpd1wdI4tHEgioFZc8SA39aar8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="312340354"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="312340354"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 10:59:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747025469"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="747025469"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2022 10:59:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oxC0k-00FQw3-2E;
        Mon, 21 Nov 2022 20:59:18 +0200
Date:   Mon, 21 Nov 2022 20:59:18 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Message-ID: <Y3vKhpTk9XCFYNLN@smile.fi.intel.com>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-15-alobakin@pm.me>
 <20221121175504.qwuoyditr4xl6oew@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121175504.qwuoyditr4xl6oew@skbuf>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 07:55:04PM +0200, Vladimir Oltean wrote:
> On Sat, Nov 19, 2022 at 11:09:28PM +0000, Alexander Lobakin wrote:

...

> > +EXPORT_SYMBOL_NS_GPL(felix_switch_ops, NET_DSA_MSCC_CORE);
> 
> What do we gain practically with the symbol namespacing?

I guess this wrap-up can possibly answer this:
https://lwn.net/Articles/760045/

-- 
With Best Regards,
Andy Shevchenko


