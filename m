Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D668C3DAAA0
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 20:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhG2SC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 14:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2SCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 14:02:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F105AC061765;
        Thu, 29 Jul 2021 11:02:50 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r17so12636369lfe.2;
        Thu, 29 Jul 2021 11:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oeb6ETNJGtLEMXQm2GkmXW4qVWqHufikq9s1QpDySu0=;
        b=t0tBpOQ7o4RxpiI7zHRgEEiGTiRaS0sSu6vHP7FDM05JWhFnv3uvaL6WbSSDNid7CU
         FrMbwLLrAuLu7lClwFYgeP2HfuMPSvxfFmnII/IrmsGv/J0vzmNbzA1pJ+TVnXC6oY1U
         w4EPNukIgj47jUfzG+FF1QJ0DZdxLRecbdnCHVD73rjU6fe+ZRGp0S1tTaIcaGdp0QcV
         x/DeQf/R/Zg1VWIBJEgNZ1KsMLdEtKGwBNtj14Rx/tQya4t0cWA/iJRC2iJoe9wMgWia
         y9hlFIdPcZOY1Y3aEousFw6dsBpM94g25rGSRgWXnhr45EHuaQGsQTdpTFAOo1CevOyG
         FxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oeb6ETNJGtLEMXQm2GkmXW4qVWqHufikq9s1QpDySu0=;
        b=XlI5fPXllJ/5JFl6IJBoT+jw238az3KXE9pbsOI8QPHdSL/dUH0nUihL5d68rcB3Bm
         7TYtMS3/CE34/WI50mnrOQbuB7Kr6lvt3+RnMCxp7HsaQYMA+O4ZURExpKyLK6NIJTCW
         EMMfq/9ev+GyrkTOEiEAzCn6c25Yq1LYHyCNkf66F/euK7Bkj61hLSS1PoqngQp15g2m
         NTFm1fq8HorUZMRJKJ/MpIfeJMxdGkLhcrqvcT+Ybi2l2pdzfs2g/Ip/DON6FwgjIdyt
         T1w/kAvWSEcEcqTTdgdhv/VVr4H+KD2j9Cyu5+u/ijifHt6qZAOe78TKEikjvlfS7Tr6
         szYw==
X-Gm-Message-State: AOAM530ZInWC5tBfDp5c0wfTPI7shKuKslm+cmGKA0iOdRE0GgqqOUvf
        L/DJSPwFl8X7rAiXVhGhJ/g=
X-Google-Smtp-Source: ABdhPJwAZXAZJD7cwqDlDbn0DkhIAx5QfSVOgu6iVbAatvSRoQ/tEqNVPsNc76GkzR3CNZskVXEtfg==
X-Received: by 2002:ac2:5933:: with SMTP id v19mr4807715lfi.85.1627581767769;
        Thu, 29 Jul 2021 11:02:47 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.80.187])
        by smtp.gmail.com with ESMTPSA id b34sm194988ljf.44.2021.07.29.11.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 11:02:47 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH net-next 09/18] ravb: Factorise ravb_ring_free function
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-10-biju.das.jz@bp.renesas.com>
Message-ID: <a0d1bb7e-0e0a-8237-c30a-e4533b5580dd@gmail.com>
Date:   Thu, 29 Jul 2021 21:02:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210722141351.13668-10-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/22/21 5:13 PM, Biju Das wrote:

> Extended descriptor support in RX is available for R-Car where as it
> is a normal descriptor for RZ/G2L. Factorise ravb_ring_free function
> so that it can support later SoC.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  5 +++
>  drivers/net/ethernet/renesas/ravb_main.c | 49 ++++++++++++++++--------
>  2 files changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index a474ed68db22..3a9cf6e8671a 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -988,7 +988,12 @@ enum ravb_chip_id {
>  	RCAR_GEN3,
>  };
>  
> +struct ravb_ops {
> +	void (*ring_free)(struct net_device *ndev, int q);

   Hmm, why not store it right in the *struct* ravb_drv_data?

> +};
> +
>  struct ravb_drv_data {
> +	const struct ravb_ops *ravb_ops;
>  	netdev_features_t net_features;
>  	netdev_features_t net_hw_features;
>  	const char (*gstrings_stats)[ETH_GSTRING_LEN];
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 4ef2565534d2..a3b8b243fd54 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -247,30 +247,39 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  }
>  
>  /* Free skb's and DMA buffers for Ethernet AVB */
> -static void ravb_ring_free(struct net_device *ndev, int q)
> +static void ravb_ring_free_rx(struct net_device *ndev, int q)

   How about ravb_rx_ring_free() instead?
 
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> -	int num_tx_desc = priv->num_tx_desc;
>  	int ring_size;
>  	int i;
>  
> -	if (priv->rx_ring[q]) {
> -		for (i = 0; i < priv->num_rx_ring[q]; i++) {
> -			struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		struct ravb_ex_rx_desc *desc = &priv->rx_ring[q][i];
>  
> -			if (!dma_mapping_error(ndev->dev.parent,
> -					       le32_to_cpu(desc->dptr)))
> -				dma_unmap_single(ndev->dev.parent,
> -						 le32_to_cpu(desc->dptr),
> -						 RX_BUF_SZ,
> -						 DMA_FROM_DEVICE);
> -		}
> -		ring_size = sizeof(struct ravb_ex_rx_desc) *
> -			    (priv->num_rx_ring[q] + 1);
> -		dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
> -				  priv->rx_desc_dma[q]);
> -		priv->rx_ring[q] = NULL;
> +		if (!dma_mapping_error(ndev->dev.parent,
> +				       le32_to_cpu(desc->dptr)))
> +			dma_unmap_single(ndev->dev.parent,
> +					 le32_to_cpu(desc->dptr),
> +					 RX_BUF_SZ,
> +					 DMA_FROM_DEVICE);
>  	}
> +	ring_size = sizeof(struct ravb_ex_rx_desc) *
> +		    (priv->num_rx_ring[q] + 1);
> +	dma_free_coherent(ndev->dev.parent, ring_size, priv->rx_ring[q],
> +			  priv->rx_desc_dma[q]);
> +	priv->rx_ring[q] = NULL;

   Couldn't this be moved into the new ravb_ring_free(), like the initial NULL check?

> +}
> +
> +static void ravb_ring_free(struct net_device *ndev, int q)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	const struct ravb_drv_data *info = priv->info;
> +	int num_tx_desc = priv->num_tx_desc;
> +	int ring_size;
> +	int i;
> +
> +	if (priv->rx_ring[q])
> +		info->ravb_ops->ring_free(ndev, q);

   ... here?

[...]

MBR, Sergei
