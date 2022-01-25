Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1A249B088
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574939AbiAYJhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574242AbiAYJcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:32:47 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD88C061753;
        Tue, 25 Jan 2022 01:32:47 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i1so993718pla.9;
        Tue, 25 Jan 2022 01:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63HA8FY2z2rbqrZsG0tnfarpNQDSSnnXJNtyh7ce5kg=;
        b=acp2vVqsraBqJdCAWjPmUdLRbPuOjg0SU/zaccYDzB9Q/kc7JVXkhTlHXY/pNXD5mD
         sOGX6zBgK3E4jpL4Gls4OaIXq0nU4JTzxdnJ4NXyyF8ya5qa8CWFjircAxb2Ahf2nNol
         hc6KawT3j81jqbqICGriwhwN2LbbXLnUn6k7MnRZloqPT3aeRw5dtfbepXJgHB//5TNR
         3dMl8ji9532z+N37Fu+ofmlejyzF97+vAT1WARWfvQ6oajKYtfCJk6Evjxrg1kx80qQN
         HleOI48BUUjE1jHYlG/7AFgAKlBbYzecTPMBj7oErPUDBMeYL7okGcjbhelNJpk/TDR7
         uF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63HA8FY2z2rbqrZsG0tnfarpNQDSSnnXJNtyh7ce5kg=;
        b=4d7QpV4BtAP6qvjj1paxORi5s9g9pytHD4WbvQ6ne6eu4RcQ0hQBow8uLQHWNrJr54
         cYUam39saybPH4pU2LQJniD+fzxPcLR3qik5wfhYowS0lgvkV/YMU9kuqHGmTKC61+CH
         w+RkTw6pYThHX5sy8l5aoH8k3GcYtcO1mbMnRNpYK6XEAh+ECwewUutaLWPQU1MlVTOH
         0T9Fw1nrQ0vnErNpHHQBH++Nof1rXXGfohVQ+T+QPbX56W++HmRJ0ViiutaVY9J6MEm4
         61CgLmZQr4LevqnOt5wWwqTWDWwFPqiYz+iW8FVvuTCDeClr7H8JvuYWxW6sSN2sYCfo
         /OKg==
X-Gm-Message-State: AOAM533a0T7STwv/ZM4qOVy0VYCijW8t9vUx6gJerGVag2iVSBfXFiwq
        GIiT1NwlMP6A350xEIW3APCQnwUlNvzlBxFIr2X2mTyLBQZHj6YH
X-Google-Smtp-Source: ABdhPJw1f6JKjKqsFJWwV6a78F/BUeKx0RYMz/5ASyzPdFnfbdvtauGWTJ7/rKBOxyCEG20PGzTJJTRt2NrPDSWsz+M=
X-Received: by 2002:a17:90a:4482:: with SMTP id t2mr2577026pjg.133.1643103166451;
 Tue, 25 Jan 2022 01:32:46 -0800 (PST)
MIME-Version: 1.0
References: <20220124165547.74412-1-maciej.fijalkowski@intel.com> <20220124165547.74412-8-maciej.fijalkowski@intel.com>
In-Reply-To: <20220124165547.74412-8-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 25 Jan 2022 10:32:35 +0100
Message-ID: <CAJ8uoz1KRjks7k-tVQoZAHScrmqEhUQJqs5_L_gJX8PnY=VCwg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 7/8] ice: xsk: improve AF_XDP ZC Tx and use
 batching API
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 8:38 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Apply the logic that was done for regular XDP from commit 9610bd988df9
> ("ice: optimize XDP_TX workloads") to the ZC side of the driver. On top
> of that, introduce batching to Tx that is inspired by i40e's
> implementation with adjustments to the cleaning logic - take into the
> account NAPI budget in ice_clean_xdp_irq_zc().
>
> Separating the stats structs onto separate cache lines seemed to improve
> the performance.

Nice one, thanks! Just one smaller comment below.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.h |   2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c  | 256 ++++++++++++++--------
>  drivers/net/ethernet/intel/ice/ice_xsk.h  |  27 ++-
>  4 files changed, 188 insertions(+), 99 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index 73f60493209d..7d8824b4c8ff 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -1462,7 +1462,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
>                 bool wd;
>
>                 if (tx_ring->xsk_pool)
> -                       wd = ice_clean_tx_irq_zc(tx_ring, budget);
> +                       wd = ice_xmit_zc(tx_ring, ICE_DESC_UNUSED(tx_ring), budget);
>                 else if (ice_ring_is_xdp(tx_ring))
>                         wd = true;
>                 else
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
> index 611dd7c4a631..ea6c9cc02a1a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -322,9 +322,9 @@ struct ice_tx_ring {
>         u16 count;                      /* Number of descriptors */
>         u16 q_index;                    /* Queue number of ring */
>         /* stats structs */
> +       struct ice_txq_stats tx_stats;
>         struct ice_q_stats      stats;
>         struct u64_stats_sync syncp;
> -       struct ice_txq_stats tx_stats;
>
>         /* CL3 - 3rd cacheline starts here */
>         struct rcu_head rcu;            /* to avoid race on free */

Seems like these comments are wrong these days. Your move indeed moves
the tx_stats to another cache line as seen in the pahole dump below,
but that is not obvious with the comments that point to the opposite.
Maybe update the cacheline start comments to the correct locations?

<snip>
u16                        q_index;              /*    94     2 */
struct ice_txq_stats       tx_stats;             /*    96    32 */

/* XXX last struct has 4 bytes of padding */

/* --- cacheline 2 boundary (128 bytes) --- */
struct ice_q_stats         stats;                /*   128    16 */
struct u64_stats_sync      syncp;                /*   144     0 */
struct callback_head       rcu __attribute__((__aligned__(8))); /*
144    16 */
long unsigned int          xps_state[1];         /*   160     8 */
<snip>

> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 8c82093fc8ec..7225c3d0b6d0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -680,134 +680,212 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
>  }
>
>  /**
> - * ice_xmit_zc - Completes AF_XDP entries, and cleans XDP entries
> + * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
>   * @xdp_ring: XDP Tx ring
> - * @budget: max number of frames to xmit
> + * @tx_buf: Tx buffer to clean
> + */
> +static void
> +ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
> +{
> +       xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> +       dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
> +                        dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
> +       dma_unmap_len_set(tx_buf, len, 0);
> +}
> +
> +/**
> + * ice_clean_xdp_irq_zc - Reclaim resources after transmit completes on XDP ring
> + * @xdp_ring: XDP ring to clean
> + * @napi_budget: amount of descriptors that NAPI allows us to clean
>   *
> - * Returns true if cleanup/transmission is done.
> + * Returns count of cleaned descriptors
>   */
> -static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
> +static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
>  {
> -       struct ice_tx_desc *tx_desc = NULL;
> -       bool work_done = true;
> -       struct xdp_desc desc;
> -       dma_addr_t dma;
> +       u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
> +       int budget = napi_budget / tx_thresh;
> +       u16 ntc = xdp_ring->next_to_clean;
> +       u16 next_dd = xdp_ring->next_dd;
> +       u16 cleared_dds = 0;
>
> -       while (likely(budget-- > 0)) {
> +       do {
> +               struct ice_tx_desc *next_dd_desc;
> +               u16 desc_cnt = xdp_ring->count;
>                 struct ice_tx_buf *tx_buf;
> +               u32 xsk_frames;
> +               u16 i;
>
> -               if (unlikely(!ICE_DESC_UNUSED(xdp_ring))) {
> -                       xdp_ring->tx_stats.tx_busy++;
> -                       work_done = false;
> -                       break;
> -               }
> -
> -               tx_buf = &xdp_ring->tx_buf[xdp_ring->next_to_use];
> -
> -               if (!xsk_tx_peek_desc(xdp_ring->xsk_pool, &desc))
> +               next_dd_desc = ICE_TX_DESC(xdp_ring, next_dd);
> +               if (!(next_dd_desc->cmd_type_offset_bsz &
> +                   cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
>                         break;
>
> -               dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc.addr);
> -               xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma,
> -                                                desc.len);
> +               cleared_dds++;
> +               xsk_frames = 0;
>
> -               tx_buf->bytecount = desc.len;
> +               for (i = 0; i < tx_thresh; i++) {
> +                       tx_buf = &xdp_ring->tx_buf[ntc];
>
> -               tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
> -               tx_desc->buf_addr = cpu_to_le64(dma);
> -               tx_desc->cmd_type_offset_bsz =
> -                       ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
> +                       if (tx_buf->raw_buf) {
> +                               ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
> +                               tx_buf->raw_buf = NULL;
> +                       } else {
> +                               xsk_frames++;
> +                       }
>
> -               xdp_ring->next_to_use++;
> -               if (xdp_ring->next_to_use == xdp_ring->count)
> -                       xdp_ring->next_to_use = 0;
> -       }
> +                       ntc++;
> +                       if (ntc >= xdp_ring->count)
> +                               ntc = 0;
> +               }
> +               if (xsk_frames)
> +                       xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
> +               next_dd_desc->cmd_type_offset_bsz = 0;
> +               next_dd = next_dd + tx_thresh;
> +               if (next_dd >= desc_cnt)
> +                       next_dd = tx_thresh - 1;
> +       } while (budget--);
>
> -       if (tx_desc) {
> -               ice_xdp_ring_update_tail(xdp_ring);
> -               xsk_tx_release(xdp_ring->xsk_pool);
> -       }
> +       xdp_ring->next_to_clean = ntc;
> +       xdp_ring->next_dd = next_dd;
>
> -       return budget > 0 && work_done;
> +       return cleared_dds * tx_thresh;
>  }
>
>  /**
> - * ice_clean_xdp_tx_buf - Free and unmap XDP Tx buffer
> - * @xdp_ring: XDP Tx ring
> - * @tx_buf: Tx buffer to clean
> + * ice_xmit_pkt - produce a single HW Tx descriptor out of AF_XDP descriptor
> + * @xdp_ring: XDP ring to produce the HW Tx descriptor on
> + * @desc: AF_XDP descriptor to pull the DMA address and length from
> + * @total_bytes: bytes accumulator that will be used for stats update
>   */
> -static void
> -ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
> +static void ice_xmit_pkt(struct ice_tx_ring *xdp_ring, struct xdp_desc *desc,
> +                        unsigned int *total_bytes)
>  {
> -       xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
> -       dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
> -                        dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
> -       dma_unmap_len_set(tx_buf, len, 0);
> +       struct ice_tx_desc *tx_desc;
> +       dma_addr_t dma;
> +
> +       dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, desc->addr);
> +       xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, desc->len);
> +
> +       tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use++);
> +       tx_desc->buf_addr = cpu_to_le64(dma);
> +       tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
> +                                                     0, desc->len, 0);
> +
> +       *total_bytes += desc->len;
>  }
>
>  /**
> - * ice_clean_tx_irq_zc - Completes AF_XDP entries, and cleans XDP entries
> - * @xdp_ring: XDP Tx ring
> - * @budget: NAPI budget
> - *
> - * Returns true if cleanup/tranmission is done.
> + * ice_xmit_pkt_batch - produce a batch of HW Tx descriptors out of AF_XDP descriptors
> + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> + * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
> + * @total_bytes: bytes accumulator that will be used for stats update
>   */
> -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
> +static void ice_xmit_pkt_batch(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
> +                              unsigned int *total_bytes)
>  {
> -       int total_packets = 0, total_bytes = 0;
> -       s16 ntc = xdp_ring->next_to_clean;
> +       u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
> +       u16 ntu = xdp_ring->next_to_use;
>         struct ice_tx_desc *tx_desc;
> -       struct ice_tx_buf *tx_buf;
> -       u32 xsk_frames = 0;
> -       bool xmit_done;
> +       u32 i;
>
> -       tx_desc = ICE_TX_DESC(xdp_ring, ntc);
> -       tx_buf = &xdp_ring->tx_buf[ntc];
> -       ntc -= xdp_ring->count;
> +       loop_unrolled_for(i = 0; i < PKTS_PER_BATCH; i++) {
> +               dma_addr_t dma;
>
> -       do {
> -               if (!(tx_desc->cmd_type_offset_bsz &
> -                     cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
> -                       break;
> +               dma = xsk_buff_raw_get_dma(xdp_ring->xsk_pool, descs[i].addr);
> +               xsk_buff_raw_dma_sync_for_device(xdp_ring->xsk_pool, dma, descs[i].len);
>
> -               total_bytes += tx_buf->bytecount;
> -               total_packets++;
> +               tx_desc = ICE_TX_DESC(xdp_ring, ntu++);
> +               tx_desc->buf_addr = cpu_to_le64(dma);
> +               tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TX_DESC_CMD_EOP,
> +                                                             0, descs[i].len, 0);
>
> -               if (tx_buf->raw_buf) {
> -                       ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
> -                       tx_buf->raw_buf = NULL;
> -               } else {
> -                       xsk_frames++;
> -               }
> +               *total_bytes += descs[i].len;
> +       }
>
> -               tx_desc->cmd_type_offset_bsz = 0;
> -               tx_buf++;
> -               tx_desc++;
> -               ntc++;
> +       xdp_ring->next_to_use = ntu;
>
> -               if (unlikely(!ntc)) {
> -                       ntc -= xdp_ring->count;
> -                       tx_buf = xdp_ring->tx_buf;
> -                       tx_desc = ICE_TX_DESC(xdp_ring, 0);
> -               }
> +       if (xdp_ring->next_to_use > xdp_ring->next_rs) {
> +               tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> +               tx_desc->cmd_type_offset_bsz |=
> +                       cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> +               xdp_ring->next_rs += tx_thresh;
> +       }
> +}
>
> -               prefetch(tx_desc);
> +/**
> + * ice_fill_tx_hw_ring - produce the number of Tx descriptors onto ring
> + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> + * @descs: AF_XDP descriptors to pull the DMA addresses and lengths from
> + * @nb_pkts: count of packets to be send
> + * @total_bytes: bytes accumulator that will be used for stats update
> + */
> +static void ice_fill_tx_hw_ring(struct ice_tx_ring *xdp_ring, struct xdp_desc *descs,
> +                               u32 nb_pkts, unsigned int *total_bytes)
> +{
> +       u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
> +       u32 batched, leftover, i;
> +
> +       batched = ALIGN_DOWN(nb_pkts, PKTS_PER_BATCH);
> +       leftover = nb_pkts & (PKTS_PER_BATCH - 1);
> +       for (i = 0; i < batched; i += PKTS_PER_BATCH)
> +               ice_xmit_pkt_batch(xdp_ring, &descs[i], total_bytes);
> +       for (; i < batched + leftover; i++)
> +               ice_xmit_pkt(xdp_ring, &descs[i], total_bytes);
> +
> +       if (xdp_ring->next_to_use > xdp_ring->next_rs) {
> +               struct ice_tx_desc *tx_desc;
> +
> +               tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> +               tx_desc->cmd_type_offset_bsz |=
> +                       cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> +               xdp_ring->next_rs += tx_thresh;
> +       }
> +}
>
> -       } while (likely(--budget));
> +/**
> + * ice_xmit_zc - take entries from XSK Tx ring and place them onto HW Tx ring
> + * @xdp_ring: XDP ring to produce the HW Tx descriptors on
> + * @budget: number of free descriptors on HW Tx ring that can be used
> + * @napi_budget: amount of descriptors that NAPI allows us to clean
> + *
> + * Returns true if there is no more work that needs to be done, false otherwise
> + */
> +bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget)
> +{
> +       struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
> +       u16 tx_thresh = ICE_RING_QUARTER(xdp_ring);
> +       u32 nb_pkts, nb_processed = 0;
> +       unsigned int total_bytes = 0;
> +
> +       if (budget < tx_thresh)
> +               budget += ice_clean_xdp_irq_zc(xdp_ring, napi_budget);
> +
> +       nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
> +       if (!nb_pkts)
> +               return true;
> +
> +       if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
> +               struct ice_tx_desc *tx_desc;
> +
> +               nb_processed = xdp_ring->count - xdp_ring->next_to_use;
> +               ice_fill_tx_hw_ring(xdp_ring, descs, nb_processed, &total_bytes);
> +               tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_rs);
> +               tx_desc->cmd_type_offset_bsz |=
> +                       cpu_to_le64(ICE_TX_DESC_CMD_RS << ICE_TXD_QW1_CMD_S);
> +               xdp_ring->next_rs = tx_thresh - 1;
> +               xdp_ring->next_to_use = 0;
> +       }
>
> -       ntc += xdp_ring->count;
> -       xdp_ring->next_to_clean = ntc;
> +       ice_fill_tx_hw_ring(xdp_ring, &descs[nb_processed], nb_pkts - nb_processed,
> +                           &total_bytes);
>
> -       if (xsk_frames)
> -               xsk_tx_completed(xdp_ring->xsk_pool, xsk_frames);
> +       ice_xdp_ring_update_tail(xdp_ring);
> +       ice_update_tx_ring_stats(xdp_ring, nb_pkts, total_bytes);
>
>         if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
>                 xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);
>
> -       ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
> -       xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);
> -
> -       return budget > 0 && xmit_done;
> +       return nb_pkts < budget;
>  }
>
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
> index 4c7bd8e9dfc4..0cbb5793b5b8 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.h
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
> @@ -6,19 +6,37 @@
>  #include "ice_txrx.h"
>  #include "ice.h"
>
> +#define PKTS_PER_BATCH 8
> +
> +#ifdef __clang__
> +#define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
> +#elif __GNUC__ >= 4
> +#define loop_unrolled_for _Pragma("GCC unroll 8") for
> +#else
> +#define loop_unrolled_for for
> +#endif
> +
>  struct ice_vsi;
>
>  #ifdef CONFIG_XDP_SOCKETS
>  int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool,
>                        u16 qid);
>  int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget);
> -bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget);
>  int ice_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
>  bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count);
>  bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi);
>  void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring);
>  void ice_xsk_clean_xdp_ring(struct ice_tx_ring *xdp_ring);
> +bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, u32 budget, int napi_budget);
>  #else
> +static inline bool
> +ice_xmit_zc(struct ice_tx_ring __always_unused *xdp_ring,
> +           u32 __always_unused budget,
> +           int __always_unused napi_budget)
> +{
> +       return false;
> +}
> +
>  static inline int
>  ice_xsk_pool_setup(struct ice_vsi __always_unused *vsi,
>                    struct xsk_buff_pool __always_unused *pool,
> @@ -34,13 +52,6 @@ ice_clean_rx_irq_zc(struct ice_rx_ring __always_unused *rx_ring,
>         return 0;
>  }
>
> -static inline bool
> -ice_clean_tx_irq_zc(struct ice_tx_ring __always_unused *xdp_ring,
> -                   int __always_unused budget)
> -{
> -       return false;
> -}
> -
>  static inline bool
>  ice_alloc_rx_bufs_zc(struct ice_rx_ring __always_unused *rx_ring,
>                      u16 __always_unused count)
> --
> 2.33.1
>
