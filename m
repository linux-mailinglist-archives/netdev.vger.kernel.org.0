Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A7862572E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbiKKJqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiKKJqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:46:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084332A3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668159905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zNf7ZXOT6z9fd4Tt6B6QdA1QJpIGsL1BM+FjfGyIKL0=;
        b=D4LtCxJuepEyJk4etcmIGGCRZr+zVpiMH1QeB/pkifPqrMdmWexRhG/IndPdGjIBSijeqB
        sxL/20MFGp/suLyvqr/4y0ulJY6Nt2Oj4vzGliuks6aKsJaty4UvA+NqKlEd+P2ES73gXh
        FQP/IFaCYwBRg6B0tSEvF/8MuI8bryA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-637-FDMTCpXbNneMSta9GYfDLQ-1; Fri, 11 Nov 2022 04:45:03 -0500
X-MC-Unique: FDMTCpXbNneMSta9GYfDLQ-1
Received: by mail-ej1-f72.google.com with SMTP id sd31-20020a1709076e1f00b007ae63b8d66aso2752037ejc.3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:45:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zNf7ZXOT6z9fd4Tt6B6QdA1QJpIGsL1BM+FjfGyIKL0=;
        b=UUvSyly9OxSMHXKFAUwL0zq6SMXdAGKwKhtyrm530zrxCXiqIkhladS/9VwCAnRmgn
         577u97fgrwKt3FSB/xVvVc4FuxJSkbkVXnRPOi7NHkgFP5b7+KurUajvoSHXOEEHSCUu
         MCGVUhFdBT9EIvWFXS7Zw2tDg0b9Kr39wHNceXDd/d6BPk6hEWJbbMdusL4xT0Lv/gNj
         RIbv2qnFRxKCKY7Af9kkA7eL64ChQflXegMLyDN+0OjbRkK2bNBXYp7Wp4VNvIk2w3GS
         X98scUBHcnr6wc0mk9wdsJcC0ObJP3xeeD4veIBQku6pmlwHM0yi495FVQiMyM29q+Pj
         H/iQ==
X-Gm-Message-State: ANoB5pkNQtfGwzkuy9WTlQJOsxM+CrnMBJZHFTyLSJFJ/dims5y1T0Lx
        Wr9OLDWTYrqNSzompFUCxFsazmHPASIFZzHVM3LS4Ke/ej9SWex4mp9ksbN/N9EIXBorCFt464R
        qdngx//Cd/3HbFvRG
X-Received: by 2002:aa7:c702:0:b0:461:8156:e0ca with SMTP id i2-20020aa7c702000000b004618156e0camr733236edq.271.1668159902255;
        Fri, 11 Nov 2022 01:45:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf51QzkFNHVdKXxekMd802nRscfJVnL2TqOzrhRzF34Md3cQPmIKH7X2QQ2HioI6VTLXL5UqJw==
X-Received: by 2002:aa7:c702:0:b0:461:8156:e0ca with SMTP id i2-20020aa7c702000000b004618156e0camr733214edq.271.1668159901827;
        Fri, 11 Nov 2022 01:45:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f7-20020a1709063f4700b0078d0981516esm719419ejj.38.2022.11.11.01.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 01:45:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 800987A68A3; Fri, 11 Nov 2022 10:44:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Stanislav Fomichev <sdf@google.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [xdp-hints] Re: [RFC bpf-next v2 06/14] xdp: Carry over xdp
 metadata into skb context
In-Reply-To: <ed37045f-eb3d-8db0-4e5d-12bf7da8587e@linux.dev>
References: <20221104032532.1615099-1-sdf@google.com>
 <20221104032532.1615099-7-sdf@google.com>
 <187e89c3-d7de-7bec-c72e-d9d6eb5bcca0@linux.dev>
 <CAKH8qBv_ZO=rsJcq2Lvq36d9sTAXs6kfUmW1Hk17bB=BGiGzhw@mail.gmail.com>
 <9a8fefe4-2fcb-95b7-cda0-06509feee78e@linux.dev>
 <6f57370f-7ec3-07dd-54df-04423cab6d1f@linux.dev> <87leokz8lq.fsf@toke.dk>
 <5a23b856-88a3-a57a-2191-b673f4160796@linux.dev> <871qqazyc9.fsf@toke.dk>
 <7eb3e22a-c416-e898-dff0-1146d3cc82c0@linux.dev> <87mt8yxuag.fsf@toke.dk>
 <ed37045f-eb3d-8db0-4e5d-12bf7da8587e@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Nov 2022 10:44:58 +0100
Message-ID: <87iljl7rl1.fsf@toke.dk>
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

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 11/10/22 3:29 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> For the metadata consumed by the stack right now it's a bit
>>>> hypothetical, yeah. However, there's a bunch of metadata commonly
>>>> supported by hardware that the stack currently doesn't consume and that
>>>> hopefully this feature will end up making more accessible. My hope is
>>>> that the stack can also learn how to use this in the future, in which
>>>> case we may run out of space. So I think of that bit mostly as
>>>> future-proofing...
>>>
>>> ic. in this case, Can the btf_id be added to 'struct xdp_to_skb_metadat=
a' later
>>> if it is indeed needed?  The 'struct xdp_to_skb_metadata' is not in UAP=
I and
>>> doing it with CO-RE is to give us flexibility to make this kind of chan=
ges in
>>> the future.
>>=20
>> My worry is mostly that it'll be more painful to add it later than just
>> including it from the start, mostly because of AF_XDP users. But if we
>> do the randomisation thing (thus forcing AF_XDP users to deal with the
>> dynamic layout as well), it should be possible to add it later, and I
>> can live with that option as well...
>
> imo, considering we are trying to optimize unnecessary field
> initialization as below, it is sort of wasteful to always initialize
> the btf_id with the same value. It is better to add it in the future
> when there is a need.

Okay, let's omit the BTF ID for now, and see what that looks like. I'll
try to keep in mind to see if I can find any reasons why we'd need to
add it back and make sure to complain before this lands if I find any :)

-Toke

