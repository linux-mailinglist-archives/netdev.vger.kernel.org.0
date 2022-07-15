Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFE35767E9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiGOUAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiGOT77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:59:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AB477496;
        Fri, 15 Jul 2022 12:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 025676122A;
        Fri, 15 Jul 2022 19:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A87C341C0;
        Fri, 15 Jul 2022 19:59:54 +0000 (UTC)
Date:   Fri, 15 Jul 2022 15:59:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/5] ftrace: introduce
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220715155953.4fb692e2@gandalf.local.home>
In-Reply-To: <0EB34157-8BCA-47FC-B78F-AA8FE45A1707@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-4-song@kernel.org>
        <20220713203343.4997eb71@rorschach.local.home>
        <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
        <20220714204817.2889e280@rorschach.local.home>
        <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
        <20220714224646.62d49e36@rorschach.local.home>
        <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
        <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
        <20220715151217.141dc98f@gandalf.local.home>
        <0EB34157-8BCA-47FC-B78F-AA8FE45A1707@fb.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 19:49:00 +0000
Song Liu <songliubraving@fb.com> wrote:

> > 
> > What about if we release the lock when doing the callback?  
> 
> We can probably unlock ftrace_lock here. But we may break locking order 
> with direct mutex (see below).

You're talking about the multi registering case, right?

> 
> > 
> > Then we just need to make sure things are the same after reacquiring the
> > lock, and if they are different, we release the lock again and do the
> > callback with the new update. Wash, rinse, repeat, until the state is the
> > same before and after the callback with locks acquired?  
> 
> Personally, I would like to avoid wash-rinse-repeat here.

But it's common to do. Keeps your hair cleaner that way ;-)

> 
> > 
> > This is a common way to handle callbacks that need to do something that
> > takes the lock held before doing a callback.
> > 
> > The reason I say this, is because the more we can keep the accounting
> > inside of ftrace the better.
> > 
> > Wouldn't this need to be done anyway if BPF was first and live kernel
> > patching needed the update? An -EAGAIN would not suffice.  
> 
> prepare_direct_functions_for_ipmodify handles BPF-first-livepatch-later
> case. The benefit of prepare_direct_functions_for_ipmodify() is that it 
> holds direct_mutex before ftrace_lock, and keeps holding it if necessary. 
> This is enough to make sure we don't need the wash-rinse-repeat. 
> 
> OTOH, if we wait until __ftrace_hash_update_ipmodify(), we already hold
> ftrace_lock, but not direct_mutex. To make changes to bpf trampoline, we
> have to unlock ftrace_lock and lock direct_mutex to avoid deadlock. 
> However, this means we will need the wash-rinse-repeat. 
> 
> 
> For livepatch-first-BPF-later case, we can probably handle this in 
> __ftrace_hash_update_ipmodify(), since we hold both direct_mutex and 
> ftrace_lock. We can unlock ftrace_lock and update the BPF trampoline. 
> It is safe against changes to direct ops, because we are still holding 
> direct_mutex. But, is this safe against another IPMODIFY ops? I am not 
> sure yet... Also, this is pretty weird because, we are updating a 
> direct trampoline before we finish registering it for the first time. 
> IOW, we are calling modify_ftrace_direct_multi_nolock for the same 
> trampoline before register_ftrace_direct_multi() returns.
> 
> The approach in v2 propagates the -EAGAIN to BPF side, so these are two
> independent calls of register_ftrace_direct_multi(). This does require
> some protocol between ftrace core and its user, but I still think this 
> is a cleaner approach. 

The issue I have with this approach is it couples BPF and ftrace a bit too
much.

But there is a way with my approach you can still do your approach. That
is, have ops_func() return zero if everything is fine, and otherwise returns
a negative value. Then have the register function fail and return whatever
value that gets returned by the ops_func()

Then have the bpf ops_func() check (does this direct caller handle
IPMODIFY? if yes, return 0, else return -EAGAIN). Then the registering of
ftrace fails with your -EAGAIN, and then you can change the direct
trampoline to handle IPMODIFY and try again. This time when ops_func() is
called, it sees that the direct trampoline can handle the IPMODIFY and
returns 0.

Basically, it's a way to still implement my suggestion, but let BPF decide
to use -EAGAIN to try again. And then BPF and ftrace don't need to have
these special flags to change the behavior of each other.

-- Steve
