Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA29663B4A5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiK1WLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiK1WLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:11:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9D11DDF9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669673416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vJAfrSiLBZ1GH3+ALah4IS7MdEjQe3AC2nBRfXse76c=;
        b=UOocgKxkHi0mVvh7IAezz8AyZCASB7xRJyW+isE4wKdwgQdVI+o8eF7WyaTW4Qv1XlKOL1
        AuF6ieHcpgtNaOCwk7d7EHVJx1tOto1YR47R1UCHl0IvwvhEP41KSnNgA+OZSzkUeVV4Mo
        J7bFo8b+G8EAzsXcXNOs5VH3fEvXj0g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-Dx9KVo1fMumtSnqMTtq7pQ-1; Mon, 28 Nov 2022 17:10:13 -0500
X-MC-Unique: Dx9KVo1fMumtSnqMTtq7pQ-1
Received: by mail-ej1-f70.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso5112391ejb.14
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 14:10:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vJAfrSiLBZ1GH3+ALah4IS7MdEjQe3AC2nBRfXse76c=;
        b=ijI8nIQP0hibUk5f0J/O5HvGA6kvZm86letH6XhuGCkQHgbJLsCI7iutngnBCZRi+p
         e+11HhsGPREHuqBS5z+LbpHw+2NJJy/BdHfCO3ApoOJTgVLS2g/B0HZUrmGM3oI7Utbl
         ePKbbdmnaw61DjGnYMZ0ZjcBZ30/uWvUpEilwb0OdkAgS3JNirFYRLxCcUHVXmwjSFdL
         Nr8gr3FGMt6XUxfuSxxVEw9t5ygsaIQpTTpzpE5M7Lp5AAgag3+B/j9b3XdFlyxNheJA
         zkfSBl6J0evBxpEc4fWETYrFNDqt8ovu+8DOKNjdk226XP2Ym2aZg/zH1LzYHQjEhbdr
         hJkQ==
X-Gm-Message-State: ANoB5pn/0EVH1J7RxWtz7J/MY8qpnkKoXo0CNgRuVkrg1zHIl1XXBmz1
        xf943s+0Yj95RY2wtt7PpQPCopi2ga1jFPnEENE2AvO+NwsW0gVwPW7MIfRmPb/KIfagacb7yWs
        YKTBLTLU6IoiJVCZn
X-Received: by 2002:a17:906:df47:b0:7c0:747a:1e0d with SMTP id if7-20020a170906df4700b007c0747a1e0dmr4682881ejc.224.1669673411822;
        Mon, 28 Nov 2022 14:10:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf425gA6m8pgpUvpIT8KHNPMAzGFBEXZEVPOH9JlVG4aiPoCzI4HDFBWqcj759365DVU9Cme3w==
X-Received: by 2002:a17:906:df47:b0:7c0:747a:1e0d with SMTP id if7-20020a170906df4700b007c0747a1e0dmr4682862ejc.224.1669673411347;
        Mon, 28 Nov 2022 14:10:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906300b00b007aee947ce9esm5417641ejz.138.2022.11.28.14.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 14:10:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3B5057EBE9C; Mon, 28 Nov 2022 23:10:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
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
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v2 2/8] bpf: XDP metadata RX
 kfuncs
In-Reply-To: <CAKH8qBvmgx0Lr7efP0ucdZMEzZM-jzDKcAW9YPBqADWVsHb9cA@mail.gmail.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-3-sdf@google.com> <87mt8e2a69.fsf@toke.dk>
 <CAKH8qBvmgx0Lr7efP0ucdZMEzZM-jzDKcAW9YPBqADWVsHb9cA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 28 Nov 2022 23:10:10 +0100
Message-ID: <874jui20jh.fsf@toke.dk>
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

>  s
>
> On Fri, Nov 25, 2022 at 9:53 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>> > There is an ndo handler per kfunc, the verifier replaces a call to the
>> > generic kfunc with a call to the per-device one.
>> >
>> > For XDP, we define a new kfunc set (xdp_metadata_kfunc_ids) which
>> > implements all possible metatada kfuncs. Not all devices have to
>> > implement them. If kfunc is not supported by the target device,
>> > the default implementation is called instead.
>>
>> BTW, this "the default implementation is called instead" bit is not
>> included in this version... :)
>
> fixup_xdp_kfunc_call should return 0 when the device doesn't have a
> kfunc defined and should fallback to the default kfunc implementation,
> right?
> Or am I missing something?

Ohh, right. Maybe add a comment stating this (as I obviously missed it :))

-Toke

