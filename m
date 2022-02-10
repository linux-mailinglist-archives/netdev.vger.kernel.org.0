Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECCE4B0B9B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbiBJK6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:58:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbiBJK6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:58:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80508FDB;
        Thu, 10 Feb 2022 02:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644490719; x=1676026719;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=984OafvZJY4SOk4PBuH9Dox9/wKSXeq2BBG8ok7oy+Q=;
  b=lNh2i0hhvYDE025Qy9Q7348/WWyXHJpks8kHk4BhhaI86BcpVS+7yQ5S
   9IKCC7YTTY9oiI5uJxoALCsvSE1Flu1tMpDsXkM7yamJFPLC5zVLbqPIK
   2C0W5Hj0l+KS0uy/ErWThyaW8ydhiLFUgO3SWwzzlnR9AFA/tBA1Fx//C
   6QXmGEByrCq+bftcsIcREOXU9OOSelNEPr/h7OkXPOqPmkrHEcVqE+AKh
   6zhLqmTJbg1MQaxI4UBjB1vrN3/BVJhPv2pQqsJ+M2iuyhmEL2Ulm6MnB
   m+46oFxQROUQPw2QwebuKPl4WjS9KEMmdLF1mHIyM01J0TVF21NsEooFk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="233027079"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="233027079"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 02:58:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541560113"
Received: from asamsono-mobl1.ccr.corp.intel.com ([10.252.41.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 02:58:33 -0800
Date:   Thu, 10 Feb 2022 12:58:31 +0200 (EET)
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
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 10/13] net: wwan: t7xx: Introduce power
 management support
In-Reply-To: <20220114010627.21104-11-ricardo.martinez@linux.intel.com>
Message-ID: <e2d38f21-b1cf-4cbf-5cf5-3862846dee51@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-11-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Implements suspend, resumes, freeze, thaw, poweroff, and restore
> `dev_pm_ops` callbacks.
> 
> >From the host point of view, the t7xx driver is one entity. But, the
> device has several modules that need to be addressed in different ways
> during power management (PM) flows.
> The driver uses the term 'PM entities' to refer to the 2 DPMA and
> 2 CLDMA HW blocks that need to be managed during PM flows.
> When a dev_pm_ops function is called, the PM entities list is iterated
> and the matching function is called for each entry in the list.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---


>  	if (ret) {
>  		dev_err(dev, "Failed to allocate RX/TX SW resources: %d\n", ret);
> +		t7xx_dpmaif_pm_entity_release(dpmaif_ctrl);
>  		return NULL;

Print after release.


> +static int __t7xx_pci_pm_suspend(struct pci_dev *pdev)
> +{
> +	struct t7xx_pci_dev *t7xx_dev;
> +	struct md_pm_entity *entity;
> +	unsigned long wait_ret;
> +	enum t7xx_pm_id id;
> +	int ret = 0;
> +
> +	t7xx_dev = pci_get_drvdata(pdev);
> +	if (atomic_read(&t7xx_dev->md_pm_state) <= MTK_PM_INIT) {
> +		dev_err(&pdev->dev,
> +			"[PM] Exiting suspend, because handshake failure or in an exception\n");
> +		return -EFAULT;
> +	}
> +
> +	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
> +
> +	ret = t7xx_wait_pm_config(t7xx_dev);
> +	if (ret)
> +		return ret;

Do you need to rollback the iowrite?

> +	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_SUSPENDED);
> +	t7xx_pcie_mac_clear_int(t7xx_dev, SAP_RGU_INT);
> +	t7xx_dev->rgu_pci_irq_en = false;
> +
> +	list_for_each_entry(entity, &t7xx_dev->md_pm_entities, entity) {
> +		if (entity->suspend) {
> +			ret = entity->suspend(t7xx_dev, entity->entity_param);
> +			if (ret) {
> +				id = entity->id;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (ret) {
> +		dev_err(&pdev->dev, "[PM] Suspend error: %d, id: %d\n", ret, id);
> +
> +		list_for_each_entry(entity, &t7xx_dev->md_pm_entities, entity) {
> +			if (id == entity->id)
> +				break;
> +
> +			if (entity->resume)
> +				entity->resume(t7xx_dev, entity->entity_param);
> +		}
> +
> +		goto suspend_complete;

Suspend failure path(?) gotos to "suspend_complete"?

> +	}
> +
> +	reinit_completion(&t7xx_dev->pm_sr_ack);
> +	t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_SUSPEND_REQ);
> +	wait_ret = wait_for_completion_timeout(&t7xx_dev->pm_sr_ack,
> +					       msecs_to_jiffies(PM_ACK_TIMEOUT_MS));
> +	if (!wait_ret)
> +		dev_err(&pdev->dev, "[PM] Wait for device suspend ACK timeout-MD\n");
> +
> +	reinit_completion(&t7xx_dev->pm_sr_ack);
> +	t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_SUSPEND_REQ_AP);
> +	wait_ret = wait_for_completion_timeout(&t7xx_dev->pm_sr_ack,
> +					       msecs_to_jiffies(PM_ACK_TIMEOUT_MS));
> +	if (!wait_ret)
> +		dev_err(&pdev->dev, "[PM] Wait for device suspend ACK timeout-SAP\n");
> +
> +	list_for_each_entry(entity, &t7xx_dev->md_pm_entities, entity) {
> +		if (entity->suspend_late)
> +			entity->suspend_late(t7xx_dev, entity->entity_param);
> +	}
> +
> +suspend_complete:
> +	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
> +
> +	if (ret) {
> +		atomic_set(&t7xx_dev->md_pm_state, MTK_PM_RESUMED);
> +		t7xx_pcie_mac_set_int(t7xx_dev, SAP_RGU_INT);
> +	}
> +
> +	return ret;
> +}

Please check all paths in this function. I found enough oddities to not 
be able to convince myself I understood it all or found all the problems.
As if, e.g., an ok path return would be missing above misnamed 
suspend_complete label (but then there's if (ret) below it which is kind 
of counterargument against my reasoning).

I've no comments on patches 11-13.

-- 
 i.

