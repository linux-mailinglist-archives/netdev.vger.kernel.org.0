Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD22B6D57DD
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 07:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjDDFJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 01:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDDFJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 01:09:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA04C1BEF
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 22:09:53 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id h17so31424506wrt.8
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 22:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680584992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ktAWZBRM+VqFBJgJmK/4MAzbC6C59mNA7HJuTF9SdP4=;
        b=nB6XFFvgBiA4rFZmYVuSLg/I/txub38UlSpOlvdfjNn4QEpDJiCGEgPePlY2LLpuLD
         /sDlI558146nn/U7yThtJHGeG8ZTubCSwNppbT5tUxk1L0LcTgn2x8HtdE71T1O1J9Ir
         EOUxjQp5/jGrMgmG8rfyInHK75f7ksw51mQulZTG0W1cQCaxkt1g2fH4ZwuegwOW6v1T
         FRzKUWue/pRlA5My55DOJTn49cwgK3Sac0yKpmrVJbBJ0VFpMFkWB32uHwh/+ORsO+Zy
         DjoceScdnqVnit0WAHqZ/Fd5FmEmrNGK7JOWoKcX9HBUiqlX8KbJj3xYaX/EIKt+FWXf
         Un4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680584992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ktAWZBRM+VqFBJgJmK/4MAzbC6C59mNA7HJuTF9SdP4=;
        b=obPqrRSJ6QGY8kEgE0yyCi92CrWgUWsp0gDCrR/NrrZopWigqmFd+hGel/jSEnZMV3
         LTehp0gN3YzDwRQVRvEk+kEfEfDM1tUyF6Ds+YRvTuxpzwmyEx+dIfRwmK+sEQ8LWDxb
         Muda0+VHPQ7H1KvZHO4AAtkCfgpSeHM01O8kNKtveW8y+yTfMUsfAanFILkgppzEy/KL
         k/HJEx0m+yBEMTX6uizOmtEB/P/28PEzQ/js8JigGYs68HQq7pGlAmL7NLtxApr1aY8A
         4kLsy8Nx/otXqINjp+eWw6VFdcIMtQ1h1TPpwy95jykvumAVo0YmZpiVrOqk6Y9BDV32
         TvRw==
X-Gm-Message-State: AAQBX9dD2PjgTrkvw/8oTGG9W0rBxq6nx0exOp/jJCwQGVrPaDGmYsAv
        YhcYzk1xSSNyJXICeEpM9Uvi19pi5kz93T/lmnfG+g==
X-Google-Smtp-Source: AKy350b7M/dTuPNrXzqElkRVJKWlcr8HY0+rrlA1porqHPfS4cXA7R5YJ8BobnabuYpU+AHDfyZiFL43xzp80xSNV80=
X-Received: by 2002:adf:fc41:0:b0:2ce:a5f8:b786 with SMTP id
 e1-20020adffc41000000b002cea5f8b786mr160086wrs.12.1680584992009; Mon, 03 Apr
 2023 22:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk> <E1pjOwe-00Fmki-6p@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pjOwe-00Fmki-6p@rmk-PC.armlinux.org.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 07:09:40 +0200
Message-ID: <CANn89iJJWNemzxbyCD4hCZk75Uoxw1nnJ5vLAqM3JGhG_AfqbQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 1/5] net: mvneta: fix transmit path
 dma-unmapping on error
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 8:30=E2=80=AFPM Russell King (Oracle)
<rmk+kernel@armlinux.org.uk> wrote:
>
> The transmit code assumes that the transmit descriptors that are used
> begin with the first descriptor in the ring, but this may not be the
> case. Fix this by providing a new function that dma-unmaps a range of
> numbered descriptor entries, and use that to do the unmapping.
>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Nice patch series !

I guess this one will need to be backported to stable versions. It
would be nice adding:

Fixes: 2adb719d74f6 ("net: mvneta: Implement software TSO")

Thanks.

> ---
>  drivers/net/ethernet/marvell/mvneta.c | 53 +++++++++++++++++----------
>  1 file changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index 2cad76d0a50e..62400ff61e34 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2714,14 +2714,40 @@ mvneta_tso_put_data(struct net_device *dev, struc=
t mvneta_tx_queue *txq,
>         return 0;
>  }
>
> +static void mvneta_release_descs(struct mvneta_port *pp,
> +                                struct mvneta_tx_queue *txq,
> +                                int first, int num)
> +{
> +       int desc_idx, i;
> +
> +       desc_idx =3D first + num;
> +       if (desc_idx >=3D txq->size)
> +               desc_idx -=3D txq->size;
> +
> +       for (i =3D num; i >=3D 0; i--) {
> +               struct mvneta_tx_desc *tx_desc =3D txq->descs + desc_idx;
> +
> +               if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
> +                       dma_unmap_single(pp->dev->dev.parent,
> +                                        tx_desc->buf_phys_addr,
> +                                        tx_desc->data_size,
> +                                        DMA_TO_DEVICE);
> +
> +               mvneta_txq_desc_put(txq);
> +
> +               if (desc_idx =3D=3D 0)
> +                       desc_idx =3D txq->size;
> +               desc_idx -=3D 1;
> +       }
> +}
> +
>  static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
>                          struct mvneta_tx_queue *txq)
>  {
>         int hdr_len, total_len, data_left;
> -       int desc_count =3D 0;
> +       int first_desc, desc_count =3D 0;
>         struct mvneta_port *pp =3D netdev_priv(dev);
>         struct tso_t tso;
> -       int i;
>
>         /* Count needed descriptors */
>         if ((txq->count + tso_count_descs(skb)) >=3D txq->size)
> @@ -2732,6 +2758,8 @@ static int mvneta_tx_tso(struct sk_buff *skb, struc=
t net_device *dev,
>                 return 0;
>         }
>
> +       first_desc =3D txq->txq_put_index;
> +
>         /* Initialize the TSO handler, and prepare the first payload */
>         hdr_len =3D tso_start(skb, &tso);
>
> @@ -2772,15 +2800,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, stru=
ct net_device *dev,
>         /* Release all used data descriptors; header descriptors must not
>          * be DMA-unmapped.
>          */
> -       for (i =3D desc_count - 1; i >=3D 0; i--) {
> -               struct mvneta_tx_desc *tx_desc =3D txq->descs + i;
> -               if (!IS_TSO_HEADER(txq, tx_desc->buf_phys_addr))
> -                       dma_unmap_single(pp->dev->dev.parent,
> -                                        tx_desc->buf_phys_addr,
> -                                        tx_desc->data_size,
> -                                        DMA_TO_DEVICE);
> -               mvneta_txq_desc_put(txq);
> -       }
> +       mvneta_release_descs(pp, txq, first_desc, desc_count - 1);
>         return 0;
>  }
>
> @@ -2790,6 +2810,7 @@ static int mvneta_tx_frag_process(struct mvneta_por=
t *pp, struct sk_buff *skb,
>  {
>         struct mvneta_tx_desc *tx_desc;
>         int i, nr_frags =3D skb_shinfo(skb)->nr_frags;
> +       int first_desc =3D txq->txq_put_index;
>
>         for (i =3D 0; i < nr_frags; i++) {
>                 struct mvneta_tx_buf *buf =3D &txq->buf[txq->txq_put_inde=
x];
> @@ -2828,15 +2849,7 @@ static int mvneta_tx_frag_process(struct mvneta_po=
rt *pp, struct sk_buff *skb,
>         /* Release all descriptors that were used to map fragments of
>          * this packet, as well as the corresponding DMA mappings
>          */
> -       for (i =3D i - 1; i >=3D 0; i--) {
> -               tx_desc =3D txq->descs + i;
> -               dma_unmap_single(pp->dev->dev.parent,
> -                                tx_desc->buf_phys_addr,
> -                                tx_desc->data_size,
> -                                DMA_TO_DEVICE);
> -               mvneta_txq_desc_put(txq);
> -       }
> -
> +       mvneta_release_descs(pp, txq, first_desc, i - 1);
>         return -ENOMEM;
>  }
>
> --
> 2.30.2
>
