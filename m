Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A3A536A69
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 05:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbiE1DTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 23:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiE1DTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 23:19:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9F6517FD;
        Fri, 27 May 2022 20:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 137D660FBD;
        Sat, 28 May 2022 03:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1EBC34114;
        Sat, 28 May 2022 03:18:57 +0000 (UTC)
Date:   Fri, 27 May 2022 23:18:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v5] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220527231856.14000ed1@gandalf.local.home>
In-Reply-To: <20220527163205.421c7828@gandalf.local.home>
References: <20220527163205.421c7828@gandalf.local.home>
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

On Fri, 27 May 2022 16:32:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -4003,7 +4128,11 @@ ftrace_match_record(struct dyn_ftrace *rec, struct ftrace_glob *func_g,
>  	char str[KSYM_SYMBOL_LEN];
>  	char *modname;
>  
> -	kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
> +	if (lookup_ip(rec->ip, &modname, str)) {
> +		/* This should only happen when a rec is disabled */
> +		WARN_ON_ONCE(!(rec->flags & FTRACE_FL_DISABLED));

It appears that some of the start up tests can call this before the
workqueue sets it to DISABLED, so we need to not WARN_ON() here. :-/

-- Steve


> +		return 0;
> +	}
>  
