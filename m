Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9943560EBB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiF3Bk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF3Bk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE2642A70C
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656553227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4mLr/uMnEoaLZnA/HXWXvXWh1thgUy9SB8ZuO1RDMMc=;
        b=VA9Puqh3PO+cM11k42JFqawx9jre8JFjRHC2odte6wIKZLekBMUXNBoaej9L7Xl4KAoZXs
        JlHwlnkpRAiNSd+cqLMXr3cp2sRcGGv6UKrMpsILb/WeJcwraR7y0Ud0OQfElxTNw7RQom
        nbJ9AgLGPansO0/mC4JXLsMwB2ibblI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-ja0aWyRzO1u6qONeXefHBA-1; Wed, 29 Jun 2022 21:40:25 -0400
X-MC-Unique: ja0aWyRzO1u6qONeXefHBA-1
Received: by mail-qk1-f198.google.com with SMTP id a68-20020a376647000000b006af6c4be635so5279874qkc.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4mLr/uMnEoaLZnA/HXWXvXWh1thgUy9SB8ZuO1RDMMc=;
        b=fH2nDajCJE5o7wMJ4rtHWyUxFJiQPyJWb5mqwB8q2ssx9rPNOdxEoavzx63jRZiTKe
         Z0wwJxHwPW4MHDdUZHv4UuC8sUzxunUmYJH2u5BqUnkwsbbJdCPFvofSGrJ0/L5RHgXJ
         a7CkbKxAvtzjNYJiDgXUKVZt1W9cG98dIYRWkKFXtt+PgjAeIeXcLVoWS2DCu3V4w42q
         /KqPmJbmZ8IidZVYF6lUQV/AdFSqYKHquaIj9AAC6r+ch/y1EnHtBj85NwYZ8vuma1l/
         mhXE+vPSi/RvoEcIGa9gPuJiKGm6/iH5irCIhsKFEVuFnUEXG5YiRrrdCgCxK7n2YU0B
         N6Lw==
X-Gm-Message-State: AJIora/9FQzjGKZCU3F2gA9aJNwEi419ys1xlBaSHeJ8dgccMdy+nnrg
        Vo2XrOogQwiERQkW3ks09NvUjnirAYOESq+qUrpaCE38m0klm6hIiqXtb8v2bP5eRqWYR9TMDa+
        p1CqTgTnB4M9k1D41/I/MuVjlzTf1pIMf
X-Received: by 2002:a37:67c9:0:b0:6af:a24:df4b with SMTP id b192-20020a3767c9000000b006af0a24df4bmr4657053qkc.691.1656553225387;
        Wed, 29 Jun 2022 18:40:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t6AwmOItZmk8HDoN5PMvp3WRLKgYxIdUKwlkoN6k4a1dwkpCmQ6hsTg+iNF079g+zsM24tgBh64vFh64wAAHY=
X-Received: by 2002:a37:67c9:0:b0:6af:a24:df4b with SMTP id
 b192-20020a3767c9000000b006af0a24df4bmr4657043qkc.691.1656553225140; Wed, 29
 Jun 2022 18:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
 <20220620134018.62414-3-miquel.raynal@bootlin.com> <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
 <20220627104303.5392c7f6@xps-13> <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
 <20220628095821.36811c5c@xps-13>
In-Reply-To: <20220628095821.36811c5c@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 29 Jun 2022 21:40:14 -0400
Message-ID: <CAK-6q+g=Bbj7gS5a+fSqCsB9n=xrZK-z0-Rg9dn9yFK5xpZsvw@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 2/4] net: ieee802154: Add support for inter
 PAN management
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 28, 2022 at 3:58 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Mon, 27 Jun 2022 21:32:08 -0400:
>
> > Hi,
> >
> > On Mon, Jun 27, 2022 at 4:43 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Sat, 25 Jun 2022 22:29:08 -0400:
> > >
> > > > Hi,
> > > >
> > > > On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote:
> > > > >
> > > > > Let's introduce the basics for defining PANs:
> > > > > - structures defining a PAN
> > > > > - helpers for PAN registration
> > > > > - helpers discarding old PANs
> > > > >
> > > >
> > > > I think the whole pan management can/should be stored in user space by
> > > > a daemon running in background.
> > >
> > > We need both, and currently:
> > > - while the scan is happening, the kernel saves all the discovered PANs
> > > - the kernel PAN list can be dumped (and also flushed) asynchronously by
> > >   the userspace
> > >
> > > IOW the userspace is responsible of keeping its own list of PANs in
> > > sync with what the kernel discovers, so at any moment it can ask the
> > > kernel what it has in memory, it can be done during a scan or after. It
> > > can request a new scan to update the entries, or flush the kernel list.
> > > The scan operation is always requested by the user anyway, it's not
> > > something happening in the background.
> > >
> >
> > I don't see what advantage it has to keep the discovered pan in the
> > kernel. You can do everything with a start/stop/pan discovered event.
>
> I think the main reason is to be much more user friendly. Keeping track
> of the known PANs in the kernel matters because when you start working
> with 802.15.4 you won't blindly use a daemon (if there is any) and will
> use test apps like iwpan which are stateless. Re-doing a scan on demand
> just takes ages (from seconds to minutes, depending on the beacon
> order).
>

I can see that things should work "out-of the box" and we are already
doing it by manual setting pan_id, etc. However, doing it in an
automatic way there exists a lot of "interpretation" about how you
want to handle it (doesn't matter if this is what the spec says or
not)... moving it to user space will offload it to the user.

> Aside from this non technical reason, I also had in mind to retrieve
> values gathered from the beacons (and stored in the PAN descriptors) to
> know more about the devices when eg. listing associations, like
> registering the short address of a coordinator. I don't yet know how
> useful this is TBH.
>
> > It also has more advantages as you can look for a specific pan and
> > stop afterwards. At the end the daemon has everything that the kernel
> > also has, as you said it's in sync.
> >
> > > > This can be a network manager as it
> > > > listens to netlink events as "detect PAN xy" and stores it and
> > > > offers it in their list to associate with it.
> > >
> > > There are events produced, yes. But really, this is not something we
> > > actually need. The user requests a scan over a given range, when the
> > > scan is over it looks at the list and decides which PAN it
> > > wants to associate with, and through which coordinator (95% of the
> > > scenarii).
> > >
> >
> > This isn't either a kernel job to decide which pan it will be
> > associated with.
>
> Yes, "it looks at the list and decides" referred to "the user".
>
> > > > We need somewhere to draw a line and I guess the line is "Is this
> > > > information used e.g. as any lookup or something in the hot path", I
> > > > don't see this currently...
> > >
> > > Each PAN descriptor is like 20 bytes, so that's why I don't feel back
> > > keeping them, I think it's easier to be able to serve the list of PANs
> > > upon request rather than only forwarding events and not being able to
> > > retrieve the list a second time (at least during the development).
> > >
> >
> > This has nothing to do with memory.
> >
> > > Overall I feel like this part is still a little bit blurry because it
> > > has currently no user, perhaps I should send the next series which
> > > actually makes the current series useful.
> > >
> >
> > Will it get more used than caching entries in the kernel for user
> > space? Please also no in-kernel association feature.
>
> I am aligned on this.
>

I am sorry I am not sure what that means.

> > We can maybe agree to that point to put it under
> > IEEE802154_NL802154_EXPERIMENTAL config, as soon as we have some
> > _open_ user space program ready we will drop this feature again...
> > this program will show that there is no magic about it.
>
> Yeah, do you want to move all the code scan/beacon/pan/association code
> under EXPERIMENTAL sections? Or is it just the PAN management logic?

Yes, why not. But as I can see there exists two categories of
introducing your netlink api:

1. API candidates which are very likely to become stable
2. API candidates which we want to remove when we have a user
replacement for it (will probably never go stable)

The 2. should be defining _after_ the 1. In the "big" netlink API
enums of EXPERIMENTAL sections.

Also you should provide for 2. some kind of ifdef/functions dummy/etc.
that it's easy to remove from the kernel when we have a user
replacement for it.
I hope that is fine for everybody.

I try to find solutions here, I don't see a reason for putting this
pan management into the kernel... whereas I appreciate the effort
which is done here and will not force you to write some user space
software that does this job. From my point of view I can't accept this
functionality in the kernel "yet".

- Alex

