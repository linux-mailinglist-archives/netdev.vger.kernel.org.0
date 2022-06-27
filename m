Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81155D5EE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbiF0Tgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiF0Tge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:36:34 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F0A631D
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:36:33 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-318889e6a2cso95553317b3.1
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jIQjfMXHnbx3bO6Z0Q5jRfVWyH1DTc13DEgnqT18uV8=;
        b=nYDEXjOTXxzAP185jzWpvXAaSaFnHAPAm46FJjEd3zPLyAwvEkh4lj33opnmWy4pQh
         mCUl2kwtDxv97szCKkqmnwy6GXDRxf2cE6TPIoht0JSOOaygfCzpdAUNnzV0H+8WxUDn
         y7H5pIfAItBPrgePUvj4Dgo0nJIO9Ha92kJnvNdF5AyO8wWzo/rj45o3CDX06xeytoZu
         AXI0kfp0Yi+4ZugOW2ugCTJ+7XXRDOK3OnbqNCY5R9lh6EcZq0TaT0VAitC2YXWgc5TJ
         zBL73yd7+leTp2azERGZU07d++HwlqkV2JUANfWV0U4WjM7/AO/jCiaAG4yPXObX+Tsa
         L+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jIQjfMXHnbx3bO6Z0Q5jRfVWyH1DTc13DEgnqT18uV8=;
        b=srxtLEMontFFzvFiJ+JFRj5OueeA6idpbeVWXhnEHcUUBJXQN2evHyImLM26zzO0ya
         3T1uT2JWcjsyRF2cAbT7meBLBeWXy7qkB14U3HCIWehWDQNog0iQZJ7XiGQaJJpBuqQw
         KEmntUJMS1dIG/blt8CIeUvprqET8XhRcYx3n3WjdvZW2TiYdGqchn/agFxu5/8CIJ2/
         nf1ljYnpJZipAeVur551UDr/qKlrNEcDd0b4Gihx7cl/nvYslbfJ9lZxRUtJezBiznyu
         v43GE60kvytQbblzohKX2V+IHOiot9Nhwga7hsVZSEd5G0MR1cYAUhNeCCedAjZh3qVT
         1EYA==
X-Gm-Message-State: AJIora9swVVuqLlLgbK4Wx401TCAeaSOhrPAalxuC4v/7gS1vNo5dm8j
        gUqc5d33RESd5HlY8NKSq7nSrlbsL+5v/UhnOYqGSg==
X-Google-Smtp-Source: AGRyM1tDYZX3aA/2ilxRG1+GR1Qeo4nhcNgZH99EhwyQvK9E4xx7d94k0lcKZE5/Q/kdruUp5S7MgT3PWCIFqW1ofsE=
X-Received: by 2002:a81:1809:0:b0:317:c014:f700 with SMTP id
 9-20020a811809000000b00317c014f700mr17496620ywy.255.1656358592291; Mon, 27
 Jun 2022 12:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJJu2ZEu2X+AdfUKrBVj5N5h2bSDE73fwNcVmOm-JSVwA@mail.gmail.com>
 <20220627191544.4266-1-kuniyu@amazon.com>
In-Reply-To: <20220627191544.4266-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jun 2022 21:36:18 +0200
Message-ID: <CANn89iJsk7g0LcH17u=JbLy5dwYi0QVg84b3c5eLf-zUTK5b8g@mail.gmail.com>
Subject: Re: [PATCH v2 net] af_unix: Do not call kmemdup() for init_net's
 sysctl table.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 9:16 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Mon, 27 Jun 2022 21:06:14 +0200
> > On Mon, Jun 27, 2022 at 8:59 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > >
> > > From:   Eric Dumazet <edumazet@google.com>
> > > Date:   Mon, 27 Jun 2022 20:40:24 +0200
> > > > On Mon, Jun 27, 2022 at 8:30 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > > > >
> > > > > From:   Jakub Kicinski <kuba@kernel.org>
> > > > > Date:   Mon, 27 Jun 2022 10:58:59 -0700
> > > > > > On Sun, 26 Jun 2022 11:43:27 -0500 Eric W. Biederman wrote:
> > > > > > > Kuniyuki Iwashima <kuniyu@amazon.com> writes:
> > > > > > >
> > > > > > > > While setting up init_net's sysctl table, we need not duplicate the global
> > > > > > > > table and can use it directly.
> > > > > > >
> > > > > > > Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > > >
> > > > > > > I am not quite certain the savings of a single entry table justivies
> > > > > > > the complexity.  But the looks correct.
> > > > > >
> > > > > > Yeah, the commit message is a little sparse. The "why" is not addressed.
> > > > > > Could you add more details to explain the motivation?
> > > > >
> > > > > I was working on a series which converts UDP/TCP hash tables into per-netns
> > > > > ones like AF_UNIX to speed up looking up sockets.  It will consume much
> > > > > memory on a host with thousands of netns, but it can be waste if we do not
> > > > > have its protocol family's sockets.
> > > >
> > > > For the record, I doubt we will accept such a patch (per net-ns
> > > > TCP/UDP hash tables)
> > >
> > > Is it because it's risky?
> >
> > Because it will be very expensive. TCP hash tables are quite big.
>
> Yes, so I'm wondering if changing the size by sysctl makes sense.  If we
> have per-netns hash tables, each table should have smaller amount of
> sockets and smaller size should be enough, I think.

How can a sysctl be safely used if two different threads call "unshare
-n" at the same time ?

>
> >
> > [    4.917080] tcp_listen_portaddr_hash hash table entries: 65536
> > (order: 8, 1048576 bytes, vmalloc)
> > [    4.917260] TCP established hash table entries: 524288 (order: 10,
> > 4194304 bytes, vmalloc hugepage)
> > [    4.917760] TCP bind hash table entries: 65536 (order: 8, 1048576
> > bytes, vmalloc)
> > [    4.917881] TCP: Hash tables configured (established 524288 bind 65536)
> >
> >
> >
> > > IIRC, you said we need per netns table for TCP in the future.
> >
> > Which ones exactly ? I guess you misunderstood.
>
> I think this.
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=04c494e68a13

"might" is very different than "will"

I would rather use the list of time_wait, instead of adding huge
memory costs for hosts with hundreds of netns.
