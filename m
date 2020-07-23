Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341DE22B3A0
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbgGWQe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:34:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:1834 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgGWQez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:34:55 -0400
IronPort-SDR: vyL+NYt2ZliHRJRxL72e/ahPc7G4EE9VaxJ+UuM8hBgJ2hmx8gy+XrUo3YgeLRskcAHNr1pHsm
 b5y1V1mcwhgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235445608"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="235445608"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 09:34:53 -0700
IronPort-SDR: hFYas6QKNxTOrvEjECjOw3UCjMCf0bwK7XQddFbktkt1InLwc36SCtegqV7XT10e6Occd/2a3J
 fvubPKBrLB2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="432795981"
Received: from tthayer-hp-z620.an.intel.com (HELO [10.122.105.146]) ([10.122.105.146])
  by orsmga004.jf.intel.com with ESMTP; 23 Jul 2020 09:34:52 -0700
Reply-To: thor.thayer@linux.intel.com
Subject: Re: [PATCH v4 04/10] net: eth: altera: add optional function to start
 tx dma
To:     "Ooi, Joyce" <joyce.ooi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>,
        Dalon Westergreen <dalon.westergreen@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
 <20200708072401.169150-5-joyce.ooi@intel.com>
From:   Thor Thayer <thor.thayer@linux.intel.com>
Message-ID: <8d16280c-af08-ac70-dcee-2646ccefc820@linux.intel.com>
Date:   Thu, 23 Jul 2020 11:35:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708072401.169150-5-joyce.ooi@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 2:23 AM, Ooi, Joyce wrote:
> From: Dalon Westergreen <dalon.westergreen@intel.com>
> 
> Allow for optional start up of tx dma if the start_txdma
> function is defined in altera_dmaops.
> 
> Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> ---
> v2: no change
> v3: no change
> v4: no change
> ---
>   drivers/net/ethernet/altera/altera_tse.h      | 1 +
>   drivers/net/ethernet/altera/altera_tse_main.c | 5 +++++
>   2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/altera/altera_tse.h b/drivers/net/ethernet/altera/altera_tse.h
> index 7d0c98fc103e..26c5541fda27 100644
> --- a/drivers/net/ethernet/altera/altera_tse.h
> +++ b/drivers/net/ethernet/altera/altera_tse.h
> @@ -401,6 +401,7 @@ struct altera_dmaops {
>   	int (*init_dma)(struct altera_tse_private *priv);
>   	void (*uninit_dma)(struct altera_tse_private *priv);
>   	void (*start_rxdma)(struct altera_tse_private *priv);
> +	void (*start_txdma)(struct altera_tse_private *priv);
>   };
>   
>   /* This structure is private to each device.
> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
> index a3749ffdcac9..0a724e4d2c8c 100644
> --- a/drivers/net/ethernet/altera/altera_tse_main.c
> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
> @@ -1244,6 +1244,9 @@ static int tse_open(struct net_device *dev)
>   
>   	priv->dmaops->start_rxdma(priv);
>   
> +	if (priv->dmaops->start_txdma)
> +		priv->dmaops->start_txdma(priv);
> +
>   	/* Start MAC Rx/Tx */
>   	spin_lock(&priv->mac_cfg_lock);
>   	tse_set_mac(priv, true);
> @@ -1646,6 +1649,7 @@ static const struct altera_dmaops altera_dtype_sgdma = {
>   	.init_dma = sgdma_initialize,
>   	.uninit_dma = sgdma_uninitialize,
>   	.start_rxdma = sgdma_start_rxdma,
> +	.start_txdma = NULL,
>   };
>   
>   static const struct altera_dmaops altera_dtype_msgdma = {
> @@ -1665,6 +1669,7 @@ static const struct altera_dmaops altera_dtype_msgdma = {
>   	.init_dma = msgdma_initialize,
>   	.uninit_dma = msgdma_uninitialize,
>   	.start_rxdma = msgdma_start_rxdma,
> +	.start_txdma = NULL,
>   };
>   
>   static const struct of_device_id altera_tse_ids[] = {
> 
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
