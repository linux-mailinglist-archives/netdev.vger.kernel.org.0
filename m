Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A8957FFE5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbiGYNcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiGYNcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:32:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA381E039;
        Mon, 25 Jul 2022 06:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oqcDs+srAB4YrGHm4QaEElZN7rrloT2cypguG/C5L2c=; b=mE65Ki9Pj7vmrKskiYZ8p7hecg
        oDQHUCTAIohrKFKoD+is4+eUxDF1CBiDZdYT/xsucWFKLy5VP2cZqHVYaO96fyaV4g68+YzwWx0VK
        hEX8Yh1MUX+kob6N6GfvfFdayCcmYZ5isjgqIYjL69dO3bvtRSgH1Go5wzCOg0Gq6UuiXT1XvC+oX
        5oorhklo/7Wz+y5ybR/2drq42GIPPDldsDRTiYNf2nqpiCiBm3AJSfMjJmDmIkGGneBveKTxAOUak
        q0vOt/oCoRlwm197Az/tbc5/9T6k/Dyuk5ayh9olMLbOc2VEkqbGI981DgPjHeU8ikvwZMZ/jnSvJ
        36PwECww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33554)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oFyCL-0002uY-FH; Mon, 25 Jul 2022 14:32:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oFyCJ-0000IT-0F; Mon, 25 Jul 2022 14:32:35 +0100
Date:   Mon, 25 Jul 2022 14:32:34 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
Message-ID: <Yt6bcnnMr7UAUFPk@shell.armlinux.org.uk>
References: <20220714010021.1786616-1-mw@semihalf.com>
 <20220724233807.bthah6ctjadl35by@skbuf>
 <CAPv3WKdFNOPRg45TiJuAVuxM0LjEnB0qZH70J1rMenJs7eBJzw@mail.gmail.com>
 <20220725122144.bdiup756mgquae3n@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725122144.bdiup756mgquae3n@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 03:21:44PM +0300, Vladimir Oltean wrote:
> On Mon, Jul 25, 2022 at 02:18:45AM +0200, Marcin Wojtas wrote:
> > I can of course apply both suggestions, however, I am wondering if I
> > should resend them at all, as Russell's series is still being
> > discussed. IMO it may be worth waiting whether it makes it before the
> > merge window - if not, I can resend this patch after v5.20-rc1,
> > targetting the net branch. What do you think?
> 
> I just don't want a fix for a known regression to slip through the cracks.
> You can resend whenever you consider, but I believe that if you do so now
> (today or in the following few days), you won't conflict with anybody's work,
> considering that this has been said:
> 
> On Fri, Jul 15, 2022 at 11:57:20PM +0100, Russell King (Oracle) wrote:
> > Well, at this point, I'm just going to give up with this kernel cycle.
> > It seems impossible to get this sorted. It seems impossible to move
> > forward with the conversion of Marvell DSA to phylink_pcs.

That is correct - I'm not intending to submit it, because there's not
enough time to sort out the mess that has been created by comments
on the approach coming way too late.

And in fact, I'm now _scared_ to submit a revision of it. I don't want
to get into writing lots more replies that take hours to compose only
to have responses that require yet more multi-hour sessions to reply
to, which only then lead to the cycle repeating with no sign of an end
to it. Something is very wrong with email as a communication tool when
things get to that point.

So, I won't be working on this. Someone else can sort the problem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
