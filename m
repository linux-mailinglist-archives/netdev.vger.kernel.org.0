Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1C82C3A6A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKYH6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKYH6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 02:58:39 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693E1C0613D4;
        Tue, 24 Nov 2020 23:58:39 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id m9so1715831pgb.4;
        Tue, 24 Nov 2020 23:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DtIe8G2KMacN//ZG4sPWF0YSzSjWO1RKSMmBk0516Zw=;
        b=eBh/tjOGY8/AEwE6++RhULLNGa/LH/FoE9SrfWa3coO6zClhPluVwsNr/FfD98l3ie
         eQsPRBglePTeeB2bkj8wkoMXflNIgxAkqnT0mlu+IW9PDoAIoukjJ8bXyQ3U+m5cNN3q
         Z9eHynsm1Gfay6dbRx5NfEIWrIHgEyBvEbCOcXmiokfiBb6S4rQuNvgGcKaQoJ2WUaW3
         5bx9JbC3OUuyOO+k2VeS0/Uq/Q6C2pAPPOClAHsTEiLSdfuaWGig8CRLx8WM/DYMJ0zf
         4WHQXx7wp+VA//VfUx7uB16xh3laDqQcw5Zffn4hMw7vmf1TO7XRnMXBm8Ib2j5yvW9X
         ErBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DtIe8G2KMacN//ZG4sPWF0YSzSjWO1RKSMmBk0516Zw=;
        b=mE+kA+ObN8DWuJCktO2p0oR4R/dP7yTsvpoq5y9A/1UE2WOn9SSsSxxNrqPBwNV1BL
         EDfjFMIHDkZV3r/XOKIiVxE/0N9DSPInjoPWVcr9z1k8Qz9afRmkPzmxEnnRMuK7XKdu
         +LD7HWooU0KXtG9KjGigI05jF6Vq9FMIqPTwk0c01f9wymyypiLpJYWEmc/tW7iVZFf4
         bygMiKXLWKcJk4SJAF+CqtK5OMYl8H+uX7uV4qebutqUKz0yVdcqM/MtCR6vJ3k4GYfe
         6VXHhLlLx67wj9GOccad0LB34fkxXAAOeH+7sZ+et1MC6d1M4xGntAruvCXPQmiutb8A
         riYA==
X-Gm-Message-State: AOAM531qex0LSxtpH74z2GKtrp4oz99Am5VN2PxeoI1p04xnlS1ZuZkk
        iOEAdCyGpDPduUQ3BRKZFDaSfLLvTNApEiZJaDQ=
X-Google-Smtp-Source: ABdhPJyi1245gyBuB5CYVo4ZzoP9q9pQpRlkiQIWTbzuglIHucNjUoeC2TfjyL/n+QEldYMc1Y7wNgtcJDZSJZlJwfs=
X-Received: by 2002:a17:90a:ea05:: with SMTP id w5mr2701550pjy.204.1606291118966;
 Tue, 24 Nov 2020 23:58:38 -0800 (PST)
MIME-Version: 1.0
References: <20201119083024.119566-1-bjorn.topel@gmail.com> <20201119083024.119566-6-bjorn.topel@gmail.com>
In-Reply-To: <20201119083024.119566-6-bjorn.topel@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 08:58:27 +0100
Message-ID: <CAJ8uoz0Dobvq1WJBcyjfEn-e9dHys2DUCGL9rgdr-z8a57MWWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 05/10] xsk: add busy-poll support for {recv,send}msg()
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
> Wire-up XDP socket busy-poll support for recvmsg() and sendmsg(). If
> the XDP socket prefers busy-polling, make sure that no wakeup/IPI is
> performed.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  net/xdp/xsk.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index bf0f5c34af6c..ecc4579e41ee 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -23,6 +23,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/rculist.h>
>  #include <net/xdp_sock_drv.h>
> +#include <net/busy_poll.h>
>  #include <net/xdp.h>
>
>  #include "xsk_queue.h"
> @@ -517,6 +518,17 @@ static int __xsk_sendmsg(struct sock *sk)
>         return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
>  }
>
> +static bool xsk_no_wakeup(struct sock *sk)
> +{
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +       /* Prefer busy-polling, skip the wakeup. */
> +       return READ_ONCE(sk->sk_prefer_busy_poll) && READ_ONCE(sk->sk_ll_=
usec) &&
> +               READ_ONCE(sk->sk_napi_id) >=3D MIN_NAPI_ID;
> +#else
> +       return false;
> +#endif
> +}
> +
>  static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t tot=
al_len)
>  {
>         bool need_wait =3D !(m->msg_flags & MSG_DONTWAIT);
> @@ -529,6 +541,12 @@ static int xsk_sendmsg(struct socket *sock, struct m=
sghdr *m, size_t total_len)
>         if (unlikely(need_wait))
>                 return -EOPNOTSUPP;
>
> +       if (sk_can_busy_loop(sk))
> +               sk_busy_loop(sk, 1); /* only support non-blocking sockets=
 */
> +
> +       if (xsk_no_wakeup(sk))
> +               return 0;
> +
>         pool =3D xs->pool;
>         if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
>                 return __xsk_sendmsg(sk);
> @@ -550,6 +568,12 @@ static int xsk_recvmsg(struct socket *sock, struct m=
sghdr *m, size_t len, int fl
>         if (unlikely(need_wait))
>                 return -EOPNOTSUPP;
>
> +       if (sk_can_busy_loop(sk))
> +               sk_busy_loop(sk, 1); /* only support non-blocking sockets=
 */
> +
> +       if (xsk_no_wakeup(sk))
> +               return 0;
> +
>         if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
>                 return xsk_wakeup(xs, XDP_WAKEUP_RX);
>         return 0;
> --
> 2.27.0
>
