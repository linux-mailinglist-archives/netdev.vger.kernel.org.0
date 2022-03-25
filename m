Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A16B4E6C7A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 03:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357703AbiCYCXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 22:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356215AbiCYCXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 22:23:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020BAB18A6;
        Thu, 24 Mar 2022 19:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A044AB82791;
        Fri, 25 Mar 2022 02:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D69C340EC;
        Fri, 25 Mar 2022 02:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648174882;
        bh=ivwDZgSZMeE+PCD2dfQWcyXhfqsyEJsULXN7F5jCXB4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l51ZcZz9ljlEyNgyBD5vxxE4D9ZRrROq4aOSgrp4vBYdm/MQHEad82u6Bnclb5rEp
         NabDQwWGTjhU/aDreeEIiEjiQs8yKcJN/37LE8C80+Ug76RInv5zVn2KrQOnHcsKoQ
         RkK9qjRzs7IysejMyu6UVWqEEdRuWe/L/KwSg5sRIhjfxCPNf22fShTg/xwR//9IhO
         LVb2xEnJBDfP4mIz8MFTAVF/fpor8y11eb5nJs7JdPlI6vQH3l66OTlg7kBNgRIRPa
         m1ic5KqYkQI1uiNUnyEa+Lv+vFzUUErp2ltcoClbbQZmlXQfMBEhJd884BcqZWvl0L
         GyvWEXXjssxQA==
Date:   Fri, 25 Mar 2022 11:21:14 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v13 bpf-next 1/1] rethook: x86: Add rethook x86
 implementation
Message-Id: <20220325112114.4604291a58ee5b214ee334da@kernel.org>
In-Reply-To: <CAADnVQLfu+uDUmovM8sOJSnH=HGxMEtmjk4+nWsAR+Mdj2TTYg@mail.gmail.com>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
        <164800289923.1716332.9772144337267953560.stgit@devnote2>
        <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
        <20220323204119.1feac1af0a1d58b8e63acd5d@kernel.org>
        <CAADnVQLfu+uDUmovM8sOJSnH=HGxMEtmjk4+nWsAR+Mdj2TTYg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 19:03:43 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Mar 23, 2022 at 4:41 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Wed, 23 Mar 2022 09:05:26 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > On Wed, Mar 23, 2022 at 11:34:59AM +0900, Masami Hiramatsu wrote:
> > > > Add rethook for x86 implementation. Most of the code has been copied from
> > > > kretprobes on x86.
> > >
> > > Right; as said, I'm really unhappy with growing a carbon copy of this
> > > stuff instead of sharing. Can we *please* keep it a single instance?
> >
> > OK, then let me update the kprobe side too.
> >
> > > Them being basically indentical, it should be trivial to have
> > > CONFIG_KPROBE_ON_RETHOOK (or somesuch) and just share this.
> >
> > Yes, ideally it should use CONFIG_HAVE_RETHOOK since the rethook arch port
> > must be a copy of the kretprobe implementation. But for safety, I think
> > having CONFIG_KPROBE_ON_RETHOOK is a good idea until replacing all kretprobe
> > implementations.
> 
> Masami,
> 
> you're respinning this patch to combine
> arch_rethook_trampoline and __kretprobe_trampoline
> right?

Yes, let me send the first patch set (for x86 at first).

BTW, can you review these 2 patches? These are only for the fprobes,
so it can be picked to bpf-next.

https://lore.kernel.org/all/164802091567.1732982.1242854551611267542.stgit@devnote2/T/#u

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
