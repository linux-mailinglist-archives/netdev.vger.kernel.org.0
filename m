Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254D452307F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbiEKKOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242415AbiEKKNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:13:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A04D2181E4
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=F9uvgbeT21ID1Q9EFsFq/dYBo9tJenIJhjrECKcmtWE=; b=dnRdnyftfZQmsL1bCIPjvzV50x
        KAmRei+cJBu2n0OocnPKKOAiu1FWSOUsjSrgw32o5pMx/OCXzY4DrP0FSaYKfgGzQwZRoOgPIMjzb
        fUx1OXdIVuMCGDH5qt/y44p7Mk+xKJDoKp8SksbyegniOCDosEqMUVk4WtSc6yOpBOgkLjIHhYwLB
        zbKWjl8LS0y5Iz5zmPTCdZ9E997rT/OL0XNTgvXpgYBPDYQuTJVuX0tZrE5j0TQ8ADKagvYx31adi
        4zs95cHImTUEz6Hq7vEpNhivwgwwztgM+WOHBGJb5Cdv7d0/pf6MTJ4lvj3l1h3ywC4RHgp/BHVRd
        6Z5//QhA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60674)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nojL0-0006bY-7B; Wed, 11 May 2022 11:12:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nojKy-000704-E0; Wed, 11 May 2022 11:12:56 +0100
Date:   Wed, 11 May 2022 11:12:56 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Josua Mayer <josua@solid-run.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <YnuMKL0n8xxzLht2@shell.armlinux.org.uk>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
 <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
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

On Tue, May 10, 2022 at 11:56:06AM +0300, Josua Mayer wrote:
> 
> Am 09.05.22 um 15:49 schrieb Andrew Lunn:
> > On Mon, May 09, 2022 at 03:29:38PM +0300, Josua Mayer wrote:
> > > Dear Maintainers,
> > > 
> > > I am working on a new device based on the LX2160A platform, that exposes
> > > 16 sfp connectors, each with its own led controlled by gpios intended
> > > to show link status.
> > Can you define link status?
> I am still struggling with the lower levels of networking terminology ... so
> I was considering when ethtool would report "Link detected: yes".

That is what the netdev LED trigger uses for "link".

> >   It is a messy concept with SFPs. Is it
> > !LOS? I guess not, because you would not of used a GPIO, just hard
> > wired it.
> I believe the intention was to decide later what information to visualize.
> In this iteration there is one LED per sfp connector, with one colour.
> But it is conceivable to in the future add more, and use them to indicate
> e.g. the negotiated speed (10/100/1000/10000).

Doing this at the SFP layer won't get you that - the SFP layer doesn't
know what speed has actually been decided upon.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
