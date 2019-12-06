Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B30114DF7
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfLFJDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:03:02 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41095 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLFJDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:03:02 -0500
Received: by mail-qk1-f196.google.com with SMTP id g15so5882912qka.8;
        Fri, 06 Dec 2019 01:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67Zm7DHp5bx3f5X4Sn0b2d1HLcXMK42K0L6gRmue3rE=;
        b=d3feDSha0xG+RZp0j+3vha7KiBw83C3laRnnu+OzA8nwsNRqB4vH8U8gQKDGLDp7FM
         JQPlaMf8CPf/mlk05jD+VE3MN8+T4U8RvvSmO/bsEdtAE1xh8aCYpQ5gwAb2bUJDhstF
         9Xm0dfZpExcUDk4s7z1dhdSWs36p9wSjHITcsMGRsdNHyFY8TTtBhGFTHYKHuOrgCm51
         MDn8Z9LAWb+7sd9NbS1KF5pn5fQ9whoHK1bNYHZsUzVzbz/0z4ligdVDFtr7QJIL8m7Z
         r0JuJ7aZS5bDpWBrgTa7RyYHvHoosvW/CjtqvYrT5mD5lDkdM34rxPxsQ8fdrNitQr8Y
         B+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67Zm7DHp5bx3f5X4Sn0b2d1HLcXMK42K0L6gRmue3rE=;
        b=Vqw01W0CjFY0u+FTUtJcLCa6SAei7+cbqI7DpMfkj1NDuAPd7wWIchcxAkuFKw9FAL
         uyBNfK1fgYIWcc38Vxx4/raUIBl7R3Eo1La4h2D8Phy1xVnNeFw0lSWQZl7hWJOxptUk
         KN0jNngnKuR3cAGP0I4A22vDYdHX2QCVRqpe53xGuuj/bG+HrVIXxVKDe8A5fTyALbTf
         +Gy0um1oz+WRrd9ZAKWdHS16fdakjGFRNczlgcSwBJ7hBiGHZqmDwSzG/K3hcLEpHny/
         VE8rn5OComHlOhicV8xKUX4ORjOtrKprbaEQsVSVwwKeWyGZVBldybcwyrfgwX3PphRa
         KggA==
X-Gm-Message-State: APjAAAU97dcYIcTSFwPp740kbE2PkASevbCQ1spE4moD7VZ3XDBKO6l8
        rXMbEFUzhguag6znVQ6cPIyglGFPag0yY5HV2UM=
X-Google-Smtp-Source: APXvYqxSZ4JnMoHxxdfoD4IykH04l1uQoKHN9CzO1hbq5PSRCGJHDPqur5UTkQT+V8vRqdqXefjZmtsnAb2xgd7sKKQ=
X-Received: by 2002:a37:aa45:: with SMTP id t66mr12613240qke.218.1575622981697;
 Fri, 06 Dec 2019 01:03:01 -0800 (PST)
MIME-Version: 1.0
References: <20191205155028.28854-1-maximmi@mellanox.com> <20191205155028.28854-2-maximmi@mellanox.com>
In-Reply-To: <20191205155028.28854-2-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 6 Dec 2019 10:02:50 +0100
Message-ID: <CAJ+HfNiV0A+Wic2JcQGQfLemf-bRghP1FKdJ0uREZz6ONdCDmw@mail.gmail.com>
Subject: Re: [PATCH bpf 1/4] xsk: Add rcu_read_lock around the XSK wakeup
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Dec 2019 at 16:52, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> The XSK wakeup callback in drivers makes some sanity checks before
> triggering NAPI. However, some configuration changes may occur during
> this function that affect the result of those checks. For example, the
> interface can go down, and all the resources will be destroyed after the
> checks in the wakeup function, but before it attempts to use these
> resources. Wrap this callback in rcu_read_lock to allow driver to
> synchronize_rcu before actually destroying the resources.
>

Thanks for taking a deeper look!

> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> ---
>  net/xdp/xsk.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 956793893c9d..d2261c90f03a 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -337,9 +337,13 @@ EXPORT_SYMBOL(xsk_umem_consume_tx);
>  static int xsk_zc_xmit(struct xdp_sock *xs)
>  {
>         struct net_device *dev = xs->dev;
> +       int err;
>
> -       return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
> -                                              XDP_WAKEUP_TX);
> +       rcu_read_lock();
> +       err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, XDP_WAKEUP_TX);
> +       rcu_read_unlock();
> +

The rationale for the the not having any synchronization on the
ndo_xsk_wakeup was to not constrain the drivers. The idea was to let
drivers take care of the required synchronization themselves, since
this is most likely driver specific. I'd prefer leaving that to the
driver implementors, not having the read-lock in the generic AF_XDP
code.

(And note that the ndo_xsk_wakeup is also called in the poll() implementation.)

I don't think this is needed for the Intel drivers, but let me
elaborate on that in those patches. Note "think" here -- I might be
way off here! :-)

> +       return err;
>  }
>
>  static void xsk_destruct_skb(struct sk_buff *skb)
> --
> 2.20.1
>
