Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2116614A40
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiKAMBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKAMBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:01:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2F8BFE
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EOVSXhyAMLoma5wRr3F50Wg6YLrDzqA7dXZKl3Izr3U=; b=rmmEFJTWJ6X0Oc7x/hKwx7i/GZ
        31mziOKqP/47l2Z83NYr9jtxSd3jha41S7bAwGA9eiq8of9rPn4BGJZaLjH/U5Uq6sSocv7oBe+RS
        1sg8WN5Uu7+4ilCRu0N0mfp3tPFW2amheRzZRnWXGOktU5xKYdLKgXMsewAaYGkMUPhILP8Nf8dmd
        zt88Rf9Y90lhkxvOeHKE2kaW6EDW6v2BObTozS086ERhJrwgBBsF2O1JTZzWWiAZR8ulog+oyyDOB
        aGexEZZy9he1C7AkPfg8wnug7Q/2Zf/mxzCjtUqNEfGqFHsLzL0Rzy5RQYVNj5Mir5nGfF6NN0Gb4
        brNslaGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35064)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oppxY-00043A-5D; Tue, 01 Nov 2022 12:01:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oppxU-0006Pv-Ir; Tue, 01 Nov 2022 12:01:32 +0000
Date:   Tue, 1 Nov 2022 12:01:32 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Message-ID: <Y2EKnLt2SyhjvcNI@shell.armlinux.org.uk>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101114806.1186516-5-vladimir.oltean@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
> Not all DSA drivers provide config->mac_capabilities, for example
> mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
> those drivers on recent kernels and no one reported that they fail to
> establish a link, so I'm guessing that they work (somehow). But I must
> admit I don't understand why phylink_generic_validate() works when
> mac_capabilities=0. Anyway, these drivers did not provide a
> phylink_validate() method before and do not provide one now, so nothing
> changes for them.

There is a specific exception:

static void dsa_port_phylink_validate(struct phylink_config *config,
                                      unsigned long *supported,
                                      struct phylink_link_state *state)
{
        struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
        struct dsa_switch *ds = dp->ds;

        if (!ds->ops->phylink_validate) {
                if (config->mac_capabilities)
                        phylink_generic_validate(config, supported, state);
                return;

When config->mac_capabilities is zero, and there is no phylink_validate()
function, dsa_port_phylink_validate() becomes a no-op, and the no-op
case basically means "everything is allowed", which is how things worked
before the generic validation was added, as you will see from commit
5938bce4b6e2 ("net: dsa: support use of phylink_generic_validate()").

Changing this as you propose below will likely break these drivers.

A safer change would be to elimate ds->ops->phylink_validate, leaving
the call to phylink_generic_validate() conditional on mac_capabilities
having been filled in - which will save breaking these older drivers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
