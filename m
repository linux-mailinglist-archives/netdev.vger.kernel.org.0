Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4385BAD35
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiIPMSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiIPMSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:18:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F90DB089B;
        Fri, 16 Sep 2022 05:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OCC0Xr+0xRy79xAXIy34CWBnfIPVnQuynqQ7f4NA21M=; b=zlkcPmIMJNXMDcPqStE+RO2Vx5
        a1vO+z6I+yyJ9BlTZe5KAtg6WMJvXIeRejlEnyBpelpYKNKDy5wUwqGHxSPPxvfKr6OgtAotjbrED
        H0VJrHpzVI1/iCZr1v8eRbg9aABDzWKrXeBzeJTRv1WBRu9l42rumHrPYvgTdXjR2Ykw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oZAIU-00GukY-C1; Fri, 16 Sep 2022 14:18:18 +0200
Date:   Fri, 16 Sep 2022 14:18:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        lxu@maxlinear.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next 2/2] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <YyRpij7ahB0cqWyy@lunn.ch>
References: <20220916082327.370579-1-Raju.Lakkaraju@microchip.com>
 <20220916082327.370579-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916082327.370579-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 01:53:27PM +0530, Raju Lakkaraju wrote:
> Add support to SGMII register dump

> +static void lan743x_get_pauseparam(struct net_device *dev,
> +				   struct ethtool_pauseparam *pause)
> +{
> +	struct lan743x_adapter *adapter = netdev_priv(dev);
> +
> +//	pause->autoneg = adapter->pause_autoneg;
> +	pause->tx_pause = adapter->pause_tx;
> +	pause->rx_pause = adapter->pause_rx;
> +}
> +
> +static int lan743x_set_pauseparam(struct net_device *dev,
> +				  struct ethtool_pauseparam *pause)
> +{
> +	struct lan743x_adapter *adapter = netdev_priv(dev);
> +	struct phy_device *phydev = dev->phydev;
> +
> +	if (pause->autoneg)
> +		return -EINVAL;
> +
> +	if (!phydev)
> +		return -EINVAL;
> +
> +	if (!phy_validate_pause(phydev, pause))
> +		return -EINVAL;
> +
> +	//adapter->pause_auto = pause->autoneg;
> +	adapter->pause_rx   = pause->rx_pause;
> +	adapter->pause_tx   = pause->tx_pause;
> +
> +	phy_set_asym_pause(phydev, pause->rx_pause, pause->tx_pause);
> +
> +	return 0;
>  }

This is not part of register dumping...

> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -25,6 +25,22 @@
>  #define PCS_POWER_STATE_DOWN	0x6
>  #define PCS_POWER_STATE_UP	0x4
>  
> +static int lan743x_sgmii_read(struct lan743x_adapter *adapter,
> +			      u8 mmd, u16 addr);
> +int lan743x_sgmii_dump_read(struct lan743x_adapter *adapter,
> +			    u8 dev, u16 adr)
> +{
> +	int ret;
> +
> +	ret = lan743x_sgmii_read(adapter, dev, adr);
> +	if (ret < 0) {
> +		pr_warn("SGMII read fail\n");

Better to use netdev_warn(), so we know which devices has read
problems.

	Andrew
