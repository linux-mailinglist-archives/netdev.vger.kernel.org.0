Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE054FACC
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382946AbiFQQG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiFQQG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:06:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39905186F5;
        Fri, 17 Jun 2022 09:06:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC7A5B82998;
        Fri, 17 Jun 2022 16:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD825C3411B;
        Fri, 17 Jun 2022 16:06:52 +0000 (UTC)
Date:   Fri, 17 Jun 2022 12:06:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/2] fprobe: samples: Add use_trace option and
 show hit/missed counter
Message-ID: <20220617120651.1e525a02@gandalf.local.home>
In-Reply-To: <165461826247.280167.11939123218334322352.stgit@devnote2>
References: <165461825202.280167.12903689442217921817.stgit@devnote2>
        <165461826247.280167.11939123218334322352.stgit@devnote2>
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

On Wed,  8 Jun 2022 01:11:02 +0900
"Masami Hiramatsu (Google)" <mhiramat@kernel.org> wrote:

>  
>  static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
>  {
> -	pr_info("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
> +	if (use_trace)
> +		trace_printk("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);

Could we add a comment stating something like "this is just an example, no
kernel code should call trace_printk() except when actively debugging".

-- Steve


> +	else
> +		pr_info("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
> +	nhit++;
>  	if (stackdump)
>  		show_backtrace();
>  }
> @@ -49,8 +56,13 @@ static void sample_exit_handler(struct fprobe *fp, unsigned long ip, struct pt_r
>  {
>  	unsigned long rip = instruction_pointer(regs);
>  
> -	pr_info("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
> -		(void *)ip, (void *)ip, (void *)rip, (void *)rip);
> +	if (use_trace)
> +		trace_printk("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
> +			(void *)ip, (void *)ip, (void *)rip, (void *)rip);
> +	else
> +		pr_info("Return from <%pS> ip = 0x%p to rip = 0x%p (%pS)\n",
> +			(void *)ip, (void *)ip, (void *)rip, (void *)rip);
> +	nhit++;
>  	if (stackdump)
>  		show_backtrace();
