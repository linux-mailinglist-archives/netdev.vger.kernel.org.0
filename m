Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B0A6A5B1E
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 15:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjB1Oxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 09:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjB1Oxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 09:53:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33353AD00;
        Tue, 28 Feb 2023 06:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I+jweXh8GnLUA7TGMUfgns+0G0Qnn1Pm3HLp2jqbB9Q=; b=GJKNtuOBdz0ef2Sns9ohq8vOf2
        TrddWczgIaMFLTOy3KMvvvEQhrT+TK6tKS1dmbXj6zO0AXAM1Cj6o7B+XuR78IIoogfUf98rXh7Xs
        1XPFcVsZuq5lHrRXGQzSasP4CzQZg64CCHh1plZPXVn1N6LUyaWMLAk0vkZh4gkNNKfU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pX1Lr-006AJQ-9Y; Tue, 28 Feb 2023 15:53:11 +0100
Date:   Tue, 28 Feb 2023 15:53:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ken Sloat <ken.s@variscite.com>
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Message-ID: <Y/4VV6MwM9xA/3KD@lunn.ch>
References: <20230228144056.2246114-1-ken.s@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228144056.2246114-1-ken.s@variscite.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 09:40:56AM -0500, Ken Sloat wrote:
> Enhanced link detection is an ADI PHY feature that allows for earlier
> detection of link down if certain signal conditions are met. This
> feature is for the most part enabled by default on the PHY. This is
> not suitable for all applications and breaks the IEEE standard as
> explained in the ADI datasheet.
> 
> To fix this, add override flags to disable enhanced link detection
> for 1000BASE-T and 100BASE-TX respectively by clearing any related
> feature enable bits.
> 
> This new feature was tested on an ADIN1300 but according to the
> datasheet applies equally for 100BASE-TX on the ADIN1200.
> 
> Signed-off-by: Ken Sloat <ken.s@variscite.com>
Hi Ken

> +static int adin_config_fld_en(struct phy_device *phydev)

Could we have a better name please. I guess it means Fast Link Down,
but the commit messages talks about Enhanced link detection. This
function is also not enabling fast link down, but disabling it, so _en
seems wrong.

> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	int reg;
> +
> +	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_FLD_EN_REG);
> +	if (reg < 0)
> +		return reg;
> +
> +	if (device_property_read_bool(dev, "adi,disable-fld-1000base-t"))

You need to document these two properties in the device tree binding.

Please also take a read of
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq

    Andrew
