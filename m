Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044D24E54FE
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245082AbiCWPQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 11:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiCWPQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 11:16:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764D119297;
        Wed, 23 Mar 2022 08:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF327617AA;
        Wed, 23 Mar 2022 15:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C901EC340E8;
        Wed, 23 Mar 2022 15:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648048495;
        bh=0RaEF1b9P3k1oz8Z7XnrYmqYZ5f88R8iXz9iiAuahRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gMWZEYPI2LLlFt3ir9aK2sg/rZ3WQzNXxT2kyNVgGlWolZmTuCsAp+4g8Hrfm5C6q
         +btg0ABnm7UBwvD3jeJL/rviI/8ie7blCVa5EF4QrGRfRY7JGRcUt+J78sBFsKS+b/
         iRv4BRMZrx/kzhtzWsvOrrCmSL+Dmn2JQxD16CN0IBkabg71Vb2uI0pkAQbK7HmoqN
         xrn60Ku/hZGwAjhKT6sO3XuIXYaDHbPxXOBjNhvIgGlToG92w53ck4GPdt0Vg/+R17
         hC2o1KBWCe6SMLCWxrg1qBpbs7aRkX/6YbWAadOwUCyuozun5kwK6NHWalTWwrpnRg
         b1zBvC4pPdlEQ==
Date:   Thu, 24 Mar 2022 00:14:48 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
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
Message-Id: <20220324001448.c39861064d776973f7811578@kernel.org>
In-Reply-To: <20220323123454.GW8939@worktop.programming.kicks-ass.net>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
        <164800289923.1716332.9772144337267953560.stgit@devnote2>
        <YjrUxmABaohh1I8W@hirez.programming.kicks-ass.net>
        <20220323204119.1feac1af0a1d58b8e63acd5d@kernel.org>
        <20220323123454.GW8939@worktop.programming.kicks-ass.net>
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

On Wed, 23 Mar 2022 13:34:54 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 23, 2022 at 08:41:19PM +0900, Masami Hiramatsu wrote:
> 
> > > Also, what's rethook for anyway?
> > 
> > Rethook is a feature which hooks the function return. Most of the
> > logic came from the kretprobe. Simply to say, 'kretprobe - kprobe' is 
> > the rethook :)
> 
> I got that far, but why did you take the bother to do these patches? Why
> wasn't 'use kretprobe' a good enough option?

Ah, sorry about lacking the background story.

Actually this came from Jiri's request of multiple kprobe for bpf[1].
He tried to solve an issue that starting bpf with multiple kprobe will
take a long time because bpf-kprobe will wait for RCU grace period for
sync rcu events.

Jiri wanted to attach a single bpf handler to multiple kprobes and
he tried to introduce multiple-probe interface to kprobe. So I asked
him to use ftrace and kretprobe-like hook if it is only for the
function entry and exit, instead of adding ad-hoc interface
to kprobes. So I introduced fprobe (kprobe like interface for ftrace)
and rethook (this is a generic return hook feature for fprobe exit handler)[2].

[1] https://lore.kernel.org/all/20220104080943.113249-1-jolsa@kernel.org/T/#u
[2] https://lore.kernel.org/all/164191321766.806991.7930388561276940676.stgit@devnote2/T/#u

This is the reason why I need to split the kretprobe's trampoline as
rethook. Kretprobe is only for probing a single function entry/exit,
thus it does not suit for this purpose.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
