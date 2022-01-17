Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EAC490613
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 11:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbiAQKiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 05:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiAQKiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 05:38:20 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38579C06161C;
        Mon, 17 Jan 2022 02:38:20 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id AA09C1F437BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642415898;
        bh=jqiDzA7U4dHZTbnAE4kudgIyEogo59g2smc2wtyjBCQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Q6wzCvc9qE0otYn2eiO7z1qOqwYBxHD2hj+a9xD+ZDbEhnoPnsww9q5sCVT0Ri90b
         +awd9SB778AgeVBUFaDcC2d0vYHLTDNlR6B3P2Qs40ImprpGrZj8dfJigFwyVREDlB
         g+YfVxD6EYxW0Q5gDY/5uEiedsqHf6Tg+ke3OIAPMgmjecb6RHfPaUpW/BjD0FrJXH
         c3nEvZFMef538HdXkXk6pHUNI0NdpJsV6hl8eGnrD32iqbvqg+2UjZgGn90oO/QuXf
         iX2yVyXjgpyM+Z8D6uzegZMrImvaYVEwywN/L9gHGyuYDgS96jvjZKHOkElscpyKyC
         wR3X2XAYjOkoQ==
Subject: Re: [PATCH net-next v12 3/7] stmmac: dwmac-mediatek: re-arrange clock
 setting
To:     Biao Huang <biao.huang@mediatek.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        dkirjanov@suse.de
References: <20220117070706.17853-1-biao.huang@mediatek.com>
 <20220117070706.17853-4-biao.huang@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Message-ID: <2c62f337-5eb4-e525-7e3a-289435315c09@collabora.com>
Date:   Mon, 17 Jan 2022 11:38:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20220117070706.17853-4-biao.huang@mediatek.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 17/01/22 08:07, Biao Huang ha scritto:
> The rmii_internal clock is needed only when PHY
> interface is RMII, and reference clock is from MAC.
> 
> Re-arrange the clock setting as following:
> 1. the optional "rmii_internal" is controlled by devm_clk_get(),
> 2. other clocks still be configured by devm_clk_bulk_get().
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 72 +++++++++++++------
>   1 file changed, 49 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> index 8747aa4403e8..2678d2deb26a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
> @@ -49,14 +49,15 @@ struct mac_delay_struct {
>   struct mediatek_dwmac_plat_data {
>   	const struct mediatek_dwmac_variant *variant;
>   	struct mac_delay_struct mac_delay;
> +	struct clk *rmii_internal_clk;
>   	struct clk_bulk_data *clks;
> -	struct device_node *np;
>   	struct regmap *peri_regmap;
> +	struct device_node *np;
>   	struct device *dev;
>   	phy_interface_t phy_mode;
> -	int num_clks_to_config;
>   	bool rmii_clk_from_mac;
>   	bool rmii_rxc;
> +	int num_clks;

I don't see any need to get a num_clks here, at this point: since all functions
reading this are getting passed a pointer to this entire structure, you can
simply always access plat->variant->num_clks.

Please, drop the addition of num_clks in this struct.

Regards,
Angelo

