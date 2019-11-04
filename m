Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28041EEA2A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfKDUsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:48:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbfKDUsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 15:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dm/daXGKUfuSGufUx97lHEf/IH6mKhkovXtMS30mfv0=; b=n3PdGG8JjqXvLTh/xmNzSdP59a
        CLj/hTen+meSxA4ETOBr1FCUOyMIqYvF6GauDtw1HKyQ1aT7w8xkRE68oLJKKPj4AxEEo7qE2tRTU
        gV4G1PIPfWV4IOXsDy2W/Wn7ieXCR5/nFm4nVSHS75pSzfpdvoZsF09WS3ujessVjl78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRjHL-0006F5-2W; Mon, 04 Nov 2019 21:48:47 +0100
Date:   Mon, 4 Nov 2019 21:48:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        davem@davemloft.net, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: bcm_sf2: Add support for optional
 reset controller line
Message-ID: <20191104204847.GB17620@lunn.ch>
References: <20191104184203.2106-1-f.fainelli@gmail.com>
 <20191104184203.2106-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104184203.2106-3-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -350,6 +350,18 @@ static int bcm_sf2_sw_rst(struct bcm_sf2_priv *priv)
>  {
>  	unsigned int timeout = 1000;
>  	u32 reg;
> +	int ret;
> +
> +	/* The watchdog reset does not work on 7278, we need to hit the
> +	 * "external" reset line through the reset controller.
> +	 */
> +	if (priv->type == BCM7278_DEVICE_ID && !IS_ERR(priv->rcdev)) {
> +		ret = reset_control_assert(priv->rcdev);
> +		if (ret)
> +			return ret;
> +
> +		return reset_control_deassert(priv->rcdev);

Hi Florian

Here you do it conditional on priv->type

> @@ -1223,6 +1240,8 @@ static int bcm_sf2_sw_remove(struct platform_device *pdev)
>  	/* Disable all ports and interrupts */
>  	bcm_sf2_sw_suspend(priv->dev->ds);
>  	bcm_sf2_mdio_unregister(priv);
> +	if (!IS_ERR(priv->rcdev))
> +		reset_control_assert(priv->rcdev);

And here it is unconditional. Seem a bit inconsistent. If it is in DT,
why not use it?

    Andrew
