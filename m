Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC66C03E1
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCSSvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCSSu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:50:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5B217146;
        Sun, 19 Mar 2023 11:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o07Y1obEQh6vMiIF631MCGn7dZ81Ro+29HesnwRuPSQ=; b=hcKv/iMngGDXKK5P768aRAErg4
        0tMvAkCQ4q11PfbYw00PsGIPQBwAQmyXIKoaLUgZKkPyBdCndz0EatyPoznyyBon6sWARKy83+1qI
        ndgoDvbdm6viKPLMXYE/T5hTozcqws+zaQDtcYLW0DHhMZfGFx0elYZY2o5xNO76q1P8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdy7D-007mPB-53; Sun, 19 Mar 2023 19:50:47 +0100
Date:   Sun, 19 Mar 2023 19:50:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: add support for BCM63xx RGMIIs
Message-ID: <53c8eeb2-f2f3-45a6-842f-44556c1098af@lunn.ch>
References: <20230319183330.761251-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319183330.761251-1-noltari@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
> +				  phy_interface_t interface)
> +{
> +	struct b53_device *dev = ds->priv;
> +	u8 rgmii_ctrl = 0, off;
> +
> +	if (port == dev->imp_port)
> +		off = B53_RGMII_CTRL_IMP;
> +	else
> +		off = B53_RGMII_CTRL_P(port);
> +
> +	b53_read8(dev, B53_CTRL_PAGE, off, &rgmii_ctrl);
> +
> +	rgmii_ctrl &= ~(RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
> +	if (interface == PHY_INTERFACE_MODE_RGMII_ID)
> +		rgmii_ctrl |= (RGMII_CTRL_DLL_RXC | RGMII_CTRL_DLL_TXC);
> +	else if (interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +		rgmii_ctrl |= RGMII_CTRL_DLL_RXC;
> +	else if (interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +		rgmii_ctrl |= RGMII_CTRL_DLL_TXC;

Please change this to a switch statement. Then i would suggest having
a case PHY_INTERFACE_MODE_RGMII: to make it clear you are handling
that as well, removing all delays. You do look to be handling it, so
it is not a big problem, but in the past we have had code where one of
the RGMII modes has been ignored resulting in some horrible problems
later. So it is something i now always look for, and like to be obvious.

> +
> +	if (port != dev->imp_port)
> +		rgmii_ctrl |= RGMII_CTRL_ENABLE_GMII;
> +
> +	b53_write8(dev, B53_CTRL_PAGE, off, rgmii_ctrl);
> +
> +	dev_info(ds->dev, "Configured port %d for %s\n", port,
> +		 phy_modes(interface));

dev_dbg().

	Andrew
