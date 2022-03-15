Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C430E4D9FC1
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349960AbiCOQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiCOQSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:18:44 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F244BBAD
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:17:31 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bi12so42629155ejb.3
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=08chLQujssce8k5pKnmpjzTLkG6bBV6TbxAkMe18QTw=;
        b=D4TjzTJu/O1snah+Mm4IsJGbH4yiPgGIaXttO83TSiHlLSN/nEQguahPea/mG0wLj+
         SM+Aul9jo8S7RTzOFHSqrd8FzEv2/S8bswcMtcKuHqisUAHl14KW5S2uGlfBQSqJAjkM
         kJ6j1pIAozPJfCqKIsU/5F2qzmuyfEuoyMy32pKA3F96S6U9ei15JPQWIBckg3CWE4Rd
         lXSBbHa6YngRd5KrKL3C1/OSFw5LJ4ncnfQdvMcIpVKyjw2JWEqDtcbYrbO8p6zZGGpl
         8pggDrTPM2L3WvIH8fFkKR0XKwejSlF3dZpg0iPdc019Lb2hYJzeFSCheT89HPn9KMiK
         gAUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08chLQujssce8k5pKnmpjzTLkG6bBV6TbxAkMe18QTw=;
        b=eiRZoWsmgA2tt583jbGvH8yh8o8iJekP2eHrieY4CEFLFTjmrkJV3t8Q0P4jUUKgBc
         ePFrejvluNadZkA4b8U2C4OW6Ooz2yVDxqAv72bo1WKpF3f6G+L6cX0HnnL+6JR8Eoij
         4hBMYfrLn1bXE2WVMDCGvAoQi/hV6aox9c8lGLhwJzqW/sPIUGPpMcmIGzAZEtVFiNrE
         Z1y3ZfVhQte3F7xWil24Vl0LLim+1j2oFGLRsAyKQALCr+3zYYIBqtSqa187FEEB/3Y0
         YViYiq3icqedrdE/uaAEyk84x4DGlPXMT3aY9Giul/qrQQWvdgKGU8mJxKoEevJppiDi
         feoQ==
X-Gm-Message-State: AOAM5308R2dSCIFUinF8y/tBrRELvfiONh5TEV2IS4GK4WxEUAVoQUzB
        o5372T90iA/YPlw5F8ARBHWDQTLeBYstz4tRpwQ=
X-Google-Smtp-Source: ABdhPJxRNw5OUxOfNT7IJog0Blntko/90cmLw1sfCgVo27TDo/GUfH7pW511izlQ3Ju2fIss1n2w0aQQUb3Ie+amq50=
X-Received: by 2002:a17:906:2584:b0:6d6:e5c9:221b with SMTP id
 m4-20020a170906258400b006d6e5c9221bmr23577103ejb.514.1647361049793; Tue, 15
 Mar 2022 09:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
 <2151fe9e8bdf18ae02bd196f69f1b64af0eb4a55.camel@gmail.com> <CANn89i+9eAOwMdUiKa6r9vJJFDkGP97FO1HVZPMKyCpq3CJHtw@mail.gmail.com>
In-Reply-To: <CANn89i+9eAOwMdUiKa6r9vJJFDkGP97FO1HVZPMKyCpq3CJHtw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 15 Mar 2022 09:17:18 -0700
Message-ID: <CAKgT0UeT4j7C4rsv1-H6fzKqp6KSN8ORDjbwpXtPofAy=0SjXA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/14] tcp: BIG TCP implementation
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 8:50 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Mar 11, 2022 at 9:13 AM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > This series implements BIG TCP as presented in netdev 0x15:
> > >
> > > https://netdevconf.info/0x15/session.html?BIG-TCP
> > >
> > > Jonathan Corbet made a nice summary: https://lwn.net/Articles/884104/
> > >
> > > Standard TSO/GRO packet limit is 64KB
> > >
> > > With BIG TCP, we allow bigger TSO/GRO packet sizes for IPv6 traffic.
> > >
> > > Note that this feature is by default not enabled, because it might
> > > break some eBPF programs assuming TCP header immediately follows IPv6 header.
> > >
> > > While tcpdump recognizes the HBH/Jumbo header, standard pcap filters
> > > are unable to skip over IPv6 extension headers.
> > >
> > > Reducing number of packets traversing networking stack usually improves
> > > performance, as shown on this experiment using a 100Gbit NIC, and 4K MTU.
> > >
> > > 'Standard' performance with current (74KB) limits.
> > > for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > > 77           138          183          8542.19
> > > 79           143          178          8215.28
> > > 70           117          164          9543.39
> > > 80           144          176          8183.71
> > > 78           126          155          9108.47
> > > 80           146          184          8115.19
> > > 71           113          165          9510.96
> > > 74           113          164          9518.74
> > > 79           137          178          8575.04
> > > 73           111          171          9561.73
> > >
> > > Now enable BIG TCP on both hosts.
> > >
> > > ip link set dev eth0 gro_ipv6_max_size 185000 gso_ipv6_max_size 185000
> > > for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > > 57           83           117          13871.38
> > > 64           118          155          11432.94
> > > 65           116          148          11507.62
> > > 60           105          136          12645.15
> > > 60           103          135          12760.34
> > > 60           102          134          12832.64
> > > 62           109          132          10877.68
> > > 58           82           115          14052.93
> > > 57           83           124          14212.58
> > > 57           82           119          14196.01
> > >
> > > We see an increase of transactions per second, and lower latencies as well.
> > >
> > > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y in mlx5 (Jakub)
> > >
> > > v3: Fixed a typo in RFC number (Alexander)
> > >     Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.
> > >
> > > v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
> > >     Addressed feedback, for Alexander and nvidia folks.
> >
> > One concern with this patch set is the addition of all the max_size
> > netdev attributes for tsov6, gsov6, and grov6. For the gsov6 and grov6
> > maxes I really think these make more sense as sysctl values since it
> > feels more like a protocol change rather than a netdev specific one.
> >
> > If I recall correctly the addition of gso_max_size and gso_max_segs
> > were added as a workaround for NICs that couldn't handle offloading
> > frames larger than a certain size. This feels like increasing the scope
> > of the workaround rather than adding a new feature.
> >
> > I didn't see the patch that went by for gro_max_size but I am not a fan
> > of the way it was added since it would make more sense as a sysctl
> > which controlled the stack instead of something that is device specific
> > since as far as the device is concerned it received MTU size frames,
> > and GRO happens above the device. I suppose it makes things symmetric
> > with gso_max_size, but at the same time it isn't really a device
> > specific attribute since the work happens in the stack above the
> > device.
> >
>
> We already have per device gso_max_size and gso_max_segs.
>
> GRO max size being per device is nice. There are cases where a host
> has multiple NIC,
> one of them being used for incoming traffic that needs to be forwarded.
>
> Maybe the changelog was not clear enough, but being able to lower gro_max_size
> is also a way to prevent frag_list being used, so that most NIC
> support TSO just fine.

The point is gso_max_size and gso_max_segs were workarounds for
devices. Basically they weren't added until it was found that specific
NICs were having issues with segmenting frames either larger than a
specific size or number of segments.

I suppose we can keep gro_max_size in place if we are wanting to say
that it ties back into the device. There may be some benefit there if
we end up with some devices allocating skbs that can aggregate more
segments than others, however in that case that seems more like a
segment limit than a size limit. Maybe something like gro_max_segs
would make more sense, or I suppose we end up with both eventually.

> > Do we need to add the IPv6 specific version of the tso_ipv6_max_size?
> > Could we instead just allow setting the gso_max_size value larger than
> > 64K? Then it would just be a matter of having a protocol specific max
> > size check to pull us back down to GSO_MAX_SIZE in the case of non-ipv6
> > frames.
>
> Not sure why adding attributes is an issue really, more flexibility
> seems better to me.
>
> One day, if someone adds LSOv2 to IPv4, I prefer being able to
> selectively turn on this support,
> after tests have concluded nothing broke.
>
> Having to turn off LSOv2 in emergency because of some bug in LSOv2
> IPv4 implementation would be bad.

You already have a means of turning off LSOv2 in the form of
gso_max_size. Remember it was put there as a workaround for broken
devices that couldn't fully support LSOv1. In my mind we would reuse
the gso_max_size, and I suppose gro_max_size to control the GSO types
supported by the device. If it is set for 64K or less then it only
supports LSOv1, if it is set higher, then it can support GSOv2. I'm
not sure it makes sense to split gso_max_size into two versions. If a
device supports GSO larger than 64K then what is the point in having
gso_max_size around when it will always be set to 64K because the
device isn't broken. Otherwise we are going to end up creating a bunch
of duplications.

What I am getting at is that it would be nice to have a stack level
control and then a device level control. The device control is there
to say what size drivers support when segmenting, whereas the stack
level control says if the protocol wants to try sending down frames
larger than 64K. So essentially all non-IPv6 protocols will cap at
64K, whereas IPv6 can go beyond that with huge frames. Then you get
the best of both worlds.
