Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7515066B086
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 12:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjAOLOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 06:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjAOLOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 06:14:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFA05B90
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 03:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673781228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qo+RjDN6fRsLN+/Dxl3u28Xl4qmoaGjS11UlhtqdFaA=;
        b=FHjIkFs1vcVJWmMzNM8jcQXtPSn+sevrlfKkDsDBAXbMkBJfNBSKsgAoTWCIu4z2E+YZ1h
        mXmG1oVskZATOacttDvGsWVUFkfcWySW/0V4lKbm8fvFDJUvMpzULB6q/8xvEV3Y3Nq15f
        ZfsHo4lqHGuoziDHW7zRs62vC1TYXtk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-306-x6qC_q0ON8aWT6ki0lnNhg-1; Sun, 15 Jan 2023 06:13:46 -0500
X-MC-Unique: x6qC_q0ON8aWT6ki0lnNhg-1
Received: by mail-ed1-f70.google.com with SMTP id z18-20020a05640235d200b0049d84165065so2074240edc.18
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 03:13:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qo+RjDN6fRsLN+/Dxl3u28Xl4qmoaGjS11UlhtqdFaA=;
        b=W04qKEC8JJBXwX+dCKWlNnvQcus1Y/ag3hVlnd6/eeKgu6SZxZRzCfMSzjvtEhmY+P
         cbk6huI4dVx5FzBrW/xj/BoutmTHueNMzlLHGUO2Mqnprq3Sj4NnPx1j95tMhMbGHSva
         zHfAdRY2QCgH0q+qp9LyCvsb2t4f6/wuUnt2zngmAohIuiWQDV3nqJw3f8T1TAjP4Q92
         5kuym7qwtAFLKg7mha/8u1StL8vyyHVGy/O8f/XPrwzWHgMya/oT6Ge1bicGycReynsN
         EgzsAiE8lGnfKg0vkH99WCF8dKG2xAm8ayDNHkU7+V85HQtN3ay9Kv97jUA6Q/TjVsF9
         SSHQ==
X-Gm-Message-State: AFqh2kopI9ik6G7gJ8Uyabv7t2TojW0wQTHkz3SVnED8FGJmBAQL+0pK
        g9oKt3sol7eWOPKXYPd+i9CxnFto38NuW2tXEZiHa1VvYUxjzyhuW9brSovqa7yHi2c1Q9VD+GQ
        LHdtA9aimXyfB2Rfp
X-Received: by 2002:a17:907:cc03:b0:7c4:f8fb:6a27 with SMTP id uo3-20020a170907cc0300b007c4f8fb6a27mr7859259ejc.0.1673781224977;
        Sun, 15 Jan 2023 03:13:44 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtE12kaaGZX4CIw6tlhtGPaOV/YEsVFLoHlrViFgewZBY/VEgAEpT3y0ZvredEKvY0EAkNDBg==
X-Received: by 2002:a17:907:cc03:b0:7c4:f8fb:6a27 with SMTP id uo3-20020a170907cc0300b007c4f8fb6a27mr7859201ejc.0.1673781223811;
        Sun, 15 Jan 2023 03:13:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f12-20020a170906494c00b00860c51f7de5sm4826573ejt.131.2023.01.15.03.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 03:13:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 42EA2900CC6; Sun, 15 Jan 2023 12:13:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
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
In-Reply-To: <493fd525-10b3-c136-8458-a1560ed2cdcb@gmail.com>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
 <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
 <87k01rfojm.fsf@toke.dk> <87h6wvfmfa.fsf@toke.dk>
 <d83f2193-3fb9-e30f-cfb0-f1098f039b67@gmail.com> <87358ef7e8.fsf@toke.dk>
 <493fd525-10b3-c136-8458-a1560ed2cdcb@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 15 Jan 2023 12:13:42 +0100
Message-ID: <87tu0sdp95.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq Toukan <ttoukan.linux@gmail.com> writes:

> On 13/01/2023 23:31, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Tariq Toukan <ttoukan.linux@gmail.com> writes:
>>=20
>>> On 12/01/2023 23:55, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>>>>
>>>>> Stanislav Fomichev <sdf@google.com> writes:
>>>>>
>>>>>> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.c=
om> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>>>>>>>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>>>>>
>>>>>>>> Preparation for implementing HW metadata kfuncs. No functional cha=
nge.
>>>>>>>>
>>>>>>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>>>>>>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>>>>>>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>>>>>>> Cc: David Ahern <dsahern@gmail.com>
>>>>>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>>>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>>>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>>>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>>>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>>>>>> Cc: xdp-hints@xdp-project.net
>>>>>>>> Cc: netdev@vger.kernel.org
>>>>>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>>>>> ---
>>>>>>>>     drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>>>>>>>     .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>>>>>>>>     .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>>>>>>>>     .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>>>>>>>>     .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++--=
--------
>>>>>>>>     5 files changed, 50 insertions(+), 43 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/driver=
s/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>>> index 2d77fb8a8a01..af663978d1b4 100644
>>>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>>> @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>>>>>>>>     union mlx5e_alloc_unit {
>>>>>>>>         struct page *page;
>>>>>>>>         struct xdp_buff *xsk;
>>>>>>>> +     struct mlx5e_xdp_buff *mxbuf;
>>>>>>>
>>>>>>> In XSK files below you mix usage of both alloc_units[page_idx].mxbu=
f and
>>>>>>> alloc_units[page_idx].xsk, while both fields share the memory of a =
union.
>>>>>>>
>>>>>>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you ju=
st
>>>>>>> need to change the existing xsk field type from struct xdp_buff *xsk
>>>>>>> into struct mlx5e_xdp_buff *xsk and align the usage.
>>>>>>
>>>>>> Hmmm, good point. I'm actually not sure how it works currently.
>>>>>> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
>>>>>> am I missing something?
>>>>>
>>>>> It's initialised piecemeal in different places; but yeah, we're mixing
>>>>> things a bit...
>>>>>
>>>>>> I'm thinking about something like this:
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>> index af663978d1b4..2d77fb8a8a01 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
>>>>>>    union mlx5e_alloc_unit {
>>>>>>           struct page *page;
>>>>>>           struct xdp_buff *xsk;
>>>>>> -       struct mlx5e_xdp_buff *mxbuf;
>>>>>>    };
>>>>>
>>>>> Hmm, for consistency with the non-XSK path we should rather go the ot=
her
>>>>> direction and lose the xsk member, moving everything to mxbuf? Let me
>>>>> give that a shot...
>>>>
>>>> Something like the below?
>>>>
>>>> -Toke
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en.h
>>>> index 6de02d8aeab8..cb9cdb6421c5 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>> @@ -468,7 +468,6 @@ struct mlx5e_txqsq {
>>>>=20=20=20=20
>>>>    union mlx5e_alloc_unit {
>>>>    	struct page *page;
>>>> -	struct xdp_buff *xsk;
>>>>    	struct mlx5e_xdp_buff *mxbuf;
>>>>    };
>>>>=20=20=20=20
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/driver=
s/net/ethernet/mellanox/mlx5/core/en/xdp.h
>>>> index cb568c62aba0..95694a25ec31 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>>>> @@ -33,6 +33,7 @@
>>>>    #define __MLX5_EN_XDP_H__
>>>>=20=20=20=20
>>>>    #include <linux/indirect_call_wrapper.h>
>>>> +#include <net/xdp_sock_drv.h>
>>>>=20=20=20=20
>>>>    #include "en.h"
>>>>    #include "en/txrx.h"
>>>> @@ -112,6 +113,21 @@ static inline void mlx5e_xmit_xdp_doorbell(struct=
 mlx5e_xdpsq *sq)
>>>>    	}
>>>>    }
>>>>=20=20=20=20
>>>> +static inline struct mlx5e_xdp_buff *mlx5e_xsk_buff_alloc(struct xsk_=
buff_pool *pool)
>>>> +{
>>>> +	return (struct mlx5e_xdp_buff *)xsk_buff_alloc(pool);
>>>
>>> What about the space needed for the rq / cqe fields? xsk_buff_alloc
>>> won't allocate it.
>>=20
>> It will! See patch 14 in the series that adds a 'cb' field to
>> xdp_buff_xsk, meaning there's actually space after the xdp_buff struct
>> being allocated by the xsk_buff_alloc API. The XSK_CHECK_PRIV_TYPE macro
>> call is there to ensure the cb field is big enough for the struct we're
>> casting to in the driver.
>>=20
>
> Oh okay, got it.
>
>>>> +}
>>>> +
>>>> +static inline void mlx5e_xsk_buff_free(struct mlx5e_xdp_buff *mxbuf)
>>>> +{
>>>> +	xsk_buff_free(&mxbuf->xdp);
>>>> +}
>>>> +
>>>> +static inline dma_addr_t mlx5e_xsk_buff_xdp_get_frame_dma(struct mlx5=
e_xdp_buff *mxbuf)
>>>> +{
>>>> +	return xsk_buff_xdp_get_frame_dma(&mxbuf->xdp);
>>>> +}
>>>> +
>>>>    /* Enable inline WQEs to shift some load from a congested HCA (HW) =
to
>>>>     * a less congested cpu (SW).
>>>>     */
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>>>> index 8bf3029abd3c..1f166dbb7f22 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>>>> @@ -3,7 +3,6 @@
>>>>=20=20=20=20
>>>>    #include "rx.h"
>>>>    #include "en/xdp.h"
>>>> -#include <net/xdp_sock_drv.h>
>>>>    #include <linux/filter.h>
>>>>=20=20=20=20
>>>>    /* RX data path */
>>>> @@ -21,7 +20,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u1=
6 ix)
>>>>    	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per=
_wqe)))
>>>>    		goto err;
>>>>=20=20=20=20
>>>> -	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[=
0].xsk));
>>>> +	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[=
0].mxbuf));
>>>>    	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
>>>>    	batch =3D xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)w=
i->alloc_units,
>>>>    				     rq->mpwqe.pages_per_wqe);
>>>
>>> This batching API gets broken as well...
>>> xsk_buff_alloc_batch fills an array of struct xdp_buff pointers, it
>>> cannot correctly act on the array of struct mlx5e_xdp_buff, as it
>>> contains additional fields.
>>=20
>> See above for why this does, in fact, work. I agree it's not totally
>> obvious, and in any case there's going to be a point where the cast
>> happens where type safety will break, which is what I was alluding to in
>> my reply to Stanislav.
>>=20
>> I guess we could try to rework the API in xdp_sock_drv.h to make this
>> more obvious instead of using the casting driver-specific wrappers I
>> suggested here. Or we could go with Stanislav's suggestion of keeping
>> allocation etc using xdp_buff and only casting to mlx5e_xdp_buff in the
>> function where it's used; then we can keep the casting localised to that
>> function, and put a comment there explaining why it works?
>>=20
>
> Stanislav's proposal LGTM.
> Let's keep the casting localised, and make sure there's a comment there.

Alright, cool!

-Toke

