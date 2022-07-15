Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A80576251
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiGOMzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiGOMzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:55:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 149CC10FDD
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657889738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOV6gCN0knh8EXo83MFRYcVha3MN8ws4cl3JXlY06yM=;
        b=F2Lfyxk31UHsUy06zeJWPNZoxYHB5zb0vapta+pSU4Fm1p6oVoN2W5WXVIaal6oiKPGSRm
        qOzPHU1cOPiJZ2KoWccik/L2VRirfDO7K/cGnrqF+fQWL9fA6yZtXA8nvlCrclNlS7u/4B
        067ysbvGJBAc2sq5cVelMTsSxaZguUg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-5bvOhm06P0OS3amsnw1Gxg-1; Fri, 15 Jul 2022 08:55:37 -0400
X-MC-Unique: 5bvOhm06P0OS3amsnw1Gxg-1
Received: by mail-ed1-f71.google.com with SMTP id z14-20020a056402274e00b0043ae5c003c1so3422340edd.9
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=mOV6gCN0knh8EXo83MFRYcVha3MN8ws4cl3JXlY06yM=;
        b=IGWsmnoVWXBa2jqEljNFz+WVeT6nQM8GgBk2Eyec3Ip5sy8H7HwVY9B7ZggcGrFP3r
         As5x0Wy2ycxR1QZs8r/VJ4GfwHbCg4mKcyU2UAnrEYwVHQ5ah7P1pQBjVyTNbum6FRMH
         fPY3bVdaDNSDbYIG8bNIYCRtyFup7yT7d1SWKJ0ZEAOONJ5EyNZfuAQJ6te+NabBCWn2
         SrRw/ZWThT72dISCQ9zksHO44K0x8SGvBUZ4K5SfAiq9CLLhD0W+k1XcFn9uYvdv3c8e
         ncdnSD2HDw0bSD5S1TATWSspTOqfPWjvqSybHjm0F0uYzmelcSbsFa6eP7+VohRHM5ro
         Ar/g==
X-Gm-Message-State: AJIora/vp0gM2nTfBdLkx4KMVmyWugYKPytw0qmExSa7Y9wWUYwoWvzV
        3nQ4f7aqKo3q4Xp8BCRs2ZDRyYZmPB/QZNaDD+0lEj+smDhy/A84gsf3QgU50Aff5b/nVrcZhJm
        DOjqX/2Rrfiylv2tU
X-Received: by 2002:aa7:c98f:0:b0:43a:71c2:3f7e with SMTP id c15-20020aa7c98f000000b0043a71c23f7emr18937154edt.60.1657889735774;
        Fri, 15 Jul 2022 05:55:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uRrjFF/vkMl1zjVttTeThbXaMNP0lM2AWToZsG6mZfuHVp4vj/P3g406cXFK7OKBCtmMigCQ==
X-Received: by 2002:aa7:c98f:0:b0:43a:71c2:3f7e with SMTP id c15-20020aa7c98f000000b0043a71c23f7emr18937100edt.60.1657889735355;
        Fri, 15 Jul 2022 05:55:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906201200b006f3ef214e13sm1963676ejo.121.2022.07.15.05.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 05:55:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E3D1B4D9CBF; Fri, 15 Jul 2022 14:55:33 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
In-Reply-To: <20220715011228.tujkugafv6eixbyz@MacBook-Pro-3.local>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com>
 <877d4gpto8.fsf@toke.dk>
 <CAKH8qBvODehxeGrqyY6+9TJPePe_KLb6vX9P1rKDgbQhuLpSSQ@mail.gmail.com>
 <87v8s0nf8h.fsf@toke.dk>
 <20220715011228.tujkugafv6eixbyz@MacBook-Pro-3.local>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Jul 2022 14:55:33 +0200
Message-ID: <87k08eo7qy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Jul 14, 2022 at 12:46:54PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> >
>> > Maybe a related question here: with the way you do
>> > BPF_MAP_TYPE_PIFO_GENERIC vs BPF_MAP_TYPE_PIFO_XDP, how hard it would
>> > be have support for storing xdp_frames/skb in any map? Let's say we
>> > have generic BPF_MAP_TYPE_RBTREE, where the key is
>> > priority/timestamp/whatever, can we, based on the value's btf_id,
>> > figure out the rest? (that the value is kernel structure and needs
>> > special care and more constraints - can't be looked up from user space
>> > and so on)
>> >
>> > Seems like we really need to have two special cases: where we transfer
>> > ownership of xdp_frame/skb to/from the map, any other big
>> > complications?
>> >
>> > That way we can maybe untangle the series a bit: we can talk about
>> > efficient data structures for storing frames/skbs independently of
>> > some generic support for storing them in the maps. Any major
>> > complications with that approach?
>>=20
>> I've had discussions with Kartikeya on this already (based on his 'kptr
>> in map' work). That may well end up being feasible, which would be
>> fantastic. The reason we didn't use it for this series is that there's
>> still some work to do on the generic verifier/infrastructure support
>> side of this (the PIFO map is the oldest part of this series), and I
>> didn't want to hold up the rest of the queueing work until that landed.
>
> Certainly makes sense for RFC to be sent out earlier,
> but Stan's point stands. We have to avoid type-specific maps when
> generic will do. kptr infra is getting close to be that answer.

ACK, I'll iterate on the map types and see how far we can get with the
kptr approach.

Do people feel a generic priority queue type would be generally useful?
Because in that case I can split out this work into a separate series...

>> >> Maybe I'm missing something, though; could you elaborate on how you'd
>> >> use kfuncs instead?
>> >
>> > I was thinking about the approach in general. In networking bpf, we've
>> > been adding new program types, new contexts and new explicit hooks.
>> > This all requires a ton of boiler plate (converting from uapi ctx to
>> > the kernel, exposing hook points, etc, etc). And looking at Benjamin's
>> > HID series, it's so much more elegant: there is no uapi, just kernel
>> > function that allows it to be overridden and a bunch of kfuncs
>> > exposed. No uapi, no helpers, no fake contexts.
>> >
>> > For networking and xdp the ship might have sailed, but I was wondering
>> > whether we should be still stuck in that 'old' boilerplate world or we
>> > have a chance to use new nice shiny things :-)
>> >
>> > (but it might be all moot if we'd like to have stable upis?)
>>=20
>> Right, I see what you mean. My immediate feeling is that having an
>> explicit stable UAPI for XDP has served us well. We do all kinds of
>> rewrite tricks behind the scenes (things like switching between xdp_buff
>> and xdp_frame, bulking, direct packet access, reading ifindexes by
>> pointer walking txq->dev, etc) which are important ways to improve
>> performance without exposing too many nitty-gritty details into the API.
>>=20
>> There's also consistency to consider: I think the addition of queueing
>> should work as a natural extension of the existing programming model for
>> XDP. So I feel like this is more a case of "if we were starting from
>> scratch today we might do things differently (like the HID series), but
>> when extending things let's keep it consistent"?
>
> "consistent" makes sense when new feature follows established path.
> The programmable packet scheduling in TX is just as revolutionary as
> XDP in RX was years ago :)
> This feature can be done similar to hid-bpf without cast-in-stone uapi
> and hooks. Such patches would be much easier to land and iterate on top.
> The amount of bike shedding will be 10 times less.
> No need for new program type, no new hooks, no new FDs and attach uapi-s.
> Even libbpf won't need any changes.
> Add few kfuncs and __weak noinline "hooks" in TX path.
> Only new map type would be necessary.
> If it can be made with kptr then it will be the only uapi exposure that
> will be heavily scrutinized.

I'm not quite convinced it's that obvious that it can be implemented
this way; but I don't mind trying it out either, if nothing else it'll
give us something to compare against...

> It doesn't mean that it will stay unstable-api forever. Once it demonstra=
tes
> that it is on par with fq/fq_codel/cake feature-wise we can bake it into =
uapi.

In any case, I don't think we should merge anything until we've shown
this :)

-Toke

