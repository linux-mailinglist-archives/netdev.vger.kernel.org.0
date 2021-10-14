Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F73C42CF84
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 02:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhJNA0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 20:26:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhJNA0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 20:26:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8A5461027;
        Thu, 14 Oct 2021 00:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634171090;
        bh=EQyzzIBtm6Daq3rcCTVWgSX9T9UCo24CrBF6aaIjRWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/UUuD5x+9osgJYmSh64WUq0hTWyuQlzSxboi3ZAnhaGpAbwlhoGZYL2Zgid7I4nN
         eWhRqXQF4uutWSCkfKszWjTLLb+/MprsIlF7QGzWxDMAgCpqXLouaLkOazlxGElQuX
         cFXUHrANRs6RZEMMSW01FCL58qiWtx1sxYeuGY46pScxk8J8keV5yXThkcnZPqsGrH
         dpWQ92wzi3jGv8wp4fUsiWijrP2NnvzUOCTwx2qtu140p5KIbe4ReKMURiSU0B9sem
         dfwZDc0dqNEiGyQA1TTG0OTodfDNG6vJligG+ASTgynAhaPIg04tb1U6GpQYuVpOvX
         df0Bkx7qpC/+g==
Date:   Wed, 13 Oct 2021 17:24:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 6/6] net: dsa: sja1105: parse
 {rx,tx}-internal-delay-ps properties for RGMII delays
Message-ID: <20211013172448.2db3b99b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013222313.3767605-7-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
        <20211013222313.3767605-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some take it or leave it comments, checkpatch pointed out some extra
brackets so I had a look at the patch.

On Thu, 14 Oct 2021 01:23:13 +0300 Vladimir Oltean wrote:
> +	int rx_delay = -1, tx_delay = -1;
>  
> +	if (!phy_interface_mode_is_rgmii(phy_mode))
> +		return 0;
>  
> +	of_property_read_u32(port_dn, "rx-internal-delay-ps", &rx_delay);
> +	of_property_read_u32(port_dn, "tx-internal-delay-ps", &tx_delay);

If I'm reading this right you're depending on delays being left as -1
in case the property reads fail. Is this commonly accepted practice?
Why not code it up as:

	u32 rx_delay;

	if (of_property_read_u32(...))
		rx_delay = 0;
	else if (rx_delay != clamp(rx_delay, ...MIN, ...MAX)
		goto err;

or some such?

> +	if ((rx_delay && rx_delay < SJA1105_RGMII_DELAY_MIN_PS) ||
> +	    (tx_delay && tx_delay < SJA1105_RGMII_DELAY_MIN_PS) ||
> +	    (rx_delay > SJA1105_RGMII_DELAY_MAX_PS) ||
> +	    (tx_delay > SJA1105_RGMII_DELAY_MAX_PS)) {

nit: checkpatch says the brackets around the latter two are unnecessary,
     just in case it's not for symmetry / on purpose

