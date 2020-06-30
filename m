Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A80720F935
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbgF3QOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbgF3QOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 12:14:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89906206C3;
        Tue, 30 Jun 2020 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593533657;
        bh=jntt+cXMESpI5BxIVrqn9RiSFOWddabQ9CFYmAAcv8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zkVQxTij0JqqWK98C4Shl4XcjRXWJTB/3lpgkz/xNfmZ/SLJWNXE/5HDqT1KiSm8O
         t8oxWLhO6TDUPN6v0mCXLULTmnRPiMgDBFS0MsEFofHq+sRfDD/1FTXpPdr8fSPkoS
         WWuIfcVhZldMzRQXsIlTYN56z0GsLpH5yq/6r6c0=
Date:   Tue, 30 Jun 2020 09:14:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 3/3] net: dsa/bcm_sf2: move pause mode setting
 into mac_link_up()
Message-ID: <20200630091415.649a3e88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1jqDUw-0004uL-Ip@rmk-PC.armlinux.org.uk>
References: <20200630102751.GA1551@shell.armlinux.org.uk>
        <E1jqDUw-0004uL-Ip@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 11:28:18 +0100 Russell King wrote:
> @@ -662,6 +655,22 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
>  		else
>  			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
>  
> +		if (interface == PHY_INTERFACE_MODE_RGMII ||
> +		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +		    interface == PHY_INTERFACE_MODE_MII ||
> +		    interface == PHY_INTERFACE_MODE_REVMII) {
> +			reg = reg_readl(priv, REG_RGMII_CNTRL_P(port));
> +			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
> +
> +			if (tx_pause)
> +				reg |= TX_PAUSE_EN;
> +			if (rx_pause)
> +				reg |= RX_PAUSE_EN;
> +
> +			reg_writel(priv, reg, REG_RGMII_CNTRL_P(port));
> +		}
> +
> +

nit: double new line
