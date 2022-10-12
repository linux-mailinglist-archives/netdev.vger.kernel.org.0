Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DFF5FC957
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 18:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJLQcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 12:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJLQb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 12:31:58 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF651B9D8
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:31:57 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 126so20625368ybw.3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+BbB7PM9hnNtO80/Dn2EefYTDUKTIFo/3oAljBeXmEc=;
        b=HcgV90oPy72IClq9m/mdhIC2EgYa23647/vXiDgyB9SLusaacBrii1cg2Sdzs+EFCu
         VDl8OkBnvu3SwiWWjyu/hBH1fwYG3Dv82zYp2dsnPxjBPJuv8Hfe6BwQG4GFNeydJdGl
         NnLV6VLJR9baUkArru1n8hauwMheZkHRlTfeMH5RkmRUj5GtUzE+FrBjCXbzsWCAIzQP
         wCmVxTN3Cnw/AKn01YBP3M5qyL46WhlUr9CW+rbOx7US3F33ENF9abSt5DJraAMGULsV
         Y9UBklyKEqRx69OUC5LLYx6ul/MuUfxJaOV3rSpE6feVcFNRp/M9ElXOq4OFocJ+h9ce
         68pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BbB7PM9hnNtO80/Dn2EefYTDUKTIFo/3oAljBeXmEc=;
        b=xH4uYO1/dLzQX36xxPu9klRu4PJ7gwzOH67FJBslWhK0praUwUVygwbocPzyvW3eE4
         gO3wk6gk3wexiW/HGd6IxURYHF60Q3Mb0ddo6AGoYNg7g131bcwKWkhDq9Pv/M5/osK2
         LcoaRTiwSWGRttPPaGesf4pW5lb4nzGsjhxQ4HceMKIUjYLj1YbL/FuOSIyn2O9zUKok
         DJFDeA5Ng/3IZ+d7IoLhJGBaMaY+r2tnzzszyl56KNCk17AZ9nRPL88rb3f9ZTuIcaFS
         6y3LogJxzNxxXAvkbAlO8YEOZwNKSD9tKzh7RaiJ6ESxrZu9D36A+Cqr7D3RQ7dXpmE3
         DpMg==
X-Gm-Message-State: ACrzQf0nqb7lakTeps0yCEXD/dp5GOvlX6biXIP0JryoU+ALxTHYybc1
        gxhhNS+gOYbzT437D69vnFiW4udlpS57HLOW1nAGLw==
X-Google-Smtp-Source: AMsMyM6dkiTI5DF73nJuGUGAe1xwxuaSeDSNi9zhtvpiEf91hd96wtZi7i05dayhTg8uDVPu1tjTlRyeKiLN95k5PQo=
X-Received: by 2002:a25:328c:0:b0:6be:2d4a:e77 with SMTP id
 y134-20020a25328c000000b006be2d4a0e77mr27903592yby.407.1665592316408; Wed, 12
 Oct 2022 09:31:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221012145036.74960-1-kuniyu@amazon.com>
In-Reply-To: <20221012145036.74960-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Oct 2022 09:31:44 -0700
Message-ID: <CANn89iJYF6S3XcfnxNcsPMjhFXz1naokJ+tLM1jSjjR6uco9bw@mail.gmail.com>
Subject: Re: [PATCH v1 net] tcp: Clean up kernel listener's reqsk in inet_twsk_purge()
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
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

On Wed, Oct 12, 2022 at 7:51 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Eric Dumazet reported a use-after-free related to the per-netns ehash
> series. [0]
>
> When we create a TCP socket from userspace, the socket always holds a
> refcnt of the netns.  This guarantees that a reqsk timer is always fired
> before netns dismantle.  Each reqsk has a refcnt of its listener, so the
> listener is not freed before the reqsk, and the net is not freed before
> the listener as well.
>
> OTOH, when in-kernel users create a TCP socket, it might not hold a refcnt
> of its netns.  Thus, a reqsk timer can be fired after the netns dismantle
> and access freed per-netns ehash.

Patch seems good, but changelog is incorrect.

1) we have a TCP listener (or more) on a netns
2) We receive SYN packets, creating SYN_RECV request sockets, added in
ehash table.
3) job is killed, TCP listener closed.
4) When a TCP listener is closed, we do not purge all SYN_RECV
requests sockets, because we rely
   on normal per-request timer firing, then finding the listener is no
longer in LISTEN state -> drop the request socket.
   (We do not maintain a per-listener list of request sockets, and
going through ehash would be quite expensive on busy servers)
5) netns is deleted (and optional TCP ehashinfo freed)
6) request socket timer fire, and wecrash while trying to unlink the
request socket from the freed ehash table.

In short, I think the case could happen with normal TCP sockets,
allocated from user space.

>
> To avoid the use-after-free, we need to clean up TCP_NEW_SYN_RECV sockets
> in inet_twsk_purge() if the netns uses a per-netns ehash.
>
> [0]: https://lore.kernel.org/netdev/CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com/
>
> BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
> include/net/inet_hashtables.h:181 [inline]
> BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
> net/ipv4/inet_connection_sock.c:913
> Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301
>
> CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
> 6.0.0-syzkaller-02757-gaf7d23f9d96a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 09/22/2022
> Call Trace:
> <IRQ>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:317 [inline]
> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
> tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
> reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
> inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
> inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
> reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
> call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
> expire_timers kernel/time/timer.c:1519 [inline]
> __run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
> __run_timers kernel/time/timer.c:1768 [inline]
> run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
> __do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
> invoke_softirq kernel/softirq.c:445 [inline]
> __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
> irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
> sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
> </IRQ>
>
> Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/inet_timewait_sock.c | 15 ++++++++++++++-
>  net/ipv4/tcp_minisocks.c      |  9 +++++----
>  2 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index 71d3bb0abf6c..66fc940f9521 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -268,8 +268,21 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo, int family)
>                 rcu_read_lock();
>  restart:
>                 sk_nulls_for_each_rcu(sk, node, &head->chain) {
> -                       if (sk->sk_state != TCP_TIME_WAIT)
> +                       if (sk->sk_state != TCP_TIME_WAIT) {
> +                               /* A kernel listener socket might not hold refcnt for net,
> +                                * so reqsk_timer_handler() could be fired after net is
> +                                * freed.  Userspace listener and reqsk never exist here.
> +                                */
> +                               if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
> +                                            hashinfo->pernet)) {
> +                                       struct request_sock *req = inet_reqsk(sk);
> +
> +                                       inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
> +                               }
> +
>                                 continue;
> +                       }
> +
>                         tw = inet_twsk(sk);
>                         if ((tw->tw_family != family) ||
>                                 refcount_read(&twsk_net(tw)->ns.count))
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 79f30f026d89..c375f603a16c 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -353,13 +353,14 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family)
>         struct net *net;
>
>         list_for_each_entry(net, net_exit_list, exit_list) {
> -               /* The last refcount is decremented in tcp_sk_exit_batch() */
> -               if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
> -                       continue;
> -
>                 if (net->ipv4.tcp_death_row.hashinfo->pernet) {
> +                       /* Even if tw_refcount == 1, we must clean up kernel reqsk */
>                         inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo, family);
>                 } else if (!purged_once) {
> +                       /* The last refcount is decremented in tcp_sk_exit_batch() */
> +                       if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
> +                               continue;
> +
>                         inet_twsk_purge(&tcp_hashinfo, family);
>                         purged_once = true;
>                 }
> --
> 2.30.2
>
