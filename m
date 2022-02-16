Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF224B7D42
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbiBPCSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:18:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiBPCSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:18:05 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0250CC0848;
        Tue, 15 Feb 2022 18:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644977874; x=1676513874;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=btqFkqzI2RBR1zMFFYo/YiodCLmLaxd3w5P6EnHJaGA=;
  b=W+4EruDUig1ipYL7/FRhxibyu1J8rVQ4VYrmCJud/49gV1WOtJkudb+D
   lWFe2hOOvk6qxaDudrK0MppwsILuxkF7Qp8FGIt+kJoYfngN15PYJSf3C
   4WyNIzo/N4MlCAidPCTDnqUHond/1RnuiHrGNY5hNaMi21jBaQlxFbbS+
   nUtN/6N+S0q3kUa1dqDdwOqgL3XqaS0MZ0PuxRknLbvA04uVTVwZyg+Mk
   W2W3C4B5j+SSOjM0vGi9GIZzuRDKCfy2VpkpHtR6dTUr9GXYI4k8W8Yfg
   zNGu8OvBIETJM4u78c83JtaUtCxEFXz8heRM5fC3zA0jDbw2MKtEHcpCI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="249336855"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="249336855"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:17:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="704083159"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.241.199]) ([10.212.241.199])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 18:17:53 -0800
Message-ID: <05b6a2dd-f485-ce4a-d508-e90f9304d016@linux.intel.com>
Date:   Tue, 15 Feb 2022 18:17:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v4 08/13] net: wwan: t7xx: Add data path
 interface
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
        sreehari.kancharla@intel.com
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-9-ricardo.martinez@linux.intel.com>
 <ca592f64-c581-56a8-8d90-5341ebd8932d@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <ca592f64-c581-56a8-8d90-5341ebd8932d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/8/2022 12:19 AM, Ilpo Järvinen wrote:
> On Thu, 13 Jan 2022, Ricardo Martinez wrote:
>
>> From: Haijun Liu <haijun.liu@mediatek.com>
>>
>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>> for initialization, ISR, control and event handling of TX/RX flows.
...
>
>> +	spin_lock_irqsave(&txq->tx_lock, flags);
>> +	cur_idx = txq->drb_wr_idx;
>> +	drb_wr_idx_backup = cur_idx;
>> +
>> +	txq->drb_wr_idx += send_cnt;
>> +	if (txq->drb_wr_idx >= txq->drb_size_cnt)
>> +		txq->drb_wr_idx -= txq->drb_size_cnt;
>> +
>> +	t7xx_setup_msg_drb(dpmaif_ctrl, txq->index, cur_idx, skb->len, 0, skb->cb[TX_CB_NETIF_IDX]);
>> +	t7xx_record_drb_skb(dpmaif_ctrl, txq->index, cur_idx, skb, 1, 0, 0, 0, 0);
>> +	spin_unlock_irqrestore(&txq->tx_lock, flags);
>> +
>> +	cur_idx = t7xx_ring_buf_get_next_wr_idx(txq->drb_size_cnt, cur_idx);
>> +
>> +	for (wr_cnt = 0; wr_cnt < payload_cnt; wr_cnt++) {
>> +		if (!wr_cnt) {
>> +			data_len = skb_headlen(skb);
>> +			data_addr = skb->data;
>> +			is_frag = false;
>> +		} else {
>> +			skb_frag_t *frag = info->frags + wr_cnt - 1;
>> +
>> +			data_len = skb_frag_size(frag);
>> +			data_addr = skb_frag_address(frag);
>> +			is_frag = true;
>> +		}
>> +
>> +		if (wr_cnt == payload_cnt - 1)
>> +			is_last_one = true;
>> +
>> +		/* TX mapping */
>> +		bus_addr = dma_map_single(dpmaif_ctrl->dev, data_addr, data_len, DMA_TO_DEVICE);
>> +		if (dma_mapping_error(dpmaif_ctrl->dev, bus_addr)) {
>> +			dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
>> +			atomic_set(&txq->tx_processing, 0);
>> +
>> +			spin_lock_irqsave(&txq->tx_lock, flags);
>> +			txq->drb_wr_idx = drb_wr_idx_backup;
>> +			spin_unlock_irqrestore(&txq->tx_lock, flags);
> Hmm, can txq's drb_wr_idx get updated (or cleared) by something else
> in between these critical sections?
drb_wr_idx cannot be modified inbetween, but it can be used to calculate 
the number of DRBs available, which shouldn't be a problem.
The function is reserving the DRBs at the beginning, in the rare case of 
error it will release them.
...
> +		txq_id = t7xx_select_tx_queue(dpmaif_ctrl);
> +		if (txq_id >= 0) {
> t7xx_select_tx_queue used to do que_started check (in v2) but it
> doesn't anymore so this if is always true these days. I'm left to
> wonder though if it was ok to drop that que_started check?

The que_started check wasn't supposed to be dropped, I'll add it back.

...

>> +/* SKB control buffer indexed values */
>> +#define TX_CB_NETIF_IDX		0
>> +#define TX_CB_QTYPE		1
>> +#define TX_CB_DRB_CNT		2
> The normal way of storing a struct to skb->cb area is:
>
> struct t7xx_skb_cb {
> 	u8	netif_idx;
> 	u8	qtype;
> 	u8	drb_cnt;
> };
>
> #define T7XX_SKB_CB(__skb)	((struct t7xx_skb_cb *)&((__skb)->cb[0]))
>
> However, there's only a single txqt/qtype (TXQ_TYPE_DEFAULT) in the
> patchset? And it seems to me that drb_cnt is a value that could be always
> derived using t7xx_get_drb_cnt_per_skb() from the skb rather than
> stored?

The next iteration will contain t7xx_tx_skb_cb and t7xx_rx_skb_cb 
structures.

Also, q_number is going to be used instead of qtype.

Only one queue is used but I think we can keep this code generic as it 
is straight forward (not like the drb_lack case), any thoughts?

>> +#define DRB_PD_DATA_LEN		((u32)GENMASK(31, 16))
> Drop the cast?

The cast was added to avoid a compiler warning about truncated bits.

I'll move it to the place where it is required:

drb->header &= cpu_to_le32(~(u32)DRB_PD_DATA_LEN);

...

