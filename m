Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADBA47E690
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 17:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349331AbhLWQ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 11:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349332AbhLWQ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 11:57:31 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535CAC061401;
        Thu, 23 Dec 2021 08:57:31 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id t19so9839001oij.1;
        Thu, 23 Dec 2021 08:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x68JNUu4zQNAYnVJBqT71y3SJaZIEALyvIGW4hRW+sE=;
        b=OWuaJLlLuXtK8Kx1Oj2ff+DwG4R8BwuuW5STC51Wi2ln2Er6scOXEA75qOYHLHAwnO
         ruIGXzl/OY9kDhjG3/WkT2MzjLGM6Jn8FC2vKXncwaBWlSuP323Bs4QoWOMs1z9vwFfe
         KO1fpBxSREjtts1qbPkIlGHYrLY74ui+IaG3//3EPRUm9i7GUgHiCb9qUFbxnPbp3bzR
         0o1clVkFkw5SoxPNIO74G1GeC5yBWzgXrFfy0GoWDSvdnU0rP8cHBccYLGzMAyDxfTtb
         o5EVFBUgnD6ZMclGrfxFgBgKtySuIJwzoPlGVeFpb3lDiXHch408KJigmLW16ndBAHOI
         wmWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x68JNUu4zQNAYnVJBqT71y3SJaZIEALyvIGW4hRW+sE=;
        b=3zbCKaBVv+0Df4L4wW11DJxev210OlfqhFoTD9/JszrU3H0MqfaAGyI2oeL+v+0sTZ
         nmpq3J0Q2fDrDx1P1Qg5wleZgU1RABau69EuI7VltfbZK834qjGSR0X5eJF4Ep0BYblW
         q0wm+/+yW7n4UbhXfDTnD+9xPWxGaEDGQXz9ZHqCYBiNzd9rpA/pE+Mi/kbIHJK/UgzE
         2oRpRhKf1IIMqFslH7Ja6G5F11vT5mGAstrghgX2eqOIbwpOKKNH/ayTBrisQqwVuSDo
         A929Ruoi0jsrck7ndSMORCSll8fWzGx5tMV9g4AzP6zJZioNGJLkMPcrEeVoglGLA5J+
         fMHQ==
X-Gm-Message-State: AOAM5318w1BtELtW0wOnlzOUy6cFYA2C8lz48orlTvjTOGceJPbTNjJ4
        6WMlYwbeVVIBTk/C/umCtRcOLPNdaLR1D2BSooo=
X-Google-Smtp-Source: ABdhPJyjyZol9yXDYAO8s5AA9nnCRQurH9Ps0frU8Pps4kfKuXnxs+1x+XiW0wqGOxiVvdupu9dWrK6zOiJv8XUuIWE=
X-Received: by 2002:a05:6808:10c9:: with SMTP id s9mr2204939ois.23.1640278650671;
 Thu, 23 Dec 2021 08:57:30 -0800 (PST)
MIME-Version: 1.0
References: <fc90434665ed92ac9e02cd6e5a9d7e64816b0847.1640116312.git.lucien.xin@gmail.com>
 <20211222144050.6a13ac4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222144050.6a13ac4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 23 Dec 2021 11:57:19 -0500
Message-ID: <CADvbK_dxJ8_BTEJkDDX_M-FkLrjFnMfSDhBe_8ZseWrG+2agBw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: use call_rcu to free endpoint
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        davem <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 5:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Dec 2021 14:51:52 -0500 Xin Long wrote:
> > This patch is to delay the endpoint free by calling call_rcu() to fix
> > another use-after-free issue in sctp_sock_dump():
> >
> >   BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
> >   Call Trace:
> >     __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
> >     lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
> >     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
> >     _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
> >     spin_lock_bh include/linux/spinlock.h:334 [inline]
> >     __lock_sock+0x203/0x350 net/core/sock.c:2253
> >     lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
> >     lock_sock include/net/sock.h:1492 [inline]
> >     sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
> >     sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
> >     sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
> >     __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
> >     inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
> >     netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
> >     __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
> >     netlink_dump_start include/linux/netlink.h:216 [inline]
> >     inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
> >     __sock_diag_cmd net/core/sock_diag.c:232 [inline]
> >     sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
> >     netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
> >     sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274
> >
> > This issue occurs when asoc is peeled off and the old sk is freed after
> > getting sk by asoc->base.sk and before calling lock_sock(sk).
> >
> > To prevent the ep/sk free, this patch is to call call_rcu to free the ep
> > and hold it under rcu_read_lock to make sure that sk in sctp_sock_dump
> > is still alive when calling lock_sock().
>
> Could you clarify a little more where the RCU lock is held, it's not
> obvious.
sure, will do.

>
> > Note that delaying endpint free won't delay the port release, as the port
> > release happens in sctp_endpoint_destroy() before calling call_rcu().
> > Also, freeing endpoint by call_rcu() makes it safe to access the sk by
> > asoc->base.sk in sctp_assocs_seq_show() and sctp_rcv().
> >
> > Thanks Jones to bring this issue up.
> >
> > Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
> > Reported-by: Lee Jones <lee.jones@linaro.org>
> > Fixes: d25adbeb0cdb ("sctp: fix an use-after-free issue in sctp_sock_dump")
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> > diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> > index 48c9c2c7602f..81fb97d382d7 100644
> > --- a/net/sctp/endpointola.c
> > +++ b/net/sctp/endpointola.c
> > @@ -184,6 +184,17 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
> >  }
> >
> >  /* Final destructor for endpoint.  */
> > +static void sctp_endpoint_destroy_rcu(struct rcu_head *head)
> > +{
> > +     struct sctp_endpoint *ep = container_of(head, struct sctp_endpoint, rcu);
> > +     struct sock *sk = ep->base.sk;
> > +
> > +     sctp_sk(sk)->ep = NULL;
> > +     sock_put(sk);
> > +
> > +     SCTP_DBG_OBJCNT_DEC(ep);
> > +}
> > +
> >  static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
> >  {
> >       struct sock *sk;
> > @@ -213,18 +224,13 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
> >       if (sctp_sk(sk)->bind_hash)
> >               sctp_put_port(sk);
> >
> > -     sctp_sk(sk)->ep = NULL;
> > -     /* Give up our hold on the sock */
> > -     sock_put(sk);
> > -
> > -     kfree(ep);
>
> where does this kfree() go after the change?
Good catch, somehow I didn't move it into sctp_endpoint_destroy_rcu().
will post v2.

Thanks!

>
> > -     SCTP_DBG_OBJCNT_DEC(ep);
> > +     call_rcu(&ep->rcu, sctp_endpoint_destroy_rcu);
> >  }
