Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB43622B38D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 18:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgGWQdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 12:33:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:13091 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbgGWQdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 12:33:21 -0400
IronPort-SDR: zCzc++Q1cdPBcyzZy46Lt8VjJHhnY6azMAnpVg6DcQavuSnlFEhww4fVnFbthyaH/XXFQ1//pC
 35zvFyh2ySJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="148063547"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="148063547"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 09:33:16 -0700
IronPort-SDR: bgQ4aMCQfoq0FglAYc7zDUVVA2o0FiHljvg95X3OW5Mmpqs6Ovmp7CpQb5zBStfU5V6DsgB3Wx
 3ug7Afi2ys9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="432795632"
Received: from tthayer-hp-z620.an.intel.com (HELO [10.122.105.146]) ([10.122.105.146])
  by orsmga004.jf.intel.com with ESMTP; 23 Jul 2020 09:33:14 -0700
Reply-To: thor.thayer@linux.intel.com
Subject: Re: [PATCH v4 02/10] net: eth: altera: set rx and tx ring size before
 init_dma call
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
 <20200708072401.169150-3-joyce.ooi@intel.com>
From:   Thor Thayer <thor.thayer@linux.intel.com>
Message-ID: <4b1e146d-c147-7c15-dd1c-9ac5abb85641@linux.intel.com>
Date:   Thu, 23 Jul 2020 11:33:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708072401.169150-3-joyce.ooi@intel.com>
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
> It is more appropriate to set the rx and tx ring size before calling
> the init function for the dma.
> 
> Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> ---
> v2: no change
> v3: no change
> v4: no change
> ---
>   drivers/net/ethernet/altera/altera_tse_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
> index ec2b36e05c3f..a3749ffdcac9 100644
> --- a/drivers/net/ethernet/altera/altera_tse_main.c
> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
> @@ -1154,6 +1154,10 @@ static int tse_open(struct net_device *dev)
>   	int i;
>   	unsigned long int flags;
>   
> +	/* set tx and rx ring size */
> +	priv->rx_ring_size = dma_rx_num;
> +	priv->tx_ring_size = dma_tx_num;
> +
>   	/* Reset and configure TSE MAC and probe associated PHY */
>   	ret = priv->dmaops->init_dma(priv);
>   	if (ret != 0) {
> @@ -1196,8 +1200,6 @@ static int tse_open(struct net_device *dev)
>   	priv->dmaops->reset_dma(priv);
>   
>   	/* Create and initialize the TX/RX descriptors chains. */
> -	priv->rx_ring_size = dma_rx_num;
> -	priv->tx_ring_size = dma_tx_num;
>   	ret = alloc_init_skbufs(priv);
>   	if (ret) {
>   		netdev_err(dev, "DMA descriptors initialization failed\n");
> 
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
