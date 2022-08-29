Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94FC5A5468
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 21:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiH2TUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 15:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiH2TUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 15:20:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2156E2CA;
        Mon, 29 Aug 2022 12:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pc0wLZlozQihEHAnbmXgpg/tgBsnYovxYc8EA7xIwkY=; b=Dbys/SM9U3H1kdLBaiRbBxOZpN
        /yxlUeV67c+OSKGxd4fXR9kByDvWq5gzTu+oKKS1HinnxiEFCvh87kr0wamnbsh2SIDA9FMy4KKPD
        iBWB69vytO3qlfyMVhGN9ec+JAxA1XJGeuM+TND0Px/jvqJsk+Ua1wbqEjOlCTA/uD8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oSkJB-00EzsU-Sl; Mon, 29 Aug 2022 21:20:29 +0200
Date:   Mon, 29 Aug 2022 21:20:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 2/2] net: dsa: LAN9303: Add basic support for LAN9354
Message-ID: <Yw0RfRXGZKl+ZwOi@lunn.ch>
References: <20220829180037.31078-1-jerry.ray@microchip.com>
 <20220829180037.31078-2-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829180037.31078-2-jerry.ray@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	if ((reg >> 16) != LAN9303_CHIP_ID) {
> -		dev_err(chip->dev, "expecting LAN9303 chip, but found: %X\n",
> +	if (((reg >> 16) != LAN9303_CHIP_ID) &&
> +	    ((reg >> 16) != LAN9354_CHIP_ID)) {
> +		dev_err(chip->dev, "unexpected device found: LAN%4.4X\n",
>  			reg >> 16);
>  		return -ENODEV;
>  	}
> @@ -884,7 +889,7 @@ static int lan9303_check_device(struct lan9303 *chip)
>  	if (ret)
>  		dev_warn(chip->dev, "failed to disable switching %d\n", ret);
>  
> -	dev_info(chip->dev, "Found LAN9303 rev. %u\n", reg & 0xffff);
> +	dev_info(chip->dev, "Found LAN%4.4X rev. %u\n", (reg >> 16), reg & 0xffff);
>  
>  	ret = lan9303_detect_phy_setup(chip);
>  	if (ret) {
> diff --git a/drivers/net/dsa/lan9303_mdio.c b/drivers/net/dsa/lan9303_mdio.c
> index bbb7032409ba..d12c55fdc811 100644
> --- a/drivers/net/dsa/lan9303_mdio.c
> +++ b/drivers/net/dsa/lan9303_mdio.c
> @@ -158,6 +158,7 @@ static void lan9303_mdio_shutdown(struct mdio_device *mdiodev)
>  
>  static const struct of_device_id lan9303_mdio_of_match[] = {
>  	{ .compatible = "smsc,lan9303-mdio" },
> +	{ .compatible = "microchip,lan9354-mdio" },

Please validate that what you find on the board actually is what the
compatible says it should be. If you don't validate it, there will be
some DT blobs that have the wrong value, but probe fine. But then you
cannot actually make use of the compatible string in the driver to do
something different between the 9303 and the 9354 because some boards
have the wrong compatible....

     Andrew
