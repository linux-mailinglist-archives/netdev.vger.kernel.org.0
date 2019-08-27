Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F16F9DA4A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 02:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfH0AGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 20:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfH0AGN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 20:06:13 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBDA92189D
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 00:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566864372;
        bh=w3CtVZ8z/4LRe13Fa4iFKi1bPPQ5GJl9YfmvxzCVq8U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CFe0O9mglRZWbn1RG0U6FXuR8SJqzIbWkfs4zRx4aR/e4PbPHW1cAsdOJFCSPWTF6
         oANRWjdFLffWD0GvK5o6/R3+8YiPT2T2ZCe2bCP7b63Ub7U/ErmxViEvewd61AV/WF
         l7UVgqmGaIxo2DIX50WO+StyzxW5vpese24JxdtM=
Received: by mail-wm1-f46.google.com with SMTP id v15so1167623wml.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 17:06:11 -0700 (PDT)
X-Gm-Message-State: APjAAAV+MlVoE72s5DaAEOU3IltWA1ngLE671f+49I7dubwNdz8Nu5CP
        cxab8oprMtAjHEt9dwcs5tafuSN1CLJVDAWkA4wfSw==
X-Google-Smtp-Source: APXvYqyPXDZNMKFlzLQoMt7do+dGsdRtE6XV/WjDjpIuiSjvrNKa4iqA9FgZLBQuvRdoh+7B/vveJoS5mXTc6DMIPuQ=
X-Received: by 2002:a1c:c5c2:: with SMTP id v185mr26068060wmf.161.1566864370119;
 Mon, 26 Aug 2019 17:06:10 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net> <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
 <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
 <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com> <20190826223558.6torq6keplniif6w@ast-mbp>
In-Reply-To: <20190826223558.6torq6keplniif6w@ast-mbp>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 26 Aug 2019 17:05:58 -0700
X-Gmail-Original-Message-ID: <CALCETrUARqcn8EmjcgMc8KP=4O5nZDMh=tcruEYvUgSzMKJUBw@mail.gmail.com>
Message-ID: <CALCETrUARqcn8EmjcgMc8KP=4O5nZDMh=tcruEYvUgSzMKJUBw@mail.gmail.com>
Subject: Re: RFC: very rough draft of a bpf permission model
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Aug 26, 2019, at 3:36 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>
>> On Fri, Aug 23, 2019 at 04:09:11PM -0700, Andy Lutomirski wrote:
>> On Thu, Aug 22, 2019 at 4:26 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> You're proposing all of the above in addition to CAP_BPF, right?
>>> Otherwise I don't see how it addresses the use cases I kept
>>> explaining for the last few weeks.
>>
>> None of my proposal is intended to exclude changes like CAP_BPF to
>> make privileged bpf() operations need less privilege.  But I think
>> it's very hard to evaluate CAP_BPF without both a full description of
>> exactly what CAP_BPF would do and what at least one full example of a
>> user would look like.
>
> the example is previous email and systemd example was not "full" ?

Can you give an example of how a real user would want to configure
their system such that a non-root systemd instance has capabilities,
sets up a BPF firewall, and does something useful with it?  You
mentioned systemd, multiple people pointed out that, on a normal
system, systemd =E2=80=94user has no capabilities. That was the end of the
discussion.

A full example is one where peoples=E2=80=99 confusion as to what the examp=
le
is gets answered.

>
>> I also think that users who want CAP_BPF should look at manipulating
>> their effective capability set instead.  A daemon that wants to use
>> bpf() but otherwise minimize the chance of accidentally causing a
>> problem can use capset() to clear its effective and inheritable masks.
>> Then, each time it wants to call bpf(), it could re-add CAP_SYS_ADMIN
>> or CAP_NET_ADMIN to its effective set, call bpf(), and then clear its
>> effective set again.  This works in current kernels and is generally
>> good practice.
>
> Such logic means that CAP_NET_ADMIN is not necessary either.
> The process could re-add CAP_SYS_ADMIN when it needs to reconfigure
> network and then drop it.

This isn't really true. By giving a process CAP_NET_ADMIN and not
CAP_SYS_ADMIN, that process can configure the network but can=E2=80=99t loa=
d
kernel modules or reconfigure the machine deliberately or by accident.

But that's besides the point.  Can you give an example where this
approach doesn't help and CAP_BPF does?


>
>> Aside from this, and depending on exactly what CAP_BPF would be, I
>> have some further concerns.  Looking at your example in this email:
>>
>>> Here is another example of use case that CAP_BPF is solving:
>>> The daemon X is started by pid=3D1 and currently runs as root.
>>> It loads a bunch of tracing progs and attaches them to kprobes
>>> and tracepoints. It also loads cgroup-bpf progs and attaches them
>>> to cgroups. All progs are collecting data about the system and
>>> logging it for further analysis.
>>
>> This needs more than just bpf().  Creating a perf kprobe event
>> requires CAP_SYS_ADMIN, and without a perf kprobe event, you can't
>> attach a bpf program.
>
> that is already solved sysctl_perf_event_paranoid.
> CAP_BPF is about BPF part only.

Hence my point: I'd like to see a real example where CAP_BPF helps.
perf_event_paranoid does not appear to grant the ability to add
kprobes.  With perf_event_paranoid set to -1:

$ perf probe --add vfs_mknod
Failed to open kprobe_events: Permission denied
  Error: Failed to add events.
$ sudo perf probe --add vfs_mknod
Added new event:
  probe:vfs_mknod      (on vfs_mknod)

I suppose I could modify permissions on debugfs and set
perf_event_paranoid=3D-1, but at that point the overall security of the
system is so weak that talking about refining the bpf part seems
pointless.

>
>> And the privilege to attach bpf programs to
>> cgroups without any DAC or MAC checks (which is what the current API
>> does) is an extremely broad privilege that is not that much weaker
>> than CAP_SYS_ADMIN or CAP_NET_ADMIN.  Also:
>
> I don't think there is a hierarchy of CAP_SYS_ADMIN vs CAP_NET_ADMIN
> vs CAP_BPF.
> CAP_BPF and CAP_NET_ADMIN carve different areas of CAP_SYS_ADMIN.
> Just like all other caps.

The whole set of capabilities on Linux us a bit of a mess.  Their
features are mostly disjoint but, on a normal Linux machine, many of
the capabilities can be used to become root with full capabilities.

>
>>> This tracing bpf is looking into kernel memory
>>> and using bpf_probe_read. Clearly it's not _secure_. But it's _safe_.
>>> The system is not going to crash because of BPF,
>>> but it can easily crash because of simple coding bugs in the user
>>> space bits of that daemon.
>>
>> The BPF verifier and interpreter, taken in isolation, may be extremely
>> safe, but attaching BPF programs to various hooks can easily take down
>> the system, deliberately or by accident.  A handler, especially if it
>> can access user memory or otherwise fault, will explode if attached to
>> an inappropriate kprobe, hw_breakpoint, or function entry trace event.
>
> absolutely not true.

This is not a constructive way to have a conversation.  When you get
an email that contains a statement you disagree with, perhaps you
could try to give some argument as to why you disagree rather than
just saying "absolutely not true".  Especially when you are talking to
one of the maintainers of the affected system who has a
not-yet-finished branch that addresses some of the bugs that you claim
absolutely don't exist.  If it's really truly necessary, I can go and
write an example that will crash an x86 kernel, but I feel like it
would be a waste of everyone's time.

Right now, on all kernels, an hw_breakpoint on memory used in a
non-recursion-safe part of any of the x86 IST entry handlers will
corrupt the kernel no later than when the hw_breakpoint handler
returns.  It does not matter in the slightest what the BPF payload is.
The payload doesn't even have to be BPF for this to blow up.

Similarly, until very, very recently, a handler that pagefaulted (due
to generating a stack trace or failing a bpf_probe_read() in the
trace_hardirqs_on path would crash the system due to corrupting cr2 in
the x86 entry code.  PeterZ just fixed this bug recently.  I believe
that there are similar bugs relating to DR6, but they probably don't
kill the system as easily.  I wouldn't rule out a full system crash,
though.  Again, a not-really-done fix for this is part-way done in my
tree.

How confident are you that a BPF program that calls bpf_probe_read()
the maximum allowable number of times on the address
0xffffffffffffffff attached to, say, an network interrupt probe will
actually leave the system in a usable state?  Maybe it will, but I'd
be a bit surprised.

How confident are you that the BPF program that calls bpf_probe_read()
on an MMIO address has well-defined semantics?  How confident are you
that the system will still work if such a program runs?

>
>> (I and the other maintainers consider this to be a bug if it happens,
>> and we'll fix it, but these bugs definitely exist.)  A cgroup-bpf hook
>> that blocks all network traffic will effectively kill a machine,
>> especially if it's a server.
>
> this permission is granted by CAP_NET_ADMIN. Nothing changes here.
>
>> A bpf program that runs excessively
>> slowly attached to a high-frequency hook will kill the system, too.
>
> not true either.

What prevents this from happening?  Is there a specific mitigation in place=
?

My point here is that the bpf is 'safe' in isolation, but that bpf
tracing is only somewhat 'safe'.

>> A bpf firewall rule that's
>> wrong can cut a machine off from the network -- I've killed machines
>> using iptables more than once, and bpf isn't magically safer.
>
> this is CAP_NET_ADMIN permission. It's a different capability.

Since you haven't fully defined what CAP_BPF would do, I can only
assume that you intend for CAP_BPF to enable installation of a BPF
inet_ingress hook on the root cgroup.  A BPF program that rejects
everything will block all traffic.

>
>>
>> I'm wondering if something like CAP_TRACING would make sense.
>> CAP_TRACING would allow operations that can reveal kernel memory and
>> other secret kernel state but that do not, by design, allow modifying
>> system behavior.  So, for example, CAP_TRACING would allow privileged
>> perf_event_open() operations and privileged bpf verifier usage.  But
>> it would not allow cgroup-bpf unless further restrictions were added,
>> and it would not allow the *_BY_ID operations, as those can modify
>> other users' bpf programs' behavior.
>
> Makes little sense to me.
> I can imagine CAP_TRACING controlling kprobe/uprobe creation
> and probe_read() both from bpf side and from vanilla kprobe.
> That would be much nicer interface to use than existing
> sysctl_perf_event_paranoid, but that is orthogonal to CAP_BPF
> which is strictly about BPF.

I'm suggesting that CAP_TRACING would also enable most of all of the
things in the verifier that are currently CAP_SYS_ADMIN and would
enable loading and attaching BPF programs to perf events.  So it's not
orthogonal.

You're welcome to post CAP_BPF patches, but perhaps you could also
comment on CAP_TRACING and capset?

--Andy
