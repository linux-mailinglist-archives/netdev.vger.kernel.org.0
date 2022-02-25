Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC394C4A47
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbiBYQPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242692AbiBYQPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:15:01 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BA41A8CBB
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iPvJebepbVJFCUzoQ/GxDKn9s1/SdDoLPZgR6UW6qgs=; b=CYZKs3oWs12ba0vpbKBPlzDbSm
        VGWf4xGRls2En9YTlP3f4Tk3QvIoURwoR/RKvM2E8YrOSuUno4/Cs0oe009aD7eVulC7+GwqL8z1x
        LqNYSWegxmoxHIpKEzHSdrHVJky0kSVDQlhPZMB6x03XdkyOyIPkWpq98LAmx9sEOZhThLmcMz87z
        EurvxaRiQO3W+9LfhVY5XeTDfsrkPbEEn0Tw3Yo/KZ+dbMV9pqc3z5/rTzs52AvSW51AQrVZiG+gr
        9e+YX6r6FiVLgkmf2CJzoYKVElbbVnj2wBS9I6SSMp6gw6TJqbe78vYp7/S7beOWC+O+jhmzhJLQl
        kWMO7F4Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57500)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNdEb-0005gU-Lh; Fri, 25 Feb 2022 16:14:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNdEa-0003De-GV; Fri, 25 Feb 2022 16:14:20 +0000
Date:   Fri, 25 Feb 2022 16:14:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Message-ID: <YhkAXKh0WIQmMYol@shell.armlinux.org.uk>
References: <Yhj+NnrggVRPmlT8@shell.armlinux.org.uk>
 <E1nNd76-00Anzt-IH@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNd76-00Anzt-IH@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 04:06:36PM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces bitmap for the Ocelot DSA switches.
> 
> Since all sub-drivers only support a single interface mode, defined by
> ocelot_port->phy_mode, we can handle this in the main driver code
> without reference to the sub-driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/ocelot/felix.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 9959407fede8..88fbbd03c81b 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -778,6 +778,15 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
>  	return ocelot_vlan_del(ocelot, port, vlan->vid);
>  }
>  
> +static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
> +				   struct phylink_config *config)
> +{
> +	struct ocelot *ocelot = ds->priv;
> +
> +	__set_bit(ocelot->ports[port].phy_mode,

Sorry, this should be ->phy_mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
