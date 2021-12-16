Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86384477764
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbhLPQMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhLPQMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:12:33 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE126C06173E;
        Thu, 16 Dec 2021 08:12:33 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id t9-20020a4a8589000000b002c5c4d19723so7028060ooh.11;
        Thu, 16 Dec 2021 08:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kZY0y4bJ51DNchCQ2ejZd3Xh1xZcKkFY6bC/GIArL0=;
        b=nAgA/qpjKfVvgxYfTjtw+a6Pd/1/AfG6Y6xfyiJFHHxQkMQhkH+p6kncmKhP8Gdp5f
         hmoZIDMKlK9X+eW/HD59KMkqh0E9l9gU7lVJMaIULD3rnCGgV/JjGRzPaRxIsseox56y
         yRid31eEM1NoDZp02PUS78e4m0kklW92OPbNyXFMNOft3P8x1HVHhdDhEX4BQju5tf6g
         MhGND/eJArQCOXohCE4ph9lMHS7pX5tNQ1EpIAzJiFf44E9mwmSmm1fnCWS/NZxh3h/t
         Lq922YHFrAUTm3EifMyVM3vB3i9OWzI8yzMDwRSgpmLLMr/rhhdDO6lQvREDAtEIvS5K
         CuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kZY0y4bJ51DNchCQ2ejZd3Xh1xZcKkFY6bC/GIArL0=;
        b=k3hv5easVGCzmJ4VOyjqcYxP3+ZdcbjQLQ9eUCyJDoZtb+yw6IlTmraoZEFVp8Mmx9
         xI7UJejFX8i0lqFKhePSiphEN8hwP5ubqi6l9C2CkThzRpxLYPYS4DPvXkHNjkeEFvP3
         tMktIw0CReid/2HvjdUtVi6z1Sh86aL12n6wLKzRjcWXGdII+15Dp3lFgLXlCqGHShEk
         DDvRDHFm+A7y51lNZZ/TD7HPJNKDJlSWfFPE61anzdU868PCegg9X4hWWMFmge6KiXSv
         OIzLeAtPtx9XJzKthmRWyWvsxL97AihQf7KvFWivwnKX7E4qWarH51MVdrJfPvFvlEjb
         hKJA==
X-Gm-Message-State: AOAM5320XURGFNj/vqfEJ8PFYU+VAx8WiOpD4jbuC4EaoSgw4VNWo9wT
        XmRAoLNTmYihJRRSqkLB6bHVxmJDhZdTSergmcM=
X-Google-Smtp-Source: ABdhPJy/4c+4QoJGB5vgsj7Dlzr2XsROyjpIWNv04Gthol0bd8SEQMUhab2NX4mgdnUh55ISlr87FKobbSkG9Ln41Yw=
X-Received: by 2002:a4a:d68f:: with SMTP id i15mr11657941oot.77.1639671152984;
 Thu, 16 Dec 2021 08:12:32 -0800 (PST)
MIME-Version: 1.0
References: <20211214215732.1507504-1-lee.jones@linaro.org>
 <20211214215732.1507504-2-lee.jones@linaro.org> <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215174818.65f3af5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 16 Dec 2021 11:12:22 -0500
Message-ID: <CADvbK_emZsHVsBvNFk9B5kCZjmAQkMBAx1MtwusDJ-+vt0ukPA@mail.gmail.com>
Subject: Re: [RESEND 2/2] sctp: hold cached endpoints to prevent possible UAF
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        lksctp developers <linux-sctp@vger.kernel.org>,
        "H.P. Yarroll" <piggy@acm.org>,
        Karl Knutson <karl@athena.chicago.il.us>,
        Jon Grimm <jgrimm@us.ibm.com>,
        Xingang Guo <xingang.guo@intel.com>,
        Hui Huang <hui.huang@nokia.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        Daisy Chang <daisyc@us.ibm.com>,
        Ryan Layer <rmlayer@us.ibm.com>,
        Kevin Gao <kevin.gao@intel.com>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 14 Dec 2021 21:57:32 +0000 Lee Jones wrote:
> > The cause of the resultant dump_stack() reported below is a
> > dereference of a freed pointer to 'struct sctp_endpoint' in
> > sctp_sock_dump().
> >
> > This race condition occurs when a transport is cached into its
> > associated hash table followed by an endpoint/sock migration to a new
> > association in sctp_assoc_migrate() prior to their subsequent use in
> > sctp_diag_dump() which uses sctp_for_each_transport() to walk the hash
> > table calling into sctp_sock_dump() where the dereference occurs.
in sctp_sock_dump():
        struct sock *sk = ep->base.sk;
        ... <--[1]
        lock_sock(sk);

Do you mean in [1], the sk is peeled off and gets freed elsewhere?
if that's true, it's still late to do sock_hold(sk) in your this patch.

I talked with Marcelo about this before, if the possible UAF in [1] exists,
the problem also exists in the main RX path sctp_rcv().

> >
> >   BUG: KASAN: use-after-free in sctp_sock_dump+0xa8/0x438 [sctp_diag]
> >   Call trace:
> >    dump_backtrace+0x0/0x2dc
> >    show_stack+0x20/0x2c
> >    dump_stack+0x120/0x144
> >    print_address_description+0x80/0x2f4
> >    __kasan_report+0x174/0x194
> >    kasan_report+0x10/0x18
> >    __asan_load8+0x84/0x8c
> >    sctp_sock_dump+0xa8/0x438 [sctp_diag]
> >    sctp_for_each_transport+0x1e0/0x26c [sctp]
> >    sctp_diag_dump+0x180/0x1f0 [sctp_diag]
> >    inet_diag_dump+0x12c/0x168
> >    netlink_dump+0x24c/0x5b8
> >    __netlink_dump_start+0x274/0x2a8
> >    inet_diag_handler_cmd+0x224/0x274
> >    sock_diag_rcv_msg+0x21c/0x230
> >    netlink_rcv_skb+0xe0/0x1bc
> >    sock_diag_rcv+0x34/0x48
> >    netlink_unicast+0x3b4/0x430
> >    netlink_sendmsg+0x4f0/0x574
> >    sock_write_iter+0x18c/0x1f0
> >    do_iter_readv_writev+0x230/0x2a8
> >    do_iter_write+0xc8/0x2b4
> >    vfs_writev+0xf8/0x184
> >    do_writev+0xb0/0x1a8
> >    __arm64_sys_writev+0x4c/0x5c
> >    el0_svc_common+0x118/0x250
> >    el0_svc_handler+0x3c/0x9c
> >    el0_svc+0x8/0xc
> >
> > To prevent this from happening we need to take a references to the
> > to-be-used/dereferenced 'struct sock' and 'struct sctp_endpoint's
> > until such a time when we know it can be safely released.
> >
> > When KASAN is not enabled, a similar, but slightly different NULL
> > pointer derefernce crash occurs later along the thread of execution in
> > inet_sctp_diag_fill() this time.
Are you able to reproduce this issue?

What I'm thinking is to fix it by freeing sk in call_rcu() by
sock_set_flag(sock->sk, SOCK_RCU_FREE),
and add rcu_read_lock() in sctp_sock_dump().

Thanks.

>
> Are you able to identify where the bug was introduced? Fixes tag would
> be good to have here.
>
> You should squash the two patches together.
>
> > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > index 760b367644c12..2029b240b6f24 100644
> > --- a/net/sctp/diag.c
> > +++ b/net/sctp/diag.c
> > @@ -301,6 +301,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> >       struct sctp_association *assoc;
> >       int err = 0;
> >
> > +     sctp_endpoint_hold(ep);
> > +     sock_hold(sk);
> >       lock_sock(sk);
> >       list_for_each_entry(assoc, &ep->asocs, asocs) {
> >               if (cb->args[4] < cb->args[1])
> > @@ -341,6 +343,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
> >       cb->args[4] = 0;
> >  release:
> >       release_sock(sk);
> > +     sock_put(sk);
> > +     sctp_endpoint_put(ep);
> >       return err;
> >  }
> >
>
