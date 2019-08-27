Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764FC9F6CE
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfH0XVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbfH0XVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:21:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17BC7206E0;
        Tue, 27 Aug 2019 23:21:46 +0000 (UTC)
Date:   Tue, 27 Aug 2019 19:21:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20190827192144.3b38b25a@gandalf.local.home>
In-Reply-To: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 16:01:08 -0700
Andy Lutomirski <luto@kernel.org> wrote:

> [adding some security and tracing folks to cc]
> 
> On Tue, Aug 27, 2019 at 1:52 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > Introduce CAP_BPF that allows loading all types of BPF programs,
> > create most map types, load BTF, iterate programs and maps.
> > CAP_BPF alone is not enough to attach or run programs.
> >
> > Networking:
> >
> > CAP_BPF and CAP_NET_ADMIN are necessary to:
> > - attach to cgroup-bpf hooks like INET_INGRESS, INET_SOCK_CREATE, INET4_CONNECT
> > - run networking bpf programs (like xdp, skb, flow_dissector)
> >
> > Tracing:
> >
> > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > are necessary to:
> > - attach bpf program to raw tracepoint
> > - use bpf_trace_printk() in all program types (not only tracing programs)
> > - create bpf stackmap
> >
> > To attach bpf to perf_events perf_event_open() needs to succeed as usual.
> >
> > CAP_BPF controls BPF side.
> > CAP_NET_ADMIN controls intersection where BPF calls into networking.
> > perf_paranoid_tracepoint_raw controls intersection where BPF calls into tracing.
> >
> > In the future CAP_TRACING could be introduced to control
> > creation of kprobe/uprobe and attaching bpf to perf_events.
> > In such case bpf_probe_read() thin wrapper would be controlled by CAP_BPF.
> > Whereas probe_read() would be controlled by CAP_TRACING.
> > CAP_TRACING would also control generic kprobe+probe_read.
> > CAP_BPF and CAP_TRACING would be necessary for tracing bpf programs
> > that want to use bpf_probe_read.

No mention of the tracefs (/sys/kernel/tracing) file?
  
> 
> First, some high-level review:
> 
> Can you write up some clear documentation aimed at administrators that
> says what CAP_BPF does?  For example, is it expected that CAP_BPF by
> itself permits reading all kernel memory?  Why might one grant it?
> 
> Can you give at least one fully described use case where CAP_BPF
> solves a real-world problem that is not solved by existing mechanisms?

At least for CAP_TRACING (if it were to allow read/write access
to /sys/kernel/tracing), that would be very useful. It would be useful
to those that basically own their machines, and want to trace their
applications all the way into the kernel without having to run as full
root.


> 
> Changing the capability that some existing operation requires could
> break existing programs.  The old capability may need to be accepted
> as well.
> 
> I'm inclined to suggest that CAP_TRACING be figured out or rejected
> before something like this gets applied.
> 
> 
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> > I would prefer to introduce CAP_TRACING soon, since it
> > will make tracing and networking permission model symmetrical.
> >  
> 
> Here's my proposal for CAP_TRACING, documentation-style:
> 
> --- begin ---
> 
> CAP_TRACING enables a task to use various kernel features to trace
> running user programs and the kernel itself.  CAP_TRACING also enables
> a task to bypass some speculation attack countermeasures.  A task in
> the init user namespace with CAP_TRACING will be able to tell exactly
> what kernel code is executed and when, and will be able to read kernel
> registers and kernel memory.  It will, similarly, be able to read the
> state of other user tasks.
> 
> Specifically, CAP_TRACING allows the following operations.  It may
> allow more operations in the future:
> 
>  - Full use of perf_event_open(), similarly to the effect of
> kernel.perf_event_paranoid == -1.
> 
>  - Loading and attaching tracing BPF programs, including use of BPF
> raw tracepoints.
> 
>  - Use of BPF stack maps.
> 
>  - Use of bpf_probe_read() and bpf_trace_printk().
> 
>  - Use of unsafe pointer-to-integer conversions in BPF.
> 
>  - Bypassing of BPF's speculation attack hardening measures and
> constant blinding.  (Note: other mechanisms might also allow this.)
> 
> CAP_TRACING does not override normal permissions on sysfs or debugfs.
> This means that, unless a new interface for programming kprobes and
> such is added, it does not directly allow use of kprobes.

kprobes can be created in the tracefs filesystem (which is separate from
debugfs, tracefs just gets automatically mounted
in /sys/kernel/debug/tracing when debugfs is mounted) from the
kprobe_events file. /sys/kernel/tracing is just the tracefs
directory without debugfs, and was created specifically to allow
tracing to be access without opening up the can of worms in debugfs.

Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
to convert perf and trace-cmd's function pointers into names. Once you
allow tracing of the kernel, hiding /proc/kallsyms is pretty useless.

-- Steve

> 
> If CAP_TRACING, by itself, enables a task to crash or otherwise
> corrupt the kernel or other tasks, this will be considered a kernel
> bug.
> 
> CAP_TRACING in a non-init user namespace may, in the future, allow
> tracing of other tasks in that user namespace or its descendants.  It
> will not enable kernel tracing or tracing of tasks outside the user
> namespace in question.
> 
> --- end ---
> 
