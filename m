Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE583DAD6D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhG2UVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:21:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232559AbhG2UVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 16:21:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yH5uVOP6NDV3mxanWoiwRIAPujE42QlL9/YdYceDovY=; b=xmGtGuEAFWj5j0hXzagN7x9J1u
        XnFnrOvxIglDS75jzWXEtG7QXJarvjaRNOui7f0vy94kdztYi40aMzcfIWKVJq5/LWwFNBFhZBSP2
        IViqvzi+a3rwLZZBGWrkZW7yAVFQvSoz6h8GQqd6Q8fPOtXCb69FeonaqC5gsMdJr02I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m9CWb-00FMil-C9; Thu, 29 Jul 2021 22:21:01 +0200
Date:   Thu, 29 Jul 2021 22:21:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Subject: Re: [PATCHv1 3/3] net: stmmac: dwmac-meson8b: Add reset controller
 for ethernet phy
Message-ID: <YQMNrVV1Dm+yxUiU@lunn.ch>
References: <20210729201100.3994-1-linux.amoon@gmail.com>
 <20210729201100.3994-4-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729201100.3994-4-linux.amoon@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -465,6 +478,13 @@ static int meson8b_dwmac_probe(struct platform_device *pdev)
>  		goto err_remove_config_dt;
>  	}
>  
> +	dwmac->eth_reset = devm_reset_control_get_exclusive(dwmac->dev, "ethreset");
> +	if (IS_ERR_OR_NULL(dwmac->eth_reset)) {
> +		dev_err(dwmac->dev, "Failed to get Ethernet reset\n");
> +		ret = PTR_ERR(dwmac->eth_reset);
> +		goto err_remove_config_dt;
> +	}
> +

Hi Anand

Since this is a new property, you need to handle it not being in the
DT blob. You probably need to use
devm_reset_control_get_optinal_exclusive()

	Andrew
