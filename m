Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7332654FAF7
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383107AbiFQQTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiFQQTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:19:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E3B31227;
        Fri, 17 Jun 2022 09:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACEFEB82B10;
        Fri, 17 Jun 2022 16:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D069C3411B;
        Fri, 17 Jun 2022 16:19:36 +0000 (UTC)
Date:   Fri, 17 Jun 2022 12:19:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 2/2] rethook: Reject getting a rethook if RCU is
 not watching
Message-ID: <20220617121934.71bc8752@gandalf.local.home>
In-Reply-To: <165461827269.280167.7379263615545598958.stgit@devnote2>
References: <165461825202.280167.12903689442217921817.stgit@devnote2>
        <165461827269.280167.7379263615545598958.stgit@devnote2>
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

On Wed,  8 Jun 2022 01:11:12 +0900
"Masami Hiramatsu (Google)" <mhiramat@kernel.org> wrote:

> From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> Since the rethook_recycle() will involve the call_rcu() for reclaiming
> the rethook_instance, the rethook must be set up at the RCU available
> context (non idle). This rethook_recycle() in the rethook trampoline
> handler is inevitable, thus the RCU available check must be done before
> setting the rethook trampoline.
> 
> This adds a rcu_is_watching() check in the rethook_try_get() so that
> it will return NULL if it is called when !rcu_is_watching().
> 
> Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> ---
>  kernel/trace/rethook.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> index b56833700d23..c69d82273ce7 100644
> --- a/kernel/trace/rethook.c
> +++ b/kernel/trace/rethook.c
> @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
>  	if (unlikely(!handler))
>  		return NULL;
>  
> +	/*
> +	 * This expects the caller will set up a rethook on a function entry.
> +	 * When the function returns, the rethook will eventually be reclaimed
> +	 * or released in the rethook_recycle() with call_rcu().
> +	 * This means the caller must be run in the RCU-availabe context.
> +	 */
> +	if (unlikely(!rcu_is_watching()))
> +		return NULL;

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

> +
>  	fn = freelist_try_get(&rh->pool);
>  	if (!fn)
>  		return NULL;

