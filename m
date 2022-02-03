Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF4B4A8625
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbiBCOYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:24:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:31771 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240146AbiBCOYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 09:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643898243; x=1675434243;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=mZITRt8XHZzpLCxK3Nbh5HG0CKWyna47vd4e3NgzEP4=;
  b=EkyY9IP+GMf4QF0dJ+tXpGmNLH5rWSMX2otQ+r48aKz1RV+tEVqu9p4L
   AaQayXDvho8fnoa7qe7wWG17uhELQPE+2CitOgGE5QuWTCXSgcM5vGRSz
   at3UEPRmjsru/EEejthkQQuPYW/qK7g24csSaOukjEsdcq3m5lGEgjTV3
   kduIKEId9fUB+NxWqyZbIXD9MlC6ppG64sPyJ/v9AoWXgN96NRq6jO49f
   4714O6dEEqKbIRSjTywz8CMJp1ynwAaWwxUKUkuivCIoO7fcc/omBdO/Z
   9KLYnkR2bBSfk4phW+/GY56MdzPDlqBRH13M59nU0jUMSQpDarAcFN6wm
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="247917409"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="247917409"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 06:24:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="699326249"
Received: from unknown (HELO ijarvine-MOBL2.mshome.net) ([10.237.66.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 06:23:55 -0800
Date:   Thu, 3 Feb 2022 16:23:49 +0200 (EET)
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
Message-ID: <1fd3d71c-d10-9feb-64c0-206a308b51d5@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-9-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

> +	unsigned short		last_ch_id;
Values is never used.

> +	if (old_rl_idx > old_wr_idx && new_wr_idx >= old_rl_idx) {
> +		dev_err(dpmaif_ctrl->dev, "RX BAT flow check fail\n");
> +		return -EINVAL;
> +	}
> +
> +	if (new_wr_idx >= bat_req->bat_size_cnt) {
> +		new_wr_idx -= bat_req->bat_size_cnt;
> +		if (new_wr_idx >= old_rl_idx) {
> +			dev_err(dpmaif_ctrl->dev, "RX BAT flow check fail\n");
> +			return -EINVAL;
> +		}

Make a label for the identical block and goto there.

> +static void t7xx_unmap_bat_skb(struct device *dev, struct dpmaif_bat_skb *bat_skb_base,
> +			       unsigned int index)
> +{
> +	struct dpmaif_bat_skb *bat_skb = bat_skb_base + index;
> +
> +	if (bat_skb->skb) {
> +		dma_unmap_single(dev, bat_skb->data_bus_addr, bat_skb->data_len, DMA_FROM_DEVICE);
> +		kfree_skb(bat_skb->skb);

For consistency, dev_kfree_skb?

> + * @initial: Indicates if the ring is being populated for the first time.
> + *
> + * Allocate skb and store the start address of the data buffer into the BAT ring.
> + * If this is not the initial call, notify the HW about the new entries.
> + *
> + * Return:
> + * * 0		- Success.
> + * * -ERROR	- Error code from failure sub-initializations.
> + */
> +int t7xx_dpmaif_rx_buf_alloc(struct dpmaif_ctrl *dpmaif_ctrl,
> +			     const struct dpmaif_bat_request *bat_req,
> +			     const unsigned char q_num, const unsigned int buf_cnt,
> +			     const bool initial)

vs its prototype:

+int t7xx_dpmaif_rx_buf_alloc(struct dpmaif_ctrl *dpmaif_ctrl,
+                            const struct dpmaif_bat_request *bat_req, const unsigned char q_num,
+                            const unsigned int buf_cnt, const bool first_time);

> +int t7xx_dpmaif_rx_frag_alloc(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_bat_request *bat_req,
> +			      const unsigned int buf_cnt, const bool initial)
> +{
> +	struct dpmaif_bat_page *bat_skb = bat_req->bat_skb;
> +	unsigned short cur_bat_idx = bat_req->bat_wr_idx;
> +	unsigned int buf_space;
> +	int ret, i;
...
> +	ret = i < buf_cnt ? -ENOMEM : 0;
> +	if (ret && initial) {

int ret = 0, i;
...
if (i < buf_cnt) {
	ret = -ENOMEM;
	if (initial) {
		...
	}
}

> +	if (!tx_drb_available || txq->tx_submit_skb_cnt >= txq->tx_list_max_len) {
> +		cb = dpmaif_ctrl->callbacks;
> +		cb->state_notify(dpmaif_ctrl->t7xx_dev, DMPAIF_TXQ_STATE_FULL, txqt);
> +		return -EBUSY;
> +	}
> +
> +	skb->cb[TX_CB_QTYPE] = txqt;
> +	skb->cb[TX_CB_DRB_CNT] = send_drb_cnt;
> +
> +	spin_lock_irqsave(&txq->tx_skb_lock, flags);
> +	list_add_tail(&skb->list, &txq->tx_skb_queue);
> +	txq->tx_submit_skb_cnt++;
> +	spin_unlock_irqrestore(&txq->tx_skb_lock, flags);

Perhaps the critical section needs to start earlier to enforce that 
tx_list_max_len check?


(I'm yet to read half of this patch...)

-- 
 i.

