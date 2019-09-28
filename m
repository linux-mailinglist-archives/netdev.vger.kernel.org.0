Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79B60C1278
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 01:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfI1Xhb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 28 Sep 2019 19:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbfI1Xhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 19:37:31 -0400
Received: from oasis.local.home (unknown [12.174.139.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132A920866;
        Sat, 28 Sep 2019 23:37:29 +0000 (UTC)
Date:   Sat, 28 Sep 2019 19:37:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
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
Message-ID: <20190928193727.1769e90c@oasis.local.home>
In-Reply-To: <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
        <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
        <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
        <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
        <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
        <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
        <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 21:07:24 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> > 
> > 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> > 
> > 2. Improve it a bit do all the privileged ops are wrapped by capset().
> > 
> > Does this make sense?  I’m a security person on occasion. I find
> > vulnerabilities and exploit them deliberately and I break things by
> > accident on a regular basis. In my considered opinion, CAP_TRACING
> > alone, even extended to cover part of BPF as I’ve described, is
> > decently safe. Getting root with just CAP_TRACING will be decently
> > challenging, especially if I don’t get to read things like sshd’s
> > memory, and improvements to mitigate even that could be added.  I
> > am quite confident that attacks starting with CAP_TRACING will have
> > clear audit signatures if auditing is on.  I am also confident that
> > CAP_BPF *will* allow DoS and likely privilege escalation, and this
> > will only get more likely as BPF gets more widely used. And, if
> > BPF-based auditing ever becomes a thing, writing to the audit
> > daemon’s maps will be a great way to cover one’s tracks.  
> 
> CAP_TRACING, as I'm proposing it, will allow full tracefs access.
> I think Steven and Massami prefer that as well.
> That includes kprobe with probe_kernel_read.
> That also means mini-DoS by installing kprobes everywhere or running
> too much ftrace.

I was talking with Kees at Plumbers about this, and we were talking
about just using simple file permissions. I started playing with some
patches to allow the tracefs be visible but by default it would only be
visible by root.

 rwx------

Then a start up script (or perhaps mount options) could change the
group owner, and change this to:

 rwxrwx---

Where anyone in the group assigned (say "tracing") gets full access to
the file system.

The more I was playing with this, the less I see the need for
CAP_TRACING for ftrace and reading the format files.

-- Steve
