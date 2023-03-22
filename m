Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8AC6C4EF8
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCVPHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjCVPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:07:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DF564870;
        Wed, 22 Mar 2023 08:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679497649; x=1711033649;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=+g6QZHtnNSRYZINFv7vVc+UKiFYDsZ4oIV9RAP1BFfo=;
  b=FgHopbNfz/ZVVZc/VdRZiuhrFS/Sl2AE/JoTiEydIaPYnyZJBpCIJlFm
   /4yw/IGeoFYabowMsBwNLSuAmWuJj+axVEg8C4mXwIvMiKx1taTAwWUpq
   JiGP8nYaoM9hxviNXWj7llkcgr7/l9LIAH9yKxuj2kh3g/3y4KTjcPq0B
   auWmSbi9n4PVCGQzPDo2P9Vj+KXTvKDRPtVcIFMudLIaI+SBEt0aA1Ofk
   /BumRoheBKZO/klg/C70xv+gHeFPak+5LtIQ+G8CWncG9eYF4WnReQwM9
   C+tilnbI3Cx+JDfgsFISfJBXf4L1CPATLT9shfQFboTgwoouhs99vtcFz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="337959357"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="337959357"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 08:07:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="825433315"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="825433315"
Received: from dpapgher-mobl1.ger.corp.intel.com ([10.249.45.216])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 08:07:11 -0700
Date:   Wed, 22 Mar 2023 17:07:08 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Tianfei Zhang <tianfei.zhang@intel.com>
cc:     richardcochran@gmail.com, Netdev <netdev@vger.kernel.org>,
        linux-fpga@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vinicius.gomes@intel.com, pierre-louis.bossart@linux.intel.com,
        marpagan@redhat.com, Russ Weight <russell.h.weight@intel.com>,
        matthew.gerlach@linux.intel.com, nico@fluxnic.net,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
In-Reply-To: <20230322143547.233250-1-tianfei.zhang@intel.com>
Message-ID: <e2684d7c-903f-2a7e-4bf3-ad2edd485e60@linux.intel.com>
References: <20230322143547.233250-1-tianfei.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023, Tianfei Zhang wrote:

> Adding a DFL (Device Feature List) device driver of ToD device for
> Intel FPGA cards.
> 
> The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> as PTP Hardware clock(PHC) device to the Linux PTP stack to synchronize
> the system clock to its ToD information using phc2sys utility of the
> Linux PTP stack. The DFL is a hardware List within FPGA, which defines
> a linked list of feature headers within the device MMIO space to provide
> an extensible way of adding subdevice features.
> 
> Signed-off-by: Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
> Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>
> 
> ---
> v2:
> - handle NULL for ptp_clock_register().
> - use readl_poll_timeout_atomic() instead of readl_poll_timeout(), and
>   change the interval timeout to 10us.
> - fix the uninitialized variable.
> ---
>  MAINTAINERS               |   7 +
>  drivers/ptp/Kconfig       |  13 ++
>  drivers/ptp/Makefile      |   1 +
>  drivers/ptp/ptp_dfl_tod.c | 333 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 354 insertions(+)
>  create mode 100644 drivers/ptp/ptp_dfl_tod.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d8ebab595b2a..3fd603369464 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15623,6 +15623,13 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/ptp/ptp_ocp.c
>  
> +INTEL PTP DFL ToD DRIVER
> +M:	Tianfei Zhang <tianfei.zhang@intel.com>
> +L:	linux-fpga@vger.kernel.org
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/ptp/ptp_dfl_tod.c
> +
>  OPENCORES I2C BUS DRIVER
>  M:	Peter Korsgaard <peter@korsgaard.com>
>  M:	Andrew Lunn <andrew@lunn.ch>
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index fe4971b65c64..e0d6f136ee46 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -186,4 +186,17 @@ config PTP_1588_CLOCK_OCP
>  
>  	  More information is available at http://www.timingcard.com/
>  
> +config PTP_DFL_TOD
> +	tristate "FPGA DFL ToD Driver"
> +	depends on FPGA_DFL

Should this also have depends on PTP_1588_CLOCK?


-- 
 i.

