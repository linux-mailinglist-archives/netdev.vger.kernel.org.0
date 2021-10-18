Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81F74317A8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhJRLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhJRLoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 07:44:44 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE7AC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 04:42:33 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y67so15777359iof.10
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 04:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h1II37IqxtxHNfmwlKrunAbTZFyn/K9e7PuKm/vrkqM=;
        b=hPtslMqLqL4Yckt2QUfkU+ILZWGUnr9/yL8Pt1DQJ7gScJaJVZPzv+/hGkPZNiqEDX
         b7oEA+YWlqZUtt6sfsPijTeUJgatBq8nEGfLbSlIdYSyvFgDMzmc5C018b54bHSyNK98
         TgefsSqMXVDu+N0kHe8uoyVM6mK6NMS+eHIGajcbCjMoWK91O0PQDiShO4wpWeSBbD65
         QZHpkR0i0jYHt1JZ5CJlRr3nOt571HKimc3r9wxA/aDJCwwRcBqn+Cxg6+UNrmZcWftz
         MdIFsTo9msKW2ZI4HChEsKx+USYUqKKjGb3KQLsnzJ14SvrKqJwvqL45ANf4cLUgTVOz
         OnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h1II37IqxtxHNfmwlKrunAbTZFyn/K9e7PuKm/vrkqM=;
        b=stGcpPuObvugpoKNIdezQOR1PHCA0avsJzb7yeTFMQ10JmLgYXrOLWlZ/nMGYDXEFr
         fNVkjdNBHPgP6/pR8DAwS87teK2CgvMNw++b2cUSBprnTFXrZJ5v0fEFu168Hk9+q0Ce
         xxM1V3nZ3CxzXO1abp+uzXDfL4P41rgfkJ19nP41qtnMkFZvIrGzzc3TTKzl3lLIi1IH
         VhmVAAcG8otsZYcAsJqjaCeXxg9ejw5TWXaR2FS2smLssPg90axitLgfJXEafKtWpyT9
         l3dEJZDWPpA6ci7Igcsz6Y6A2QAjj3mydItIW5R+DKiolcmHQC7gFHcvf3Z5+FWM8v1o
         D8Kg==
X-Gm-Message-State: AOAM530PjuUWTxZ/Auau/B4IMS6esBDwbYpcza0WhxDmo6VuKKaql6GW
        PfNdeqXDQ+jMg3NOewzDieG2vvU9eZo/2DTIFbY=
X-Google-Smtp-Source: ABdhPJy6CnykuyVItN/+WRw0+xbXoQXS9r+T31fTasnqaWInS5CqDSfDI58ra5oRcmJL/RUt9SqEzt8lqVPhUk3EUXQ=
X-Received: by 2002:a6b:cd87:: with SMTP id d129mr13441244iog.28.1634557352555;
 Mon, 18 Oct 2021 04:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com> <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
In-Reply-To: <9608bf7c-a6a2-2a30-2d96-96bd1dfb25e3@bobbriscoe.net>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 18 Oct 2021 04:42:20 -0700
Message-ID: <CAA93jw4mjmA9xfqSW6FOHjQXxEJfuttQzeyeU5PWLdgYzR6U8g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
To:     Bob Briscoe <ietf@bobbriscoe.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally I would comment in-line on the patches but was somehow
unsubscribed to netdev as of oct 11. I'm glad more eyeballs
are on this, finally, however.

1) I would prefer this series bake in the l4s and bbrv2 trees a while,
be tested on vms, containers, on cloudy substrates, and home routers.

Note, I just said series. pie, fq_pie, and cake all can use
rfc3168-style ecn. Worse, fq_codel is also used in the wifi stack, but
not as a qdisc.

I think a safer and simpler path forward for existing assumptions and
callers for rfc3168 -style is that the existing INET_ECN_set_ce and
related calls be reworked to exclude ect1.

(as seen here) https://code.woboq.org/linux/linux/include/net/codel_impl.h.html#182

and the existing ce_threshold parameter enabled by default (at some
acceptible threshold) but only on detecting ect_1. That eliminates
the change to the uapi, and more correctly supports both standards.

Not having the ce_threshold param exposed currently in wifi and not
knowing how to make l4s-style signalling (at least vs tcp prague,
maybe not against bbrv2), it seems safest to make ect_1 - > drop reno
style on wifi, presently.

2) I don't know what is supposed to happen with GRO/GSO packets. This
is actually a long standing confusion of mine in the present day
linux stack - if a GRO packet (say an IW10 burst) is marked - do all
the packets get the marking? or just one? Is it driver or hardware
dependent? (software GRO is the bane of my existence)

3) My other long standing confusion is "triggered" by how we do
statistics keeping for packets - ce_mark gets overloaded by this
patch,
and we end up tracking two very different instances of the same idea
in the kernel statistics (much like the confusion along the path).
Given the frequency of marking in the l4s case is much higher than the
rfc3168 case, I'd advocate for a separate, 64 bit statistic.

Please note that in general I find the "packets" stat in the kernel,
given gso/gro, kind of hard to deal with in the first place,
"bytes_marked"
would be a better statistic to track than packets.
