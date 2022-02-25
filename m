Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9364D4C42F4
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbiBYK6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiBYK6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:58:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FCD197B47
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hMGbU3Vkj5WK+JmlrMWQYsksGK4/IrXnet4jcvWIigw=; b=PLtxBaiiLbTzRZ2KGN0n7/bBiB
        UW5pS3VVOP01KMjlzmItcrUew9yJGjT2/j9bWqrjeHQRx0L9AydORDkyjav4WUfEKHfTnDE/2aK+o
        J679mFf+KQD1oOpbaJgqkoWVqejRlvAjTBeN5HWzEtKEw68b91P4G9HRDpelWsh+VeUQGqh4431BE
        9rauuV+xr5KK+7x+A9lS84k92rl+R1UfyA9Dki3LIU6L02ANIfd3I0aAty49rEnKD2EX1TwSPh2RE
        84VoS2E6JvseIGGFQQZ0QeeI4eCf4BebcYER2yH5Jn5LcDvQ1XbOKftP9Q9v8rZK6B2/O06/paSYF
        pjh139rA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57474)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNYIB-0005Co-64; Fri, 25 Feb 2022 10:57:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNYI9-0002zK-0D; Fri, 25 Feb 2022 10:57:41 +0000
Date:   Fri, 25 Feb 2022 10:57:40 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/6] net: dsa: sja1105: use
 .mac_select_pcs() interface
Message-ID: <Yhi2JHfZ+QI95J9V@shell.armlinux.org.uk>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGm6-00AOip-6r@rmk-PC.armlinux.org.uk>
 <20220225103913.abn4pc57ow6dy2m6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225103913.abn4pc57ow6dy2m6@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 12:39:13PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 24, 2022 at 04:15:26PM +0000, Russell King (Oracle) wrote:
> > Convert the PCS selection to use mac_select_pcs, which allows the PCS
> > to perform any validation it needs, and removes the need to set the PCS
> > in the mac_config() callback, delving into the higher DSA levels to do
> > so.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks.

> > -	.phylink_mac_config	= sja1105_mac_config,
> 
> Deleting sja1105_mac_config() here is safe not because
> phylink_mac_config() stops calling pl->mac_ops->mac_config(), but
> because dsa_port_phylink_mac_config() first checks whether
> ds->ops->phylink_mac_config is implemented, and that is purely an
> artefact of providing a phylib-style ds->ops->adjust_link, right?

Yes and no.

We already have a several DSA drivers that have NULL phylink_mac_config
and that don't provide an adjust_link function. Even if adjust_link was
eventually killed off, the test in dsa_port_phylink_mac_config() would
still be necessary unless all these DSA drivers are updated with a stub
function for it.

Consequently, I view phylink_mac_config in DSA as entirely optional and
that optionality is already very much a part of the DSA interface, even
though that is not the case with the corresponding phylink_mac_ops
.mac_config method.

Moreover, this optionality is a common theme in DSA switch operations
methods.

> Maybe it's worth mentioning.

Given that .phylink_mac_config is already established as being optional
in DSA, does the addition of one more instance need to be explicitly
mentioned?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
