Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48964D4469
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241173AbiCJKWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 05:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbiCJKWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:22:41 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B63513DE3C;
        Thu, 10 Mar 2022 02:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646907700; x=1678443700;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=sEdEVTS+mm9I/4yqFHkcIpZLo+BMD4jhu7Q5AQwgU7E=;
  b=MbTcZxtWHkeh592o5TR00uZTTmY0fvV47T3DY8i4LBqs7uzufJDPyofN
   1/7LW59+0kZ8rlFLW0LK4DW+9QxvnpmR6USjsw+2LE5onr6sXkK5IxEck
   pgvpzfIcBqgQw2LbmYdzrWPx4xQe9tbslB1ihYL7QjTXUNDohErSXfy9b
   kfWulddOZT0YjECiXIEnV7If2Yks/55u28x1rXcUWWLsAelnH0kZZHER0
   xpp1FtNOzwJyNXcs6DXEsBDc7aK23TXoH1ml+nuyfNddsft2IjYlHgWFr
   jUwgi4xzRsIMuD7CahR5u+UhU5gKQBhsUxxp/5igQHdaNDegDFrkDkqkV
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="254951561"
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="254951561"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 02:21:39 -0800
X-IronPort-AV: E=Sophos;i="5.90,170,1643702400"; 
   d="scan'208";a="554581194"
Received: from mborg-mobl.ger.corp.intel.com ([10.252.33.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 02:21:34 -0800
Date:   Thu, 10 Mar 2022 12:21:31 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v5 12/13] net: wwan: t7xx: Device deep sleep
 lock/unlock
In-Reply-To: <20220223223326.28021-13-ricardo.martinez@linux.intel.com>
Message-ID: <1aca9e1f-8b6b-d3e2-d3ff-1bf37abe63f5@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-13-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Introduce the mechanism to lock/unlock the device 'deep sleep' mode.
> When the PCIe link state is L1.2 or L2, the host side still can keep
> the device is in D0 state from the host side point of view. At the same
> time, if the device's 'deep sleep' mode is unlocked, the device will
> go to 'deep sleep' while it is still in D0 state on the host side.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---



> +int t7xx_pci_sleep_disable_complete(struct t7xx_pci_dev *t7xx_dev)
> +{
> +	struct device *dev = &t7xx_dev->pdev->dev;
> +	int ret;
> +
> +	ret = wait_for_completion_timeout(&t7xx_dev->sleep_lock_acquire,
> +					  msecs_to_jiffies(PM_SLEEP_DIS_TIMEOUT_MS));
> +	if (!ret)
> +		dev_err_ratelimited(dev, "Resource wait complete timed out\n");
> +
> +	return ret;
> +}
> +
> +/**
> + * t7xx_pci_disable_sleep() - Disable deep sleep capability.
> + * @t7xx_dev: MTK device.
> + *
> + * Lock the deep sleep capability, note that the device can still go into deep sleep
> + * state while device is in D0 state, from the host's point-of-view.
> + *
> + * If device is in deep sleep state, wake up the device and disable deep sleep capability.
> + */
> +void t7xx_pci_disable_sleep(struct t7xx_pci_dev *t7xx_dev)
> +{
> +	unsigned long flags;
> +
> +	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {
> +		atomic_inc(&t7xx_dev->sleep_disable_count);
> +		complete_all(&t7xx_dev->sleep_lock_acquire);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&t7xx_dev->md_pm_lock, flags);
> +	if (atomic_inc_return(&t7xx_dev->sleep_disable_count) == 1) {
> +		u32 deep_sleep_enabled;
> +
> +		reinit_completion(&t7xx_dev->sleep_lock_acquire);

You might want to check that there's a mechanism that prevents this 
racing with wait_for_completion_timeout() in t7xx_pci_sleep_disable_complete().

I couldn't prove it myself but there are probably aspect in the PM side of 
things I wasn't able to take fully into account (that is, which call 
paths are not possible to occur).

> +		t7xx_dev_set_sleep_capability(t7xx_dev, false);
> +
> +		deep_sleep_enabled = ioread32(IREG_BASE(t7xx_dev) + T7XX_PCIE_RESOURCE_STATUS);
> +		deep_sleep_enabled &= T7XX_PCIE_RESOURCE_STS_MSK;
> +		if (deep_sleep_enabled) {
> +			spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
> +			complete_all(&t7xx_dev->sleep_lock_acquire);
> +			return;
> +		}
> +
> +		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DS_LOCK);
> +	}
> +	spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
> +}


-- 
 i.

