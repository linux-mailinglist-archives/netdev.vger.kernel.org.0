Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE1E494DB9
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbiATMPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:15:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46012 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiATMPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:15:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31142616AF;
        Thu, 20 Jan 2022 12:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E53C340E0;
        Thu, 20 Jan 2022 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642680933;
        bh=0zqjRx17jeQjOp1ol5omqJUXW3BnaewnNO4FG3prRkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ihUgSNX5R5BLdm/EgKc1Xd0m/WUKj/xJJKFgn0xd6tHchDDoW3zUL3mOYEybMoZm1
         r5yWPtR1q9gLxHv4MXtT9Ss2ZtGIUuljKzpemqUiFFndGkxP1rMzQ9rgP2QXCZIAf/
         D8puAzQs6H50/JWpUngeFbFb/p2dbxJ+fzRMQtdo55J0M4/jAZrgOBrgBhXl84/fpP
         39GuC5D9+AlHQoaBMLGe/xBvu0HYUpOYsXt0Y2ikFeo3Y8N2w7cxZvc+Ppd5TO7PaB
         hE8SEZeWUvrEXUyp2iMqQJRwJ9QUNFrdxZDbCQ+qD+aH6Y6RgVYeLwdGhFqpf6suTU
         H4WFVYmqI+Smw==
Date:   Thu, 20 Jan 2022 21:15:27 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [RFC PATCH v3 7/9] bpf: Add kprobe link for attaching raw
 kprobes
Message-Id: <20220120211527.cd46c74ce2ad8f401aec545a@kernel.org>
In-Reply-To: <Yek9Jq1UVa8fq91n@krava>
References: <164260419349.657731.13913104835063027148.stgit@devnote2>
        <164260427009.657731.15292670471943106202.stgit@devnote2>
        <Yek9Jq1UVa8fq91n@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jan 2022 11:44:54 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Jan 19, 2022 at 11:57:50PM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > +static int kprobe_link_prog_run(struct bpf_kprobe_link *kprobe_link,
> > +				struct pt_regs *regs)
> > +{
> > +	struct bpf_trace_run_ctx run_ctx;
> > +	struct bpf_run_ctx *old_run_ctx;
> > +	int err;
> > +
> > +	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> > +		err = 0;
> > +		goto out;
> > +	}
> > +
> > +	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > +	run_ctx.bpf_cookie = kprobe_link->bpf_cookie;
> > +
> > +	rcu_read_lock();
> > +	migrate_disable();
> > +	err = bpf_prog_run(kprobe_link->link.prog, regs);
> > +	migrate_enable();
> > +	rcu_read_unlock();
> > +
> > +	bpf_reset_run_ctx(old_run_ctx);
> > +
> > + out:
> > +	__this_cpu_dec(bpf_prog_active);
> > +	return err;
> > +}
> > +
> > +static void kprobe_link_entry_handler(struct fprobe *fp, unsigned long entry_ip,
> > +				      struct pt_regs *regs)
> > +{
> > +	struct bpf_kprobe_link *kprobe_link;
> > +
> > +	/*
> > +	 * Because fprobe's regs->ip is set to the next instruction of
> > +	 * dynamic-ftrace insturction, correct entry ip must be set, so
> > +	 * that the bpf program can access entry address via regs as same
> > +	 * as kprobes.
> > +	 */
> > +	instruction_pointer_set(regs, entry_ip);
> 
> ok, so this actually does the stall for me.. it changes
> the return address back to repeat the call again

Good catch! and don't mind, this change is introduced me :-P.
I thought that if I didn't add the FTRACE_FL_IPMODIFY, ftrace
ignores the updated regs->ip, but it doesn't.

> bu I think it's good idea to carry the original ip in regs
> (for bpf_get_func_ip helper) so I think we need to save it
> first and restore after the callback

Yes, btw, should I do that fix in fprobe?

> 
> I'll make the fix and add cookie change Andrii asked for
> on top of your ftrace changes and let you know

OK, thank you!

> 
> thanks,
> jirka
> 
> > +	kprobe_link = container_of(fp, struct bpf_kprobe_link, fp);
> > +	kprobe_link_prog_run(kprobe_link, regs);
> > +}
> > +
> 
> SNIP
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
