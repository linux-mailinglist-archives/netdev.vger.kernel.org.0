Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C0749281D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 15:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbiARONz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 09:13:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:44387 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244053AbiARONw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 09:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642515232; x=1674051232;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=g3R0cIe4iqYCfLjz5VgE92FWcftNBXlwLtolMhyM68s=;
  b=JJLw6E/Vyhq+x5Lw8f2OUAipOk2Lu9a5DiDda5vkau0VcOh7IuO2wTO1
   OIP76woEK9v8y3uOhZsJ4JUI250u+Rbnyw9Q8OAUq6C+QdZnK4bbkUImO
   oAwWHnXPyAHquz+wERHRZpNj5BHT9YpHDtgs8okX5d+ZivoNgyOahlDW8
   ZMmzTiibXiPNf2RZ81iKGj43CnR98Q4sZ5BSjPi89pQbUeRuGVYWfITBz
   kL4Uph1zfPSU2IfcD2dv40KW+wENUrpI5pkPr2Hif8Z+NyM4XvoS5D1x1
   At22i3ez5v3h1L8W/5Xk6H0iO4vFHrWaKgJu1Fuq52/jGSIGqUCHtneTL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244618390"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="244618390"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 06:13:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="531811469"
Received: from oelagadx-mobl2.ger.corp.intel.com ([10.251.219.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 06:13:44 -0800
Date:   Tue, 18 Jan 2022 16:13:42 +0200 (EET)
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
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
Message-ID: <d5854453-84b-1eba-7cc7-d94f41a185d@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
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
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

In general, I felt it to be quite clean and understandable.


> +#define CLDMA_NUM 2

I tried to understand its purpose but it seems that only one of the 
indexes is used in the arrays where this define gives the size? Related to 
this, ID_CLDMA0 is not used anywhere?

> +static int t7xx_cldma_gpd_rx_collect(struct cldma_queue *queue, int budget)
> +{
> +	struct cldma_ctrl *md_ctrl = queue->md_ctrl;
> +	bool rx_not_done, over_budget = false;
> +	struct t7xx_cldma_hw *hw_info;
> +	unsigned int l2_rx_int;
> +	unsigned long flags;
> +	int ret;
> +
> +	hw_info = &md_ctrl->hw_info;
> +
> +	do {
> +		rx_not_done = false;
> +
> +		ret = t7xx_cldma_gpd_rx_from_q(queue, budget, &over_budget);
> +		if (ret == -ENODATA)
> +			return 0;
> +
> +		if (ret)
> +			return ret;
> +
> +		spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
> +		if (md_ctrl->rxq_active & BIT(queue->index)) {
> +			if (!t7xx_cldma_hw_queue_status(hw_info, queue->index, MTK_RX))
> +				t7xx_cldma_hw_resume_queue(hw_info, queue->index, MTK_RX);
> +
> +			l2_rx_int = t7xx_cldma_hw_int_status(hw_info, BIT(queue->index), MTK_RX);
> +			if (l2_rx_int) {
> +				t7xx_cldma_hw_rx_done(hw_info, l2_rx_int);
> +
> +				if (over_budget) {
> +					spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
> +					return -EAGAIN;
> +				}
> +
> +				rx_not_done = true;
> +			}
> +		}
> +
> +		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
> +	} while (rx_not_done);
> +
> +	return 0;
> +}

Minor naming nit, rx_not_done doesn't seem to really tell if rx was being
done or not but whether the loop should run another iteration?

> +static void t7xx_cldma_ring_free(struct cldma_ctrl *md_ctrl,
> +				 struct cldma_ring *ring, enum dma_data_direction tx_rx)
> +{
> +	struct cldma_request *req_cur, *req_next;
> +
> +	list_for_each_entry_safe(req_cur, req_next, &ring->gpd_ring, entry) {
> +		if (req_cur->mapped_buff && req_cur->skb) {
> +			dma_unmap_single(md_ctrl->dev, req_cur->mapped_buff,
> +					 t7xx_skb_data_area_size(req_cur->skb), tx_rx);
> +			req_cur->mapped_buff = 0;
> +		}
> +
> +		dev_kfree_skb_any(req_cur->skb);
> +
> +		if (req_cur->gpd)
> +			dma_pool_free(md_ctrl->gpd_dmapool, req_cur->gpd, req_cur->gpd_addr);
> +
> +		list_del(&req_cur->entry);
> +		kfree_sensitive(req_cur);

Why _sensitive for a bunch of addresses? There's another one in 10/13 
which also looks bogus.

> +static void t7xx_cldma_enable_irq(struct cldma_ctrl *md_ctrl)
> +{
> +	t7xx_pcie_mac_set_int(md_ctrl->t7xx_dev, md_ctrl->hw_info.phy_interrupt_id);
> +}
> +
> +static void t7xx_cldma_disable_irq(struct cldma_ctrl *md_ctrl)
> +{
> +	t7xx_pcie_mac_clear_int(md_ctrl->t7xx_dev, md_ctrl->hw_info.phy_interrupt_id);
> +}

t7xx_pcie_mac_set_int and t7xx_pcie_mac_clear_int are only defined
by a later patch.

> +static bool t7xx_cldma_qs_are_active(struct t7xx_cldma_hw *hw_info)
> +{
> +	unsigned int tx_active;
> +	unsigned int rx_active;
> +
> +	tx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_TX);
> +	rx_active = t7xx_cldma_hw_queue_status(hw_info, CLDMA_ALL_Q, MTK_RX);
> +	if (tx_active == CLDMA_INVALID_STATUS || rx_active == CLDMA_INVALID_STATUS)

These cannot ever be true because of mask in t7xx_cldma_hw_queue_status().

> +static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
> +{
> +	struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
> +	struct cldma_request *req;
> +	struct cldma_rgpd *rgpd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rxq->ring_lock, flags);
> +	t7xx_cldma_q_reset(rxq);
> +	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
> +		rgpd = req->gpd;
> +		rgpd->gpd_flags = GPD_FLAGS_IOC | GPD_FLAGS_HWO;
> +		rgpd->data_buff_len = 0;
> +
> +		if (req->skb) {
> +			req->skb->len = 0;
> +			skb_reset_tail_pointer(req->skb);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&rxq->ring_lock, flags);
> +	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
> +		int ret;

I find this kind of newline+unlock+more code a bit odd groupingwise.
IMO, the newline should be after the unlock rather than just before it to 
better indicate the critical sections visually.

> +static void t7xx_cldma_stop_q(struct cldma_ctrl *md_ctrl, unsigned char qno, enum mtk_txrx tx_rx)
> +{
> +	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
> +	if (tx_rx == MTK_RX) {
> +		t7xx_cldma_hw_irq_dis_eq(hw_info, qno, MTK_RX);
> +		t7xx_cldma_hw_irq_dis_txrx(hw_info, qno, MTK_RX);
> +
> +		if (qno == CLDMA_ALL_Q)
> +			md_ctrl->rxq_active &= ~TXRX_STATUS_BITMASK;
> +		else
> +			md_ctrl->rxq_active &= ~(TXRX_STATUS_BITMASK & BIT(qno));
> +
> +		t7xx_cldma_hw_stop_queue(hw_info, qno, MTK_RX);
> +	} else if (tx_rx == MTK_TX) {
> +		t7xx_cldma_hw_irq_dis_eq(hw_info, qno, MTK_TX);
> +		t7xx_cldma_hw_irq_dis_txrx(hw_info, qno, MTK_TX);
> +
> +		if (qno == CLDMA_ALL_Q)
> +			md_ctrl->txq_active &= ~TXRX_STATUS_BITMASK;
> +		else
> +			md_ctrl->txq_active &= ~(TXRX_STATUS_BITMASK & BIT(qno));
> +
> +		t7xx_cldma_hw_stop_queue(hw_info, qno, MTK_TX);
> +	}
> +
> +	spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
> +}

This is always called with CLDMA_ALL_Q, never with a single queue.

> +/**
> + * t7xx_cldma_send_skb() - Send control data to modem.
> + * @md_ctrl: CLDMA context structure.
> + * @qno: Queue number.
> + * @skb: Socket buffer.
> + * @blocking: True for blocking operation.
> + *
> + * Send control packet to modem using a ring buffer.
> + * If blocking is set, it will wait for completion.
> + *
> + * Return:
> + * * 0		- Success.
> + * * -ENOMEM	- Allocation failure.
> + * * -EINVAL	- Invalid queue request.
> + * * -EBUSY	- Resource lock failure.
> + */
> +int t7xx_cldma_send_skb(struct cldma_ctrl *md_ctrl, int qno, struct sk_buff *skb, bool blocking)
> +{
> +	struct cldma_request *tx_req;
> +	struct cldma_queue *queue;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (qno >= CLDMA_TXQ_NUM)
> +		return -EINVAL;
> +
> +	queue = &md_ctrl->txq[qno];
> +
> +	spin_lock_irqsave(&md_ctrl->cldma_lock, flags);
> +	if (!(md_ctrl->txq_active & BIT(qno))) {
> +		ret = -EBUSY;
> +		spin_unlock_irqrestore(&md_ctrl->cldma_lock, flags);
> +		goto allow_sleep;
> +	}
...
> +		if (!blocking) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
> +		ret = wait_event_interruptible_exclusive(queue->req_wq, queue->budget > 0);
> +	} while (!ret);
> +
> +allow_sleep:
> +	return ret;
> +}

First of all, if I interpreted the call chains correctly, this function is 
always called with blocking=true.

Second, the first codepath returning -EBUSY when not txq_active seems
twisted/reversed logic to me (not active => busy ?!?).


> +int t7xx_cldma_init(struct t7xx_modem *md, struct cldma_ctrl *md_ctrl)
> +{
> +	struct t7xx_cldma_hw *hw_info = &md_ctrl->hw_info;
> +	int i;
> +
> +	md_ctrl->txq_active = 0;
> +	md_ctrl->rxq_active = 0;
> +	md_ctrl->is_late_init = false;
> +
> +	spin_lock_init(&md_ctrl->cldma_lock);
> +	for (i = 0; i < CLDMA_TXQ_NUM; i++) {
> +		md_cd_queue_struct_init(&md_ctrl->txq[i], md_ctrl, MTK_TX, i);
> +		md_ctrl->txq[i].md = md;
> +
> +		md_ctrl->txq[i].worker =
> +			alloc_workqueue("md_hif%d_tx%d_worker",
> +					WQ_UNBOUND | WQ_MEM_RECLAIM | (i ? 0 : WQ_HIGHPRI),
> +					1, md_ctrl->hif_id, i);
> +		if (!md_ctrl->txq[i].worker)
> +			return -ENOMEM;

Leaks?

> +		INIT_WORK(&md_ctrl->txq[i].cldma_work, t7xx_cldma_tx_done);
> +	}
> +
> +	for (i = 0; i < CLDMA_RXQ_NUM; i++) {
> +		md_cd_queue_struct_init(&md_ctrl->rxq[i], md_ctrl, MTK_RX, i);
> +		md_ctrl->rxq[i].md = md;
> +		INIT_WORK(&md_ctrl->rxq[i].cldma_work, t7xx_cldma_rx_done);
> +
> +		md_ctrl->rxq[i].worker = alloc_workqueue("md_hif%d_rx%d_worker",
> +							 WQ_UNBOUND | WQ_MEM_RECLAIM,
> +							 1, md_ctrl->hif_id, i);
> +		if (!md_ctrl->rxq[i].worker)
> +			return -ENOMEM;

Ditto.

> +enum cldma_id {
> +	ID_CLDMA0,

As mentioned above, this is not used anywhere.

> +	ID_CLDMA1,
> +};
> +
> +struct cldma_request {
> +	void *gpd;		/* Virtual address for CPU */
> +	dma_addr_t gpd_addr;	/* Physical address for DMA */
> +	struct sk_buff *skb;
> +	dma_addr_t mapped_buff;
> +	struct list_head entry;
> +};
> +
> +struct cldma_queue;

Unnecessary fwd decl.

> +struct cldma_ctrl;
> +
> +struct cldma_ring {
> +	struct list_head gpd_ring;	/* Ring of struct cldma_request */
> +	int length;			/* Number of struct cldma_request */
> +	int pkt_size;
> +};
> +
> +struct cldma_queue {
> +	struct t7xx_modem *md;
> +	struct cldma_ctrl *md_ctrl;
> +	enum mtk_txrx dir;
> +	unsigned char index;
> +	struct cldma_ring *tr_ring;
> +	struct cldma_request *tr_done;
> +	struct cldma_request *rx_refill;
> +	struct cldma_request *tx_xmit;

Based on the name, I'd have expected this to point to something that is 
currently under transmission but studying how it is used, it seems to 
point to next available req. Maybe rename to tx_next_avail or something 
along those lines? (Although when the ring is full, it isn't available 
if I understood the code correctly).

> +#define GPD_FLAGS_BDP		BIT(1)
> +#define GPD_FLAGS_BPS		BIT(2)

Unused.


-- 
 i.

