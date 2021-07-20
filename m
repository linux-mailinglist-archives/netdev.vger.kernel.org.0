Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC89D3CFFFC
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhGTQec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhGTQeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 12:34:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35342C0613DB
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 10:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7cHKqEQDiiTmHYi14BY/DjXD7FItWf37FKIzXMObQwE=; b=pD6uKZFG0wGGeBQuntL97yaAf
        aRXA/tX+nCZDrShjc++ksMJHp04ss7XK9PdcFeEhoRdaNsX0lUgh9jY9xWs1pKcCP4FPc22OOYRXK
        wqCVx29dKVYC8/U4aBhg84h3Rpa1extCLl3QUrJgGT3NJUPurJIiK27qN/X/SI5Qy/oE6/Zw0dP7l
        /jj+PH7Kg3JfCuj11DpZQm4EveRkmhryhlhgunHpJrQ1OwFBSgIH1oyBiHU9dyBbkCThjQ98VqCWu
        qloYU4EoXpK1nsQBXr8SNaqzikxEqKG/Oq5thaJSYB+uzr1ju2sEG2AjkTnk8uDxoPMoLSTiq31jU
        1bnFgsRKw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46376)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m5tJj-0006g7-CV; Tue, 20 Jul 2021 18:14:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m5tJh-000753-O5; Tue, 20 Jul 2021 18:14:01 +0100
Date:   Tue, 20 Jul 2021 18:14:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift tunable
 support
Message-ID: <20210720171401.GV22278@shell.armlinux.org.uk>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
 <20210720170424.07cba755@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210720170424.07cba755@dellmb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 05:04:24PM +0200, Marek Behún wrote:
> Hi Russell,
> 
> On Tue, 20 Jul 2021 14:38:20 +0100
> Russell King <rmk+kernel@armlinux.org.uk> wrote:
> 
> > Add support for the downshift tunable for the Marvell 88x3310 PHY.
> > Downshift is only usable with firmware 0.3.5.0 and later.
> 
> mv3310_{g,s}et_features are also used for 88E211x, but there is no such
> register in the documentation for these PHYs. (Also firmware versions on
> those are different, the newest is 8.3.0.0, but thats not important.)
> My solution would be to rename the current methods prefix to mv211x_ and
> and add new mv3310_{g,s}et_tunable methods.

There's more than just the tunables themselves - there's also
config_init().

We already need to reject downshift when old firmware is running,
as that fails to work correctly. So, we can just do that for
88E211x as well, adding a flag to struct mv3310_chip to indicate
whether downshift is present. Sound sensible?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
