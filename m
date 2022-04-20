Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE9B508098
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 07:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358395AbiDTFds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 01:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiDTFdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 01:33:46 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFF611C02;
        Tue, 19 Apr 2022 22:31:01 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e1so339542ile.2;
        Tue, 19 Apr 2022 22:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nuxxapEs+M5yK26jsf4JOVoP3RaTp9CaYMXH3Qi7BnM=;
        b=m6n3UDbwyYseWE0m3xwpSMxKMAQg7O+DYd9PY3jsVi5Vt8MdUMbWJ5BbMgjz0BLkQ1
         6Osczxl3Rx/2WnIhaqf6d9NB5vc/zN8cbIgGWqTn3AEhUMtf7gayYr6k7Kz1HHAu+IDx
         RryeOpN5H73JSax+jCknmY3/7vRPK+Dz/WFiARIiO5lNp9WGmRga4xIyGu5FbV0AYlrs
         y+184FwL3curFzsFKWcKpxIWZG91jaRxAIL4HoWCbe0taLf3STJYeregu81oeOsa53GW
         8YNXEdmBN9ENyp48LIRZ430fKDfP1u20700D9cvnx2hUbmxqf/2yb0g31yHtrM4o5TDI
         QZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nuxxapEs+M5yK26jsf4JOVoP3RaTp9CaYMXH3Qi7BnM=;
        b=qP4w+zmwBtAzbpSnIjH8ahh3WsQRqj1vGEFjTYzff7TYEH6jeKXq7YKtXfhF7IrWmm
         7SEESOPw90/MsHsPML0CgXuY+VeoCDHUE7CZNEg2ZjtPYljc9+GZ1AGmjtR4TYCzT0US
         ZLenKkFvbtztsuOBopiRqEWX6h67IIFOWXsDpZXIChMtS2lK+ieFB9uRTsQmwEDn2xMW
         2z6BUGHxZsgNlYm44CVHPwjta2GkmrWuSxpnPG623Jb2kwzp2JD1GHTSW0rI+yviq8Yl
         fhjbbFRKXhDFWhwnnH+tgYxTBGvnU8DYh7pLI2G97ilzdSDM5coLeQ/lK0vzSi4KDekR
         BDkA==
X-Gm-Message-State: AOAM53106cEJs8qoVPhRDn2hmGr1skCd1yAGt5x4tjEryj4QhLyg5lVg
        OmYdp98ZCQPczRmL10/Z8/yydvovYa1x5a9lX0k=
X-Google-Smtp-Source: ABdhPJzzqRVICUIJZyiBou/6sakX22tJlgAFvBTlOQOgOFFGsk6sXr6KK0CLtFM+CVx9UoVb7o+5cVtuaFR3tpGT4Mg=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr8064445ilb.305.1650432661257; Tue, 19
 Apr 2022 22:31:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220414223704.341028-1-alobakin@pm.me> <20220414223704.341028-2-alobakin@pm.me>
 <20220419090355.GP2731@worktop.programming.kicks-ass.net>
In-Reply-To: <20220419090355.GP2731@worktop.programming.kicks-ass.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Apr 2022 22:30:50 -0700
Message-ID: <CAEf4Bza=Ver5J-PYCceEohjgLSFVTCoYKXUEnc=uNkUC3rrZ5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/11] bpf, perf: fix bpftool compilation with !CONFIG_PERF_EVENTS
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 2:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Apr 14, 2022 at 10:44:48PM +0000, Alexander Lobakin wrote:
> > When CONFIG_PERF_EVENTS is not set, struct perf_event remains empty.
> > However, the structure is being used by bpftool indirectly via BTF.
> > This leads to:
> >
> > skeleton/pid_iter.bpf.c:49:30: error: no member named 'bpf_cookie' in 'struct perf_event'
> >         return BPF_CORE_READ(event, bpf_cookie);
> >                ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
> >
> > ...
> >
> > skeleton/pid_iter.bpf.c:49:9: error: returning 'void' from a function with incompatible result type '__u64' (aka 'unsigned long long')
> >         return BPF_CORE_READ(event, bpf_cookie);
> >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Tools and samples can't use any CONFIG_ definitions, so the fields
> > used there should always be present.
> > Move CONFIG_BPF_SYSCALL block out of the CONFIG_PERF_EVENTS block
> > to make it available unconditionally.
>
> Urgh, this is nasty.. did you verify nothing relies on that structure
> actually being empty?
>
> Also, why are we changing kernel headers to fix some daft userspace
> issue?
>

I agree, this is quite ugly. And I think it's not necessary at all.

BPF CO-RE, which bpftool relies on here, allows to have bpftool's own
minimal definition of struct perf_event with bpf_cookie field and not
rely on UAPI headers having full definition. Something like this:

struct perf_event___local {
    u64 bpf_cookie;
} __attribute__((preserve_access_index));

Then use `struct perf_event___local` (note the three underscores, they
are important) instead of struct perf_event in BPF code.

And we'll have to do the same for struct bpf_perf_link, I presume?

> > Fixes: cbdaf71f7e65 ("bpftool: Add bpf_cookie to link output")
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  include/linux/perf_event.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index af97dd427501..b1d5715b8b34 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -762,12 +762,14 @@ struct perf_event {
> >       u64                             (*clock)(void);
> >       perf_overflow_handler_t         overflow_handler;
> >       void                            *overflow_handler_context;
> > +#endif /* CONFIG_PERF_EVENTS */
> >  #ifdef CONFIG_BPF_SYSCALL
> >       perf_overflow_handler_t         orig_overflow_handler;
> >       struct bpf_prog                 *prog;
> >       u64                             bpf_cookie;
> >  #endif
> >
> > +#ifdef CONFIG_PERF_EVENTS
> >  #ifdef CONFIG_EVENT_TRACING
> >       struct trace_event_call         *tp_event;
> >       struct event_filter             *filter;
> > --
> > 2.35.2
> >
> >
