Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF9541880
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 23:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379189AbiFGVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 17:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379966AbiFGVLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 17:11:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB3921682A;
        Tue,  7 Jun 2022 11:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7JLpmF2WWEjZt5s92gmeTOB0LAVvi3DsmkSlokLpb2s=; b=sgEjrBWyLnlD29+Ns5Q/ZOkcLs
        TUfzlICy3mxwL8/vxk4D0UGg8KV2IZkdkayNdiCB91n0/G/tCK1B1ojv9skTIkXd0b+09ti+aa/L1
        ObMQMw01e/rumghyYynjZOOIM1nzYWkDSJ+i/JwwBp6DJiDC0V/hUUyrYHpLf67vy9MFpw97VyzY5
        t/NZo/b0smUbP1XVZrfEMo62pwSWVhBuEkHIv6ZjDqd4gmcNAcDkXAkgtPv/nYtzFoMrFnIHa83KH
        7C7VwSIsS9L1o/pUNbFPIyheMxx6lETSmK0VJihiNObpkcidZl4G4smoR08W/la1e0jm8XNfYMMO7
        goLIgocQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32776)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nyeJY-0003q1-6t; Tue, 07 Jun 2022 19:52:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nyeJV-00012v-B3; Tue, 07 Jun 2022 19:52:25 +0100
Date:   Tue, 7 Jun 2022 19:52:25 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     luizluca@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH net v2] net: dsa: realtek: rtl8365mb: fix GMII caps for
 ports with internal PHY
Message-ID: <Yp+eaUiOwZts/HgS@shell.armlinux.org.uk>
References: <20220607184624.417641-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220607184624.417641-1-alvin@pqrs.dk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 08:46:24PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Since commit a18e6521a7d9 ("net: phylink: handle NA interface mode in
> phylink_fwnode_phy_connect()"), phylib defaults to GMII when no phy-mode
> or phy-connection-type property is specified in a DSA port node of the
> device tree. The same commit caused a regression in rtl8365mb whereby
> phylink would fail to connect, because the driver did not advertise
> support for GMII for ports with internal PHY.
> 
> It should be noted that the aforementioned regression is not because the
> blamed commit was incorrect: on the contrary, the blamed commit is
> correcting the previous behaviour whereby unspecified phy-mode would
> cause the internal interface mode to be PHY_INTERFACE_MODE_NA. The
> rtl8365mb driver only worked by accident before because it _did_
> advertise support for PHY_INTERFACE_MODE_NA, despite NA being reserved
> for internal use by phylink. With one mistake fixed, the other was
> exposed.
> 
> Commit a5dba0f207e5 ("net: dsa: rtl8365mb: add GMII as user port mode")
> then introduced implicit support for GMII mode on ports with internal
> PHY to allow a PHY connection for device trees where the phy-mode is not
> explicitly set to "internal". At this point everything was working OK
> again.
> 
> Subsequently, commit 6ff6064605e9 ("net: dsa: realtek: convert to
> phylink_generic_validate()") broke this behaviour again by discarding
> the usage of rtl8365mb_phy_mode_supported() - where this GMII support
> was indicated - while switching to the new .phylink_get_caps API.
> 
> With the new API, rtl8365mb_phy_mode_supported() is no longer needed.
> Remove it altogether and add back the GMII capability - this time to
> rtl8365mb_phylink_get_caps() - so that the above default behaviour works
> for ports with internal PHY again.
> 
> Fixes: 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Even though I raised concerns about the ext_int thing previously, this
is still a step forward, so:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
