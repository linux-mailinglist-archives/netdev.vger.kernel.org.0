Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38492550DC2
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 02:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiFTANp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 20:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiFTANZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 20:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3E5FE08
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655684003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lzXXCZk15gEIaB/UXj3e2E+9WNxr1m0xkz5FrfPwLsY=;
        b=T8xDqm5FqIBM8HS/ix+ZuLF7wCLe+O237x2cqUy0IZAHLNh5y0XBICsK7Rkslk3f8GGCEj
        aCJWvRPqW2q9V/OYMe2hm90Ea+Fm0GXi4fNCRGtsvQNamJQqWnWwJnJB1md6DhTEDmbxNL
        bImAJr+rvbCsV5R50YHs+QHdYymDXlE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-ABB3C0itO4q51H_KxwOnkg-1; Sun, 19 Jun 2022 20:13:21 -0400
X-MC-Unique: ABB3C0itO4q51H_KxwOnkg-1
Received: by mail-qv1-f72.google.com with SMTP id t5-20020a0cb385000000b0046e63b0cef8so10301935qve.23
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 17:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lzXXCZk15gEIaB/UXj3e2E+9WNxr1m0xkz5FrfPwLsY=;
        b=H2eE/U0phfXZGQV9jUBtX/pL84gLzS0nTJu0DmLkZW1XWSo7kEI+4LSuxkZh13TiYJ
         mbfvyR1OS3Nmi8ivIVnPWm+Pn5OB6bT4h1hiV2j2zlYtHdIcDe23oYcUN9CoUPF1I6Se
         rjh9K8etdWd0gSvMvrsJ1XntS61in9p59FWNe4ojK6b6YvBR3kWYsz7MMGZsQ0D9mWoT
         DXyqyegwFMHPsFd2QFEc/LRy2urYgqSJR7ql8L3pMZ5VJO3/h/rNK0QLsNF+kclb/M0j
         fSA5GBwnTJj5QjcGlGopGB53xv29yBmdEkA5iMlK2TC8Tt1OJXXvu4rw6Y+h/cPjBF1r
         MFGQ==
X-Gm-Message-State: AJIora9kA4dRzLpGOPxcPvq7CBoLPw7xJQWZKEb5qnYb5G0AaBWjSlG9
        U/Jnw6LYOxFylHCA/L/qjrJK/LKaC3g0qWE5Lc6jCnT+Qd9UhtUX9QVnw5Ua/i6NEhZPnKoK3qo
        6Nir/nLkQ3a0VONL/lrCdCrxK1JtiQXh9
X-Received: by 2002:a05:6214:21e5:b0:46d:82b5:b1a2 with SMTP id p5-20020a05621421e500b0046d82b5b1a2mr17181641qvj.116.1655684000418;
        Sun, 19 Jun 2022 17:13:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u11rtrLY+g5M2nCrOAG+de9EQor4S+jtJsK4ufq12Bslo6XKYHwYbk+2okXdqgEXXhSaZqNjZta9YrIegta5M=
X-Received: by 2002:a05:6214:21e5:b0:46d:82b5:b1a2 with SMTP id
 p5-20020a05621421e500b0046d82b5b1a2mr17181630qvj.116.1655684000127; Sun, 19
 Jun 2022 17:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13> <20220608154749.06b62d59@xps-13>
 <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
 <20220609175217.21a9acee@xps-13> <CAK-6q+jchHcge2_hMznO6fwx=xoUEpmoZTFYLAUwqM2Ue4Lx-A@mail.gmail.com>
 <20220617171256.2261a99e@xps-13>
In-Reply-To: <20220617171256.2261a99e@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Sun, 19 Jun 2022 20:13:08 -0400
Message-ID: <CAK-6q+i-77wXoTN0vXi4s-sv20d13x+2fMpw4TB9dDyXAhjOGA@mail.gmail.com>
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

On Fri, Jun 17, 2022 at 11:13 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> aahringo@redhat.com wrote on Sat, 11 Jun 2022 08:23:41 -0400:
>
> > Hi,
> >
> > On Thu, Jun 9, 2022 at 11:52 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Wed, 8 Jun 2022 21:56:53 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Wed, Jun 8, 2022 at 9:47 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Hi Alex,
> > > > >
> > > > > > > 3. coordinator (any $TYPE specific) userspace software
> > > > > > >
> > > > > > > May the main argument. Some coordinator specific user space daemon
> > > > > > > does specific type handling (e.g. hostapd) maybe because some library
> > > > > > > is required. It is a pain to deal with changing roles during the
> > > > > > > lifetime of an interface and synchronize user space software with it.
> > > > > > > We should keep in mind that some of those handlings will maybe be
> > > > > > > moved to user space instead of doing it in the kernel. I am fine with
> > > > > > > the solution now, but keep in mind to offer such a possibility.
> > > > > > >
> > > > > > > I think the above arguments are probably the same why wireless is
> > > > > > > doing something similar and I would avoid running into issues or it's
> > > > > > > really difficult to handle because you need to solve other Linux net
> > > > > > > architecture handling at first.
> > > > > >
> > > > > > Yep.
> > > > >
> > > > > The spec makes a difference between "coordinator" and "PAN
> > > > > coordinator", which one is the "coordinator" interface type supposed to
> > > > > picture? I believe we are talking about being a "PAN coordinator", but
> > > > > I want to be sure that we are aligned on the terms.
> > > > >
> > > >
> > > > I think it depends what exactly the difference is. So far I see for
> > > > address filtering it should be the same. Maybe this is an interface
> > > > option then?
> > >
> > > The difference is that the PAN coordinator can decide to eg. refuse an
> > > association, while the other coordinators, are just FFDs with no
> > > specific decision making capability wrt the PAN itself, but have some
> > > routing capabilities available for the upper layers.
> > >
> >
> > As I said, if there is a behaviour "it can do xxx, but the spec
> > doesn't give more information about it" this smells for me like things
> > moving into the user space. This can also be done e.g. by a filtering
> > mechanism, _just_ the user will configure how this filtering will look
> > like.
> >
> > > The most I look into this, the less likely it is that the Linux stack
> > > will drive an RFD. Do you think it's worth supporting them? Because if
> > > we don't:
> > > * NODE == FFD which acts as coordinator
> > > * COORD == FFD which acts as the PAN coordinator
> > >
> >
> > I thought that this is a kind of "transceiver type capability " e.g. I
> > can imagine if it's only a "RFD" transceiver then you would be e.g.
> > not able to set the address filter to coordinator capability. However
> > I think that will never happen for a SoftMAC transceiver because why
> > not adding a little bit silicon to provide that? People also can
> > always have a co-processor and run the transceiver in promiscuous
> > mode. E.g. atusb (which makes this transceiver poweful, because we
> > have control over the firmware).
> >
> > For me node != coord, because the address filtering is different. As I
> > mentioned in another mail "coordinator" vs "PAN coordinator" as
> > described is what the user is doing here on top of it.
> >
> > > > > > > > > You are mixing things here with "role in the network" and what
> > > > > > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > > > > > different things.
> > > > > > > >
> > > > > > > > I don't think I am, however maybe our vision differ on what an
> > > > > > > > interface should be.
> > > > > > > >
> > > > > > > > > You should use those defines and the user needs to create a new
> > > > > > > > > interface type and probably have a different extended address
> > > > > > > > > to act as a coordinator.
> > > > > > > >
> > > > > > > > Can't we just simply switch from coordinator to !coordinator
> > > > > > > > (that's what I currently implemented)? Why would we need the user
> > > > > > > > to create a new interface type *and* to provide a new address?
> > > > > > > >
> > > > > > > > Note that these are real questions that I am asking myself. I'm
> > > > > > > > fine adapting my implementation, as long as I get the main idea.
> > > > > > > >
> > > > > > >
> > > > > > > See above.
> > > > > >
> > > > > > That's okay for me. I will adapt my implementation to use the
> > > > > > interface thing. In the mean time additional details about what a
> > > > > > coordinator interface should do differently (above question) is
> > > > > > welcome because this is not something I am really comfortable with.
> > > > >
> > > > > I've updated the implementation to use the IFACE_COORD interface and it
> > > > > works fine, besides one question below.
> > > > >
> > > > > Also, I read the spec once again (soon I'll sleep with it) and
> > > > > actually what I extracted is that:
> > > > >
> > > > > * A FFD, when turned on, will perform a scan, then associate to any PAN
> > > > >   it found (algorithm is beyond the spec) or otherwise create a PAN ID
> > > > >   and start its own PAN. In both cases, it finishes its setup by
> > > > >   starting to send beacons.
> > > > >
> > > >
> > > > What does it mean "algorithm is beyond the spec" - build your own?
> > >
> > > This is really what is in the spec, I suppose it means "do what you
> > > want in your use case".
> > >
> > > What I have in mind: when a device is powered on and detects two PANs,
> > > well, it can join whichever it wants, but perhaps we should make the
> > > decision based on the LQI information we have (the closer the better).
> > >
> >
> > As I said in the other mail, this smells more and more for me to move
> > this handling to user space. The kernel therefore supports operations
> > to trigger the necessary steps (scan/assoc/etc.)
> >
> > > > > * A RFD will behave more or less the same, without the PAN creation
> > > > >   possibility of course. RFD-RX and RFD-TX are not required to support
> > > > >   any of that, I'll assume none of the scanning features is suitable
> > > > >   for them.
> > > > >
> > > > > I have a couple of questions however:
> > > > >
> > > > > - Creating an interface (let's call it wpancoord) out of wpan0 means
> > > > >   that two interfaces can be used in different ways and one can use
> > > > >   wpan0 as a node while using wpancoord as a PAN coordinator. Is that
> > > > >   really allowed? How should we prevent this from happening?
> > > > >
> > > >
> > > > When the hardware does not support it, it should be forbidden. As most
> > > > transceivers have only one address filter it should be forbidden
> > > > then... but there exists a way to indeed have such a setup (which you
> > > > probably don't need to think about). It's better to forbid something
> > > > now, with the possibility later allowing it. So it should not break
> > > > any existing behaviour.
> > >
> > > Done, thanks to the pointer you gave in the other mail.
> > >
> > > >
> > > > > - Should the device always wait for the user(space) to provide the PAN
> > > > >   to associate to after the scan procedure right after the
> > > > >   add_interface()? (like an information that must be provided prior to
> > > > >   set the interface up?)
> > > > >
> > > > > - How does an orphan FFD should pick the PAN ID for a PAN creation?
> > > > >   Should we use a random number? Start from 0 upwards? Start from
> > > > >   0xfffd downwards? Should the user always provide it?
> > > > >
> > > >
> > > > I think this can be done all with some "fallback strategies" (build
> > > > your own) if it's not given as a parameter.
> > >
> > > Ok, In case no PAN is found, and at creation no PAN ID is provided, we
> > > can default to 0.
> > >
> >
> > See me for other mails. (user space job)
> >
> > > > > - Should an FFD be able to create its own PAN on demand? Shall we
> > > > >   allow to do that at the creation of the new interface?
> > > > >
> > > >
> > > > I thought the spec said "or otherwise"? That means if nothing can be
> > > > found, create one?
> > >
> > > Ok, so we assume this is only at startup, fine. But then how to handle
> > > the set_pan_id() call? I believe we can forbid any set_pan_id() command
> > > to be run while the interface is up. That would ease the handling.
> > > Unless I am missing something?
> > >
> >
> > See my other mails (user space job).
>
> Ok then, I'll go with the following constraints in mind:
>
> SCAN (passive/active) (all devices)
> - All devices are allowed to perform scans.
> - The user decides when a scan must be performed, there is no
>   limitation on when to do a scan (but the interface must be up for
>   physical reasons).

Yes, I think it should not have anything to do with interface
limitation.... it needs to have an operating phy. However I can say
more to this when I see code (but please don't provide me with any
github repository, I mean here on the mailing list and not a more than
15 patches stack, Thanks.) You probably want to say on an user level
"run scan for iface $FOO" but this is just to make it simpler.

> PAN ID
> - The user is responsible to set the PAN ID.

This is currently the case and I don't see a reason to change it.

> - Like several other parameters, the PAN ID can only be changed if the
>   iface is down. Which means the user might need to do:
>         link up > scan > link down > set params > link up

Yes, changing this behaviour will break other things.

> BEACON
> - Coordinator interfaces only can send beacons.

okay.

> - Beacons can only be sent when part of a PAN (PAN ID != 0xffff).

I guess that 0xffff means no pan is set and if no pan is set there is no pan?

> - The choice of the beacon interval is up to the user, at any moment.
> OTHER PARAMETERS

I would say "okay", there might be an implementation detail about when
it's effective.
But is this not only required if doing such "passive" mode?

> - The choice of the channel (page, etc) is free until the device is
>   associated to another, then it becomes fixed.
>

I would say no here, because if the user changes it it's their
problem... it's required to be root for doing it and that should be
enough to do idiot things?

> ASSOCIATION (to be done)
> - Device association/disassociation procedure is requested by the
>   user.

This is similar like wireless is doing with assoc/deassoc to ap.

> - Accepting new associations is up to the user (coordinator only).

Again implementation details how this should be realized.

> - If the device has no parent (was not associated to any device) it is
>   PAN coordinator and has additional rights regarding associations.
>

No idea what a "device' here is, did we not made a difference between
"coordinator" vs "PAN coordinator" before and PAN is that thing which
does some automatically scan/assoc operation and the other one not? I
really have no idea what "device" here means.

- Alex

