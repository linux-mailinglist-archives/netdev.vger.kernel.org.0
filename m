Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD6486A64
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243254AbiAFTPc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jan 2022 14:15:32 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34181 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243146AbiAFTPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:15:31 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 71CA0E0008;
        Thu,  6 Jan 2022 19:15:28 +0000 (UTC)
Date:   Thu, 6 Jan 2022 20:15:26 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     David Girault <David.Girault@qorvo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Frederic Blain <Frederic.Blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
Message-ID: <20220106201526.7e513f2f@xps13>
In-Reply-To: <CAB_54W4Z1KgT+Cx0SXptvkwYK76wDOFTueFUFF4e7G_ABP7kkA@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-18-miquel.raynal@bootlin.com>
        <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
        <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
        <CAB_54W6ikdGe=ZYqOsMgBdb9KBtfAphkBeu4LLp6S4R47ZDHgA@mail.gmail.com>
        <20220105094849.0c7e9b65@xps13>
        <CAB_54W4Z1KgT+Cx0SXptvkwYK76wDOFTueFUFF4e7G_ABP7kkA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 5 Jan 2022 19:23:04 -0500:

> Hi,
> 
> On Wed, 5 Jan 2022 at 03:48, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Thu, 30 Dec 2021 14:48:41 -0500:
> >  
> > > Hi,
> > >
> > > On Thu, 30 Dec 2021 at 12:00, David Girault <David.Girault@qorvo.com> wrote:  
> > > >
> > > > Hi Alexander,
> > > >
> > > > At Qorvo, we have developped a SoftMAC driver for our DW3000 chip that will benefit such API.
> > > >  
> > > Do you want to bring this driver upstream as well? Currently those
> > > callbacks will be introduced but no user is there.  
> >
> > I think so far the upstream fate of the DW3000 driver has not been ruled
> > out so let's assume it won't be upstreamed (at least not fully), that's
> > also why we decided to begin with the hwsim driver.
> >  
> 
> ok.
> 
> > However, when designing this series, it appeared quite clear that any
> > hardMAC driver would need this type of interface. The content of the
> > interface, I agree, could be further discussed and even edited, but the
> > main idea of giving the information to the phy driver about what is
> > happening regarding eg. scan operations or beacon frames, might make
> > sense regardless of the current users, no?
> >  
> 
> A HardMAC driver does not use this driver interface... but there
> exists a SoftMAC driver for a HardMAC transceiver. This driver
> currently works because we use dataframes only... It will not support
> scanning currently and somehow we should make iit not available for
> drivers like that and for drivers which don't set symbol duration.
> They need to be fixed.

My bad. I did not look at it correctly. I made a mistake when talking
about a hardMAC.

Instead, it is a "custom" low level MAC layer. I believe we can compare
the current mac802154 layer mostly to the MLME that is mentioned in the
spec. Well here the additional layer that needs these hooks would be
the MCPS. I don't know if this will be upstreamed or not, but the need
for these hooks is real if such an intermediate low level MAC layer
gets introduced.

In v2 I will get rid of the two patches adding "driver access" to scans
and beacons in order to facilitate the merge of the big part. Then we
will have plenty of time to discuss how we can create such an interface.
Perhaps I'll be able to propose more code as well to make use of these
hooks, we will see.

> > This being said, if other people decide to upstream a hardMAC driver
> > and need these hooks to behave a little bit differently, it's their
> > right to tweak them and that would also be part of the game.
> >
> > Although we might not need these hooks in a near future at all if we
> > move to the filtering modes, because the promiscuous call with the
> > specific level might indicate to the device how it should configure
> > itself already.
> >  
> 
> My concern is that somebody else might want to remove those callbacks
> because they are not used.

Yes, this is likely to happen quickly because of robots :)

Thanks,
Miquèl
