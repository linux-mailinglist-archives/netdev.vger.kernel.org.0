Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE5056949D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiGFVk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiGFVk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:40:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6B827FDC;
        Wed,  6 Jul 2022 14:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29EEC6219C;
        Wed,  6 Jul 2022 21:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5196BC3411C;
        Wed,  6 Jul 2022 21:40:51 +0000 (UTC)
Date:   Wed, 6 Jul 2022 17:40:49 -0400
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
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Message-ID: <20220706174049.6c60250f@gandalf.local.home>
In-Reply-To: <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220602193706.2607681-6-song@kernel.org>
        <20220706153843.37584b5b@gandalf.local.home>
        <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
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

On Wed, 6 Jul 2022 21:37:52 +0000
Song Liu <songliubraving@fb.com> wrote:

> > Can you comment here that returning -EAGAIN will not cause this to repeat.
> > That it will change things where the next try will not return -EGAIN?  
> 
> Hmm.. this is not the guarantee here. This conflict is a real race condition 
> that an IPMODIFY function (i.e. livepatch) is being registered at the same time 
> when something else, for example bpftrace, is updating the BPF trampoline. 
> 
> This EAGAIN will propagate to the user of the IPMODIFY function (i.e. livepatch),
> and we need to retry there. In the case of livepatch, the retry is initiated 
> from user space. 

We need to be careful here then. If there's a userspace application that
runs at real-time and does a:

	do {
		errno = 0;
		regsiter_bpf();
	} while (errno != -EAGAIN);

it could in theory preempt the owner of the lock and never make any
progress.

-- Steve
