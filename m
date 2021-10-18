Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC81943298A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 00:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhJRWGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:06:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhJRWGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 18:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0jATFIJZGaGNJtI9nrB9A/vH/sBn6bZ/u4kev59KQDU=; b=TlE0CpnflLLrtpn7Q37GMlaV49
        0/yZ9p1p5gDe31wEsAI/I9pIXpIccKfhPZld5y2zAF2Kr/uM7WnT/jXnhkSx3RQ5AXH0+O2GMlpfO
        Y06hNiqZ9BIzV+oQV2x33bR5AZAHTZ6vBIbxJCfTr9tk0Zd4h/q9atKp4PvaFpDek3tg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcajm-00B0y8-8D; Tue, 19 Oct 2021 00:04:06 +0200
Date:   Tue, 19 Oct 2021 00:04:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 12/13] net: phy: adjust qca8081 master/slave seed
 value if link down
Message-ID: <YW3vVt99i7TNCzaC@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-13-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-13-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 11:33:32AM +0800, Luo Jie wrote:
> 1. The master/slave seed needs to be updated when the link can't
> be created.
> 
> 2. The case where two qca8081 PHYs are connected each other and
> master/slave seed is generated as the same value also needs
> to be considered, so adding this code change into read_status
> instead of link_change_notify.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/at803x.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 5d007f89e9d3..77aaf9e72781 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -1556,6 +1556,22 @@ static int qca808x_read_status(struct phy_device *phydev)
>  	else
>  		phydev->interface = PHY_INTERFACE_MODE_SMII;
>  
> +	/* generate seed as a lower random value to make PHY linked as SLAVE easily,
> +	 * except for master/slave configuration fault detected.
> +	 * the reason for not putting this code into the function link_change_notify is
> +	 * the corner case where the link partner is also the qca8081 PHY and the seed
> +	 * value is configured as the same value, the link can't be up and no link change
> +	 * occurs.
> +	 */
> +	if (!phydev->link) {
> +		if (phydev->master_slave_state == MASTER_SLAVE_STATE_ERR) {
> +			qca808x_phy_ms_seed_enable(phydev, false);
> +		} else {
> +			qca808x_phy_ms_random_seed_set(phydev);
> +			qca808x_phy_ms_seed_enable(phydev, true);
> +		}
> +	}

Are you assuming here that the status is polled once a second, and
each poll you choose a new seed and see if it succeeds? What happens
when interrupts are used, not polling?

     Andrew
