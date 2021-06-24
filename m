Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB43B39AE
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 01:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFXXUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 19:20:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:30667 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhFXXUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 19:20:33 -0400
IronPort-SDR: 5r3iESg80Mks136Y5VTjz2bcP1dY4MmRnOGVyeynw46LDHfJB6RuDk0BEkV7DIrJuo1zHQFJXa
 tQ8f98IMvnFQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="204566606"
X-IronPort-AV: E=Sophos;i="5.83,297,1616482800"; 
   d="scan'208";a="204566606"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 16:18:12 -0700
IronPort-SDR: XtdU2V9Y4JHphMCTtOSe6BKj/dN4RO81C5hpswDBLyl51IHaR3zBnqPCiTJQhncw+YrtwMBkYy
 RR/Vtm5rhZlQ==
X-IronPort-AV: E=Sophos;i="5.83,297,1616482800"; 
   d="scan'208";a="487956572"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.175.27]) ([10.212.175.27])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 16:18:12 -0700
Subject: Re: [PATCH net-next 12/16] gve: DQO: Add core netdev features
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
References: <20210624180632.3659809-1-bcf@google.com>
 <20210624180632.3659809-13-bcf@google.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <793c316c-e367-bf55-c4da-f4fc3d4aa587@intel.com>
Date:   Thu, 24 Jun 2021 16:18:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624180632.3659809-13-bcf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/2021 11:06 AM, Bailey Forrest wrote:
> Add napi netdev device registration, interrupt handling and initial tx
> and rx polling stubs. The stubs will be filled in follow-on patches.
>
> Also:
> - LRO feature advertisement and handling
> - Also update ethtool logic
>
> Signed-off-by: Bailey Forrest <bcf@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>
> ---
>   drivers/net/ethernet/google/gve/Makefile      |   2 +-
>   drivers/net/ethernet/google/gve/gve.h         |   2 +
>   drivers/net/ethernet/google/gve/gve_adminq.c  |   2 +
>   drivers/net/ethernet/google/gve/gve_dqo.h     |  32 +++
>   drivers/net/ethernet/google/gve/gve_ethtool.c |  12 +-
>   drivers/net/ethernet/google/gve/gve_main.c    | 188 ++++++++++++++++--
>   drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  24 +++
>   drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  23 +++
>   8 files changed, 260 insertions(+), 25 deletions(-)
>   create mode 100644 drivers/net/ethernet/google/gve/gve_dqo.h
>   create mode 100644 drivers/net/ethernet/google/gve/gve_rx_dqo.c
>   create mode 100644 drivers/net/ethernet/google/gve/gve_tx_dqo.c
>
> diff --git a/drivers/net/ethernet/google/gve/Makefile b/drivers/net/ethernet/google/gve/Makefile
> index 0143f4471e42..b9a6be76531b 100644
> --- a/drivers/net/ethernet/google/gve/Makefile
> +++ b/drivers/net/ethernet/google/gve/Makefile
> @@ -1,4 +1,4 @@
>   # Makefile for the Google virtual Ethernet (gve) driver
>   
>   obj-$(CONFIG_GVE) += gve.o
> -gve-objs := gve_main.o gve_tx.o gve_rx.o gve_ethtool.o gve_adminq.o gve_utils.o
> +gve-objs := gve_main.o gve_tx.o gve_tx_dqo.o gve_rx.o gve_rx_dqo.o gve_ethtool.o gve_adminq.o gve_utils.o
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index 8a2a8d125090..d6bf0466ae8b 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -45,6 +45,8 @@
>   /* PTYPEs are always 10 bits. */
>   #define GVE_NUM_PTYPES	1024
>   
> +#define GVE_RX_BUFFER_SIZE_DQO 2048
> +
>   /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
>   struct gve_rx_desc_queue {
>   	struct gve_rx_desc *desc_ring; /* the descriptor ring */
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> index cf017a499119..5bb56b454541 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -714,6 +714,8 @@ int gve_adminq_describe_device(struct gve_priv *priv)
>   	if (gve_is_gqi(priv)) {
>   		err = gve_set_desc_cnt(priv, descriptor);
>   	} else {
> +		/* DQO supports LRO. */
> +		priv->dev->hw_features |= NETIF_F_LRO;

Shouldn't this be NETIF_F_HW_GRO?
Also, what does DQO stands for?

<snip>

