Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7566A526
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjAMVc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjAMVcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:32:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE30FCE5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 13:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673645525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBQ2obDxMXX42qL3YkJjJ5dlV/jxi9z9Rx4B7IugdIs=;
        b=OWiNHlpZ48C8huwfeecTGHgkzMxLQu2UoDPcUFfgXoysf1/jXMctMcITZGOULJnPkY6P+V
        8aosy7v+MKXc4ML9b5RVqJHcmkN7attnAOt9hBmICTmXZYxMz3CZ/5wLFjGdZfRWXriufb
        xECwo0Z2ftZSDsTfP0afve6/CEPUEQQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-147-T7sQr0Z6OrW7xclTknk_8A-1; Fri, 13 Jan 2023 16:32:04 -0500
X-MC-Unique: T7sQr0Z6OrW7xclTknk_8A-1
Received: by mail-ej1-f72.google.com with SMTP id sa32-20020a1709076d2000b0084d4593797eso12472225ejc.16
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 13:32:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBQ2obDxMXX42qL3YkJjJ5dlV/jxi9z9Rx4B7IugdIs=;
        b=42bSw8DqCKdOffrJeSGpkbhrMe2r2ECOxFhGaM+GTjM8hq0FT2l86bAOaUabeFnPXF
         Kq78cF+Jk4NbfjF4w7i5XtrfRuWpPkaPynTdNp0AyTRjkK9Ss4sWxbh/j3FMRRmZiW45
         85RGxPlHj1+x5aEle6R1LUm26+bJclOWHMsS1CToeOwkircyZjdt4BuiTUkszepXUwMv
         bki7SQ6Ir88eWIJFrm4MGSvGGHUmqT60SuxyvtWAaSKItDlHNPLAamG3EM9hMvuIi0x/
         kiCRJLQQggHweViD/1op76ZcjBwNOf6L0ztmMVIBhiymi9heHHqQRG2UU4icf+7fy/qu
         XtMw==
X-Gm-Message-State: AFqh2krdT6CgIDJ09z7Rbi+/Tbrz8cg1dE3w+W0haa42KSl7u3P4+3qS
        g7JAB1W69QjIY91hjOLV7tYIEijLZWSvdlLvPjsr5HsTrUXhiB6L1yMfXulwUckT3jLjWZ47+Zg
        YCyJU/tw3TQILseur
X-Received: by 2002:a17:906:3a93:b0:7c0:f7b0:9aed with SMTP id y19-20020a1709063a9300b007c0f7b09aedmr65347258ejd.55.1673645522957;
        Fri, 13 Jan 2023 13:32:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv06bbX6NW7l/TNj9Attm0dFHFTcDfcNOkYM+nFsg8q3ifgVssu2cYchc0pXNxuvM9ku2s1bQ==
X-Received: by 2002:a17:906:3a93:b0:7c0:f7b0:9aed with SMTP id y19-20020a1709063a9300b007c0f7b09aedmr65347172ejd.55.1673645521009;
        Fri, 13 Jan 2023 13:32:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id qw25-20020a1709066a1900b00781dbdb292asm8948619ejc.155.2023.01.13.13.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 13:32:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 54F95900963; Fri, 13 Jan 2023 22:31:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>
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
In-Reply-To: <d83f2193-3fb9-e30f-cfb0-f1098f039b67@gmail.com>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
 <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
 <87k01rfojm.fsf@toke.dk> <87h6wvfmfa.fsf@toke.dk>
 <d83f2193-3fb9-e30f-cfb0-f1098f039b67@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 13 Jan 2023 22:31:59 +0100
Message-ID: <87358ef7e8.fsf@toke.dk>
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

> On 12/01/2023 23:55, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>>=20
>>> Stanislav Fomichev <sdf@google.com> writes:
>>>
>>>> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com=
> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>>>>>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>>>
>>>>>> Preparation for implementing HW metadata kfuncs. No functional chang=
e.
>>>>>>
>>>>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>>>>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>>>>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>>>>> Cc: David Ahern <dsahern@gmail.com>
>>>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>>>> Cc: xdp-hints@xdp-project.net
>>>>>> Cc: netdev@vger.kernel.org
>>>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>>> ---
>>>>>>    drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>>>>>    .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>>>>>>    .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>>>>>>    .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>>>>>>    .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++-----=
-----
>>>>>>    5 files changed, 50 insertions(+), 43 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en.h
>>>>>> index 2d77fb8a8a01..af663978d1b4 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>> @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>>>>>>    union mlx5e_alloc_unit {
>>>>>>        struct page *page;
>>>>>>        struct xdp_buff *xsk;
>>>>>> +     struct mlx5e_xdp_buff *mxbuf;
>>>>>
>>>>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf =
and
>>>>> alloc_units[page_idx].xsk, while both fields share the memory of a un=
ion.
>>>>>
>>>>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
>>>>> need to change the existing xsk field type from struct xdp_buff *xsk
>>>>> into struct mlx5e_xdp_buff *xsk and align the usage.
>>>>
>>>> Hmmm, good point. I'm actually not sure how it works currently.
>>>> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
>>>> am I missing something?
>>>
>>> It's initialised piecemeal in different places; but yeah, we're mixing
>>> things a bit...
>>>
>>>> I'm thinking about something like this:
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>> index af663978d1b4..2d77fb8a8a01 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
>>>>   union mlx5e_alloc_unit {
>>>>          struct page *page;
>>>>          struct xdp_buff *xsk;
>>>> -       struct mlx5e_xdp_buff *mxbuf;
>>>>   };
>>>
>>> Hmm, for consistency with the non-XSK path we should rather go the other
>>> direction and lose the xsk member, moving everything to mxbuf? Let me
>>> give that a shot...
>>=20
>> Something like the below?
>>=20
>> -Toke
>>=20
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en.h
>> index 6de02d8aeab8..cb9cdb6421c5 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> @@ -468,7 +468,6 @@ struct mlx5e_txqsq {
>>=20=20=20
>>   union mlx5e_alloc_unit {
>>   	struct page *page;
>> -	struct xdp_buff *xsk;
>>   	struct mlx5e_xdp_buff *mxbuf;
>>   };
>>=20=20=20
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xdp.h
>> index cb568c62aba0..95694a25ec31 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>> @@ -33,6 +33,7 @@
>>   #define __MLX5_EN_XDP_H__
>>=20=20=20
>>   #include <linux/indirect_call_wrapper.h>
>> +#include <net/xdp_sock_drv.h>
>>=20=20=20
>>   #include "en.h"
>>   #include "en/txrx.h"
>> @@ -112,6 +113,21 @@ static inline void mlx5e_xmit_xdp_doorbell(struct m=
lx5e_xdpsq *sq)
>>   	}
>>   }
>>=20=20=20
>> +static inline struct mlx5e_xdp_buff *mlx5e_xsk_buff_alloc(struct xsk_bu=
ff_pool *pool)
>> +{
>> +	return (struct mlx5e_xdp_buff *)xsk_buff_alloc(pool);
>
> What about the space needed for the rq / cqe fields? xsk_buff_alloc=20
> won't allocate it.

It will! See patch 14 in the series that adds a 'cb' field to
xdp_buff_xsk, meaning there's actually space after the xdp_buff struct
being allocated by the xsk_buff_alloc API. The XSK_CHECK_PRIV_TYPE macro
call is there to ensure the cb field is big enough for the struct we're
casting to in the driver.

>> +}
>> +
>> +static inline void mlx5e_xsk_buff_free(struct mlx5e_xdp_buff *mxbuf)
>> +{
>> +	xsk_buff_free(&mxbuf->xdp);
>> +}
>> +
>> +static inline dma_addr_t mlx5e_xsk_buff_xdp_get_frame_dma(struct mlx5e_=
xdp_buff *mxbuf)
>> +{
>> +	return xsk_buff_xdp_get_frame_dma(&mxbuf->xdp);
>> +}
>> +
>>   /* Enable inline WQEs to shift some load from a congested HCA (HW) to
>>    * a less congested cpu (SW).
>>    */
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>> index 8bf3029abd3c..1f166dbb7f22 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>> @@ -3,7 +3,6 @@
>>=20=20=20
>>   #include "rx.h"
>>   #include "en/xdp.h"
>> -#include <net/xdp_sock_drv.h>
>>   #include <linux/filter.h>
>>=20=20=20
>>   /* RX data path */
>> @@ -21,7 +20,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 =
ix)
>>   	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wq=
e)))
>>   		goto err;
>>=20=20=20
>> -	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[0]=
.xsk));
>> +	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[0]=
.mxbuf));
>>   	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
>>   	batch =3D xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->=
alloc_units,
>>   				     rq->mpwqe.pages_per_wqe);
>
> This batching API gets broken as well...
> xsk_buff_alloc_batch fills an array of struct xdp_buff pointers, it=20
> cannot correctly act on the array of struct mlx5e_xdp_buff, as it=20
> contains additional fields.

See above for why this does, in fact, work. I agree it's not totally
obvious, and in any case there's going to be a point where the cast
happens where type safety will break, which is what I was alluding to in
my reply to Stanislav.

I guess we could try to rework the API in xdp_sock_drv.h to make this
more obvious instead of using the casting driver-specific wrappers I
suggested here. Or we could go with Stanislav's suggestion of keeping
allocation etc using xdp_buff and only casting to mlx5e_xdp_buff in the
function where it's used; then we can keep the casting localised to that
function, and put a comment there explaining why it works?

> Maybe letting mlx5e_xdp_buff point to its struct xdp_buff (instead of=20
> wrapping it) will solve the problems here, then we'll loop over the=20
> xdp_buff * array and copy the pointers into the struct mlx5e_xdp_buff *=20
> array.
> Need to give it deeper thoughts...
>
> struct mlx5e_xdp_buff {
> 	struct xdp_buff *xdp;
> 	struct mlx5_cqe64 *cqe;
> 	struct mlx5e_rq *rq;
> };

This was actually my original proposal; we discussed this back on v2 of
this patch series. People generally felt that the 'cb' field approach
(originally suggested by Jakub) was better. See the discussion starting
from here:

https://lore.kernel.org/r/20221123111431.7b54668e@kernel.org

-Toke

