Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4644333D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhKBQm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:42:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:49962 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhKBQm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:42:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="218210509"
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="218210509"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 08:46:58 -0700
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="667164066"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 08:46:52 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mhvzf-0033E0-QA;
        Tue, 02 Nov 2021 17:46:35 +0200
Date:   Tue, 2 Nov 2021 17:46:35 +0200
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
Subject: Re: [PATCH v2 03/14] net: wwan: t7xx: Add core components
Message-ID: <YYFdW5IWdbyKVF/u@smile.fi.intel.com>
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-4-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101035635.26999-4-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 08:56:24PM -0700, Ricardo Martinez wrote:
> From: Haijun Lio <haijun.liu@mediatek.com>
> 
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
> 
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.

I will assume that the comments given against previous patch will be applied
to this and the rest of the patches where it makes sense or appropriate.

Below only new comments.

...

> +config MTK_T7XX
> +	tristate "MediaTek PCIe 5G WWAN modem T7XX device"

T77xx is easier to read by human beings.

> +	depends on PCI

...

> +struct ccci_header {
> +	/* do not assume data[1] is data length in rx */

To understand this comment you need to elaborate the content of the header.

> +	u32 data[2];
> +	u32 status;
> +	u32 reserved;
> +};

...

> +#define CCCI_HEADER_NO_DATA	0xffffffff

Is this internal value to Linux or something which is given by hardware?

...

> +/* Modem exception check identification number */
> +#define MD_EX_CHK_ID		0x45584350
> +/* Modem exception check acknowledge identification number */
> +#define MD_EX_CHK_ACK_ID	0x45524543

To me both looks like fourcc. Can you add their ASCII values into comments?

...

> +	/* Use 1*4 bits to avoid low power bits*/

What does "1*4 bits" mean?

> +	iowrite32(L1_1_DISABLE_BIT(1) | L1_2_DISABLE_BIT(1),
> +		  IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);

...

> +int mtk_pci_mhccif_isr(struct mtk_pci_dev *mtk_dev)
> +{
> +	struct md_sys_info *md_info;
> +	struct ccci_fsm_ctl *ctl;
> +	struct mtk_modem *md;
> +	unsigned int int_sta;
> +	unsigned long flags;
> +	u32 mask;
> +
> +	md = mtk_dev->md;
> +	ctl = fsm_get_entry();
> +	if (!ctl) {

> +		dev_err(&mtk_dev->pdev->dev,
> +			"process MHCCIF interrupt before modem monitor was initialized\n");

Can this potentially flood the logs? If so, needs to be rate limited.

> +		return -EINVAL;
> +	}

> +	md_info = md->md_info;

> +	spin_lock_irqsave(&md_info->exp_spinlock, flags);

Can it be called outside of IRQ context?

> +	int_sta = get_interrupt_status(mtk_dev);
> +	md_info->exp_id |= int_sta;
> +
> +	if (md_info->exp_id & D2H_INT_PORT_ENUM) {
> +		md_info->exp_id &= ~D2H_INT_PORT_ENUM;
> +		if (ctl->curr_state == CCCI_FSM_INIT ||
> +		    ctl->curr_state == CCCI_FSM_PRE_START ||
> +		    ctl->curr_state == CCCI_FSM_STOPPED)
> +			ccci_fsm_recv_md_interrupt(MD_IRQ_PORT_ENUM);
> +	}
> +
> +	if (md_info->exp_id & D2H_INT_EXCEPTION_INIT) {
> +		if (ctl->md_state == MD_STATE_INVALID ||
> +		    ctl->md_state == MD_STATE_WAITING_FOR_HS1 ||
> +		    ctl->md_state == MD_STATE_WAITING_FOR_HS2 ||
> +		    ctl->md_state == MD_STATE_READY) {
> +			md_info->exp_id &= ~D2H_INT_EXCEPTION_INIT;
> +			ccci_fsm_recv_md_interrupt(MD_IRQ_CCIF_EX);
> +		}
> +	} else if (ctl->md_state == MD_STATE_WAITING_FOR_HS1) {
> +		/* start handshake if MD not assert */
> +		mask = mhccif_mask_get(mtk_dev);
> +		if ((md_info->exp_id & D2H_INT_ASYNC_MD_HK) && !(mask & D2H_INT_ASYNC_MD_HK)) {
> +			md_info->exp_id &= ~D2H_INT_ASYNC_MD_HK;
> +			queue_work(md->handshake_wq, &md->handshake_work);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&md_info->exp_spinlock, flags);
> +
> +	return 0;
> +}

...

> +static int mtk_acpi_reset(struct mtk_pci_dev *mtk_dev, char *fn_name)
> +{
> +#ifdef CONFIG_ACPI
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	acpi_status acpi_ret;
> +	struct device *dev;
> +	acpi_handle handle;
> +
> +	dev = &mtk_dev->pdev->dev;

> +	if (acpi_disabled) {
> +		dev_err(dev, "acpi function isn't enabled\n");
> +		return -EFAULT;
> +	}

Why this check?

> +	handle = ACPI_HANDLE(dev);
> +	if (!handle) {
> +		dev_err(dev, "acpi handle isn't found\n");

acpi --> ACPI

> +		return -EFAULT;
> +	}
> +
> +	if (!acpi_has_method(handle, fn_name)) {
> +		dev_err(dev, "%s method isn't found\n", fn_name);
> +		return -EFAULT;
> +	}
> +
> +	acpi_ret = acpi_evaluate_object(handle, fn_name, NULL, &buffer);
> +	if (ACPI_FAILURE(acpi_ret)) {
> +		dev_err(dev, "%s method fail: %s\n", fn_name, acpi_format_exception(acpi_ret));
> +		return -EFAULT;
> +	}
> +#endif
> +	return 0;
> +}

...

> +	msleep(RGU_RESET_DELAY_US);

DELAY in microseconds while msleep() takes milliseconds.
Something is wrong here.

Also, delays such as 10ms+ should be explained. Esp. when they are
in the threaded IRQ handler.

...

> +void mtk_md_exception_handshake(struct mtk_modem *md)
> +{
> +	struct mtk_pci_dev *mtk_dev;

	struct device *dev = &mtk_dev->pdev->dev;

will help a lot to make below code cleaner.

> +	int ret;

> +	mtk_dev = md->mtk_dev;
> +	md_exception(md, HIF_EX_INIT);
> +	ret = wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_INIT_DONE);
> +
> +	if (ret)
> +		dev_err(&mtk_dev->pdev->dev, "EX CCIF HS timeout, RCH 0x%lx\n",
> +			D2H_INT_EXCEPTION_INIT_DONE);
> +
> +	md_exception(md, HIF_EX_INIT_DONE);
> +	ret = wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_CLEARQ_DONE);
> +	if (ret)
> +		dev_err(&mtk_dev->pdev->dev, "EX CCIF HS timeout, RCH 0x%lx\n",
> +			D2H_INT_EXCEPTION_CLEARQ_DONE);
> +
> +	md_exception(md, HIF_EX_CLEARQ_DONE);
> +	ret = wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_ALLQ_RESET);
> +	if (ret)
> +		dev_err(&mtk_dev->pdev->dev, "EX CCIF HS timeout, RCH 0x%lx\n",
> +			D2H_INT_EXCEPTION_ALLQ_RESET);
> +
> +	md_exception(md, HIF_EX_ALLQ_RESET);
> +}

...

> +err_fsm_init:
> +	ccci_fsm_uninit();
> +err_alloc:
> +	destroy_workqueue(md->handshake_wq);

Labels should explain what will be done when goto, and not what was done.

...

> +/* Modem feature query identification number */
> +#define MD_FEATURE_QUERY_ID	0x49434343

All fourcc:s should be represented as ASCII in the comments.

...

> +#ifndef __T7XX_MONITOR_H__
> +#define __T7XX_MONITOR_H__

> +#include <linux/sched.h>

Who is the user of this?

...

> +static int mtk_request_irq(struct pci_dev *pdev)
> +{
> +	struct mtk_pci_dev *mtk_dev;
> +	int ret, i;
> +
> +	mtk_dev = pci_get_drvdata(pdev);
> +
> +	for (i = 0; i < EXT_INT_NUM; i++) {
> +		const char *irq_descr;
> +		int irq_vec;
> +
> +		if (!mtk_dev->intr_handler[i])
> +			continue;
> +
> +		irq_descr = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_%d",
> +					   dev_driver_string(&pdev->dev), i);
> +		if (!irq_descr)

Resource leak is here.

> +			return -ENOMEM;
> +
> +		irq_vec = pci_irq_vector(pdev, i);
> +		ret = request_threaded_irq(irq_vec, mtk_dev->intr_handler[i],
> +					   mtk_dev->intr_thread[i], 0, irq_descr,
> +					   mtk_dev->callback_param[i]);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Failed to request_irq: %d, int: %d, ret: %d\n",
> +				irq_vec, i, ret);
> +			while (i--) {
> +				if (!mtk_dev->intr_handler[i])
> +					continue;
> +
> +				free_irq(pci_irq_vector(pdev, i), mtk_dev->callback_param[i]);
> +			}
> +
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}

...

> +	ret = pci_alloc_irq_vectors(mtk_dev->pdev, EXT_INT_NUM, EXT_INT_NUM, PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		dev_err(&mtk_dev->pdev->dev, "Failed to allocate MSI-X entry, errno: %d\n", ret);

', errno' is redundant.

> +		return ret;
> +	}
> +
> +	ret = mtk_request_irq(mtk_dev->pdev);
> +	if (ret) {
> +		pci_free_irq_vectors(mtk_dev->pdev);
> +		return ret;
> +	}
> +
> +	/* Set MSIX merge config */
> +	mtk_pcie_mac_msix_cfg(mtk_dev, EXT_INT_NUM);
> +	return 0;
> +}

...

> +	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));

This API is absoleted, use corresponding DMA API directly.
On top of that, 64-bit setting never fail...

> +	if (ret) {

> +		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			dev_err(&pdev->dev, "Could not set PCI DMA mask, err: %d\n", ret);
> +			return ret;
> +		}

...so this attempt is almost a dead code.

> +	}

...

> +	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> +	if (ret) {
> +		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
> +		if (ret) {
> +			dev_err(&pdev->dev, "Could not set consistent PCI DMA mask, err: %d\n",
> +				ret);
> +			return ret;
> +		}
> +	}

Ditto.

...

> +	mtk_pcie_mac_set_int(mtk_dev, MHCCIF_INT);
> +	mtk_pcie_mac_interrupts_en(mtk_dev);

> +	pci_set_master(pdev);

It's too late for this call. Are you sure it's needed here? Why?

> +
> +	return 0;

...

> +err:

Meaningless label name. Try your best to make it better.

> +	ccci_skb_pool_free(&mtk_dev->pools);

Does it free IRQ handlers? If so, the function naming is not good enough.

> +	return ret;

...

> +static int __init mtk_pci_init(void)
> +{
> +	return pci_register_driver(&mtk_pci_driver);
> +}
> +module_init(mtk_pci_init);
> +
> +static void __exit mtk_pci_cleanup(void)
> +{
> +	pci_unregister_driver(&mtk_pci_driver);
> +}
> +module_exit(mtk_pci_cleanup);

NIH module_pci_driver().

...

> + * @pdev: pci device

pci --> PCI

...

> +#include <linux/io-64-nonatomic-lo-hi.h>

> +#include <linux/msi.h>

Wondering what the APIs you are using from there.

...

> +	for (i = 0; i < ATR_TABLE_NUM_PER_ATR; i++) {
> +		offset = (ATR_PORT_OFFSET * port) + (ATR_TABLE_OFFSET * i);

Too many parentheses.

> +		/* Disable table by SRC_ADDR */
> +		reg = pbase + ATR_PCIE_WIN0_T0_ATR_PARAM_SRC_ADDR + offset;
> +		iowrite64(0, reg);
> +	}

...

> +		pos = ffs(lower_32_bits(cfg->size));
> +		if (!pos)
> +			pos = ffs(upper_32_bits(cfg->size)) + 32;

NIH __ffs64() ?

...

> +static void mtk_pcie_mac_enable_disable_int(struct mtk_pci_dev *mtk_dev, bool enable)
> +{
> +	u32 value;
> +
> +	value = ioread32(IREG_BASE(mtk_dev) + ISTAT_HST_CTRL);

Either add...

> +	if (enable)
> +		value &= ~ISTAT_HST_CTRL_DIS;
> +	else
> +		value |= ISTAT_HST_CTRL_DIS;

> +

...or remove blank line for the sake of consistency.

> +	iowrite32(value, IREG_BASE(mtk_dev) + ISTAT_HST_CTRL);
> +}

...

> +#include <linux/bitops.h>

Who is the user of this?

...

> +#ifndef __T7XX_REG_H__
> +#define __T7XX_REG_H__
> +
> +#include <linux/bits.h>

...

> +#define EXP_BAR0				0x0c
> +#define EXP_BAR2				0x04
> +#define EXP_BAR4				0x0c

BAR0 and BAR4 have the same value. Either explain or fix accordingly.

...

> +#define MSIX_MSK_SET_ALL			GENMASK(31, 24)

Missed blank line ?

> +enum pcie_int {
> +	DPMAIF_INT = 0,
> +	CLDMA0_INT,
> +	CLDMA1_INT,
> +	CLDMA2_INT,
> +	MHCCIF_INT,
> +	DPMAIF2_INT,
> +	SAP_RGU_INT,
> +	CLDMA3_INT,
> +};

...

> +static struct sk_buff *alloc_skb_from_pool(struct skb_pools *pools, size_t size)
> +{
> +	if (size > MTK_SKB_4K)
> +		return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_64k);
> +	else if (size > MTK_SKB_16)
> +		return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_4k);
> +	else if (size > 0)
> +		return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_16);

Redundant 'else'. Recommend to read again our internal Wiki about typical
issues with the code.

> +	return NULL;
> +}

...

> +static struct sk_buff *alloc_skb_from_kernel(size_t size, gfp_t gfp_mask)
> +{
> +	if (size > MTK_SKB_4K)
> +		return __dev_alloc_skb(MTK_SKB_64K, gfp_mask);
> +	else if (size > MTK_SKB_1_5K)
> +		return __dev_alloc_skb(MTK_SKB_4K, gfp_mask);
> +	else if (size > MTK_SKB_16)
> +		return __dev_alloc_skb(MTK_SKB_1_5K, gfp_mask);
> +	else if (size > 0)
> +		return __dev_alloc_skb(MTK_SKB_16, gfp_mask);

Ditto.

> +	return NULL;
> +}

...

> +		for (i = 0; i < queue->max_len; i++) {
> +			struct sk_buff *skb;
> +
> +			skb = alloc_skb_from_kernel(skb_size, GFP_KERNEL);

> +

Redundant.

> +			if (!skb) {
> +				while ((skb = skb_dequeue(&queue->skb_list)))
> +					dev_kfree_skb_any(skb);
> +				return -ENOMEM;
> +			}
> +
> +			skb_queue_tail(&queue->skb_list, skb);
> +		}

...

> +/**
> + * ccci_alloc_skb_from_pool() - allocate memory for skb from pre-allocated pools
> + * @pools: skb pools
> + * @size: allocation size
> + * @blocking : true for blocking operation

Extra white space.

Again, revisit _all_ comments in your series and make them consistent in _all_
possible aspects (style, grammar, ...).

> + *
> + * Returns pointer to skb on success, NULL on failure.
> + */

...

> +	if (blocking) {

> +		might_sleep();

might_sleep_if() at the top of the function?

> +		skb = alloc_skb_from_kernel(size, GFP_KERNEL);
> +	} else {
> +		for (count = 0; count < ALLOC_SKB_RETRY; count++) {
> +			skb = alloc_skb_from_kernel(size, GFP_ATOMIC);
> +			if (skb)
> +				return skb;
> +		}
> +	}

...

> +	while (queue->skb_list.qlen < SKB_64K_POOL_SIZE) {
> +		skb = alloc_skb_from_kernel(MTK_SKB_64K, GFP_KERNEL);
> +		if (skb)
> +			skb_queue_tail(&queue->skb_list, skb);
> +	}

May it become an infinite loop?

...

> +	while (queue->skb_list.qlen < SKB_4K_POOL_SIZE) {
> +		skb = alloc_skb_from_kernel(MTK_SKB_4K, GFP_KERNEL);
> +		if (skb)
> +			skb_queue_tail(&queue->skb_list, skb);
> +	}

Ditto.

...

> +	while (queue->skb_list.qlen < SKB_16_POOL_SIZE) {
> +		skb = alloc_skb_from_kernel(MTK_SKB_16, GFP_KERNEL);
> +		if (skb)
> +			skb_queue_tail(&queue->skb_list, skb);
> +	}

Ditto.

...

> +	pools->reload_work_queue = alloc_workqueue("pool_reload_work",
> +						   WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
> +						   1);

	... wqflags = WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI;

	pools->reload_work_queue = alloc_workqueue("pool_reload_work", wqflags, 1);

> +	if (!pools->reload_work_queue) {
> +		ret = -ENOMEM;
> +		goto err_wq;
> +	}

...

> +	list_for_each_entry_safe(notifier_cur, notifier_next,
> +				 &ctl->notifier_list, entry) {

Out of a sudden this is two lines...

> +		if (notifier_cur == notifier)
> +			list_del(&notifier->entry);
> +	}

...

> +			if (!list_empty(&ctl->event_queue)) {
> +				event = list_first_entry(&ctl->event_queue,
> +							 struct ccci_fsm_event, entry);

	event = list_first_entry_or_null();
	if (event) {

> +				if (event->event_id == CCCI_EVENT_MD_EX) {
> +					fsm_finish_event(ctl, event);
> +				} else if (event->event_id == CCCI_EVENT_MD_EX_REC_OK) {
> +					rec_ok = true;
> +					fsm_finish_event(ctl, event);
> +				}
> +			}

...

> +			if (!list_empty(&ctl->event_queue)) {
> +				event = list_first_entry(&ctl->event_queue,
> +							 struct ccci_fsm_event, entry);
> +				if (event->event_id == CCCI_EVENT_MD_EX_PASS)
> +					fsm_finish_event(ctl, event);
> +			}

Ditto

...

> +	if (!atomic_read(&ctl->md->rgu_irq_asserted)) {

It may be set exactly here, what's the point in atomicity of the above check?

> +		/* disable DRM before FLDR */
> +		mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_DRM_DISABLE_AP);
> +		msleep(FSM_DRM_DISABLE_DELAY_MS);
> +		/* try FLDR first */
> +		err = mtk_acpi_fldr_func(mtk_dev);
> +		if (err)
> +			mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_DEVICE_RESET);
> +	}

...

> +	wait_event_interruptible_timeout(ctl->async_hk_wq,
> +					 atomic_read(&md->core_md.ready) ||
> +					 atomic_read(&ctl->exp_flg), HZ * 60);

Are you sure you understand what you are doing with the atomics?

> +	if (atomic_read(&ctl->exp_flg))
> +		dev_err(dev, "MD exception is captured during handshake\n");
> +
> +	if (!atomic_read(&md->core_md.ready)) {
> +		dev_err(dev, "MD handshake timeout\n");
> +		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
> +	} else {
> +		fsm_routine_ready(ctl);
> +	}

...

> +	read_poll_timeout(ioread32, dev_status, (dev_status & MISC_STAGE_MASK) == LINUX_STAGE,
> +			  20000, 2000000, false, IREG_BASE(md->mtk_dev) + PCIE_MISC_DEV_STATUS);

Why ignoring an error is fine here?

...

> +	cmd = kmalloc(sizeof(*cmd),
> +		      (in_irq() || in_softirq() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL);

Hmm...

> +	if (!cmd)
> +		return -ENOMEM;

> +	if (in_irq() || irqs_disabled())
> +		flag &= ~FSM_CMD_FLAG_WAITING_TO_COMPLETE;

Even more hmm...

> +	if (flag & FSM_CMD_FLAG_WAITING_TO_COMPLETE) {
> +		wait_event(cmd->complete_wq, cmd->result != FSM_CMD_RESULT_PENDING);

Is it okay in IRQ context?

> +		if (cmd->result != FSM_CMD_RESULT_OK)
> +			result = -EINVAL;

> +		spin_lock_irqsave(&ctl->cmd_complete_lock, flags);
> +		kfree(cmd);
> +		spin_unlock_irqrestore(&ctl->cmd_complete_lock, flags);

While this is under spin lock?

> +	}

...

> +enum md_state ccci_fsm_get_md_state(void)
> +{
> +	struct ccci_fsm_ctl *ctl;
> +
> +	ctl = ccci_fsm_entry;
> +	if (ctl)
> +		return ctl->md_state;
> +	else
> +		return MD_STATE_INVALID;
> +}
> +
> +unsigned int ccci_fsm_get_current_state(void)
> +{
> +	struct ccci_fsm_ctl *ctl;
> +
> +	ctl = ccci_fsm_entry;
> +	if (ctl)
> +		return ctl->curr_state;
> +	else
> +		return CCCI_FSM_STOPPED;
> +}

Redundant 'else' everywhere.

...

> +int ccci_fsm_init(struct mtk_modem *md)
> +{
> +	struct ccci_fsm_ctl *ctl;

	struct device *dev = &md->mtk_dev->pdev->dev;

...

> +	ctl->fsm_thread = kthread_run(fsm_main_thread, ctl, "ccci_fsm");
> +	if (IS_ERR(ctl->fsm_thread)) {
> +		dev_err(&md->mtk_dev->pdev->dev, "failed to start monitor thread\n");

> +		return PTR_ERR(ctl->fsm_thread);
> +	}
> +
> +	return 0;

	return PTR_ERR_OR_ZERO(...);

> +}

-- 
With Best Regards,
Andy Shevchenko


