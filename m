Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EE96381EF
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 01:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiKYAhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 19:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYAht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 19:37:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EA5827FD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 16:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669336616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVrOkDrmMGpa5h7AIlaFraeH3E0rHqCXhdxo/iWpc3M=;
        b=XBFVp4HnA/btmGL5SXFWdcy+bQD2QbqbCfEb9vcdJ/Rv5d8f+dwIcFhjak3SxKK/KqdZu7
        tnakvykpxgYyWDypu/tx9Fvch4foQxNLLz2P9pjaIu492VN4WiPaHFDFctsvLdp2w7bzSF
        XyT312brCz5+PPwaoeVn7CUAu05Xz/M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-354-n_ryq-NVPZ6I-cOOFCjojA-1; Thu, 24 Nov 2022 19:36:54 -0500
X-MC-Unique: n_ryq-NVPZ6I-cOOFCjojA-1
Received: by mail-ej1-f71.google.com with SMTP id sh31-20020a1709076e9f00b007ae32b7eb51so1564193ejc.9
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 16:36:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVrOkDrmMGpa5h7AIlaFraeH3E0rHqCXhdxo/iWpc3M=;
        b=jXcMjjexK2dZ22Pfr7aB4ISavpXnByMNWvbxmSXdCvXNVzpuVBmymmYFNHxD0LygsI
         ygjswm0+JmkPCGcK4X3zArUA8aDUMDR21zvKQGvRN3Wmo9g+LS56CccSZEwLsjBtLO+C
         C/Rwb6zTDKPVTIvkzO04gBJ3x2e7MwnR5lkLFvAZ4EtdLlONN4aTAR8xHn1T9j38lo1i
         BEXc5r04JqogS8Z1tL9/FPzvMbZ3PfqvcxWnhD5U8vhlZsEoKhKi6Cc/4uAEWAKbvfth
         wmnMEZJ721jt+9xEjMMRAT029MuQ8uA3rUNWBeXWXqvWgDNQpJ9hPhgBaVfjiSpLUEb1
         LjxA==
X-Gm-Message-State: ANoB5pkeP8gjuCAscroDSYrvYmK9MvdEjxO2bdvG+2tTHVyKqUIdygWV
        qlE3gKH+DNWcC1hM4E3kTkSi6o7F7qRYJrvyOa5Km1kbBSWKH981ktTozxdHR+TEVBdV66K+v6t
        YKQvqrgenkX/f/Fy4
X-Received: by 2002:a17:906:810:b0:7ba:5b85:994f with SMTP id e16-20020a170906081000b007ba5b85994fmr7093362ejd.510.1669336613671;
        Thu, 24 Nov 2022 16:36:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5kN53QWAHI3CajHtXDJoe0dz9z+qfwYwqCLE3CqwTYapDEN2akUb+MJf0gMCXGfUJU4PLHlQ==
X-Received: by 2002:a17:906:810:b0:7ba:5b85:994f with SMTP id e16-20020a170906081000b007ba5b85994fmr7093337ejd.510.1669336613264;
        Thu, 24 Nov 2022 16:36:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i10-20020a05640242ca00b00467c3cbab6fsm1115299edc.77.2022.11.24.16.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 16:36:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D11337EB6D8; Fri, 25 Nov 2022 01:36:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, sdf@google.com,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
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
In-Reply-To: <Y3+XtkkIh0o++Dgr@boxer>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com> <874jupviyc.fsf@toke.dk>
 <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org> <Y3557Ecr80Y9ZD2z@google.com>
 <871qptuyie.fsf@toke.dk> <20221123174746.418920e5@kernel.org>
 <87edts2z8n.fsf@toke.dk> <Y3+K7dJLFX7gRQp+@boxer> <Y3+XtkkIh0o++Dgr@boxer>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Nov 2022 01:36:51 +0100
Message-ID: <874jun3m58.fsf@toke.dk>
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

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Thu, Nov 24, 2022 at 04:17:01PM +0100, Maciej Fijalkowski wrote:
>> On Thu, Nov 24, 2022 at 03:39:20PM +0100, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>> > Jakub Kicinski <kuba@kernel.org> writes:
>> >=20
>> > > On Wed, 23 Nov 2022 22:55:21 +0100 Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
>> > >> > Good idea, prototyped below, lmk if it that's not what you had in=
 mind.
>> > >> >
>> > >> > struct xdp_buff_xsk {
>> > >> > 	struct xdp_buff            xdp;                  /*     0    56 =
*/
>> > >> > 	u8                         cb[16];               /*    56    16 =
*/
>> > >> > 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */=20=
=20
>> > >>=20
>> > >> As pahole helpfully says here, xdp_buff is actually only 8 bytes fr=
om
>> > >> being a full cache line. I thought about adding a 'cb' field like t=
his
>> > >> to xdp_buff itself, but figured that since there's only room for a
>> > >> single pointer, why not just add that and let the driver point it to
>> > >> where it wants to store the extra context data?
>> > >
>> > > What if the driver wants to store multiple pointers or an integer or
>> > > whatever else? The single pointer seems quite arbitrary and not
>> > > strictly necessary.
>> >=20
>> > Well, then you allocate a separate struct and point to that? Like I did
>> > in mlx5:
>> >=20
>> >=20
>> > +	struct mlx5_xdp_ctx mlctx =3D { .cqe =3D cqe, .rq =3D rq };
>> > +	struct xdp_buff xdp =3D { .drv_priv =3D &mlctx };
>> >=20
>> > but yeah, this does give an extra pointer deref on access. I'm not
>> > really opposed to the cb field either, I just think it's a bit odd to
>> > put it in struct xdp_buff_xsk; that basically requires the driver to
>> > keep the layouts in sync.
>> >=20
>> > Instead, why not but a cb field into xdp_buff itself so it can be used
>> > for both the XSK and the non-XSK paths? Then the driver can just
>> > typecast the xdp_buff into its own struct that has whatever data it
>> > wants in place of the cb field?
>>=20
>> Why can't you simply have a pointer to xdp_buff in driver specific
>> xdp_buff container which would point to xdp_buff that is stack based (or
>> whatever else memory that will back it up - I am about to push a change
>> that makes ice driver embed xdp_buff within a struct that represents Rx
>> ring) for XDP path and for ZC the pointer to xdp_buff that you get from
>> xsk_buff_pool ? This would satisfy both sides I believe and would let us
>> keep the same container struct.
>>=20
>> struct mlx4_xdp_buff {
>> 	struct xdp_buff *xdp;
>> 	struct mlx4_cqe *cqe;
>> 	struct mlx4_en_dev *mdev;
>> 	struct mlx4_en_rx_ring *ring;
>> 	struct net_device *dev;
>> };
>
> Nah this won't work from kfunc POV, probably no way to retrieve the
> mlx4_xdp_buff based on xdp_buff ptr that needs to be used as an arg.
>
> Sorry I'll think more about it, in the meantime let's hear more voices
> whether we should keep Stan's original approach + modify xdp_buff_xsk or
> go with Toke's proposal.

OK, so I played around with the mlx5 code a bit more, and I think the
"wrapping struct + cb area" can be made to work without too many ugly
casts; I'll send an updated version of the mlx5 patches with this
incorporated tomorrow, after I've run some tests...

-Toke

