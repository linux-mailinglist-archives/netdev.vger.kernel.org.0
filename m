Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573B2494309
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 23:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343817AbiASW0L convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jan 2022 17:26:11 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56099 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357570AbiASW0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 17:26:06 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5399DFF805;
        Wed, 19 Jan 2022 22:26:01 +0000 (UTC)
Date:   Wed, 19 Jan 2022 23:26:00 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Subject: Re: [wpan-next v2 08/27] net: ieee802154: Drop symbol duration
 settings when the core does it already
Message-ID: <20220119232600.6b8755d0@xps13>
In-Reply-To: <CAB_54W4Z0H5ubvOBjpnCpGOWYrNXYOJvxB4_kZsp8LqdJrTLkg@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-9-miquel.raynal@bootlin.com>
        <CAB_54W5QU5JCtQYwvTKREd6ZeQWmC19LF4mj853U0Gz-mCObVQ@mail.gmail.com>
        <20220113121645.434a6ef6@xps13>
        <CAB_54W5_x88zVgSJep=yK5WVjPvcWMy8dmyOJWcjy=5o0jCy0w@mail.gmail.com>
        <20220114112113.63661251@xps13>
        <CAB_54W77d_PjX_ZfKJdO4D4hHsAWjw0jWgRA7L0ewNnqApQhcQ@mail.gmail.com>
        <20220117101245.1946e474@xps13>
        <CAB_54W4rqXxSrTY=fqbt6o41a2SAEY_suqyqZ3hymheCgzRqTQ@mail.gmail.com>
        <20220118113833.0185f564@xps13>
        <CAB_54W4Z0H5ubvOBjpnCpGOWYrNXYOJvxB4_kZsp8LqdJrTLkg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Tue, 18 Jan 2022 17:43:00 -0500:

> Hi,
> 
> On Tue, 18 Jan 2022 at 05:38, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >  
> > > > > btw:
> > > > > Also for testing with hwsim and the missing features which currently
> > > > > exist. Can we implement some user space test program which replies
> > > > > (active scan) or sends periodically something out via AF_PACKET raw
> > > > > and a monitor interface that should work to test if it is working?  
> > > >
> > > > We already have all this handled, no need for extra software. You can
> > > > test active and passive scans between two hwsim devices already:
> > > >
> > > > # iwpan dev wpan0 beacons send interval 15
> > > > # iwpan dev wpan1 scan type active duration 1
> > > > # iwpan dev wpan0 beacons stop
> > > >
> > > > or
> > > >
> > > > # iwpan dev wpan0 beacons send interval 1
> > > > # iwpan dev wpan1 scan type passive duration 2
> > > > # iwpan dev wpan0 beacons stop
> > > >  
> > > > > Ideally we could do that very easily with scapy (not sure about their
> > > > > _upstream_ 802.15.4 support). I hope I got that right that there is
> > > > > still something missing but we could fake it in such a way (just for
> > > > > hwsim testing).  
> > > >
> > > > I hope the above will match your expectations.
> > > >  
> > >
> > > I need to think and read more about... in my mind is currently the
> > > following question: are not coordinators broadcasting that information
> > > only? Means, isn't that a job for a coordinator?  
> >
> > My understanding right now:
> > - The spec states that coordinators only can send beacons and perform
> >   scans.  
> 
> ok.
> 
> > - I don't yet have the necessary infrastructure to give coordinators
> >   more rights than regular devices or RFDs (but 40+ patches already,
> >   don't worry this is something we have in mind)
> > - Right now this is the user to decide whether a device might answer
> >   beacon requests or not. This will soon become more limited but it
> >   greatly simplifies the logic for now.
> >  
> 
> There was always the idea behind it to make an "coordinator" interface
> type and there is a reason for that because things e.g. filtering
> becomes different than a non-coordinator interface type (known as node
> interface in wpan).
> At the end interface types should make a big difference in how the
> "role" inside the network should be, which you can also see in
> wireless as "station"/"access point" interface devices.
> 
> A non full functional device should then also not be able to act as a
> coordinator e.g. it cannot create coordinator types.

I've added a few more parameters to be able to reflect the type of
device (ffd, rfd, rfd_r/tx) and also eventually its coordinator state.
I've hacked into nl802154 to give these information to the user and let
it device wether the device (if it's an ffd) should act as a
coordinator. This is only a first step before we create a real PAN
creation procedure of course.

I've then adapted the following patches to follow check against the
device/coordinator state to decide if an operation should be aborted or
not.

> However we can still make some -EOPNOTSUPP if something in a different
> way should be done. This clearly breaks userspace and I am not sure if
> we should worry or not worry about it in the current state of
> 802.15.4...
> 
> - Alex


Thanks,
Miquèl
