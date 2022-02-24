Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8503F4C2C31
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 13:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiBXMy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 07:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiBXMy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 07:54:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B6D20E796;
        Thu, 24 Feb 2022 04:53:56 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3504F1F44A;
        Thu, 24 Feb 2022 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645707235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2G7Q4/SbY0/u6FJFyQ5u7ok3xEUfxBWHs/wk8cUfVjo=;
        b=UPAiUuz+WH8h7pPxSNNG6Dpza+Qb+DM5ZsIxaWxc1kG25pDybpqYRQX9kVy96n/KQltFxM
        vCZj0mVEeW3p5oSQ+Rdkp5XuV/rGPiV4X0Q4CY3EpPGaEBOzTiQGkDt8cbMTH188U9lC2M
        4/y8+BgA/LqcXC5UeGyUaGQEyyqilIo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645707235;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2G7Q4/SbY0/u6FJFyQ5u7ok3xEUfxBWHs/wk8cUfVjo=;
        b=PIqZ3B1fxD+QIGOx68q/WUrx7rRxAgTPIf32nkK4Qbync3bJbDpyVAY9lHUo4LrfE3UD9a
        22Slgo4cEHRrhsBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5311B13AD9;
        Thu, 24 Feb 2022 12:53:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id d5/wEOJ/F2IoEgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 24 Feb 2022 12:53:54 +0000
Message-ID: <f62148d7-6f7a-3557-e3ca-3a261b61ac9d@suse.de>
Date:   Thu, 24 Feb 2022 15:53:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2] net: stmmac: only enable DMA interrupts when ready
Content-Language: ru
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     kernel@axis.com, Lars Persson <larper@axis.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220224113829.1092859-1-vincent.whitchurch@axis.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20220224113829.1092859-1-vincent.whitchurch@axis.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/24/22 14:38, Vincent Whitchurch пишет:
> In this driver's ->ndo_open() callback, it enables DMA interrupts,
> starts the DMA channels, then requests interrupts with request_irq(),
> and then finally enables napi.
> 
> If RX DMA interrupts are received before napi is enabled, no processing
> is done because napi_schedule_prep() will return false.  If the network
> has a lot of broadcast/multicast traffic, then the RX ring could fill up
> completely before napi is enabled.  When this happens, no further RX
> interrupts will be delivered, and the driver will fail to receive any
> packets.
> 
> Fix this by only enabling DMA interrupts after all other initialization
> is complete.
> 
> Fixes: 523f11b5d4fd72efb ("net: stmmac: move hardware setup for stmmac_open to new function")
> Reported-by: Lars Persson <larper@axis.com>
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6708ca2aa4f7..43978558d6c0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2260,6 +2260,23 @@ static void stmmac_stop_tx_dma(struct stmmac_priv *priv, u32 chan)
>   	stmmac_stop_tx(priv, priv->ioaddr, chan);
>   }
>   
> +static void stmmac_enable_all_dma_irq(struct stmmac_priv *priv)
> +{
> +	u32 rx_channels_count = priv->plat->rx_queues_to_use;
> +	u32 tx_channels_count = priv->plat->tx_queues_to_use;
> +	u32 dma_csr_ch = max(rx_channels_count, tx_channels_count);
> +	u32 chan;
> +
> +	for (chan = 0; chan < dma_csr_ch; chan++) {
> +		struct stmmac_channel *ch = &priv->channel[chan];
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&ch->lock, flags);
> +		stmmac_enable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
> +		spin_unlock_irqrestore(&ch->lock, flags);
> +	}
> +}
> +
>   /**
>    * stmmac_start_all_dma - start all RX and TX DMA channels
>    * @priv: driver private structure
> @@ -2902,8 +2919,10 @@ static int stmmac_init_dma_engine(struct stmmac_priv *priv)
>   		stmmac_axi(priv, priv->ioaddr, priv->plat->axi);
>   
>   	/* DMA CSR Channel configuration */
> -	for (chan = 0; chan < dma_csr_ch; chan++)
> +	for (chan = 0; chan < dma_csr_ch; chan++) {
>   		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
Did you miss to take a channel lock?
> +		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
> +	}
>   
>   	/* DMA RX Channel Configuration */
>   	for (chan = 0; chan < rx_channels_count; chan++) {
> @@ -3759,6 +3778,7 @@ static int stmmac_open(struct net_device *dev)
>   
>   	stmmac_enable_all_queues(priv);
>   	netif_tx_start_all_queues(priv->dev);
> +	stmmac_enable_all_dma_irq(priv);
>   
>   	return 0;
>   
> @@ -6508,8 +6528,10 @@ int stmmac_xdp_open(struct net_device *dev)
>   	}
>   
>   	/* DMA CSR Channel configuration */
> -	for (chan = 0; chan < dma_csr_ch; chan++)
> +	for (chan = 0; chan < dma_csr_ch; chan++) {
>   		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
> +		stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 1);
> +	}
>   
>   	/* Adjust Split header */
>   	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
> @@ -6570,6 +6592,7 @@ int stmmac_xdp_open(struct net_device *dev)
>   	stmmac_enable_all_queues(priv);
>   	netif_carrier_on(dev);
>   	netif_tx_start_all_queues(dev);
> +	stmmac_enable_all_dma_irq(priv);
>   
>   	return 0;
>   
> @@ -7447,6 +7470,7 @@ int stmmac_resume(struct device *dev)
>   	stmmac_restore_hw_vlan_rx_fltr(priv, ndev, priv->hw);
>   
>   	stmmac_enable_all_queues(priv);
> +	stmmac_enable_all_dma_irq(priv);
>   
>   	mutex_unlock(&priv->lock);
>   	rtnl_unlock();
