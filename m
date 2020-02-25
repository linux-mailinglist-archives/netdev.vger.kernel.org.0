Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC61516B966
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgBYGBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:01:39 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40286 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYGBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:01:39 -0500
Received: by mail-yw1-f65.google.com with SMTP id i126so6718182ywe.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 22:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e0rzqvhgwpOfQhQCIq5cjFbK1rG8Ft2D0FdpY4JT0BY=;
        b=tv2/g6T8ubcL4S+8xCDLS2HIrs6iR3p2Q2A8p3ggJ1Rclt12nqVIHTXEOQyHZd1pII
         scC4EJSQHauU9pfIo7eg7EnWALjMBQde5spiA4tgMQJLMmzUcN5TRhowouH1M1wXECu0
         ps4kPQqvCG2VLWR6PWxmwNfmjwoHaRJNRTeJF5tCjyfgXcOx9Wlbr4Ehc0ayX7gzLEQw
         sh8AejQ1CPNGjPEttgQwJq+yxGS2SWS2Cqej70cI/JXpWCLwjNgnTepBdPtGcnXcvI10
         baXpok10X2zVuCdZ4XBwm91PYeiukH/dZXO8qbPMATvYq+Uq3o1B/BfotqkhPUyX/E0g
         L+8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e0rzqvhgwpOfQhQCIq5cjFbK1rG8Ft2D0FdpY4JT0BY=;
        b=Nc0GYFyrXKvKDszjy6aF786XX46BsUGqfqDmyEHGcfxwnyBjOkmQQakNWBR70wGBlh
         y/e3959zxkoKXj7BsqXcVRzbXqDlNZwGaw2XJsdTTmr7sYtNf1BBv0ieQ1P1E3iubg36
         SzgTBti7QlnXYu54q067BIO/tL2MOjLBM/juwbPdgffeL/sNBcVOgTg3fMv1Rf7ZjSKc
         wdaP7Tbmvyn82GLOoNU6AkEorx/y5S4MxXxZRsxoOtmpS/LpTcpIZesjR1N+oyTnE4wv
         7QYIlOWWYcd9K41/OqRBoKF6J6MXXQ0QrZ+81e86EZqxaAYWt7xrOaq6cScGADgj3wem
         yVtg==
X-Gm-Message-State: APjAAAWsMNmBFvxBg/v6tq5Cv2OdXjqZ9k22f9VcxZtDwieVlTcLee9Z
        ImSugSSzxm8XrmOKmyel14qUDJp1cjrdP8H5syNq3D/GN3M=
X-Google-Smtp-Source: APXvYqwrAApIpAJ2zAeXVJ9P7xfknEc2TvDQS20TpTE/gWandQiWYGwRX4hK4gqiDjJ5XPcvgWjnTiocnQemGyPv2x8=
X-Received: by 2002:a25:bd85:: with SMTP id f5mr21050414ybh.274.1582610497544;
 Mon, 24 Feb 2020 22:01:37 -0800 (PST)
MIME-Version: 1.0
References: <20200225055806.74881-1-arjunroy.kdev@gmail.com>
In-Reply-To: <20200225055806.74881-1-arjunroy.kdev@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 24 Feb 2020 22:01:25 -0800
Message-ID: <CANn89iKFc9=4DrvuyGt05CVGqPumPO2e91wPZzp8qE90j4Gfeg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 9:58 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
>
> From: Arjun Roy <arjunroy@google.com>
>
> TCP receive zerocopy currently does not update the returned optlen for
> getsockopt(). Thus, userspace cannot properly determine if all the
> fields are set in the passed-in struct. This patch sets the optlen
> before return, in keeping with the expected operation of getsockopt().
>
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Please add a proper Fixes: tag :)

Thanks.

>
> ---
>  net/ipv4/tcp.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 600deb39f17de..fb9894d3d30e9 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4148,8 +4148,12 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  zerocopy_rcv_inq:
>                 zc.inq = tcp_inq_hint(sk);
>  zerocopy_rcv_out:
> -               if (!err && copy_to_user(optval, &zc, len))
> -                       err = -EFAULT;
> +               if (!err) {
> +                       if (put_user(len, optlen))
> +                               return -EFAULT;
> +                       if (copy_to_user(optval, &zc, len))
> +                               return -EFAULT;
> +               }
>                 return err;
>         }
>  #endif
> --
> 2.25.0.265.gbab2e86ba0-goog
>
