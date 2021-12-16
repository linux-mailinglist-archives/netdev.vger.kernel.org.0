Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659EE477323
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbhLPNak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:30:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:9678 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237535AbhLPNaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 08:30:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226773928"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="226773928"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:30:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519251362"
Received: from jetten-mobl.ger.corp.intel.com ([10.252.36.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:30:32 -0800
Date:   Thu, 16 Dec 2021 15:30:30 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com
Subject: Re: [PATCH net-next v3 07/12] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <20211207024711.2765-8-ricardo.martinez@linux.intel.com>
Message-ID: <5154c2b5-4b94-fcfb-fbdc-8d3dcacc34de@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-8-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> for initialization, ISR, control and event handling of TX/RX flows.
> 
> DPMAIF TX
> Exposes the `dmpaif_tx_send_skb` function which can be used by the
> network device to transmit packets.
> The uplink data management uses a Descriptor Ring Buffer (DRB).
> First DRB entry is a message type that will be followed by 1 or more
> normal DRB entries. Message type DRB will hold the skb information
> and each normal DRB entry holds a pointer to the skb payload.
> 
> DPMAIF RX
> The downlink buffer management uses Buffer Address Table (BAT) and
> Packet Information Table (PIT) rings.
> The BAT ring holds the address of skb data buffer for the HW to use,
> while the PIT contains metadata about a whole network packet including
> a reference to the BAT entry holding the data buffer address.
> The driver reads the PIT and BAT entries written by the modem, when
> reaching a threshold, the driver will reload the PIT and BAT rings.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

+struct dpmaif_ctrl {
...
+       unsigned char                   txq_select_times;

txq_select_times value is never used.

> +unsigned int t7xx_ring_buf_get_next_wrdx(unsigned int buf_len, unsigned int buf_idx)
> +{
> +	buf_idx++;
> +
> +	return buf_idx < buf_len ? buf_idx : 0;
> +}
> +
> +unsigned int t7xx_ring_buf_rd_wr_count(unsigned int total_cnt, unsigned int rd_idx,
> +				       unsigned int wrt_idx, enum dpmaif_rdwr rd_wr)
> +{
> +	int pkt_cnt;
> +
> +	if (rd_wr == DPMAIF_READ)
> +		pkt_cnt = wrt_idx - rd_idx;
> +	else
> +		pkt_cnt = rd_idx - wrt_idx - 1;
> +
> +	if (pkt_cnt < 0)
> +		pkt_cnt += total_cnt;
> +
> +	return (unsigned int)pkt_cnt;
> +}

Didn't the earlier patch use wridx and ridx for the same concept? It would 
be useful to have consistency in variable naming.

> +static inline unsigned int t7xx_normal_pit_bid(const struct dpmaif_normal_pit *pit_info)

No inlines in .c files please. Please fix all of them, not just this one..

> +	for (i = 0; i < alloc_cnt; i++) {
> +		unsigned short cur_bat_idx = bat_start_idx + i;
> +		struct dpmaif_bat_skb *cur_skb;
> +		struct dpmaif_bat *cur_bat;
> +
> +		if (cur_bat_idx >= bat_max_cnt)
> +			cur_bat_idx -= bat_max_cnt;
> +
> +		cur_skb = (struct dpmaif_bat_skb *)bat_req->bat_skb + cur_bat_idx;
> +		if (!cur_skb->skb) {
> +			struct dpmaif_skb_info *skb_info;
> +
> +			skb_info = t7xx_dpmaif_dev_alloc_skb(dpmaif_ctrl, bat_req->pkt_buf_sz);
> +			if (!skb_info)
> +				break;
> +
> +			cur_skb->skb = skb_info->skb;
> +			cur_skb->data_bus_addr = skb_info->data_bus_addr;
> +			cur_skb->data_len = skb_info->data_len;
> +			kfree(skb_info);

It seems that here you do an alloc that is immediately followed by kfree.
Couldn't this be solved by passing cur_skb to a function which assigns 
those values you want directly to it?

> +	old_sw_rel_idx = rxq->pit_release_rd_idx;
> +	new_sw_rel_idx = old_sw_rel_idx + rel_entry_num;
> +	old_hw_wr_idx = rxq->pit_wr_idx;
> +	if (old_hw_wr_idx < old_sw_rel_idx && new_sw_rel_idx >= rxq->pit_size_cnt)
> +		new_sw_rel_idx = new_sw_rel_idx - rxq->pit_size_cnt;

-=

> +/**
> + * t7xx_dpmaif_rx_frag_alloc() - Allocates buffers for the Fragment BAT ring.
> + * @dpmaif_ctrl: Pointer to DPMAIF context structure.
> + * @bat_req: Pointer to BAT request structure.
> + * @buf_cnt: Number of buffers to allocate.
> + * @initial: Indicates if the ring is being populated for the first time.
> + *
> + * Fragment BAT is used when the received packet does not fit in a normal BAT entry.
> + * This function allocates a page fragment and stores the start address of the page
> + * into the Fragment BAT ring.
> + * If this is not the initial call, notify the HW about the new entries.
> + *
> + * Return:
> + * * 0		- Success.
> + * * -ERROR	- Error code from failure sub-initializations.
> + */
> +int t7xx_dpmaif_rx_frag_alloc(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_bat_request *bat_req,
> +			      const unsigned int buf_cnt, const bool initial)
> +{
> +	struct dpmaif_bat_page *bat_skb = bat_req->bat_skb;
> +	unsigned short cur_bat_idx = bat_req->bat_wr_idx;
> +	unsigned int buf_space;
> +	int i;
> +
> +	if (!buf_cnt || buf_cnt > bat_req->bat_size_cnt)
> +		return -EINVAL;
> +
> +	buf_space = t7xx_ring_buf_rd_wr_count(bat_req->bat_size_cnt,
> +					      bat_req->bat_release_rd_idx, bat_req->bat_wr_idx,
> +					      DPMAIF_WRITE);
> +	if (buf_cnt > buf_space) {
> +		dev_err(dpmaif_ctrl->dev,
> +			"Requested more buffers than the space available in RX frag ring\n");
> +		return -EINVAL;
> +	}
> +
> +	for (i = 0; i < buf_cnt; i++) {
> +		struct dpmaif_bat_page *cur_page = bat_skb + cur_bat_idx;
> +		struct dpmaif_bat *cur_bat;
> +		dma_addr_t data_base_addr;
> +
> +		if (!cur_page->page) {
> +			unsigned long offset;
> +			struct page *page;
> +			void *data;
> +
> +			data = netdev_alloc_frag(bat_req->pkt_buf_sz);
> +			if (!data)
> +				break;
> +
> +			page = virt_to_head_page(data);
> +			offset = data - page_address(page);
> +
> +			data_base_addr = dma_map_page(dpmaif_ctrl->dev, page, offset,
> +						      bat_req->pkt_buf_sz, DMA_FROM_DEVICE);
> +			if (dma_mapping_error(dpmaif_ctrl->dev, data_base_addr)) {
> +				dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
> +				put_page(virt_to_head_page(data));
> +				break;
> +			}
> +
> +			cur_page->page = page;
> +			cur_page->data_bus_addr = data_base_addr;
> +			cur_page->offset = offset;
> +			cur_page->data_len = bat_req->pkt_buf_sz;
> +		}
> +
> +		data_base_addr = cur_page->data_bus_addr;
> +		cur_bat = (struct dpmaif_bat *)bat_req->bat_base + cur_bat_idx;
> +		cur_bat->buffer_addr_ext = upper_32_bits(data_base_addr);
> +		cur_bat->p_buffer_addr = lower_32_bits(data_base_addr);
> +		cur_bat_idx = t7xx_ring_buf_get_next_wrdx(bat_req->bat_size_cnt, cur_bat_idx);
> +	}
> +
> +	if (i < buf_cnt)
> +		return -ENOMEM;
> +	bat_req->bat_wr_idx = cur_bat_idx;

Is there some leak if this early returns and does not update bat_wr_idx?
One call path seems to eventually just ignore error code.


> +static int t7xx_dpmaif_rx_start(struct dpmaif_rx_queue *rxq, const unsigned short pit_cnt,
> +				const unsigned long timeout)
> +{
> +	struct device *dev = rxq->dpmaif_ctrl->dev;
> +	struct dpmaif_cur_rx_skb_info *skb_info;
> +	unsigned short rx_cnt, recv_skb_cnt = 0;
> +	unsigned int cur_pit, pit_len;
> +	int ret = 0, ret_hw = 0;
> +
> +	pit_len = rxq->pit_size_cnt;
> +	skb_info = &rxq->rx_data_info;
> +	cur_pit = rxq->pit_rd_idx;
> +
> +	for (rx_cnt = 0; rx_cnt < pit_cnt; rx_cnt++) {
> +		struct dpmaif_normal_pit *pkt_info;
> +		u32 val;
> +
> +		if (!skb_info->msg_pit_received && time_after_eq(jiffies, timeout))
> +			break;
> +
> +		pkt_info = (struct dpmaif_normal_pit *)rxq->pit_base + cur_pit;
> +		if (t7xx_dpmaif_check_pit_seq(rxq, pkt_info)) {
> +			dev_err_ratelimited(dev, "RXQ%u checks PIT SEQ fail\n", rxq->index);
> +			return -EAGAIN;
> +		}
> +
> +		val = FIELD_GET(NORMAL_PIT_PACKET_TYPE, le32_to_cpu(pkt_info->pit_header));
> +		if (val == DES_PT_MSG) {
> +			if (skb_info->msg_pit_received)
> +				dev_err(dev, "RXQ%u received repeated PIT\n", rxq->index);
> +
> +			skb_info->msg_pit_received = true;
> +			t7xx_dpmaif_parse_msg_pit(rxq, (struct dpmaif_msg_pit *)pkt_info,
> +						  skb_info);
> +		} else { /* DES_PT_PD */
> +			val = FIELD_GET(NORMAL_PIT_BUFFER_TYPE, le32_to_cpu(pkt_info->pit_header));
> +			if (val != PKT_BUF_FRAG)
> +				ret = t7xx_dpmaif_get_rx_pkt(rxq, pkt_info, skb_info);
> +			else if (!skb_info->cur_skb)
> +				ret = -EINVAL;
> +			else
> +				ret = t7xx_dpmaif_get_frag(rxq, pkt_info, skb_info);
> +
> +			if (ret < 0) {
> +				skb_info->err_payload = 1;
> +				dev_err_ratelimited(dev, "RXQ%u error payload\n", rxq->index);
> +			}
> +
> +			val = FIELD_GET(NORMAL_PIT_CONT, le32_to_cpu(pkt_info->pit_header));
> +			if (!val) {
> +				if (!skb_info->err_payload) {
> +					t7xx_dpmaif_rx_skb(rxq, skb_info);
> +				} else if (skb_info->cur_skb) {
> +					dev_kfree_skb_any(skb_info->cur_skb);
> +					skb_info->cur_skb = NULL;
> +				}
> +
> +				memset(skb_info, 0, sizeof(*skb_info));
> +
> +				recv_skb_cnt++;
> +				if (!(recv_skb_cnt & DPMAIF_RX_PUSH_THRESHOLD_MASK)) {
> +					wake_up_all(&rxq->rx_wq);
> +					recv_skb_cnt = 0;
> +				}
> +			}
> +		}
> +
> +		cur_pit = t7xx_ring_buf_get_next_wrdx(pit_len, cur_pit);
> +		rxq->pit_rd_idx = cur_pit;
> +		rxq->pit_remain_release_cnt++;
> +
> +		if (rx_cnt > 0 && !(rx_cnt % DPMAIF_NOTIFY_RELEASE_COUNT)) {
> +			ret_hw = t7xx_dpmaifq_rx_notify_hw(rxq);
> +			if (ret_hw < 0)
> +				break;
> +		}
> +	}
> +
> +	if (recv_skb_cnt)
> +		wake_up_all(&rxq->rx_wq);
> +
> +	if (!ret_hw)
> +		ret_hw = t7xx_dpmaifq_rx_notify_hw(rxq);
> +
> +	if (ret_hw < 0 && !ret)
> +		ret = ret_hw;
> +
> +	return ret < 0 ? ret : rx_cnt;
> +}

ret variable handling seems odd, loop overwrites prev errors. Is there
perhaps a break missing from somewhere as post loop checks seem to care 
about the value of ret variable?

> +	return (real_rel_cnt < rel_cnt) ? -EAGAIN : 0;

Extra ().

> +static int t7xx_dpmaif_add_skb_to_ring(struct dpmaif_ctrl *dpmaif_ctrl, struct sk_buff *skb)
> +{
> +	unsigned int wr_cnt, send_cnt, payload_cnt;
> +	bool is_frag, is_last_one = false;
> +	int qtype = skb->cb[TX_CB_QTYPE];
> +	struct skb_shared_info *info;
> +	struct dpmaif_tx_queue *txq;
> +	int drb_wr_idx_backup = -1;

Redundant initialization.

> +	unsigned short cur_idx;
> +	unsigned int data_len;
> +	dma_addr_t bus_addr;
> +	unsigned long flags;
> +	void *data_addr;
> +	int ret = 0;
> +
> +	txq = &dpmaif_ctrl->txq[qtype];
> +	if (!txq->que_started || dpmaif_ctrl->state != DPMAIF_STATE_PWRON)
> +		return -ENODEV;
> +
> +	atomic_set(&txq->tx_processing, 1);
> +	 /* Ensure tx_processing is changed to 1 before actually begin TX flow */
> +	smp_mb();
> +
> +	info = skb_shinfo(skb);
> +	if (info->frag_list)
> +		dev_warn_ratelimited(dpmaif_ctrl->dev, "frag_list not supported\n");
> +
> +	payload_cnt = info->nr_frags + 1;
> +	/* nr_frags: frag cnt, 1: skb->data, 1: msg DRB */
> +	send_cnt = payload_cnt + 1;
> +
> +	spin_lock_irqsave(&txq->tx_lock, flags);
> +	cur_idx = txq->drb_wr_idx;
> +	drb_wr_idx_backup = cur_idx;
> +
> +	txq->drb_wr_idx += send_cnt;
> +	if (txq->drb_wr_idx >= txq->drb_size_cnt)
> +		txq->drb_wr_idx -= txq->drb_size_cnt;
> +
> +	t7xx_setup_msg_drb(dpmaif_ctrl, txq->index, cur_idx, skb->len, 0, skb->cb[TX_CB_NETIF_IDX]);
> +	t7xx_record_drb_skb(dpmaif_ctrl, txq->index, cur_idx, skb, 1, 0, 0, 0, 0);
> +	spin_unlock_irqrestore(&txq->tx_lock, flags);
> +
> +	cur_idx = t7xx_ring_buf_get_next_wrdx(txq->drb_size_cnt, cur_idx);
> +
> +	for (wr_cnt = 0; wr_cnt < payload_cnt; wr_cnt++) {
> +		if (!wr_cnt) {
> +			data_len = skb_headlen(skb);
> +			data_addr = skb->data;
> +			is_frag = false;
> +		} else {
> +			skb_frag_t *frag = info->frags + wr_cnt - 1;
> +
> +			data_len = skb_frag_size(frag);
> +			data_addr = skb_frag_address(frag);
> +			is_frag = true;
> +		}
> +
> +		if (wr_cnt == payload_cnt - 1)
> +			is_last_one = true;
> +
> +		/* TX mapping */
> +		bus_addr = dma_map_single(dpmaif_ctrl->dev, data_addr, data_len, DMA_TO_DEVICE);
> +		if (dma_mapping_error(dpmaif_ctrl->dev, bus_addr)) {
> +			dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		spin_lock_irqsave(&txq->tx_lock, flags);
> +		t7xx_setup_payload_drb(dpmaif_ctrl, txq->index, cur_idx, bus_addr, data_len,
> +				       is_last_one);
> +		t7xx_record_drb_skb(dpmaif_ctrl, txq->index, cur_idx, skb, 0, is_frag,
> +				    is_last_one, bus_addr, data_len);
> +		spin_unlock_irqrestore(&txq->tx_lock, flags);
> +
> +		cur_idx = t7xx_ring_buf_get_next_wrdx(txq->drb_size_cnt, cur_idx);
> +	}
> +
> +	if (ret < 0) {
> +		atomic_set(&txq->tx_processing, 0);
> +
> +		if (drb_wr_idx_backup >= 0) {

Always true?

> +		/* Confirm that SW will not transmit */
> +		count = 0;
> +
> +		do {
> +			if (++count >= DPMAIF_MAX_CHECK_COUNT) {
> +				dev_err(dpmaif_ctrl->dev, "TX queue stop failed\n");
> +				break;
> +			}
> +		} while (atomic_read(&txq->tx_processing));

while (atomic_read(...)) {
	...
}


-- 
 i.

