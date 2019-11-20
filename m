Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD25104403
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfKTTNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:13:25 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33315 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfKTTNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:13:25 -0500
Received: by mail-io1-f65.google.com with SMTP id j13so487293ioe.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 11:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mclxCsHKzbR36d5e9hgll2WFrQNIIO+Q3B0RezvabIs=;
        b=mrgEX94LZGHw8tAX12R3uHtwkOdKwoCRbo3wiNUUZ7Ok6XPh+TwQQcImFg1JKXvJep
         FUcTj5MlT6T0hipQzWBpy61RY3SbPNC/CN6YgtohWcsOIsV0xeVY3rXCS3wt7AODGdue
         kQDK6uAsT7cjyskat0sTUj8tsGl1DAP1GOySHm59VDaAJm+RhVK09JWQSy4hDxMeaOV8
         u9K0+Xmiyx4RxMDnp8TMORFXneIs6TywlslCR6tdb3qalLSupZ1j97YD2yjUoPBg27Z1
         /0JFhV73Wb/amHjr3Yc2z7Kx36xC9VE/3Iyd7BGsk9uN/0jexyrTo8HnhhYQb7ahmUwy
         SYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mclxCsHKzbR36d5e9hgll2WFrQNIIO+Q3B0RezvabIs=;
        b=aYn1k2mHRNaiU77TbsdmnJFLZOfge4lFcD4SMXcKEPe0kE3E6TJfhIm4kBVZrUttRY
         r0DFyaF7Rmm3sEox6sKWZHAfykuXM/XOKz7HI5MwWTFl+xOS4cBOLB9SFc3KROQrDtgu
         l6JpcdhDpnOco9hXKkmZqbStsYggA5/cipngvhpTXFSq5GAbmhnPt74+A8juv+Jy8uPV
         uDRVgt2jZt841323olWI8Ik1AS4mYW7pv20jg+75802Nz5LjneEbKW/w+tszSJIVdQls
         CqOJKrzrrTW2IAZXZjTbU2X07gD5nvydargadObWT+VCx8/WCqWn3EwXLKQB8jJmJrEt
         BWIw==
X-Gm-Message-State: APjAAAV4NEPKiFmToWJ6seBdzuoGPDZGRDFDB8lX7UdOvQuPjv4ldcYq
        DFNcOvx7thalVdoZhmm3NYTaIyHzRMc65uJjVe+onQ==
X-Google-Smtp-Source: APXvYqxpoFfZm8FRGaqhamf5hUX+7P/V9i17v03+yyNDvJsqOCGSArFF1UaB9NM8HssID1tBvlnMRDrrwvTC6ABeLK0=
X-Received: by 2002:a02:ad14:: with SMTP id s20mr4729083jan.132.1574277203475;
 Wed, 20 Nov 2019 11:13:23 -0800 (PST)
MIME-Version: 1.0
References: <20191120083919.GH27852@unicorn.suse.cz> <CANn89iJYXh7AwK8_Aiz3wXqugG0icPNW6OPsPxwOvpH90kr+Ew@mail.gmail.com>
 <20191120181046.GA29650@unicorn.suse.cz>
In-Reply-To: <20191120181046.GA29650@unicorn.suse.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Nov 2019 11:13:09 -0800
Message-ID: <CANn89iLfX2CYKU7hPZkPTNiUoCUyW2PLznsVnxomu4JEWmkefQ@mail.gmail.com>
Subject: Re: possible race in __inet_lookup_established()
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Firo Yang <firo.yang@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 10:10 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Wed, Nov 20, 2019 at 08:12:10AM -0800, Eric Dumazet wrote:
> > On Wed, Nov 20, 2019 at 12:39 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > > Hello Eric,
> > >
> > > we are investigating a crash in socket lookup in a distribution kernel
> > > based on v4.12 but the possible problem we found seems to also apply to
> > > current mainline (or net) code.
> > >
> > > The common pattern is:
> > >
> > > - the crash always happens in __inet_lookup_established() in
> > >
> > >         sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > >                 if (sk->sk_hash != hash)     <-----------------
> > >                         continue;
> > >
> > >   as sk is an invalid pointer; in particular, &sk->sk_nulls_node is null
> > >   so dereferencing sk->sk_hash faults
> > >
> > > - the reason is that previous sk value pointed to a listening socket
> > >   rather than an established one; as listening socket uses sk_node, end
> > >   of the chain is marked by a null pointer which is not detected as
> > >   a chain end by sk_nulls_for_each_rcu()
> > >
> > > - there is no socket matching skb which is a TCP pure ACK having
> > >   127.0.0.1 as both source and destination
> > >
> > > - the chain pointed to by head variable is empty
> > >
> > > Firo Yang came with the theory that this could be a race between socket
> > > lookup and freing the socket and replacing it with a listening one:
> > >
> > > 1. CPU A gets a pointer to an established socket as sk in the
> > > sk_nulls_for_each_rcu() loop in __inet_lookup_established() but does not
> > > thake a reference to it.
> > >
> > > 2. CPU B frees the socket
> > >
> > > 3. Slab object pointed to by sk is reused for a new listening socket.
> > > This socket has null sk->sk_node->next which uses the same spot as
> > > sk->sk_nulls_node->next
> > >
> > > 4. CPU A tests sk->sk_nulls_node->next with is_a_nulls() (false) and
> > > follows the pointer, resulting in a fault dereferencing sk->sk_hash.
> > >
> > > Unless we missed something, there is no protection against established
> > > socket being freed and replaced by a new listening one while
> > > __inet_lookup_established() has a pointer to it. The RCU loop only
> > > prevents the slab object being reused for a different slab cache or
> > > something completely different but as established and listening sockets
> > > share the same slab cache, it does not protect us from switching from
> > > established to listening.
> > >
> > > As far as I can say, this kind of race could have happened for quite
> > > long but before your commit ou3b24d854cb35 ("tcp/dccp: do not touch
> > > listener sk_refcnt under synflood"), the worst that could happen would
> > > be switching to a chain in listener lookup table, following it to its
> > > end and then (most likely) restarting the lookup or failing. Now that
> > > established and listening sockets use different list types, replacing
> > > one with the other can be deadly.
> > >
> > > Do you agree that this race is possible or is there something we missed
> > > that would prevent it?
> > >
> > A listener is hashed on icsk_listen_portaddr_node, so I do not see how a
> > listener could be found in the establish chain ?
>
> It is not really in the chain. What we suspect is that between sk is
> assigned pointer to an established socket in __inet_lookup_established()
> and using sk->sk_nulls_node->next to go to the next (or stop if it's odd
> nulls value), this established socket could be freed and its slab object
> reused for a listening socket. As listening sockets no longer use a
> nulls hashlist but a normal hashlist, in the most common case where the
> socket is last in the chain, sk->sk_node->next (which occupies the same
> place as sk->sk_nulls_node->next) would be NULL so that is_a_nulls()
> does not recognize the chain end and the loop would go on to next socket
> in the chain.
>

I hear you, but where is the sk->sk_nulls_node->next would be set to
NULL exactly ?

> Michal
>
> >
> > sock_copy() makes sure to not touch sk_node
> >
> > sk_prot_clear_nulls() makes sure to not touch sk_node
> >
> > So maybe you miss a backport or something ?
