Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1964873AB
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 08:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiAGHkh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Jan 2022 02:40:37 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:55251 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbiAGHkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 02:40:35 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 431C31BF207;
        Fri,  7 Jan 2022 07:40:30 +0000 (UTC)
Date:   Fri, 7 Jan 2022 08:40:29 +0100
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
Message-ID: <20220107084029.21f341a4@xps13>
In-Reply-To: <CAB_54W7=YJu7qJPcGX0O6nkBhmg7EmX2iTy+Q+EgffqE5+0NCQ@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-18-miquel.raynal@bootlin.com>
        <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
        <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
        <CAB_54W6ikdGe=ZYqOsMgBdb9KBtfAphkBeu4LLp6S4R47ZDHgA@mail.gmail.com>
        <20220105094849.0c7e9b65@xps13>
        <CAB_54W4Z1KgT+Cx0SXptvkwYK76wDOFTueFUFF4e7G_ABP7kkA@mail.gmail.com>
        <20220106201526.7e513f2f@xps13>
        <CAB_54W7=YJu7qJPcGX0O6nkBhmg7EmX2iTy+Q+EgffqE5+0NCQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Thu, 6 Jan 2022 23:21:45 -0500:

> Hi,
> 
> On Thu, 6 Jan 2022 at 14:15, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Wed, 5 Jan 2022 19:23:04 -0500:
> >  
> ...
> > >
> > > A HardMAC driver does not use this driver interface... but there
> > > exists a SoftMAC driver for a HardMAC transceiver. This driver
> > > currently works because we use dataframes only... It will not support
> > > scanning currently and somehow we should make iit not available for
> > > drivers like that and for drivers which don't set symbol duration.
> > > They need to be fixed.  
> >
> > My bad. I did not look at it correctly. I made a mistake when talking
> > about a hardMAC.
> >
> > Instead, it is a "custom" low level MAC layer. I believe we can compare
> > the current mac802154 layer mostly to the MLME that is mentioned in the
> > spec. Well here the additional layer that needs these hooks would be
> > the MCPS. I don't know if this will be upstreamed or not, but the need
> > for these hooks is real if such an intermediate low level MAC layer
> > gets introduced.
> >
> > In v2 I will get rid of the two patches adding "driver access" to scans
> > and beacons in order to facilitate the merge of the big part. Then we
> > will have plenty of time to discuss how we can create such an interface.
> > Perhaps I'll be able to propose more code as well to make use of these
> > hooks, we will see.
> >  
> 
> That the we have a standardised interface between Ieee802154 and
> (HardMAC or SoftMAC(mac802154)) (see cfg802154_ops) which is defined
> according the spec would make it more "stable" that it will work with
> different HardMAC transceivers (which follows that interface) and
> mac802154 stack (which also follows that interface). If I understood
> you correctly.


I am not sure. I am really talking about a softMAC. I am not sure
where to put that layer "vertically" but according to the spec the MCPS
(MAC Common Part Sublayer) is the layer that contains the data
primitives, while MLME has been designed for management and
configuration.

> I think this is one reason why we are not having any HardMAC
> transceivers driver supported in a proper way yet.
> 
> I can also imagine about a hwsim HardMAC transceiver which redirects
> cfg802154 to mac802154 SoftMAC instance again (something like that),
> to have a virtual HardMAC transceiver for testing purpose, etc. In
> theory that should work...

Yeah I see what you mean, but IMHO that's basically duplicating the
softMAC layer, we already have hwsim wired to cfg802154 through
mac802154. In a certain way we could argue that this is a hardMAC =)

Thanks,
Miquèl
