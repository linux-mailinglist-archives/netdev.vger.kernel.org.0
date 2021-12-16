Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DFA4771B1
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhLPMZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:25:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:5945 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236595AbhLPMZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 07:25:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="237013841"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="237013841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 04:25:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519227912"
Received: from jetten-mobl.ger.corp.intel.com ([10.252.36.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 04:25:49 -0800
Date:   Thu, 16 Dec 2021 14:25:47 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
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
Subject: Re: [PATCH net-next v3 05/12] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
In-Reply-To: <20211207024711.2765-6-ricardo.martinez@linux.intel.com>
Message-ID: <66e09242-ee3e-f714-a9b9-d3ee80ef6596@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-6-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> 
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.
> 
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> +{
> +	struct t7xx_port *port_private = wwan_port_get_drvdata(port);
> +	size_t actual_count = 0, alloc_size = 0, txq_mtu = 0;
> +	struct t7xx_port_static *port_static;
> +	int i, multi_packet = 1, ret = 0;
> +	struct sk_buff *skb_ccci = NULL;
> +	struct t7xx_fsm_ctl *ctl;
> +	enum md_state md_state;
> +	unsigned int count;
> +	bool port_multi;
> +
> +	count = skb->len;
> +	if (!count)
> +		return -EINVAL;
> +
> +	port_static = port_private->port_static;
> +	ctl = port_private->t7xx_dev->md->fsm_ctl;
> +	md_state = t7xx_fsm_get_md_state(ctl);
> +	if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
> +		dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
> +			 port_static->name, md_state);
> +		return -ENODEV;
> +	}
> +
> +	txq_mtu = CLDMA_TXQ_MTU;
> +
> +	if (port_private->flags & PORT_F_USER_HEADER) {
> +		if (port_private->flags & PORT_F_USER_HEADER && count > txq_mtu) {
> +			dev_err(port_private->dev, "Packet %u larger than MTU on %s port\n",
> +				count, port_static->name);
> +			return -ENOMEM;
> +		}
> +
> +		alloc_size = min_t(size_t, txq_mtu, count);
> +		actual_count = alloc_size;
> +	} else {
> +		alloc_size = min_t(size_t, txq_mtu, count + CCCI_H_ELEN);
> +		actual_count = alloc_size - CCCI_H_ELEN;
> +		port_multi = t7xx_port_wwan_multipkt_capable(port_static);
> +		if ((count + CCCI_H_ELEN > txq_mtu) && port_multi)
> +			multi_packet = DIV_ROUND_UP(count, txq_mtu - CCCI_H_ELEN);
> +	}
> +
> +	for (i = 0; i < multi_packet; i++) {
> +		struct ccci_header *ccci_h = NULL;
> +
> +		if (multi_packet > 1 && multi_packet == i + 1) {
> +			actual_count = count % (txq_mtu - CCCI_H_ELEN);
> +			alloc_size = actual_count + CCCI_H_ELEN;
> +		}
> +
> +		skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
> +		if (!skb_ccci)
> +			return -ENOMEM;
> +
> +		ccci_h = skb_put(skb_ccci, CCCI_H_LEN);
> +		ccci_h->packet_header = 0;
> +		ccci_h->packet_len = cpu_to_le32(actual_count + CCCI_H_LEN);
> +		ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
> +		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, port_static->tx_ch));
> +		ccci_h->ex_msg = 0;
> +
> +		memcpy(skb_put(skb_ccci, actual_count), skb->data + i * (txq_mtu - CCCI_H_ELEN),
> +		       actual_count);
> +
> +		t7xx_port_proxy_set_seq_num(port_private, ccci_h);
> +
> +		ret = t7xx_port_send_skb_to_md(port_private, skb_ccci, true);
> +		if (ret)
> +			goto err_free_skb;
> +
> +		port_private->seq_nums[MTK_TX]++;
> +
> +		if (multi_packet == 1)
> +			return actual_count;
> +		else if (multi_packet == i + 1)
> +			return count;
> +	}

I'd recommend renaming variables to make it clearer what they count:
- count -> bytes
- actual_count -> actual_bytes
- multi_packet -> packets


-- 
 i.

