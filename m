Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F1C43EA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfJAWrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbfJAWrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 18:47:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33E40215EA;
        Tue,  1 Oct 2019 22:47:33 +0000 (UTC)
Date:   Tue, 1 Oct 2019 18:47:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "LSM List" <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20191001184731.0ec98c7a@gandalf.local.home>
In-Reply-To: <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
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
        <20191001181052.43c9fabb@gandalf.local.home>
        <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Oct 2019 22:18:18 +0000
Alexei Starovoitov <ast@fb.com> wrote:

> > And then you can just format the string from the bpf_trace_printk()
> > into msg, and then have:
> > 
> > 	trace_bpf_print(msg);  
> 
> It's an interesting idea, but I don't think it can work.
> Please see bpf_trace_printk implementation in kernel/trace/bpf_trace.c
> It's a lot more than string printing.

Well, trace_printk() is just string printing. I was thinking that the
bpf_trace_printk() could just use a vsnprintf() into a temporary buffer
(like trace_printk() does), and then call the trace event to write it
out.

> 
> > The user could then just enable the trace event from the file system. I
> > could also work on making instances work like /tmp does (with the
> > sticky bit) in creation. That way people with write access to the
> > instances directory, can make their own buffers that they can use (and
> > others can't access).  
> 
> We tried instances in bcc in the past and eventually removed all the 
> support. The overhead of instances is too high to be usable.

What overhead? An ftrace instance should not have any more overhead than
the root one does (it's the same code). Or are you talking about memory
overhead?

> 
> > 
> >   
> >>
> >> Both 'trace' and 'trace_pipe' have quirky side effects.
> >> Like opening 'trace' file will make all parallel trace_printk() to be ignored.
> >> While reading 'trace_pipe' file will clear it.
> >> The point that traditional 'read' and 'write' ACLs don't map as-is
> >> to tracefs, so I would be careful categorizing things into
> >> confidentiality vs integrity only based on access type.  
> > 
> > What exactly is the bpf_trace_printk() used for? I may have other ideas
> > that can help.  
> 
> It's debugging of bpf programs. Same is what printk() is used for
> by kernel developers.
> 

How is it extracted? Just read from the trace or trace_pipe file?

-- Steve
