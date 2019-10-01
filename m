Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19D71C438F
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfJAWK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfJAWKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 18:10:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009AE20873;
        Tue,  1 Oct 2019 22:10:53 +0000 (UTC)
Date:   Tue, 1 Oct 2019 18:10:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20191001181052.43c9fabb@gandalf.local.home>
In-Reply-To: <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
        <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
        <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
        <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
        <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
        <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
        <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
        <20190928193727.1769e90c@oasis.local.home>
        <201909301129.5A1129C@keescook>
        <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 18:22:28 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> tracefs is a file system, so clearly file based acls are much better fit
> for all tracefs operations.
> But that is not the case for ftrace overall.
> bpf_trace_printk() calls trace_printk() that dumps into trace pipe.
> Technically it's ftrace operation, but it cannot be controlled by tracefs
> and by file permissions. That's the motivation to guard bpf_trace_printk()
> usage from bpf program with CAP_TRACING.

BTW, I'd rather have bpf use an event that records a string than using
trace printk itself.

Perhaps something like "bpf_print" event? That could be defined like:

TRACE_EVENT(bpf_print,
	TP_PROTO(const char *msg),
	TP_ARGS(msg),
	TP_STRUCT__entry(
		__string(msg, msg)
	),
	TP_fast_assign(
		__assign_str(msg, msg)
	),
	TP_printk("msg=%s", __get_str(msg))
);

And then you can just format the string from the bpf_trace_printk()
into msg, and then have:

	trace_bpf_print(msg);

The user could then just enable the trace event from the file system. I
could also work on making instances work like /tmp does (with the
sticky bit) in creation. That way people with write access to the
instances directory, can make their own buffers that they can use (and
others can't access).


> 
> Both 'trace' and 'trace_pipe' have quirky side effects.
> Like opening 'trace' file will make all parallel trace_printk() to be ignored.
> While reading 'trace_pipe' file will clear it.
> The point that traditional 'read' and 'write' ACLs don't map as-is
> to tracefs, so I would be careful categorizing things into
> confidentiality vs integrity only based on access type.

What exactly is the bpf_trace_printk() used for? I may have other ideas
that can help.

-- Steve
