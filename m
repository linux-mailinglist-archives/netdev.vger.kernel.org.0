Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5997F576734
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiGOTMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGOTMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:12:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECC040BF7;
        Fri, 15 Jul 2022 12:12:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E7EBB82E16;
        Fri, 15 Jul 2022 19:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CBCC34115;
        Fri, 15 Jul 2022 19:12:19 +0000 (UTC)
Date:   Fri, 15 Jul 2022 15:12:17 -0400
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
Message-ID: <20220715151217.141dc98f@gandalf.local.home>
In-Reply-To: <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-4-song@kernel.org>
        <20220713203343.4997eb71@rorschach.local.home>
        <AA1D9833-DF67-4AFD-815C-DD89AB57B3A2@fb.com>
        <20220714204817.2889e280@rorschach.local.home>
        <6A7EF1C7-471B-4652-99C1-87C72C223C59@fb.com>
        <20220714224646.62d49e36@rorschach.local.home>
        <170BE89A-101C-4B25-A664-5E47A902DB83@fb.com>
        <0CE9BF90-B8CE-40F6-A431-459936157B78@fb.com>
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

On Fri, 15 Jul 2022 17:42:55 +0000
Song Liu <songliubraving@fb.com> wrote:


> A quick update and ask for feedback/clarification.
> 
> Based on my understanding, you recommended calling ops_func() from 
> __ftrace_hash_update_ipmodify() and in ops_func() the direct trampoline
> may make changes to the trampoline. Did I get this right?
> 
> 
> I am going towards this direction, but hit some issue. Specifically, in 
> __ftrace_hash_update_ipmodify(), ftrace_lock is already locked, so the 
> direct trampoline cannot easily make changes with 
> modify_ftrace_direct_multi(), which locks both direct_mutex and 
> ftrace_mutex. 
> 
> One solution would be have no-lock version of all the functions called
> by modify_ftrace_direct_multi(), but that's a lot of functions and the
> code will be pretty ugly. The alternative would be the logic in v2: 
> __ftrace_hash_update_ipmodify() returns -EAGAIN, and we make changes to 
> the direct trampoline in other places: 
> 
> 1) if DIRECT ops attached first, the trampoline is updated in 
>    prepare_direct_functions_for_ipmodify(), see 3/5 of v2;
> 
> 2) if IPMODIFY ops attached first, the trampoline is updated in
>    bpf_trampoline_update(), see "goto again" path in 5/5 of v2. 
> 
> Overall, I think this way is still cleaner. What do you think about this?

What about if we release the lock when doing the callback?

Then we just need to make sure things are the same after reacquiring the
lock, and if they are different, we release the lock again and do the
callback with the new update. Wash, rinse, repeat, until the state is the
same before and after the callback with locks acquired?

This is a common way to handle callbacks that need to do something that
takes the lock held before doing a callback.

The reason I say this, is because the more we can keep the accounting
inside of ftrace the better.

Wouldn't this need to be done anyway if BPF was first and live kernel
patching needed the update? An -EAGAIN would not suffice.

-- Steve
