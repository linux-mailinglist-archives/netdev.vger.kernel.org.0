Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569D564C73C
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 11:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbiLNKfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 05:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237963AbiLNKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 05:35:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DB820BF2
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671014069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Fg00XXF2yM6wh3TO2WZ8TwfHdQYz2juPaqJ6letSgY=;
        b=GYwC9OrlMiBcKWGYiW/nRGyqfZhBSyc+g87krEGrtFTDfIbK54v067VP1n1GLJgENvczM0
        wCnY2NgX/CGHpS0DX+gCtbs/eqJl1fBbnG2EHVmaMOO/G8n65CF0MdNG8e5nj3rU4MWTDN
        jy9xRyQqPk2SPb6L30YJoJQjT64pZ8w=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-93MoOaVBObSNORUAlNvPYw-1; Wed, 14 Dec 2022 05:34:28 -0500
X-MC-Unique: 93MoOaVBObSNORUAlNvPYw-1
Received: by mail-ej1-f69.google.com with SMTP id sg39-20020a170907a42700b007c19b10a747so1872255ejc.11
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 02:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Fg00XXF2yM6wh3TO2WZ8TwfHdQYz2juPaqJ6letSgY=;
        b=B6ZzQpbZtwbz54KquUDNz2mos5xl0qAGAuCEF1WHzdDd7MngkKkNF7gHtxPD2Gqu9T
         y8gVCf1TEXF7U1aZYSynIyV/0fyPkDaB76jQ2YxUBW9hbTW9SD/EKBThYQPc2KPK7zOd
         WoazOrF+5Hnd0kdyxoV8ybk986epc3Gw3iANrqf16J8c2ifaAP47zqB+NI/KnlYfc6ke
         34lEOONQxCWpdrG5NMKQMsyCZBtWgzn5gcz0BE9HmTg90chZebZxcfb/+IB0vL4kYijP
         ofn+NKTpkWoGwgQhzd2QFhMz4mdb/afL6UxROwIceYSDBiWTaosZyLOtJLkUoKkBppfS
         gnmg==
X-Gm-Message-State: ANoB5plzAfHiu+Vr5/WLXw1TNZs5LHmQBHO2gvCULlWBNAhheCwLjwjI
        a/GUGLJ9L6sn/CmFQ/qH6amedVH/2Vu1HdlHNZ+2XuY33VxkBxlWQoJpolYPH4xY3U9SBV2LxYN
        JPErN5ZSrMBra3OuC
X-Received: by 2002:a17:907:8a22:b0:7af:16b5:9af8 with SMTP id sc34-20020a1709078a2200b007af16b59af8mr27839835ejc.33.1671014066323;
        Wed, 14 Dec 2022 02:34:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5CVYouzmF4fVkxVmkciAuxXMAnbXeAYX6tQ5aBH2lvugDNhvxTXrHafnkjusNLMP7PybGnyQ==
X-Received: by 2002:a17:907:8a22:b0:7af:16b5:9af8 with SMTP id sc34-20020a1709078a2200b007af16b59af8mr27839782ejc.33.1671014065395;
        Wed, 14 Dec 2022 02:34:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090609ca00b00780b1979adesm5622969eje.218.2022.12.14.02.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 02:34:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D96782F53A; Wed, 14 Dec 2022 11:34:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>,
        David Vernet <void@manifault.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v4 01/15] bpf: Document XDP RX
 metadata
In-Reply-To: <CAKH8qBvjwMXvTg3ij=6wk2yu+=oWcRizmKf_YtW_yp5+W2F_=g@mail.gmail.com>
References: <20221213023605.737383-1-sdf@google.com>
 <20221213023605.737383-2-sdf@google.com> <Y5iqTKnhtX2yaSAq@maniforge.lan>
 <CAKH8qBvjwMXvTg3ij=6wk2yu+=oWcRizmKf_YtW_yp5+W2F_=g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 14 Dec 2022 11:34:23 +0100
Message-ID: <87fsdigtow.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
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

> On Tue, Dec 13, 2022 at 8:37 AM David Vernet <void@manifault.com> wrote:
>>
>> On Mon, Dec 12, 2022 at 06:35:51PM -0800, Stanislav Fomichev wrote:
>> > Document all current use-cases and assumptions.
>> >
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
>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> > ---
>> >  Documentation/bpf/xdp-rx-metadata.rst | 90 +++++++++++++++++++++++++++
>> >  1 file changed, 90 insertions(+)
>> >  create mode 100644 Documentation/bpf/xdp-rx-metadata.rst
>> >
>> > diff --git a/Documentation/bpf/xdp-rx-metadata.rst b/Documentation/bpf/xdp-rx-metadata.rst
>> > new file mode 100644
>> > index 000000000000..498eae718275
>> > --- /dev/null
>> > +++ b/Documentation/bpf/xdp-rx-metadata.rst
>>
>> I think you need to add this to Documentation/bpf/index.rst. Or even
>> better, maybe it's time to add an xdp/ subdirectory and put all docs
>> there? Don't want to block your patchset from bikeshedding on this
>> point, so for now it's fine to just put it in
>> Documentation/bpf/index.rst until we figure that out.
>
> Maybe let's put it under Documentation/networking/xdp-rx-metadata.rst
> and reference form Documentation/networking/index.rst? Since it's more
> relevant to networking than the core bpf?
>
>> > @@ -0,0 +1,90 @@
>> > +===============
>> > +XDP RX Metadata
>> > +===============
>> > +
>> > +XDP programs support creating and passing custom metadata via
>> > +``bpf_xdp_adjust_meta``. This metadata can be consumed by the following
>> > +entities:
>>
>> Can you add a couple of sentences to this intro section that explains
>> what metadata is at a high level?
>
> I'm gonna copy-paste here what I'm adding, feel free to reply back if
> still unclear. (so we don't have to wait another week to discuss the
> changes)
>
> XDP programs support creating and passing custom metadata via
> ``bpf_xdp_adjust_meta``. The metadata can contain some extra information
> about the packet: timestamps, hash, vlan and tunneling information, etc.
> This metadata can be consumed by the following entities:

This is not really accurate, though? The metadata area itself can
contain whatever the XDP program wants it to, and I think you're
conflating the "old" usage for arbitrary storage with the driver-kfunc
metadata support.

I think we should clear separate the two: the metadata area is just a
place to store data (and is not consumed by the stack, except that
TC-BPF programs can access it), and the driver kfuncs are just a general
way to get data out of the drivers (and has nothing to do with the
metadata area, you can just get the data into stack variables).

While it would be good to have a documentation of the general metadata
area stuff somewhere, I don't think it necessarily have to be part of
this series, so maybe just stick to documenting the kfuncs?

-Toke

