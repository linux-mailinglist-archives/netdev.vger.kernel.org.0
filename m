Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8332C441C23
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhKAOGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:06:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:47279 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232268AbhKAOGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 10:06:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10154"; a="229746150"
X-IronPort-AV: E=Sophos;i="5.87,199,1631602800"; 
   d="scan'208";a="229746150"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 07:03:29 -0700
X-IronPort-AV: E=Sophos;i="5.87,199,1631602800"; 
   d="scan'208";a="467313512"
Received: from smile.fi.intel.com ([10.237.72.184])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 07:03:23 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mhXty-002gsD-4y;
        Mon, 01 Nov 2021 16:03:06 +0200
Date:   Mon, 1 Nov 2021 16:03:05 +0200
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
Subject: Re: [PATCH v2 02/14] net: wwan: t7xx: Add control DMA interface
Message-ID: <YX/zmY81A9d0nIlO@smile.fi.intel.com>
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101035635.26999-3-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 08:56:23PM -0700, Ricardo Martinez wrote:
> From: Haijun Lio <haijun.liu@mediatek.com>
> 
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
> 
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
> 
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
> 
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
> 
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring

> Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

This...

> + * Authors: Haijun Lio <haijun.liu@mediatek.com>

(singular form?)

> + * Contributors: Amir Hanania <amir.hanania@intel.com>
> + *               Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> + *               Moises Veleta <moises.veleta@intel.com>
> + *               Ricardo Martinez<ricardo.martinez@linux.intel.com>
> + *               Sreehari Kancharla <sreehari.kancharla@intel.com>

...doesn't correlate with the above.

At least Ricardo seems to be the (co-)author of the code according to
the tag block above.

Also consider to start list(s) from the new line:

Autors:
 A B <>
 X Y <>

etc.

...

> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>

You may play with iwyu and amend this (including for headers and
the rest of the C-files).

[1]: https://include-what-you-use.org/

> +#include "t7xx_cldma.h"
> +
> +void cldma_clear_ip_busy(struct cldma_hw_info *hw_info)
> +{
> +	/* write 1 to clear IP busy register wake up CPU case */
> +	iowrite32(ioread32(hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY) | IP_BUSY_WAKEUP,
> +		  hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY);

Much easier to read in the standard pattern, i.e.

	u32 val;

	val = ioread32(hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY);
	val |= IP_BUSY_WAKEUP;
	iowrite32(val, hw_info->ap_pdn_base + REG_CLDMA_IP_BUSY);

> +}
> +
> +/**
> + * cldma_hw_restore() - Restore CLDMA HW registers
> + * @hw_info: Pointer to struct cldma_hw_info
> + *
> + * Restore HW after resume. Writes uplink configuration for CLDMA HW.

> + *

Redundant blank line. Check again your code for unneeded redundant lines.

> + */

...

> +void cldma_hw_reset(void __iomem *ao_base)
> +{
> +	iowrite32(ioread32(ao_base + REG_INFRA_RST4_SET) | RST4_CLDMA1_SW_RST_SET,
> +		  ao_base + REG_INFRA_RST4_SET);
> +	iowrite32(ioread32(ao_base + REG_INFRA_RST2_SET) | RST2_CLDMA1_AO_SW_RST_SET,
> +		  ao_base + REG_INFRA_RST2_SET);
> +	udelay(1);
> +	iowrite32(ioread32(ao_base + REG_INFRA_RST4_CLR) | RST4_CLDMA1_SW_RST_CLR,
> +		  ao_base + REG_INFRA_RST4_CLR);
> +	iowrite32(ioread32(ao_base + REG_INFRA_RST2_CLR) | RST2_CLDMA1_AO_SW_RST_CLR,
> +		  ao_base + REG_INFRA_RST2_CLR);

Setting and clearing are in the same order, is it okay?
Can we do it rather symmetrical?

> +}

...

> +	mb(); /* prevents outstanding GPD updates */

Is there any counterpart of this barrier?

...

> +	ch_id = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0) & bitmask;

	ch_id = ioread32(hw_info->ap_pdn_base + REG_CLDMA_L2TISAR0);
	ch_id &= bitmask;

Consider to use this pattern everywhere in the similar cases.

...

> +	/* ack interrupt */

Is it useful? If so it sounds to me like half said phrase, perhaps needs more
elaboration?

...

> +	/* enable interrupt */

> +	/* mask wakeup signal */

> +	/* disable TX and RX invalid address check */

Diito to all of these and more.

You shouldn't describe what code is doing, you should put why it's doing it.

...

> +/* interrupt status bit meaning, bitmask */
> +#define EMPTY_STATUS_BITMASK		0xff00
> +#define TXRX_STATUS_BITMASK		0x00ff

GENMASK()

> +/* L2RISAR0 */
> +#define TQ_ERR_INT_BITMASK		0x00ff0000
> +#define TQ_ACTIVE_START_ERR_INT_BITMASK	0xff000000
> +
> +#define RQ_ERR_INT_BITMASK		0x00ff0000
> +#define RQ_ACTIVE_START_ERR_INT_BITMASK	0xff000000

GENMASK()

What exactly BIT means in all of them when they are _not_ bit masks?

...

> +static struct cldma_request *cldma_ring_step_forward(struct cldma_ring *ring,
> +						     struct cldma_request *req)
> +{
> +	struct cldma_request *next_req;
> +
> +	if (req->entry.next == &ring->gpd_ring)
> +		next_req = list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
> +	else
> +		next_req = list_entry(req->entry.next, struct cldma_request, entry);

list_next_entry()

> +
> +	return next_req;
> +}
> +
> +static struct cldma_request *cldma_ring_step_backward(struct cldma_ring *ring,
> +						      struct cldma_request *req)
> +{
> +	struct cldma_request *prev_req;
> +
> +	if (req->entry.prev == &ring->gpd_ring)
> +		prev_req = list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
> +	else
> +		prev_req = list_entry(req->entry.prev, struct cldma_request, entry);

list_prev_entry()

> +
> +	return prev_req;
> +}

...

> +static int cldma_gpd_rx_from_queue(struct cldma_queue *queue, int budget, bool *over_budget)
> +{
> +	unsigned char hwo_polling_count = 0;
> +	struct cldma_hw_info *hw_info;
> +	struct cldma_ctrl *md_ctrl;
> +	struct cldma_request *req;
> +	struct cldma_rgpd *rgpd;
> +	struct sk_buff *new_skb;
> +	bool rx_done = false;
> +	struct sk_buff *skb;
> +	int count = 0;

> +	int ret = 0;

How exactly is this assignment being used?
You need to revisit all of them in the driver.

> +	md_ctrl = md_cd_get(queue->hif_id);
> +	hw_info = &md_ctrl->hw_info;

> +	while (!rx_done) {

do {

> +		req = queue->tr_done;
> +		if (!req) {
> +			dev_err(md_ctrl->dev, "RXQ was released\n");
> +			return -ENODATA;
> +		}
> +
> +		rgpd = req->gpd;
> +		if ((rgpd->gpd_flags & GPD_FLAGS_HWO) || !req->skb) {
> +			u64 gpd_addr;
> +
> +			/* current 64 bit address is in a table by Q index */
> +			gpd_addr = ioread64(hw_info->ap_pdn_base +
> +					    REG_CLDMA_DL_CURRENT_ADDRL_0 +
> +					    queue->index * sizeof(u64));

> +			if (gpd_addr == GENMASK_ULL(63, 0)) {
> +				dev_err(md_ctrl->dev, "PCIe Link disconnected\n");
> +				return -ENODATA;
> +			}

I'm wondering if PCI core provides some common method for that (like
pci_dev_is_present() or so) and if it can be used here.

> +			if ((u64)queue->tr_done->gpd_addr != gpd_addr &&
> +			    hwo_polling_count++ < 100) {
> +				udelay(1);
> +				continue;
> +			}
> +
> +			break;

I would rather expect

	if (...)
		break;
	...
	continue;

> +		}
> +
> +		hwo_polling_count = 0;
> +		skb = req->skb;
> +
> +		if (req->mapped_buff) {
> +			dma_unmap_single(md_ctrl->dev, req->mapped_buff,
> +					 skb_data_size(skb), DMA_FROM_DEVICE);
> +			req->mapped_buff = 0;
> +		}
> +
> +		/* init skb struct */
> +		skb->len = 0;
> +		skb_reset_tail_pointer(skb);
> +		skb_put(skb, rgpd->data_buff_len);
> +
> +		/* consume skb */
> +		if (md_ctrl->recv_skb) {
> +			ret = md_ctrl->recv_skb(queue, skb);
> +		} else {
> +			ccci_free_skb(&md_ctrl->mtk_dev->pools, skb);
> +			ret = -ENETDOWN;
> +		}

> +		new_skb = NULL;

Would be better to put it to else branch...

> +		if (ret >= 0 || ret == -ENETDOWN)
> +			new_skb = ccci_alloc_skb_from_pool(&md_ctrl->mtk_dev->pools,
> +							   queue->tr_ring->pkt_size,
> +							   GFS_BLOCKING);

> +

...and drop this empty line.

> +		if (!new_skb) {
> +			/* either the port was busy or the skb pool was empty */
> +			usleep_range(5000, 10000);
> +			return -EAGAIN;

Neither comment, nor function name suggests this error code.
Why not -EBUSY nor -ENOMEM?

> +		}
> +
> +		/* mark cldma_request as available */
> +		req->skb = NULL;
> +		cldma_rgpd_set_data_ptr(rgpd, 0);
> +		queue->tr_done = cldma_ring_step_forward(queue->tr_ring, req);
> +
> +		req = queue->rx_refill;
> +		rgpd = req->gpd;
> +		req->mapped_buff = dma_map_single(md_ctrl->dev, new_skb->data,
> +						  skb_data_size(new_skb), DMA_FROM_DEVICE);
> +		if (dma_mapping_error(md_ctrl->dev, req->mapped_buff)) {
> +			dev_err(md_ctrl->dev, "DMA mapping failed\n");
> +			req->mapped_buff = 0;
> +			ccci_free_skb(&md_ctrl->mtk_dev->pools, new_skb);
> +			return -ENOMEM;
> +		}
> +
> +		cldma_rgpd_set_data_ptr(rgpd, req->mapped_buff);
> +		rgpd->data_buff_len = 0;
> +		/* set HWO, no need to hold ring_lock */
> +		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
> +		/* mark cldma_request as available */
> +		req->skb = new_skb;
> +		queue->rx_refill = cldma_ring_step_forward(queue->tr_ring, req);

> +		if (++count >= budget && need_resched()) {
> +			*over_budget = true;
> +			rx_done = true;
> +		}

	} while (...);

	*over_budget = true;

> +	}
> +
> +	return 0;
> +}

...

> +		ret = cldma_gpd_rx_from_queue(queue, budget, &over_budget);
> +		if (ret == -ENODATA)
> +			return 0;
> +
> +		if (ret)
> +			return ret;

Drop redundant blank line

> +			/* greedy mode */
> +			l2_rx_int = cldma_hw_int_status(hw_info, BIT(queue->index), true);

> +

Redundant blank line. I think you may shrink your driver by 100+ LOCs
due to these...

> +			if (l2_rx_int) {

> +			}
> +		}

...

> +	struct cldma_ctrl *md_ctrl;
> +	struct cldma_queue *queue;
> +	int value;
> +
> +	queue = container_of(work, struct cldma_queue, cldma_rx_work);
> +	md_ctrl = md_cd_get(queue->hif_id);

These assignments seem easily can be unified with the definitions.

> +	value = queue->tr_ring->handle_rx_done(queue, queue->budget);

> +

Redundant.

> +	if (value && md_ctrl->rxq_active & BIT(queue->index)) {
> +		queue_work(queue->worker, &queue->cldma_rx_work);
> +		return;
> +	}

...

> +		spin_lock_irqsave(&queue->ring_lock, flags);
> +		req = queue->tr_done;
> +		if (!req) {

> +			dev_err(md_ctrl->dev, "TXQ was released\n");

Under spin lock?! Why?

> +			spin_unlock_irqrestore(&queue->ring_lock, flags);
> +			break;
> +		}

...

> +		/* restore IOC setting */
> +		if (req->ioc_override & GPD_FLAGS_IOC) {
> +			if (req->ioc_override & GPD_FLAGS_HWO)
> +				tgpd->gpd_flags |= GPD_FLAGS_IOC;
> +			else
> +				tgpd->gpd_flags &= ~GPD_FLAGS_IOC;

> +			dev_notice(md_ctrl->dev,
> +				   "qno%u, req->ioc_override=0x%x,tgpd->gpd_flags=0x%x\n",
> +				   queue->index, req->ioc_override, tgpd->gpd_flags);

Why so high level of the message without baling out?

> +		}

...

> +		ul_curr_addr = ioread64(hw_info->ap_pdn_base +
> +					REG_CLDMA_UL_CURRENT_ADDRL_0 +
> +					queue->index * sizeof(u64));
> +		if (req->gpd_addr != ul_curr_addr)
> +			dev_err(md_ctrl->dev,
> +				"CLDMA%d Q%d TGPD addr, SW:%pad, HW:%pad\n", md_ctrl->hif_id,
> +				queue->index, &req->gpd_addr, &ul_curr_addr);

Why error level without bailing out?

> +		else
> +			/* retry */
> +			cldma_hw_resume_queue(&md_ctrl->hw_info, queue->index, false);

...

> +	struct cldma_hw_info *hw_info;
> +	struct cldma_ctrl *md_ctrl;
> +	struct cldma_queue *queue;
> +	unsigned int l2_tx_int;
> +	unsigned long flags;
> +
> +	queue = container_of(work, struct cldma_queue, cldma_tx_work);
> +	md_ctrl = md_cd_get(queue->hif_id);
> +	hw_info = &md_ctrl->hw_info;

Can be unified with definitions above.
Same to all similar cases.

...

> +	item->gpd = dma_pool_alloc(md_ctrl->gpd_dmapool, GFP_KERNEL | __GFP_ZERO,
> +				   &item->gpd_addr);

dma_pool_zalloc()

> +	if (!item->gpd)
> +		goto err_gpd_alloc;

...

> +	item->gpd = dma_pool_alloc(md_ctrl->gpd_dmapool, GFP_KERNEL | __GFP_ZERO,
> +				   &item->gpd_addr);

Ditto.

> +	if (!item->gpd) {
> +		kfree(item);
> +		return NULL;
> +	}

...

> +			for (i = 0; i < CLDMA_TXQ_NUM; i++) {
> +				if (l2_tx_int & BIT(i)) {

NIH for_each_set_bit()

> +				}

...

> +			for (i = 0; i < CLDMA_RXQ_NUM; i++) {
> +				if (l2_rx_int & (BIT(i) | EQ_STA_BIT(i))) {

Ditto.

> +				}

...

> +	return ((tx_active || rx_active) && tx_active != CLDMA_ALL_Q && rx_active != CLDMA_ALL_Q);

Too many parentheses.

...

> +	if (read_poll_timeout(queues_active, active, !active, CHECK_Q_STOP_STEP_US,
> +			      CHECK_Q_STOP_TIMEOUT_US, true, hw_info)) {
> +		dev_err(md_ctrl->dev, "Could not stop CLDMA%d queues", hif_id);

> +		return -EAGAIN;

Why shadowing error code?

> +	}

...

> +static void cldma_late_release(struct cldma_ctrl *md_ctrl)
> +{
> +	int i;

> +	if (md_ctrl->is_late_init) {

	if (!...)
		 return;

> +	}
> +}

...

> +		/* wait write done */
> +		wmb();

This requires also elaboration on where is the counterpart of this barrier.

...

> +static void clear_txq(struct cldma_ctrl *md_ctrl, int qnum)
> +{
> +	struct cldma_request *req;
> +	struct cldma_queue *txq;
> +	struct cldma_tgpd *tgpd;
> +	unsigned long flags;

> +	txq = &md_ctrl->txq[qnum];

To the definition block.

> +	spin_lock_irqsave(&txq->ring_lock, flags);

> +	req = list_first_entry(&txq->tr_ring->gpd_ring, struct cldma_request, entry);
> +	txq->tr_done = req;
> +	txq->tx_xmit = req;
> +	txq->budget = txq->tr_ring->length;

I'm wondering what the magic is behind these lines...

> +	list_for_each_entry(req, &txq->tr_ring->gpd_ring, entry) {
> +		tgpd = req->gpd;
> +		tgpd->gpd_flags &= ~GPD_FLAGS_HWO;
> +		cldma_tgpd_set_data_ptr(tgpd, 0);
> +		tgpd->data_buff_len = 0;
> +		if (req->skb) {
> +			ccci_free_skb(&md_ctrl->mtk_dev->pools, req->skb);
> +			req->skb = NULL;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&txq->ring_lock, flags);
> +}

...

> +	tx_req->mapped_buff = dma_map_single(md_ctrl->dev, skb->data,
> +					     skb->len, DMA_TO_DEVICE);

In one case you have a long line, in many others you have doing this.
A bit of consistency is required. If you use 100, use it everywhere,
or otherwise go for 80 everywhere (with possible exceptions as written
in the documentation).

...


> +	if (queue->budget > (MAX_TX_BUDGET - 1))

	if (queue->budget >= MAX_TX_BUDGET)

> +		return queue->budget;

...

> + * Return: 0 on success, -ENOMEM on allocation failure, -EINVAL on invalid queue request, or
> + *         -EBUSY on resource lock failure.

* Return: 0 on success,
	  -ENOMEM on allocation failure,
	  -EINVAL on invalid queue request, or
	  -EBUSY on resource lock failure.

?

...

> +	do {
> +		spin_lock_irqsave(&queue->ring_lock, flags);
> +		tx_req = queue->tx_xmit;
> +		if (queue->budget > 0 && !tx_req->skb) {
> +			queue->budget--;
> +			queue->tr_ring->handle_tx_request(queue, tx_req, skb, ioc_override);
> +			queue->tx_xmit = cldma_ring_step_forward(queue->tr_ring, tx_req);
> +			spin_unlock_irqrestore(&queue->ring_lock, flags);

Since these are two different locks, how you guarantee that below will be run
correctly? (Perhaps some explanation is needed)

> +			spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
> +			cldma_hw_start_send(md_ctrl, qno);
> +			spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
> +			break;
> +		}

...

> +		ret = wait_event_interruptible_exclusive(queue->req_wq, queue->budget > 0);
> +		if (ret == -ERESTARTSYS)
> +			ret = -EINTR;

Why overriding?

...

> +exit:

Seems useless.

> +	return ret;

...

> +/* this function contains longer duration initializations */

Useless.

You must really revisit all the comments over the driver and change them to
explain why rather than what.

Above, of course, maybe converted to kernel doc that actually describes what
the API is doing in more verbose way.

...

> +	snprintf(dma_pool_name, 32, "cldma_request_dma_hif%d", md_ctrl->hif_id);

sizeof()

...

					       sizeof(struct cldma_tgpd), 16, 0);

16 is magic.

...

> +	for (i = 0; i < CLDMA_TXQ_NUM; i++)
> +		cldma_tx_queue_init(&md_ctrl->txq[i]);
> +
> +	for (i = 0; i < CLDMA_RXQ_NUM; i++)
> +		cldma_rx_queue_init(&md_ctrl->rxq[i]);
> +	mutex_unlock(&ctl_cfg_mutex);
> +
> +	md_ctrl->is_late_init = true;
> +	return 0;
> +
> +err_rx_ring:
> +	while (i--)
> +		cldma_ring_free(md_ctrl, &md_ctrl->rx_ring[i], DMA_FROM_DEVICE);

> +	i = CLDMA_TXQ_NUM;

I would rather provide i,j and drop this line for good.

> +err_tx_ring:
> +	while (i--)
> +		cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);

...

> +/**
> + * cldma_exception() - CLDMA exception handler
> + * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)
> + * @stage: exception stage
> + *
> + * disable/flush/stop/start CLDMA/queues based on exception stage.

Please, elaborate state machine here with the (ASCII) chart of the (possible)
state changes.

> + *

Redundant.

> + */

...

> +/**
> + * cldma_init() - Initialize CLDMA
> + * @hif_id: CLDMA ID (ID_CLDMA0 or ID_CLDMA1)

> + * initialize HIF TX/RX queue structure
> + * register CLDMA callback isr with PCIe driver

You need to revisit all descriptions in order to amend English grammar and
punctuation. E.g. here you lost capitalization and period.

> + * Return: 0 on success, a negative error code on failure
> + */

...

> +			alloc_workqueue("md_hif%d_tx%d_worker",
> +					WQ_UNBOUND | WQ_MEM_RECLAIM | (!i ? WQ_HIGHPRI : 0),

What is the idea behind redundant negation?

> +					1, hif_id, i);

...

> +#ifndef __T7XX_HIF_CLDMA_H__
> +#define __T7XX_HIF_CLDMA_H__
> +
> +#include <linux/pci.h>
> +#include <linux/sched.h>
> +#include <linux/spinlock.h>
> +#include <linux/wait.h>
> +#include <linux/workqueue.h>
> +#include <linux/types.h>
> +
> +#include "t7xx_cldma.h"
> +#include "t7xx_common.h"
> +#include "t7xx_modem_ops.h"
> +#include "t7xx_pci.h"

All of these headers are needed and used here?
Really?!

But bits.h is missed...

...

> +/* cldma_ring is quite light, most of ring buffer operations require queue struct. */
> +struct cldma_ring {
> +	struct list_head gpd_ring;	/* ring of struct cldma_request */
> +	int length;			/* number of struct cldma_request */
> +	int pkt_size;			/* size of each packet in ring */
> +
> +	int (*handle_tx_request)(struct cldma_queue *queue, struct cldma_request *req,
> +				 struct sk_buff *skb, unsigned int ioc_override);
> +	int (*handle_rx_done)(struct cldma_queue *queue, int budget);
> +	int (*handle_tx_done)(struct cldma_queue *queue);

Perhaps convert comments to proper kernel doc.

> +};

...

> +struct cldma_tgpd {
> +	u8 gpd_flags;
> +	u16 non_used;
> +	u8 debug_id;
> +	u32 next_gpd_ptr_h;
> +	u32 next_gpd_ptr_l;
> +	u32 data_buff_bd_ptr_h;
> +	u32 data_buff_bd_ptr_l;
> +	u16 data_buff_len;
> +	u16 non_used1;
> +} __packed;

What useful does __packed here?

> +struct cldma_rgpd {
> +	u8 gpd_flags;
> +	u8 non_used;
> +	u16 data_allow_len;
> +	u32 next_gpd_ptr_h;
> +	u32 next_gpd_ptr_l;
> +	u32 data_buff_bd_ptr_h;
> +	u32 data_buff_bd_ptr_l;
> +	u16 data_buff_len;
> +	u8 non_used1;
> +	u8 debug_id;
> +} __packed;

Ditto.

(If it's about unaligned addresses, then you have to mention it somewhere)

-- 
With Best Regards,
Andy Shevchenko


