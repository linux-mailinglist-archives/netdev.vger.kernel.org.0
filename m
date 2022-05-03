Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA03517B20
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 02:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiECAG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 20:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiECAFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 20:05:51 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7119C340CD
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 17:02:20 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ef5380669cso164880617b3.9
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 17:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zmqp+Ft/zwvr/6XNHzx2dgjoZyo15357vIqJ54QbeHA=;
        b=FZ+KcB9iEqqwL90YKZUo772ZoUj9XXSAm9P4FOwDoJXmA8uAPjiE8Rc/DEq5/8k3O9
         iXXELsU5iHCsDLVmv/3Q6qjNsJlqgd1TfkwMOqJO3XmU2haOnU5OY+VgVNP6QQIh7hDD
         3c9W+gbBshGo6H7JdXQ3Ny1CIIok1+LSaaSI9nYlhn6vst8wz3hy+fdN+NQmjlW9xCfy
         5xW8i8DhoqfI7eJ2q7A1t3kvSfi8ajiAIus38733zzyeZ+XpKNUeADHT7xnp39WiOthN
         WmIldhDEnEnHmKSkltBNutYuBK+6VKGAobwzurm13k76EFfccSDzep8MWJfClveNtFPl
         YStg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zmqp+Ft/zwvr/6XNHzx2dgjoZyo15357vIqJ54QbeHA=;
        b=PrgLHB3l6PefQcy4d3fk0XR31rufegDr1muRMsgVDXev6K5z09kzghQqUkdYggv8rf
         /RTpVx9M1PAwNPAOthk9MggP7I6vmtulUk4ym6rJd3urBf0CE2aAb2R0RE9ovmSMgYeV
         FEbYgtPy0x6YsdbzIOxUeokmT3kQJoJinmbOIvssQCauJYbM9pMIbG4LEJuUjFYOoskx
         RSURhcVOnzspPrGWzejqOWFRnVd58R0dZstHpiWzLPGUczZeJNS98nyK4E5vbyCys0NF
         ycS11gkShlKIHZqUIyQpow8b3BxXl66sdGoiq174QJ9BUrTAjV8pwJdbjJ2LP/z75Oth
         EGmA==
X-Gm-Message-State: AOAM532t5tEFJttNbebetBYjRd5AvjxAOw+4MPTlNxQ4u/2+0h7FkrSr
        ftUqEOZl0JRhVJygl6G5X4vQPHHVeE3OQ8ivyogWjg==
X-Google-Smtp-Source: ABdhPJyRo7mWvjoH/vNqWXpdMy1k84mIgj6ZGRiuT5JyS+SJPkkLuo7YBmZ4s8l8oj5KMTVw1+1Vp6nJTwYlrkdsspo=
X-Received: by 2002:a81:4f0c:0:b0:2f8:46f4:be90 with SMTP id
 d12-20020a814f0c000000b002f846f4be90mr13772455ywb.332.1651536139152; Mon, 02
 May 2022 17:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220502182345.306970-1-xiyou.wangcong@gmail.com> <20220502182345.306970-2-xiyou.wangcong@gmail.com>
In-Reply-To: <20220502182345.306970-2-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 2 May 2022 17:02:07 -0700
Message-ID: <CANn89i+fXaDBptNMYjUqKhAuZrRX7+0v7sv5DZqK4seLCzBO3A@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 1/4] tcp: introduce tcp_read_skb()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 2, 2022 at 11:24 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> a preparation for the next patch which actually introduces
> a new sock ops.
>
> TCP is special here, because it has tcp_read_sock() which is
> mainly used by splice(). tcp_read_sock() supports partial read
> and arbitrary offset, neither of them is needed for sockmap.
>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/tcp.h |  2 ++
>  net/ipv4/tcp.c    | 63 +++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 57 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 94a52ad1101c..ab7516e5cc56 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -667,6 +667,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
>  /* Read 'sendfile()'-style from a TCP socket */
>  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>                   sk_read_actor_t recv_actor);
> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +                sk_read_actor_t recv_actor);
>
>  void tcp_initialize_rcv_mss(struct sock *sk);
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index db55af9eb37b..8d48126e3694 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1600,7 +1600,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
>         __kfree_skb(skb);
>  }
>
> -static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
> +static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off, bool unlink)
>  {
>         struct sk_buff *skb;
>         u32 offset;
> @@ -1613,6 +1613,8 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
>                 }
>                 if (offset < skb->len || (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)) {
>                         *off = offset;
> +                       if (unlink)
> +                               __skb_unlink(skb, &sk->sk_receive_queue);

Why adding this @unlink parameter ?
This makes your patch more invasive than needed.
Can not this unlink happen from your new helper instead ? See [3] later.

>                         return skb;
>                 }
>                 /* This looks weird, but this can happen if TCP collapsing
> @@ -1646,7 +1648,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>
>         if (sk->sk_state == TCP_LISTEN)
>                 return -ENOTCONN;
> -       while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> +       while ((skb = tcp_recv_skb(sk, seq, &offset, false)) != NULL) {
>                 if (offset < skb->len) {
>                         int used;
>                         size_t len;
> @@ -1677,7 +1679,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>                          * getting here: tcp_collapse might have deleted it
>                          * while aggregating skbs from the socket queue.
>                          */
> -                       skb = tcp_recv_skb(sk, seq - 1, &offset);
> +                       skb = tcp_recv_skb(sk, seq - 1, &offset, false);
>                         if (!skb)
>                                 break;
>                         /* TCP coalescing might have appended data to the skb.
> @@ -1702,13 +1704,58 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>
>         /* Clean up data we have read: This will do ACK frames. */
>         if (copied > 0) {
> -               tcp_recv_skb(sk, seq, &offset);
> +               tcp_recv_skb(sk, seq, &offset, false);
>                 tcp_cleanup_rbuf(sk, copied);
>         }
>         return copied;
>  }
>  EXPORT_SYMBOL(tcp_read_sock);
>
> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +                sk_read_actor_t recv_actor)
> +{
> +       struct tcp_sock *tp = tcp_sk(sk);
> +       u32 seq = tp->copied_seq;
> +       struct sk_buff *skb;
> +       int copied = 0;
> +       u32 offset;
> +
> +       if (sk->sk_state == TCP_LISTEN)
> +               return -ENOTCONN;
> +
> +       while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {

[3]
            The unlink from sk->sk_receive_queue could happen here.

> +               int used = recv_actor(desc, skb, 0, skb->len);
> +
> +               if (used <= 0) {
> +                       if (!copied)
> +                               copied = used;
> +                       break;
> +               }
> +               seq += used;
> +               copied += used;
> +
> +               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> +                       kfree_skb(skb);

[1]

The two kfree_skb() ([1] & [2]) should be a consume_skb() ?

> +                       ++seq;
> +                       break;
> +               }
> +               kfree_skb(skb);

[2]


> +               if (!desc->count)
> +                       break;
> +               WRITE_ONCE(tp->copied_seq, seq);
> +       }
> +       WRITE_ONCE(tp->copied_seq, seq);
> +
> +       tcp_rcv_space_adjust(sk);
> +
> +       /* Clean up data we have read: This will do ACK frames. */
> +       if (copied > 0)
> +               tcp_cleanup_rbuf(sk, copied);
> +
> +       return copied;
> +}
> +EXPORT_SYMBOL(tcp_read_skb);
> +
>  int tcp_peek_len(struct socket *sock)
>  {
>         return tcp_inq(sock->sk);
> @@ -1890,7 +1937,7 @@ static int receive_fallback_to_copy(struct sock *sk,
>                 struct sk_buff *skb;
>                 u32 offset;
>
> -               skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset);
> +               skb = tcp_recv_skb(sk, tcp_sk(sk)->copied_seq, &offset, false);
>                 if (skb)
>                         tcp_zerocopy_set_hint_for_skb(sk, zc, skb, offset);
>         }
> @@ -1937,7 +1984,7 @@ static int tcp_zc_handle_leftover(struct tcp_zerocopy_receive *zc,
>         if (skb) {
>                 offset = *seq - TCP_SKB_CB(skb)->seq;
>         } else {
> -               skb = tcp_recv_skb(sk, *seq, &offset);
> +               skb = tcp_recv_skb(sk, *seq, &offset, false);
>                 if (TCP_SKB_CB(skb)->has_rxtstamp) {
>                         tcp_update_recv_tstamps(skb, tss);
>                         zc->msg_flags |= TCP_CMSG_TS;
> @@ -2130,7 +2177,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
>                                 skb = skb->next;
>                                 offset = seq - TCP_SKB_CB(skb)->seq;
>                         } else {
> -                               skb = tcp_recv_skb(sk, seq, &offset);
> +                               skb = tcp_recv_skb(sk, seq, &offset, false);
>                         }
>
>                         if (TCP_SKB_CB(skb)->has_rxtstamp) {
> @@ -2186,7 +2233,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
>                 tcp_rcv_space_adjust(sk);
>
>                 /* Clean up data we have read: This will do ACK frames. */
> -               tcp_recv_skb(sk, seq, &offset);
> +               tcp_recv_skb(sk, seq, &offset, false);
>                 tcp_cleanup_rbuf(sk, length + copylen);
>                 ret = 0;
>                 if (length == zc->length)
> --
> 2.32.0
>
