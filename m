Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53B48CF18
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbiALX12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:27:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:22914 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235421AbiALX12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 18:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642030048; x=1673566048;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KtQ/owbWjK6HG+TVAL3VKKbtDPtAaWOC4lqP8oGoJuU=;
  b=X/Xvg8ae3VOuhEuiByeQ6R4wojHkrYlltgYMQ8hQxrCNJYEEyfKFBUHy
   a6weUJiw/0w+OX3L5X/2cOQqOc9XsoCZB+zU1bivE3P+dK0MFZF9tijeA
   U+9cE/oWO7foMKOiRRNRFk8qdE9ViAuz5hf/S+dsjzfjxvyL+PjAcJCSc
   sk2hVFcpEym1Wcgn58Qs7YjD6X59a3Kc6TRuTPIinPo69iFRqlFrlosuN
   nZwQbfH2JWu+fdFAEGq3dnZzncxZvOimV88RIEtB+kOcbrVl+GrkpJ5ID
   +mpNnYa8pMv5A6Vnpopz7SEtDyFR53ykAmoVz5Ro7zOd/cgpD+ZNJ1lG+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="268224003"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="268224003"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:27:27 -0800
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; 
   d="scan'208";a="515698389"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.104.69]) ([10.209.104.69])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 15:27:27 -0800
Message-ID: <b203030d-7120-5ed3-9543-0e4d2ff08c10@linux.intel.com>
Date:   Wed, 12 Jan 2022 15:27:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v3 07/12] net: wwan: t7xx: Add data path
 interface
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-8-ricardo.martinez@linux.intel.com>
 <5154c2b5-4b94-fcfb-fbdc-8d3dcacc34de@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <5154c2b5-4b94-fcfb-fbdc-8d3dcacc34de@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/16/2021 5:30 AM, Ilpo Järvinen wrote:
...
>
>> +	for (i = 0; i < alloc_cnt; i++) {
>> +		unsigned short cur_bat_idx = bat_start_idx + i;
>> +		struct dpmaif_bat_skb *cur_skb;
>> +		struct dpmaif_bat *cur_bat;
>> +
>> +		if (cur_bat_idx >= bat_max_cnt)
>> +			cur_bat_idx -= bat_max_cnt;
>> +
>> +		cur_skb = (struct dpmaif_bat_skb *)bat_req->bat_skb + cur_bat_idx;
>> +		if (!cur_skb->skb) {
>> +			struct dpmaif_skb_info *skb_info;
>> +
>> +			skb_info = t7xx_dpmaif_dev_alloc_skb(dpmaif_ctrl, bat_req->pkt_buf_sz);
>> +			if (!skb_info)
>> +				break;
>> +
>> +			cur_skb->skb = skb_info->skb;
>> +			cur_skb->data_bus_addr = skb_info->data_bus_addr;
>> +			cur_skb->data_len = skb_info->data_len;
>> +			kfree(skb_info);
> It seems that here you do an alloc that is immediately followed by kfree.
> Couldn't this be solved by passing cur_skb to a function which assigns
> those values you want directly to it?

Yes, alloc removed in the next version.

...

>
>> +int t7xx_dpmaif_rx_frag_alloc(struct dpmaif_ctrl *dpmaif_ctrl, struct dpmaif_bat_request *bat_req,
>> +			      const unsigned int buf_cnt, const bool initial)
>> +{
>> +	struct dpmaif_bat_page *bat_skb = bat_req->bat_skb;
>> +	unsigned short cur_bat_idx = bat_req->bat_wr_idx;
>> +	unsigned int buf_space;
>> +	int i;
>> +
>> +	if (!buf_cnt || buf_cnt > bat_req->bat_size_cnt)
>> +		return -EINVAL;
>> +
>> +	buf_space = t7xx_ring_buf_rd_wr_count(bat_req->bat_size_cnt,
>> +					      bat_req->bat_release_rd_idx, bat_req->bat_wr_idx,
>> +					      DPMAIF_WRITE);
>> +	if (buf_cnt > buf_space) {
>> +		dev_err(dpmaif_ctrl->dev,
>> +			"Requested more buffers than the space available in RX frag ring\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	for (i = 0; i < buf_cnt; i++) {
>> +		struct dpmaif_bat_page *cur_page = bat_skb + cur_bat_idx;
>> +		struct dpmaif_bat *cur_bat;
>> +		dma_addr_t data_base_addr;
>> +
>> +		if (!cur_page->page) {
>> +			unsigned long offset;
>> +			struct page *page;
>> +			void *data;
>> +
>> +			data = netdev_alloc_frag(bat_req->pkt_buf_sz);
>> +			if (!data)
>> +				break;
>> +
>> +			page = virt_to_head_page(data);
>> +			offset = data - page_address(page);
>> +
>> +			data_base_addr = dma_map_page(dpmaif_ctrl->dev, page, offset,
>> +						      bat_req->pkt_buf_sz, DMA_FROM_DEVICE);
>> +			if (dma_mapping_error(dpmaif_ctrl->dev, data_base_addr)) {
>> +				dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
>> +				put_page(virt_to_head_page(data));
>> +				break;
>> +			}
>> +
>> +			cur_page->page = page;
>> +			cur_page->data_bus_addr = data_base_addr;
>> +			cur_page->offset = offset;
>> +			cur_page->data_len = bat_req->pkt_buf_sz;
>> +		}
>> +
>> +		data_base_addr = cur_page->data_bus_addr;
>> +		cur_bat = (struct dpmaif_bat *)bat_req->bat_base + cur_bat_idx;
>> +		cur_bat->buffer_addr_ext = upper_32_bits(data_base_addr);
>> +		cur_bat->p_buffer_addr = lower_32_bits(data_base_addr);
>> +		cur_bat_idx = t7xx_ring_buf_get_next_wrdx(bat_req->bat_size_cnt, cur_bat_idx);
>> +	}
>> +
>> +	if (i < buf_cnt)
>> +		return -ENOMEM;
>> +	bat_req->bat_wr_idx = cur_bat_idx;
> Is there some leak if this early returns and does not update bat_wr_idx?
> One call path seems to eventually just ignore error code.

Yes, the code should not return here. Also need to unmap the pages in 
case of error.

...

>> +static int t7xx_dpmaif_rx_start(struct dpmaif_rx_queue *rxq, const unsigned short pit_cnt,
>> +				const unsigned long timeout)
>> +{
>> +	struct device *dev = rxq->dpmaif_ctrl->dev;
>> +	struct dpmaif_cur_rx_skb_info *skb_info;
>> +	unsigned short rx_cnt, recv_skb_cnt = 0;
>> +	unsigned int cur_pit, pit_len;
>> +	int ret = 0, ret_hw = 0;
>> +
>> +	pit_len = rxq->pit_size_cnt;
>> +	skb_info = &rxq->rx_data_info;
>> +	cur_pit = rxq->pit_rd_idx;
>> +
>> +	for (rx_cnt = 0; rx_cnt < pit_cnt; rx_cnt++) {
>> +		struct dpmaif_normal_pit *pkt_info;
>> +		u32 val;
>> +
>> +		if (!skb_info->msg_pit_received && time_after_eq(jiffies, timeout))
>> +			break;
>> +
>> +		pkt_info = (struct dpmaif_normal_pit *)rxq->pit_base + cur_pit;
>> +		if (t7xx_dpmaif_check_pit_seq(rxq, pkt_info)) {
>> +			dev_err_ratelimited(dev, "RXQ%u checks PIT SEQ fail\n", rxq->index);
>> +			return -EAGAIN;
>> +		}
>> +
>> +		val = FIELD_GET(NORMAL_PIT_PACKET_TYPE, le32_to_cpu(pkt_info->pit_header));
>> +		if (val == DES_PT_MSG) {
>> +			if (skb_info->msg_pit_received)
>> +				dev_err(dev, "RXQ%u received repeated PIT\n", rxq->index);
>> +
>> +			skb_info->msg_pit_received = true;
>> +			t7xx_dpmaif_parse_msg_pit(rxq, (struct dpmaif_msg_pit *)pkt_info,
>> +						  skb_info);
>> +		} else { /* DES_PT_PD */
>> +			val = FIELD_GET(NORMAL_PIT_BUFFER_TYPE, le32_to_cpu(pkt_info->pit_header));
>> +			if (val != PKT_BUF_FRAG)
>> +				ret = t7xx_dpmaif_get_rx_pkt(rxq, pkt_info, skb_info);
>> +			else if (!skb_info->cur_skb)
>> +				ret = -EINVAL;
>> +			else
>> +				ret = t7xx_dpmaif_get_frag(rxq, pkt_info, skb_info);
>> +
>> +			if (ret < 0) {
>> +				skb_info->err_payload = 1;
>> +				dev_err_ratelimited(dev, "RXQ%u error payload\n", rxq->index);
>> +			}
>> +
>> +			val = FIELD_GET(NORMAL_PIT_CONT, le32_to_cpu(pkt_info->pit_header));
>> +			if (!val) {
>> +				if (!skb_info->err_payload) {
>> +					t7xx_dpmaif_rx_skb(rxq, skb_info);
>> +				} else if (skb_info->cur_skb) {
>> +					dev_kfree_skb_any(skb_info->cur_skb);
>> +					skb_info->cur_skb = NULL;
>> +				}
>> +
>> +				memset(skb_info, 0, sizeof(*skb_info));
>> +
>> +				recv_skb_cnt++;
>> +				if (!(recv_skb_cnt & DPMAIF_RX_PUSH_THRESHOLD_MASK)) {
>> +					wake_up_all(&rxq->rx_wq);
>> +					recv_skb_cnt = 0;
>> +				}
>> +			}
>> +		}
>> +
>> +		cur_pit = t7xx_ring_buf_get_next_wrdx(pit_len, cur_pit);
>> +		rxq->pit_rd_idx = cur_pit;
>> +		rxq->pit_remain_release_cnt++;
>> +
>> +		if (rx_cnt > 0 && !(rx_cnt % DPMAIF_NOTIFY_RELEASE_COUNT)) {
>> +			ret_hw = t7xx_dpmaifq_rx_notify_hw(rxq);
>> +			if (ret_hw < 0)
>> +				break;
>> +		}
>> +	}
>> +
>> +	if (recv_skb_cnt)
>> +		wake_up_all(&rxq->rx_wq);
>> +
>> +	if (!ret_hw)
>> +		ret_hw = t7xx_dpmaifq_rx_notify_hw(rxq);
>> +
>> +	if (ret_hw < 0 && !ret)
>> +		ret = ret_hw;
>> +
>> +	return ret < 0 ? ret : rx_cnt;
>> +}
> ret variable handling seems odd, loop overwrites prev errors. Is there
> perhaps a break missing from somewhere as post loop checks seem to care
> about the value of ret variable?

ret should not be used outside of the loop, the error handling will be 
cleaned up in the

next version.

ret tells if the payload is good, in the unlikely case of error, the 
loop can continue

with the next packet.


