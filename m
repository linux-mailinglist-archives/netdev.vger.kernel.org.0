Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3829D636CA1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbiKWV40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiKWV4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:56:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400947CBBE
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669240531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kqTEmMaEeigLnRU6RG80MkxMt/GiY11xNAc/zypvq18=;
        b=Q9RNaNOVqoD8k4ZWIaPYyfhcuDTQNEV8Gk69CT942rOhB9YKeHZFOR5fknp9kfnVcaNduv
        owmDbNmbi9WLAOk0Vt9V9xqNymtzaXcWa9kQNMxxTV5VqhQSLv1DAFnwvgjx9VKg0e6/2P
        FtHfPV0XqOhMrqIehQwSL6LhiRQehcE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-333-k1sk5dNPP76Y0y2Wt_vPFg-1; Wed, 23 Nov 2022 16:55:24 -0500
X-MC-Unique: k1sk5dNPP76Y0y2Wt_vPFg-1
Received: by mail-ed1-f69.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so12439edz.21
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 13:55:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kqTEmMaEeigLnRU6RG80MkxMt/GiY11xNAc/zypvq18=;
        b=ff3myOEcIP26b01xO6xIdo8b+K/dgiJ2EbyJlcGbAV7ILEnqCQ3G0xWLiNzliIyvmX
         UWL0DKc7WaYgSGjZtBV1Koa7xTfo9qXQU+fi1n1iGvj7pr8JCwaWk+oB333n/h66BxQn
         VljvXGgSQGkWZhbzeQoqRxbbE7U5dcZ5hzCA3Y03HLzws4Jarry6vQXo7cYmG+uIPm2D
         WLiaPP6SQ/DcFwqLckUgoQZoTCEq6EUgd+wUEre1iHiQypT2Ke3mpq0VOFMgOjaTOoLQ
         v/uPavG0ypGoU4e29I5ptCKFLYtkmDr0nZarHv0Kj/Fzgj3iGI83ylSNlmr+h7qnp/WB
         G1KA==
X-Gm-Message-State: ANoB5pn6kbeHC44lkOOlYJ8E5VL4iQLrnFbH4KciIHKcIobQ+Zq5swM+
        2gkhmtqFU3pCd1RI8n+dU+WBncivo/FWdm/IS5U1Ni1rzWibKMU2IKZiZ2qAhHanb2PUN1E4oYv
        r6rOit3JyTaApH+qX
X-Received: by 2002:a17:906:2645:b0:781:d0c1:4434 with SMTP id i5-20020a170906264500b00781d0c14434mr25348299ejc.756.1669240523318;
        Wed, 23 Nov 2022 13:55:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7WUn9Quenvdu13MHi5HDlfzWyjodMVzOIuW2Gtiy9+JzauvhV7pYkGKJNQd8mDwjWVbvpcKQ==
X-Received: by 2002:a17:906:2645:b0:781:d0c1:4434 with SMTP id i5-20020a170906264500b00781d0c14434mr25348269ejc.756.1669240522853;
        Wed, 23 Nov 2022 13:55:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lg15-20020a170906f88f00b007aec1b39478sm169320ejb.188.2022.11.23.13.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 13:55:22 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 806927D517F; Wed, 23 Nov 2022 22:55:21 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     sdf@google.com, Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
In-Reply-To: <Y3557Ecr80Y9ZD2z@google.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com> <874jupviyc.fsf@toke.dk>
 <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org> <Y3557Ecr80Y9ZD2z@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Nov 2022 22:55:21 +0100
Message-ID: <871qptuyie.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com writes:

> On 11/23, Jakub Kicinski wrote:
>> On Wed, 23 Nov 2022 10:26:41 -0800 Stanislav Fomichev wrote:
>> > > This embedding trick works for drivers that put xdp_buff on the stack,
>> > > but mlx5 supports XSK zerocopy, which uses the xsk_buff_pool for
>> > > allocating them. This makes it a bit awkward to do the same thing  
>> there;
>> > > and since it's probably going to be fairly common to do something like
>> > > this, how about we just add a 'void *drv_priv' pointer to struct
>> > > xdp_buff that the drivers can use? The xdp_buff already takes up a  
>> full
>> > > cache line anyway, so any data stuffed after it will spill over to a  
>> new
>> > > one; so I don't think there's much difference performance-wise.
>> >
>> > I guess the alternative is to extend xsk_buff_pool with some new
>> > argument for xdp_buff tailroom? (so it can kmalloc(sizeof(xdp_buff) +
>> > xdp_buff_tailroom))
>> > But it seems messy because there is no way of knowing what the target
>> > device's tailroom is, so it has to be a user setting :-/
>> > I've started with a priv pointer in xdp_buff initially, it seems fine
>> > to go back. I'll probably convert veth/mlx4 to the same mode as well
>> > to avoid having different approaches in different places..
>
>> Can we not do this please? Add 16B of "private driver space" after
>> the xdp_buff in xdp_buff_xsk (we have 16B to full cacheline), the
>> drivers decide how they use it. Drivers can do BUILD_BUG_ON() for their
>> expected size and cast that to whatever struct they want. This is how
>> various offloads work, the variable size tailroom would be an over
>> design IMO.
>
>> And this way non XSK paths can keep its normal typing.
>
> Good idea, prototyped below, lmk if it that's not what you had in mind.
>
> struct xdp_buff_xsk {
> 	struct xdp_buff            xdp;                  /*     0    56 */
> 	u8                         cb[16];               /*    56    16 */
> 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */

As pahole helpfully says here, xdp_buff is actually only 8 bytes from
being a full cache line. I thought about adding a 'cb' field like this
to xdp_buff itself, but figured that since there's only room for a
single pointer, why not just add that and let the driver point it to
where it wants to store the extra context data?

I am not suggesting to make anything variable-size; the 'void *drv_priv'
is just a normal pointer. There's no changes to any typing; not sure
where you got that from, Jakub?

Also, the priv pointer approach works for both XSK and on-stack
allocations, unlike this approach (see below).

> 	dma_addr_t                 dma;                  /*    72     8 */
> 	dma_addr_t                 frame_dma;            /*    80     8 */
> 	struct xsk_buff_pool *     pool;                 /*    88     8 */
> 	u64                        orig_addr;            /*    96     8 */
> 	struct list_head           free_list_node;       /*   104    16 */
>
> 	/* size: 120, cachelines: 2, members: 7 */
> 	/* last cacheline: 56 bytes */
> };
>
> Toke, I can try to merge this into your patch + keep your SoB (or feel free
> to try this and retest yourself, whatever works).
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index bc2d9034af5b..837bf103b871 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -44,6 +44,11 @@
>   	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
>   	 sizeof(struct mlx5_wqe_inline_seg))
>
> +struct mlx5_xdp_cb {
> +	struct mlx5_cqe64 *cqe;
> +	struct mlx5e_rq *rq;
> +};
> +
>   struct mlx5e_xsk_param;
>   int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param  
> *xsk);
>   bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c  
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index c91b54d9ff27..84d23b2da7ce 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -5,6 +5,7 @@
>   #include "en/xdp.h"
>   #include <net/xdp_sock_drv.h>
>   #include <linux/filter.h>
> +#include <linux/build_bug.h>
>
>   /* RX data path */
>
> @@ -286,8 +287,14 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct  
> mlx5e_rq *rq,
>   					      u32 cqe_bcnt)
>   {
>   	struct xdp_buff *xdp = wi->au->xsk;
> +	struct mlx5_xdp_cb *cb;
>   	struct bpf_prog *prog;
>
> +	BUILD_BUG_ON(sizeof(struct mlx5_xdp_cb) > XSKB_CB_SIZE);
> +	cb = xp_get_cb(xdp);
> +	cb->cqe = NULL /*cqe*/;
> +	cb->rq = rq;

So this works fine for the XSK path, but for the regular XDP path, mlx5
*does* indeed put the xdp_buff on the stack. So to re-use code there
would be an implicit assumption that both memory layout and size matches
between the two paths. I'm not sure that's better than just having a
pointer inside the xdp_buff and pointing it wherever makes sense for
that driver (as my patch did)?

-Toke

