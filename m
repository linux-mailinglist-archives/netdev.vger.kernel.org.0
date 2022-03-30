Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F844EB7E5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbiC3BnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiC3BnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:43:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF668181153;
        Tue, 29 Mar 2022 18:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98011B818FD;
        Wed, 30 Mar 2022 01:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FD5C340ED;
        Wed, 30 Mar 2022 01:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648604485;
        bh=E+W75rEfjNola5byciTV+3Zona1ftqK2IdkEei5+nXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E/+wgWROFKb15gcv5EinHlqBrufUg4aODterIGcfckL5wS/OpfEyJQrQtNnbZWTZl
         HQagsK86eEDTjAL4J0E2FTv8IpeapXjBcH1GePKz9ea32MR7ss4ZoyycyXqSoa9hpM
         67+3xwqeGjLSpd0su2xs2ehMMJH+VNn1CN2wPaS3a/8CN/ZUTbDa05HhRS84nzwSA3
         DsfG/U9kEz8CseFBbV8H4zqGmSXD0d69vu+vBiyPb61pQqRLoEennW6pYEXoDlPDR/
         98CoA6wMIsK2EpoUhTX/TVSYhTYt1Oq+wm86qGcI7kShuL0deL7s5Aj3jE1WA5YA0k
         7HNcdVuNAQHnA==
Date:   Tue, 29 Mar 2022 18:41:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, peterz@infradead.org,
        mhiramat@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf 2022-03-29
Message-ID: <20220329184123.59cfad63@kernel.org>
In-Reply-To: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 16 non-merge commits during the last 1 day(s) which contain
> a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> 
> The main changes are:
> 
> 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> 
> 2) ice/xsk fixes, from Maciej and Magnus.
> 
> 3) Various small fixes, from Andrii, Yonghong, Geliang and others.

There are some new sparse warnings here that look semi-legit.
As in harmless but not erroneous.

kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
kernel/trace/rethook.c:68:9:    void ( * )( ... )

66 void rethook_free(struct rethook *rh)
67 {
68         rcu_assign_pointer(rh->handler, NULL);
69 
70         call_rcu(&rh->rcu, rethook_free_rcu);
71 }

Looks like this should be a WRITE_ONCE() ?

And the __user annotations in bpf_trace.c are still not right,
first arg of kprobe_multi_resolve_syms() should __user:

kernel/trace/bpf_trace.c:2370:34: warning: incorrect type in argument 2 (different address spaces)
kernel/trace/bpf_trace.c:2370:34:    expected void const [noderef] __user *from
kernel/trace/bpf_trace.c:2370:34:    got void const *usyms
kernel/trace/bpf_trace.c:2376:51: warning: incorrect type in argument 2 (different address spaces)
kernel/trace/bpf_trace.c:2376:51:    expected char const [noderef] __user *src
kernel/trace/bpf_trace.c:2376:51:    got char const *
kernel/trace/bpf_trace.c:2443:49: warning: incorrect type in argument 1 (different address spaces)
kernel/trace/bpf_trace.c:2443:49:    expected void const *usyms
kernel/trace/bpf_trace.c:2443:49:    got void [noderef] __user *[assigned] usyms

How do you wanna proceed?
