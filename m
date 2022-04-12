Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9369C4FCB02
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344671AbiDLBCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245667AbiDLA4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:56:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FF41FCC0;
        Mon, 11 Apr 2022 17:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0B09B8198C;
        Tue, 12 Apr 2022 00:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DC5C385AB;
        Tue, 12 Apr 2022 00:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724569;
        bh=bUn5MsT2K3tXiL4OUAHoHpu6WGSu0PQnC8Qt/TN43SE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ViCn0Y6LM+yv0btIMrHmlN+58EMx9MaXxxgCwKhNVwVOxuIGaKehJl/ZLscRhnQJ4
         mJ7lLRBHAgazX8B77zxLgrABdwYaIefAtrLOI4/52lNZv6Zx7nVnc4Pj3Huyu3F35f
         kHg7hiF5+AdmI3BRZTSyJWhLXYe6Jvk2Qw49+XyCjhOnI1yx1y2U4F/JrX9rH4s1as
         JjqNeKBJRlY7dTDblK05yNU7Bp5KPimltOU5ziXBZKlFCnPwICA7lEag1Pl9TdGHbv
         p6RKbqYj3pLBihxkZscNumNxW4BMAGw2c028jnQipUQUJjAibgIzUsKd1kzgSMe50o
         dPSG4eTamKURw==
Date:   Tue, 12 Apr 2022 09:49:23 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-Id: <20220412094923.0abe90955e5db486b7bca279@kernel.org>
In-Reply-To: <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 15:15:40 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> > +#define DEBUGFS "/sys/kernel/debug/tracing/"
> > +
> > +static int get_syms(char ***symsp, size_t *cntp)
> > +{
> > +       size_t cap = 0, cnt = 0, i;
> > +       char *name, **syms = NULL;
> > +       struct hashmap *map;
> > +       char buf[256];
> > +       FILE *f;
> > +       int err;
> > +
> > +       /*
> > +        * The available_filter_functions contains many duplicates,
> > +        * but other than that all symbols are usable in kprobe multi
> > +        * interface.
> > +        * Filtering out duplicates by using hashmap__add, which won't
> > +        * add existing entry.
> > +        */
> > +       f = fopen(DEBUGFS "available_filter_functions", "r");
> 
> I'm really curious how did you manage to attach to everything in
> available_filter_functions because when I'm trying to do that I fail.
> available_filter_functions has a bunch of functions that should not be
> attachable (e.g., notrace functions). Look just at __bpf_tramp_exit:
> 
>   void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr);

Hmm, this sounds like a bug in ftrace side. IIUC, the
"available_filter_functions" only shows the functions which is NOT
instrumented by mcount, we should not see any notrace functions on it.

Technically, this is done by __no_instrument_function__ attribute.

#if defined(CC_USING_HOTPATCH)
#define notrace                 __attribute__((hotpatch(0, 0)))
#elif defined(CC_USING_PATCHABLE_FUNCTION_ENTRY)
#define notrace                 __attribute__((patchable_function_entry(0, 0)))
#else
#define notrace                 __attribute__((__no_instrument_function__))
#endif

> 
> So first, curious what I am doing wrong or rather why it succeeds in
> your case ;)
> 
> But second, just wanted to plea to "fix" available_filter_functions to
> not list stuff that should not be attachable. Can you please take a
> look and checks what's going on there and why do we have notrace
> functions (and what else should *NOT* be there)?

Can you share how did you reproduce the issue? I'll check it.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
