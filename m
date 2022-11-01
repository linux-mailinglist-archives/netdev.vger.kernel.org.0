Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C3D6143D9
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 05:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiKAES6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 00:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKAES5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 00:18:57 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07DB261E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 21:18:54 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3691e040abaso126313207b3.9
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 21:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VUF/Qmx+rY4ofAPzgC56XwikLetS3QY1PsVELjQFfWc=;
        b=jJeOWea2O2jCBFxm14UjC+3QO6Ivge2VhWN5bkuwdQzXe0ymYGA2JomSFMH+ydXLYn
         4ERzA1oBo7uus+nhiJYSDddTkilTOVt+/nlQjTidUcDniVv+Vnxfgabkgtiio9g2Cstp
         +aD68b6x4orlUQEktlCwzCC02AFAszhyTjHbd+GTZ7uP7dgDRXLonxS90UKjFyyWqCJX
         3H42o2k+oJGEGaqhGNArqO3mjYRiJCVrM3UV9I3NAuDhObEnkmMh8i6AeQZDkQiLer3G
         MlAD2MsuDZY/AOMFJavachvYwJyXWKlcVvhqy5Irp323lEropYXOVMi6ZrQa/VYtj6SN
         9BMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VUF/Qmx+rY4ofAPzgC56XwikLetS3QY1PsVELjQFfWc=;
        b=FD+BelDB25QXPBo7vXmyHWCfT9yKCVs/eaSrl5f/gFd47UifTSM82GgognW25CkWnT
         gJuCvvAljkreqJsCsXKhNH04Gkrsk0aKE/NeemClbUYa+TINyO3NCzHpjp/nHl4ZJDUa
         6b5nPbffL0JaOpaN5XGw9fzh0dy4y7RhrLrTveP5orPyu3bZo3Xtr2Zu2P5w704jLfUR
         Vt1q0yIpPHm/vH+nird2Pbfwf5hoFSFaCk0OGfnDTiOaYRKggYB4zrzCb0qr3onexaK+
         0VnUBXGsiqyVndw5kRMiQmYriy/HgQLq1O2n2x4ty0OInLPivOo5kSGJWCZw92Aj5Zg+
         5C5A==
X-Gm-Message-State: ACrzQf09DpuUGuD5T2gNKiGBgbXCbou16mwQtVQ1d3IX2u5PQ1aadaPA
        9o2LeczuxzR/7fE7pFusWmxMewteDNZv4HwilSWTKg==
X-Google-Smtp-Source: AMsMyM4ojU+XWvO+rtNnk94QNrBQnjyRV7ORoG0+sJ4q9/sFkh1g3EC+co53Wshjba9GS9MHbbguBwoWtz4a63XqveY=
X-Received: by 2002:a81:1dce:0:b0:34c:e500:b95b with SMTP id
 d197-20020a811dce000000b0034ce500b95bmr16059781ywd.109.1667276333697; Mon, 31
 Oct 2022 21:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221101035234.3910189-1-edumazet@google.com>
In-Reply-To: <20221101035234.3910189-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Tue, 1 Nov 2022 00:18:17 -0400
Message-ID: <CACSApvZY9FrC481k76HydWbhYYVpky-Ys51zR0pbt6BXtvZk0Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: refine tcp_prune_ofo_queue() logic
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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

On Mon, Oct 31, 2022 at 11:52 PM Eric Dumazet <edumazet@google.com> wrote:
>
> After commits 36a6503fedda ("tcp: refine tcp_prune_ofo_queue()
> to not drop all packets") and 72cd43ba64fc1
> ("tcp: free batches of packets in tcp_prune_ofo_queue()")
> tcp_prune_ofo_queue() drops a fraction of ooo queue,
> to make room for incoming packet.
>
> However it makes no sense to drop packets that are
> before the incoming packet, in sequence space.
>
> In order to recover from packet losses faster,
> it makes more sense to only drop ooo packets
> which are after the incoming packet.
>
> Tested:
> packetdrill test:
>    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [3800], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
>
>    +0 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 0>
>   +.1 < . 1:1(0) ack 1 win 1024
>    +0 accept(3, ..., ...) = 4
>
>  +.01 < . 200:300(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 200:300>
>
>  +.01 < . 400:500(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 400:500 200:300>
>
>  +.01 < . 600:700(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 600:700 400:500 200:300>
>
>  +.01 < . 800:900(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 800:900 600:700 400:500 200:300>
>
>  +.01 < . 1000:1100(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 1000:1100 800:900 600:700 400:500>
>
>  +.01 < . 1200:1300(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
>
> // this packet is dropped because we have no room left.
>  +.01 < . 1400:1500(100) ack 1 win 1024
>
>  +.01 < . 1:200(199) ack 1 win 1024
> // Make sure kernel did not drop 200:300 sequence
>    +0 > . 1:1(0) ack 300 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
> // Make room, since our RCVBUF is very small
>    +0 read(4, ..., 299) = 299
>
>  +.01 < . 300:400(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 500 <nop,nop, sack 1200:1300 1000:1100 800:900 600:700>
>
>  +.01 < . 500:600(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 700 <nop,nop, sack 1200:1300 1000:1100 800:900>
>
>    +0 read(4, ..., 400) = 400
>
>  +.01 < . 700:800(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 900 <nop,nop, sack 1200:1300 1000:1100>
>
>  +.01 < . 900:1000(100) ack 1 win 1024
>    +0 > . 1:1(0) ack 1100 <nop,nop, sack 1200:1300>
>
>  +.01 < . 1100:1200(100) ack 1 win 1024
> // This checks that 1200:1300 has not been removed from ooo queue
>    +0 > . 1:1(0) ack 1300
>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice idea! It should lower tail latency on highly congested
links. Thank you Eric!

> ---
>  net/ipv4/tcp_input.c | 51 +++++++++++++++++++++++++++-----------------
>  1 file changed, 31 insertions(+), 20 deletions(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 0640453fce54b6daae0861d948f3db075830daf6..d764b5854dfcc865207b5eb749c29013ef18bdbc 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4764,8 +4764,8 @@ static void tcp_ofo_queue(struct sock *sk)
>         }
>  }
>
> -static bool tcp_prune_ofo_queue(struct sock *sk);
> -static int tcp_prune_queue(struct sock *sk);
> +static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb);
> +static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb);
>
>  static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
>                                  unsigned int size)
> @@ -4773,11 +4773,11 @@ static int tcp_try_rmem_schedule(struct sock *sk, struct sk_buff *skb,
>         if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
>             !sk_rmem_schedule(sk, skb, size)) {
>
> -               if (tcp_prune_queue(sk) < 0)
> +               if (tcp_prune_queue(sk, skb) < 0)
>                         return -1;
>
>                 while (!sk_rmem_schedule(sk, skb, size)) {
> -                       if (!tcp_prune_ofo_queue(sk))
> +                       if (!tcp_prune_ofo_queue(sk, skb))
>                                 return -1;
>                 }
>         }
> @@ -5329,6 +5329,8 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
>   * Clean the out-of-order queue to make room.
>   * We drop high sequences packets to :
>   * 1) Let a chance for holes to be filled.
> + *    This means we do not drop packets from ooo queue if their sequence
> + *    is before incoming packet sequence.
>   * 2) not add too big latencies if thousands of packets sit there.
>   *    (But if application shrinks SO_RCVBUF, we could still end up
>   *     freeing whole queue here)
> @@ -5336,24 +5338,31 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
>   *
>   * Return true if queue has shrunk.
>   */
> -static bool tcp_prune_ofo_queue(struct sock *sk)
> +static bool tcp_prune_ofo_queue(struct sock *sk, const struct sk_buff *in_skb)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>         struct rb_node *node, *prev;
> +       bool pruned = false;
>         int goal;
>
>         if (RB_EMPTY_ROOT(&tp->out_of_order_queue))
>                 return false;
>
> -       NET_INC_STATS(sock_net(sk), LINUX_MIB_OFOPRUNED);
>         goal = sk->sk_rcvbuf >> 3;
>         node = &tp->ooo_last_skb->rbnode;
> +
>         do {
> +               struct sk_buff *skb = rb_to_skb(node);
> +
> +               /* If incoming skb would land last in ofo queue, stop pruning. */
> +               if (after(TCP_SKB_CB(in_skb)->seq, TCP_SKB_CB(skb)->seq))
> +                       break;
> +               pruned = true;
>                 prev = rb_prev(node);
>                 rb_erase(node, &tp->out_of_order_queue);
> -               goal -= rb_to_skb(node)->truesize;
> -               tcp_drop_reason(sk, rb_to_skb(node),
> -                               SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
> +               goal -= skb->truesize;
> +               tcp_drop_reason(sk, skb, SKB_DROP_REASON_TCP_OFO_QUEUE_PRUNE);
> +               tp->ooo_last_skb = rb_to_skb(prev);
>                 if (!prev || goal <= 0) {
>                         if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
>                             !tcp_under_memory_pressure(sk))
> @@ -5362,16 +5371,18 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
>                 }
>                 node = prev;
>         } while (node);
> -       tp->ooo_last_skb = rb_to_skb(prev);
>
> -       /* Reset SACK state.  A conforming SACK implementation will
> -        * do the same at a timeout based retransmit.  When a connection
> -        * is in a sad state like this, we care only about integrity
> -        * of the connection not performance.
> -        */
> -       if (tp->rx_opt.sack_ok)
> -               tcp_sack_reset(&tp->rx_opt);
> -       return true;
> +       if (pruned) {
> +               NET_INC_STATS(sock_net(sk), LINUX_MIB_OFOPRUNED);
> +               /* Reset SACK state.  A conforming SACK implementation will
> +                * do the same at a timeout based retransmit.  When a connection
> +                * is in a sad state like this, we care only about integrity
> +                * of the connection not performance.
> +                */
> +               if (tp->rx_opt.sack_ok)
> +                       tcp_sack_reset(&tp->rx_opt);
> +       }
> +       return pruned;
>  }
>
>  /* Reduce allocated memory if we can, trying to get
> @@ -5381,7 +5392,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
>   * until the socket owning process reads some of the data
>   * to stabilize the situation.
>   */
> -static int tcp_prune_queue(struct sock *sk)
> +static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb)
>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>
> @@ -5408,7 +5419,7 @@ static int tcp_prune_queue(struct sock *sk)
>         /* Collapsing did not help, destructive actions follow.
>          * This must not ever occur. */
>
> -       tcp_prune_ofo_queue(sk);
> +       tcp_prune_ofo_queue(sk, in_skb);
>
>         if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
>                 return 0;
> --
> 2.38.1.273.g43a17bfeac-goog
>
