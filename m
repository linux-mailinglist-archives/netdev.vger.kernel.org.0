Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC5574F14
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbiGNNXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239760AbiGNNWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:22:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0840C61D5E;
        Thu, 14 Jul 2022 06:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D8362063;
        Thu, 14 Jul 2022 13:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF2C34114;
        Thu, 14 Jul 2022 13:22:17 +0000 (UTC)
Date:   Thu, 14 Jul 2022 09:22:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/5] ftrace: allow customized flags for
 ftrace_direct_multi ftrace_ops
Message-ID: <20220714092215.149d4823@gandalf.local.home>
In-Reply-To: <BDED3B27-B42F-44AD-904E-010752462A67@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-2-song@kernel.org>
        <20220713191846.18b05b43@gandalf.local.home>
        <0029EF24-6508-4011-B365-3E2175F9FEAB@fb.com>
        <20220713203841.76d66245@rorschach.local.home>
        <C2FCCC9B-5F7D-4BBF-8410-67EA79166909@fb.com>
        <20220713225511.70d03fc6@gandalf.local.home>
        <BDED3B27-B42F-44AD-904E-010752462A67@fb.com>
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

On Thu, 14 Jul 2022 04:37:43 +0000
Song Liu <songliubraving@fb.com> wrote:

> >   
> >> 
> >> non-direct ops without IPMODIFY can already share with IPMODIFY ops.  
> > 
> > It can? ftrace sets IPMODIFY for all DIRECT callers to prevent that. Except
> > for this patch that removes that restriction (which I believe is broken).  
> 
> I mean "non-direct" ftrace ops, not direct ftrace ops. 

Ah, sorry misunderstood that.


> > Let me start from the beginning.  
> 
> I got your point now. We replace the flag on direct trampoline with a 
> callback check. So yes, this works. 

I'm glad we are on the same page :-)


> > 9. ftrace sees the lkp IPMODIFY ops has SHARED_IPMODIFY on it, and knows
> >   that there's a direct call here too. It removes the IPMODIFY ops, and
> >   then calls the direct ops->ops_func(STOP_SHARE_WITH_IPMODIFY) to let the
> >   direct code know that it is no longer sharing with an IPMODIFY such that
> >   it can change to call the function directly and not use the stack.  
> 
> I wonder whether we still need this flag. Alternatively, we can always
> find direct calls on the function and calls ops_func(STOP_SHARE_WITH_IPMODIFY). 

Actually we don't need the new flag and we don't need to always search. When
a direct is attached to the function then the rec->flags will have
FTRACE_FL_DIRECT attached to it.

Then if an IPMODIFY is being removed and the rec->flags has
FTRACE_FL_DIRECT set, then we know to search the ops for the one that has a
DIRECT flag attached and we can call the ops_func() on that one.

We should also add a FTRACE_WARN_ON() if a direct is not found but the flag
was set.

> 
> What do you think about this? 
>

I think this works.

Also, on the patch that implements this in the next version, please add to
the change log:

Link: https://lore.kernel.org/all/20220602193706.2607681-2-song@kernel.org/

so that we have a link to this discussion.

Thanks,

-- Steve
