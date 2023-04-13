Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D076E0BDA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDMKvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDMKvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 06:51:46 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4ED2D67
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:51:37 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50672fbf83eso1532339a12.0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 03:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681383096; x=1683975096;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RxeMOwbpGENb+weUS3Q3c1MqA2boB5pRuOKSrr+VKMA=;
        b=olAgFLXV5pQj078BxZmSCdSLqKQ8QJvL1YxmQNcD4ubNdFmVEZtp0Tj+74ZMtWMOcI
         DE+D3UQfYz/CR4E02hxL+0SMwxIGuIjRO1xaMbbjRWm4tXfmZNgoQWlWlrPAoPHccj6O
         VWdvaFir8HjPgBX+IRWFrxCNRDsXY7R42iz1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681383096; x=1683975096;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxeMOwbpGENb+weUS3Q3c1MqA2boB5pRuOKSrr+VKMA=;
        b=OIGRAQ49Ab2co1CpumV8zGuMqiVh6ngkobjFwLB1ADTocKIAmmOMSfHZsBrojTe80V
         MiKqaKWYOhG+Rvi+qL/9KgIoZog3y+OXj55j9dFLM4loVBVjTfEaIUFs4ZvmtKAVk0Wr
         dn/kQ12Vaf5cNX1JirVm6BhVGJpmcU4o9zVBO7JHpY4CfHfcUAjQuy6YEkKrdrj8eNFc
         9BHt5lFtZKlh7B5pJlgWBFwSt2LcCRPu5/EN0KgRvgdIIKz55eAK+8aThHiCyAZqAqNl
         tF47uFsWMKN44xA0j9Pfmw9lYbqhQVvXS7A36ehNZg9GSGgcdRJE4RS4U8w0SCXR79Wh
         lf+g==
X-Gm-Message-State: AAQBX9eKl8PiXrI3gcsnGHMkuKV9qlSX5OyleRqy5LRNhbcS0PVEiHIx
        IDQJbiAyCtlmO3mzHkMUzglAo4Plud3oD+kqtGNimw==
X-Google-Smtp-Source: AKy350aJVHJsIM/7Cw5RRVLHjyYZYMjj/wfkGRiEzVOfWIvLI+ptJr0GOC68cQM7cPhDCwcJUYGEhLI0zZpYDF8aKKM=
X-Received: by 2002:a50:bb25:0:b0:502:7551:86c7 with SMTP id
 y34-20020a50bb25000000b00502755186c7mr738815ede.4.1681383096281; Thu, 13 Apr
 2023 03:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
In-Reply-To: <875ya12phx.fsf@toke.dk>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Thu, 13 Apr 2023 12:56:20 +0200
Message-ID: <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Well, I'm mostly concerned with having two different operation and
> configuration modes for the same thing. We'll probably need to support
> multibuf for AF_XDP anyway for the non-ZC path, which means we'll need
> to create a UAPI for that in any case. And having two APIs is just going
> to be more complexity to handle at both the documentation and
> maintenance level.

I don't know if I would call this another "API". This patchset doesn't
change the semantics of anything. It only lifts the chunk size
restriction when hugepages are used. Furthermore, the changes here are
quite small and easy to understand. The four sentences added to the
documentation shouldn't be too concerning either. :-)

In 30 years when everyone finally migrates to page sizes >= 64K the
maintenance burden will drop to zero. Knock wood. :-)

>
> It *might* be worth it to do this if the performance benefit is really
> compelling, but, well, you'd need to implement both and compare directly
> to know that for sure :)

What about use-cases that require incoming packet data to be
contiguous? Without larger chunk sizes, the user is forced to allocate
extra space per packet and copy the data. This defeats the purpose of
ZC.
