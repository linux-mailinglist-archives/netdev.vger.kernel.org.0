Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB5A536D1F
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 15:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiE1Naj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 09:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiE1Nah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 09:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A513E1A80A;
        Sat, 28 May 2022 06:30:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AAFA60EE3;
        Sat, 28 May 2022 13:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38DBC34100;
        Sat, 28 May 2022 13:30:33 +0000 (UTC)
Date:   Sat, 28 May 2022 09:30:32 -0400
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
Subject: Re: [PATCH v6] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220528093032.6d2f4147@gandalf.local.home>
In-Reply-To: <20220527234003.2719e6c6@gandalf.local.home>
References: <20220527234003.2719e6c6@gandalf.local.home>
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

On Fri, 27 May 2022 23:40:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> @@ -6830,6 +6960,10 @@ void ftrace_module_enable(struct module *mod)
>  		if (ftrace_start_up)
>  			cnt += referenced_filters(rec);
>  
> +		/* Weak functions should still be ignored */
> +		if (!test_for_valid_rec(rec))
> +			continue;

This also needs to clear the other flags.

As this is for module load, it does a two stage setup. That is to make the
correct state of the ftrace locations in the module. As the updates to NOP
is done before the text is set to RO, and if tracing is enabled/disabled
during this time, it will trigger a BUG as it detects executable code
running in RW text. To solve that, the initial setting of the records of
the module is done with the DISABLE flag set, so they are ignored by the
enabling and disabling of ftrace. All the module ftrace locations are set to
NOP.

This function is called after the text is set to ro and we enable the
module functions based on the flags set. But if we are ignoring the record
(as kvm has weak functions), we need to not only skip the setting of the
code, but need to clear the flags to state they are not set. Otherwise it
screws up the accounting of ftrace, and ftrace will WARN and disable itself.

-- Steve




> +
>  		rec->flags &= ~FTRACE_FL_DISABLED;
>  		rec->flags += cnt;
>  

