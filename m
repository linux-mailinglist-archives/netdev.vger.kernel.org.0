Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF25362C3
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 14:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352308AbiE0MlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 08:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353162AbiE0MkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 08:40:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B950B1C920;
        Fri, 27 May 2022 05:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 728C7B823D0;
        Fri, 27 May 2022 12:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903ADC385A9;
        Fri, 27 May 2022 12:30:45 +0000 (UTC)
Date:   Fri, 27 May 2022 08:30:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: Re: [PATCH v4] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220527083043.022e8e36@gandalf.local.home>
In-Reply-To: <20220526141912.794c2786@gandalf.local.home>
References: <20220526141912.794c2786@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 14:19:12 -0400
Steven Rostedt <rostedt@goodmis.org> (by way of Steven Rostedt
<rostedt@goodmis.org>) wrote:

> +++ b/kernel/trace/ftrace.c
> @@ -3654,6 +3654,31 @@ static void add_trampoline_func(struct seq_file *m, struct ftrace_ops *ops,
>  		seq_printf(m, " ->%pS", ptr);
>  }
>  
> +#ifdef FTRACE_MCOUNT_MAX_OFFSET
> +static int print_rec(struct seq_file *m, unsigned long ip)
> +{
> +	unsigned long offset;
> +	char str[KSYM_SYMBOL_LEN];
> +	char *modname;
> +	const char *ret;
> +
> +	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);
> +	if (!ret || offset > FTRACE_MCOUNT_MAX_OFFSET)
> +		return -1;

Unfortunately, I can't just skip printing these functions. The reason is
because it breaks trace-cmd (libtracefs specifically). As trace-cmd can
filter with full regular expressions (regex(3)), and does so by searching
the available_filter_functions. It collects an index of functions to
enabled, then passes that into set_ftrace_filter.

As a speed up, set_ftrace_filter allows you to pass an index, defined by the
line in available_filter_functions, into it that uses array indexing into
the ftrace table to enable/disable functions for tracing. By skipping
entries, it breaks the indexing, because the index is a 1 to 1 paring of
the lines of available_filter_functions.

To solve this, instead of printing nothing, I have this:

	ret = kallsyms_lookup(ip, NULL, &offset, &modname, str);
	/* Weak functions can cause invalid addresses */
	if (!ret || offset > FTRACE_MCOUNT_MAX_OFFSET) {
		snprintf(str, KSYM_SYMBOL_LEN, "%s_%ld",
			 FTRACE_INVALID_FUNCTION, offset);
	}

Where:

#define FTRACE_INVALID_FUNCTION		"__ftrace_invalid_address__"

When doing this, the available_filter_functions file has 546 invalid
entries. 14 of which are for the kvm module. Probably to deal with the
differences between Intel and AMD.

When a function is read as invalid, the rec->flags get set as DISABLED,
which will keep it from being enabled in the future.

Of course, one can just enter in numbers without reading any of the files,
and that will allow them to be set. It won't do anything bad, it would just
act like it does today.

Does anyone have any issues with this approach (with
__ftrace_invalid_address__%d inserted into available_filter_functions)?


-- Steve


> +
> +	seq_puts(m, str);
> +	if (modname)
> +		seq_printf(m, " [%s]", modname);
> +	return 0;
> +}
> +#else
> +static int print_rec(struct seq_file *m, unsigned long ip)
> +{
> +	seq_printf(m, "%ps", (void *)ip);
> +	return 0;
> +}
> +#endif
> +
