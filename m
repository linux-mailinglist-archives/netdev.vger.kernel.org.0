Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2D6DAAD7
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240235AbjDGJZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbjDGJZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:25:36 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7079A5E1
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 02:25:35 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id cf7so48506995ybb.5
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 02:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680859535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8D8TgtaHgWSOgl8M/AoLVH7Mm8t98a84cfv1H5Koqg=;
        b=pl07k9cLHi9cTQ+QjsS/8Szos0Y2/CugXVxASEuLObMBYRZsCQ41/bXMLWRZ48Mqkh
         n1aKXJB+TL4jphB1vIRC+6vfk7I9z/ie1I12yljxrQy+nSnjPdf2qgpNrEiXXJuyTe4K
         0vxqalZ85FVhfrlr92aZG6yfr6ZEFKBJaWsmYFkkewR4b0wn8qHt+KIg/wPECQmuNF9x
         TuMUMjj+GZNVSlNQwsjvrH1i1vFFwyOvdsnQ+6VEof62rbM+zvrUIJz0bFmPNgQgK3ma
         8oSKIYJ98y5sls2izMVUy4c9mM65z3UH4fgpv/iaStITkcnt8T7cyWTlxnHy1NU/dKQu
         CjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680859535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8D8TgtaHgWSOgl8M/AoLVH7Mm8t98a84cfv1H5Koqg=;
        b=jgT3ahkSPS92N/0cfPrSguZjJqcbFQpc/6lZ8Cq+69RCTx0K69JC3vSw9eYehEveO/
         AbxQ6R9UNu7FtN0WC2dLxDzcQ5npeUI8lXijCJdrE0DjAM7OS8ddQlSw7LzdOOPy//x7
         Iutu5CiXz2acdqQFOgpjhaHJ0aMD4hW47sAIyaEbai2CqWzJtU8dUYTmtotSvI86rnMq
         /DJS6DqXEFW19Os/9C7Fy0+gMI/Ie51+/pPkhxYRzQCzynK9tj30pnEJj1eqU7AlcrnT
         t5EMA5nhii8Kbfc4PjmCzOaPrYyrqhcrVGD7jf/hhK/h+dctpqzOGsdXnfqwiY6DjgOY
         hnrQ==
X-Gm-Message-State: AAQBX9fmr1Ut+sMVwZ9AL0equQ3X9NnNuOt92jVjrNoOPRvaJARCl6ir
        +W7MB6YmxdGq/4otZKop0+++d5kF1aTcJ6hmYOcEmw==
X-Google-Smtp-Source: AKy350bMTvfE+Km86n4ZECo6ADU8bz+X+rC3y5kYs97CNgX/wPSmUws7SzV5TlXTzixuvzhNepV7SYsY8m4OH09xNGI=
X-Received: by 2002:a25:740f:0:b0:b09:6f3d:ea1f with SMTP id
 p15-20020a25740f000000b00b096f3dea1fmr1525213ybc.4.1680859534748; Fri, 07 Apr
 2023 02:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230407012536.273382-1-kuba@kernel.org> <20230407012536.273382-7-kuba@kernel.org>
In-Reply-To: <20230407012536.273382-7-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 7 Apr 2023 11:25:23 +0200
Message-ID: <CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=2+aStsbbwpWzKHjk51g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 6/7] bnxt: use new queue try_stop/try_wake macros
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Michael Chan <michael.chan@broadcom.com>
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

On Fri, Apr 7, 2023 at 3:25=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Convert bnxt to use new macros rather than open code the logic.
> Two differences:
> (1) bnxt_tx_int() will now only issue a memory barrier if it sees
>     enough space on the ring to wake the queue. This should be fine,
>     the mb() is between the writes to the ring pointers and checking
>     queue state.
> (2) we'll start the queue instead of waking on race, this should
>     be safe inside the xmit handler.

...

>                                    "bnxt: ring busy w/ flush pending!\n")=
;
> -               if (bnxt_txr_netif_try_stop_queue(bp, txr, txq))
> +               if (!netif_txq_try_stop(txq, bnxt_tx_avail(bp, txr),
> +                                       bp->tx_wake_thresh))
>                         return NETDEV_TX_BUSY;
>         }
>

BTW, we should make sure the @desc argument of netif_txq_try_stop() is
correctly implemented.
I often see drivers with either buggy or not efficient implementation.

For instance, bnxt could perhaps be slightly described more accurately with=
:

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 18cac98ba58e86c53eb87ed592424ed719b2f892..ec4a2d4dea3c58de08e51c1d65b=
3d2fd75d71e6a
100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2231,13 +2231,12 @@ struct bnxt {
 #define SFF_MODULE_ID_QSFP28                   0x11
 #define BNXT_MAX_PHY_I2C_RESP_SIZE             64

-static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_info =
*txr)
+static inline u32 bnxt_tx_avail(const struct bnxt *bp,
+                               const struct bnxt_tx_ring_info *txr)
 {
-       /* Tell compiler to fetch tx indices from memory. */
-       barrier();
+       u32 used =3D READ_ONCE(txr->tx_prod) - READ_ONCE(txr->tx_cons);

-       return bp->tx_ring_size -
-               ((txr->tx_prod - txr->tx_cons) & bp->tx_ring_mask);
+       return bp->tx_ring_size - (used & bp->tx_ring_mask);
 }

 static inline void bnxt_writeq(struct bnxt *bp, u64 val,


In the same vein, mlx4 would probably need something like:

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 2f79378fbf6ec106bf78d0fd12e911ff200ba8d7..13557701e254e7aeff057abd26a=
88d19c3a5cd69
100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -226,9 +226,11 @@ void mlx4_en_deactivate_tx_ring(struct mlx4_en_priv *p=
riv,
                       MLX4_QP_STATE_RST, NULL, 0, 0, &ring->sp_qp);
 }

-static inline bool mlx4_en_is_tx_ring_full(struct mlx4_en_tx_ring *ring)
+static inline bool mlx4_en_is_tx_ring_full(const struct mlx4_en_tx_ring *r=
ing)
 {
-       return ring->prod - ring->cons > ring->full_size;
+       u32 used =3D READ_ONCE(ring->prod) - READ_ONCE(ring->cons);
+
+       return used > ring->full_size;
 }

 static void mlx4_en_stamp_wqe(struct mlx4_en_priv *priv,
