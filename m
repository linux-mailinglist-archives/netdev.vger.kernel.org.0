Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E796A6DA764
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 04:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240342AbjDGCFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 22:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbjDGCFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 22:05:32 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B4DD324;
        Thu,  6 Apr 2023 19:03:51 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id dg15so24295925vsb.13;
        Thu, 06 Apr 2023 19:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680832939; x=1683424939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNjYz0mwAEnp5iGFtGlkbjUifhzDTS1lkAnmUE+wQDs=;
        b=k0Rk6Klrd+NMVlkQ0I4To0EBVYkq06tJRKyF9Q+HTZZ0mjPeotBo3paE++cFPYF74I
         d7YMh7vQCKZi1N9BOffWx91Z9WKlyoiq8QIJe2HB3hbBC/XT6aa52OB/+8fug6vGCi1D
         Nia+kmPulIYI1u+DRUOoTPbVkxzFpd10SUkVkW00sps43RMJ/0UWdKnXPLRV/OSqjmi8
         gZl+aiT8xrAeqf1Vpf+QzMN9k0mRMRhaw+u6oqUurjvtM+n18w2/8gxsC1kd+w7FC2nn
         ZXYQqe0Qqim7CRV9MMMbxO5dOwfeUjdeIE99mgOFkjWw0tD6DM0lBb2rdCFNnUi4vm/M
         3HbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680832939; x=1683424939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNjYz0mwAEnp5iGFtGlkbjUifhzDTS1lkAnmUE+wQDs=;
        b=H9g2dANrHmsqL3PUQcRVszm1lVPbos3LcAiYt23doHI7qvn/L6BORbCk69oxUl+tib
         w4x7IhUbtve4/dg4bdzQSorQi/QjGKbsgtEACh6zhV+zhbA+xHiqgX5sZuM4hlu0g4+U
         uv+Jtb8VZuxSTTf8ccDvC15y1fNHLB0wNMi8iaGnj72hQg+YE05IdS5tLdNjKnLUaNBu
         sndsXD/tic39/ltFo7RXYP4/VN+xDPSnxwyA1D1V5Q6EI44rByfUe3xAj7f9pE8Vsle9
         XIKXEiS6e4BnjwxrvMUA8sEgNjpTYM8GKqvzXrEvQteeu7UTxp+sV7E1u+czGoJz5SkL
         gdcg==
X-Gm-Message-State: AAQBX9dNl0ALa9FBbg5F2tGWFe4+4p7Ec2b3dj1M0xvgo+1wMUwNSGa2
        ajTtGLgSIq2vL+ZKjTXDHpVJAcp7vUIAzqLvMsI=
X-Google-Smtp-Source: AKy350bGEsmljBB5v0+qgjtoyZwIZGaewYP8JGjSoxxkH0iyM7Jm0eZvtJ9T10+AG3zRu8TocoTTHS8eeuT3PBMxDmM=
X-Received: by 2002:a67:c190:0:b0:425:969d:3709 with SMTP id
 h16-20020a67c190000000b00425969d3709mr326145vsj.3.1680832939251; Thu, 06 Apr
 2023 19:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230406094245.3633290-1-dhowells@redhat.com> <20230406094245.3633290-7-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-7-dhowells@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 Apr 2023 22:01:42 -0400
Message-ID: <CAF=yD-LAC4QCfoGVKaW-GzU26=xp-6Wuq3jxAhJK1+KV0M+q2A@mail.gmail.com>
Subject: Re: [PATCH net-next v5 06/19] tcp: Make sendmsg(MSG_SPLICE_PAGES)
 copy unspliceable data
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
> If sendmsg() with MSG_SPLICE_PAGES encounters a page that shouldn't be
> spliced - a slab page, for instance, or one with a zero count - make
> tcp_sendmsg() copy it.
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
>  net/ipv4/tcp.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 510bacc7ce7b..238a8ad6527c 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1418,10 +1418,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
>                                 goto do_error;
>                         copy =3D err;
>                 } else if (zc =3D=3D 2) {
> -                       /* Splice in data. */
> +                       /* Splice in data if we can; copy if we can't. */
>                         struct page *page =3D NULL, **pages =3D &page;
>                         size_t off =3D 0, part;
> -                       bool can_coalesce;
> +                       bool can_coalesce, put =3D false;
>                         int i =3D skb_shinfo(skb)->nr_frags;
>
>                         copy =3D iov_iter_extract_pages(&msg->msg_iter, &=
pages,
> @@ -1448,12 +1448,34 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
>                                 goto wait_for_space;
>                         copy =3D part;
>
> +                       if (!sendpage_ok(page)) {
> +                               const void *p =3D kmap_local_page(page);
> +                               void *q;
> +
> +                               q =3D page_frag_memdup(NULL, p + off, cop=
y,
> +                                                    sk->sk_allocation, U=
LONG_MAX);
> +                               kunmap_local(p);
> +                               if (!q) {
> +                                       iov_iter_revert(&msg->msg_iter, c=
opy);
> +                                       err =3D copy ?: -ENOMEM;
> +                                       goto do_error;
> +                               }
> +                               page =3D virt_to_page(q);
> +                               off =3D offset_in_page(q);
> +                               put =3D true;
> +                               can_coalesce =3D false;
> +                       }
> +

This is almost identical in the later udp and unix implementations.
Could this be a wrapper, something like

    page =3D sendpage_copy_if_needed(&page, &off, copy, gfp, &put));

(it seems page is never needed if it would return NULL)
