Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB634D9F26
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349763AbiCOPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349762AbiCOPvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:51:40 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603DF45527
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:50:25 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2e5757b57caso51225057b3.4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R0XgSv5CQhz6oeuEYFIhvRN2vKO0zOsCTthsJxp13lE=;
        b=S35cmdwXEz2TUg5qxpiM/TmO1f/aMmIp4RRBcj0AK7DEZJqOCRhhi5bTz0vke4ep2r
         uLqRrzEB+z14yLq7y8zYDC40/Ugd2cLTLRr4Io3JjbgYCY91LtCo5w2CP7YUA6X3TQ3V
         fqHCLN2mxJJQW85PaFS68+kLywXMjXYmmaK1CnrTI8rx53weN9Y+Ho/GuVuaRgJ3jjDU
         7caidiXNnL7tO1lH0huQnuDunWn63jFkN9I7s+5V+xCs+F6mVwZW2LCVSk92iN0pKUgm
         vBx6yaDCyPxV76qJUbuNBn81DtxDCfDfrREdjq0FodeM7YnkQmoQBjrK2MM6OCuApSjn
         xC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R0XgSv5CQhz6oeuEYFIhvRN2vKO0zOsCTthsJxp13lE=;
        b=RnaJlJntRrBPDsxVZSRaTxAmEiHcC4VfvLpyPWnh8S1af1YPCYEZ+mHdXgQU7/vFi1
         HDWxLY4QOfuHCj0QZUaQokm0BQtYS9pHbdNgbTVi8D881nHyL2cvq2H7ve6fjAF60V23
         0U02xRaFkURYsy14anjzGAVxZFJHgDqz1cAdU6C9LgKmAT+zH70uX6xlFv6MRZJeNz8N
         P+CGpyH2wF938/UA6gcibpivoKb99aTvZMMYO1UmqvCizvF8l7BbZ+Y+KZvkSJq0xUJs
         +lz1ImPlK76/md4gpdzGLy8Y45+SRRLAhuvaz/tUoiIIy4vZdXhScVuLmaa1QNOiL0He
         egOA==
X-Gm-Message-State: AOAM531dd8ehggTdzETn++4C2rWsBjwSkflIgpKYYxj7zj5UVIn0Wjqx
        Nlt5IRA85vnAnngCE3jfQF32oZ9jT21GsxHgaUozfQ==
X-Google-Smtp-Source: ABdhPJzc+GS9N/wAaMbbfJgIuR70OTWHWv7fTGUBRYBUgksNURv/kyt9/JH0/CXQaie+i3wOWSXhon5xub3dIG36j5k=
X-Received: by 2002:a81:af57:0:b0:2dc:40d0:1380 with SMTP id
 x23-20020a81af57000000b002dc40d01380mr24500842ywj.255.1647359424148; Tue, 15
 Mar 2022 08:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220310054703.849899-1-eric.dumazet@gmail.com> <2151fe9e8bdf18ae02bd196f69f1b64af0eb4a55.camel@gmail.com>
In-Reply-To: <2151fe9e8bdf18ae02bd196f69f1b64af0eb4a55.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Mar 2022 08:50:12 -0700
Message-ID: <CANn89i+9eAOwMdUiKa6r9vJJFDkGP97FO1HVZPMKyCpq3CJHtw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/14] tcp: BIG TCP implementation
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 9:13 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > This series implements BIG TCP as presented in netdev 0x15:
> >
> > https://netdevconf.info/0x15/session.html?BIG-TCP
> >
> > Jonathan Corbet made a nice summary: https://lwn.net/Articles/884104/
> >
> > Standard TSO/GRO packet limit is 64KB
> >
> > With BIG TCP, we allow bigger TSO/GRO packet sizes for IPv6 traffic.
> >
> > Note that this feature is by default not enabled, because it might
> > break some eBPF programs assuming TCP header immediately follows IPv6 header.
> >
> > While tcpdump recognizes the HBH/Jumbo header, standard pcap filters
> > are unable to skip over IPv6 extension headers.
> >
> > Reducing number of packets traversing networking stack usually improves
> > performance, as shown on this experiment using a 100Gbit NIC, and 4K MTU.
> >
> > 'Standard' performance with current (74KB) limits.
> > for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > 77           138          183          8542.19
> > 79           143          178          8215.28
> > 70           117          164          9543.39
> > 80           144          176          8183.71
> > 78           126          155          9108.47
> > 80           146          184          8115.19
> > 71           113          165          9510.96
> > 74           113          164          9518.74
> > 79           137          178          8575.04
> > 73           111          171          9561.73
> >
> > Now enable BIG TCP on both hosts.
> >
> > ip link set dev eth0 gro_ipv6_max_size 185000 gso_ipv6_max_size 185000
> > for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> > 57           83           117          13871.38
> > 64           118          155          11432.94
> > 65           116          148          11507.62
> > 60           105          136          12645.15
> > 60           103          135          12760.34
> > 60           102          134          12832.64
> > 62           109          132          10877.68
> > 58           82           115          14052.93
> > 57           83           124          14212.58
> > 57           82           119          14196.01
> >
> > We see an increase of transactions per second, and lower latencies as well.
> >
> > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y in mlx5 (Jakub)
> >
> > v3: Fixed a typo in RFC number (Alexander)
> >     Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.
> >
> > v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
> >     Addressed feedback, for Alexander and nvidia folks.
>
> One concern with this patch set is the addition of all the max_size
> netdev attributes for tsov6, gsov6, and grov6. For the gsov6 and grov6
> maxes I really think these make more sense as sysctl values since it
> feels more like a protocol change rather than a netdev specific one.
>
> If I recall correctly the addition of gso_max_size and gso_max_segs
> were added as a workaround for NICs that couldn't handle offloading
> frames larger than a certain size. This feels like increasing the scope
> of the workaround rather than adding a new feature.
>
> I didn't see the patch that went by for gro_max_size but I am not a fan
> of the way it was added since it would make more sense as a sysctl
> which controlled the stack instead of something that is device specific
> since as far as the device is concerned it received MTU size frames,
> and GRO happens above the device. I suppose it makes things symmetric
> with gso_max_size, but at the same time it isn't really a device
> specific attribute since the work happens in the stack above the
> device.
>

We already have per device gso_max_size and gso_max_segs.

GRO max size being per device is nice. There are cases where a host
has multiple NIC,
one of them being used for incoming traffic that needs to be forwarded.

Maybe the changelog was not clear enough, but being able to lower gro_max_size
is also a way to prevent frag_list being used, so that most NIC
support TSO just fine.


> Do we need to add the IPv6 specific version of the tso_ipv6_max_size?
> Could we instead just allow setting the gso_max_size value larger than
> 64K? Then it would just be a matter of having a protocol specific max
> size check to pull us back down to GSO_MAX_SIZE in the case of non-ipv6
> frames.

Not sure why adding attributes is an issue really, more flexibility
seems better to me.

One day, if someone adds LSOv2 to IPv4, I prefer being able to
selectively turn on this support,
after tests have concluded nothing broke.

Having to turn off LSOv2 in emergency because of some bug in LSOv2
IPv4 implementation would be bad.
