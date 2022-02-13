Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71B44B3B6A
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 13:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiBMM6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 07:58:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbiBMM6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 07:58:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D696A5B88E;
        Sun, 13 Feb 2022 04:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=76rqzaWttVih/dB1HTOqZ2nr+hKq7a/b3VRkDpxa+lc=; b=Nq+JN+NnVPwtOeljjpbmascntu
        DVMUZ+IreQIYZxM6UaN/s4OlBNX3Z6LA9amdN5oPeBCBpKbXMLGzOdpTu52eqHBCm/tiJGxxQZPMR
        4YuW7QxKHvxHqu7uYXhbdU1tQpr22me9/ZW5BbexJUgCAk0Zg3JX6wWm/llWMJTLM+Llzx8jOZYfb
        urG6NsStPy6oCGRdb6/rQ7bUliGbUzLCEDceSdSP22smbQhdZ+ut4Bg/W04cFS8gGDCKT5nsdBf7j
        mon6JwUpAPhVRarsLPiU0301RjMbuqSXl7zCW/724DTMukgrkutFNPSNCghxvBY6sukoqu1yNImDj
        z22wIrtQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57228)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nJESf-0000QO-OX; Sun, 13 Feb 2022 12:58:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nJESd-0005aV-DT; Sun, 13 Feb 2022 12:58:39 +0000
Date:   Sun, 13 Feb 2022 12:58:39 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fix validation of built-in
 PHYs on 6095/6097
Message-ID: <YgkAfy3fQ1hq7nlf@shell.armlinux.org.uk>
References: <20220213003702.2440875-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213003702.2440875-1-tobias@waldekranz.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for spotting this. Some comments below.

On Sun, Feb 13, 2022 at 01:37:01AM +0100, Tobias Waldekranz wrote:
> +static void mv88e6095_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
> +				       struct phylink_config *config)
> +{
> +	u8 cmode = chip->ports[port].cmode;
> +
> +	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
> +
> +	if (mv88e6xxx_phy_is_internal(chip->ds, port)) {
> +		if (cmode == MV88E6185_PORT_STS_CMODE_PHY)
> +			__set_bit(PHY_INTERFACE_MODE_MII,
> +				  config->supported_interfaces);

Hmm. First, note that with mv88e6xxx_get_caps(), you'll end up with both
MII and GMII here. GMII is necessary as that's the phylib default if no
one specifies anything different in the firmware description. I assume
you've noticed a problem because you specify MII for the internal ports
in firmware?

I'm wondering what the point of checking the cmode here is - if the port
is internal, won't this switch always have cmode == PHY?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
