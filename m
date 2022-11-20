Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1189E631486
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 14:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKTNzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 08:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiKTNzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 08:55:31 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E1F12D1E;
        Sun, 20 Nov 2022 05:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668952530; x=1700488530;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6oz/VGdHbmnvKnjIBkMxIP78ltMPsharNqLSWuk0xuk=;
  b=UbQIeKvWEQLfUe0vxAZ7mxayS5abA8Llq2JtN1+ZtsNOIbRq3/Cfa77y
   iZqnQ3/vbaEFjhDwcUd98MvRVCnxvnmPmx3ngn+61fhHrynIqBY2jiLqw
   xrG6BampbB25emJzKicvBRXQ+uopz9NlL/k7bz3okXnJL9TXD3L4732o9
   LrKaeTncvnMzTqYywGEegvJ9sadycPhiXBMOXIDOhYm4918VAS7rhFEGz
   prjwA297TzWq9BUyr/GUzHOYqaoKmPf7k4bOqf4nH1TyTS9+k8xS0LzDT
   5h8rpxRRVBM/xd1OVIOkm0J41BD8HrirPudtcQ6xSmkx3zB8RJzxd8O/c
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10536"; a="296760503"
X-IronPort-AV: E=Sophos;i="5.96,179,1665471600"; 
   d="scan'208";a="296760503"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 05:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10536"; a="640740467"
X-IronPort-AV: E=Sophos;i="5.96,179,1665471600"; 
   d="scan'208";a="640740467"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 20 Nov 2022 05:55:24 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1owkn3-00Eqr5-1w;
        Sun, 20 Nov 2022 15:55:21 +0200
Date:   Sun, 20 Nov 2022 15:55:21 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
Subject: Re: [PATCH 11/18] platform/x86: int3472: fix object shared between
 several modules
Message-ID: <Y3oxyUx0UkWVjGvn@smile.fi.intel.com>
References: <20221119225650.1044591-1-alobakin@pm.me>
 <20221119225650.1044591-12-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119225650.1044591-12-alobakin@pm.me>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 19, 2022 at 11:08:17PM +0000, Alexander Lobakin wrote:
> common.o is linked to both intel_skl_int3472_{discrete,tps68470}:
> 
> > scripts/Makefile.build:252: ./drivers/platform/x86/intel/int3472/Makefile:
> > common.o is added to multiple modules: intel_skl_int3472_discrete
> > intel_skl_int3472_tps68470
> 
> Although both drivers share one Kconfig option
> (CONFIG_INTEL_SKL_INT3472), it's better to not link one object file
> into several modules (and/or vmlinux).
> Under certain circumstances, such can lead to the situation fixed by
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> 
> Introduce the new module, intel_skl_int3472_common, to provide the
> functions from common.o to both discrete and tps68470 drivers. This
> adds only 3 exports and doesn't provide any changes to the actual
> code.

...

> +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> +

Redundant blank line. You may put it to be last MODULE_*() in the file, if you
think it would be more visible.

>  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
>  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
>  MODULE_LICENSE("GPL v2");

...

> +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> +
>  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
>  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
>  MODULE_LICENSE("GPL v2");

Ditto. And the same to all your patches.

-- 
With Best Regards,
Andy Shevchenko


