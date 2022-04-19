Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD44506765
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 11:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350291AbiDSJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 05:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiDSJHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 05:07:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD82101D;
        Tue, 19 Apr 2022 02:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tJv95mQg9EXcrt3p8ZvGMQTsakmmfw1AaQTwIhE1nnE=; b=Ib42ZfuGQhQogTNLh41qU+s7rN
        BRAbnqQc1YebQu2SE8eJycbwM5rnxrVzV01lhWWogtc7YfXe/fFYOOfKul6INZN27AAxhe9cF4b6Y
        kxe7Cp27gTncTOlOpfatmhDKqOzrjoG3bUGTaMJhWsb8S9YtpZbHjlOtOGIGoXOry9C6n83iBpSg6
        sZV0VjTQqYvJg7uxZkk0kWg0ifqjNnMHZFF4jfCJ5RF4KXfuvH8Y9l7waFzBdNLDaqLfKytxkGozo
        OIzVudh0DufesV21MGJcSWu6hmhsMtoQmfa3Fc0BVR5Bg0eFxc6+wJrPo03zB3mULzxQslLelWcjt
        UrbiTiEQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ngjmA-006mQV-2G; Tue, 19 Apr 2022 09:03:58 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7D15998618A; Tue, 19 Apr 2022 11:03:55 +0200 (CEST)
Date:   Tue, 19 Apr 2022 11:03:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
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
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
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
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH bpf-next 01/11] bpf, perf: fix bpftool compilation with
 !CONFIG_PERF_EVENTS
Message-ID: <20220419090355.GP2731@worktop.programming.kicks-ass.net>
References: <20220414223704.341028-1-alobakin@pm.me>
 <20220414223704.341028-2-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414223704.341028-2-alobakin@pm.me>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 10:44:48PM +0000, Alexander Lobakin wrote:
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

Urgh, this is nasty.. did you verify nothing relies on that structure
actually being empty?

Also, why are we changing kernel headers to fix some daft userspace
issue?

> Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  include/linux/perf_event.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index af97dd427501..b1d5715b8b34 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -762,12 +762,14 @@ struct perf_event {
>  	u64				(*clock)(void);
>  	perf_overflow_handler_t		overflow_handler;
>  	void				*overflow_handler_context;
> +#endif /* CONFIG_PERF_EVENTS */
>  #ifdef CONFIG_BPF_SYSCALL
>  	perf_overflow_handler_t		orig_overflow_handler;
>  	struct bpf_prog			*prog;
>  	u64				bpf_cookie;
>  #endif
> 
> +#ifdef CONFIG_PERF_EVENTS
>  #ifdef CONFIG_EVENT_TRACING
>  	struct trace_event_call		*tp_event;
>  	struct event_filter		*filter;
> --
> 2.35.2
> 
> 
