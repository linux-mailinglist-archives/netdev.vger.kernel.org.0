Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B140955ADF2
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 03:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiFZBgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 21:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiFZBgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 21:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 714C111C34
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 18:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656207378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8O4fzKRAz2zP57dq93wK++tWKPEvnj0LB56OQk6ucks=;
        b=AKT0eM6J/GlhHnEkJnlQGZTGVZwHP7zrOlBskEb1753s/AbEd4+DYLb2aXx9bM8PJu/50A
        2gQKqaLFPDV6XtbE9QLK4UBRJBl9hlVXFzPEZCiCPO/d9iX+8c72B3svX9Erw3fq8sxMR0
        L6Zw8ZxTKxVEgTb+eqpzpAeyxtfIWmY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-ggRSY_8DOh24jXStc3tTrQ-1; Sat, 25 Jun 2022 21:36:17 -0400
X-MC-Unique: ggRSY_8DOh24jXStc3tTrQ-1
Received: by mail-qv1-f70.google.com with SMTP id w18-20020a0ce112000000b0046e7f2c5a06so6168064qvk.0
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 18:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8O4fzKRAz2zP57dq93wK++tWKPEvnj0LB56OQk6ucks=;
        b=hM30zLegi2YfxAom6BYGOnouk+Gx36MY8s2+Uci588TpyXHAEkUgAVZGgwzn+OwiLY
         BKq7VDMiiWRI0ODJHJikNUSXg1zoQzevPgSA9rUB5Temns0rX/HhCPi0FosTfX3C6ogm
         q7kcdr2WoeiWe+wXiWLxW2QBYdCfCCwIS2zVCu+wp0MmT+ZABe/MzMbiu9HiXNIBETPu
         noVZL5zfjFc+pgIzslZ7Cc4s+GfRvyYkRKjUaucWJyxhD/IFq2BbI9rjOIdy7cr9zW2c
         WsNCeKe9e3DtDlFE+kUC5SMz3HNwTIB82uDgBMafVOTi3acHFGZ5zfAbmzL5H/EM1ISJ
         JbiA==
X-Gm-Message-State: AJIora9ZrXGY38cZJJ9vduUxBq6GfVGNDGl/geslrlE8DCDkiQ6N3OSF
        kj4mOj6cDSOPR1IkKMWWVqv+fo08R/LH5a1/E9Ne6qgt2g+2o8/F+t1qI90/wJNecETYspmMY3P
        PLNQYD+G/3+/dUICjXQjQGQwzKlKTa9UY
X-Received: by 2002:ac8:5749:0:b0:305:1ea5:4a7 with SMTP id 9-20020ac85749000000b003051ea504a7mr4683694qtx.291.1656207376553;
        Sat, 25 Jun 2022 18:36:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uq6+A+8Na482Sw9pwOEAxv/g8sSD/ay/goWkcdqc0AwFxo0ChJnSgA+kJhwrsMvYWoMizIltuZqGCbwute4ik=
X-Received: by 2002:ac8:5749:0:b0:305:1ea5:4a7 with SMTP id
 9-20020ac85749000000b003051ea504a7mr4683685qtx.291.1656207376277; Sat, 25 Jun
 2022 18:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13> <20220608154749.06b62d59@xps-13>
 <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
 <20220609175217.21a9acee@xps-13> <CAK-6q+jchHcge2_hMznO6fwx=xoUEpmoZTFYLAUwqM2Ue4Lx-A@mail.gmail.com>
 <20220617171256.2261a99e@xps-13> <CAK-6q+i-77wXoTN0vXi4s-sv20d13x+2fMpw4TB9dDyXAhjOGA@mail.gmail.com>
 <20220620111922.51189382@xps-13> <CAK-6q+jR00MD+W02AAH8P5xG7hUD-x8NEnOG_W3mifj=6ybBzg@mail.gmail.com>
 <20220621082714.78451ee0@xps-13>
In-Reply-To: <20220621082714.78451ee0@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sat, 25 Jun 2022 21:36:05 -0400
Message-ID: <CAK-6q+gtAwi7VP_Tj5KE01LWoaV3CEYnMGSwpAQbrgH3v5xkSw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 21, 2022 at 2:27 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Mon, 20 Jun 2022 21:54:33 -0400:
>
> > Hi,
> >
> > On Mon, Jun 20, 2022 at 5:19 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote:
> > ...
> > > >
> > > > > - Beacons can only be sent when part of a PAN (PAN ID !=3D 0xffff=
).
> > > >
> > > > I guess that 0xffff means no pan is set and if no pan is set there =
is no pan?
> > >
> > > Yes, Table 8-94=E2=80=94MAC PIB attributes states:
> > >
> > >         "The identifier of the PAN on which the device is operating. =
If
> > >         this value is 0xffff, the device is not associated."
> > >
> >
> > I am not sure if I understand this correctly but for me sending
> > beacons means something like "here is a pan which I broadcast around"
>
> Yes, and any coordinator in a beacon enabled PAN is required to send
> beacons to advertise the PAN after it associated.
>
> > and then there is "'device' is not associated".
>

I think there are several misunderstandings in the used terms in this
discussion.

A "associated" device does not imply an association by using the mac
commands, it can also be by setting a pan id manually without doing
anything of communication.
But this would for me just end in a term "has valid PAN id",
association is using the mac commands.

> FFDs are not supposed to send any beacon if they are not part of a PAN.
>

FFD is a device capability (it can run as pan coordinator, which is a
node with more functions), it is not a term which can be used in
combination with an instance of a living role in the network
(coordinator). That's for me what I understand in linux-wpan terms ->
it's a coordinator interface.

> > Is when "associated"
> > (doesn't matter if set manual or due scan/assoc) does this behaviour
> > implies "I am broadcasting my pan around, because my panid is !=3D
> > 0xffff" ?
>
> I think so, yes. To summarize:
>
> Associated:
> * PAN is !=3D 0xffff
> * FFD can send beacons
> Not associated:
> * PAN is =3D=3D 0xffff
> * FFD cannot send beacons
>

But the user need to explicit enable the "reacting/sending (probably
depends on active/passive) beacon feature" which indeed sounds fine to
me.

> > > > > - The choice of the beacon interval is up to the user, at any mom=
ent.
> > > > > OTHER PARAMETERS
> > > >
> > > > I would say "okay", there might be an implementation detail about w=
hen
> > > > it's effective.
> > > > But is this not only required if doing such "passive" mode?
> > >
> > > The spec states that a coordinator can be in one of these 3 states:
> > > - Not associated/not in a PAN yet: it cannot send beacons nor answer
> > >   beacon requests
> >
> > so this will confirm, it should send beacons if panid !=3D 0xffff (as m=
y
> > question above)?
>
> It should only send beacons if in a beacon-enabled PAN. The spec is
> not very clear about if this is mandatory or not.
>

as above. Sounds fine to me to have a setting start/stop for that.

> > > - Associated/in a PAN and in this case:
> > >     - It can be configured to answer beacon requests (for other
> > >       devices performing active scans)
> > >     - It can be configured to send beacons "passively" (for other
> > >       devices performing passive scans)
> > >
> > > In practice we will let to the user the choice of sending beacons
> > > passively or answering to beacon requests or doing nothing by adding =
a
> > > fourth possibility:
> > >     - The device is not configured, it does not send beacons, even wh=
en
> > >       receiving a beacon request, no matter its association status.
> > >
> >
> > Where is this "user choice"? I mean you handle those answers for
> > beacon requests in the kernel?
>
> Without user input, so the default state remains the same as today: do
> not send beacons + do not answer beacon requests. Then, we created a:
>
>         iwpan dev xxx beacons send ...
>
> command which, depending on the beacon interval will either send
> beacons at a given pace (interval < 15) or answer beacon requests
> otherwise.
>
> If the user want's to get back to the initial state (silent device):
>
>         iwpan dev xxx beacons stop
>

sounds fine.

> > > > > - The choice of the channel (page, etc) is free until the device =
is
> > > > >   associated to another, then it becomes fixed.
> > > > >
> > > >
> > > > I would say no here, because if the user changes it it's their
> > > > problem... it's required to be root for doing it and that should be
> > > > enough to do idiot things?
> > >
> > > That was a proposal to match the spec, but I do agree we can let the
> > > user handle this, so I won't add any checks regarding channel changes=
.
> > >
> >
> > okay.
> >
> > > > > ASSOCIATION (to be done)
> > > > > - Device association/disassociation procedure is requested by the
> > > > >   user.
> > > >
> > > > This is similar like wireless is doing with assoc/deassoc to ap.
> > >
> > > Kind of, yes.
> > >
> >
> > In the sense of "by the user" you don't mean putting this logic into
> > user space you want to do it in kernel and implement it as a
> > netlink-op, the same as wireless is doing? I just want to confirm
> > that. Of course everything else is different, but from this
> > perspective it should be realized.
>
> Yes absolutely, the user would have a command (which I am currently
> writing) like:
>
> iwpan dev xxx associate pan_id yyy coord zzz
> iwpan dev xxx disassociate device zzz
>

Can say more about that if I am seeing code.

> Mind the disassociate command which works for parents (you are
> associated to a device and want to leave the PAN) and also for children
> (a device is associated to you, and you request it to leave the PAN).
>
> > > > > - Accepting new associations is up to the user (coordinator only)=
.
> > > >
> > > > Again implementation details how this should be realized.
> > >
> > > Any coordinator can decide whether new associations are possible or
> > > not. There is no real use case besides this option besides the memory
> > > consumption on limited devices. So either we say "we don't care about
> > > that possible limitation on Linux systems" or "let's add a user
> > > parameter which tells eg. the number of devices allowed to associate"=
.
> > >
> > > What's your favorite?
> > >
> >
> > Sure there should be a limitation about how many pans should be
> > allowed, that is somehow the bare minimum which should be there.
> > I was not quite sure how the user can decide of denied assoc or not,
> > but this seems out of scope for right now...
>
> I thought as well about this, I think in the future we might find a way
> to whitelist or blacklist devices and have these answers being sent
> automatically by the kernel based on user lists, but this is really an
> advanced feature and there is currently no use case yet, so I'll go for
> the netlink op which changes the default number of devices which may
> associate to a coordinator.

yes.

> >
> > > > > - If the device has no parent (was not associated to any device) =
it is
> > > > >   PAN coordinator and has additional rights regarding association=
s.
> > > > >
> > > >
> > > > No idea what a "device' here is, did we not made a difference betwe=
en
> > > > "coordinator" vs "PAN coordinator" before and PAN is that thing whi=
ch
> > > > does some automatically scan/assoc operation and the other one not?=
 I
> > > > really have no idea what "device" here means.
> > >
> > > When implementing association, we need to keep track of the
> > > parent/child relationship because we may expect coordinators to
> > > propagate messages from leaf node up to their parent. A device withou=
t
> > > parent is then the PAN coordinator. Any coordinator may advertise the
> > > PAN and subsequent devices may attach to it, this is creating a tree =
of
> > > nodes.
> > >
> >
> >
> > Who is keeping track of this relationship?
>
> Each device keeps track of:
> - the parent (the coordinator it associated with, NULL if PAN
>   coordinator)
> - a list of devices (FFD or RFD) which successfully associated
>
> > So we store pans which we
> > found with a whole "subtree" attached to it?
>
> This is different, we need basically three lists:
> - the parent in the PAN
> - the children (as in the logic of association) in the PAN
> - the coordinators around which advertise their PAN with beacons (the
>   PAN can be the same as ours, or different)
>
> > btw: that sounds similar to me to what RPL is doing...,
>
> I think RPL stands one level above in the OSI layers? Anyway, my
> understanding (and this is really something which I grasped by reading
> papers because the spec lacks a lot of information about it) is that:
> - the list of PANs is mainly useful for our own initial association
> - the list of immediate parent/children is to be used by the upper
>   layer to create routes, but as in the 802.15.4 layer, we are not
>   supposed to propagate this information besides giving it to the
>   "next upper layer".
>

I am asking the question who stores that, because I don't think this
should be stored in kernel space. A user space daemon will trigger the
mac commands scan/assoc/deassoc/etc. (kernel job) and get the results
of those commands and store it in however the user space daemon is
handling it. This is from my point of view no kernel job, triggering
the mac commands in a way that we can add all children information,
parents, etc, whatever you need to fill information in mac commands.
Yes, this is a kernel task.

Also I heard that association with a coordinator will allocate in the
pan a short address, the associated device (which triggered the
association command) will then set the allocated short address by the
coordinator, did you take a look into that?

- Alex

