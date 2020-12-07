Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD902D0C8D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgLGJCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgLGJCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 04:02:30 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065F1C061A51;
        Mon,  7 Dec 2020 01:01:53 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id o7so7055973pjj.2;
        Mon, 07 Dec 2020 01:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O6TV8n4dnhxn+ChBFoZj/FKpNfXbjWCYooSaqLgkIwQ=;
        b=XaUYi5l5LtTJmoYdO/7wC46Irj3xh1f/qTjTir4CLZk5/KWRrGPLIQbRtOExLWdIiJ
         6sEKSplwI2uSigUnCgZ0HpKDRkHgLt7SOsuEAraq0iMfvFiZK0nm6yetJawPkz1641Lu
         XgC45Gutnr1EMD5KCemY/7PLHPG3RznEE/cFD3WlLNAvES+chxP03fH6YEHs75miNZ/T
         s0C2WbDBrQzCT+p++aI4n6ywMNoLmcQGC4209kcotxSz+9ig8Q4YwLJE5G4TLgLxum3T
         gTqc6HL48ILSxwL6AIwto5wKoVw3p7Xs/R+eqkACae8qdk00ez6kY2ZtssLAexswTtfi
         tMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O6TV8n4dnhxn+ChBFoZj/FKpNfXbjWCYooSaqLgkIwQ=;
        b=UmM+MvQdo+4jZ6EKvOeyB9HnorKQhHBO3LroE3AaJd/GArkb3mgZt04hawDVLMIXJ8
         Dlb3QCyKcnO3ELALHUyEStobIaz5+wiostHKDqQZ4ZIxcERVpNHRfg1o75tNWXO80xkx
         ybetFTLrPpfBOpa+H2rWgx5Wnczuo1ZbbxC2ldph7fQzRg2rdTcWNCUugwmQItyMPN5N
         mtwKfE9zst9wNHyN2m6rgvS3aQULnCaRDnpA4kvCI8PAOZ2l4Jdgc7XVHN5C4jZKKrWW
         05LqFxx+bGhvvSaqVuQzmme7vkp3AciWfEqrkaPLL4J6N5A2EPDNm6ZOMPqNMRvCDqu6
         lBgw==
X-Gm-Message-State: AOAM530eBrdFAKLNVj/ebDzZsQSElKW/CeqbttHvXrTnjU1v3low7oee
        tqxInQQOPQcpQy7RHKmPSZH6OTt52x7KsqwWBCQ=
X-Google-Smtp-Source: ABdhPJxG87O/y7oR2NId/KTWlxPZYbLiTAKw37psKvRCHoQCu6/Avp6BuOdfDWtFEC/JsEOrKmpj6V2OFWl/n6YubXM=
X-Received: by 2002:a17:90a:fcc:: with SMTP id 70mr15268706pjz.168.1607331712537;
 Mon, 07 Dec 2020 01:01:52 -0800 (PST)
MIME-Version: 1.0
References: <20201207082008.132263-1-bjorn.topel@gmail.com>
In-Reply-To: <20201207082008.132263-1-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 7 Dec 2020 10:01:41 +0100
Message-ID: <CAJ8uoz1sb=RWNbdAYSduqL5ME7OwWMV3aEwgPhgN0v=4mCSjwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: Validate socket state in xsk_recvmsg, prior
 touching socket members
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 9:22 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> In AF_XDP the socket state needs to be checked, prior touching the
> members of the socket. This was not the case for the recvmsg
> implementation. Fix that by moving the xsk_is_bound() call.
>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Fixes: 45a86681844e ("xsk: Add support for recvmsg()")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 56c46e5f57bc..e28c6825e089 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -554,12 +554,12 @@ static int xsk_recvmsg(struct socket *sock, struct =
msghdr *m, size_t len, int fl
>         struct sock *sk =3D sock->sk;
>         struct xdp_sock *xs =3D xdp_sk(sk);
>
> +       if (unlikely(!xsk_is_bound(xs)))
> +               return -ENXIO;
>         if (unlikely(!(xs->dev->flags & IFF_UP)))
>                 return -ENETDOWN;
>         if (unlikely(!xs->rx))
>                 return -ENOBUFS;
> -       if (unlikely(!xsk_is_bound(xs)))
> -               return -ENXIO;
>         if (unlikely(need_wait))
>                 return -EOPNOTSUPP;
>
>
> base-commit: 34da87213d3ddd26643aa83deff7ffc6463da0fc
> --
> 2.27.0
>
