Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4084F50E3AB
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbiDYOxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 10:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiDYOxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 10:53:17 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41F6312
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 07:50:12 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x33so26635886lfu.1
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zf+hXoaAIJMPkGuw9oZzSZmXBy9xEijxBEFasiFjsj0=;
        b=YTq29PMLtEWTPvNx3IridBO7V15I7wB2orLxynEyqxO8vtGJ+U9bkhavODwnylL8FU
         998NnGCNIZv6z2GaAKfGsp82gPKV+cUR+KkoH7RdgqiPq2fvdkX6LxcuvfSTct64Tyd9
         SLayyDNamYshewdBXRZl2gL4hAPl8E8rZmcNRqkqA8Jpug9OWp5WmCD709fjGYW8hIGj
         vG/nfYpOneDl1YcpsFeb690hvEQk296835lQxFOhOPdzjZeFh+q2aZ1eRoYtqgbWi6j0
         Gp/b1D0Ygne4Z9seONxVcb4lu1O7BSazHANNbIh43soSHSQPsTiBndQLi6SFB1tseRe3
         FMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zf+hXoaAIJMPkGuw9oZzSZmXBy9xEijxBEFasiFjsj0=;
        b=1LCwf2H8UhhExWVk8Y1/nZK0x10ek45hi9sKnYJA4MrQaItSPtbUY0DTF0hJAnf7BP
         qaiQmAmNUmFPJ/XGrOIHJCfPLGBDV02uIMcuUqCqozZsDEiewYEhw3JTfPghVCfCZZ2T
         dvlyNiHtugY+cBrEWFCjgVIxmEbHUaKxjDOpRRrvuDQr1sPfTUB3PDzA2zhbEnqDH2jJ
         f8QmAU40WyZrDFAJ7eoR3w7uTAjcwec63V+c+29RnXeVD22KaEl1Kp4hgTwAWXHSnWKt
         GjSLoy7stpK6kPyU/wKNZGHmXqnssgCNmVOI8SLqhFDvNAH0Qk1hntXdUG4mWF1WtgzQ
         9pzw==
X-Gm-Message-State: AOAM531E1pEVle838fPuHFw94AWAloG04XlFxPRL/XlUpHj3Bx7apOyO
        ykSuZENANjnGMhTzbKcTr7IpTeGrfmiFTqc0fax3Lw==
X-Google-Smtp-Source: ABdhPJzR1pamSALPzrMFywGCe3pa9IBZOoONhSRpoYWIIFexCf+gWN7rEU656nXukBiUcEHuNnTE6OVPAPgj+ObDP4o=
X-Received: by 2002:ac2:5a47:0:b0:471:fdbe:910b with SMTP id
 r7-20020ac25a47000000b00471fdbe910bmr6812242lfn.315.1650898210890; Mon, 25
 Apr 2022 07:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de> <20220425074146.1fa27d5f@kernel.org>
In-Reply-To: <20220425074146.1fa27d5f@kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 25 Apr 2022 16:49:34 +0200
Message-ID: <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lukas Wunner <lukas@wunner.de>, Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 4:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 23 Apr 2022 18:07:23 +0200 Lukas Wunner wrote:
> > > Looking at the original report it looks like the issue could be
> > > resolved with a more usb-specific change: e.g. it looks like
> > > usbnet_defer_kevent() is not acquiring a dev reference as it should.
> > >
> > > Have you considered that path?
> >
> > First of all, the diffstat of the patch shows this is an opportunity
> > to reduce LoC as well as simplify and speed up device teardown.
> >
> > Second, the approach you're proposing won't work if a driver calls
> > netif_carrier_on/off() after unregister_netdev().
> >
> > It seems prudent to prevent such a misbehavior in *any* driver,
> > not just usbnet.  usbnet may not be the only one doing it wrong.
> > Jann pointed out that there are more syzbot reports related
> > to a UAF in linkwatch:
> >
> > https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot
> >
> > Third, I think an API which schedules work, invisibly to the driver,
> > is dangerous and misguided.  If it is illegal to call
> > netif_carrier_on/off() for an unregistered but not yet freed netdev,
> > catch that in core networking code and don't expect drivers to respect
> > a rule which isn't even documented.
>
> Doesn't mean we should make it legal. We can add a warning to catch
> abuses.

That was the idea with
https://lore.kernel.org/netdev/20220128014303.2334568-1-jannh@google.com/,
but I didn't get any replies when I asked what the precise semantics
of dev_hold() are supposed to be
(https://lore.kernel.org/netdev/CAG48ez1-OyZETvrYAfaHicYW1LbrQUVp=C0EukSWqZrYMej73w@mail.gmail.com/),
so I don't know how to proceed...
