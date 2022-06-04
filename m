Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1DE53D4B4
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 03:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347605AbiFDBud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 21:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiFDBuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 21:50:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AEA827FDF
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 18:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654307428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yyONruk37FP0IvD6T8UlE2+3rlPNbm0pNIQeBo7LBl8=;
        b=fWWM12lALjnNFXpwEnfJDI5kPVe9slhevuSUWgPAmkxmFS/4sU+tF01p2q8eskrXl0nAmy
        uZ60kQ2tFaA9UWWbhCxPtkAMgE1DvhP3YIb8bTGGqITOKY/M7f1szkaGUAMJq3tp1dHmtY
        EG1wzaGVBcqgnjNBChIfXgPt+GDyNtM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-96m0dfmAMDe6waAAAiX8zg-1; Fri, 03 Jun 2022 21:50:27 -0400
X-MC-Unique: 96m0dfmAMDe6waAAAiX8zg-1
Received: by mail-qv1-f70.google.com with SMTP id k6-20020a0cd686000000b004625db7d2aaso6264611qvi.7
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 18:50:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yyONruk37FP0IvD6T8UlE2+3rlPNbm0pNIQeBo7LBl8=;
        b=vugmpZ6bBk3a6tIQzoYN/36+J0svArnfLNH1yrEuj7ey7eynHasoo5z5VRE1elqq53
         J1KZ7YfPUM/dJzmJnNFnyl0YJ81hjc8VVci7GtdhtZw3hKksqfPk9HQBgWwbYHB5Hh3M
         YDBR8bOS4n+R7bGwEkPXDNKE8HJYqjjjgpaCM7YIUutowVRUTbWR9gVbWPC1+sN/us07
         N3L3KDLZXP+TCXnSGBbto+g17CmIAWcUX2plWau5/FHLbe7/gAkRUPB/iKcodWHXet9D
         gtjPh7GMNg39PsOQgnNQRZwrPh8Qbd7+tPi9mzLxeDgONTuZG6eTnhoPyGn6GzPaxYgu
         d1Cw==
X-Gm-Message-State: AOAM530VMeaRzKKBRLfLuPLIUg9SsweL9P1/skWrOgBiQP1bOt+TFfx2
        rD0bBP6yjiEiJtmEt4YthwrMjeYiv+8cLx7YIjU3oMS+N1tOJVW3uFUgsXS66vRFXyI+7X+dRRq
        RTnH1yt2MupFlHjI8t0LwIw0DXE5MskYr
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id a9-20020a0562140c2900b0045afedd7315mr63423067qvd.59.1654307426835;
        Fri, 03 Jun 2022 18:50:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHzOeETeFjMvaA+vQh5+GUdoJS6AaWH3HtiTczNatQjsPOGXDLrSNbwm3UbfTN/bfKlK7fzeO/f2Voxur4r9g=
X-Received: by 2002:a05:6214:c29:b0:45a:fedd:7315 with SMTP id
 a9-20020a0562140c2900b0045afedd7315mr63423059qvd.59.1654307426594; Fri, 03
 Jun 2022 18:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
 <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
 <d844514c-771f-e720-407b-2679e430243a@datenfreihafen.org> <20220603195509.73cf888f@xps-13>
In-Reply-To: <20220603195509.73cf888f@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 3 Jun 2022 21:50:15 -0400
Message-ID: <CAK-6q+if-dNbpbneTfUtj6MrZXiYPq9npZfMkatXKo8cfU1m9w@mail.gmail.com>
Subject: Re: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 3, 2022 at 1:55 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Stefan, Alex,
>
> stefan@datenfreihafen.org wrote on Wed, 1 Jun 2022 23:01:51 +0200:
>
> > Hello.
> >
> > On 01.06.22 05:30, Alexander Aring wrote:
> > > Hi,
> > >
> > > On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote:
> > >>
> > >> Hello,
> > >>
> > >> This series brings support for that famous synchronous Tx API for MLME
> > >> commands.
> > >>
> > >> MLME commands will be used during scan operations. In this situation,
> > >> we need to be sure that all transfers finished and that no transfer
> > >> will be queued for a short moment.
> > >>
> > >
> > > Acked-by: Alexander Aring <aahringo@redhat.com>
> >
> > These patches have been applied to the wpan-next tree. Thanks!
> >
> > > There will be now functions upstream which will never be used, Stefan
> > > should wait until they are getting used before sending it to net-next.
> >
> > Indeed this can wait until we have a consumer of the functions before pushing this forward to net-next. Pretty sure Miquel is happy to finally move on to other pieces of his puzzle and use them. :-)
>
> Next part is coming!
>
> In the mean time I've experienced a new lockdep warning:
>
> All the netlink commands are executed with the rtnl taken.
> In my current implementation, when I configure/edit a scan request or a
> beacon request I take a scan_lock or a beacons_lock, so they may only
> be taken after the rtnl in this case, which leads to this sequence of
> events:
> - the rtnl is taken (by the net core)
> - the beacon's lock is taken
>
> But now in a beacon's work or an active scan work, what happens is:
> - work gets woken up
> - the beacon/scan lock is taken
> - a beacon/beacon-request frame is transmitted
> - the rtnl lock is taken during this transmission
>
> Lockdep then detects a possible circular dependency:
> [  490.153387]        CPU0                    CPU1
> [  490.153391]        ----                    ----
> [  490.153394]   lock(&local->beacons_lock);
> [  490.153400]                                lock(rtnl_mutex);
> [  490.153406]                                lock(&local->beacons_lock);
> [  490.153412]   lock(rtnl_mutex);
>
> So in practice, I always need to have the rtnl lock taken when
> acquiring these other locks (beacon/scan_lock) which I think is far
> from optimal.
>

*Note that those can also be false positives.

> 1# One solution is to drop the beacons/scan locks because they are not
> useful anymore and simply rely on the rtnl.
>

depends on how long it will be held.

> 2# Another solution would be to change the mlme_tx() implementation to
> finally not need the rtnl at all.
>
> Note that just calling ASSERT_RTNL() makes no difference in 2#, it
> still means that I always need to acquire the rtnl before acquiring the
> beacons/scan locks, which greatly reduces their usefulness and leads to
> solution 1# in the end.
>
> IIRC I decided to introduce the rtnl to avoid ->ndo_stop() calls during
> an MLME transmission. I don't know if it has another use there. If not,
> we may perhaps get rid of the rtnl in mlme_tx() by really handling the
> stop calls (but I was too lazy so far to do that).
>
> What direction would you advise?

Hard to say without code. Please show us some code of the current
state... there should also be some stacktrace of the circular lock
dependency, please provide the full output _matching_ the provided
code.

Thanks.

- Alex

