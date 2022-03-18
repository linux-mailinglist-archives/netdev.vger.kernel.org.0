Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A991B4DE4A4
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 00:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241570AbiCRXvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 19:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241564AbiCRXvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 19:51:00 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C341314924F;
        Fri, 18 Mar 2022 16:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647647380; x=1679183380;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FvD98hz50M7JnRHfkfTWPNB0aCDVABKuZeTx5d5YSEg=;
  b=bfvRbW9nNqhC8kSVbzIrUFZiPLISrZO3Kty7kaXVOlqLfTWt9l6Fp6CZ
   coPRtxxyam04nzNyF6RYx2Kv0ZO1zQJrbgtHmjoC9zRrNdCUnUGCv7RdN
   EqHDsv7k1cKfyObk3fdRYA8mt2ZpTi+sIjr/6gNNBRZtHhDWoGrF7pfhT
   tZRVYLud/gW5TCtI0MbqvQLOjITVz7t2cLz8QWMYwVIYNx8y9g0MqhJhM
   nfaSF20NMJO1o2oWqeuuNo9ExT4X7bFSS6MNbjLc66cVLUZ4OgUbstnIs
   qrPxrrBqFMo00A0kD00JmIh7SRdajFxllWPPGMJdnOljJCdcDByAAy7el
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="239412595"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="239412595"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 16:49:40 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="691498551"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.164.23]) ([10.212.164.23])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 16:49:39 -0700
Message-ID: <a43666ad-4216-29e9-762d-ade19fd77620@linux.intel.com>
Date:   Fri, 18 Mar 2022 16:49:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v5 12/13] net: wwan: t7xx: Device deep sleep
 lock/unlock
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
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
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-13-ricardo.martinez@linux.intel.com>
 <1aca9e1f-8b6b-d3e2-d3ff-1bf37abe63f5@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <1aca9e1f-8b6b-d3e2-d3ff-1bf37abe63f5@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/2022 2:21 AM, Ilpo Järvinen wrote:
> On Wed, 23 Feb 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Introduce the mechanism to lock/unlock the device 'deep sleep' mode.
>> When the PCIe link state is L1.2 or L2, the host side still can keep
>> the device is in D0 state from the host side point of view. At the same
>> time, if the device's 'deep sleep' mode is unlocked, the device will
>> go to 'deep sleep' while it is still in D0 state on the host side.
>>
>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>> ---
...
>> +int t7xx_pci_sleep_disable_complete(struct t7xx_pci_dev *t7xx_dev)
>> +{
>> +	struct device *dev = &t7xx_dev->pdev->dev;
>> +	int ret;
>> +
>> +	ret = wait_for_completion_timeout(&t7xx_dev->sleep_lock_acquire,
>> +					  msecs_to_jiffies(PM_SLEEP_DIS_TIMEOUT_MS));
>> +	if (!ret)
>> +		dev_err_ratelimited(dev, "Resource wait complete timed out\n");
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * t7xx_pci_disable_sleep() - Disable deep sleep capability.
>> + * @t7xx_dev: MTK device.
>> + *
>> + * Lock the deep sleep capability, note that the device can still go into deep sleep
>> + * state while device is in D0 state, from the host's point-of-view.
>> + *
>> + * If device is in deep sleep state, wake up the device and disable deep sleep capability.
>> + */
>> +void t7xx_pci_disable_sleep(struct t7xx_pci_dev *t7xx_dev)
>> +{
>> +	unsigned long flags;
>> +
>> +	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {
>> +		atomic_inc(&t7xx_dev->sleep_disable_count);
>> +		complete_all(&t7xx_dev->sleep_lock_acquire);
>> +		return;
>> +	}
>> +
>> +	spin_lock_irqsave(&t7xx_dev->md_pm_lock, flags);
>> +	if (atomic_inc_return(&t7xx_dev->sleep_disable_count) == 1) {
>> +		u32 deep_sleep_enabled;
>> +
>> +		reinit_completion(&t7xx_dev->sleep_lock_acquire);
> You might want to check that there's a mechanism that prevents this
> racing with wait_for_completion_timeout() in t7xx_pci_sleep_disable_complete().
>
> I couldn't prove it myself but there are probably aspect in the PM side of
> things I wasn't able to take fully into account (that is, which call
> paths are not possible to occur).
Those functions are called in the following order:
1.- t7xx_pci_disable_sleep()
2.- t7xx_pci_sleep_disable_complete()
3.- t7xx_pci_enable_sleep()

That sequence and md_pm_lock protect against a race condition between 
wait_for_completion_timeout() and  reinit_completion().
On the other hand, there could be a race condition between 
t7xx_pci_disable_sleep() and t7xx_pci_enable_sleep() which may cause 
sleep to get enabled while one thread expects it to be disabled.
The fix would be to protect sleep_disable_count with md_pm_lock, then 
sleep_disable_count doesn't need to be declared as atomic.
The next version will include cleanup in this area.
>> +		t7xx_dev_set_sleep_capability(t7xx_dev, false);
>> +
>> +		deep_sleep_enabled = ioread32(IREG_BASE(t7xx_dev) + T7XX_PCIE_RESOURCE_STATUS);
>> +		deep_sleep_enabled &= T7XX_PCIE_RESOURCE_STS_MSK;
>> +		if (deep_sleep_enabled) {
>> +			spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
>> +			complete_all(&t7xx_dev->sleep_lock_acquire);
>> +			return;
>> +		}
>> +
>> +		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DS_LOCK);
>> +	}
>> +	spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
>> +}
>
