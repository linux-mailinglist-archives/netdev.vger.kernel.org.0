Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA69508B82
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379904AbiDTPGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379812AbiDTPGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:06:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D211427C6;
        Wed, 20 Apr 2022 08:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MqRy5uOENRenwCweqKVKazl/zwptPRAhGLk8TN0xBVE=; b=ZfNSnErbK5pFp00soQ9733fFLA
        D/eTR2WsYJ3a4BdstrPQAdKRFg7TymQik1QrmrVN8abvu9E1ZF7oqp6LtwhwVtOI69AJGmINAcc+c
        dGQGB9l7+RX98w2vluAbST2VgwLpjEW75o1jnYd2PdADD0cUIy2un17/Eavpcsp7P5Bo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nhBrH-00Gg5f-DV; Wed, 20 Apr 2022 17:03:07 +0200
Date:   Wed, 20 Apr 2022 17:03:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] net: phy: marvell: Add LED accessors for Marvell
 88E1510
Message-ID: <YmAgq1pm37Glw2v+@lunn.ch>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-5-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420124053.853891-5-kai.heng.feng@canonical.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 08:40:51PM +0800, Kai-Heng Feng wrote:
> Implement get_led_config() and set_led_config() callbacks so phy core
> can use firmware LED as platform requested.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/phy/marvell.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 2702faf7b0f60..c5f13e09b0692 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -750,6 +750,30 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
>  	return err;
>  }
>  
> +static int marvell_get_led_config(struct phy_device *phydev)
> +{
> +	int led;
> +
> +	led = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
> +	if (led < 0) {
> +		phydev_warn(phydev, "Fail to get marvell phy LED.\n");
> +		led = 0;
> +	}

I've said this multiple times, there are three LED registers, The
Function Control register, the Priority Control register and the Timer
control register. It is the combination of all three that defines how
the LEDs work. You need to save all of them.

And you need to make your API generic enough that the PHY driver can
save anywhere from 1 bit to 42 bytes of configuration.

I don't know ACPI, but i'm pretty sure this is not the ACPI way of
doing this. I think you should be defining an ACPI method, which
phylib can call after initialising the hardware to allow the firmware
to configure the LED.

     Andrew
