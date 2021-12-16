Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16B547717F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhLPMSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:18:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:15932 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229830AbhLPMSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 07:18:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="220153467"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="220153467"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 04:18:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519225023"
Received: from jetten-mobl.ger.corp.intel.com ([10.252.36.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 04:17:54 -0800
Date:   Thu, 16 Dec 2021 14:17:52 +0200 (EET)
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
Subject: Re: [PATCH net-next v3 03/12] net: wwan: t7xx: Add port proxy
 infrastructure
In-Reply-To: <20211207024711.2765-4-ricardo.martinez@linux.intel.com>
Message-ID: <6ac2bf45-c61b-7716-5dcf-6945591a3cc3@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-4-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>


> +		status = FIELD_GET(HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
> +		if (status == PORT_CH_STATUS_RX) {
> +			port->skb_handler(port, skb);

In the other callsite, port->skb_handler is checked for NULL but not here,
is it ok?

> +		if (md_state == MD_STATE_EXCEPTION && port_static->tx_ch != PORT_CH_MD_LOG_TX &&
> +		    port_static->tx_ch != PORT_CH_UART1_TX)
> +			return -ETXTBSY;

Here "TXT" = "text" (it seems unrelated to TX path).

> +#define MTK_MAX_QUEUE_NUM	16
> +#define MAX_RX_QUEUE_LENGTH	32
> +#define MAX_CTRL_QUEUE_LENGTH	16

MTK_QUEUES, RX_QUEUE_MAXLEN, CTRL_QUEUE_MAXLEN would be shorter and not
lose any of the meaning.

> +#define CLDMA_TXQ_MTU		MTK_SKB_4K
> +
> +struct port_proxy {
> +	int				port_number;
> +	struct t7xx_port_static		*ports_shared;
> +	struct t7xx_port		*ports_private;
> +	struct list_head		rx_ch_ports[PORT_CH_ID_MASK];

An off-by-one error in the array sizing?


-- 
 i.

