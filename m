Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0265088B4
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378726AbiDTNEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378732AbiDTNEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:04:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B778B40A3C;
        Wed, 20 Apr 2022 06:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zIkXVDYmmQVhZ1bq0pQa9yk1n2MJ8aMOtfJNOcepzZk=; b=XK1I9Mhtw/bSyS0hwSxYnh+CyE
        Q57aW4YqCTNsH3v9TiiC2ZKQ6jxGeR1FOdu2MtQeo/F3WKShcPaFp0Jnc0yU6dsRRXzUV13B3cHCb
        GgTqXP3+WhFfJ1kfhwnB+C4sNs4RvLMnUzMlaqGB9q12CeHNSLMK1njdTnMJf+8PbM88=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nh9x7-00GfTs-F4; Wed, 20 Apr 2022 15:01:01 +0200
Date:   Wed, 20 Apr 2022 15:01:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] net: mdio: Add "use-firmware-led" firmware property
Message-ID: <YmAEDbJJU1hLNSY1@lunn.ch>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
 <20220420124053.853891-3-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420124053.853891-3-kai.heng.feng@canonical.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 08:40:49PM +0800, Kai-Heng Feng wrote:
> Some system may prefer preset PHY LED setting instead of the one
> hardcoded in the PHY driver, so adding a new firmware
> property, "use-firmware-led", to cope with that.
> 
> On ACPI based system the ASL looks like this:
> 
>     Scope (_SB.PC00.OTN0)
>     {
>         Device (PHY0)
>         {
>             Name (_ADR, One)  // _ADR: Address
>             Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
>             {
>                 ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
>                 Package (0x01)
>                 {
>                     Package (0x02)
>                     {
>                         "use-firmware-led",
>                         One
>                     }
>                 }
>             })
>         }
> 
>         Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
>         {
>             ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device Properties for _DSD */,
>             Package (0x01)
>             {
>                 Package (0x02)
>                 {
>                     "phy-handle",
>                     PHY0
>                 }
>             }
>         })
>     }
> 
> Basically use the "phy-handle" reference to read the "use-firmware-led"
> boolean.

Please update Documentation/firmware-guide/acpi/dsd/phy.rst

Please also Cc: the ACPI list. I have no idea what the naming
convention is for ACPI properties.

> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/net/mdio/fwnode_mdio.c | 4 ++++
>  include/linux/phy.h            | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index 1c1584fca6327..bfca67b42164b 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -144,6 +144,10 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  	 */
>  	if (mii_ts)
>  		phy->mii_ts = mii_ts;
> +
> +	phy->use_firmware_led =
> +		fwnode_property_read_bool(child, "use-firmware-led");
> +

This is an ACPI only property. It is not valid in DT. It does not
fulfil the DT naming requirement etc. So please move this up inside
the if (is_acpi_node(child)) clause.

> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 36ca2b5c22533..53e693b3430ec 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -656,6 +656,7 @@ struct phy_device {
>  	/* Energy efficient ethernet modes which should be prohibited */
>  	u32 eee_broken_modes;
>  
> +	bool use_firmware_led;

There is probably a two byte hole after mdix_ctrl. So please consider
adding it there. Also, don't forget to update the documentation.

       Andrew
