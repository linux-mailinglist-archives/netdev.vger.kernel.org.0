Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168C782A80
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 06:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfHFEqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 00:46:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40294 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFEqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 00:46:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so40875292pgj.7
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 21:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2j7+zajW8YHjJb6vtd6GGK8PfR2IXlyooiMNjhgqda4=;
        b=0WEACkB6+tkSwapaLx3mUtGXDP8tMN+Mw0CtY4oq4TY6eb6BPbFQ03Rq2JZAoM20/u
         FY8yhlRyoAUr2kF8VcVVR4h1UEAzDuwkzsU7nYIJ1qyZPWUMp23JmIfyrAGr3kvvZPrF
         Sdjlj4dm+VQbaqllPiRCeTV7Da9fWHPMaV77IFgzqVJwYBuAK/0TvHPhNfqAJveP7gSq
         6umgH6JcdQoRVJeg1LsHHvrANHxAgrbqwGK/adiCXx9KDqVtIjQOy89BCabkWAd+YMco
         nwsihxmqdAzfW6NyggGtIhUVCR96fStCxpW/zabYpJcYfwuyq0TJWULFKJYpIURYyfDn
         dv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2j7+zajW8YHjJb6vtd6GGK8PfR2IXlyooiMNjhgqda4=;
        b=BW4jDxMUaUIXzxMceARfRUbFR/whNUP00IU/H6iwGV2QItTNXCGFozH8w2TIBVKv4n
         D0ku1sl1ohJivXlrgH72Tuw+4bPR/5qObD7H/1OiPaTBWJJuMSQsvG/lI4xo/GI8ausW
         r+hTkAOE8GoLdb8pwA4P17MLXlSDB18zAXPnpb9m9Eir02pdVskGInzmolzCDYfbR03/
         V7AuEgLcx+6ZDC9sCfOAkyzxgPlRbT1teQqY53IYYaCIULATK/n5QY91Vgsf77jUcDFr
         nZpkAXcWQ32Iv/lWY4w1B4jjfNIhXuCh2tqt1iw9uz/l3WvbEwla4JcoqVsCAh1Y+Qoz
         avfQ==
X-Gm-Message-State: APjAAAVUjr/5sOmz+9DzU+gt5K00mCKzEURsoyYZjXinTkaV9apbJQXA
        9DARUXNFT/05VQwyGO/VQ5Qz0g==
X-Google-Smtp-Source: APXvYqxJ1GU+jM362HNbpRUZRKuHn12ZYsRHo95Oyr4gTePUavWdw/B4lZOUiOayXIOV5B07X0OeVQ==
X-Received: by 2002:a17:90a:a489:: with SMTP id z9mr1170396pjp.24.1565066798435;
        Mon, 05 Aug 2019 21:46:38 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v18sm85291165pgl.87.2019.08.05.21.46.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 21:46:38 -0700 (PDT)
Date:   Mon, 5 Aug 2019 21:46:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 06/10] net: stmmac: Implement RSS and enable it
 in XGMAC core
Message-ID: <20190805214600.4c84ccd7@cakuba.netronome.com>
In-Reply-To: <e70981c111ac857a0bac77750bd69a3383d99ee0.1565027782.git.joabreu@synopsys.com>
References: <cover.1565027782.git.joabreu@synopsys.com>
        <e70981c111ac857a0bac77750bd69a3383d99ee0.1565027782.git.joabreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Aug 2019 20:01:19 +0200, Jose Abreu wrote:
> Implement the RSS functionality and add the corresponding callbacks in
> XGMAC core.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> index c4c45402b8f8..9ff9d9ac1a50 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> @@ -254,6 +254,34 @@ static void dwxgmac2_clear(struct dma_desc *p)
>  	p->des3 = 0;
>  }
>  
> +static int dwxgmac2_get_rx_hash(struct dma_desc *p, u32 *hash,
> +				enum pkt_hash_types *type)
> +{
> +	unsigned int rdes3 = le32_to_cpu(p->des3);
> +	u32 ptype;
> +
> +	if (rdes3 & XGMAC_RDES3_RSV) {
> +		ptype = (rdes3 & XGMAC_RDES3_L34T) >> XGMAC_RDES3_L34T_SHIFT;
> +
> +		switch (ptype) {
> +		case 0x1:
> +		case 0x2:
> +		case 0x9:
> +		case 0xA:

nit: it'd be nice to have defines for these constants

> +			*type = PKT_HASH_TYPE_L4;
> +			break;
> +		default:
> +			*type = PKT_HASH_TYPE_L3;
> +			break;
> +		}
> +
> +		*hash = le32_to_cpu(p->des1);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  const struct stmmac_desc_ops dwxgmac210_desc_ops = {
>  	.tx_status = dwxgmac2_get_tx_status,
>  	.rx_status = dwxgmac2_get_rx_status,

> @@ -4182,7 +4208,7 @@ int stmmac_dvr_probe(struct device *device,
>  	struct net_device *ndev = NULL;
>  	struct stmmac_priv *priv;
>  	u32 queue, maxq;
> -	int ret = 0;
> +	int i, ret = 0;
>  
>  	ndev = devm_alloc_etherdev_mqs(device, sizeof(struct stmmac_priv),
>  				       MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES);
> @@ -4290,6 +4316,14 @@ int stmmac_dvr_probe(struct device *device,
>  #endif
>  	priv->msg_enable = netif_msg_init(debug, default_msg_level);
>  
> +	/* Initialize RSS */
> +	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
> +	for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
> +		priv->rss.table[i] = i % priv->plat->rx_queues_to_use;

ethtool_rxfh_indir_default() ?

> +	if (priv->dma_cap.rssen && priv->plat->rss_en)
> +		ndev->features |= NETIF_F_RXHASH;
> +
>  	/* MTU range: 46 - hw-specific max */
>  	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
>  	if ((priv->plat->enh_desc) || (priv->synopsys_id >= DWMAC_CORE_4_00))
