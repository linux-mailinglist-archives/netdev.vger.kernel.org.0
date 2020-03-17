Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B6A187DFF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 11:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgCQKRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 06:17:49 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39820 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgCQKRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 06:17:49 -0400
Received: by mail-ot1-f68.google.com with SMTP id r2so5608964otn.6
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 03:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oDa8VM8GdllhFAvMRWp4hpupCPaz/QUO5MsZDtEiqs0=;
        b=ltYysL5WIC7dpKo4GMaDU8Ml3B6mi7mjaGVG65T2DEiDiGYOgzRyMLCrxrRWChP5HS
         yTQFrSduvcsM0xNp1YBTAIiflKZ/sMN8pGWZae/ArhXNCikTtXesCEck8fUXUCEp/w/C
         Iw+LoUythKxvdhc9mhmIz2zs2mGoFetgsadTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oDa8VM8GdllhFAvMRWp4hpupCPaz/QUO5MsZDtEiqs0=;
        b=l/G+XeDPSv+JXeh/5tjdB5l581vNvHnewNk6Y3vk0WODmxeS5tDxXfUYe+ks+eqm2u
         0MGO1QjeZnMRJGijN5f5QNBXiXwUyM1HEpcEplHzTwBQNowD/dn5BFSB8jV/nSmXYmDF
         hPoEEuFFlNCmONDgN+iOClF+BJSAsAsuXYqKvUAsRhVM7UaZe644ePo1bEom1ZNwaiSU
         slGID4kjlgXh76lVIWk0C/pbcEnHHuhF85OA5TG4RhJa0luzVMYDFm92o+Ah1VCTqxKz
         svioMtuAXqSQKmWnxWWBisEWslZPOPm7hYbyHf5RIPUCTbzT6afs3KpJVSKwToibLTYT
         IpzA==
X-Gm-Message-State: ANhLgQ0inmK5WdyASJ7EgoN5RMsZBiFkcmwmP785NW1ZkKfO+tU9NCeg
        zQUQ/Ly9ms6NL0krsTWHJfbCptKAY5yvLAwnnYBJgNy1yMk=
X-Google-Smtp-Source: ADFU+vuLKvREZqrIEBvOy9oEphIEL8EarmOXVsUtthjxfzzfXXP7vVtCLR/q+kK0AHEL4R5JJBkITw0OWnska0E6pcA=
X-Received: by 2002:a9d:30c7:: with SMTP id r7mr2911068otg.289.1584440268438;
 Tue, 17 Mar 2020 03:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200310174711.7490-1-lmb@cloudflare.com> <20200310174711.7490-5-lmb@cloudflare.com>
 <5e6973ed90f8d_20552ab9153405b4ca@john-XPS-13-9370.notmuch>
In-Reply-To: <5e6973ed90f8d_20552ab9153405b4ca@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 17 Mar 2020 10:17:37 +0000
Message-ID: <CACAyw9_4wvOdE+enxxJPPTMXbfFmWfMo8qcaRtu6j0y4W=E9HQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] bpf: sockmap, sockhash: return file descriptors from
 privileged lookup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 at 23:27, John Fastabend <john.fastabend@gmail.com> wrote:
>
> Lorenz Bauer wrote:
> > Allow callers with CAP_NET_ADMIN to retrieve file descriptors from a
> > sockmap and sockhash. O_CLOEXEC is enforced on all fds.
> >
> > Without this, it's difficult to resize or otherwise rebuild existing
> > sockmap or sockhashes.
> >
> > Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > ---
> >  net/core/sock_map.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 03e04426cd21..3228936aa31e 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -347,12 +347,31 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
> >  static int __sock_map_copy_value(struct bpf_map *map, struct sock *sk,
> >                                void *value)
> >  {
> > +     struct file *file;
> > +     int fd;
> > +
> >       switch (map->value_size) {
> >       case sizeof(u64):
> >               sock_gen_cookie(sk);
> >               *(u64 *)value = atomic64_read(&sk->sk_cookie);
> >               return 0;
> >
> > +     case sizeof(u32):
> > +             if (!capable(CAP_NET_ADMIN))
> > +                     return -EPERM;
> > +
> > +             fd = get_unused_fd_flags(O_CLOEXEC);
> > +             if (unlikely(fd < 0))
> > +                     return fd;
> > +
> > +             read_lock_bh(&sk->sk_callback_lock);
> > +             file = get_file(sk->sk_socket->file);
> > +             read_unlock_bh(&sk->sk_callback_lock);
> > +
> > +             fd_install(fd, file);
> > +             *(u32 *)value = fd;
> > +             return 0;
> > +
>
> Hi Lorenz, Can you say something about what happens if the sk
> is deleted from the map or the sock is closed/unhashed ideally
> in the commit message so we have it for later reference. I guess
> because we are in an rcu block here the sk will be OK and psock
> reference will exist until after the rcu block at least because
> of call_rcu(). If the psock is destroyed from another path then
> the fd will still point at the sock. correct?

This is how I understand it:
* sk is protected by rcu_read_lock (as you point out)
* sk->sk_callback_lock protects against sk->sk_socket being
  modified by sock_orphan, sock_graft, etc. via sk_set_socket
* get_file increments the refcount on the file

I'm not sure how the psock figures into this, maybe you can
elaborate a little?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
