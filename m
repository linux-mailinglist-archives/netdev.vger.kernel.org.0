Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F9853508C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347621AbiEZOZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345679AbiEZOZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:25:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81890C5E51;
        Thu, 26 May 2022 07:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A34A61B48;
        Thu, 26 May 2022 14:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712A6C385A9;
        Thu, 26 May 2022 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653575135;
        bh=W7tj7X0phM9ahD0Hf4v7nQNVq951iFKg/FrRScsgPRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UFtiGo1CsYcwPCr5EjO22WjzXTWu8He/a5sTNyplgujEvmhS6TEno7+MAFntwxf+F
         itS4A/xIo7ZQnFuhzKFkuDq4rUIZkVzVBpMr7TH9OHanx/L7suCr5f0HF9wZkqpxnc
         VJm8Zs2klYzxdZX7+v5iI2/6MGghSp+kxNKeNHOwujidM0BI4LF+CflqQJOIVQDCSL
         lvKNBsa2FsulTUGaVN+EHgcuShXAtpyJ/CMseKxxDJuxdVYC2HaHgEGEfpFCytRRbQ
         3WFy9+yYlO2OzaSULl8QS7vakz+CR8jeY7SKlgAXquh64N09d91nZgG0xp8tIXGwQz
         6F7Q1B9LbElyg==
Date:   Thu, 26 May 2022 23:25:30 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] rethook: Reject getting a rethook if RCU is not
 watching
Message-Id: <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
In-Reply-To: <20220524192301.0c2ab08a@gandalf.local.home>
References: <165189881197.175864.14757002789194211860.stgit@devnote2>
        <20220524192301.0c2ab08a@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 19:23:01 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat,  7 May 2022 13:46:52 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> Is this expected to go through the BPF tree?
> 

Yes, since rethook (fprobe) is currently used only from eBPF.
Jiri, can you check this is good for your test case?

Thank you,


> -- Steve
> 
> 
> > Since the rethook_recycle() will involve the call_rcu() for reclaiming
> > the rethook_instance, the rethook must be set up at the RCU available
> > context (non idle). This rethook_recycle() in the rethook trampoline
> > handler is inevitable, thus the RCU available check must be done before
> > setting the rethook trampoline.
> > 
> > This adds a rcu_is_watching() check in the rethook_try_get() so that
> > it will return NULL if it is called when !rcu_is_watching().
> > 
> > Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > ---
> >  kernel/trace/rethook.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > index b56833700d23..c69d82273ce7 100644
> > --- a/kernel/trace/rethook.c
> > +++ b/kernel/trace/rethook.c
> > @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
> >  	if (unlikely(!handler))
> >  		return NULL;
> >  
> > +	/*
> > +	 * This expects the caller will set up a rethook on a function entry.
> > +	 * When the function returns, the rethook will eventually be reclaimed
> > +	 * or released in the rethook_recycle() with call_rcu().
> > +	 * This means the caller must be run in the RCU-availabe context.
> > +	 */
> > +	if (unlikely(!rcu_is_watching()))
> > +		return NULL;
> > +
> >  	fn = freelist_try_get(&rh->pool);
> >  	if (!fn)
> >  		return NULL;
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
