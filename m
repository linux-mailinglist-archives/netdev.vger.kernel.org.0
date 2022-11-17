Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86D062D96E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiKQLde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiKQLdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:33:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EF848763
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668684756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TqGQL7f1VO0oELXAbLB5ugC34/GyGd79wtlJNVZt8i4=;
        b=AfWJS63HRuee6RQKnnQqTxJD/a1ChM3XLv8GaW0x3XFmcZd5jLj9Seb19UHkLmlzTl5ZUg
        o8XWbB2hYOqrjmd1y0gvWc+uPQgFD2KXojhUeFMgLLSK1fA5Z44F0zGUFE+RDuhsyX0XE5
        vrPrhdd9MU+D4rnlPRMPjsfQ0RrM1cc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-QhBknQ39Nm65YUJ1xjrSrQ-1; Thu, 17 Nov 2022 06:32:35 -0500
X-MC-Unique: QhBknQ39Nm65YUJ1xjrSrQ-1
Received: by mail-ej1-f72.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso946205ejb.14
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 03:32:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TqGQL7f1VO0oELXAbLB5ugC34/GyGd79wtlJNVZt8i4=;
        b=rLPs6yryvYU91JARAtcZ3oHyu4uzLpyCnL9A0vxspDqQbM/Tn/Pp4qC+HFysdNcc4g
         NNx3e1NXbAHpd5lT9eRdOG47PfA5WjQl8sA/ma8EvN/5wwokmq6qaxuJHDirYRy5xWL7
         62Bffn2oVCHb7Cb/q9MrcVHVb0sJ41/NNcrZEH0bAitZQZv++e2vMxK/lvnGG17h9xQ0
         x93mPHRkBbS6J4AtQLwad3UFISqQZgAsxIgSvspWuwX0vZFy8K/SSz1biUikx/Ym3oA3
         G6kpi+Y/Lo2sWkCHT8ObDafhf3GjTXWh3jEhVnnWgw+kP1x/K3cMzwNGMBVTMolo8Uir
         KlPA==
X-Gm-Message-State: ANoB5pmI5enSKlkdGSd/58fzrzUhdi5emqgKhEQACswFt+Q8eqP+4KYP
        e7u4yK+iATbbNhPDvbtqnFjQfAF5Oc7ShZWSYzy0JYhkH7s/kxRMuMi0uG5HWCHKRmTtCcZXcqA
        t4aRnaCONgRqdrHbf
X-Received: by 2002:a17:907:7611:b0:7ae:bc3b:d9c6 with SMTP id jx17-20020a170907761100b007aebc3bd9c6mr1633122ejc.770.1668684753725;
        Thu, 17 Nov 2022 03:32:33 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4FDPSA2bFot9pEEWUNSs2DyZF1gHv0A8iE/vXrtKslN50mPd5zjItty36Nhjk3PExk7IhqkA==
X-Received: by 2002:a17:907:7611:b0:7ae:bc3b:d9c6 with SMTP id jx17-20020a170907761100b007aebc3bd9c6mr1633108ejc.770.1668684753381;
        Thu, 17 Nov 2022 03:32:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id bw10-20020a170906c1ca00b0078dce9984afsm238635ejb.220.2022.11.17.03.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 03:32:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 638917A6F66; Thu, 17 Nov 2022 12:32:31 +0100 (CET)
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
In-Reply-To: <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
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
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Nov 2022 12:32:31 +0100
Message-ID: <87wn7t4y0g.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
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

>> > Doesn't look like the descriptors are as nice as you're trying to
>> > paint them (with clear hash/csum fields) :-) So not sure how much
>> > CO-RE would help.
>> > At least looking at mlx4 rx_csum, the driver consults three different
>> > sets of flags to figure out the hash_type. Or am I just unlucky with
>> > mlx4?
>>
>> Which part are you talking about ?
>>         hw_checksum = csum_unfold((__force __sum16)cqe->checksum);
>> is trivial enough for bpf prog to do if it has access to 'cqe' pointer
>> which is what John is proposing (I think).
>
> I'm talking about mlx4_en_process_rx_cq, the caller of that check_csum.
> In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
> I'm assuming we want to have hash_type available to the progs?

I agree we should expose the hash_type, but that doesn't actually look
to be that complicated, see below.

> But also, check_csum handles other corner cases:
> - short_frame: we simply force all those small frames to skip checksum complete
> - get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes from
> IPv6 header
> - get_fixed_ipv4_csum: Although the stack expects checksum which
> doesn't include the pseudo header, the HW adds it
>
> So it doesn't look like we can just unconditionally use cqe->checksum?
> The driver does a lot of massaging around that field to make it
> palatable.

Poking around a bit in the other drivers, AFAICT it's only a subset of
drivers that support CSUM_COMPLETE at all; for instance, the Intel
drivers just set CHECKSUM_UNNECESSARY for TCP/UDP/SCTP. I think the
CHECKSUM_UNNECESSARY is actually the most important bit we'd want to
propagate?

AFAICT, the drivers actually implementing CHECKSUM_COMPLETE need access
to other data structures than the rx descriptor to determine the status
of the checksum (mlx4 looks at priv->flags, mlx5 checks rq->state), so
just exposing the rx descriptor to BPF as John is suggesting does not
actually give the XDP program enough information to act on the checksum
field on its own. We could still have a separate kfunc to just expose
the hw checksum value (see below), but I think it probably needs to be
paired with other kfuncs to be useful.

Looking at the mlx4 code, I think the following mapping to kfuncs (in
pseudo-C) would give the flexibility for XDP to access all the bits it
needs, while inlining everything except getting the full checksum for
non-TCP/UDP traffic. An (admittedly cursory) glance at some of the other
drivers (mlx5, ice, i40e) indicates that this would work for those
drivers as well.


bpf_xdp_metadata_rx_hash_supported() {
  return dev->features & NETIF_F_RXHASH;
}

bpf_xdp_metadata_rx_hash() {
  return be32_to_cpu(cqe->immed_rss_invalid);
}

bpf_xdp_metdata_rx_hash_type() {
  if (likely(dev->features & NETIF_F_RXCSUM) &&
      (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP | MLX4_CQE_STATUS_UDP)) &&
	(cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
	  cqe->checksum == cpu_to_be16(0xffff))
     return PKT_HASH_TYPE_L4;

   return PKT_HASH_TYPE_L3;
}

bpf_xdp_metadata_rx_csum_supported() {
  return dev->features & NETIF_F_RXCSUM;
}

bpf_xdp_metadata_rx_csum_level() {
	if ((cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP |
				       MLX4_CQE_STATUS_UDP)) &&
	    (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
	    cqe->checksum == cpu_to_be16(0xffff))
            return CHECKSUM_UNNECESSARY;
            
	if (!(priv->flags & MLX4_EN_FLAG_RX_CSUM_NON_TCP_UDP &&
	      (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IP_ANY))) &&
              !short_frame(len))
            return CHECKSUM_COMPLETE; /* we could also omit this case entirely */

        return CHECKSUM_NONE;
}

/* this one could be called by the metadata_to_skb code */
bpf_xdp_metadata_rx_csum_full() {
  return check_csum() /* BPF_CALL this after refactoring so it is skb-agnostic */
}

/* this one would be for people like John who want to re-implement
 * check_csum() themselves */
bpf_xdp_metdata_rx_csum_raw() {
  return cqe->checksum;
}


-Toke

