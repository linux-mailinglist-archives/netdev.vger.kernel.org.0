Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253CA51220E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 21:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiD0THR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 15:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiD0THA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 15:07:00 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D00EBF71;
        Wed, 27 Apr 2022 11:53:52 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id f2so3981801ioh.7;
        Wed, 27 Apr 2022 11:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VJ91s6H07ClEByjQbgZruheBlPpsvHRlP6vfpPqzZKY=;
        b=EKwxHil5G0kU+wbkmov0G1EaEobARTaBhSglDRm/pqjMlzyw2xWvkwLpGcmiuCwiWJ
         At36hRwRARLjFsB0PsstrYFE9MGEZmMhqVj6IkdW1Qe3i77MufwhagvCIO3pyldfedH+
         1L5FME3HrT5gXe+YfTuK1vScwvVdBBAvF3r85wZ4RSEairsG6Sl93FEnp+wFW9Lub42h
         JoeSUxM+XtEzDhZiGXt0UT79mhVEXx13upi3pSqqFpUs393Ub5H4TEiurTeKxrq4SzOx
         bx8DqZf4u4eSuipwPj4ZXSXZxkJ0PDwLmP82YCvAND/nMeSjVzccZu1gkgmHm97aBOf9
         qsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VJ91s6H07ClEByjQbgZruheBlPpsvHRlP6vfpPqzZKY=;
        b=7DgfYkHZAWMo6vQgfeQRIq5cEzoy5ln7IM4WnC5QDK5RNvL4sWJhf8HfrdWkhFIOLV
         hZwD88uaM1y7aZa5X4MtHbpN5H7ivchG2GjCDVFQTsjzbAoYSUehfkSZkAuaLDzYL56w
         JYvz+MOw2q7H1gWClR1iaI273B5yOzpAZoRvmO87ppgdJHmi1VMNb/gTM48LlIBpGsJ1
         f1IczIgT4Pmid1K7r44pCn0Pe6ahYFS9Gcl7BMy6PTzC5HKopCyfYL8vV1j5yTsBY1D+
         vvrwmmCHmPwZF4vA2y8nGmx430i6yWvsbAA2wLJGFQdVflkg0Xb741PxTv7Q+CM3q14Y
         CgCw==
X-Gm-Message-State: AOAM532Bq7F0sbmi/E6zbD8SAY5HUkSBJ3uSyn/AWDmJS4Bj5awY7QNB
        D8gF+4EQofjMuQ93QyuDwEl9BHTLQEPPi0DJ0N4=
X-Google-Smtp-Source: ABdhPJzl9VUnx3Oh6fY4dpfEp3sorFTDo26fFd33NZFaIoxLMKHh9xEeNMXVp8dcrjOJt836MeA+18nprDrk4z78Bj8=
X-Received: by 2002:a5d:9f4e:0:b0:652:2323:2eb8 with SMTP id
 u14-20020a5d9f4e000000b0065223232eb8mr12051724iot.79.1651085631636; Wed, 27
 Apr 2022 11:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-9-alobakin@pm.me>
 <CAEf4BzZVohaHdCTz_KFVdEus2pndLTZvg=BHfujpgt29qbio3Q@mail.gmail.com> <05d21d85-7b59-a8f9-73dc-89189986db11@fb.com>
In-Reply-To: <05d21d85-7b59-a8f9-73dc-89189986db11@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 11:53:40 -0700
Message-ID: <CAEf4BzYrEfkdvP+k+np0S9-Rtf=xnpgVhL25wFgPQ81bm-_h_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/11] samples: bpf: fix shifting unsigned long
 by 32 positions
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Song Liu <songliubraving@fb.com>,
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
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 8:55 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/20/22 10:18 AM, Andrii Nakryiko wrote:
> > On Thu, Apr 14, 2022 at 3:46 PM Alexander Lobakin <alobakin@pm.me> wrote:
> >>
> >> On 32 bit systems, shifting an unsigned long by 32 positions
> >> yields the following warning:
> >>
> >> samples/bpf/tracex2_kern.c:60:23: warning: shift count >= width of type [-Wshift-count-overflow]
> >>          unsigned int hi = v >> 32;
> >>                              ^  ~~
> >>
> >
> > long is always 64-bit in BPF, but I suspect this is due to
> > samples/bpf/Makefile still using this clang + llc combo, where clang
> > is called with native target and llc for -target bpf. Not sure if we
> > are ready to ditch that complicated combination. Yonghong, do we still
> > need that or can we just use -target bpf in samples/bpf?
>
> Current most bpf programs in samples/bpf do not use vmlinux.h and CO-RE.
> They direct use kernel header files. That is why clang C -> IR
> compilation still needs to be native.
>
> We could just use -target bpf for the whole compilation but that needs
> to change the code to use vmlinux.h and CO-RE. There are already a
> couple of sample bpf programs did this.

Right, I guess I'm proposing to switch samples/bpf to vmlinux.h. Only
purely networking BPF apps can get away with not using vmlinux.h
because they might avoid dependency on kernel types. But even then a
lot of modern networking apps seem to be gaining elements of more
generic tracing and would rely on CO-RE for staying "portable" between
kernels. So it might be totally fine to just use CO-RE universally in
samples/bpf?

>
> >
> >
> >> The usual way to avoid this is to shift by 16 two times (see
> >> upper_32_bits() macro in the kernel). Use it across the BPF sample
> >> code as well.
> >>
> >> Fixes: d822a1926849 ("samples/bpf: Add counting example for kfree_skb() function calls and the write() syscall")
> >> Fixes: 0fb1170ee68a ("bpf: BPF based latency tracing")
> >> Fixes: f74599f7c530 ("bpf: Add tests and samples for LWT-BPF")
> >> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> >> ---
> >>   samples/bpf/lathist_kern.c      | 2 +-
> >>   samples/bpf/lwt_len_hist_kern.c | 2 +-
> >>   samples/bpf/tracex2_kern.c      | 2 +-
> >>   3 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >
> > [...]
