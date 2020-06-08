Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888F91F1F83
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 21:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgFHTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 15:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgFHTKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 15:10:36 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC9FC08C5C2;
        Mon,  8 Jun 2020 12:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZonQ0UDsN5PlfPeYT+UnD79efeR5ZrxLv1CluCkZN2k=; b=oj5zWNi7wL9JaIOEGk6sTJcTq
        XyCOS5qAseLnJipxACgnhmsClNgy3WahJ0c+p4PQDLv16HS3ITYa1RKQu9tzSiP5qCJvcFtgMQq5O
        U45AHcyEDTUArZ7uq28sVvFI5bo/sqOp8LGEL8iqd4GUVM7luItg+u+rdXUDjCB1NoTtu9qloVtPy
        BC/GaJH5atIFFl4Zs2apFoZzZmo+8bR9FEC7tVXcUq00iWidbamIsly59tvq4867O+5qlsdpMQqPn
        sdHl1vhFYls+dkDDgsBlbu4BvlSAzboQ0E0hzrpW0ISba6BjLnFbf33wOZGuVn+YL79EMmS0r0fq8
        vXXQDDsdQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:51054)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jiNA0-0000sA-LI; Mon, 08 Jun 2020 20:10:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jiN9v-0002Kd-JR; Mon, 08 Jun 2020 20:10:11 +0100
Date:   Mon, 8 Jun 2020 20:10:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <20200608191011.GP1551@shell.armlinux.org.uk>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
 <20200608183953.GR311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608183953.GR311@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

A quick read through on the first review...

On Mon, Jun 08, 2020 at 07:39:53PM +0100, Jonathan McDowell wrote:
> +static int
> +qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
> +			     struct phylink_link_state *state)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	u32 reg;
> +
> +	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
> +
> +	state->link = (reg & QCA8K_PORT_STATUS_LINK_UP);
> +	state->an_complete = state->link;
> +	state->an_enabled = (reg & QCA8K_PORT_STATUS_LINK_AUTO);

I much prefer to use !!(reg & ...) since these are single-bit
bitfields.

> +	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
> +							   DUPLEX_HALF;
> +
> +	switch (reg & QCA8K_PORT_STATUS_SPEED) {
> +	case QCA8K_PORT_STATUS_SPEED_10:
> +		state->speed = SPEED_10;
> +		break;
> +	case QCA8K_PORT_STATUS_SPEED_100:
> +		state->speed = SPEED_100;
> +		break;
> +	case QCA8K_PORT_STATUS_SPEED_1000:
> +		state->speed = SPEED_1000;
> +		break;
> +	default:
> +		state->speed = SPEED_UNKNOWN;
> +		break;
> +	}
>  
> -	/* Set duplex mode */
> -	if (phy->duplex == DUPLEX_FULL)
> -		reg |= QCA8K_PORT_STATUS_DUPLEX;
> +	state->pause = MLO_PAUSE_NONE;
> +	if (reg & QCA8K_PORT_STATUS_RXFLOW)
> +		state->pause |= MLO_PAUSE_RX;
> +	if (reg & QCA8K_PORT_STATUS_TXFLOW)
> +		state->pause |= MLO_PAUSE_TX;
> +	if (reg & QCA8K_PORT_STATUS_FLOW_AUTO)
> +		state->pause |= MLO_PAUSE_AN;

There is no need to report back MLO_PAUSE_AN.

From the quick read of this, nothing else obviously stood out.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 503kbps up
