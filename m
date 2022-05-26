Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A4C534FCD
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 15:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347469AbiEZNO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 09:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238800AbiEZNOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 09:14:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884DBD6828;
        Thu, 26 May 2022 06:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E33E961AB2;
        Thu, 26 May 2022 13:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF54C385B8;
        Thu, 26 May 2022 13:14:41 +0000 (UTC)
Date:   Thu, 26 May 2022 09:14:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20220526091440.7c40a577@gandalf.local.home>
In-Reply-To: <20220526073949.GL2578@worktop.programming.kicks-ass.net>
References: <20220525180553.419eac77@gandalf.local.home>
        <20220526073949.GL2578@worktop.programming.kicks-ass.net>
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

On Thu, 26 May 2022 09:39:49 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
> > to zero, which will have ftrace ignore all locations that are not at the
> > start of the function.  
> 
> ^^^ that paragraph is obsolete by your own changes thing below :-)

Well, it is partially correct (if X86_KERNEL_IBT is disabled).

I'll update the change log to reflect the update.

> 
> > [1] https://lore.kernel.org/all/20220412094923.0abe90955e5db486b7bca279@kernel.org/
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> > Changes since v1: https://lore.kernel.org/all/20220503150410.2d9e88aa@rorschach.local.home/
> > 
> >  - Changed MAX_OFFSET to 4 on x86 if KERNEL_IBT is enabled
> >    (Reminded by Peter Zijlstra)
> > 
> >  arch/x86/include/asm/ftrace.h | 10 +++++++
> >  kernel/trace/ftrace.c         | 50 +++++++++++++++++++++++++++++++++--
> >  2 files changed, 58 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index 024d9797646e..53675fe2d847 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -9,6 +9,16 @@
> >  # define MCOUNT_ADDR		((unsigned long)(__fentry__))
> >  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
> >  
> > +/* Ignore unused weak functions which will have non zero offsets */
> > +#ifdef CONFIG_HAVE_FENTRY
> > +# ifdef CONFIG_X86_KERNEL_IBT
> > +/* endbr64 is 4 bytes in front of the fentry */
> > +#  define FTRACE_MCOUNT_MAX_OFFSET	4
> > +# else
> > +#  define FTRACE_MCOUNT_MAX_OFFSET	0
> > +# endif
> > +#endif  
> 
> #define FTRACE_MCOUNT_MAX_OFFSET ENDBR_INSN_SIZE
> 
> Should do the same I think, less lines etc..

Thanks, I figured there was something else I could use besides hard coding
it. But I may add that as a separate patch after this gets merged, because
my branch doesn't have that code in it yet, so it wont compile.

-- Steve
