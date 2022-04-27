Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6955123B5
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiD0UPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiD0UOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:14:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E93939CF;
        Wed, 27 Apr 2022 13:08:45 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id g10so686196ilf.6;
        Wed, 27 Apr 2022 13:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cla1mRlZmz4uhMbCRbo+KpuTRkPBnIsQ9k/Thhz0OGo=;
        b=LkzYLHe6dAjRlXJcMe8Sfr4UR2W8rf+VrAkIXc7U9nyNahwgSriKY5afY1aq/huC0A
         X8TQ6p9+XYkycvafu84oWv2rO0GvgzZ1zVdnTbHUjc2aU3ohCrWpGUxuHTDyDqFsdlbH
         ycYnj9MyRzBEu8+rzisn8gfy70xlV0KyRfBC/nR8JM9o02IS8dcluzb/GClHGN8+UGs7
         DUkSa23YiAGWCsE1Dm26QVLh9A/KL+ZS/UC1jzsosTDymVi2D4Gs1AeD9W/QdD5RnUii
         +1s8058IIsLHatFe8RTS8ylWhOUm5Zxp1aydpufrG6iLMW9582/jjblwlbWkS1CNbizq
         m2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cla1mRlZmz4uhMbCRbo+KpuTRkPBnIsQ9k/Thhz0OGo=;
        b=PKio8gt8chbzRvFB5a04vDS3vFgoUhhGO3mX7b9vU83K5Ex8fU6p6Ops1NJkyrWb+4
         kDNxzlmjK4jjRoA/9F+eSRSRy0quRsZVyJn7zBxQp+Z6chN0DxvQ8t7NZK/KaYLSamkg
         N3FkJUjFqpU3IZja/oUV6OMrsB/aSYmYcBKyEDMDGXX98+xjy5KKP4Ph9WFWL1hYNONs
         oukQc6DV2tThsfNHy8/hrpUnMRAfu5i3JyW4rSrxTmi+Jt98UeVZnbcEp2haMtrbX3OI
         Sjj1ATPfs+GQwGrZ4EP/XGV9kly3gtIWYDXSk2mtUKV1sD/Y3JJlTg5hwHM8BO2WM0Rn
         1Pkw==
X-Gm-Message-State: AOAM5309u4yqURRKSmD14pIgzWry92JqC03mN0XXxwSL/cR8EpAsUNuQ
        hpFBmBvkrOwSfRLkPUxH8rnlV4BlvVrhlli9oJN+g0kaRC4=
X-Google-Smtp-Source: ABdhPJxVrHLWzMl2diBWW1SLZpza2DmwTehokXQ9z+ushyK6LQMn3k1/nLZJ4EoX0HKsBovaiBYn/tvZtloLZ+XJTgM=
X-Received: by 2002:a05:6e02:1ba3:b0:2cc:4158:d3ff with SMTP id
 n3-20020a056e021ba300b002cc4158d3ffmr11673755ili.98.1651090124991; Wed, 27
 Apr 2022 13:08:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220427070644.319661-1-imagedong@tencent.com>
In-Reply-To: <20220427070644.319661-1-imagedong@tencent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 13:08:34 -0700
Message-ID: <CAEf4BzaED-93fAR9YYA2RcCYNgzqAQki6exMyoabiZfJMVd-aQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] net: bpf: support direct packet access in
 tracing program
To:     menglong8.dong@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
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

On Wed, Apr 27, 2022 at 12:08 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> For now, eBPF program of type TRACING is able to access the arguments
> of the function or raw_tracepoint directly, which makes data access
> easier and efficient. And we can also output the raw data in skb to
> user space in tracing program by bpf_skb_output() helper.
>
> However, we still can't access the packet data in 'struct sk_buff'
> directly and have to use the helper bpf_probe_read_kernel() to analyse
> packet data.
>
> Network tools, which based on eBPF TRACING, often do packet analyse
> works in tracing program for filtering, statistics, etc. For example,
> we want to trace abnormal skb free through 'kfree_skb' tracepoint with
> special ip address or tcp port.
>
> In this patch, 2 helpers are introduced: bpf_skb_get_header() and
> bpf_skb_get_end(). The pointer returned by bpf_skb_get_header() has
> the same effect with the 'data' in 'struct __sk_buff', and
> bpf_skb_get_end() has the same effect with the 'data_end'.
>
> Therefore, we can now access packet data in tracing program in this
> way:
>
>   SEC("fentry/icmp_rcv")
>   int BPF_PROG(tracing_open, struct sk_buff* skb)
>   {
>         void *data, *data_end;
>         struct ethhdr *eth;
>
>         data = bpf_skb_get_header(skb, BPF_SKB_HEADER_MAC);
>         data_end = bpf_skb_get_end(skb);
>
>         if (!data || !data_end)
>                 return 0;
>
>         if (data + sizeof(*eth) > data_end)
>                 return 0;
>
>         eth = data;
>         bpf_printk("proto:%d\n", bpf_ntohs(eth->h_proto));
>
>         return 0;
>   }
>
> With any positive reply, I'll complete the selftests programs.

See bpf_dynptr patches that Joanne is working on. That's an
alternative mechanism for data/data_end and is going to be easier and
more flexible to work with. It is the plan that once basic bpf_dynptr
functionality lands, we'll have dynptr "constructors" for xdp_buff and
sk_buff. I think it's a better path forward.

>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/bpf.h      |  4 +++
>  include/uapi/linux/bpf.h | 29 ++++++++++++++++++++
>  kernel/bpf/verifier.c    |  6 +++++
>  kernel/trace/bpf_trace.c | 58 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 97 insertions(+)
>

[...]
