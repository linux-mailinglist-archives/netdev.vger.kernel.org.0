Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B5F6DA71E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbjDGB5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDGB47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:56:59 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F3A5FF9;
        Thu,  6 Apr 2023 18:56:57 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id i22so28967686uat.8;
        Thu, 06 Apr 2023 18:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680832616; x=1683424616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePvYWF3LgrcJpSASOA2Qoq+JJD21U5lACk4RrX/7jlk=;
        b=g2mZYAJJnU1KnfR/yHCsvDwnCfuYElvYtsT/kyxkU0tRQGasWF1Sy+DZHkx1V9Op+d
         iwlFDMTYW/Nq2m2ZFQzcXOadB4I9ZZn2PGjQcJEp2RvZWcFrvqBprNTgD+Sb0YoW61GT
         ZYVJFDxzzUW/wRM7T1S4rWLlEhNqthJUPa2nEQAZNC4m50hH3EzQEbOywTZgkmQ1vwHy
         7MxVJwMokNAymJvD5IZ9lxjaO+tTVCacb5krBZbjWKKveoJAf72XO1bMruMAee4CXols
         HGDO78FAtsTCsI5SI0xOpIVwj8JShB8es/McNabo22aHe/xjChP3o9rQoo1eFcDxHnsp
         1vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680832616; x=1683424616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePvYWF3LgrcJpSASOA2Qoq+JJD21U5lACk4RrX/7jlk=;
        b=FcVIjKyG8cSjbFFUOk5RYzoJm1V0uPbiWKiULmXxKB07MvYIg87uPGadR+7IXSHo2C
         BgSIKIen+N3qFS0KXZplJPjBe+uT7FidLzlbjUhYeeBplaJBX2kmNwEFMPYY8xmXWIbM
         LVRjCqhMw1l0+/JCEcmQYaEzVd6r2JGBd5FPY6/fvAtJ4BzMYJk8R3spMhl+GI3UzJ1D
         sLzV1B18Rq7XdYrnXizchL6c9tM/XjoGTwvf/e1tIkmBzRZp8b5fJNFZQK8w7xQkkVJ8
         RMJJW2oU1SFW7jp7PpRd7s9cWdeaBBikfRb/TzePSUXiM4wMbRXwjKXLEwp50KJYYSfb
         290g==
X-Gm-Message-State: AAQBX9fVdYZf+5ubm1xEweH7H2n7o3wjeHNeqn+JzbFnfO4XQLbE8xYe
        LeT8jumZXpGVQTPmMPuGOeOJM5nwqnqcXuOoVA8=
X-Google-Smtp-Source: AKy350aN1EG3BFhPHsmtekMoLwM0M28+ANFkN2MoPqmBdJx+Rgl+3U1I8HzoiHBTu1F37NkXpx33PJMqLfkoDTHUFzk=
X-Received: by 2002:ab0:539b:0:b0:6cd:2038:4911 with SMTP id
 k27-20020ab0539b000000b006cd20384911mr258188uaa.1.1680832616636; Thu, 06 Apr
 2023 18:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230406094245.3633290-1-dhowells@redhat.com> <20230406094245.3633290-6-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-6-dhowells@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 Apr 2023 21:56:19 -0400
Message-ID: <CAF=yD-+QCYsjuRvzTOjhn=sKCWwOd5ZWxG6VS-xkYEoxzGkUkA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 05/19] tcp: Support MSG_SPLICE_PAGES
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 5:43=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Make TCP's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
> spliced from the source iterator.
>
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Dumazet <edumazet@google.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: David Ahern <dsahern@kernel.org>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  net/ipv4/tcp.c | 67 ++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 60 insertions(+), 7 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index fd68d49490f2..510bacc7ce7b 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1221,7 +1221,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msgh=
dr *msg, size_t size)
>         int flags, err, copied =3D 0;
>         int mss_now =3D 0, size_goal, copied_syn =3D 0;
>         int process_backlog =3D 0;
> -       bool zc =3D false;
> +       int zc =3D 0;
>         long timeo;
>
>         flags =3D msg->msg_flags;
> @@ -1232,17 +1232,22 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
>                 if (msg->msg_ubuf) {
>                         uarg =3D msg->msg_ubuf;
>                         net_zcopy_get(uarg);
> -                       zc =3D sk->sk_route_caps & NETIF_F_SG;
> +                       if (sk->sk_route_caps & NETIF_F_SG)
> +                               zc =3D 1;
>                 } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>                         uarg =3D msg_zerocopy_realloc(sk, size, skb_zcopy=
(skb));
>                         if (!uarg) {
>                                 err =3D -ENOBUFS;
>                                 goto out_err;
>                         }
> -                       zc =3D sk->sk_route_caps & NETIF_F_SG;
> -                       if (!zc)
> +                       if (sk->sk_route_caps & NETIF_F_SG)
> +                               zc =3D 1;
> +                       else
>                                 uarg_to_msgzc(uarg)->zerocopy =3D 0;
>                 }
> +       } else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
> +               if (sk->sk_route_caps & NETIF_F_SG)
> +                       zc =3D 2;
>         }
>
>         if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) =
&&
> @@ -1305,7 +1310,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msgh=
dr *msg, size_t size)
>                 goto do_error;
>
>         while (msg_data_left(msg)) {
> -               int copy =3D 0;
> +               ssize_t copy =3D 0;
>
>                 skb =3D tcp_write_queue_tail(sk);
>                 if (skb)
> @@ -1346,7 +1351,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msgh=
dr *msg, size_t size)
>                 if (copy > msg_data_left(msg))
>                         copy =3D msg_data_left(msg);
>
> -               if (!zc) {
> +               if (zc =3D=3D 0) {
>                         bool merge =3D true;
>                         int i =3D skb_shinfo(skb)->nr_frags;
>                         struct page_frag *pfrag =3D sk_page_frag(sk);
> @@ -1391,7 +1396,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msgh=
dr *msg, size_t size)
>                                 page_ref_inc(pfrag->page);
>                         }
>                         pfrag->offset +=3D copy;
> -               } else {
> +               } else if (zc =3D=3D 1)  {

Instead of 1 and 2, MSG_ZEROCOPY and MSG_SPLICE_PAGES make the code
more self-documenting.

>                         /* First append to a fragless skb builds initial
>                          * pure zerocopy skb
>                          */
> @@ -1412,6 +1417,54 @@ int tcp_sendmsg_locked(struct sock *sk, struct msg=
hdr *msg, size_t size)
>                         if (err < 0)
>                                 goto do_error;
>                         copy =3D err;
> +               } else if (zc =3D=3D 2) {
> +                       /* Splice in data. */
> +                       struct page *page =3D NULL, **pages =3D &page;
> +                       size_t off =3D 0, part;
> +                       bool can_coalesce;
> +                       int i =3D skb_shinfo(skb)->nr_frags;
> +
> +                       copy =3D iov_iter_extract_pages(&msg->msg_iter, &=
pages,
> +                                                     copy, 1, 0, &off);
> +                       if (copy <=3D 0) {
> +                               err =3D copy ?: -EIO;
> +                               goto do_error;
> +                       }
> +
> +                       can_coalesce =3D skb_can_coalesce(skb, i, page, o=
ff);
> +                       if (!can_coalesce && i >=3D READ_ONCE(sysctl_max_=
skb_frags)) {
> +                               tcp_mark_push(tp, skb);
> +                               iov_iter_revert(&msg->msg_iter, copy);
> +                               goto new_segment;
> +                       }
> +                       if (tcp_downgrade_zcopy_pure(sk, skb)) {
> +                               iov_iter_revert(&msg->msg_iter, copy);
> +                               goto wait_for_space;
> +                       }
> +
> +                       part =3D tcp_wmem_schedule(sk, copy);
> +                       iov_iter_revert(&msg->msg_iter, copy - part);
> +                       if (!part)
> +                               goto wait_for_space;
> +                       copy =3D part;
> +
> +                       if (can_coalesce) {
> +                               skb_frag_size_add(&skb_shinfo(skb)->frags=
[i - 1], copy);
> +                       } else {
> +                               get_page(page);
> +                               skb_fill_page_desc_noacc(skb, i, page, of=
f, copy);
> +                       }
> +                       page =3D NULL;
> +
> +                       if (!(flags & MSG_NO_SHARED_FRAGS))
> +                               skb_shinfo(skb)->flags |=3D SKBFL_SHARED_=
FRAG;
> +
> +                       skb->len +=3D copy;
> +                       skb->data_len +=3D copy;
> +                       skb->truesize +=3D copy;
> +                       sk_wmem_queued_add(sk, copy);
> +                       sk_mem_charge(sk, copy);
> +

Similar to udp, perhaps in a helper?
