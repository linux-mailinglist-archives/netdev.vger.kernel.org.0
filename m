Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7CE22F3B5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgG0PT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgG0PT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:19:56 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD39C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:19:55 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id j21so5504953ual.11
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q4U5zuhIATNnRf0A4WQyT28oybMArFXXEFCl7nS55j8=;
        b=aSU0p2b6XzobLyIWooJz29y+4PiIAb6qzgBx76qtDDKAO6WGdludj3uNz4nAnlJEoQ
         mxnKZg6jm7t03bw+UM3kXmZ6pL3pR+uMvwILo2NBPb/51tZ7XoDQciXbKfmmtZHIrRfb
         Wj70RSrwyBlen8X45eezXa9cb4k/qd/kQjTOyiMEw09lfrzF0fYTQARDZ8w+WcBVkgqC
         vRMbzCC2kh2SmjUfS12qg0KOkw/wdxF83g8yDIMGwAxr3nSvwdzCaYBqC65uqAHUgzPm
         ykz5Fafe1nzJrwlvTqb5jy7ffeH94V4zfNGNbE+80f6LTfzIKt3TTQCJS+DpBeeeV5Zg
         E3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4U5zuhIATNnRf0A4WQyT28oybMArFXXEFCl7nS55j8=;
        b=ainaThWel1JFGuYPfwYhpMNDcc3dFd+u2JB78Kcq8PasVb3w9XAxG3ZTT1OAP5lpwi
         BJ+kqzzOSIv1iH+vpDH+OVFNzswOm7frCWpdaZd9S5Fo+wbn7WflDHQm66xx+ZUgX++m
         2WTLSjAiHSdDfPXgvcLD2s8E+gwhJxJI77FczS47aqpuSGQNRgbGAXlCHWja3cU+l4C8
         gBwZom/bhsrkle3IEm94ODJVLSWIxDrC92r39hKg1XcjtDXrXYqIsxJzjOAtIlrGG+i6
         yrN0WJ1Hmg/2nCl9TiyR3uWRuZJU2lt027/+kAAJXfWlnqAC06FPGEl5z3FralvHNaJ+
         H2rA==
X-Gm-Message-State: AOAM531LLWp1W+g9NaTQbToWlRp7izJ15g5N7YqQShyubwG18NVkyrdG
        361e1e2G4GxxJ6rxpbtFT5KvKJMwfU6rudYoBp+w1g==
X-Google-Smtp-Source: ABdhPJwebd9qsFLejcD9fpRNQdeyMd4ou8zrMuggB5bGDqZ4RBQKjP31F4S41A/oYRjA2KF09mml5hsiY1D1lrWyQTQ=
X-Received: by 2002:ab0:a8a:: with SMTP id d10mr1864953uak.41.1595863194686;
 Mon, 27 Jul 2020 08:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-16-jonathan.lemon@gmail.com>
In-Reply-To: <20200727052846.4070247-16-jonathan.lemon@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 08:19:43 -0700
Message-ID: <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/21] net/tcp: add MSG_NETDMA flag for sendmsg()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> This flag indicates that the attached data is a zero-copy send,
> and the pages should be retrieved from the netgpu module.  The
> socket should should already have been attached to a netgpu queue.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/socket.h | 1 +
>  net/ipv4/tcp.c         | 8 ++++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 04d2bc97f497..63816cc25dee 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -310,6 +310,7 @@ struct ucred {
>                                           */
>
>  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path */
> +#define MSG_NETDMA     0x8000000
>  #define MSG_FASTOPEN   0x20000000      /* Send data in TCP SYN */
>  #define MSG_CMSG_CLOEXEC 0x40000000    /* Set close_on_exec for file
>                                            descriptor received through
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 261c28ccc8f6..340ce319edc9 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1214,6 +1214,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>                         uarg->zerocopy = 0;
>         }
>
> +       if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> +               zc = sk->sk_route_caps & NETIF_F_SG;
> +               if (!zc) {
> +                       err = -EFAULT;
> +                       goto out_err;
> +               }
> +       }
>

Sorry, no, we can not allow adding yet another branch into TCP fast
path for yet another variant of zero copy.

Overall, I think your patch series desperately tries to add changes in
TCP stack, while there is yet no proof
that you have to use TCP transport between the peers.
