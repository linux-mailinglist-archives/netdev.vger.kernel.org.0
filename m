Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A725752A4
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiGNQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGNQVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 37F5F62488
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657815665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mZrd88vA65IAM29+EyEva7WRDVagjfNyLnQBYjfHAAc=;
        b=MdD7kmEf/ocFHgww57E0oeZX2seHS812QUXVP5KlwKoCClK0zNgY+xkG+Mtn/DrUUBs0N/
        qrDvrxRrBmaJ4//6duos6ok3OPwFcwWEzCL6WVM362aSBuyttlmuIAjjYvSClIbcbTUjFa
        7NPD+Z106gQbg5BA0vBv+NZLXpJOyp8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-_Vb-a3SdPSCZbArpvNksAA-1; Thu, 14 Jul 2022 12:21:03 -0400
X-MC-Unique: _Vb-a3SdPSCZbArpvNksAA-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a056402268f00b0043ac600a6bcso1763876edd.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 09:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mZrd88vA65IAM29+EyEva7WRDVagjfNyLnQBYjfHAAc=;
        b=q14Ug3rVFCMiiXKGzQWbOvHIsdhwCPeUDGPQB3wHLgXXxQMo0zCFW0z/A0tlPK7AXg
         DTrvKB1KuTgxd6Gj12QTiDEnb8e8BBw96qKImrSq8NDhvRBI9stAzY1Y25zDHUjOFK6h
         B941LEm0oYuis8Q2c5C0sf0NnT/cpRKfI8uzHX+zRjsQJ1YaM4LuHk5fvyJ7P+6umBet
         RU9LTMfc3fGGb2TQYi/XwD2s9+2FpOQa9YStGiyWuZwSP6DMA4rWqGtH+Abaplpj4m9w
         Tcr5lCLLuZUqqV4fUVDfc283WV6ghwpBM2C1IVdTOPEseRBa8iRLmRDJ04Smplf1v5n5
         VC1Q==
X-Gm-Message-State: AJIora8XV/IXCuLut0cHYkoULUs9crTfUqbjUNDkcB8c0yLNyozluo9n
        reuDDRVnQ8t+BNjFe9qaivaqi7bPlvWFfR+Wn/93VqPhIMOEVT7HbsXZ3Bxh2ogK4O6hLwFQGHR
        8p5XibGeXR+RDVaH+
X-Received: by 2002:a17:907:1b03:b0:6ff:78d4:c140 with SMTP id mp3-20020a1709071b0300b006ff78d4c140mr9798191ejc.554.1657815662188;
        Thu, 14 Jul 2022 09:21:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1suZy3eyfgIgGnufIGbSJyZzwXtSM3/fp0F8BczXQFtHwmk/uLXmanS3Tc6S/xx69LkMl3j5w==
X-Received: by 2002:a17:907:1b03:b0:6ff:78d4:c140 with SMTP id mp3-20020a1709071b0300b006ff78d4c140mr9798146ejc.554.1657815661832;
        Thu, 14 Jul 2022 09:21:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id cq16-20020a056402221000b0043a4a5813d8sm1283249edb.2.2022.07.14.09.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 09:21:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A6A9D4D9B7C; Thu, 14 Jul 2022 18:21:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
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
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling
 capabilities
In-Reply-To: <CAM0EoM=Pz_EWHsWzVZkZfojoRyUgLPVhGRHq6aGVhdcLC2YvHw@mail.gmail.com>
References: <20220713111430.134810-1-toke@redhat.com>
 <CAM0EoM=Pz_EWHsWzVZkZfojoRyUgLPVhGRHq6aGVhdcLC2YvHw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Jul 2022 18:21:00 +0200
Message-ID: <87sfn3oec3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> I think what would be really interesting is to see the performance numbers when
> you have multiple producers/consumers(translation multiple
> threads/softirqs) in play
> targeting the same queues. Does PIFO alleviate the synchronization challenge
> when you have multiple concurrent readers/writers? Or maybe for your use case
> this would not be a common occurrence or not something you care about?

Right, this is definitely one of the areas we want to flesh out some
more and benchmark. I think a PIFO-based algorithm *can* be an
improvement here because you can compute the priority without holding
any lock and only grab a lock for inserting the packet; which can be
made even better with a (partially) lockless data structure and/or
batching.

In any case we *have* to do a certain amount of re-inventing for XDP
because we can't reuse the qdisc infrastructure anyway. Ultimately, I
expect it will be possible to write both really well-performing
algorithms, and really badly-performing ones. Such is the power of BPF,
after all, and as long as we can provide an existence proof of the
former, that's fine with me :)

> As I mentioned previously, I think this is what Cong's approach gets
> for free.

Yes, but it also retains the global qdisc lock; my (naive, perhaps?)
hope is that since we have to do things differently in XDP land anyway,
that work can translate into something that is amenable to being
lockless in qdisc land as well...

-Toke

