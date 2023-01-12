Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FD566865D
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbjALWIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239533AbjALWHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:07:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF2476AE8
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673560512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o2pqGz5pxnSufN+M86D4kyp6huaACG/FfcB/U9shMco=;
        b=TyIjyWBXMkazfyLSDibpqxXFfOII3dGzdniraIunj0Gma7Co02J/wpPMQwckjSfp1bv7Ik
        3o0cMkaTDt/wjsWHaf6tAZBYEoBH8nM0eoE+rjx7kI7OGiswarraThCx66xURLYYRwWVSY
        wjyaP8egN4SIMyEoIKfVNQvSBZldTgE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-JUMLCd3tNCun1aZQNAUerA-1; Thu, 12 Jan 2023 16:55:11 -0500
X-MC-Unique: JUMLCd3tNCun1aZQNAUerA-1
Received: by mail-ej1-f71.google.com with SMTP id qw20-20020a1709066a1400b007c1727f7c55so13455833ejc.2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o2pqGz5pxnSufN+M86D4kyp6huaACG/FfcB/U9shMco=;
        b=yZ5MAAz9Yv34WSDOKqz+QEpzo2pxhZCZ/mIqzjNrBnVoNpjsNqRba1+3HIQ0t2FQdl
         DaTvp8owsNCJcYITwGjAPIMrw3yY0PH9lv+rdJJ1cKiP6vjzke4SXO0IZ0kGthggVmXM
         V47Q9lxlSs3LeeYQGY5FyPg4xgrWZiBmKL81TUIjOwpS4ctetFi5YsCiLy660GOlL/TI
         q1T822UPwdDUm9laUHHH7MW+XZGAPmsSiyBL35Sp+ahun31qH03dBeQef7AquWdoQ3Fs
         7UvrS/JiYvuPhB4I2lWrZm+vgIAtGMBdmuCg3SED/z+VnDaorTpkLYHFBGx5Qpm41LWj
         mN4g==
X-Gm-Message-State: AFqh2kp1rNviLaSlGDkHxp2Tb3B0a5/SnRMidPBWWHECwo0KsRs2rlw1
        DdthcxAOkFvz5/M5pdLA8HtVa+khgfhYfW0nwXm9YXhFcsJd66Cn+ICSksKADCFfekPiD2h04A7
        6qwE7mbPI2lMg9CA6
X-Received: by 2002:a17:907:2bed:b0:7c0:dd80:e95e with SMTP id gv45-20020a1709072bed00b007c0dd80e95emr1031470ejc.51.1673560507465;
        Thu, 12 Jan 2023 13:55:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXskfiIzt1rRtcZmMG8KEcbynfep73CDRMmHyuGL20jYnjmciHfnH5BK2mK79hQJV+1g26p9+A==
X-Received: by 2002:a17:907:2bed:b0:7c0:dd80:e95e with SMTP id gv45-20020a1709072bed00b007c0dd80e95emr1031428ejc.51.1673560506631;
        Thu, 12 Jan 2023 13:55:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r2-20020a17090609c200b007bd28b50305sm7861149eje.200.2023.01.12.13.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 13:55:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3667E900729; Thu, 12 Jan 2023 22:55:05 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce
 wrapper for xdp_buff
In-Reply-To: <87k01rfojm.fsf@toke.dk>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
 <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
 <87k01rfojm.fsf@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Jan 2023 22:55:05 +0100
Message-ID: <87h6wvfmfa.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

> Stanislav Fomichev <sdf@google.com> writes:
>
>> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com> =
wrote:
>>>
>>>
>>>
>>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>> >
>>> > Preparation for implementing HW metadata kfuncs. No functional change.
>>> >
>>> > Cc: Tariq Toukan <tariqt@nvidia.com>
>>> > Cc: Saeed Mahameed <saeedm@nvidia.com>
>>> > Cc: John Fastabend <john.fastabend@gmail.com>
>>> > Cc: David Ahern <dsahern@gmail.com>
>>> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>> > Cc: Jakub Kicinski <kuba@kernel.org>
>>> > Cc: Willem de Bruijn <willemb@google.com>
>>> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>> > Cc: Maryam Tahhan <mtahhan@redhat.com>
>>> > Cc: xdp-hints@xdp-project.net
>>> > Cc: netdev@vger.kernel.org
>>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> > ---
>>> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>>> >   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>>> >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++-------=
---
>>> >   5 files changed, 50 insertions(+), 43 deletions(-)
>>> >
>>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en.h
>>> > index 2d77fb8a8a01..af663978d1b4 100644
>>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> > @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>>> >   union mlx5e_alloc_unit {
>>> >       struct page *page;
>>> >       struct xdp_buff *xsk;
>>> > +     struct mlx5e_xdp_buff *mxbuf;
>>>
>>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf and
>>> alloc_units[page_idx].xsk, while both fields share the memory of a unio=
n.
>>>
>>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
>>> need to change the existing xsk field type from struct xdp_buff *xsk
>>> into struct mlx5e_xdp_buff *xsk and align the usage.
>>
>> Hmmm, good point. I'm actually not sure how it works currently.
>> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
>> am I missing something?
>
> It's initialised piecemeal in different places; but yeah, we're mixing
> things a bit...
>
>> I'm thinking about something like this:
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> index af663978d1b4..2d77fb8a8a01 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
>>  union mlx5e_alloc_unit {
>>         struct page *page;
>>         struct xdp_buff *xsk;
>> -       struct mlx5e_xdp_buff *mxbuf;
>>  };
>
> Hmm, for consistency with the non-XSK path we should rather go the other
> direction and lose the xsk member, moving everything to mxbuf? Let me
> give that a shot...

Something like the below?

-Toke

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 6de02d8aeab8..cb9cdb6421c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -468,7 +468,6 @@ struct mlx5e_txqsq {
=20
 union mlx5e_alloc_unit {
 	struct page *page;
-	struct xdp_buff *xsk;
 	struct mlx5e_xdp_buff *mxbuf;
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index cb568c62aba0..95694a25ec31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -33,6 +33,7 @@
 #define __MLX5_EN_XDP_H__
=20
 #include <linux/indirect_call_wrapper.h>
+#include <net/xdp_sock_drv.h>
=20
 #include "en.h"
 #include "en/txrx.h"
@@ -112,6 +113,21 @@ static inline void mlx5e_xmit_xdp_doorbell(struct mlx5=
e_xdpsq *sq)
 	}
 }
=20
+static inline struct mlx5e_xdp_buff *mlx5e_xsk_buff_alloc(struct xsk_buff_=
pool *pool)
+{
+	return (struct mlx5e_xdp_buff *)xsk_buff_alloc(pool);
+}
+
+static inline void mlx5e_xsk_buff_free(struct mlx5e_xdp_buff *mxbuf)
+{
+	xsk_buff_free(&mxbuf->xdp);
+}
+
+static inline dma_addr_t mlx5e_xsk_buff_xdp_get_frame_dma(struct mlx5e_xdp=
_buff *mxbuf)
+{
+	return xsk_buff_xdp_get_frame_dma(&mxbuf->xdp);
+}
+
 /* Enable inline WQEs to shift some load from a congested HCA (HW) to
  * a less congested cpu (SW).
  */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 8bf3029abd3c..1f166dbb7f22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -3,7 +3,6 @@
=20
 #include "rx.h"
 #include "en/xdp.h"
-#include <net/xdp_sock_drv.h>
 #include <linux/filter.h>
=20
 /* RX data path */
@@ -21,7 +20,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe)))
 		goto err;
=20
-	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[0].xs=
k));
+	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[0].mx=
buf));
 	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
 	batch =3D xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->allo=
c_units,
 				     rq->mpwqe.pages_per_wqe);
@@ -33,8 +32,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	 * the first error, which will mean there are no more valid descriptors.
 	 */
 	for (; batch < rq->mpwqe.pages_per_wqe; batch++) {
-		wi->alloc_units[batch].xsk =3D xsk_buff_alloc(rq->xsk_pool);
-		if (unlikely(!wi->alloc_units[batch].xsk))
+		wi->alloc_units[batch].mxbuf =3D mlx5e_xsk_buff_alloc(rq->xsk_pool);
+		if (unlikely(!wi->alloc_units[batch].mxbuf))
 			goto err_reuse_batch;
 	}
=20
@@ -44,7 +43,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
=20
 	if (likely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_ALIGNED)) {
 		for (i =3D 0; i < batch; i++) {
-			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i]=
.mxbuf);
=20
 			umr_wqe->inline_mtts[i] =3D (struct mlx5_mtt) {
 				.ptag =3D cpu_to_be64(addr | MLX5_EN_WR),
@@ -53,7 +52,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		}
 	} else if (unlikely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_UNALIG=
NED)) {
 		for (i =3D 0; i < batch; i++) {
-			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i]=
.mxbuf);
=20
 			umr_wqe->inline_ksms[i] =3D (struct mlx5_ksm) {
 				.key =3D rq->mkey_be,
@@ -65,7 +64,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		u32 mapping_size =3D 1 << (rq->mpwqe.page_shift - 2);
=20
 		for (i =3D 0; i < batch; i++) {
-			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i]=
.mxbuf);
=20
 			umr_wqe->inline_ksms[i << 2] =3D (struct mlx5_ksm) {
 				.key =3D rq->mkey_be,
@@ -91,7 +90,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		__be32 frame_size =3D cpu_to_be32(rq->xsk_pool->chunk_size);
=20
 		for (i =3D 0; i < batch; i++) {
-			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+			dma_addr_t addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i]=
.mxbuf);
=20
 			umr_wqe->inline_klms[i << 1] =3D (struct mlx5_klm) {
 				.key =3D rq->mkey_be,
@@ -137,7 +136,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
=20
 err_reuse_batch:
 	while (--batch >=3D 0)
-		xsk_buff_free(wi->alloc_units[batch].xsk);
+		mlx5e_xsk_buff_free(wi->alloc_units[batch].mxbuf);
=20
 err:
 	rq->stats->buff_alloc_err++;
@@ -156,7 +155,7 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq=
, u16 ix, int wqe_bulk)
 	 * allocate XDP buffers straight into alloc_units.
 	 */
 	BUILD_BUG_ON(sizeof(rq->wqe.alloc_units[0]) !=3D
-		     sizeof(rq->wqe.alloc_units[0].xsk));
+		     sizeof(rq->wqe.alloc_units[0].mxbuf));
 	buffs =3D (struct xdp_buff **)rq->wqe.alloc_units;
 	contig =3D mlx5_wq_cyc_get_size(wq) - ix;
 	if (wqe_bulk <=3D contig) {
@@ -177,8 +176,9 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq=
, u16 ix, int wqe_bulk)
 		/* Assumes log_num_frags =3D=3D 0. */
 		frag =3D &rq->wqe.frags[j];
=20
-		addr =3D xsk_buff_xdp_get_frame_dma(frag->au->xsk);
+		addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(frag->au->mxbuf);
 		wqe->data[0].addr =3D cpu_to_be64(addr + rq->buff.headroom);
+		frag->au->mxbuf->rq =3D rq;
 	}
=20
 	return alloc;
@@ -199,12 +199,13 @@ int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 =
ix, int wqe_bulk)
 		/* Assumes log_num_frags =3D=3D 0. */
 		frag =3D &rq->wqe.frags[j];
=20
-		frag->au->xsk =3D xsk_buff_alloc(rq->xsk_pool);
-		if (unlikely(!frag->au->xsk))
+		frag->au->mxbuf =3D mlx5e_xsk_buff_alloc(rq->xsk_pool);
+		if (unlikely(!frag->au->mxbuf))
 			return i;
=20
-		addr =3D xsk_buff_xdp_get_frame_dma(frag->au->xsk);
+		addr =3D mlx5e_xsk_buff_xdp_get_frame_dma(frag->au->mxbuf);
 		wqe->data[0].addr =3D cpu_to_be64(addr + rq->buff.headroom);
+		frag->au->mxbuf->rq =3D rq;
 	}
=20
 	return wqe_bulk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 7b08653be000..4313165709cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -41,7 +41,6 @@
 #include <net/gro.h>
 #include <net/udp.h>
 #include <net/tcp.h>
-#include <net/xdp_sock_drv.h>
 #include "en.h"
 #include "en/txrx.h"
 #include "en_tc.h"
@@ -434,7 +433,7 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *r=
q,
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
 		 */
-		xsk_buff_free(wi->au->xsk);
+		mlx5e_xsk_buff_free(wi->au->mxbuf);
 		return;
 	}
=20
@@ -515,7 +514,7 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_m=
pw_info *wi, bool recycle
 		 */
 		for (i =3D 0; i < rq->mpwqe.pages_per_wqe; i++)
 			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
-				xsk_buff_free(alloc_units[i].xsk);
+				mlx5e_xsk_buff_free(alloc_units[i].mxbuf);
 	} else {
 		for (i =3D 0; i < rq->mpwqe.pages_per_wqe; i++)
 			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))

