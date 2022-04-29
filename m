Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2565E513F8C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 02:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351511AbiD2AfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 20:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiD2AfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 20:35:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288A6B9F02;
        Thu, 28 Apr 2022 17:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD912B83260;
        Fri, 29 Apr 2022 00:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D298DC385A9;
        Fri, 29 Apr 2022 00:31:53 +0000 (UTC)
Date:   Thu, 28 Apr 2022 20:31:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-ID: <20220428203152.41693bbe@gandalf.local.home>
In-Reply-To: <20220428200945.5f6a5ba2@gandalf.local.home>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
        <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
        <20220428095803.66c17c32@gandalf.local.home>
        <CAADnVQKi+4oBt2C__qz7QoHqTtXYLUjaqwTNFoSE=up9c9k4cA@mail.gmail.com>
        <20220428160519.04cc40c0@gandalf.local.home>
        <CAEf4Bzbu3zuDcPj3ue8D6VCdMTw2PEREJBU42CbR1Pe=5qOrTQ@mail.gmail.com>
        <20220428195303.6295e90b@gandalf.local.home>
        <20220428200945.5f6a5ba2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 20:09:45 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> OK, I think I see the issue you have. Because the functions shown in
> available_filter_functions which uses the simple "%ps" to show the function
> name:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/trace/ftrace.c#n3692
> 
> And the code that does the actual matching uses kallsyms_lookup()
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/trace/ftrace.c#n4017
> 
> Which appears not to match the function for the address, you can't pass in
> __bpf_tramp_exit because it wont match the symbol returned by
> kallsyms_lookup.

Never mind, in testing this I had marked the weak function as notrace,
which was the reason I couldn't add it to the set_ftrace_notrace.

After removing the notrace, kallsyms_lookup() doesn't make a difference. It
appears that kallsyms will include overridden weak functions into the size
of the function before it. I tried:

	ret = kallsyms_lookup(rec->ip, &size, &offset, &modname, str);
	if (!ret || offset > size) {
		seq_printf(m, "no function at %lx", rec->ip);
	} else {
		seq_printf(m, "%s", str);
		if (modname)
			seq_printf(m, " [%s]", modname);
	}

And it made no difference.

> 
> This does indeed look like a bug in %ps.
> 

Yes, this does appear to be a issue with kallsyms in general.

-- Steve
