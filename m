Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF520668565
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbjALVbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240704AbjALVaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:30:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0400B1AA17
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673557761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qRZmqvXhb2nF8oyfgDRdsPHD4BOhp1E6vlAaM7IvjKQ=;
        b=UlfDa9DfnBhyE5AWaPB34tkTDP5WNk7h+29/QQyhAyz8A0b1zK/nAf5Kn+qmOuboTJQbMa
        4EQ3of7ceV5DPILkwTYIJU5kDBx9hPciZr7KnygvPhYoVF8Z1RBgOpc0TP5NyKwOfTqpJQ
        uHY6w2ijsmNGWdiB7xw2ES0m3uoiz2Y=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-473-_sMfFTuoPQKnkQ0bbD_0LQ-1; Thu, 12 Jan 2023 16:09:20 -0500
X-MC-Unique: _sMfFTuoPQKnkQ0bbD_0LQ-1
Received: by mail-ed1-f70.google.com with SMTP id m7-20020a056402510700b00488d1fcdaebso12971422edd.9
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRZmqvXhb2nF8oyfgDRdsPHD4BOhp1E6vlAaM7IvjKQ=;
        b=MbE7x0R/a328AfD1OaBDeeRQ+Ih/cwULzhfmh3O3hshpfndwMPk9C1tNRe6MfCE17U
         NKidKTi4lBWugP4a5AIkSrn02nPUnVhpufSmLpQ8ylmbyV1qmB7y1IhWpLFjOjT11ecO
         5Vqr1f6Nhf3iSCtD/CuOvMGOGKJStT/+s1c9arhsTFl59GPuw9OwC7XAxo09p4kG3cMs
         sMaACq0OE35xuCzk1EzfBlQoXyCzeuDn/MLNpoves/uXEENI0fkFf+Nsm0jz5bNXoe9O
         xpTCRTTO4dSTkcwVaxoo61Y1lXfVrHxM0w96REmLJCTFXs6G/s0B0gpp08lic6n+wlzo
         9DgQ==
X-Gm-Message-State: AFqh2kq4N5blcVP0ttv3T0riipq3qxGF6P2Pj2F8HD6jpV5QbU+eZsE+
        3IC3M547QR3ySe0RSubDlIIi8swzdBXhVhfO9P8nr3zPNQCxBOQVLtqjckp5fq2evhtQaFJxkkc
        PoiruSDgYcx0p34SZ
X-Received: by 2002:a17:907:a788:b0:7fd:ec83:b8b8 with SMTP id vx8-20020a170907a78800b007fdec83b8b8mr68328456ejc.19.1673557759237;
        Thu, 12 Jan 2023 13:09:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvnI2Xp7NQNgDDqPzkdNmTMwZjxoSIACaNZJ4Kh+MujVfoi7pKt8VZYEZWPa/tk3CaBBUxymw==
X-Received: by 2002:a17:907:a788:b0:7fd:ec83:b8b8 with SMTP id vx8-20020a170907a78800b007fdec83b8b8mr68328433ejc.19.1673557758922;
        Thu, 12 Jan 2023 13:09:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s17-20020a1709060c1100b0084d21db0691sm7846755ejf.179.2023.01.12.13.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 13:09:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 940CE90071B; Thu, 12 Jan 2023 22:09:17 +0100 (CET)
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
In-Reply-To: <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
 <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Jan 2023 22:09:17 +0100
Message-ID: <87k01rfojm.fsf@toke.dk>
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

Stanislav Fomichev <sdf@google.com> writes:

> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com> w=
rote:
>>
>>
>>
>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >
>> > Preparation for implementing HW metadata kfuncs. No functional change.
>> >
>> > Cc: Tariq Toukan <tariqt@nvidia.com>
>> > Cc: Saeed Mahameed <saeedm@nvidia.com>
>> > Cc: John Fastabend <john.fastabend@gmail.com>
>> > Cc: David Ahern <dsahern@gmail.com>
>> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> > Cc: Willem de Bruijn <willemb@google.com>
>> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>> > Cc: Maryam Tahhan <mtahhan@redhat.com>
>> > Cc: xdp-hints@xdp-project.net
>> > Cc: netdev@vger.kernel.org
>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> > ---
>> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>> >   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>> >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++--------=
--
>> >   5 files changed, 50 insertions(+), 43 deletions(-)
>> >
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en.h
>> > index 2d77fb8a8a01..af663978d1b4 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> > @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>> >   union mlx5e_alloc_unit {
>> >       struct page *page;
>> >       struct xdp_buff *xsk;
>> > +     struct mlx5e_xdp_buff *mxbuf;
>>
>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf and
>> alloc_units[page_idx].xsk, while both fields share the memory of a union.
>>
>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
>> need to change the existing xsk field type from struct xdp_buff *xsk
>> into struct mlx5e_xdp_buff *xsk and align the usage.
>
> Hmmm, good point. I'm actually not sure how it works currently.
> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
> am I missing something?

It's initialised piecemeal in different places; but yeah, we're mixing
things a bit...

> I'm thinking about something like this:
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index af663978d1b4..2d77fb8a8a01 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
>  union mlx5e_alloc_unit {
>         struct page *page;
>         struct xdp_buff *xsk;
> -       struct mlx5e_xdp_buff *mxbuf;
>  };

Hmm, for consistency with the non-XSK path we should rather go the other
direction and lose the xsk member, moving everything to mxbuf? Let me
give that a shot...

-Toke

