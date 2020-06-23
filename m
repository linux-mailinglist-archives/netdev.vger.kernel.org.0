Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163EB2048ED
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgFWFCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728622AbgFWFCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 01:02:49 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3949AC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 22:02:48 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id d64so1821977vke.4
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 22:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQt+AGRJghmCR4VSGJk0DwGPgHtH5mpNDvt/7Fx7waw=;
        b=SMNlMhHZ1M88j+h7fjI9ajjdSOJpQAe9DvUKGtNkLM8oGNJeSKdh8rdQeneo1dyGBp
         QUxD7BU8yBispBN2EToR5/ZjkbBNzRizcF0npE/2imp7R4vDLLbIt9ChiCDsxmQwifnl
         ThYpeyLF9iWBmaxsS0roF65DLSZBGijAnSvQSgl/f8wOTmxVS3gFUI4UJ6njk7rB4B6+
         mfnMePg3ky70qkuQLvGO+FrUDsiYYOQFxm/GUdVq5NW475NpfueKy8231a7BiiA7uua0
         LcLm2+dgMXbCZFiJj2qMwzdKp2kjXLi9tDkFrk63dfaVqEWKBiDGmCwdWuiZD/cyr3qU
         qjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQt+AGRJghmCR4VSGJk0DwGPgHtH5mpNDvt/7Fx7waw=;
        b=VFSiKUk46yte1qOk7Epv7T94HFXFI+aOehlWqo3qc2zWC9bmx/tgdKEbcyV2+r1Svi
         jl/KmbYz9+pc8ol2L2SHVi7UpUkM5tnTc5XeIymvJOfYmPua7rfRq12PUl95ZWquDpKr
         F3BXpMzXR2s1BgJytyjtrYEqi7oj6Iak/MEgBCaHBu7HtkLlNdbNngSGeSmT5Kwl9MEg
         hkk0npfGgK7oDpv0nWO+hy/3EAM/CcIULQViOlrM5EGk2EqZsb5HjYF2WodVdHViqql7
         hvSdgMKfgFiYDuBZZuFqZN62B34uI55Hi6QMiRBOK634mng+duKybvtOlQ3PsNWKnxDO
         N/cA==
X-Gm-Message-State: AOAM532oMWR94Y42ZC0zf0kVJXB8nCTqLmieYoWebC6/cuXIz1ba6HIU
        1811fYWhpI4T/k7lxRfU+iGu4Z3lqMELWhb2HzM=
X-Google-Smtp-Source: ABdhPJxIl1UC64/exoJGtYvcVBbrzZVwR/ArfZ6ocjQY5EgD+XP52rdmr2i31u49pfZxDrFK4AxNQymOeAlcHFM9E9A=
X-Received: by 2002:a1f:3ac6:: with SMTP id h189mr18049467vka.16.1592888566578;
 Mon, 22 Jun 2020 22:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <1592832083-23249-1-git-send-email-magnus.karlsson@intel.com>
 <1592832083-23249-2-git-send-email-magnus.karlsson@intel.com> <57effc14-afed-51c8-9926-686d1cdea803@intel.com>
In-Reply-To: <57effc14-afed-51c8-9926-686d1cdea803@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 23 Jun 2020 07:02:35 +0200
Message-ID: <CAJ8uoz1jNy==6qw8Yjx5C8wwHORE8RkcXmhuih0xcwnhpb=Fqg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 1/2] i40e: optimize AF_XDP Tx
 completion path
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        jeffrey.t.kirsher@intel.com,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 3:00 AM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
>
>
> On 6/22/2020 6:21 AM, Magnus Karlsson wrote:
> > Improve the performance of the AF_XDP zero-copy Tx completion
> > path. When there are no XDP buffers being sent using XDP_TX or
> > XDP_REDIRECT, we do not have go through the SW ring to clean up any
> > entries since the AF_XDP path does not use these. In these cases, just
> > fast forward the next-to-use counter and skip going through the SW
> > ring. The limit on the maximum number of entries to complete is also
> > removed since the algorithm is now O(1). To simplify the code path, the
> > maximum number of entries to complete for the XDP path is therefore
> > also increased from 256 to 512 (the default number of Tx HW
> > descriptors). This should be fine since the completion in the XDP path
> > is faster than in the SKB path that has 256 as the maximum number.
> >
> > This patch provides around 4% throughput improvement for the l2fwd
> > application in xdpsock on my machine.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   drivers/net/ethernet/intel/i40e/i40e_txrx.c |  1 +
> >   drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 34 ++++++++++++++++-------------
> >   3 files changed, 21 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > index f9555c8..0ce9d1e 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> > @@ -3538,6 +3538,7 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
> >        */
> >       smp_wmb();
> >
> > +     xdp_ring->xdp_tx_active++;
> >       i++;
> >       if (i == xdp_ring->count)
> >               i = 0;
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > index 5c25597..c16fcd9 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > @@ -371,6 +371,7 @@ struct i40e_ring {
> >       /* used in interrupt processing */
> >       u16 next_to_use;
> >       u16 next_to_clean;
> > +     u16 xdp_tx_active;
> >
> >       u8 atr_sample_rate;
> >       u8 atr_count;
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > index 7276580..c8cd6a6 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> > @@ -378,6 +378,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
> >    **/
> >   static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >   {
> > +     unsigned int sent_frames = 0, total_bytes = 0;
> >       struct i40e_tx_desc *tx_desc = NULL;
> >       struct i40e_tx_buffer *tx_bi;
> >       bool work_done = true;
> > @@ -408,6 +409,9 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >                                  | I40E_TX_DESC_CMD_EOP,
> >                                  0, desc.len, 0);
> >
> > +             sent_frames++;
> > +             total_bytes += tx_bi->bytecount;
> > +
> >               xdp_ring->next_to_use++;
> >               if (xdp_ring->next_to_use == xdp_ring->count)
> >                       xdp_ring->next_to_use = 0;
> > @@ -420,6 +424,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
> >               i40e_xdp_ring_update_tail(xdp_ring);
> >
> >               xsk_umem_consume_tx_done(xdp_ring->xsk_umem);
> > +             i40e_update_tx_stats(xdp_ring, sent_frames, total_bytes);
> >       }
> >
> >       return !!budget && work_done;
> > @@ -434,6 +439,7 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
> >                                    struct i40e_tx_buffer *tx_bi)
> >   {
> >       xdp_return_frame(tx_bi->xdpf);
> > +     tx_ring->xdp_tx_active--;
> >       dma_unmap_single(tx_ring->dev,
> >                        dma_unmap_addr(tx_bi, dma),
> >                        dma_unmap_len(tx_bi, len), DMA_TO_DEVICE);
> > @@ -450,24 +456,23 @@ static void i40e_clean_xdp_tx_buffer(struct i40e_ring *tx_ring,
> >   bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
> >                          struct i40e_ring *tx_ring, int napi_budget)
>
> napi_budget is not used. so the 3rd arg can be removed

Thanks Sridhar. You are correct on all accounts in this mail. Will fix
and send a v2.

/Magnus

> >   {
> > -     unsigned int ntc, total_bytes = 0, budget = vsi->work_limit;
> > -     u32 i, completed_frames, frames_ready, xsk_frames = 0;
> > +     unsigned int ntc, budget = vsi->work_limit;
> >       struct xdp_umem *umem = tx_ring->xsk_umem;
> > +     u32 i, completed_frames, xsk_frames = 0;
> >       u32 head_idx = i40e_get_head(tx_ring);
> >       bool work_done = true, xmit_done;
>
> work_done is no longer required
>
> >       struct i40e_tx_buffer *tx_bi;
> >
> >       if (head_idx < tx_ring->next_to_clean)
> >               head_idx += tx_ring->count;
> > -     frames_ready = head_idx - tx_ring->next_to_clean;
> > +     completed_frames = head_idx - tx_ring->next_to_clean;
> >
> > -     if (frames_ready == 0) {
> > +     if (completed_frames == 0)
> >               goto out_xmit;
> > -     } else if (frames_ready > budget) {
> > -             completed_frames = budget;
> > -             work_done = false;
> > -     } else {
> > -             completed_frames = frames_ready;
> > +
> > +     if (likely(!tx_ring->xdp_tx_active)) {
> > +             xsk_frames = completed_frames;
> > +             goto skip;
> >       }
> >
> >       ntc = tx_ring->next_to_clean;
> > @@ -475,18 +480,18 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
> >       for (i = 0; i < completed_frames; i++) {
> >               tx_bi = &tx_ring->tx_bi[ntc];
> >
> > -             if (tx_bi->xdpf)
> > +             if (tx_bi->xdpf) {
> >                       i40e_clean_xdp_tx_buffer(tx_ring, tx_bi);
> > -             else
> > +                     tx_bi->xdpf = NULL;
> > +             } else {
> >                       xsk_frames++;
> > -
> > -             tx_bi->xdpf = NULL;
> > -             total_bytes += tx_bi->bytecount;
> > +             }
> >
> >               if (++ntc >= tx_ring->count)
> >                       ntc = 0;
> >       }
> >
> > +skip:
> >       tx_ring->next_to_clean += completed_frames;
> >       if (unlikely(tx_ring->next_to_clean >= tx_ring->count))
> >               tx_ring->next_to_clean -= tx_ring->count;
> > @@ -495,7 +500,6 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
> >               xsk_umem_complete_tx(umem, xsk_frames);
> >
> >       i40e_arm_wb(tx_ring, vsi, budget);
>
> I guess budget here should be replaced with completed_frames
>
> > -     i40e_update_tx_stats(tx_ring, completed_frames, total_bytes);
> >
> >   out_xmit:
> >       if (xsk_umem_uses_need_wakeup(tx_ring->xsk_umem))
>
>
> >
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
