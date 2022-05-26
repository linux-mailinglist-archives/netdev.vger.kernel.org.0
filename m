Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECB05351E2
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348118AbiEZQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 12:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiEZQOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 12:14:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF6169B72;
        Thu, 26 May 2022 09:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02E2CB82116;
        Thu, 26 May 2022 16:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B55C385A9;
        Thu, 26 May 2022 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653581678;
        bh=BEu8FzeHozipT80VRZydXI3h7OCtUf6qqnj3rnbJsss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h6QqxykjCTfxmQ8S7G1J1DIbzLZ8SGvgK05PfCUuCSO36BsCGHJ9FV/F9dMEwzto9
         8u0P/od/8hswj0uVUbquDcqlBCPYvFafoRM5BDRTc25w29g/lYMMLmcKV/3kQb0wuF
         bilIIberizrJIX3eh1O+aGuMgGG+PnfwyFk5N7+fck6XZYSvgStQfQqxnAIj6Qymdi
         NQtS2Bse7+U+6LcJ4gznxFDAVAGbPUEM47tyC/jFXRAjQtjKg6YcwSOXRrVLiwywcp
         EnXjRVzfE0qTh3IhaMO6kTc+9ZMkphQNFDc9ovd62fAGU4WA1RKhQmwodkditFNxpI
         WE9d89Noip/2A==
Date:   Fri, 27 May 2022 01:14:34 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] rethook: Reject getting a rethook if RCU is not
 watching
Message-Id: <20220527011434.9e8c47d1b40f549baf2cf52a@kernel.org>
In-Reply-To: <Yo+TWcfpyHy55Il5@krava>
References: <165189881197.175864.14757002789194211860.stgit@devnote2>
        <20220524192301.0c2ab08a@gandalf.local.home>
        <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
        <Yo+TWcfpyHy55Il5@krava>
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

On Thu, 26 May 2022 16:49:26 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> On Thu, May 26, 2022 at 11:25:30PM +0900, Masami Hiramatsu wrote:
> > On Tue, 24 May 2022 19:23:01 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Sat,  7 May 2022 13:46:52 +0900
> > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > 
> > > Is this expected to go through the BPF tree?
> > > 
> > 
> > Yes, since rethook (fprobe) is currently used only from eBPF.
> > Jiri, can you check this is good for your test case?
> 
> sure I'll test it.. can't see the original email,
> perhaps I wasn't cc-ed.. but I'll find it

Here it is. I Cc-ed your @kernel.org address.
https://lore.kernel.org/all/165189881197.175864.14757002789194211860.stgit@devnote2/T/#u

> 
> is this also related to tracing 'idle' functions,
> as discussed in here?
>   https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/

Ah, yes. So this may not happen with the above patch, but for the
hardening (ensuring it is always safe), I would like to add this.

> 
> because that's the one I can reproduce.. but I can
> certainly try that with your change as well

Thank you!

> 
> jirka
> 
> > 
> > Thank you,
> > 
> > 
> > > -- Steve
> > > 
> > > 
> > > > Since the rethook_recycle() will involve the call_rcu() for reclaiming
> > > > the rethook_instance, the rethook must be set up at the RCU available
> > > > context (non idle). This rethook_recycle() in the rethook trampoline
> > > > handler is inevitable, thus the RCU available check must be done before
> > > > setting the rethook trampoline.
> > > > 
> > > > This adds a rcu_is_watching() check in the rethook_try_get() so that
> > > > it will return NULL if it is called when !rcu_is_watching().
> > > > 
> > > > Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> > > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > > ---
> > > >  kernel/trace/rethook.c |    9 +++++++++
> > > >  1 file changed, 9 insertions(+)
> > > > 
> > > > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > > > index b56833700d23..c69d82273ce7 100644
> > > > --- a/kernel/trace/rethook.c
> > > > +++ b/kernel/trace/rethook.c
> > > > @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
> > > >  	if (unlikely(!handler))
> > > >  		return NULL;
> > > >  
> > > > +	/*
> > > > +	 * This expects the caller will set up a rethook on a function entry.
> > > > +	 * When the function returns, the rethook will eventually be reclaimed
> > > > +	 * or released in the rethook_recycle() with call_rcu().
> > > > +	 * This means the caller must be run in the RCU-availabe context.
> > > > +	 */
> > > > +	if (unlikely(!rcu_is_watching()))
> > > > +		return NULL;
> > > > +
> > > >  	fn = freelist_try_get(&rh->pool);
> > > >  	if (!fn)
> > > >  		return NULL;
> > > 
> > 
> > 
> > -- 
> > Masami Hiramatsu (Google) <mhiramat@kernel.org>


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
