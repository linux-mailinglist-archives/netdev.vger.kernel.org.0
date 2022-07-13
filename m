Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB7573FFB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiGMXSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGMXSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:18:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75929FD0;
        Wed, 13 Jul 2022 16:18:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D05EB821FB;
        Wed, 13 Jul 2022 23:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2634C3411E;
        Wed, 13 Jul 2022 23:18:47 +0000 (UTC)
Date:   Wed, 13 Jul 2022 19:18:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kernel-team@fb.com>,
        <jolsa@kernel.org>, <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Message-ID: <20220713191846.18b05b43@gandalf.local.home>
In-Reply-To: <20220602193706.2607681-2-song@kernel.org>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-2-song@kernel.org>
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

On Thu, 2 Jun 2022 12:37:02 -0700
Song Liu <song@kernel.org> wrote:

> This enables users of ftrace_direct_multi to specify the flags based on
> the actual use case. For example, some users may not set flag IPMODIFY.

If we apply this patch without any of the others, then we are relying on
the caller to get it right?

That is, can we register a direct function with this function and pick a
function with IPMODIFY already attached?

-- Steve


> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/trace/ftrace.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 2fcd17857ff6..afe782ae28d3 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5456,8 +5456,7 @@ int modify_ftrace_direct(unsigned long ip,
>  }
>  EXPORT_SYMBOL_GPL(modify_ftrace_direct);
>  
> -#define MULTI_FLAGS (FTRACE_OPS_FL_IPMODIFY | FTRACE_OPS_FL_DIRECT | \
> -		     FTRACE_OPS_FL_SAVE_REGS)
> +#define MULTI_FLAGS (FTRACE_OPS_FL_DIRECT | FTRACE_OPS_FL_SAVE_REGS)
>  
>  static int check_direct_multi(struct ftrace_ops *ops)
>  {
> @@ -5547,7 +5546,7 @@ int register_ftrace_direct_multi(struct ftrace_ops *ops, unsigned long addr)
>  	}
>  
>  	ops->func = call_direct_funcs;
> -	ops->flags = MULTI_FLAGS;
> +	ops->flags |= MULTI_FLAGS;
>  	ops->trampoline = FTRACE_REGS_ADDR;
>  
>  	err = register_ftrace_function(ops);

