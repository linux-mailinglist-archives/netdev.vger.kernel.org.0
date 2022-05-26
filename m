Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672B2534AEE
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346444AbiEZHkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344295AbiEZHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:40:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6C69CC98;
        Thu, 26 May 2022 00:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CQYB5ThBtWWWuBvkE8q2MyBazTowOjB+4l1o9Cu5nTw=; b=SVwIeurYxcY7RzY6Z46nHHqe5f
        +rD8OWEXpV+jeanc9GyIyj4MDC6Y/4ERvos6N4ojEXgH/66BnWF77D/QDDgBkEhKqaY4TmL6RDZgT
        2UwU8QuO14Ue2mrEh4Dnaim6lBhr+Za4LDbqBhRFeusToAbiavifZmatefDSQ6T7nYdNsiS6ngyRR
        ObTN5Otg9UhD5r2mEy/Nu9JpphM4XuC2xGEEc8o2H3yunqcm/MjpHAFsf0xlfxqX4e0SYviAVU3UX
        uNJwxKhIzqg4WwGBqX0aJ1luPxP2EPgwUnHE0O4aI9oRDX8keWphaxWk8snut4dy/UZcu1vexgCjJ
        Y4zBwO/Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nu863-001qTC-Nw; Thu, 26 May 2022 07:39:52 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 83AC8980E04; Thu, 26 May 2022 09:39:49 +0200 (CEST)
Date:   Thu, 26 May 2022 09:39:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
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
        KP Singh <kpsingh@chromium.org>, x86@kernel.org
Subject: Re: [PATCH v2] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220526073949.GL2578@worktop.programming.kicks-ass.net>
References: <20220525180553.419eac77@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525180553.419eac77@gandalf.local.home>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 06:05:53PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> If an unused weak function was traced, it's call to fentry will still
> exist, which gets added into the __mcount_loc table. Ftrace will use
> kallsyms to retrieve the name for each location in __mcount_loc to display
> it in the available_filter_functions and used to enable functions via the
> name matching in set_ftrace_filter/notrace. Enabling these functions do
> nothing but enable an unused call to ftrace_caller. If a traced weak
> function is overridden, the symbol of the function would be used for it,
> which will either created duplicate names, or if the previous function was
> not traced, it would be incorrectly listed in available_filter_functions
> as a function that can be traced.
> 
> This became an issue with BPF[1] as there are tooling that enables the
> direct callers via ftrace but then checks to see if the functions were
> actually enabled. The case of one function that was marked notrace, but
> was followed by an unused weak function that was traced. The unused
> function's call to fentry was added to the __mcount_loc section, and
> kallsyms retrieved the untraced function's symbol as the weak function was
> overridden. Since the untraced function would not get traced, the BPF
> check would detect this and fail.
> 
> The real fix would be to fix kallsyms to not show address of weak
> functions as the function before it. But that would require adding code in
> the build to add function size to kallsyms so that it can know when the
> function ends instead of just using the start of the next known symbol.
> 
> In the mean time, this is a work around. Add a FTRACE_MCOUNT_MAX_OFFSET
> macro that if defined, ftrace will ignore any function that has its call
> to fentry/mcount that has an offset from the symbol that is greater than
> FTRACE_MCOUNT_MAX_OFFSET.
> 
> If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
> to zero, which will have ftrace ignore all locations that are not at the
> start of the function.

^^^ that paragraph is obsolete by your own changes thing below :-)

> [1] https://lore.kernel.org/all/20220412094923.0abe90955e5db486b7bca279@kernel.org/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> Changes since v1: https://lore.kernel.org/all/20220503150410.2d9e88aa@rorschach.local.home/
> 
>  - Changed MAX_OFFSET to 4 on x86 if KERNEL_IBT is enabled
>    (Reminded by Peter Zijlstra)
> 
>  arch/x86/include/asm/ftrace.h | 10 +++++++
>  kernel/trace/ftrace.c         | 50 +++++++++++++++++++++++++++++++++--
>  2 files changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index 024d9797646e..53675fe2d847 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -9,6 +9,16 @@
>  # define MCOUNT_ADDR		((unsigned long)(__fentry__))
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
>  
> +/* Ignore unused weak functions which will have non zero offsets */
> +#ifdef CONFIG_HAVE_FENTRY
> +# ifdef CONFIG_X86_KERNEL_IBT
> +/* endbr64 is 4 bytes in front of the fentry */
> +#  define FTRACE_MCOUNT_MAX_OFFSET	4
> +# else
> +#  define FTRACE_MCOUNT_MAX_OFFSET	0
> +# endif
> +#endif

#define FTRACE_MCOUNT_MAX_OFFSET ENDBR_INSN_SIZE

Should do the same I think, less lines etc..
