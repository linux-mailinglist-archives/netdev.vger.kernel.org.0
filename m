Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31D545EDEF
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377475AbhKZMfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:35:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377443AbhKZMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:33:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637929823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wJpjstKjFgGO5wW+gqXS3RJS7pxbzNnoYG45SxgIaVs=;
        b=DqtQb3REG6A8Wqip2hMPUaSUcAfVeM6IEdjUHM4WIYzL1YNWvSL8q28BdizRGtlHjo6+RT
        Af1gCnqZlcclntPKpr03yHw+3n4XhetD0AbRMcpcZr9mEWU85wWRIROzZi3JrpRXq9ZFbF
        6R2XTR36BdCajUBUMrw5hraEVZ0aa8o=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-598-IM2Ck28XPHa6CXRC42WyVA-1; Fri, 26 Nov 2021 07:30:21 -0500
X-MC-Unique: IM2Ck28XPHa6CXRC42WyVA-1
Received: by mail-ed1-f69.google.com with SMTP id m17-20020aa7d351000000b003e7c0bc8523so7938887edr.1
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:30:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wJpjstKjFgGO5wW+gqXS3RJS7pxbzNnoYG45SxgIaVs=;
        b=Xx+0+8F0mRQScDFNQbD7Sq5yJf3Ya2yTtPid7zdj3WDNI5qEpohrZqXUN0bHIvn1TK
         /c9tiVmos/E0eJRhTDqKDmY+WpOKr47BvisotbF9YTvcJ9Tk/LNBlegkO5+yWwGDv2Ra
         J9E2lwzwLZX+zA6yoCHn9OHJw1qsJXl6E4rBEz5P+i0RoSduypijtkwpSEBBGW9mDzCR
         zB08MTUnKOQKDjLbtAxceWzWg24on1eqkZCVdyxxWTC9wbkWSAtAe9UqBFXXOWMFPyvn
         a343kLdWxtfhwLbaHVwzU9P7AdPjASUO3f5iZhnE1oYS5DNZoEX3Xfoo/jNL2DFcFuPA
         qDVA==
X-Gm-Message-State: AOAM533qG1u1foBY3RG3ZicakfCQh/v+GdNyuPyGoncLajh/rQZaFboG
        Stq481eWih4Yz3jcQ7x2y6Lnv2/kuCrHPUpmTP2DjaTx1mK19QDP6F4JtWU+pK5FKbYqAEcKTvM
        2GQTFUjRpcFgMCB7b
X-Received: by 2002:a17:906:9253:: with SMTP id c19mr38089893ejx.63.1637929818649;
        Fri, 26 Nov 2021 04:30:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFpOGQFmWiCNvf6rQhtfEjSpRvn9st0kQKBRiIz3dQouSyrrzQoU3PWI7Fk46YpVzPcL/lig==
X-Received: by 2002:a17:906:9253:: with SMTP id c19mr38089763ejx.63.1637929817373;
        Fri, 26 Nov 2021 04:30:17 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l18sm2825795ejo.114.2021.11.26.04.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:30:16 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0A5011802A0; Fri, 26 Nov 2021 13:30:16 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
In-Reply-To: <20211125204007.133064-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
 <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Nov 2021 13:30:16 +0100
Message-ID: <87sfvj9k13.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 25 Nov 2021 09:44:40 -0800
>
>> On Thu, 25 Nov 2021 18:07:08 +0100 Alexander Lobakin wrote:
>> > > This I agree with, and while I can see the layering argument for putting
>> > > them into 'ip' and rtnetlink instead of ethtool, I also worry that these
>> > > counters will simply be lost in obscurity, so I do wonder if it wouldn't
>> > > be better to accept the "layering violation" and keeping them all in the
>> > > 'ethtool -S' output?  
>> > 
>> > I don't think we should harm the code and the logics in favor of
>> > 'some of the users can face something'. We don't control anything
>> > related to XDP using Ethtool at all, but there is some XDP-related
>> > stuff inside iproute2 code, so for me it's even more intuitive to
>> > have them there.
>> > Jakub, may be you'd like to add something at this point?
>> 
>> TBH I wasn't following this thread too closely since I saw Daniel
>> nacked it already. I do prefer rtnl xstats, I'd just report them 
>> in -s if they are non-zero. But doesn't sound like we have an agreement
>> whether they should exist or not.
>
> Right, just -s is fine, if we drop the per-channel approach.

I agree that adding them to -s is fine (and that resolves my "no one
will find them" complain as well). If it crowds the output we could also
default to only output'ing a subset, and have the more detailed
statistics hidden behind a verbose switch (or even just in the JSON
output)?

>> Can we think of an approach which would make cloudflare and cilium
>> happy? Feels like we're trying to make the slightly hypothetical 
>> admin happy while ignoring objections of very real users.
>
> The initial idea was to only uniform the drivers. But in general
> you are right, 10 drivers having something doesn't mean it's
> something good.

I don't think it's accurate to call the admin use case "hypothetical".
We're expending a significant effort explaining to people that XDP can
"eat" your packets, and not having any standard statistics makes this
way harder. We should absolutely cater to our "early adopters", but if
we want XDP to see wider adoption, making it "less weird" is critical!

> Maciej, I think you were talking about Cilium asking for those stats
> in Intel drivers? Could you maybe provide their exact usecases/needs
> so I'll orient myself? I certainly remember about XSK Tx packets and
> bytes.
> And speaking of XSK Tx, we have per-socket stats, isn't that enough?

IMO, as long as the packets are accounted for in the regular XDP stats,
having a whole separate set of stats only for XSK is less important.

>> Please leave the per-channel stats out. They make a precedent for
>> channel stats which should be an attribute of a channel. Working for 
>> a large XDP user for a couple of years now I can tell you from my own
>> experience I've not once found them useful. In fact per-queue stats are
>> a major PITA as they crowd the output.
>
> Oh okay. My very first iterations were without this, but then I
> found most of the drivers expose their XDP stats per-channel. Since
> I didn't plan to degrade the functionality, they went that way.

I personally find the per-channel stats quite useful. One of the primary
reasons for not achieving full performance with XDP is broken
configuration of packet steering to CPUs, and having per-channel stats
is a nice way of seeing this. I can see the point about them being way
too verbose in the default output, though, and I do generally filter the
output as well when viewing them. But see my point above about only
printing a subset of the stats by default; per-channel stats could be
JSON-only, for instance?

-Toke

