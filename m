Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5482A77DE
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgKEHTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgKEHTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 02:19:22 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D2C0613CF;
        Wed,  4 Nov 2020 23:19:22 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f38so754711pgm.2;
        Wed, 04 Nov 2020 23:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1TLgog7JBgHorKNM3wu5oUyqgLdnRdAs11pbRUNSTBw=;
        b=L3f1l1H1g9M6vyiNZZR4pDhuTZwnL5Q+PH/q7i9xri9FLJIIfMK4Sp6Ly3VPONYFcc
         bR8v0k17u3+8Fpqubf79f7dNaAXTg/0JBymxFMKkbPcCi2/pAgVaWYELG8iyW9FNBN1d
         Go1wwOVlaNnZwkC/kvp1FlE9V91LVhgxNwz0PyELvsrVYs+cc1A5TJf8KrmFVf3Q0Dxp
         HlPqCQsGcyUSe796N1DS/i1+ptTF/53LPJtjc7tYg5rrNf79EblAG8gjTdB2nSRL9vcM
         KDzewdwg6mbCQCSaEEQb5CvUgrvbP4vCr0nqc69ZUfprvdcUAWra2U41thsusWuqdevy
         oUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1TLgog7JBgHorKNM3wu5oUyqgLdnRdAs11pbRUNSTBw=;
        b=h3w4gHNXJYvOX/gaDxcPcLK5NV4GSS32xbOFK0c0UQ82o+6PBGuTE0/igxkbWEJA3T
         YwMkkl+8sqaeSJipt7mPGMJuHALX/jogSfTp5kKRR/O1pyl/HP9HHx2i6dwmmQEYNskR
         JOKCIyCr76D7MviHcugzy6Gy2tieXgKei6RgJoZ8EI8wJPx0VQljtK+tEVMdzHNHXG/F
         Kjd5+UkXe/pFMgE1/tgxXHxc0EV+dalGzWg3aqIaVEeREat3iBCwJqKau/RqELGNvN46
         qK+qND70O6W1kHu6+U28jCNeUEhEVCrcyAMBVj0btUTfK5Xa/M+7kFs4AaexoLlgHVnj
         RRdA==
X-Gm-Message-State: AOAM532xiYDXbUs37qDC21wT+1fnwxH8Hvy9XoQLCxS6z4dyEBl58x1t
        OLs+TGm2KBgtvM+E+iNp1wU33Gx6fS6IuqFQXoY=
X-Google-Smtp-Source: ABdhPJz3LEKOTubGfhWi7zbZ4YpD4hVn0AU2fTZyOc0OeVA0nJurOEQnwP6zmKj/hKmVz1OltWRPsV9CA71iIk9RYws=
X-Received: by 2002:aa7:8428:0:b029:18b:b43:6cc with SMTP id
 q8-20020aa784280000b029018b0b4306ccmr1161992pfn.73.1604560762121; Wed, 04 Nov
 2020 23:19:22 -0800 (PST)
MIME-Version: 1.0
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-7-git-send-email-magnus.karlsson@gmail.com> <20201104230122.GA40117@ranger.igk.intel.com>
In-Reply-To: <20201104230122.GA40117@ranger.igk.intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 5 Nov 2020 08:19:11 +0100
Message-ID: <CAJ8uoz1B8GSCSFoOWN8cM=qUczLRqELSjUsoG-K2AcOzKEzEyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/6] i40e: use batched xsk Tx interfaces to
 increase performance
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 12:12 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Nov 04, 2020 at 03:09:02PM +0100, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Use the new batched xsk interfaces for the Tx path in the i40e driver
> > to improve performance. On my machine, this yields a throughput
> > increase of 4% for the l2fwd sample app in xdpsock. If we instead just
> > look at the Tx part, this patch set increases throughput with above
> > 20% for Tx.
> >
> > Note that I had to explicitly loop unroll the inner loop to get to
> > this performance level, by using a pragma. It is honored by both clang
> > and gcc and should be ignored by versions that do not support
> > it. Using the -funroll-loops compiler command line switch on the
> > source file resulted in a loop unrolling on a higher level that
> > lead to a performance decrease instead of an increase.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   2 +-
> >  drivers/net/ethernet/intel/i40e/i40e_main.c    |   4 +-
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  14 ++-
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.h    |   3 +-
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c     | 127 ++++++++++++++++++-------
> >  5 files changed, 110 insertions(+), 40 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> > index 26ba1f3..dc34867 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
> > @@ -2025,7 +2025,7 @@ static int i40e_set_ringparam(struct net_device *netdev,
> >                        */
> >                       tx_rings[i].desc = NULL;
> >                       tx_rings[i].rx_bi = NULL;
> > -                     err = i40e_setup_tx_descriptors(&tx_rings[i]);
> > +                     err = i40e_setup_tx_descriptors(&tx_rings[i], false);
> >                       if (err) {
> >                               while (i) {
> >                                       i--;
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > index 4f8a2154..c93774a 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > @@ -3030,13 +3030,13 @@ static int i40e_vsi_setup_tx_resources(struct i40e_vsi *vsi)
> >       int i, err = 0;
> >
> >       for (i = 0; i < vsi->num_queue_pairs && !err; i++)
> > -             err = i40e_setup_tx_descriptors(vsi->tx_rings[i]);
> > +             err = i40e_setup_tx_descriptors(vsi->tx_rings[i], false);
> >
> >       if (!i40e_enabled_xdp_vsi(vsi))
> >               return err;
> >
> >       for (i = 0; i < vsi->num_queue_pairs && !err; i++)
> > -             err = i40e_setup_tx_descriptors(vsi->xdp_rings[i]);
> > +             err = i40e_setup_tx_descriptors(vsi->xdp_rings[i], true);
>
> One last suggestion: I think that you could just call ring_is_xdp(tx_ring)
> within i40e_setup_tx_descriptors() and based on that allocate the
> xsk_descs array, instead of parametrizing the function. At the time of
> setting up tx descs the I40E_TXR_FLAGS_XDP flag is already set.
>
> I think this would be a cleaner way of doing it.

Yes, good suggestion. Will do that.

> >
> >       return err;
> >  }
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > index d43ce13..3e13e0e 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -676,6 +676,8 @@ void i40e_free_tx_resources(struct i40e_ring *tx_ring)
> >       i40e_clean_tx_ring(tx_ring);
> >       kfree(tx_ring->tx_bi);
> >       tx_ring->tx_bi = NULL;
> > +     kfree(tx_ring->xsk_descs);
> > +     tx_ring->xsk_descs = NULL;
> >
> >       if (tx_ring->desc) {
> >               dma_free_coherent(tx_ring->dev, tx_ring->size,
> > @@ -1259,10 +1261,11 @@ void i40e_clean_programming_status(struct i40e_ring *rx_ring, u64 qword0_raw,
> >  /**
> >   * i40e_setup_tx_descriptors - Allocate the Tx descriptors
> >   * @tx_ring: the tx ring to set up
> > + * @xdp_ring: true if this is an XDP Tx ring
> >   *
> >   * Return 0 on success, negative on error
> >   **/
> > -int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
> > +int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring, bool xdp_ring)
> >  {
> >       struct device *dev = tx_ring->dev;
> >       int bi_size;
> > @@ -1277,6 +1280,13 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
> >       if (!tx_ring->tx_bi)
> >               goto err;
> >
> > +     if (xdp_ring) {
> > +             tx_ring->xsk_descs = kcalloc(I40E_MAX_NUM_DESCRIPTORS, sizeof(*tx_ring->xsk_descs),
> > +                                          GFP_KERNEL);
> > +             if (!tx_ring->xsk_descs)
> > +                     goto err;
> > +     }
> > +
> >       u64_stats_init(&tx_ring->syncp);
> >
> >       /* round up to nearest 4K */
> > @@ -1300,6 +1310,8 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
> >       return 0;
> >
> >  err:
> > +     kfree(tx_ring->xsk_descs);
> > +     tx_ring->xsk_descs = NULL;
> >       kfree(tx_ring->tx_bi);
> >       tx_ring->tx_bi = NULL;
> >       return -ENOMEM;
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > index 2feed92..628d5d7 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > @@ -389,6 +389,7 @@ struct i40e_ring {
> >       struct i40e_channel *ch;
> >       struct xdp_rxq_info xdp_rxq;
> >       struct xsk_buff_pool *xsk_pool;
> > +     struct xdp_desc *xsk_descs;      /* For storing descriptors in the AF_XDP ZC path */
> >  } ____cacheline_internodealigned_in_smp;
> >
> >  static inline bool ring_uses_build_skb(struct i40e_ring *ring)
> > @@ -451,7 +452,7 @@ bool i40e_alloc_rx_buffers(struct i40e_ring *rxr, u16 cleaned_count);
> >  netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
> >  void i40e_clean_tx_ring(struct i40e_ring *tx_ring);
> >  void i40e_clean_rx_ring(struct i40e_ring *rx_ring);
> > -int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring);
> > +int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring, bool xdp_ring);
> >  int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring);
> >  void i40e_free_tx_resources(struct i40e_ring *tx_ring);
> >  void i40e_free_rx_resources(struct i40e_ring *rx_ring);
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index eabe1a3..515d856 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -383,6 +383,78 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
> >       return failure ? budget : (int)total_rx_packets;
> >  }
> >
> > +static void i40e_xmit_pkt(struct i40e_ring *xdp_ring, struct xdp_desc *desc,
> > +                       unsigned int *total_bytes)
> > +{
> > +     struct i40e_tx_desc *tx_desc;
> > +     dma_addr_t dma;
> > +
> > +     dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc->addr);
> > +     xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc->len);
> > +
> > +     tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use++);
> > +     tx_desc->buffer_addr = cpu_to_le64(dma);
> > +     tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC | I40E_TX_DESC_CMD_EOP,
> > +                                               0, desc->len, 0);
> > +
> > +     *total_bytes += desc->len;
> > +}
> > +
> > +/* This value should match the pragma below. Why 4? It is strictly
> > + * empirical. It seems to be a good compromise between the advantage
> > + * of having simultaneous outstanding reads to the DMA array that can
> > + * hide each others latency and the disadvantage of having a larger
> > + * code path.
> > + */
> > +#define PKTS_PER_BATCH 4
> > +
> > +static void i40e_xmit_pkt_batch(struct i40e_ring *xdp_ring, struct xdp_desc *desc,
> > +                             unsigned int *total_bytes)
> > +{
> > +     u16 ntu = xdp_ring->next_to_use;
> > +     struct i40e_tx_desc *tx_desc;
> > +     dma_addr_t dma;
> > +     u32 i;
> > +
> > +#pragma GCC unroll 4
> > +     for (i = 0; i < PKTS_PER_BATCH; i++) {
> > +             dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc[i].addr);
> > +             xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc[i].len);
> > +
> > +             tx_desc = I40E_TX_DESC(xdp_ring, ntu++);
> > +             tx_desc->buffer_addr = cpu_to_le64(dma);
> > +             tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC |
> > +                                                       I40E_TX_DESC_CMD_EOP,
> > +                                                       0, desc[i].len, 0);
> > +
> > +             *total_bytes += desc[i].len;
> > +     }
> > +
> > +     xdp_ring->next_to_use = ntu;
> > +}
> > +
> > +static void i40e_fill_tx_hw_ring(struct i40e_ring *xdp_ring, struct xdp_desc *descs, u32 nb_pkts,
> > +                              unsigned int *total_bytes)
> > +{
> > +     u32 batched, leftover, i;
> > +
> > +     batched = nb_pkts & ~(PKTS_PER_BATCH - 1);
> > +     leftover = nb_pkts & (PKTS_PER_BATCH - 1);
> > +     for (i = 0; i < batched; i += PKTS_PER_BATCH)
> > +             i40e_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
> > +     for (i = batched; i < batched + leftover; i++)
> > +             i40e_xmit_pkt(xdp_ring, &descs[i], total_bytes);
> > +}
> > +
> > +static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
> > +{
> > +     u16 ntu = xdp_ring->next_to_use ? xdp_ring->next_to_use - 1 : xdp_ring->count - 1;
> > +     struct i40e_tx_desc *tx_desc;
> > +
> > +     tx_desc = I40E_TX_DESC(xdp_ring, ntu);
> > +     tx_desc->cmd_type_offset_bsz |= (I40E_TX_DESC_CMD_RS << I40E_TXD_QW1_CMD_SHIFT);
> > +}
> > +
> >  /**
> >   * i40e_xmit_zc - Performs zero-copy Tx AF_XDP
> >   * @xdp_ring: XDP Tx ring
> > @@ -392,45 +464,30 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
> >   **/
> >  static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >  {
> > -     unsigned int sent_frames = 0, total_bytes = 0;
> > -     struct i40e_tx_desc *tx_desc = NULL;
> > -     struct xdp_desc desc;
> > -     dma_addr_t dma;
> > -
> > -     while (budget-- > 0) {
> > -             if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
> > -                     break;
> > -
> > -             dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
> > -             xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
> > -                                              desc.len);
> > -
> > -             tx_desc = I40E_TX_DESC(xdp_ring, xdp_ring->next_to_use);
> > -             tx_desc->buffer_addr = cpu_to_le64(dma);
> > -             tx_desc->cmd_type_offset_bsz =
> > -                     build_ctob(I40E_TX_DESC_CMD_ICRC
> > -                                | I40E_TX_DESC_CMD_EOP,
> > -                                0, desc.len, 0);
> > -
> > -             sent_frames++;
> > -             total_bytes += desc.len;
> > -
> > -             xdp_ring->next_to_use++;
> > -             if (xdp_ring->next_to_use == xdp_ring->count)
> > -                     xdp_ring->next_to_use = 0;
> > +     struct xdp_desc *descs = xdp_ring->xsk_descs;
> > +     u32 nb_pkts, nb_processed = 0;
> > +     unsigned int total_bytes = 0;
> > +
> > +     nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
> > +     if (!nb_pkts)
> > +             return false;
> > +
> > +     if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> > +             nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> > +             i40e_fill_tx_hw_ring(xdp_ring, descs, nb_processed, &total_bytes);
> > +             xdp_ring->next_to_use = 0;
> >       }
> >
> > -     if (tx_desc) {
> > -             /* Request an interrupt for the last frame and bump tail ptr. */
> > -             tx_desc->cmd_type_offset_bsz |= (I40E_TX_DESC_CMD_RS <<
> > -                                              I40E_TXD_QW1_CMD_SHIFT);
> > -             i40e_xdp_ring_update_tail(xdp_ring);
> > +     i40e_fill_tx_hw_ring(xdp_ring, &descs[nb_processed], nb_pkts - nb_processed,
> > +                          &total_bytes);
> >
> > -             xsk_tx_release(xdp_ring->xsk_pool);
> > -             i40e_update_tx_stats(xdp_ring, sent_frames, total_bytes);
> > -     }
> > +     /* Request an interrupt for the last frame and bump tail ptr. */
> > +     i40e_set_rs_bit(xdp_ring);
> > +     i40e_xdp_ring_update_tail(xdp_ring);
> > +
> > +     i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
> >
> > -     return !!budget;
> > +     return true;
> >  }
> >
> >  /**
> > --
> > 2.7.4
> >
