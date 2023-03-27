Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BBE6CB110
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjC0Vxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC0Vxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:53:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3217F12E
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 14:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8tY0EYnHj3jeUWCkoSv1I9M7ZwjFASXrsz6dbTd93IE=; b=U7NbSCavv2g7p57qNAAMtTamaA
        lhzLm0pE1ZtKew8/wbowRv9ZKqhtlqli4cq6rZFeCagCQBbUyBL43zpVnPqEKWLWHQ2h0+lN+8YT6
        DSTdU1EL7nDFoz/abcbGv2W+XvnDe3lvYq4vSNnjFjuu5h+InPmN1veKJ7Jwn61JTbxdCB5rSzDT6
        G5y8LGUK/UhKAWfw5v5QX2VrPKnoEkB5879kXFsO/QXoKETSS9yCDOsqRaCzNiVb3NAhroWkkHA/I
        YFiN2NdyKvF1oBuE/jazBdJw3prEhIqXxh9RX7cszj7hdZ1FMqZoijQ1qs68eXhv1g3yNwiJoKf3C
        9q8xLBSw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59362)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgumY-0004mE-7Q; Mon, 27 Mar 2023 22:53:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgumW-0005na-JX; Mon, 27 Mar 2023 22:53:36 +0100
Date:   Mon, 27 Mar 2023 22:53:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 02/23] net: phylink: Plumb eee_active in mac_link_up
 call
Message-ID: <ZCIQYJVMoG3RUfN3@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-3-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thinking about this more having read the follow-on patches, I retract
my r-b tag, because there is an issue that needs solving.

On Mon, Mar 27, 2023 at 07:01:40PM +0200, Andrew Lunn wrote:
> @@ -1257,7 +1260,8 @@ static void phylink_link_up(struct phylink *pl,
>  
>  	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
>  				 pl->cur_interface, speed, duplex,
> -				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
> +				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause,
> +				 eee_active);

In one of your later patches, you have phylib call phy_link_up() when
the state changes as a result of configuration. That will cause
phy_link_change(), which will update phylink's stored link state, and
trigger phylink to re-resolve the link.

However, phylink guarantees that mac_link_up() will only be called
if mac_link_down() was previously called. This will *not* cause
mac_link_up() to be called.

Moreover, we don't want mac_link_up() to be called because the link
hasn't gone down and to do so will violate that guarantee that
phylink makes to MAC drivers.

So, I don't think this is going to work fully as seems to be intended,
if I'm understanding things correctly.

Maybe we should have a new mac_set_eee() method which we can call
when the EEE state changes? Would we need to call it with the LPI
delay parameter and wheneever that changes, or should we rely on
the MAC to do that? What if the LPI parameter is dependent on the
speed the MAC is operating? Just brain-storming...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
