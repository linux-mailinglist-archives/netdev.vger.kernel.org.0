Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7F84BDD6C
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236109AbiBUNaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:30:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbiBUNai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:30:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C174113D30
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ahkwxjWHNSiT2ayAwIqa4ergL7YUdarz58urXi+nBbg=; b=mGKkGAqNQo7I7ZH9BN8Pq9lnRJ
        q2BjO6YaArzhys39opY5UuaoS6QrwIgQkA+DvXdR5Ckj0Y+PxDvo4LV7EePywQSm8OLvkoAQ5C0az
        py1V1JW7bTZIdpWGnLMH73VanWnkXKTNJVAc25yaTAuPAOVX5fEhuBFHmv+QeFjqxDAezruu1HQ2r
        4trBYg0tPu0NawQWE6hdEoAx0BV0ix8Me/D6Y/8+irhPL+n0A+jOgZjeodTQuUQFvQXEQZjhVUzde
        CODvZIda06B+yrCOl3BL+RRPGRsipvBEduIYjWC/2cHHOXeyEWaVqUorUTAn17dnisU5oam3MUwud
        AxwSHj+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57390)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nM8lW-0000QC-SF; Mon, 21 Feb 2022 13:30:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nM8lV-0007KL-1K; Mon, 21 Feb 2022 13:30:09 +0000
Date:   Mon, 21 Feb 2022 13:30:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v2 1/6] net: dsa: add support for phylink
 mac_select_pcs()
Message-ID: <YhOT4WbZ1FHXDHIg@shell.armlinux.org.uk>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
 <E1nKlY3-009aKs-Oo@rmk-PC.armlinux.org.uk>
 <20220219211241.beyajbwmuz7fg2bt@skbuf>
 <20220219212223.efd2mfxmdokvaosq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219212223.efd2mfxmdokvaosq@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 11:22:24PM +0200, Vladimir Oltean wrote:
> On Sat, Feb 19, 2022 at 11:12:41PM +0200, Vladimir Oltean wrote:
> > >  static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
> > >  	.validate = dsa_port_phylink_validate,
> > > +	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
> > 
> > This patch breaks probing on DSA switch drivers that weren't converted
> > to supported_interfaces, due to this check in phylink_create():
> 
> And this is only the most superficial layer of breakage. Everywhere in
> phylink.c where pl->mac_ops->mac_select_pcs() is used, its presence is
> checked and non-zero return codes from it are treated as hard errors,
> even -EOPNOTSUPP, even if this particular error code is probably
> intended to behave identically as the absence of the function pointer,
> for compatibility.

I don't understand what problem you're getting at here - and I don't
think there is a problem.

While I know it's conventional in DSA to use EOPNOTSUPP to indicate
that a called method is not implemented, this is not something that
is common across the board - and is not necessary here.

The implementation of dsa_port_phylink_mac_select_pcs() returns a
NULL PCS when the DSA operation for it is not implemented. This
means that:

1) phylink_validate_mac_and_pcs() won't fail due to mac_select_pcs()
   being present but DSA drivers not implementing it.

2) phylink_major_config() will not attempt to call phylink_set_pcs()
   to change the PCS.

So, that much is perfectly safe.

As for your previous email reporting the problem with phylink_create(),
thanks for the report and sorry for the breakage - the breakage was
obviously not intended, and came about because of all the patch
shuffling I've done over the last six months trying to get these
changes in, and having forgotten about this dependency.

I imagine the reason you've raised EOPNOTSUPP is because you wanted to
change dsa_port_phylink_mac_select_pcs() to return an error-pointer
encoded with that error code rather than NULL, but you then (no
surprises to me) caused phylink to fail.

Considering the idea of using EOPNOTSUPP, at the two places we call
mac_select_pcs(), we would need to treat this the same way we currently
treat NULL. We would also need phylink_create() to call
mac_select_pcs() if the method is non-NULL to discover if the DSA
sub-driver implements the method - but we would need to choose an
interface at this point.

I think at this point, I'd rather:

1) add a bool in struct phylink to indicate whether we should be calling
   mac_select_pcs, and replace the

	if (pl->mac_ops->mac_select_pcs)

   with

        if (pl->using_mac_select_pcs)

2) have phylink_create() do:

	bool using_mac_select_pcs = false;

	if (mac_ops->mac_select_pcs &&
	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) != 
	      ERR_PTR(-EOPNOTSUPP))
		using_mac_select_pcs = true;

	if (using_mac_select_pcs &&
	    phy_interface_empty(config->supported_interfaces)) {
		...

	...

	pl->using_mac_select_pcs = using_mac_select_pcs;

which should give what was intended until DSA drivers are all updated
to fill in config->supported_interfaces.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
