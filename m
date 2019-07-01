Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723BF5BA47
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfGALET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:04:19 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39098 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfGALET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 07:04:19 -0400
Received: by mail-oi1-f193.google.com with SMTP id m202so9599102oig.6
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 04:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vv0b/07n+8zSUsZe0LzS6WSjsQlP6DK/ftc6/hhnOKM=;
        b=ny33PSAWdczoex/IjqObuT9jZ4U7RT+s4jycYXNAzdtuj2+ZGODyGEnxcZF4OuEPdP
         abkZ2pF1fIBRRR5gb+cB0ehd9V2Z/tkhhSFUTQaa6WVJjKr2vxjTzLlMxZTKOcRE+eFq
         6XFs/sb8xxTsY56m6wx09YGGjA2BBghJNNGPF6QBLBrYgBGHHlrPfeo1IF+15zOluO8y
         rkh+YhDjb6vbAReHYB67h8icF3f21uCoa18jeFXfGjjIivJwz2kUoJ0/xuvd0eH8KnW6
         ARpAkPgc6ZfLF65+lp6IlqiMXD1ZRhn97M/JIEh0wuAuljvGBkvtN8RCHLBmOFd2/IWC
         TPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vv0b/07n+8zSUsZe0LzS6WSjsQlP6DK/ftc6/hhnOKM=;
        b=tXXAsTnpbNknJq1qpP/W1tE4D+6HvWy8OVERykGCtjp1KXfriiY7/3SxwwWDg4DS1M
         UmcIHNHs15symNFrk46RaLCRbP64dGqu3fptySOqlhgbcBDerQc6+dRdrmPdwVWZjE6L
         OameAZUxaiUh5XuqOG/0oTlPJeyG5pSd6WK2N9JY525hDUrDG6qLDttUVgT0eRKFXZje
         UbtCSimcgvEOB7cQWqu45/+5zdZTjwwjuyzo61TbpnnpknOp2AShFqrUOl42if5L/1sb
         G/Ewm2uhhs+WV6XfRREz7Va4Se9xcAWCkMlhUhsae/kZp2LfbckvDh522WWSxr7b8PGH
         EnEw==
X-Gm-Message-State: APjAAAWSleRp+pk7sBlLqbdBxSO2BjIKDQVItabEUKsyU5LDmswpE1JM
        pXy0xOpBmeFlnYm+e8Wj+bGofGUN2XBmIeI7TXo=
X-Google-Smtp-Source: APXvYqzRO7d4LtTvnq+tvajQxnOLYwEIBoqMN5h9kcgG17vl0nH4iDvkMG24SYtYht4jbfc26CNzRdS8qrYOWKJinXo=
X-Received: by 2002:aca:f441:: with SMTP id s62mr6495122oih.109.1561979058752;
 Mon, 01 Jul 2019 04:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com> <20190628221555.3009654-3-jonathan.lemon@gmail.com>
In-Reply-To: <20190628221555.3009654-3-jonathan.lemon@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 1 Jul 2019 13:04:07 +0200
Message-ID: <CAJ8uoz0EL9gx87JmhjBmYscx-J2UCYK73OV73T3eohOEp0BEUw@mail.gmail.com>
Subject: Re: [PATCH 2/3 bpf-next] i40e: Support zero-copy XDP_TX on the RX
 path for AF_XDP sockets.
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        jeffrey.t.kirsher@intel.com, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 12:18 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> When the XDP program attached to a zero-copy AF_XDP socket returns XDP_TX,
> queue the umem frame on the XDP TX ring.  Space on the recycle stack is
> pre-allocated when the xsk is created.  (taken from tx_ring, since the
> xdp ring is not initialized yet)
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 54 +++++++++++++++++++--
>  2 files changed, 51 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> index 100e92d2982f..3e7954277737 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> @@ -274,6 +274,7 @@ static inline unsigned int i40e_txd_use_count(unsigned int size)
>  #define I40E_TX_FLAGS_TSYN             BIT(8)
>  #define I40E_TX_FLAGS_FD_SB            BIT(9)
>  #define I40E_TX_FLAGS_UDP_TUNNEL       BIT(10)
> +#define I40E_TX_FLAGS_ZC_FRAME         BIT(11)
>  #define I40E_TX_FLAGS_VLAN_MASK                0xffff0000
>  #define I40E_TX_FLAGS_VLAN_PRIO_MASK   0xe0000000
>  #define I40E_TX_FLAGS_VLAN_PRIO_SHIFT  29
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> index ce8650d06962..020f9859215d 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -91,7 +91,8 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
>             qid >= netdev->real_num_tx_queues)
>                 return -EINVAL;
>
> -       if (!xsk_umem_recycle_alloc(umem, vsi->rx_rings[0]->count))
> +       if (!xsk_umem_recycle_alloc(umem, vsi->rx_rings[0]->count +
> +                                         vsi->tx_rings[0]->count))
>                 return -ENOMEM;
>
>         err = i40e_xsk_umem_dma_map(vsi, umem);
> @@ -175,6 +176,48 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
>                 i40e_xsk_umem_disable(vsi, qid);
>  }
>
> +static int i40e_xmit_rcvd_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)

This function looks very much like i40e_xmit_xdp_ring(). How can we
refactor them to make them share more code and not lose performance at
the same time? This comment is also valid for the ixgbe driver patch
that follows.

Thanks: Magnus

> +{
> +       struct i40e_ring *xdp_ring;
> +       struct i40e_tx_desc *tx_desc;
> +       struct i40e_tx_buffer *tx_bi;
> +       struct xdp_frame *xdpf;
> +       dma_addr_t dma;
> +
> +       xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
> +
> +       if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
> +               xdp_ring->tx_stats.tx_busy++;
> +               return I40E_XDP_CONSUMED;
> +       }
> +       xdpf = convert_to_xdp_frame_keep_zc(xdp);
> +       if (unlikely(!xdpf))
> +               return I40E_XDP_CONSUMED;
> +       xdpf->handle = xdp->handle;
> +
> +       dma = xdp_umem_get_dma(rx_ring->xsk_umem, xdp->handle);
> +       tx_bi = &xdp_ring->tx_bi[xdp_ring->next_to_use];
> +       tx_bi->bytecount = xdpf->len;
> +       tx_bi->gso_segs = 1;
> +       tx_bi->xdpf = xdpf;
> +       tx_bi->tx_flags = I40E_TX_FLAGS_ZC_FRAME;
> +
> +       tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
> +       tx_desc->buffer_addr = cpu_to_le64(dma);
> +       tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC |
> +                                                 I40E_TX_DESC_CMD_EOP,
> +                                                 0, xdpf->len, 0);
> +       smp_wmb();
> +
> +       xdp_ring->next_to_use++;
> +       if (xdp_ring->next_to_use == xdp_ring->count)
> +               xdp_ring->next_to_use = 0;
> +
> +       tx_bi->next_to_watch = tx_desc;
> +
> +       return I40E_XDP_TX;
> +}
> +
>  /**
>   * i40e_run_xdp_zc - Executes an XDP program on an xdp_buff
>   * @rx_ring: Rx ring
> @@ -187,7 +230,6 @@ int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
>  static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
>  {
>         int err, result = I40E_XDP_PASS;
> -       struct i40e_ring *xdp_ring;
>         struct bpf_prog *xdp_prog;
>         u32 act;
>
> @@ -202,8 +244,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
>         case XDP_PASS:
>                 break;
>         case XDP_TX:
> -               xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->queue_index];
> -               result = i40e_xmit_xdp_tx_ring(xdp, xdp_ring);
> +               result = i40e_xmit_rcvd_zc(rx_ring, xdp);
>                 break;
>         case XDP_REDIRECT:
>                 err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
> @@ -628,6 +669,11 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
>  static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
>                                      struct i40e_tx_buffer *tx_bi)
>  {
> +       if (tx_bi->tx_flags & I40E_TX_FLAGS_ZC_FRAME) {
> +               xsk_umem_recycle_addr(tx_ring->xsk_umem, tx_bi->xdpf->handle);
> +               tx_bi->tx_flags = 0;
> +               return;
> +       }
>         xdp_return_frame(tx_bi->xdpf);
>         dma_unmap_single(tx_ring->dev,
>                          dma_unmap_addr(tx_bi, dma),
> --
> 2.17.1
>
