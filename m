Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0276544133
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 03:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiFIB5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 21:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFIB5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 21:57:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7596B2BB37
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654739826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kXhU2yLuFUW+Y1jzIoJ7mNQGYBtFKdFOGgD8xlAg/uA=;
        b=XgYcm01DiT0gZV4HJ4FqfN7Dcg9voipgWZh3G9xJk+oRAZCJiej8yvwvo84u0wv4O56/7/
        emp3JiTUzEZFfn2lS7eLUcLjqfvtg9gEAhbfSPZL4lyRugKqIB/UqJ8HgS0c89KOyHYNZd
        IvuOxdfUgzT4PiY26mQ3RJGXeeh77Ek=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-uQgAlPZePnaH5XcgVx7xLg-1; Wed, 08 Jun 2022 21:57:05 -0400
X-MC-Unique: uQgAlPZePnaH5XcgVx7xLg-1
Received: by mail-qk1-f197.google.com with SMTP id w22-20020a05620a445600b006a6c18678f2so8113993qkp.4
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 18:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXhU2yLuFUW+Y1jzIoJ7mNQGYBtFKdFOGgD8xlAg/uA=;
        b=5XT4vSI5t38zbsk2KFTEOrw3g35wUWtzrBSUAeC9AnK2/qGcDmGPdcdGJVQPd9bcy9
         wJWSfnHR0VDQMiGC//Q7PFQaz7+I0rgUrLHRkaMImQBvefZ1llQDUXgwgG8497JVccYw
         78vUCBhGr5uIc6AOgG8kyHn6z+gCXp9lj2muu7mw/iSxxKTlezQ0D/o54AW6m3qhBVlo
         lVo1OUlYlDHsw8HBj+DJGASZd/iDWzOm7Mt2kwllnVAjtNZCeuqzNoH+5EZKibXglv8O
         f8RJMEsypeMKvyrTz3EDWvpEK9hk0dcEg2HMB9MUhX7LImrpE+07kvOSDiIULJwbx1dM
         IVrQ==
X-Gm-Message-State: AOAM530VbZBTd61xZP/XhP6LRvlc+aqnGv/abzDvhkSZTVK7qflobp/2
        rW/4sS5KAwt5GCbcxbHicwU7v3Jq79FumJN8ZVs+lAphB+Yuh4PlZqPwuEaW2FvKJCZSi5R4evY
        EcZoGJLg1l8x4btuk/OxNFii7r9Chv3JI
X-Received: by 2002:a37:7d0:0:b0:6a6:ad21:b4f9 with SMTP id 199-20020a3707d0000000b006a6ad21b4f9mr16720130qkh.27.1654739824948;
        Wed, 08 Jun 2022 18:57:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZ3FDiDrng3dXxlEpQneMbqEZ8Fn3z9JSzzkcYRNM2DqT9jrzecgyqsxFC1I7ZF4+/QM4y5dNW//vv2wRBrkU=
X-Received: by 2002:a37:7d0:0:b0:6a6:ad21:b4f9 with SMTP id
 199-20020a3707d0000000b006a6ad21b4f9mr16720116qkh.27.1654739824699; Wed, 08
 Jun 2022 18:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
 <20220603182143.692576-2-miquel.raynal@bootlin.com> <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
 <20220606174319.0924f80d@xps-13> <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
 <20220607181608.609429cb@xps-13> <20220608154749.06b62d59@xps-13>
In-Reply-To: <20220608154749.06b62d59@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 8 Jun 2022 21:56:53 -0400
Message-ID: <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator interface type
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jun 8, 2022 at 9:47 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> > > 3. coordinator (any $TYPE specific) userspace software
> > >
> > > May the main argument. Some coordinator specific user space daemon
> > > does specific type handling (e.g. hostapd) maybe because some library
> > > is required. It is a pain to deal with changing roles during the
> > > lifetime of an interface and synchronize user space software with it.
> > > We should keep in mind that some of those handlings will maybe be
> > > moved to user space instead of doing it in the kernel. I am fine with
> > > the solution now, but keep in mind to offer such a possibility.
> > >
> > > I think the above arguments are probably the same why wireless is
> > > doing something similar and I would avoid running into issues or it's
> > > really difficult to handle because you need to solve other Linux net
> > > architecture handling at first.
> >
> > Yep.
>
> The spec makes a difference between "coordinator" and "PAN
> coordinator", which one is the "coordinator" interface type supposed to
> picture? I believe we are talking about being a "PAN coordinator", but
> I want to be sure that we are aligned on the terms.
>

I think it depends what exactly the difference is. So far I see for
address filtering it should be the same. Maybe this is an interface
option then?

> > > > > You are mixing things here with "role in the network" and what
> > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > different things.
> > > >
> > > > I don't think I am, however maybe our vision differ on what an
> > > > interface should be.
> > > >
> > > > > You should use those defines and the user needs to create a new
> > > > > interface type and probably have a different extended address
> > > > > to act as a coordinator.
> > > >
> > > > Can't we just simply switch from coordinator to !coordinator
> > > > (that's what I currently implemented)? Why would we need the user
> > > > to create a new interface type *and* to provide a new address?
> > > >
> > > > Note that these are real questions that I am asking myself. I'm
> > > > fine adapting my implementation, as long as I get the main idea.
> > > >
> > >
> > > See above.
> >
> > That's okay for me. I will adapt my implementation to use the
> > interface thing. In the mean time additional details about what a
> > coordinator interface should do differently (above question) is
> > welcome because this is not something I am really comfortable with.
>
> I've updated the implementation to use the IFACE_COORD interface and it
> works fine, besides one question below.
>
> Also, I read the spec once again (soon I'll sleep with it) and
> actually what I extracted is that:
>
> * A FFD, when turned on, will perform a scan, then associate to any PAN
>   it found (algorithm is beyond the spec) or otherwise create a PAN ID
>   and start its own PAN. In both cases, it finishes its setup by
>   starting to send beacons.
>

What does it mean "algorithm is beyond the spec" - build your own?

> * A RFD will behave more or less the same, without the PAN creation
>   possibility of course. RFD-RX and RFD-TX are not required to support
>   any of that, I'll assume none of the scanning features is suitable
>   for them.
>
> I have a couple of questions however:
>
> - Creating an interface (let's call it wpancoord) out of wpan0 means
>   that two interfaces can be used in different ways and one can use
>   wpan0 as a node while using wpancoord as a PAN coordinator. Is that
>   really allowed? How should we prevent this from happening?
>

When the hardware does not support it, it should be forbidden. As most
transceivers have only one address filter it should be forbidden
then... but there exists a way to indeed have such a setup (which you
probably don't need to think about). It's better to forbid something
now, with the possibility later allowing it. So it should not break
any existing behaviour.

> - Should the device always wait for the user(space) to provide the PAN
>   to associate to after the scan procedure right after the
>   add_interface()? (like an information that must be provided prior to
>   set the interface up?)
>
> - How does an orphan FFD should pick the PAN ID for a PAN creation?
>   Should we use a random number? Start from 0 upwards? Start from
>   0xfffd downwards? Should the user always provide it?
>

I think this can be done all with some "fallback strategies" (build
your own) if it's not given as a parameter.

> - Should an FFD be able to create its own PAN on demand? Shall we
>   allow to do that at the creation of the new interface?
>

I thought the spec said "or otherwise"? That means if nothing can be
found, create one?

- Alex

