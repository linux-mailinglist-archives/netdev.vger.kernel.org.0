Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9526C62E9D4
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiKQXrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiKQXrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:47:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADA3A451
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668728813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t4amhDHKsYSMHWw3ZB+fT/YBGFiZSg1p/vLZ6sF81EM=;
        b=JT9tTRqoliJZ5A6VTL+saUo7rvl+3jylEkd2Ptr3jBOgmkgp2pZG/6FAcWA/quQ3JV/054
        wZjjh/sTmNJm8mNOwQbycFD5d05g92owYjmfeKCmiFt7TTGvN5zybxhkKfNmUNaumQberm
        Ub0EuuJErFPgDfI5bscGzufTVwqiNA0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-n-pQsnT7NjOvfg7k2p27Cg-1; Thu, 17 Nov 2022 18:46:51 -0500
X-MC-Unique: n-pQsnT7NjOvfg7k2p27Cg-1
Received: by mail-ed1-f71.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so2058287edz.21
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 15:46:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t4amhDHKsYSMHWw3ZB+fT/YBGFiZSg1p/vLZ6sF81EM=;
        b=OJSxItCv4jIgncDulD+jKtBtFRkC+w2x/A7t+DO7OK+YfTZWMtOUb+W7PZgMktct+T
         J17mJj/JqyaBEu/hfTQa8RDXSY68JRs+8TZEsohgMEYDtoQrHMiBubNrhW/flih3XKvo
         OMIsvZt0uo6cuvHYR2Ydi/FMxodIcYAO9krngCKD32RtE+qrLdg5JptSLSJ9Fd3cT6KW
         SO2B+/4SIQHPSW2N2CqIXQQUDcHbAJaU2dxuJJ2Z1/FNw5kGFB1C0E2VTy17MQMKzTJL
         wvHKWScwLuGHzlo9qI6xxXHu6Q02A8BcrFgrskSOTdGkfH17GNg+pgBt/djz/dFFYMt+
         xO/A==
X-Gm-Message-State: ANoB5pnH0JezG1qPSGMMoRtH9fnPU/joedsVKyECOhkblGqcCnmH7jUX
        54GfpolnCerj1RVdjgp5BuHOMAUIIw22oJ+SpNsVPIXyx0YijBTCIJq4DUtidIIgXVyTtEKZzl3
        Z0R/jVAzAXqSoUs1j
X-Received: by 2002:a17:906:791:b0:7ad:14f8:7583 with SMTP id l17-20020a170906079100b007ad14f87583mr4074848ejc.185.1668728810208;
        Thu, 17 Nov 2022 15:46:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5xbcfwM/CIQaQKBLzuqeKKGNTHSR6fYH18SUafOXx+saLrIDVlD+zoA8TAuKC4YfWcmovUKg==
X-Received: by 2002:a17:906:791:b0:7ad:14f8:7583 with SMTP id l17-20020a170906079100b007ad14f87583mr4074814ejc.185.1668728809728;
        Thu, 17 Nov 2022 15:46:49 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906292a00b007ad96726c42sm959726ejd.91.2022.11.17.15.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 15:46:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ED9B37A701D; Fri, 18 Nov 2022 00:46:46 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx
 timestamp metadata for xdp
In-Reply-To: <CAKH8qBsPinmCO0Ny1hva7kp4+C7XFdxZLPBYEHXQWDjJ5SSoYw@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com> <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch>
 <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev> <878rkbjjnp.fsf@toke.dk>
 <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch>
 <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
 <87wn7t4y0g.fsf@toke.dk>
 <CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com>
 <CAKH8qBsPinmCO0Ny1hva7kp4+C7XFdxZLPBYEHXQWDjJ5SSoYw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Nov 2022 00:46:46 +0100
Message-ID: <874juxywih.fsf@toke.dk>
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

Stanislav Fomichev <sdf@google.com> writes:

> On Thu, Nov 17, 2022 at 8:59 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Thu, Nov 17, 2022 at 3:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >
>> > Stanislav Fomichev <sdf@google.com> writes:
>> >
>> > >> > Doesn't look like the descriptors are as nice as you're trying to
>> > >> > paint them (with clear hash/csum fields) :-) So not sure how much
>> > >> > CO-RE would help.
>> > >> > At least looking at mlx4 rx_csum, the driver consults three diffe=
rent
>> > >> > sets of flags to figure out the hash_type. Or am I just unlucky w=
ith
>> > >> > mlx4?
>> > >>
>> > >> Which part are you talking about ?
>> > >>         hw_checksum =3D csum_unfold((__force __sum16)cqe->checksum);
>> > >> is trivial enough for bpf prog to do if it has access to 'cqe' poin=
ter
>> > >> which is what John is proposing (I think).
>> > >
>> > > I'm talking about mlx4_en_process_rx_cq, the caller of that check_cs=
um.
>> > > In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
>> > > I'm assuming we want to have hash_type available to the progs?
>> >
>> > I agree we should expose the hash_type, but that doesn't actually look
>> > to be that complicated, see below.
>> >
>> > > But also, check_csum handles other corner cases:
>> > > - short_frame: we simply force all those small frames to skip checks=
um complete
>> > > - get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes fr=
om
>> > > IPv6 header
>> > > - get_fixed_ipv4_csum: Although the stack expects checksum which
>> > > doesn't include the pseudo header, the HW adds it
>> > >
>> > > So it doesn't look like we can just unconditionally use cqe->checksu=
m?
>> > > The driver does a lot of massaging around that field to make it
>> > > palatable.
>> >
>> > Poking around a bit in the other drivers, AFAICT it's only a subset of
>> > drivers that support CSUM_COMPLETE at all; for instance, the Intel
>> > drivers just set CHECKSUM_UNNECESSARY for TCP/UDP/SCTP. I think the
>> > CHECKSUM_UNNECESSARY is actually the most important bit we'd want to
>> > propagate?
>> >
>> > AFAICT, the drivers actually implementing CHECKSUM_COMPLETE need access
>> > to other data structures than the rx descriptor to determine the status
>> > of the checksum (mlx4 looks at priv->flags, mlx5 checks rq->state), so
>> > just exposing the rx descriptor to BPF as John is suggesting does not
>> > actually give the XDP program enough information to act on the checksum
>> > field on its own. We could still have a separate kfunc to just expose
>> > the hw checksum value (see below), but I think it probably needs to be
>> > paired with other kfuncs to be useful.
>> >
>> > Looking at the mlx4 code, I think the following mapping to kfuncs (in
>> > pseudo-C) would give the flexibility for XDP to access all the bits it
>> > needs, while inlining everything except getting the full checksum for
>> > non-TCP/UDP traffic. An (admittedly cursory) glance at some of the oth=
er
>> > drivers (mlx5, ice, i40e) indicates that this would work for those
>> > drivers as well.
>> >
>> >
>> > bpf_xdp_metadata_rx_hash_supported() {
>> >   return dev->features & NETIF_F_RXHASH;
>> > }
>> >
>> > bpf_xdp_metadata_rx_hash() {
>> >   return be32_to_cpu(cqe->immed_rss_invalid);
>> > }
>> >
>> > bpf_xdp_metdata_rx_hash_type() {
>> >   if (likely(dev->features & NETIF_F_RXCSUM) &&
>> >       (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP | MLX4_CQE_STATUS=
_UDP)) &&
>> >         (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
>> >           cqe->checksum =3D=3D cpu_to_be16(0xffff))
>> >      return PKT_HASH_TYPE_L4;
>> >
>> >    return PKT_HASH_TYPE_L3;
>> > }
>> >
>> > bpf_xdp_metadata_rx_csum_supported() {
>> >   return dev->features & NETIF_F_RXCSUM;
>> > }
>> >
>> > bpf_xdp_metadata_rx_csum_level() {
>> >         if ((cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP |
>> >                                        MLX4_CQE_STATUS_UDP)) &&
>> >             (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
>> >             cqe->checksum =3D=3D cpu_to_be16(0xffff))
>> >             return CHECKSUM_UNNECESSARY;
>> >
>> >         if (!(priv->flags & MLX4_EN_FLAG_RX_CSUM_NON_TCP_UDP &&
>> >               (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IP_ANY))) &&
>> >               !short_frame(len))
>> >             return CHECKSUM_COMPLETE; /* we could also omit this case =
entirely */
>> >
>> >         return CHECKSUM_NONE;
>> > }
>> >
>> > /* this one could be called by the metadata_to_skb code */
>> > bpf_xdp_metadata_rx_csum_full() {
>> >   return check_csum() /* BPF_CALL this after refactoring so it is skb-=
agnostic */
>> > }
>> >
>> > /* this one would be for people like John who want to re-implement
>> >  * check_csum() themselves */
>> > bpf_xdp_metdata_rx_csum_raw() {
>> >   return cqe->checksum;
>> > }
>>
>> Are you proposing a bunch of per-driver kfuncs that bpf prog will call.
>> If so that works, but bpf prog needs to pass dev and cqe pointers
>> into these kfuncs, so they need to be exposed to the prog somehow.
>> Probably through xdp_md ?

No, I didn't mean we should call per-driver kfuncs; the examples above
were meant to be examples of what the mlx4 driver would unrolls those
kfuncs to. Sorry that that wasn't clear.

> So far I'm doing:
>
> struct mlx4_xdp_buff {
>   struct xdp_buff xdp;
>   struct mlx4_cqe *cqe;
>   struct mlx4_en_dev *mdev;
> }
>
> And then the kfuncs get ctx (aka xdp_buff) as a sole argument and can
> find cqe/mdev via container_of.
>
> If we really need these to be exposed to the program, can we use
> Yonghong's approach from [0]?

I don't think we should expose them to the BPF program; I like your
approach of stuffing them next to the CTX pointer and de-referencing
that. This makes it up to the driver which extra objects it needs, and
the caller doesn't have to know/care.

I'm not vehemently opposed to *also* having the rx-desc pointer directly
accessible (in which case Yonghong's kfunc approach is probably fine).
However, as mentioned in my previous email, I doubt how useful that
descriptor itself will be...

>> This way we can have both: bpf prog reading cqe fields directly
>> and using kfuncs to access things.
>> Inlining of kfuncs should be done generically.
>> It's not a driver job to convert native asm into bpf asm.
>
> Ack. I can replace the unrolling with something that just resolves
> "generic" kfuncs to the per-driver implementation maybe? That would at
> least avoid netdev->ndo_kfunc_xxx indirect calls at runtime..

As stated above, I think we should keep the unrolling. If we end up with
an actual CALL instruction for every piece of metadata that's going to
suck performance-wise; unrolling is how we keep this fast enough! :)

-Toke

