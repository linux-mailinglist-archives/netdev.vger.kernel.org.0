Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562E8570E73
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiGKX4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKX4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:56:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179592BB3F;
        Mon, 11 Jul 2022 16:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5041B8100E;
        Mon, 11 Jul 2022 23:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A9BC34115;
        Mon, 11 Jul 2022 23:55:54 +0000 (UTC)
Date:   Mon, 11 Jul 2022 19:55:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kernel-team@fb.com>,
        <jolsa@kernel.org>, <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 0/5] ftrace: host klp and bpf trampoline
 together
Message-ID: <20220711195552.22c3a4be@gandalf.local.home>
In-Reply-To: <20220602193706.2607681-1-song@kernel.org>
References: <20220602193706.2607681-1-song@kernel.org>
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

I just realized that none of the live kernel patching folks are Cc'd on
this thread. I think they will care much more about this than I do.

-- Steve


On Thu, 2 Jun 2022 12:37:01 -0700
Song Liu <song@kernel.org> wrote:

> Changes v1 => v2:
> 1. Fix build errors for different config. (kernel test robot)
> 
> Kernel Live Patch (livepatch, or klp) and bpf trampoline are important
> features for modern systems. This set allows the two to work on the same
> kernel function as the same time.
> 
> live patch uses ftrace with IPMODIFY, while bpf trampoline use direct
> ftrace. Existing policy does not allow the two to attach to the same kernel
> function. This is changed by fine tuning ftrace IPMODIFY policy, and allows
> one non-DIRECT IPMODIFY ftrace_ops and one non-IPMODIFY DIRECT ftrace_ops
> on the same kernel function at the same time. Please see 3/5 for more
> details on this.
> 
> Note that, one of the constraint here is to let bpf trampoline use direct
> call when it is not working on the same function as live patch. This is
> achieved by allowing ftrace code to ask bpf trampoline to make changes.
> 
> Jiri Olsa (1):
>   bpf, x64: Allow to use caller address from stack
> 
> Song Liu (4):
>   ftrace: allow customized flags for ftrace_direct_multi ftrace_ops
>   ftrace: add modify_ftrace_direct_multi_nolock
>   ftrace: introduce FTRACE_OPS_FL_SHARE_IPMODIFY
>   bpf: trampoline: support FTRACE_OPS_FL_SHARE_IPMODIFY
> 
>  arch/x86/net/bpf_jit_comp.c |  13 +-
>  include/linux/bpf.h         |   8 ++
>  include/linux/ftrace.h      |  79 +++++++++++
>  kernel/bpf/trampoline.c     | 109 +++++++++++++--
>  kernel/trace/ftrace.c       | 269 +++++++++++++++++++++++++++++++-----
>  5 files changed, 424 insertions(+), 54 deletions(-)
> 
> --
> 2.30.2

