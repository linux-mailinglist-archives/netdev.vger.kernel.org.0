Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206A8104565
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfKTU6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:58:02 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:41423 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKTU6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:58:02 -0500
Received: by mail-il1-f196.google.com with SMTP id q15so986879ils.8
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 12:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jAdBykSSSgb7b/uWvY1JNRyZfzIn0f0FpKL1y/XyMRM=;
        b=cjbsH/VP0XtegD0CY1rrIaJk7FeevuMXnDSxKWJZlFuYvzk2D3NMtYWd05YH5lmbSn
         9c6bHyaMJb2OTeofp+cVwkLdLEv/QvSzvPw8g4vBwIV/GRCFXEIFaMkZ1v2LJQDaAEgp
         oxZ6eFqo4XMBt4kpMEz+uD6pAiCvStKJfFsc4o8mhP8CChJF2F9R0SagSS8n63mvGkxQ
         eZsFF1wKc9+62Nx4UbWxNy+97nxu2cTBDvjr92+OL7/zzkJxVSzZvnyAHCZqAXo7uLm2
         yX7FsN/Tle0lToMiqtHNocHEpolGo5nai9z31SUc1/dGerjpNnpXvY11RLYnDt/l2gwV
         eVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jAdBykSSSgb7b/uWvY1JNRyZfzIn0f0FpKL1y/XyMRM=;
        b=K9oTwfNd9K5nja/Exriu2q/ugVNV9HKw1CxTr+C9zMeYtB6Y0KeFFxA2XViO/Dn53c
         WS2HxXAUiEWB74YG2ljmPZ6RNF2xYHEbqg75vIysF4oq/SHhbksDe3LjVdiKIXKUOMt8
         1LD5teHY6TxTjYEnUkfAyhLHmKWT2X8Zp4l8YLFYHu3DYF32aHyTIbb2PGR/Eu6NI3V8
         lZ8N1NjA7Vq7A35PBnzItHDXD8qVsnIy0vKz9UfG1qCZEeLcChAl8YgszhxCOmrAGQhR
         r7cQsB/Ys2tIFsJ2DFefzSh/D4IEkoxKH98dv+9VfJmwD7lkbUbJ7/RRrpX9izD6VnmR
         hWHQ==
X-Gm-Message-State: APjAAAXYGB7YjTkgAgvdVvtAuoOuuWgoT/f6M05AMLV2CRieXSh8YtTk
        N4YyayOXVooF17K5IDQ0mc7dWEahv4XKzSfric2VQA==
X-Google-Smtp-Source: APXvYqw3YfUKYm4PkKLw7ekpu6TWFIyUcHJ2OgCaltN7dJEUV0e9LDfwtl3UbtmhbaJYxjwT9oXKU54oJ14yYgv3b6s=
X-Received: by 2002:a92:ca8d:: with SMTP id t13mr5559051ilo.58.1574283480306;
 Wed, 20 Nov 2019 12:58:00 -0800 (PST)
MIME-Version: 1.0
References: <20191120083919.GH27852@unicorn.suse.cz> <CANn89iJYXh7AwK8_Aiz3wXqugG0icPNW6OPsPxwOvpH90kr+Ew@mail.gmail.com>
 <20191120181046.GA29650@unicorn.suse.cz> <CANn89iLfX2CYKU7hPZkPTNiUoCUyW2PLznsVnxomu4JEWmkefQ@mail.gmail.com>
 <20191120195226.GB29650@unicorn.suse.cz> <e9d19a66-94af-b4e8-255d-38a8cdc6f218@gmail.com>
 <20191120204948.GC29650@unicorn.suse.cz>
In-Reply-To: <20191120204948.GC29650@unicorn.suse.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Nov 2019 12:57:48 -0800
Message-ID: <CANn89iJeq2CCBrdgt=fFxG3Uk7f4CHbLfsOM2S8q3ucC6znzEA@mail.gmail.com>
Subject: Re: possible race in __inet_lookup_established()
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, Firo Yang <firo.yang@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:49 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Wed, Nov 20, 2019 at 12:04:53PM -0800, Eric Dumazet wrote:
> >
> >
> > On 11/20/19 11:52 AM, Michal Kubecek wrote:
> > > On Wed, Nov 20, 2019 at 11:13:09AM -0800, Eric Dumazet wrote:
> > >> On Wed, Nov 20, 2019 at 10:10 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >>>
> > >>> On Wed, Nov 20, 2019 at 08:12:10AM -0800, Eric Dumazet wrote:
> > >>>> On Wed, Nov 20, 2019 at 12:39 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >>>>
> > >>>>> Hello Eric,
> > >>>>>
> > >>>>> we are investigating a crash in socket lookup in a distribution kernel
> > >>>>> based on v4.12 but the possible problem we found seems to also apply to
> > >>>>> current mainline (or net) code.
> > >>>>>
> > >>>>> The common pattern is:
> > >>>>>
> > >>>>> - the crash always happens in __inet_lookup_established() in
> > >>>>>
> > >>>>>         sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > >>>>>                 if (sk->sk_hash != hash)     <-----------------
> > >>>>>                         continue;
> > >>>>>
> > >>>>>   as sk is an invalid pointer; in particular, &sk->sk_nulls_node is null
> > >>>>>   so dereferencing sk->sk_hash faults
> > >>>>>
> > >>>>> - the reason is that previous sk value pointed to a listening socket
> > >>>>>   rather than an established one; as listening socket uses sk_node, end
> > >>>>>   of the chain is marked by a null pointer which is not detected as
> > >>>>>   a chain end by sk_nulls_for_each_rcu()
> > >>>>>
> > >>>>> - there is no socket matching skb which is a TCP pure ACK having
> > >>>>>   127.0.0.1 as both source and destination
> > >>>>>
> > >>>>> - the chain pointed to by head variable is empty
> > >>>>>
> > >>>>> Firo Yang came with the theory that this could be a race between socket
> > >>>>> lookup and freing the socket and replacing it with a listening one:
> > >>>>>
> > >>>>> 1. CPU A gets a pointer to an established socket as sk in the
> > >>>>> sk_nulls_for_each_rcu() loop in __inet_lookup_established() but does not
> > >>>>> thake a reference to it.
> > >>>>>
> > >>>>> 2. CPU B frees the socket
> > >>>>>
> > >>>>> 3. Slab object pointed to by sk is reused for a new listening socket.
> > >>>>> This socket has null sk->sk_node->next which uses the same spot as
> > >>>>> sk->sk_nulls_node->next
> > >>>>>
> > >>>>> 4. CPU A tests sk->sk_nulls_node->next with is_a_nulls() (false) and
> > >>>>> follows the pointer, resulting in a fault dereferencing sk->sk_hash.
> > >>>>>
> > >>>>> Unless we missed something, there is no protection against established
> > >>>>> socket being freed and replaced by a new listening one while
> > >>>>> __inet_lookup_established() has a pointer to it. The RCU loop only
> > >>>>> prevents the slab object being reused for a different slab cache or
> > >>>>> something completely different but as established and listening sockets
> > >>>>> share the same slab cache, it does not protect us from switching from
> > >>>>> established to listening.
> > >>>>>
> > >>>>> As far as I can say, this kind of race could have happened for quite
> > >>>>> long but before your commit ou3b24d854cb35 ("tcp/dccp: do not touch
> > >>>>> listener sk_refcnt under synflood"), the worst that could happen would
> > >>>>> be switching to a chain in listener lookup table, following it to its
> > >>>>> end and then (most likely) restarting the lookup or failing. Now that
> > >>>>> established and listening sockets use different list types, replacing
> > >>>>> one with the other can be deadly.
> > >>>>>
> > >>>>> Do you agree that this race is possible or is there something we missed
> > >>>>> that would prevent it?
> > >>>>>
> > >>>> A listener is hashed on icsk_listen_portaddr_node, so I do not see how a
> > >>>> listener could be found in the establish chain ?
> > >>>
> > >>> It is not really in the chain. What we suspect is that between sk is
> > >>> assigned pointer to an established socket in __inet_lookup_established()
> > >>> and using sk->sk_nulls_node->next to go to the next (or stop if it's odd
> > >>> nulls value), this established socket could be freed and its slab object
> > >>> reused for a listening socket. As listening sockets no longer use a
> > >>> nulls hashlist but a normal hashlist, in the most common case where the
> > >>> socket is last in the chain, sk->sk_node->next (which occupies the same
> > >>> place as sk->sk_nulls_node->next) would be NULL so that is_a_nulls()
> > >>> does not recognize the chain end and the loop would go on to next socket
> > >>> in the chain.
> > >>>
> > >>
> > >> I hear you, but where is the sk->sk_nulls_node->next would be set to
> > >> NULL exactly ?
> > >
> > > In __inet_hash() when the new listening socket is inserted into the
> > > listening hashtable:
> > >
> > >     if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
> > >             sk->sk_family == AF_INET6)
> > >             hlist_add_tail_rcu(&sk->sk_node, &ilb->head);
> > >     else
> > >             hlist_add_head_rcu(&sk->sk_node, &ilb->head);
> > >
> > > If the chain is empty, sk->sk_node->next will be set to NULL by either
> > > branch. And even if it's not, the loop in __inet_lookup_established()
> > > would follow the chain from listening hashtable and still get to the
> > > NULL end marker eventually.
> >
> >
> > Oh right, I was confused by icsk_listen_portaddr_node, but listener use two
> > hashes...
> >
> > Do you have a patch, or do you want me to work on a fix ?
>
> Firo suggested something like
>
> ------------------------------------------------------------------------
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -362,6 +362,8 @@ struct sock *__inet_lookup_established(struct net *net,
>
>  begin:
>         sk_nulls_for_each_rcu(sk, node, &head->chain) {
> +               if (unlikely(!node))
> +                       goto begin;
>                 if (sk->sk_hash != hash)
>                         continue;
>                 if (likely(INET_MATCH(sk, net, acookie,
> ------------------------------------------------------------------------
>
> It depends on implementation details but I believe it would work. It
> would be nicer if we could detect the switch to a listening socket but
> I don't see how to make such test race free without introducing
> unacceptable performance penalty.

No, we do not want to add more checks in the fast path really.

I was more thinking about not breaking the RCU invariants.

(ie : adding back the nulls stuff that I removed in 3b24d854cb35
("tcp/dccp: do not touch
listener sk_refcnt under synflood")
