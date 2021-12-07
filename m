Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC84646BA90
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhLGMD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:03:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:5296 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhLGMDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 07:03:53 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217585365"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="217585365"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 04:00:23 -0800
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="563492029"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 04:00:18 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1muZ7u-003DBt-2B;
        Tue, 07 Dec 2021 13:59:18 +0200
Date:   Tue, 7 Dec 2021 13:59:17 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Subject: Re: [PATCH net-next v3 06/12] net: wwan: t7xx: Data path HW layer
Message-ID: <Ya9MlTpZ8Var/JMy@smile.fi.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-7-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207024711.2765-7-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 07:47:05PM -0700, Ricardo Martinez wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HW layer provides HW abstraction
> for the upper layer (DPMAIF HIF). It implements functions to do the HW
> configuration, TX/RX control and interrupt handling.

...

> +	ret = readx_poll_timeout_atomic(ioread32, hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0,
> +					value, (value & ul_intr_enable) != ul_intr_enable, 0,
> +					DPMAIF_CHECK_INIT_TIMEOUT_US);
> +	if (ret)
> +		return ret;

...

> +	ret = readx_poll_timeout_atomic(ioread32, hw_info->pcie_base + DPMAIF_AO_UL_APDL_L2TIMR0,
> +					value, (value & ul_intr_enable) != ul_intr_enable, 0,
> +					DPMAIF_CHECK_INIT_TIMEOUT_US);
> +	if (ret)
> +		return ret;

...

> +	ret = readx_poll_timeout_atomic(ioread32, hw_info->pcie_base + DPMAIF_AO_UL_AP_L2TIMR0,
> +					value, (value & ul_int_que_done) == ul_int_que_done, 0,
> +					DPMAIF_CHECK_TIMEOUT_US);
> +	if (ret)
> +		dev_err(dpmaif_ctrl->dev,
> +			"Could not mask the UL interrupt. DPMAIF_AO_UL_AP_L2TIMR0 is 0x%x\n",
> +			value);

I would recommend to add a small patch that extends iopoll.h by ioreadXX() variants.

Or as alternative just define it here at the top of the file (or in one of the
header if it's used more than in one module) so we may move it to the iopoll.h
in the future:


#define ioread32_poll_timeout_atomic(addr, val, cond, delay_us, timeout_us) \
	readx_poll_timeout_atomic(ioread32, addr, val, cond, delay_us, timeout_us)


-- 
With Best Regards,
Andy Shevchenko


