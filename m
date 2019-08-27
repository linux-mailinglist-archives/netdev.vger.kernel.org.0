Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7D9F683
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfH0XBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfH0XBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:01:23 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE6E233FF
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 23:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566946881;
        bh=HsIuj/1hGmTe3FacQdmSLl1zZrHFZWUqwnDRSSeK2IA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Q5nLHkdOUH5steymeMPAAMH8/xu44BLHsIO/HnwC6668ZtaBksi+6Vh9pvfrtB+VL
         deHeNiY7kVZHbTH6YWN36XN2rxlu1CQ28awK1SMMd59PNPDlUEtoWMXPg0tDn++wfo
         2NS9LYQ1AJfAKzBlxyJHRqYQDsHi2C/MNYPo/u6E=
Received: by mail-wm1-f44.google.com with SMTP id t6so704542wmj.4
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 16:01:21 -0700 (PDT)
X-Gm-Message-State: APjAAAU2zyilddDtVzVU3hjJi8DWa9wxA2uYlTwgbsov+YmYWAcApnne
        P86LtRchD/3O3NtiucSgisxFVSQimMK/NN/qx6kKww==
X-Google-Smtp-Source: APXvYqwxX6aj+Ymx+62b9ZPWXCfphCCr0vC4ulvY7qH4JEvBOfx6MvOXOniW6CIRGuQYazWncVtTqLvs8HJBAWLUrm8=
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr810307wmk.79.1566946879494;
 Tue, 27 Aug 2019 16:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org>
In-Reply-To: <20190827205213.456318-1-ast@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 27 Aug 2019 16:01:08 -0700
X-Gmail-Original-Message-ID: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
Message-ID: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
To:     Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[adding some security and tracing folks to cc]

On Tue, Aug 27, 2019 at 1:52 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Introduce CAP_BPF that allows loading all types of BPF programs,
> create most map types, load BTF, iterate programs and maps.
> CAP_BPF alone is not enough to attach or run programs.
>
> Networking:
>
> CAP_BPF and CAP_NET_ADMIN are necessary to:
> - attach to cgroup-bpf hooks like INET_INGRESS, INET_SOCK_CREATE, INET4_CONNECT
> - run networking bpf programs (like xdp, skb, flow_dissector)
>
> Tracing:
>
> CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> are necessary to:
> - attach bpf program to raw tracepoint
> - use bpf_trace_printk() in all program types (not only tracing programs)
> - create bpf stackmap
>
> To attach bpf to perf_events perf_event_open() needs to succeed as usual.
>
> CAP_BPF controls BPF side.
> CAP_NET_ADMIN controls intersection where BPF calls into networking.
> perf_paranoid_tracepoint_raw controls intersection where BPF calls into tracing.
>
> In the future CAP_TRACING could be introduced to control
> creation of kprobe/uprobe and attaching bpf to perf_events.
> In such case bpf_probe_read() thin wrapper would be controlled by CAP_BPF.
> Whereas probe_read() would be controlled by CAP_TRACING.
> CAP_TRACING would also control generic kprobe+probe_read.
> CAP_BPF and CAP_TRACING would be necessary for tracing bpf programs
> that want to use bpf_probe_read.

First, some high-level review:

Can you write up some clear documentation aimed at administrators that
says what CAP_BPF does?  For example, is it expected that CAP_BPF by
itself permits reading all kernel memory?  Why might one grant it?

Can you give at least one fully described use case where CAP_BPF
solves a real-world problem that is not solved by existing mechanisms?

Changing the capability that some existing operation requires could
break existing programs.  The old capability may need to be accepted
as well.

I'm inclined to suggest that CAP_TRACING be figured out or rejected
before something like this gets applied.


>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> I would prefer to introduce CAP_TRACING soon, since it
> will make tracing and networking permission model symmetrical.
>

Here's my proposal for CAP_TRACING, documentation-style:

--- begin ---

CAP_TRACING enables a task to use various kernel features to trace
running user programs and the kernel itself.  CAP_TRACING also enables
a task to bypass some speculation attack countermeasures.  A task in
the init user namespace with CAP_TRACING will be able to tell exactly
what kernel code is executed and when, and will be able to read kernel
registers and kernel memory.  It will, similarly, be able to read the
state of other user tasks.

Specifically, CAP_TRACING allows the following operations.  It may
allow more operations in the future:

 - Full use of perf_event_open(), similarly to the effect of
kernel.perf_event_paranoid == -1.

 - Loading and attaching tracing BPF programs, including use of BPF
raw tracepoints.

 - Use of BPF stack maps.

 - Use of bpf_probe_read() and bpf_trace_printk().

 - Use of unsafe pointer-to-integer conversions in BPF.

 - Bypassing of BPF's speculation attack hardening measures and
constant blinding.  (Note: other mechanisms might also allow this.)

CAP_TRACING does not override normal permissions on sysfs or debugfs.
This means that, unless a new interface for programming kprobes and
such is added, it does not directly allow use of kprobes.

If CAP_TRACING, by itself, enables a task to crash or otherwise
corrupt the kernel or other tasks, this will be considered a kernel
bug.

CAP_TRACING in a non-init user namespace may, in the future, allow
tracing of other tasks in that user namespace or its descendants.  It
will not enable kernel tracing or tracing of tasks outside the user
namespace in question.

--- end ---

Does this sound good?  The idea here is that CAP_TRACING should be
very useful even without CAP_BPF, which allows CAP_BPF to be less
powerful.

> +bool cap_bpf_tracing(void)
> +{
> +       return capable(CAP_SYS_ADMIN) ||
> +              (capable(CAP_BPF) && !perf_paranoid_tracepoint_raw());
> +}

If auditing is on, this will audit the wrong thing.  James, I think a
helper like:

bool ns_either_cap(struct user_ns *ns, int preferred_cap, int other_cap);

would help.  ns_either_cap returns true if either cap is held (i.e.
effective, as usual).  On success, it audits preferred_cap if held and
other_cap otherwise.  On failure, it audits preferred_cap.  Does this
sound right?

Also, for reference, perf_paranoid_tracepoint_raw() is this:

static inline bool perf_paranoid_tracepoint_raw(void)
{
        return sysctl_perf_event_paranoid > -1;
}

so the overall effect of cap_bpf_tracing() is rather odd, and it seems
to control a few things that don't obvious all have similar security
effects.


> @@ -2080,7 +2083,10 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
>         struct bpf_prog *prog;
>         int ret = -ENOTSUPP;
>
> -       if (!capable(CAP_SYS_ADMIN))
> +       if (!capable(CAP_NET_ADMIN) || !capable(CAP_BPF))
> +               /* test_run callback is available for networking progs only.
> +                * Add cap_bpf_tracing() above when tracing progs become runable.
> +                */

I think test_run should probably be CAP_SYS_ADMIN forever.  test_run
is the only way that one can run a bpf program and call helper
functions via the program if one doesn't have permission to attach the
program.  Also, if there's a way to run a speculation attack via a bpf
program, test_run will make it much easier to do in a controlled
environment.  Finally, when debugging bpf programs, developers can use
their own computers or a VM.
