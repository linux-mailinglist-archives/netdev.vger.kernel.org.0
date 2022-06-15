Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7354C354
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241637AbiFOIRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiFOIRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:17:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300B93F32F
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 01:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eqaRobKnAUU3BvEA8fKWtrivlwnTouchar71TS8QUXw=; b=WC709MTc6Nxj8rnyP1/+4LArVf
        eqQC6vJ6id2zCso0Mlwje9ARyrZmbg+scUdMRPyluREQ6Y3c32bphMBsC4hjy8wldwt4ieMYMhXsd
        8vArsugNmI+edtHcUmS6saSa8+qOA3K2j9DKXbeQd/HmmXf0uC100wVaDNC9I50OgaOroNNspqVWa
        TZQxbEe4AC0w5bh2J3HcZdRRZFJiwmF2tERMSvcJQIW/wntuZK3PBp7uATWRxiTkS/sHMgujo/ikd
        aGGyONw6oSOr9E4eq4CgWTp9mR0O+zAHdQ7BEIxLWFEQgz8yHAkkdLy4FKKaFptPsXb6Fqc/8vz0A
        JoD9QYVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32872)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o1OCy-0004A9-SO; Wed, 15 Jun 2022 09:17:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o1OCs-0008H4-FV; Wed, 15 Jun 2022 09:16:54 +0100
Date:   Wed, 15 Jun 2022 09:16:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 02/15] net: phylink: add phylink_pcs_inband()
Message-ID: <YqmVdj4X5101PC1u@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
 <E1o0jgF-000JYC-49@rmk-PC.armlinux.org.uk>
 <20220614224652.09d4c287@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614224652.09d4c287@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 10:46:52PM -0700, Jakub Kicinski wrote:
> On Mon, 13 Jun 2022 14:00:31 +0100 Russell King (Oracle) wrote:
> > +	if (phylink_autoneg_inband(mode) &&
> > +	    (interface == PHY_INTERFACE_MODE_SGMII ||
> > +	     interface == PHY_INTERFACE_MODE_QSGMII ||
> > +	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
> > +		return true;
> > +	else
> > +		return false;
> 
> Okay, let me be a little annoying...

No, not annoying!

> Could you run thru checkpatch --strict and fix the few whitespace
> issues it points out? There's a handful of spaces instead of tabs,
> unaligned continuation lines and an unnecessary bracket.

That somewhat surprises me... will fix most of the strict errors,
except this one:

WARNING: function definition argument 'struct mv88e639x_pcs *' should also have
an identifier name
#337: FILE: drivers/net/dsa/mv88e6xxx/pcs-639x.c:93:
+       irqreturn_t (*handler)(struct mv88e639x_pcs *);

because its utterly pointless. What extra information would adding "pcs"
give to the reader? I can Understand it for standard C types because they
are opaque, but not for this.

> Patch 1 does not need to be backported so I presume it can lose the
> fixes tag?

As the commit talks about fixing something, in my experience the commit
will get automatically selected for backporting to stable trees whether
or not it has a fixes tag on it. The only way to stop that happening is
not through avoiding a fixes tag, but to keep on top of the stable tree
emails to stop patches being backported that don't need to be.

If you still want me to remove it, I will, but I predict it will still
be backported.

> The quoted code can be converted into a direct return of the condition,
> I don't really care but I think there are bots out there which will
> send a "fix" soon if we commit this.
> 
> And patch 10 generates a transient "function should be static" warning.
> I think you need a __maybe_unused on mv88e6xxx_pcs_select() as well.

Gah, I did build-test each patch individually, but I guess because of
the time it takes to do so I must have not looked at the results
properly - will fix.

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
