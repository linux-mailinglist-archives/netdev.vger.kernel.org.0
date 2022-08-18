Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA6A5986A1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343930AbiHRO6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343920AbiHRO6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:58:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DC32657F
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660834710; x=1692370710;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=PYrOGzpKb5vjRGsMISCHWSqnvhZNHlqoAEj8dYNd2jE=;
  b=JHr4IpJ1LwMxuXCTZqVsWKKHVknP5Qt6oCEXmW7/rVngOeUc1TAl7l+j
   UHCJclQa51U3sV4wAkpF5B+fSF/IoOhSNuEfbHi5Icbo4zym3MFKj9p5t
   +DIk2aHl+FjVo0hYYc9e6RkZvLgyL0McuVwumMoUVST98DoD8R7/ruq/m
   aCtjGagn3dGKqsVbXpmTl7gyDJvWLLM9UdVQf7ZzPeH9yQktjBOBLXxvZ
   9HPK8Zz3ywk3EDCsJDpzQZirwdbrRVX++HgadZgGLRVUvhy+4kGep1PVT
   jOxJrAiEBcidNFPVed3qE/bGt9p4X0930lfGk7LmyoacGVa3PyP+0teJF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="272543360"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="272543360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668138304"
Received: from dursu-mobl1.ger.corp.intel.com ([10.249.42.244])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 07:58:26 -0700
Date:   Thu, 18 Aug 2022 17:58:24 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     m.chetan.kumar@intel.com
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com, Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: Re: [PATCH net-next 3/5] net: wwan: t7xx: PCIe reset rescan
In-Reply-To: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
Message-ID: <56bd12a1-234e-9e92-8be4-72fff69e53bd@linux.intel.com>
References: <20220816042353.2416956-1-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> PCI rescan module implements "rescan work queue". In firmware flashing
> or coredump collection procedure WWAN device is programmed to boot in
> fastboot mode and a work item is scheduled for removal & detection.
> The WWAN device is reset using APCI call as part driver removal flow.
> Work queue rescans pci bus at fixed interval for device detection,
> later when device is detect work queue exits.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> ---

> +       bool                    hp_enable;

Never written to.

> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
> new file mode 100644
> index 000000000000..045777d8a843
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
> @@ -0,0 +1,117 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, MediaTek Inc.
> + * Copyright (c) 2021-2022, Intel Corporation.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ":t7xx:%s: " fmt, __func__
> +#define dev_fmt(fmt) "t7xx: " fmt
> +
> +#include <linux/delay.h>
> +#include <linux/pci.h>
> +#include <linux/spinlock.h>
> +#include <linux/workqueue.h>
> +
> +#include "t7xx_pci.h"
> +#include "t7xx_pci_rescan.h"
> +
> +static struct remove_rescan_context g_mtk_rescan_context;

Any particular reason for this name?

> +void t7xx_pci_dev_rescan(void)
> +{
> +	struct pci_bus *b = NULL;
> +
> +	pci_lock_rescan_remove();
> +	while ((b = pci_find_next_bus(b)))
> +		pci_rescan_bus(b);
> +
> +	pci_unlock_rescan_remove();

I'd remove the empty line to keep the critical sections grouped together. 

> +}
> +
> +void t7xx_rescan_done(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +	if (g_mtk_rescan_context.rescan_done == 0) {
> +		pr_debug("this is a rescan probe\n");
> +		g_mtk_rescan_context.rescan_done = 1;
> +	} else {
> +		pr_debug("this is a init probe\n");
> +	}
> +	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +}
> +
> +static void t7xx_remove_rescan(struct work_struct *work)
> +{
> +	struct pci_dev *pdev;
> +	int num_retries = RESCAN_RETRIES;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +	g_mtk_rescan_context.rescan_done = 0;
> +	pdev = g_mtk_rescan_context.dev;
> +	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +
> +	if (pdev) {
> +		pci_stop_and_remove_bus_device_locked(pdev);
> +		pr_debug("start remove and rescan flow\n");
> +	}
> +
> +	do {
> +		t7xx_pci_dev_rescan();
> +		spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +		if (g_mtk_rescan_context.rescan_done) {
> +			spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +			break;
> +		}
> +
> +		spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);

Ditto.

> +		msleep(DELAY_RESCAN_MTIME);
> +	} while (num_retries--);
> +}
> +
> +void t7xx_rescan_queue_work(struct pci_dev *pdev)
> +{
> +	unsigned long flags;
> +
> +	dev_info(&pdev->dev, "start queue_mtk_rescan_work\n");
> +	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +	if (!g_mtk_rescan_context.rescan_done) {
> +		dev_err(&pdev->dev, "rescan failed because last rescan undone\n");

The meaning of the message is hard to understand.

> +		spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +		return;
> +	}
> +
> +	g_mtk_rescan_context.dev = pdev;
> +	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);

Crit section newlines.

> +	queue_work(g_mtk_rescan_context.pcie_rescan_wq, &g_mtk_rescan_context.service_task);
> +}
> +
> +int t7xx_rescan_init(void)
> +{
> +	spin_lock_init(&g_mtk_rescan_context.dev_lock);
> +	g_mtk_rescan_context.rescan_done = 1;
> +	g_mtk_rescan_context.dev = NULL;
> +	g_mtk_rescan_context.pcie_rescan_wq = create_singlethread_workqueue(MTK_RESCAN_WQ);
> +	if (!g_mtk_rescan_context.pcie_rescan_wq) {
> +		pr_err("Failed to create workqueue: %s\n", MTK_RESCAN_WQ);
> +		return -ENOMEM;
> +	}
> +
> +	INIT_WORK(&g_mtk_rescan_context.service_task, t7xx_remove_rescan);
> +
> +	return 0;
> +}
> +
> +void t7xx_rescan_deinit(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&g_mtk_rescan_context.dev_lock, flags);
> +	g_mtk_rescan_context.rescan_done = 0;
> +	g_mtk_rescan_context.dev = NULL;
> +	spin_unlock_irqrestore(&g_mtk_rescan_context.dev_lock, flags);
> +	cancel_work_sync(&g_mtk_rescan_context.service_task);
> +	destroy_workqueue(g_mtk_rescan_context.pcie_rescan_wq);
> +}

In general, I felt this whole file was very heavy to read compared with 
the other parts of t7xx code. Maybe it will get better if 
g_mtk_rescan_context becomes shorter and re-newlining is done to better 
indicate the critical sections but we'll see.

> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.h b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
> new file mode 100644
> index 000000000000..de4ca1363bb0
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0-only
> + *
> + * Copyright (c) 2021, MediaTek Inc.
> + * Copyright (c) 2021-2022, Intel Corporation.
> + */
> +
> +#ifndef __T7XX_PCI_RESCAN_H__
> +#define __T7XX_PCI_RESCAN_H__
> +
> +#define MTK_RESCAN_WQ "mtk_rescan_wq"
> +
> +#define DELAY_RESCAN_MTIME 1000
> +#define RESCAN_RETRIES 35
> +
> +struct remove_rescan_context {
> +	struct work_struct	 service_task;

Extra whitespace.

> +	struct workqueue_struct *pcie_rescan_wq;
> +	spinlock_t		dev_lock; /* protects device */

Perhaps use a tab before the comment instead to make some room.

> +	struct pci_dev		*dev;
> +	int			rescan_done;
> +};


-- 
 i.

