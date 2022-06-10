Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53A2546A9F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349596AbiFJQhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349369AbiFJQhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:37:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843EA58E61;
        Fri, 10 Jun 2022 09:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GU5EGVeTqN5+C1jzIs0AK4LYqqFPJgnxg1VAjCLxsuM=; b=VL/CuC9jG/VSJ4pukOpiQLXsjw
        Duh8E9PDnQpKExZeAOfaEkvppZfvnJMxaGjA+3WIyKE3a5xgByLieyfRz0zTq7AvXaxXcBteTDt82
        qmY2aKF1JlbXy0e3/eZ2hufOEk7o/FuoekMOwsbSDvRmT+48gnmKW1GoU2GAOlkXHc2M8wfL+xQMZ
        XDSU0hW8kSEIPXglFdSKowBLCfnUtRr8esuufnnMB3KhmxdVOMV/hb1+rNdGu886nPwd8I7tW5Ghi
        lcYzYo7Vn2wXrWfsfWwKXco3nnOZy7L8zdP1/WFYri7F9+CyTLSB2FgRcn+CwqDDXATNsNp5IWXHe
        WIVw8gZg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32818)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nzhcp-0007ot-DT; Fri, 10 Jun 2022 17:36:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nzhcl-0003oO-Ib; Fri, 10 Jun 2022 17:36:39 +0100
Date:   Fri, 10 Jun 2022 17:36:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     hauke@hauke-m.de, Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
Message-ID: <YqNzF7KbSI9h0tSQ@shell.armlinux.org.uk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
 <20220610153829.446516-6-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220610153829.446516-6-alvin@pqrs.dk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 05:38:29PM +0200, Alvin Šipraga wrote:
> Finally, rtl8365mb_phylink_get_caps() is fixed up to return supported
> capabilities based on the external interface properties described above.
> This allows for ports with an external interface to be treated as DSA
> user ports, and for ports with an internal PHY to be treated as DSA CPU
> ports.

I've needed to read that a few times... and I'm still not sure. You seem
to be saying that:
- ports with an internal PHY (which presumably provide baseT connections?)
  are used as DSA CPU ports.
- ports with an external interface supporting a range of RGMII, SGMII and
  HSGMII interface modes are DSA user ports.

With Marvell switches, it's the other way around - the ports with an
internal PHY are normally DSA user ports. Other ports can be a user,
inter-switch or CPU port.

So, I'm slightly confused by your description.

In any ase, looking at the get_caps() (and only that):

> @@ -953,7 +1026,13 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
>  static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
>  				       struct phylink_config *config)
>  {
> -	if (dsa_is_user_port(ds, port)) {
> +	const struct rtl8365mb_extint *extint =
> +		rtl8365mb_get_port_extint(ds->priv, port);
> +
> +	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> +				   MAC_10 | MAC_100 | MAC_1000FD;

MAC capabilities are constant across all interfaces - okay.

> +
> +	if (!extint) {
>  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>  			  config->supported_interfaces);
>  
> @@ -962,12 +1041,16 @@ static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
>  		 */
>  		__set_bit(PHY_INTERFACE_MODE_GMII,
>  			  config->supported_interfaces);
> -	} else if (dsa_is_cpu_port(ds, port)) {
> -		phy_interface_set_rgmii(config->supported_interfaces);
> +		return;

Internal ports need to support phylib, so both internal and gmii
interface modes - okay.

>  	}
>  
> -	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> -				   MAC_10 | MAC_100 | MAC_1000FD;
> +	/* Populate according to the modes supported by _this driver_,
> +	 * not necessarily the modes supported by the hardware, some of
> +	 * which remain unimplemented.
> +	 */
> +
> +	if (extint->supported_interfaces & RTL8365MB_PHY_INTERFACE_MODE_RGMII)
> +		phy_interface_set_rgmii(config->supported_interfaces);

External ports that support RGMII get all RGMII modes - also okay.

So, for the get_cops() function, I'm fine with this new code, and for
this alone:

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

I haven't looked at the remainder of the changes.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
