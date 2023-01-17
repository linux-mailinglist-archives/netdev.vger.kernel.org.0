Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C486866D7A0
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbjAQIKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbjAQIKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:10:34 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B051B21952
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:10:32 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id c124so32999322ybb.13
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k6xMhlAAkrehljV4vsrHaLx/UZ6dm8dE67nLbG3/2rQ=;
        b=iGP4JrW2NkFzLX99gIe7LEdD05adTh5k1leAihSso7Co24qslKZ6gHL9k6sthjVI1N
         w4xcxZvMhBtZPf4DUqiFVDDocn1F5HbIFcwGEKVqGeUpBN6QcM0Xnn4uAy9smBkwV82o
         nwq3dnH24ebBn9lroJNXpRHjeNnZ/7icPZ9Z+JeR4U0RpcAPzZMG/kZffb5r5HddXEUl
         rPjZxbb28Tf8iXHe2kMOyPR+QeUyZCVnbravxehnd6ahZe2QooOgEuPHNeCFdyow6uPb
         p4XxVo/kznjlX42qEEZWjkSRP6TDlcKmNyLeOFZ+JRrewVp6mpg2HM5lIXT6/5I74LKE
         BH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6xMhlAAkrehljV4vsrHaLx/UZ6dm8dE67nLbG3/2rQ=;
        b=fPSjA8ClUme+1c7W1USjTGZmme3OdH1GnqDYRdaPhpCFE8Ejxoiap4AKMNV/vhUvdH
         0NMmROJLtx0yaypERiQjV+qnVheuxL708xCtBBXVuDLrsieY4XVDQ3vr9tFhTklAFOYw
         qbLX65z9V0z6tvgw4PHhA9YKPpcnppdEdQ2C4JZcUs8xMFknsjfnmqb+GuGhm94Z72Jy
         EQTM39n4GfN5swaVQd0CRz3qeDEFsB0IEy7B2qXExslSpVYkuUL5GN8sk97YfXelTVw5
         rvLFLZIwb8UCFzopTrPm44XKv/ZtwnhnWlGvyi4es6GZv4PbvimkIWmbtL5+VvrfQB6K
         8htg==
X-Gm-Message-State: AFqh2kpJ5DtS+lMQd+j7pBn9ZoFisA8UZAL6v9tlY0fth/bsfBVSqlAX
        k7xssRvrvWL/4JaFuM4yEC0iU+yodsdzIeSUynG7aw==
X-Google-Smtp-Source: AMrXdXuE+DtPVUKhhhTOF4GpD7IYNYJBkLlYUbLK1bu9doPdSohiW9he8X1pCIAqSePDuW4lEN8mMVVQBUjnJCqa8Qk=
X-Received: by 2002:a25:bf8e:0:b0:7d7:ec44:7cdc with SMTP id
 l14-20020a25bf8e000000b007d7ec447cdcmr321408ybk.598.1673943031673; Tue, 17
 Jan 2023 00:10:31 -0800 (PST)
MIME-Version: 1.0
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
 <20230114030137.672706-3-xiyou.wangcong@gmail.com> <CANn89i+scj506yqh4YYAf5PQspbpqxym+YDiaXZTPaODM4_ANA@mail.gmail.com>
In-Reply-To: <CANn89i+scj506yqh4YYAf5PQspbpqxym+YDiaXZTPaODM4_ANA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 17 Jan 2023 09:10:20 +0100
Message-ID: <CANn89iJ1FZvtyHgXC69YEVirg0B5moKM1eDLSU1skLQV0PNrGw@mail.gmail.com>
Subject: Re: [Patch net v3 2/2] l2tp: close all race conditions in l2tp_tunnel_register()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, gnault@redhat.com,
        tparkin@katalix.com, Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>
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

On Tue, Jan 17, 2023 at 9:08 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Jan 14, 2023 at 4:01 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > The code in l2tp_tunnel_register() is racy in several ways:
> >
> > 1. It modifies the tunnel socket _after_ publishing it.
> >
> > 2. It calls setup_udp_tunnel_sock() on an existing socket without
> >    locking.
> >
> > 3. It changes sock lock class on fly, which triggers many syzbot
> >    reports.
> >
> > This patch amends all of them by moving socket initialization code
> > before publishing and under sock lock. As suggested by Jakub, the
> > l2tp lockdep class is not necessary as we can just switch to
> > bh_lock_sock_nested().
> >
> > Fixes: 37159ef2c1ae ("l2tp: fix a lockdep splat")
> > Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
> > Reported-by: syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com
> > Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: Guillaume Nault <gnault@redhat.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Tom Parkin <tparkin@katalix.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/l2tp/l2tp_core.c | 28 ++++++++++++++--------------
> >  1 file changed, 14 insertions(+), 14 deletions(-)
> >
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index e9c0ce0b7972..b6554e32bb12 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> > @@ -1041,7 +1041,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
> >         IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED | IPSKB_REROUTED);
> >         nf_reset_ct(skb);
> >
> > -       bh_lock_sock(sk);
> > +       bh_lock_sock_nested(sk);
> >         if (sock_owned_by_user(sk)) {
> >                 kfree_skb(skb);
> >                 ret = NET_XMIT_DROP;
> > @@ -1385,8 +1385,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
> >         return err;
> >  }
> >
> > -static struct lock_class_key l2tp_socket_class;
> > -
> >  int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
> >                        struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
> >  {
> > @@ -1482,21 +1480,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
> >         }
> >
> >         sk = sock->sk;
> > +       lock_sock(sk);
> >         write_lock_bh(&sk->sk_callback_lock);
> >         ret = l2tp_validate_socket(sk, net, tunnel->encap);
> > -       if (ret < 0)
> > +       if (ret < 0) {
>
> I think we need to write_unlock_bh(&sk->sk_callback_lock)
> before release_sock(), or risk lockdep reports.
>

Any objection if I propose :

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index b6554e32bb12ae7813cc06c01e4d1380af667375..03608d3ded4b83d1e59e064e482f54cffcdf5240
100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1483,10 +1483,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,
        lock_sock(sk);
        write_lock_bh(&sk->sk_callback_lock);
        ret = l2tp_validate_socket(sk, net, tunnel->encap);
-       if (ret < 0) {
-               release_sock(sk);
+       if (ret < 0)
                goto err_inval_sock;
-       }
        rcu_assign_sk_user_data(sk, tunnel);
        write_unlock_bh(&sk->sk_callback_lock);

@@ -1523,6 +1521,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
*tunnel, struct net *net,

 err_inval_sock:
        write_unlock_bh(&sk->sk_callback_lock);
+       release_sock(sk);

        if (tunnel->fd < 0)
                sock_release(sock);
