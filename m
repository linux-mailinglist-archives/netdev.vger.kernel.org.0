Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23A65D244
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfGBPBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:01:43 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33942 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBPBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:01:43 -0400
Received: by mail-oi1-f193.google.com with SMTP id l12so13291145oil.1;
        Tue, 02 Jul 2019 08:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wu4n6rt8dpZFT6Rp38QtTJKHyefNt4oXtkanq1KfYnk=;
        b=eCsTmrn1/4HhdFxlat2QV5hCplRz6CB9F27W1WRgR6BU6rnPsWmXFAYkH2Ky3l2Mxn
         XcNUt0BbtOaRvRhLj+W0YrE/BMReTe79kFT8VsAnDODOBr+adj55iQyv81dBjfxFTifW
         d3s11jzxStz+7/Qy2Lr8LAkR71rx/nv56g0dgHrn6aevgkmgPUsL3qcftHMZxS9UFryP
         k80FNBKkVi7EClYuhk9lnkw5aatMej5nNX/jvIHPneqPIX/0u6E3OGA0rmELTsvtHx/C
         /qZ7UZQLPe3+HTA7qw2UPLnFATxEJze8ilimKRIsKsenhUObwnW1N933Wtx02wKIAoPC
         Oy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wu4n6rt8dpZFT6Rp38QtTJKHyefNt4oXtkanq1KfYnk=;
        b=alE+Kh7OW0V0G0gEISvCAYQagZmgU8YrFOQi73F9RS67xnMLMKu12aSeR6I2uH1kxj
         wZixl6cVCFVI2ZAMpf/YJ0TkAlbRpgIdAEnlcI9iZ8edMRuP82ogtlodHO0MX5nRFdRH
         NLGZ8zvXvlFNefErYgQhAEy0ZZySetDMrepuInOxhnxLmX1NATsrg7/jl26bVj0W0tGY
         8ilbiePBTypIEzV9h/3ss0W+3ePoCkA0XyjSoBqPvspoElBV3/9EQVPa9o/zOU0UVlOA
         nzw1+YJJpcbm91PK61CtadSVJO6TLEABA6a2p79zE68yhWMMpR4WiTm0Gh4Gyxt0dl9J
         clrQ==
X-Gm-Message-State: APjAAAUOtmKwLlHvOyCmILla3zGpyCisgMIHzZBuarKrNxHe9BCeV6+W
        TMzEOu6JcEd/QkDzcHvPlnFim2jQRWabz89QFjw=
X-Google-Smtp-Source: APXvYqys/5PUoAJe+X6a6JgO6aiyne8nF8T9en3E395817ZJ1kIeIrjteFy3bHIb7hlImllnPR88MjC1/nD2nfDbfKM=
X-Received: by 2002:a05:6808:8c2:: with SMTP id k2mr3154282oij.98.1562079702002;
 Tue, 02 Jul 2019 08:01:42 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
 <20190702143634.19688-1-i.maximets@samsung.com>
In-Reply-To: <20190702143634.19688-1-i.maximets@samsung.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 2 Jul 2019 17:01:30 +0200
Message-ID: <CAJ8uoz34wS-Ut=TiULN32Zs-terBkzSiEws65jsd=f4S_rp43Q@mail.gmail.com>
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 4:36 PM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Unlike driver mode, generic xdp receive could be triggered
> by different threads on different CPU cores at the same time
> leading to the fill and rx queue breakage. For example, this
> could happen while sending packets from two processes to the
> first interface of veth pair while the second part of it is
> open with AF_XDP socket.
>
> Need to take a lock for each generic receive to avoid race.

Thanks for this catch Ilya. Do you have any performance numbers you
could share of the impact of adding this spin lock? The reason I ask
is that if the impact is negligible, then let us just add it. But if
it is too large, we might want to brain storm about some other
possible solutions.

Thanks: Magnus

> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
>  include/net/xdp_sock.h |  2 ++
>  net/xdp/xsk.c          | 32 +++++++++++++++++++++++---------
>  2 files changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index d074b6d60f8a..ac3c047d058c 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -67,6 +67,8 @@ struct xdp_sock {
>          * in the SKB destructor callback.
>          */
>         spinlock_t tx_completion_lock;
> +       /* Protects generic receive. */
> +       spinlock_t rx_lock;
>         u64 rx_dropped;
>  };
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index a14e8864e4fa..19f41d2b670c 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
>         u32 metalen = xdp->data - xdp->data_meta;
>         u32 len = xdp->data_end - xdp->data;
> +       unsigned long flags;
>         void *buffer;
>         u64 addr;
>         int err;
>
> -       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
> -               return -EINVAL;
> +       spin_lock_irqsave(&xs->rx_lock, flags);
> +
> +       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
> +               err = -EINVAL;
> +               goto out_unlock;
> +       }
>
>         if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>             len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
> -               xs->rx_dropped++;
> -               return -ENOSPC;
> +               err = -ENOSPC;
> +               goto out_drop;
>         }
>
>         addr += xs->umem->headroom;
> @@ -138,13 +143,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>         memcpy(buffer, xdp->data_meta, len + metalen);
>         addr += metalen;
>         err = xskq_produce_batch_desc(xs->rx, addr, len);
> -       if (!err) {
> -               xskq_discard_addr(xs->umem->fq);
> -               xsk_flush(xs);
> -               return 0;
> -       }
> +       if (err)
> +               goto out_drop;
> +
> +       xskq_discard_addr(xs->umem->fq);
> +       xskq_produce_flush_desc(xs->rx);
>
> +       spin_unlock_irqrestore(&xs->rx_lock, flags);
> +
> +       xs->sk.sk_data_ready(&xs->sk);
> +       return 0;
> +
> +out_drop:
>         xs->rx_dropped++;
> +out_unlock:
> +       spin_unlock_irqrestore(&xs->rx_lock, flags);
>         return err;
>  }
>
> @@ -765,6 +778,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>
>         xs = xdp_sk(sk);
>         mutex_init(&xs->mutex);
> +       spin_lock_init(&xs->rx_lock);
>         spin_lock_init(&xs->tx_completion_lock);
>
>         mutex_lock(&net->xdp.lock);
> --
> 2.17.1
>
