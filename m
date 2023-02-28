Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02926A5DD3
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjB1Q7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjB1Q7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:59:08 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE96130EE
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xCnlc1Gki00zW7kdKJSzUwNMkxyFMg76xsHdm9UNSNk=; b=ufQ3YSF9BC4gr732h7PmHOvE7b
        75xLYDN9h14RsXRKP8WCcfvssybkruXaEiFmyH1JSd2liEAruniMM6bj3oYPoXvhqSalpp+1b28WX
        sMNTMlpDwXJEbX6Zluy9NVCPcX5VzZuKWi2z8rYFSRrFJ7uvSXEZwLnYfwd1o955aUYqCYpPRy+2R
        eXEayi8QJOBlYszAi81KPjWNNc8/fCbkmU9//F3DNjZMddNR2TguLU+fhR6Niz3SE6c6cBCa/Ruip
        5qB1ZQKJGGsNX99E0XdL7/cZfx/Ml5wYuiIB1SpsJGtqchCrBdTxdeYv15rRs7Q7Mr4khj3m8FYTr
        YWwg2Ypg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43790)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pX3JV-00052l-5l; Tue, 28 Feb 2023 16:58:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pX3JT-0002tA-08; Tue, 28 Feb 2023 16:58:51 +0000
Date:   Tue, 28 Feb 2023 16:58:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        richardcochran@gmail.com, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <Y/4yymy8ZBlMrjDG@shell.armlinux.org.uk>
References: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
 <20230228164435.133881-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228164435.133881-1-michael@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 05:44:35PM +0100, Michael Walle wrote:
> >> 4. Letting drivers override PHY at run time.
> >
> > I think this is the only sensible solution - we know for example that
> > mvpp2 will prefer its PTP implementation as it is (a) higher resolution
> > and (b) has more flexibility than what can be provided by the Marvell
> > PHYs that it is often used with.
> 
> Please also consider that there might be one switch with a shared
> PHC and multiple PHYs, each with its own PHC.

Doesn't the PTP API already allow that? The PHC is a separate API from
the network hardware timestamping - and the netdev/PHY is required
to implement the ethtool get_ts_info API that provides userspace with
the index to the PHC associated with the interface.

> In this case, it is a
> property of the board wether PHY timestamping actually works, because
> it will need some kind of synchronization between all the PHYs.

How is this any different from e.g. a platform where there are
multiple network interfaces each with their own independent PHC
such as Macchiatobin, where there are two CP110 dies, each with
their own group of three ethernet adapters, and each die has its
own PHC shared between the three ethernet adapters?

Hardware synchronisation between the two PHCs isn't possible, but
they might tick at the same rate (it's something that hasn't been
checked.) However, the hardware signals aren't that helpful because
there's no way to make e.g. the rising edge always be at the start
of a second. So the synchronisation has to be done in software.

I don't think PHCs need to be synchronised in hardware to "actually
work". Take an example of a PC with two network cards, both having
their own independent PHC.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
