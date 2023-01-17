Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38D666D78B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbjAQIIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbjAQIIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:08:37 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101ED9EF9
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:08:36 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-4c24993965eso405546187b3.12
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 00:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qim6kbiGsHAbB/p2ZKCIXyw1Tj3bOAmrl/He/UIR4ng=;
        b=S6O8v0MrEZYEgNEzCCK3maXPUG+zjlsmgSFD9ufvMcI2C5xUCoSxRaMTX4BpfhpAOQ
         ZJW1mFOL9dTs6ttcvHT4FIzm7+0gYJv9b4541xBakWezkd+MSYf/BKZMfdeT04jMxIRg
         TieIgYiO+/y4IaLQfwAXZJkSR6rtBIaoB3LgqmdZOxAx8HLLIBwLhgA1CR/in1fYb0IH
         UN9e5C5TqAoJk3cDLtg+7tmm878LdYqCn2L4RcOIj6wtHIXsWOGj3NFSijz7w1eTw2u9
         yBo6HV8zAlku1D77dWin1Ji3D6tM5wN/Y8JlvvsBOgL6Za66+4LWj8IYL5mFhyd7rEet
         yUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qim6kbiGsHAbB/p2ZKCIXyw1Tj3bOAmrl/He/UIR4ng=;
        b=mXeTbM9qhFck5Qd+uGZ03IrcSdzir4Yzx45AWhWeL7G8NIANnyIBuJ0mfn5YCL+8Br
         YGhn6pPMR6DXWuBo3dncoI+hz//zN8hREOzxhj/6rMs/1/87L5CMu7f3ba9Rd93T+dBY
         ksgCu75BnDvGpvjQ7PBZA/Yv2jy6S1b0vaEXRAoiZExu50pwyQle66yVkhH06qBz1BzS
         tDPhLP+qpHv7jtprp2aQQZv0gK+p0UqDuUWSSJ0TysatRB66uAfUvhdYa/D+1mafGbm1
         uM3frUH3dLWqEbF3k7WwFjDTKKXBke99dBhnn4TWtvWPdNneP626auUD3+z2O7MB9qhV
         JaMw==
X-Gm-Message-State: AFqh2krKHSFa+V2Z+aC9PMyh8bj26c6NTYteLhWw+kk0DYyiGzfJbKLX
        7Iy504+TRU8UzdW4VOVPmpLL04J9mkfYd+tuwj7Jgw==
X-Google-Smtp-Source: AMrXdXteW1RcuGUT44uzyinnVUX6x+Qdfyf2PpQf6w6deDuFKRypII0t2euEcp44+WZTmrwRwEKfTtZ3YPeNpWBYNlY=
X-Received: by 2002:a81:6e46:0:b0:37e:6806:a5f9 with SMTP id
 j67-20020a816e46000000b0037e6806a5f9mr298269ywc.47.1673942915016; Tue, 17 Jan
 2023 00:08:35 -0800 (PST)
MIME-Version: 1.0
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com> <20230114030137.672706-3-xiyou.wangcong@gmail.com>
In-Reply-To: <20230114030137.672706-3-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 17 Jan 2023 09:08:23 +0100
Message-ID: <CANn89i+scj506yqh4YYAf5PQspbpqxym+YDiaXZTPaODM4_ANA@mail.gmail.com>
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

On Sat, Jan 14, 2023 at 4:01 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> The code in l2tp_tunnel_register() is racy in several ways:
>
> 1. It modifies the tunnel socket _after_ publishing it.
>
> 2. It calls setup_udp_tunnel_sock() on an existing socket without
>    locking.
>
> 3. It changes sock lock class on fly, which triggers many syzbot
>    reports.
>
> This patch amends all of them by moving socket initialization code
> before publishing and under sock lock. As suggested by Jakub, the
> l2tp lockdep class is not necessary as we can just switch to
> bh_lock_sock_nested().
>
> Fixes: 37159ef2c1ae ("l2tp: fix a lockdep splat")
> Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
> Reported-by: syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com
> Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
> Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Guillaume Nault <gnault@redhat.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Tom Parkin <tparkin@katalix.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/l2tp/l2tp_core.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index e9c0ce0b7972..b6554e32bb12 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1041,7 +1041,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
>         IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED | IPSKB_REROUTED);
>         nf_reset_ct(skb);
>
> -       bh_lock_sock(sk);
> +       bh_lock_sock_nested(sk);
>         if (sock_owned_by_user(sk)) {
>                 kfree_skb(skb);
>                 ret = NET_XMIT_DROP;
> @@ -1385,8 +1385,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
>         return err;
>  }
>
> -static struct lock_class_key l2tp_socket_class;
> -
>  int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
>                        struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
>  {
> @@ -1482,21 +1480,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>         }
>
>         sk = sock->sk;
> +       lock_sock(sk);
>         write_lock_bh(&sk->sk_callback_lock);
>         ret = l2tp_validate_socket(sk, net, tunnel->encap);
> -       if (ret < 0)
> +       if (ret < 0) {

I think we need to write_unlock_bh(&sk->sk_callback_lock)
before release_sock(), or risk lockdep reports.



> +               release_sock(sk);
>                 goto err_inval_sock;
> +       }
>         rcu_assign_sk_user_data(sk, tunnel);
>         write_unlock_bh(&sk->sk_callback_lock);
>
> -       sock_hold(sk);
> -       tunnel->sock = sk;
> -       tunnel->l2tp_net = net;
> -
> -       spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> -       idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
> -       spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
> -
>         if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
>                 struct udp_tunnel_sock_cfg udp_cfg = {
>                         .sk_user_data = tunnel,
> @@ -1510,9 +1503,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>
>         tunnel->old_sk_destruct = sk->sk_destruct;
>         sk->sk_destruct = &l2tp_tunnel_destruct;
> -       lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
> -                                  "l2tp_sock");
>         sk->sk_allocation = GFP_ATOMIC;
> +       release_sock(sk);
> +
> +       sock_hold(sk);
> +       tunnel->sock = sk;
> +       tunnel->l2tp_net = net;
> +
> +       spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
> +       idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
> +       spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
>
>         trace_register_tunnel(tunnel);
>
> --
> 2.34.1
>
