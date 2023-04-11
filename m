Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266AF6DE1E6
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDKRJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjDKRJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:09:14 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18140F2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:09:12 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id ch3so10027704ybb.4
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681232952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gm7xePjxYk7+XJPNyNCPc3m+W8vE886GdLa6QN77x1c=;
        b=Dt/fnq5Rohg8OvlruMfiPphHzl880reg7mPfS4YNa5TmiKezMqJU7c5N642pzetXf2
         6NbxlvK5ktk5iVQVml81CM9HQp85vFnzaieIFuuBqYSPu6WYL5u9tdlk4I6vgkBMqUvC
         w6wRpn8CV3RHhSbKqat6mlHmMYEYrkecxwv76tB8yR+Z9cCcwUm2we4/xm2upTtQATqH
         K4dsin1oFx+mWY14ixXb3oYb59cL4azDcD+rWQMZleC8KPvs8F+48Wq+ejwmTxLhkXPf
         IQbCu9aPtXBDaBDRLeDoRMpbwBZMZsK7uZVTPVozcyVwBpKD7OpdbHbV6DcndD7Ixvtu
         1lzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681232952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gm7xePjxYk7+XJPNyNCPc3m+W8vE886GdLa6QN77x1c=;
        b=y1thwfw+Y3POX42QM4G57wWOs77w/PbGyAOQftt0SXjLIdFWPGZLBacV9PKsk+QsXy
         QsLw/UBbOGUeCKkoECk+fHf+uNdNVdWNra/jw0f+AUazBAKn6AQhs6RmKsSYv995FgQ/
         5Y57OSrfKV+NzX4dSKGDeSvCkBASDnrw2Aoo3YTUQbLLuiRf3S4ybbe9cfSYDZNSJv2a
         H+8r8OBdpmDcGXblzUlGP+UQEdmo2doGUVOYJkk+/ZoQIZOtVktO9/ML3UxID7BJct/b
         Jg94VGvLbXcInhHDFIDJkViXiohx9vI/9cqe5ySGtLezYytHq4VmbI0xrSphsuk8bSQS
         eM5A==
X-Gm-Message-State: AAQBX9ebtivuZvGpu8dMxDYjnCHYNNBt2Au7qNM/5FRqc5aCoefoFYUx
        htKSeLDpj0o4ga/oFh55VZEgeq6deWZQ+kPwqn0TRrMlqxxbNmEmUtQ6gWnk
X-Google-Smtp-Source: AKy350b8jaqgaAHh8wLrh+Z1EDrMUNUXWA3JcWdiVtFGHsb3jqA9X9Y6psDGOt8LUL6EO2xtyY+DLjKwwfub7Ud1Mfs=
X-Received: by 2002:a25:7347:0:b0:b8f:892:3967 with SMTP id
 o68-20020a257347000000b00b8f08923967mr2861731ybc.4.1681232951657; Tue, 11 Apr
 2023 10:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230411160902.4134381-1-dhowells@redhat.com> <20230411160902.4134381-8-dhowells@redhat.com>
In-Reply-To: <20230411160902.4134381-8-dhowells@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Apr 2023 19:09:00 +0200
Message-ID: <CANn89iLW3_1SZV4EV3h2W45B_+b+R67fp40t8OaqpqLnVEhTew@mail.gmail.com>
Subject: Re: [PATCH net-next v6 07/18] tcp: Support MSG_SPLICE_PAGES
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 6:09=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Make TCP's sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
> spliced or copied (if it cannot be spliced) from the source iterator.
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
>
> Notes:
>     ver #6)
>      - Use common helper.
>
>  net/ipv4/tcp.c | 43 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 7 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index fd68d49490f2..0b2213da5aaf 100644
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

zc is set to 0, 1, MSG_ZEROCOPY ,   MSG_SPLICE_PAGES

I find this a bit confusing. Maybe use a private enum ?

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
> +                               zc =3D MSG_ZEROCOPY;
> +                       else
>                                 uarg_to_msgzc(uarg)->zerocopy =3D 0;
>                 }
> +       } else if (unlikely(msg->msg_flags & MSG_SPLICE_PAGES) && size) {
> +               if (sk->sk_route_caps & NETIF_F_SG)
> +                       zc =3D MSG_SPLICE_PAGES;
