Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D35559863
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 13:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiFXLTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 07:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiFXLTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 07:19:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FCF60F3D;
        Fri, 24 Jun 2022 04:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=drUiWUYPOZ/mgsA2rYPc/1tb3Z6e5waNzU0Gaj97Y94=; b=V4tqB7bt46YbBvHVmMMPgnR83K
        SfeytZgNSy7zchvIyqboLlbKzOGDcOlf9dQ3cfVgR++WaU3YrpDSu/lVJYFuJHRDpUWeBU5WiVe7y
        w6QpuEML9NK9hHmIz0/fmJbSzphOfHsYOKGz0bDe0UR2+6Z8VGFk0rAE3c/Wf/XJkTpg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o4hKv-0083zQ-1I; Fri, 24 Jun 2022 13:18:53 +0200
Date:   Fri, 24 Jun 2022 13:18:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Subject: Re: [PATCH 1/3] net: ethernet: stmmac: dwmac-rk: Disable delayline
 if it is invalid
Message-ID: <YrWdnQKVbJR+NrfH@lunn.ch>
References: <20220623162850.245608-1-sebastian.reichel@collabora.com>
 <20220623162850.245608-2-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623162850.245608-2-sebastian.reichel@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1422,7 +1420,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
>  
>  	ret = of_property_read_u32(dev->of_node, "tx_delay", &value);
>  	if (ret) {
> -		bsp_priv->tx_delay = 0x30;
> +		bsp_priv->tx_delay = -1;
>  		dev_err(dev, "Can not read property: tx_delay.");
>  		dev_err(dev, "set tx_delay to 0x%x\n",
>  			bsp_priv->tx_delay);
> @@ -1433,7 +1431,7 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
>  
>  	ret = of_property_read_u32(dev->of_node, "rx_delay", &value);
>  	if (ret) {
> -		bsp_priv->rx_delay = 0x10;
> +		bsp_priv->rx_delay = -1;
>  		dev_err(dev, "Can not read property: rx_delay.");
>  		dev_err(dev, "set rx_delay to 0x%x\n",
>  			bsp_priv->rx_delay);

rockchip-dwmac.yaml says:


  tx_delay:
    description: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
    $ref: /schemas/types.yaml#/definitions/uint32

  rx_delay:
    description: Delay value for RXD timing. Range value is 0~0x7F, 0x10 as default.
    $ref: /schemas/types.yaml#/definitions/uint32

So it seems to me you are changing the documented default. You cannot
do that, this is ABI.

   Andrew
