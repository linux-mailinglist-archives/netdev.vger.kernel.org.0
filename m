Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828B44D0EB9
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 05:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245096AbiCHEjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 23:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237826AbiCHEi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 23:38:58 -0500
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD85C13DFB;
        Mon,  7 Mar 2022 20:38:02 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id r4so4376607lfr.1;
        Mon, 07 Mar 2022 20:38:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ExE8WvfRjxN7qDY8jPSgjg/R7OV7shYgJVHpiWtF5B0=;
        b=tdrCw6g87eglfm0a6/hBiFuro00rigVnHLE7JJf/bv2MCV7vhVr1lxyS/Bxr2N6KBX
         rODTDU50jQM+v5+nu+4AR7fPYUtCxLufBqOodY5EzB3GUdES6idwTpK6qIEsXRTm6sYN
         NwhGHwZmHKsml8YywguTaIphOcgBP3AVvwf1t5kytrL/DBVP+9TktHBgReijY8pqTZaU
         NhZLy9zx343W2OpW2rQ2N9YoZ0TYrahxDEWm9qBE2qymb1H8BcWG8zX2wR9ooLtavaZy
         +LX0UsxzZigtjV+2xNvsfA51/LsiQJ2Z8U+NKAkVzLSaHoVxSVJi3VqiEGtX4IBvdb+k
         BZIQ==
X-Gm-Message-State: AOAM531dH+/IfOJFTLYS/RxDXEzf4uteFimRg60kDjPAuENaxsGm0PIl
        jTEJqbGJC5a64zc3HeDHLKWI+mBUCJA8P9r8Y3Y=
X-Google-Smtp-Source: ABdhPJyphz/S/llS9OXnB/IurzYXJDmlGfTZKEoTxw80c268tGE+fz0VLXvl7vov35bB6OfbZPIvONAnX1pU3axlf4c=
X-Received: by 2002:a05:6512:2109:b0:448:2706:7bcb with SMTP id
 q9-20020a056512210900b0044827067bcbmr8121880lfr.528.1646714280654; Mon, 07
 Mar 2022 20:38:00 -0800 (PST)
MIME-Version: 1.0
References: <20220304232832.764156-1-namhyung@kernel.org> <38f99862-e5f4-0688-b5ef-43fa6584b823@fb.com>
In-Reply-To: <38f99862-e5f4-0688-b5ef-43fa6584b823@fb.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Mon, 7 Mar 2022 20:37:49 -0800
Message-ID: <CAM9d7cgHLDYVR-cJjw8xpWr9DvWR_C91hBiMN+eMNPB9UtROXg@mail.gmail.com>
Subject: Re: [RFC] A couple of issues on BPF callstack
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Eugene Loh <eugene.loh@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, Mar 5, 2022 at 4:28 PM Yonghong Song <yhs@fb.com> wrote:
> On 3/4/22 3:28 PM, Namhyung Kim wrote:
> > More important thing to me is the content of the (perf) callchain.  If
> > the event has __PERF_SAMPLE_CALLCHAIN_EARLY, it will have context info
> > like PERF_CONTEXT_KERNEL.  So user might or might not see it depending
> > on whether the perf_event set with precise_ip and SAMPLE_CALLCHAIN.
> > This doesn't look good.
>
> Patch 7b04d6d60fcf ("bpf: Separate bpf_get_[stack|stackid] for
> perf events BPF") tried to fix __PERF_SAMPLE_CALLCHAIN_EARLY issue
> for bpf_get_stack[id]() helpers.

Right.

> The helpers will check whether event->attr.sample_type has
> __PERF_SAMPLE_CALLCHAIN_EARLY encoded or not, based on which
> the stacks will be retrieved accordingly.
> Did you any issue here?

It changes stack trace results by adding perf contexts like
PERF_CONTEXT_KERNEL and PERF_CONTEXT_USER.
Without __PERF_SAMPLE_CALLCHAIN_EARLY, I don't see those.

> >
> > After all, I think it'd be really great if we can skip those
> > uninteresting info easily.  Maybe we could add a flag to skip BPF code
>
> We cannot just skip those callchains with __PERF_SAMPLE_CALLCHAIN_EARLY.
> There are real use cases for it.

I'm not saying that I want to skip all the callchains.
What I want is a way to avoid those perf context info
in the callchains so that I can make sure to have the
same stack traces in a known code path regardless
of the event attribute and cpu vendors - as far as I know
__PERF_SAMPLE_CALLCHAIN_EARLY is enabled on Intel cpus only.

>
> > perf context, and even some scheduler code from the trace respectively
> > like in stack_trace_consume_entry_nosched().
>
> A flag for the bpf_get_stack[id]() helpers? It is possible. It would be
> great if you can detail your use case here and how a flag could help
> you.

Yep, something like BPF_F_SKIP_BPF_STACK.

In my case, I collect a callchain in a tracepoint to find its caller.
And I want to have a short call stack depth for a performance reason.
But the every 3 or 4 entries are already filled by BPF code and
I want to skip them.  I know that I can set it with skip mask but
having a hard coded value can be annoying since it might be
changed by different compilers, kernel version or configurations.

Similarly, I think it'd be useful to skip some scheduler functions
like __schedule when collecting stack traces in sched_switch.

Thanks,
Namhyung
