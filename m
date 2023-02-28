Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67266A5D36
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjB1QgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjB1QgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:36:15 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5294830B19
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:36:01 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id i12so6647535ila.5
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ltXYXOcZ3OGIEPn2c8rUXOu2L4S2v+sWCbU8pCw0aJE=;
        b=Z2NjPSwGU0nPH5QAkdlmpkhE7nS2c60627BIY1ABwtfjidxH4jvRSphSPOhL1uUb90
         BZaIca15B9kS+YOoFeLilxhJe5OADnTdc2RIrcyRp0GFWS6Vq7KHKnaIXYlzBGv0gBRv
         IRZR1WRfh4JSJ5OmqBZNwwNpRwv92Q3OSLH6596nlYdxoOe+K639ikjyjBo8f2PeaQtl
         4pKwWgNcGJ0BX570m1YVctVP8pKxEa1409vfSQ2brDf1LIM6kJQKKb1xbSr2AQcxNLKR
         ay87bDtEEKEaKpB/bQyjuiUEpCsy0llImXdieyssZGg6JSS8TrPBNHtx+/Pyf9ydayja
         6Nrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltXYXOcZ3OGIEPn2c8rUXOu2L4S2v+sWCbU8pCw0aJE=;
        b=OJ5bL8KaDEfjsafQd0fKzr4XwnMBOvwsT1igGjSvSmOJFe1Km5cNTAepCzaBzM4HLG
         wzzyIQTAj91BtikKZWN0uH5ya39LgE2bCa0PLXxzAqvumVYHg/U5ApsKY9n4iptNAyBB
         FIYLSRUN2K4S1TXqhbvKMLAfAsw5B3B/t6UiDuWm7TuIIMCr85EwbEUF+XOvJ8ZRMKfZ
         n7144gQTnAck/TV9HXOcmiQAPQBqVvg4KLvov8sfDOROIdC7WVltRe7MyhhaowPrPIbs
         6+0MIroYkh7I0poD6X6l90vn3DZH32fK7u19v61A4jqyyw1SymXUkCih/LAfx+1LHmjy
         9HaA==
X-Gm-Message-State: AO0yUKUNDLfsqvwQ63IwpZQgqhg3aoXToQxkx9yZAKEYhiL4FFh8r2AW
        +1y2Hy1Lf3Hb0ImPjYLOgHEHs4IUpDsvtGt9zFwp+SXGce8f742Q
X-Google-Smtp-Source: AK7set+/k8fKAtmO5jBgoWqQsE2qzBdBUG/GhdfBcNUxRby/pD6FCVBRqtRezRnZN7I9JHqhDDZYBz+FYDQqbepQ/lw=
X-Received: by 2002:a92:6d06:0:b0:314:1fbc:27c9 with SMTP id
 i6-20020a926d06000000b003141fbc27c9mr1649431ilc.2.1677602160483; Tue, 28 Feb
 2023 08:36:00 -0800 (PST)
MIME-Version: 1.0
References: <20230224184606.7101-1-fw@strlen.de> <20230227152741.4a53634b@kernel.org>
 <0650079e-2cc1-626b-ac04-2230b41fd842@intel.com> <20230228163453.GA11370@breakpoint.cc>
In-Reply-To: <20230228163453.GA11370@breakpoint.cc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 17:35:49 +0100
Message-ID: <CANn89i+jO1Zbd5w_sCO3muvo=jByWOaXxd9EUjHZiYJSYAATBw@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
To:     Florian Westphal <fw@strlen.de>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, shakeelb@google.com,
        soheil@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Feb 28, 2023 at 5:35=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Date: Mon, 27 Feb 2023 15:27:41 -0800
> >
> > > On Fri, 24 Feb 2023 19:46:06 +0100 Florian Westphal wrote:
> > >> There is a noticeable tcp performance regression (loopback or cross-=
netns),
> > >> seen with iperf3 -Z (sendfile mode) when generic retpolines are need=
ed.
> > >>
> > >> With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
> > >> memory pressure happen much more often. For TCP indirect calls are
> > >> used.
> > >>
> > >> We can't remove the if-set-return short-circuit check in
> > >> tcp_enter_memory_pressure because there are callers other than
> > >> sk_enter_memory_pressure.  Doing a check in the sk wrapper too
> > >> reduces the indirect calls enough to recover some performance.
> > >>
> > >> Before,
> > >> 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiv=
er
> > >>
> > >> After:
> > >> 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiv=
er
> > >>
> > >> "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns=
.
> > >>
> > >> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as pos=
sible")
> > >> Signed-off-by: Florian Westphal <fw@strlen.de>
> > >
> > > Looks acceptable, Eric?
> > >
> > I'm no Eric, but I'd only change this:
> >
> > +     if (!memory_pressure || READ_ONCE(*memory_pressure) =3D=3D 0)
> >
> > to
> >
> > +     if (!memory_pressure || !READ_ONCE(*memory_pressure))
>
> I intentioanlly used '=3D=3D 0', i found it too easy to miss the '!' befo=
re
> 'R'.  But maybe I just need better glasses.

Sorry for the delay, I will take a look.
