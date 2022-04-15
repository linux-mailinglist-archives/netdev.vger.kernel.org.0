Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD155033DF
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352778AbiDOX46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiDOX44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81C12AE7;
        Fri, 15 Apr 2022 16:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E738B831BC;
        Fri, 15 Apr 2022 23:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B83DC385B4;
        Fri, 15 Apr 2022 23:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650066863;
        bh=zB3P6rJZN/By5Iuun6emUQBHSdfFSQaOz0rSzPoCu88=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pOQhh5/FCCUl6mq3o7UPQLlRBJuQIU1MhhHZPGuA+F55YhbJYQjPt77tb4QUxVd1O
         W0D9K6Nd144QRfk3wXYS04dXgv5kTc7Mnb/fs3nc0aEA8iCHtMdPMSn07ddWCspohY
         eLd6vn2JqHrGZ7/YlmpU6ktydWKWsC3GZ72EX597u8Plv8Nzxuq+HPkYFbrfY56mvs
         fKz6iF08n0r1VFB93pBSeHgcdsH1krCsbmhgHLmFuwsfDlJctJlEtUn6QmV3qTn4Hu
         dMIcdelqBXj49wdXu2nb+c9Pq/oN4SRKP8DA8ZvPf2lvZvxQp6W1Qjivhs676dK+Xu
         M/bAtVaQBSuNQ==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2eafabbc80aso95246127b3.11;
        Fri, 15 Apr 2022 16:54:22 -0700 (PDT)
X-Gm-Message-State: AOAM532ickrxeJeKrzHjlc9dyzFGxDyBMkTz2N1xv9KRkonam6c4MIMF
        JEAFB2Kzcx0ekruD4stQqohrf0xK/gXvZTxeq3g=
X-Google-Smtp-Source: ABdhPJwruJ2DfBF/L5tsPxBRZTqmDEHj/8xa6rjPWFgo5TGQaO8WRiBrIzExNV9TGp80OykO6utMSigN+h5+NhKMrzY=
X-Received: by 2002:a81:9b57:0:b0:2f1:49eb:1ad9 with SMTP id
 s84-20020a819b57000000b002f149eb1ad9mr1277161ywg.130.1650066861971; Fri, 15
 Apr 2022 16:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-9-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-9-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:54:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5KnLUfN2Vom1c2_+ZSeqfvnYpULhEVujeUBa_6OBQseg@mail.gmail.com>
Message-ID: <CAPhsuW5KnLUfN2Vom1c2_+ZSeqfvnYpULhEVujeUBa_6OBQseg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/11] samples: bpf: fix shifting unsigned long
 by 32 positions
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 3:46 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> On 32 bit systems, shifting an unsigned long by 32 positions
> yields the following warning:
>
> samples/bpf/tracex2_kern.c:60:23: warning: shift count >= width of type [-Wshift-count-overflow]
>         unsigned int hi = v >> 32;
>                             ^  ~~
>
> The usual way to avoid this is to shift by 16 two times (see
> upper_32_bits() macro in the kernel). Use it across the BPF sample
> code as well.
>
> Fixes: d822a1926849 ("samples/bpf: Add counting example for kfree_skb() function calls and the write() syscall")
> Fixes: 0fb1170ee68a ("bpf: BPF based latency tracing")
> Fixes: f74599f7c530 ("bpf: Add tests and samples for LWT-BPF")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: Song Liu <songliubraving@fb.com>
> ---
>  samples/bpf/lathist_kern.c      | 2 +-
>  samples/bpf/lwt_len_hist_kern.c | 2 +-
>  samples/bpf/tracex2_kern.c      | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/samples/bpf/lathist_kern.c b/samples/bpf/lathist_kern.c
> index 4adfcbbe6ef4..9744ed547abe 100644
> --- a/samples/bpf/lathist_kern.c
> +++ b/samples/bpf/lathist_kern.c
> @@ -53,7 +53,7 @@ static unsigned int log2(unsigned int v)
>
>  static unsigned int log2l(unsigned long v)
>  {
> -       unsigned int hi = v >> 32;
> +       unsigned int hi = (v >> 16) >> 16;
>
>         if (hi)
>                 return log2(hi) + 32;
> diff --git a/samples/bpf/lwt_len_hist_kern.c b/samples/bpf/lwt_len_hist_kern.c
> index 1fa14c54963a..bf32fa04c91f 100644
> --- a/samples/bpf/lwt_len_hist_kern.c
> +++ b/samples/bpf/lwt_len_hist_kern.c
> @@ -49,7 +49,7 @@ static unsigned int log2(unsigned int v)
>
>  static unsigned int log2l(unsigned long v)
>  {
> -       unsigned int hi = v >> 32;
> +       unsigned int hi = (v >> 16) >> 16;
>         if (hi)
>                 return log2(hi) + 32;
>         else
> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> index 5bc696bac27d..6bf22056ff95 100644
> --- a/samples/bpf/tracex2_kern.c
> +++ b/samples/bpf/tracex2_kern.c
> @@ -57,7 +57,7 @@ static unsigned int log2(unsigned int v)
>
>  static unsigned int log2l(unsigned long v)
>  {
> -       unsigned int hi = v >> 32;
> +       unsigned int hi = (v >> 16) >> 16;
>         if (hi)
>                 return log2(hi) + 32;
>         else
> --
> 2.35.2
>
>
