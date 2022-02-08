Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E11F4AD31E
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349438AbiBHIV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349429AbiBHIVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:21:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB920C03FED4;
        Tue,  8 Feb 2022 00:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644308455; x=1675844455;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=cWnjNS2T/J7AT4tEtPiiLipRQKwXs7zYxhjkP9k1ShA=;
  b=cLDG5ySIWPZTBIUWOXGcCZb73Lp+QH3WcQSDDjaHhsZVDrTB37YdWE/A
   ZqX+hPy+7bWNl9OQyhhE+vcVXAlo8p6e6Udb4tGT+oo2NXIosCYvy5u2t
   vjpZyq6QqEbDJNAPOuyzYymdjeFzi2wF5pgXTTD19BQNcmJvX/a3t5qNA
   vYox14nznWcyugl6NEJLNAkoaI37JnZvQ278vni69WliES32xQAvIZHrD
   LyvuPj8+7CLqibeu0OVmE/GDxPnxzZEk9qGJhh8g8Tt+dFPgyLB5kq1Un
   2rTGQSRJKMmaOewRoWYvmbsNpmWMr+T7OMF5oiOaz7vWNxqxYDt+pSklW
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="232466438"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="232466438"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 00:20:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="525460805"
Received: from aanghelu-mobl.ger.corp.intel.com ([10.251.209.174])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 00:20:48 -0800
Date:   Tue, 8 Feb 2022 10:19:14 +0200 (EET)
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
Subject: Re: [PATCH net-next v4 08/13] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <20220114010627.21104-9-ricardo.martinez@linux.intel.com>
Message-ID: <ca592f64-c581-56a8-8d90-5341ebd8932d@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-9-ricardo.martinez@linux.intel.com>
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
> ---

> +	bat_req->bat_mask[idx] = 1;
...
> +		if (!bat_req->bat_mask[index])
...
> +		bat->bat_mask[index] = 0;

Seem to be linux/bitmap.h

I wonder though if the loop in t7xx_dpmaif_avail_pkt_bat_cnt()
could be replaced with arithmetic calculation based on
bat_release_rd_idx and some other idx? It would make the bitmap
unnecessary.

> +static int t7xx_dpmaif_rx_start(struct dpmaif_rx_queue *rxq, const unsigned short pit_cnt,
> +				const unsigned long timeout)
> +{
> +	struct device *dev = rxq->dpmaif_ctrl->dev;
> +	struct dpmaif_cur_rx_skb_info *skb_info;
> +	unsigned short rx_cnt, recv_skb_cnt = 0;

unsigned int

I'd also use unsigned int for all those local variables dealing
with the indexes instead of unsigned short.

> +static int t7xx_dpmaif_rx_data_collect(struct dpmaif_ctrl *dpmaif_ctrl,
> +				       const unsigned char q_num, const int budget)
> +{
> +	struct dpmaif_rx_queue *rxq = &dpmaif_ctrl->rxq[q_num];
> +	unsigned long time_limit;
> +	unsigned int cnt;
> +
> +	time_limit = jiffies + msecs_to_jiffies(DPMAIF_WQ_TIME_LIMIT_MS);
> +
> +	do {
> +		unsigned int rd_cnt;
> +		int real_cnt;
> +
> +		cnt = t7xx_dpmaifq_poll_pit(rxq);
> +		if (!cnt)
> +			break;
> +
> +		if (!rxq->pit_base)
> +			return -EAGAIN;
> +
> +		rd_cnt = cnt > budget ? budget : cnt;

min_t or min (after making budget const unsigned int).

> +		real_cnt = t7xx_dpmaif_rx_start(rxq, rd_cnt, time_limit);
> +		if (real_cnt < 0)
> +			return real_cnt;
> +
> +		if (real_cnt < cnt)
> +			return -EAGAIN;
> +
> +	} while (cnt);

With the break already inside the loop for the same condition,
this check is dead-code.

> +	hw_read_idx = t7xx_dpmaif_ul_get_rd_idx(&dpmaif_ctrl->hif_hw_info, q_num);
> +
> +	new_hw_rd_idx = hw_read_idx / DPMAIF_UL_DRB_ENTRY_WORD;

Is DPMAIF_UL_DRB_ENTRY_WORD size of an entry? In that case it
would probably make sense put it inside t7xx_dpmaif_ul_get_rd_idx?

> +	if (new_hw_rd_idx >= DPMAIF_DRB_ENTRY_SIZE) {

Is DPMAIF_DRB_ENTRY_SIZE telling the number of entries rather than
an "ENTRY_SIZE"? I think these both constant could likely be named 
better.

> +	drb->header_dw1 = cpu_to_le32(FIELD_PREP(DRB_MSG_DTYP, DES_DTYP_MSG));
> +	drb->header_dw1 |= cpu_to_le32(FIELD_PREP(DRB_MSG_CONT, 1));
> +	drb->header_dw1 |= cpu_to_le32(FIELD_PREP(DRB_MSG_PACKET_LEN, pkt_len));
> +
> +	drb->header_dw2 = cpu_to_le32(FIELD_PREP(DRB_MSG_COUNT_L, count_l));
> +	drb->header_dw2 |= cpu_to_le32(FIELD_PREP(DRB_MSG_CHANNEL_ID, channel_id));
> +	drb->header_dw2 |= cpu_to_le32(FIELD_PREP(DRB_MSG_L4_CHK, 1));

I'd do:
drb->header_dw1 = cpu_to_le32(FIELD_PREP(DRB_MSG_DTYP, DES_DTYP_MSG) |
                              FIELD_PREP(DRB_MSG_CONT, 1) |
                              FIELD_PREP(DRB_MSG_PACKET_LEN, pkt_len));


> +static void t7xx_setup_payload_drb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned char q_num,
> +				   unsigned short cur_idx, dma_addr_t data_addr,
> +				   unsigned int pkt_size, char last_one)

bool last_one

> +	struct skb_shared_info *info;

Variable usually called shinfo.

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
> +	cur_idx = t7xx_ring_buf_get_next_wr_idx(txq->drb_size_cnt, cur_idx);
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
> +			atomic_set(&txq->tx_processing, 0);
> +
> +			spin_lock_irqsave(&txq->tx_lock, flags);
> +			txq->drb_wr_idx = drb_wr_idx_backup;
> +			spin_unlock_irqrestore(&txq->tx_lock, flags);

Hmm, can txq's drb_wr_idx get updated (or cleared) by something else
in between these critical sections?

That "TX mapping" comment seems to just state the obvious.

> +static int t7xx_txq_burst_send_skb(struct dpmaif_tx_queue *txq)
> +{
> +	int drb_remain_cnt, i;
> +	unsigned long flags;
> +	int drb_cnt = 0;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&txq->tx_lock, flags);
> +	drb_remain_cnt = t7xx_ring_buf_rd_wr_count(txq->drb_size_cnt, txq->drb_release_rd_idx,
> +						   txq->drb_wr_idx, DPMAIF_WRITE);
> +	spin_unlock_irqrestore(&txq->tx_lock, flags);
> +
> +	for (i = 0; i < DPMAIF_SKB_TX_BURST_CNT; i++) {
> +		struct sk_buff *skb;
> +
> +		spin_lock_irqsave(&txq->tx_skb_lock, flags);
> +		skb = list_first_entry_or_null(&txq->tx_skb_queue, struct sk_buff, list);
> +		spin_unlock_irqrestore(&txq->tx_skb_lock, flags);
> +
> +		if (!skb)
> +			break;
> +
> +		if (drb_remain_cnt < skb->cb[TX_CB_DRB_CNT]) {
> +			spin_lock_irqsave(&txq->tx_lock, flags);
> +			drb_remain_cnt = t7xx_ring_buf_rd_wr_count(txq->drb_size_cnt,
> +								   txq->drb_release_rd_idx,
> +								   txq->drb_wr_idx, DPMAIF_WRITE);
> +			spin_unlock_irqrestore(&txq->tx_lock, flags);
> +			continue;
> +		}
...
> +	if (drb_cnt > 0) {
> +		txq->drb_lack = false;
> +		ret = drb_cnt;
> +	} else if (ret == -ENOMEM) {
> +		txq->drb_lack = true;

Based on the variable name, I'd expect drb_lack be set true when
drb_remain_cnt < skb->cb[TX_CB_DRB_CNT] occurred but that doesn't
happen. Maybe that if branch within loop should set ret = -ENOMEM;
before continue?

It would be nice if the drb check here and in
t7xx_check_tx_queue_drb_available could be consolidated into
a single place. That requires small refactoring (adding __
variant of that function which does just the check).

Please also check the other comments on skb->cb below.

> +		txq_id = t7xx_select_tx_queue(dpmaif_ctrl);
> +		if (txq_id >= 0) {

t7xx_select_tx_queue used to do que_started check (in v2) but it
doesn't anymore so this if is always true these days. I'm left to
wonder though if it was ok to drop that que_started check?

> +static unsigned char t7xx_get_drb_cnt_per_skb(struct sk_buff *skb)
> +{
> +	/* Normal DRB (frags data + skb linear data) + msg DRB */
> +	return skb_shinfo(skb)->nr_frags + 2;
> +}

I'd rename this to t7xx_skb_drb_cnt().

> +int t7xx_dpmaif_tx_send_skb(struct dpmaif_ctrl *dpmaif_ctrl, unsigned int txqt, struct sk_buff *skb)
> +{
> +	bool tx_drb_available = true;
...
> +	send_drb_cnt = t7xx_get_drb_cnt_per_skb(skb);
> +
> +	txq = &dpmaif_ctrl->txq[txqt];
> +	if (!(txq->tx_skb_stat++ % DPMAIF_SKB_TX_BURST_CNT))
> +		tx_drb_available = t7xx_check_tx_queue_drb_available(txq, send_drb_cnt);
> +
> +	if (!tx_drb_available || txq->tx_submit_skb_cnt >= txq->tx_list_max_len) {

Because of the modulo if, drbs might not be available despite
variable claims them to be. Is it intentional?

> +		if (FIELD_GET(DRB_SKB_IS_LAST, drb_skb->config)) {
> +			kfree_skb(drb_skb->skb);

dev_kfree_...?


> +void t7xx_dpmaif_tx_stop(struct dpmaif_ctrl *dpmaif_ctrl)
> +{
> +	int i;
> +
> +	for (i = 0; i < DPMAIF_TXQ_NUM; i++) {
> +		struct dpmaif_tx_queue *txq;
> +		int count;
> +
> +		txq = &dpmaif_ctrl->txq[i];
> +		txq->que_started = false;
> +		/* Ensure tx_processing is changed to 1 before actually begin TX flow */
> +		smp_mb();
> +
> +		/* Confirm that SW will not transmit */
> +		count = 0;
> +
> +		while (atomic_read(&txq->tx_processing)) {

That "Ensure ..." comment should be reworded as it makes little
sense as is for 2 reasons:
- We're in _stop, not begin tx func
- tx_processing isn't changed to 1 here

> +/* SKB control buffer indexed values */
> +#define TX_CB_NETIF_IDX		0
> +#define TX_CB_QTYPE		1
> +#define TX_CB_DRB_CNT		2

The normal way of storing a struct to skb->cb area is:

struct t7xx_skb_cb {
	u8	netif_idx;
	u8	qtype;
	u8	drb_cnt;
};

#define T7XX_SKB_CB(__skb)	((struct t7xx_skb_cb *)&((__skb)->cb[0]))

However, there's only a single txqt/qtype (TXQ_TYPE_DEFAULT) in the 
patchset? And it seems to me that drb_cnt is a value that could be always
derived using t7xx_get_drb_cnt_per_skb() from the skb rather than
stored?

> +#define DRB_PD_DATA_LEN		((u32)GENMASK(31, 16))
Drop the cast?

> +struct dpmaif_drb_skb {
...
> +	u16			config;
> +};
> +
> +#define DRB_SKB_IS_LAST		BIT(15)
> +#define DRB_SKB_IS_FRAG		BIT(14)
> +#define DRB_SKB_IS_MSG		BIT(13)
> +#define DRB_SKB_DRB_IDX		GENMASK(12, 0)

These are not HW related (don't care about endianess)? I guess
C bitfield could be used for them.


-- 
 i.

