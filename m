Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8026CEE59
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjC2QAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjC2P7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:59:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A04161B2
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:59:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so65302057ede.8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680105541;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O9rVM+TyMjTEamPO1YLxI72VkrMEpvNCPXT/D1jIETM=;
        b=XElgWmxaLhWe5F03cqiSoKI5bsUuTFyQ+Omq+unoOkkS+T83i7Pjlb4L8E3+ae9LnX
         FmEl9W3QfJ+4JLTMi2uGEKY4oZYK3OWdsd4EzdiU9RAOcJgrr4KVwihtVUD1H95qPzjz
         BQl6Y6HRA0H+bj9LIN7FpbHJPOb6pZ9HmVQ2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680105541;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O9rVM+TyMjTEamPO1YLxI72VkrMEpvNCPXT/D1jIETM=;
        b=fXRxInSJfNzFiIoNo9FuuV5VZ9b0pFqMVadppbJ8+lfVcuQNMatdMhv7WoM7pJiq/E
         XYkFYLwFwiJfLe/9zbqL8skRZQYmQA8EWDVxyVjbsbZxIiF3oB6dBPtsxdGvUZVq1bmq
         xfQcxXTvZZ5YsWuj/WzI45/KPMcIn2PkjFasLDMSaxU+VrfPMco2NpJd+iGZp2WYJgTB
         7I7De4kvJ5yjSNYPIh1uui4gecp9HJTFnyE5HphclOWWW41tOPbT49kxDvUhMYbSP08W
         wmqFVuKqZvFhU1TGokT9YmWj2dZkJE/DWAoAeo8BYqbcNJdfdiultkGx2SUVYEf7rfcy
         awmw==
X-Gm-Message-State: AAQBX9c79sI6HJvOQTcc7fA1+SPYNQ6ykpx/ncGbPMcMCM/R9xrBnrp9
        o8di1ZkwXDCqUvlV7pyhFQjfqpKlizmvWP4RODK4vw==
X-Google-Smtp-Source: AKy350Zsj7496tj4JV/et0FhpoM2AUiFOnO2pMRSyzkfT3qLg0ZXJJR+WBgcmP04Czf7BiQbP518zk4JdiFw8TQBcvI=
X-Received: by 2002:a17:907:a49:b0:931:6f5b:d27d with SMTP id
 be9-20020a1709070a4900b009316f5bd27dmr10361097ejc.0.1680105540984; Wed, 29
 Mar 2023 08:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230319195656.326701-1-kal.conley@dectris.com>
 <20230319195656.326701-2-kal.conley@dectris.com> <CAJ8uoz2d9cSvLeguJ+5KenCqibxpshCiAKms4c75mGgzJVmkBA@mail.gmail.com>
In-Reply-To: <CAJ8uoz2d9cSvLeguJ+5KenCqibxpshCiAKms4c75mGgzJVmkBA@mail.gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Wed, 29 Mar 2023 18:03:35 +0200
Message-ID: <CAHApi-mEwbAcYzHHTR0QMSA8EqByvmwzLCBkMw2_6hxqkiCBmQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
> > enables sending/receiving jumbo ethernet frames up to the theoretical
> > maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
> > to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
> > XDP_COPY mode is usuable pending future driver work.
>
> nit: useable

Fixed in v2.

>
> > For consistency, check for HugeTLB pages during UMEM registration. This
> > implies that hugepages are required for XDP_COPY mode despite DMA not
> > being used. This restriction is desirable since it ensures user software
> > can take advantage of future driver support.
> >
> > Even in HugeTLB mode, continue to do page accounting using order-0
> > (4 KiB) pages. This minimizes the size of this change and reduces the
> > risk of impacting driver code. Taking full advantage of hugepages for
> > accounting should improve XDP performance in the general case.
>
> Thank you Kal for working on this. Interesting stuff.
>
> First some general comments and questions on the patch set:
>
> * Please document this new feature in Documentation/networking/af_xdp.rst

Fixed in v2.

> * Have you verified the SKB path for Rx? Tx was exercised by running l2fwd.

This patchset allows sending/receiving 9000 MTU packets with xdpsock
(slightly modified). The benchmark numbers show the results for rxdrop
(-r).

> * Have you checked that an XDP program can access the full >4K packet?
> The xdp_buff has no problem with this as the buffer is consecutive,
> but just wondering if there is some other check or limit in there?
> Jesper and Toke will likely know, so roping them in.

Yes, the full packet can be accessed from a SEC("xdp") BPF program
(only tested in SKB mode).

> * Would be interesting to know your thoughts about taking this to
> zero-copy mode too. It would be good if you could support all modes
> from the get go, instead of partial support for some unknown amount of
> time and then zero-copy support. Partial support makes using the
> feature more cumbersome when an app is deployed on various systems.
> The continuity checking code you have at the end of the patch is a
> step in the direction of zero-copy support, it seems.

I think this patchset is enough to support zero-copy as long as the
driver allows it. Currently, no drivers will work out of the box AFAIK
since they all validate the chunk_size or the MTU size. I would
absolutely love for drivers to support this. Hopefully this patchset
is enough inspiration? :-) Do you think it's absolutely necessary to
have driver ZC support ready to land this?

> * What happens if I try to run this in zero-copy mode with a chunk_size > 4K?

AFAIK drivers check for this and throw an error. Maybe there are some
drivers that don't check this properly?

> * There are some compilation errors to fix from the kernel test robot

Fixed in v2.

>
> require_hugetlb would be a clearer name

Fixed in v2. Renamed to `need_hugetlb`.

>
> next_mapping? n as a name is not very descriptive.

Fixed in v2. Renamed to `stride`.

>
> >         u32 i;
> >
> > -       for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> > -               if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> > +       for (i = 0; i + n < dma_map->dma_pages_cnt; i++) {
> > +               if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + n])
> >                         dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> >                 else
> >                         dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> >         }
> > +       for (; i < dma_map->dma_pages_cnt; i++)
> > +               dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
>
> Is this not too conservative? If your umem consists of two huge pages
> mappings but they are not mapped consecutively in physical memory, you
> are going to mark all the chunks as non-consecutive. Would it not be
> better to just look chunk_size ahead of you instead of page_size
> above? The only thing you care about is that the chunk you are in is
> in consecutive physical memory, and that is strictly only true for
> zero-copy mode. So this seems to be in preparation for zero-copy mode.
>

It is slightly too conservative. I have updated the logic a bit in v2.
If the packet doesn't cross a page boundary, then this array is not
read anyway.

Thanks!
Kal
