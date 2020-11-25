Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A752C39DF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgKYHQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgKYHQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 02:16:23 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C76CC0613D4;
        Tue, 24 Nov 2020 23:16:23 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id l11so674296plt.1;
        Tue, 24 Nov 2020 23:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FLixRuYcjlzkXMCPVjeCT6ZjLrkMdMvBPO/J/NBDbU8=;
        b=gLnBfRHV1xBig3HBBT1lWSsgDFsSM+gOfleW46aWWiNP/gciF/poiuKhif5IFzuI3F
         Nb67ni+ZZARTqZjZzmOrZ/l0ui0Zq72kP2labj7kCC3uzdLzk0NpI+PxXl0/4yxZbi4j
         FK34xRagedBEjB3TYdW7alXeI28y2rTYKdRtCWMMPi90h2TV75ED9O2FcEDv3ef2vMHC
         Ie7eHuJVjud7XZ32xZVCGDNidA5m9XRKqiEOF2xGkutpS59NrfO4iCYZaIEZWVeQuurt
         35CDhXZYIh4Iwr4w30WskUjU14r7y1t+6siJTEyzw4rJdWU3QImwjem0y/2hSJ8lD3xR
         DHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FLixRuYcjlzkXMCPVjeCT6ZjLrkMdMvBPO/J/NBDbU8=;
        b=cVpwoU6SCZTE3Cg1a3vcNAIVTL/0r6hkBG6gntX/RE/9Q7/J6ekGPZ8FMGtuo3iFFO
         ++rhdKI6e5jADXGQVzsvH1524glWEzZ3i7SVbRWImEFH5Az4/Fo8o8K8uOURm0Li2HMJ
         zaEIFDTp/vQMqE+3f6ArOyRs3Oiij4vTwSQmaP5PVxUaIxs8egiJ8pXrl/5VlWpq3cgn
         6h8bLNf7v7oWdA1h+Bt1tauYPUib8SsfDSg1Aqz8lze3fUIA4+zv/dabRd491LcblhUs
         cHw3+GAJrgJrJh3DLRsUvNFrr35Su5//q5C6BFmehAOVQgJO+1rhxQFwCfbHNGkrRwGg
         tuzg==
X-Gm-Message-State: AOAM531kcEtIhFveXhO0chBPfecrcSECMw6ERT/zNYSDTq2jwjYcIHN6
        IRj3sne47WigFCmh2KlheeU9QDKHWWw1Q1NRpY0=
X-Google-Smtp-Source: ABdhPJwdLCBRDBbCj66ayfFc7QBY8z4qpsXvWYjf4D2QIy23v5Sr691EaB1Ww8Spv4P0yGg3oCUM34NduRqm3k8mPec=
X-Received: by 2002:a17:902:bd02:b029:da:8fd:af6b with SMTP id
 p2-20020a170902bd02b02900da08fdaf6bmr2145917pls.7.1606288582460; Tue, 24 Nov
 2020 23:16:22 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-5-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-5-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 08:16:11 +0100
Message-ID: <CAJ8uoz31U=WprbtgGhrGqzuC5-TswsKEtOhfk1NFnBS6fz53Bg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 04/10] xsk: check need wakeup flag in sendmsg()
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 9:33 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Add a check for need wake up in sendmsg(), so that if a user calls
> sendmsg() when no wakeup is needed, do not trigger a wakeup.
>
> To simplify the need wakeup check in the syscall, unconditionally
> enable the need wakeup flag for Tx. This has a side-effect for poll();
> If poll() is called for a socket without enabled need wakeup, a Tx
> wakeup is unconditionally performed.
>
> The wakeup matrix for AF_XDP now looks like:
>
> need wakeup | poll()       | sendmsg()   | recvmsg()
> ------------+--------------+-------------+------------
> disabled    | wake Tx      | wake Tx     | nop
> enabled     | check flag;  | check flag; | check flag;
>             |   wake Tx/Rx |   wake Tx   |   wake Rx
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk.c           |  6 +++++-
>  net/xdp/xsk_buff_pool.c | 13 ++++++-------
>  2 files changed, 11 insertions(+), 8 deletions(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 56a52ec75696..bf0f5c34af6c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -522,13 +522,17 @@ static int xsk_sendmsg(struct socket *sock, struct =
msghdr *m, size_t total_len)
>         bool need_wait =3D !(m->msg_flags & MSG_DONTWAIT);
>         struct sock *sk =3D sock->sk;
>         struct xdp_sock *xs =3D xdp_sk(sk);
> +       struct xsk_buff_pool *pool;
>
>         if (unlikely(!xsk_is_bound(xs)))
>                 return -ENXIO;
>         if (unlikely(need_wait))
>                 return -EOPNOTSUPP;
>
> -       return __xsk_sendmsg(sk);
> +       pool =3D xs->pool;
> +       if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
> +               return __xsk_sendmsg(sk);
> +       return 0;
>  }
>
>  static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len=
, int flags)
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 8a3bf4e1318e..96bb607853ad 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -144,14 +144,13 @@ static int __xp_assign_dev(struct xsk_buff_pool *po=
ol,
>         if (err)
>                 return err;
>
> -       if (flags & XDP_USE_NEED_WAKEUP) {
> +       if (flags & XDP_USE_NEED_WAKEUP)
>                 pool->uses_need_wakeup =3D true;
> -               /* Tx needs to be explicitly woken up the first time.
> -                * Also for supporting drivers that do not implement this
> -                * feature. They will always have to call sendto().
> -                */
> -               pool->cached_need_wakeup =3D XDP_WAKEUP_TX;
> -       }
> +       /* Tx needs to be explicitly woken up the first time.  Also
> +        * for supporting drivers that do not implement this
> +        * feature. They will always have to call sendto() or poll().
> +        */
> +       pool->cached_need_wakeup =3D XDP_WAKEUP_TX;
>
>         dev_hold(netdev);
>
> --
> 2.27.0
>
