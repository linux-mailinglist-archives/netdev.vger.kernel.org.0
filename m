Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5355030F8
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiDOXKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiDOXKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:10:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60006183BE;
        Fri, 15 Apr 2022 16:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B0D3B831BB;
        Fri, 15 Apr 2022 23:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D519C385AF;
        Fri, 15 Apr 2022 23:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650064090;
        bh=bun1UW6dQN+eeylN7K4W70rNw5ZTuBxbCaji7Cqa870=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Kx2EbsKWUajlN+9EYTClzJvSsIYSC0HMbpGZJ+ViEb6kodJh4fqPQAafSm+RNgDyY
         UD5s7AzJmqA4r/G5RGaG6yMqa+SBGNxlSotO8THxVSeIeEXnnf0ZuynU28sa3oicyC
         IGc/GOGHFZe05gBPClMuGve0nkZ00NXKVv1beymT0WVvzlnXjIkCObGjHkboA+UfRL
         j5UZsaRvZM1eY02Vv7aE+eaLwlkg30VQ2hybLCDwIDQTPH58qWHccOtOXCFTXbAyG9
         JPBwM0TPIzODSx3pqPfRF7LEm6xYOSCceYrjHY/ZpDYJoOogFqwOTd4GCDI5eNOLfS
         bEo9m5ZHCFNWw==
Received: by mail-yb1-f173.google.com with SMTP id t67so16608290ybi.2;
        Fri, 15 Apr 2022 16:08:10 -0700 (PDT)
X-Gm-Message-State: AOAM530y8pse7f21Iqhf5l9O4k5JLtanBK0CPOKKp15Y1z9uw6DCGsvA
        HUN+5VnOloum4YqU/Xq4BZmfDZLht1GBIV/dPqU=
X-Google-Smtp-Source: ABdhPJzfao0cbhuAT+evsmpeKuZ23Th3dopsUfXigTn3uQNgTDcD+/N0ixKG3h8vTUKKSo+9oYfu8IiLwQdS0yiXQk8=
X-Received: by 2002:a05:6902:1506:b0:63e:4f1b:40ae with SMTP id
 q6-20020a056902150600b0063e4f1b40aemr1355690ybu.322.1650064089602; Fri, 15
 Apr 2022 16:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-2-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-2-alobakin@pm.me>
From:   Song Liu <song@kernel.org>
Date:   Fri, 15 Apr 2022 16:07:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7qrH6Fc-MSJSJzS0r_vDzTfHyaaRDGhrTjo9vijQwpWg@mail.gmail.com>
Message-ID: <CAPhsuW7qrH6Fc-MSJSJzS0r_vDzTfHyaaRDGhrTjo9vijQwpWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/11] bpf, perf: fix bpftool compilation with !CONFIG_PERF_EVENTS
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

On Thu, Apr 14, 2022 at 3:45 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> When CONFIG_PERF_EVENTS is not set, struct perf_event remains empty.
> However, the structure is being used by bpftool indirectly via BTF.
> This leads to:
>
> skeleton/pid_iter.bpf.c:49:30: error: no member named 'bpf_cookie' in 'struct perf_event'
>         return BPF_CORE_READ(event, bpf_cookie);
>                ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
>
> ...
>
> skeleton/pid_iter.bpf.c:49:9: error: returning 'void' from a function with incompatible result type '__u64' (aka 'unsigned long long')
>         return BPF_CORE_READ(event, bpf_cookie);
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Tools and samples can't use any CONFIG_ definitions, so the fields
> used there should always be present.
> Move CONFIG_BPF_SYSCALL block out of the CONFIG_PERF_EVENTS block
> to make it available unconditionally.
>
> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

While I can't think of a real failure with this approach, it does feel
weird to me. Can we fix this with bpf_core_field_exists()?

Thanks,
Song


> ---
>  include/linux/perf_event.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index af97dd427501..b1d5715b8b34 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -762,12 +762,14 @@ struct perf_event {
>         u64                             (*clock)(void);
>         perf_overflow_handler_t         overflow_handler;
>         void                            *overflow_handler_context;
> +#endif /* CONFIG_PERF_EVENTS */
>  #ifdef CONFIG_BPF_SYSCALL
>         perf_overflow_handler_t         orig_overflow_handler;
>         struct bpf_prog                 *prog;
>         u64                             bpf_cookie;
>  #endif
>
> +#ifdef CONFIG_PERF_EVENTS
>  #ifdef CONFIG_EVENT_TRACING
>         struct trace_event_call         *tp_event;
>         struct event_filter             *filter;
> --
> 2.35.2
>
>
