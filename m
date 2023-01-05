Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65D965F05D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbjAEPok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234806AbjAEPo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:44:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A3D5D439
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 07:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672933422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5NKNG56/XyX8OVsf4PxGDxDUNqP39WI3kdbx8STm4Y=;
        b=ZpoeKLVbTet8QHcnWOQasDTeuVA9Naorwa21RIHOQgeRqTC/DY+W8R0Iwnd3eMS2tMTiNI
        H+kt2TPqZ6nIwerdPt9J7jTdDMYnta3FV2A94YHyHQ1w8VKorNUApQkRLaOKk/NElOBYD9
        FNvgSQUExZoo5+BbWdvxi4oFHqH01lM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-593-XrIL1X9ZMs-1bvDnfJu1bQ-1; Thu, 05 Jan 2023 10:43:34 -0500
X-MC-Unique: XrIL1X9ZMs-1bvDnfJu1bQ-1
Received: by mail-ej1-f70.google.com with SMTP id oz11-20020a1709077d8b00b007c0dd8018b6so23486862ejc.17
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 07:43:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5NKNG56/XyX8OVsf4PxGDxDUNqP39WI3kdbx8STm4Y=;
        b=cd5JiIxNh9ELn8ucTBTyJa5xvl3oIZVt4U5fucXe09EUGwELRWLA7n41JfU/sAHB98
         UxX6VvKThJZQ26n799ZpNym7THdA5JgUM/hAdYuTG2Zih/APaWJ8u3rDCRNPpjdAx9DL
         KsTvgyTXzxMHi1GYRIij8esyNyRVuCvREoQ6/9mpVHwN3RFIlxzQ3MX1RrfJc+LMy95k
         RjcT+DePNa8vnZO5sKBGBfpQh5IakTCb6ql0/5V81J/WQWsELr28+zvYxWicLPkojpv5
         i2dC8sc/v1q7VDoJbq/pB5D2qbTA23PCg/64FDDF7BEdSXH2gufvmzV8LzfRYGtq2foL
         8cVA==
X-Gm-Message-State: AFqh2kpVQTWIjIbXOaZa90kLq+fOqlcM1mBM1TgbRnGBgHOW8rtn/YLS
        1wfQD0Y2UQK3r6cb3+QhBrKEskCAvFoY1Y3aN6iO9JgxGCCc+3ziaaR0VkyKlrmek+3BLGnytVC
        WepJLDddtXGIucOqC
X-Received: by 2002:a17:907:3f9d:b0:7c1:1c4:5eaf with SMTP id hr29-20020a1709073f9d00b007c101c45eafmr64230030ejc.49.1672933411009;
        Thu, 05 Jan 2023 07:43:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsbERp9ImDaNCzrV5I4d65046Fey1i3AgsqJdjD+sSzcM4MYCOgh3gfD2nUCFctSiQWAuCnAw==
X-Received: by 2002:a17:907:3f9d:b0:7c1:1c4:5eaf with SMTP id hr29-20020a1709073f9d00b007c101c45eafmr64229963ejc.49.1672933410239;
        Thu, 05 Jan 2023 07:43:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r28-20020a056402035c00b0045b4b67156fsm16088775edw.45.2023.01.05.07.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 07:43:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DEF878D9EC7; Thu,  5 Jan 2023 16:43:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
In-Reply-To: <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y7U8aAhdE3TuhtxH@lore-desk>
 <87bkne32ly.fsf@toke.dk> <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 05 Jan 2023 16:43:28 +0100
Message-ID: <871qo90yxr.fsf@toke.dk>
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

Tariq Toukan <ttoukan.linux@gmail.com> writes:

> On 04/01/2023 14:28, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>>=20
>>>> On Tue, 03 Jan 2023 16:19:49 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>>>>> Hmm, good question! I don't think we've ever explicitly documented any
>>>>> assumptions one way or the other. My own mental model has certainly
>>>>> always assumed the first frag would continue to be the same size as in
>>>>> non-multi-buf packets.
>>>>
>>>> Interesting! :) My mental model was closer to GRO by frags
>>>> so the linear part would have no data, just headers.
>>>
>>> That is assumption as well.
>>=20
>> Right, okay, so how many headers? Only Ethernet, or all the way up to
>> L4 (TCP/UDP)?
>>=20
>> I do seem to recall a discussion around the header/data split for TCP
>> specifically, but I think I mentally put that down as "something people
>> may way to do at some point in the future", which is why it hasn't made
>> it into my own mental model (yet?) :)
>>=20
>> -Toke
>>=20
>
> I don't think that all the different GRO layers assume having their=20
> headers/data in the linear part. IMO they will just perform better if=20
> these parts are already there. Otherwise, the GRO flow manages, and=20
> pulls the needed amount into the linear part.
> As examples, see calls to gro_pull_from_frag0 in net/core/gro.c, and the=
=20
> call to pskb_may_pull() from skb_gro_header_slow().
>
> This resembles the bpf_xdp_load_bytes() API used here in the xdp prog.

Right, but that is kernel code; what we end up doing with the API here
affects how many programs need to make significant changes to work with
multibuf, and how many can just set the frags flag and continue working.
Which also has a performance impact, see below.

> The context of my questions is that I'm looking for the right memory=20
> scheme for adding xdp-mb support to mlx5e striding RQ.
> In striding RQ, the RX buffer consists of "strides" of a fixed size set=20
> by pthe driver. An incoming packet is written to the buffer starting from=
=20
> the beginning of the next available stride, consuming as much strides as=
=20
> needed.
>
> Due to the need for headroom and tailroom, there's no easy way of=20
> building the xdp_buf in place (around the packet), so it should go to a=20
> side buffer.
>
> By using 0-length linear part in a side buffer, I can address two=20
> challenging issues: (1) save the in-driver headers memcpy (copy might=20
> still exist in the xdp program though), and (2) conform to the=20
> "fragments of the same size" requirement/assumption in xdp-mb.=20
> Otherwise, if we pull from frag[0] into the linear part, frag[0] becomes=
=20
> smaller than the next fragments.

Right, I see.

So my main concern would be that if we "allow" this, the only way to
write an interoperable XDP program will be to use bpf_xdp_load_bytes()
for every packet access. Which will be slower than DPA, so we may end up
inadvertently slowing down all of the XDP ecosystem, because no one is
going to bother with writing two versions of their programs. Whereas if
you can rely on packet headers always being in the linear part, you can
write a lot of the "look at headers and make a decision" type programs
using just DPA, and they'll work for multibuf as well.

But maybe I'm mistaken and people are just going to use the load_bytes
helper anyway because they want to go deeper than whatever "headers" bit
we'll end up guaranteeing is in the linear part?

-Toke

