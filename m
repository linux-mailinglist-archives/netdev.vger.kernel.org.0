Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241C9510DFB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 03:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356716AbiD0BdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356720AbiD0BdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:33:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18362DF0;
        Tue, 26 Apr 2022 18:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RVBHFqV9TmrZIE98jV3fTbZU85zYa+qeuHeH76mXrhs=; b=bJ4MGg1L1rsKB/Io5rXbq3Sw81
        6u3PwI405n5V8QKHK7+BDAQ7tPhXjU6qiMaQjZVYJWkqyPQKrIp3vzLG8UOoRVgZAIctDiI0LiXaD
        06x/nWSJ7zEDd4dUYXhu/6DJS1nABDL2r4art1FNmO2myiMHhcl/epMTB6XWN/PdEpDI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njWVF-0001z5-3f; Wed, 27 Apr 2022 03:30:01 +0200
Date:   Wed, 27 Apr 2022 03:30:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Single chip mode detection for
 MV88E6*41
Message-ID: <YmicmQEGbAvITaNm@lunn.ch>
References: <20220424125451.295435-1-nathan@nathanrossi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424125451.295435-1-nathan@nathanrossi.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 12:54:51PM +0000, Nathan Rossi wrote:
> The mv88e6xxx driver expects switches that are configured in single chip
> addressing mode to have the MDIO address configured as 0. This is due to
> the switch ADDR pins representing the single chip addressing mode as 0.
> However depending on the device (e.g. MV88E6*41) the switch does not
> respond on address 0 or any other address below 16 (the first port
> address) in single chip addressing mode. This allows for other devices
> to be on the same shared MDIO bus despite the switch being in single
> chip addressing mode.
> 
> When using a switch that works this way it is not possible to configure
> switch driver as single chip addressing via device tree, along with
> another MDIO device on the same bus with address 0, as both devices
> would have the same address of 0 resulting in mdiobus_register_device
> -EBUSY errors for one of the devices with address 0.
> 
> In order to support this configuration the switch node can have its MDIO
> address configured as 16 (the first address that the device responds
> to). During initialization the driver will treat this address similar to
> how address 0 is, however because this address is also a valid
> multi-chip address (in certain switch models, but not all) the driver
> will configure the SMI in single chip addressing mode and attempt to
> detect the switch model. If the device is configured in single chip
> addressing mode this will succeed and the initialization process can
> continue. If it fails to detect a valid model this is because the switch
> model register is not a valid register when in multi-chip mode, it will
> then fall back to the existing SMI initialization process using the MDIO
> address as the multi-chip mode address.
> 
> This detection method is safe if the device is in either mode because
> the single chip addressing mode read is a direct SMI/MDIO read operation
> and has no side effects compared to the SMI writes required for the
> multi-chip addressing mode.

Thanks for rewording the commit message. This makes it a lot clearer
what is going on and how it is fixed.

> @@ -6971,9 +6993,18 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>  	if (chip->reset)
>  		usleep_range(1000, 2000);
>  
> -	err = mv88e6xxx_detect(chip);
> -	if (err)
> -		goto out;
> +	/* Detect if the device is configured in single chip addressing mode,
> +	 * otherwise continue with address specific smi init/detection.
> +	 */
> +	if (mv88e6xxx_single_chip_detect(chip, mdiodev)) {
> +		err = mv88e6xxx_smi_init(chip, mdiodev->bus, mdiodev->addr);
> +		if (err)
> +			goto out;
> +

This is confusing. Then name mv88e6xxx_single_chip_detect() suggests
it will return true if it detects a single chip device. When it fact
is return 0 == False if it does find such a device.

So i think this would be better coded as

	err = mv88e6xxx_single_chip_detect(chip, mdiodev);
	if (err) {
		err = mv88e6xxx_smi_init(chip, mdiodev->bus, mdiodev->addr);
		if (err)
			goto out;

I did however test this code on my 370rd, and it does work. So once we
get this sorted out, it is good to go.

	Andrew			
