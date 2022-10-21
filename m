Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC98960798A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJUO0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiJUO0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:26:19 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A7A27356E;
        Fri, 21 Oct 2022 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hLIftyCnMfJmXHqHfS25A/HJN5FcIUZYxrBqbDtX2Uk=; b=peZQ7bDpyEjIneTfXTLFKNWDTQ
        djMbqkXJR2b/a6BfBT1DpCLSrjhzi5mc5o8QC2ZBTaUSxj9o6katVd1cN2Sv9NaqX3jiFIR1/74Di
        Z5U2FM47UOM0gPZXEOdh/ozlzcSMjiBaHPeE6TjHXxiwYO4HfV0slzjIHJX5WGEcC174=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1olsLh-000F2c-Cs; Fri, 21 Oct 2022 15:46:09 +0200
Date:   Fri, 21 Oct 2022 15:46:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 1/2] net: lan743x: Add support for
 get_pauseparam and set_pauseparam
Message-ID: <Y1Kiocu3WUubYyVe@lunn.ch>
References: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
 <20221021055642.255413-2-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021055642.255413-2-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan743x_set_pauseparam(struct net_device *dev,
> +				  struct ethtool_pauseparam *pause)
> +{
> +	struct lan743x_adapter *adapter = netdev_priv(dev);
> +	struct phy_device *phydev = dev->phydev;
> +	struct lan743x_phy *phy = &adapter->phy;
> +
> +	if (!phydev)
> +		return -ENODEV;
> +
> +	if (!phy_validate_pause(phydev, pause))
> +		return -EINVAL;
> +
> +	phy->fc_request_control = 0;
> +	if (pause->rx_pause)
> +		phy->fc_request_control |= FLOW_CTRL_RX;
> +
> +	if (pause->tx_pause)
> +		phy->fc_request_control |= FLOW_CTRL_TX;
> +
> +	phy->fc_autoneg = pause->autoneg;
> +
> +	phy_set_asym_pause(phydev, pause->rx_pause,  pause->tx_pause);
> +
> +	if (pause->autoneg == AUTONEG_DISABLE)
> +		lan743x_mac_flow_ctrl_set_enables(adapter, pause->tx_pause,
> +						  pause->rx_pause);

pause is not too well defined. But i think phy_set_asym_pause() should
be in an else clause. If pause autoneg is off, you directly set it in
the MAC and ignore what is negotiated. If it is enabled, you
negotiate. As far as i understand, you don't modify your negotiation
when pause autoneg is off.

	Andrew
