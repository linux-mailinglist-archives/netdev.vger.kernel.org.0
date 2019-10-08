Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC05CF574
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbfJHJAP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Oct 2019 05:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbfJHJAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 05:00:15 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22F5851EF1
        for <netdev@vger.kernel.org>; Tue,  8 Oct 2019 09:00:14 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id b90so4114887ljf.11
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 02:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3h3n4ftaKqE2RqZorcgiE0edDWteb7jJKNdYgxfxACY=;
        b=pxIOrFWL4JdD1XpGSnah55BE5rSgsanU9Tt6sfDmlfHObPbKfexkSCLfwd8VMMbtfs
         7bdiXtwju3WyoNU5ECIAlP/544KwBfOwV3CNJl7a2stmeqYpLufVCfanDP9Z87em8chd
         jCguEwLsZQTgcoR23BsTsFBq+MNJAIT4cIhjp6DiIJCzi0g9wAZyJu7KtcRl7+l8Xf30
         k4HWFxVerMPTTXl3kW3YtP+njURlFB7rGjoPIBNtHPxBz5DlSkXl1PHhCVMDoTz1cJTn
         tGUYX4qfkD4YCXU5hqOjeqMdwDz/mVXHi5ErYX1ognkCu4YaRmP4Y59QrsoUyuo1M3t5
         +HOQ==
X-Gm-Message-State: APjAAAWdX8JISZ+hc4UfoVjg4qgeuai0SyLowuE2xJ9Tp5ECe8BxrdhN
        6aNjUqqcjzQZ16qmCLgEensBRtCUkapagHDlUArOXBGVqUEmoF8cHcgJDpBET47DNN2UgpFFtU9
        D+MRFtel9COzEmIjh
X-Received: by 2002:a2e:1409:: with SMTP id u9mr21217293ljd.162.1570525212439;
        Tue, 08 Oct 2019 02:00:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqylI0mujbJlNbyT8tJGrZXGjS083qVxk37AaTywyP6ZbAq4wsaQmXBBuuUyOoO+DX+kc5Or7A==
X-Received: by 2002:a2e:1409:: with SMTP id u9mr21217276ljd.162.1570525212130;
        Tue, 08 Oct 2019 02:00:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id t6sm3846749ljd.102.2019.10.08.02.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 02:00:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4306D18063D; Tue,  8 Oct 2019 11:00:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into BPF programs on load
In-Reply-To: <20191007202224.GD27307@pc-66.home>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1> <157020976144.1824887.10249946730258092768.stgit@alrua-x1> <20191007002739.5seu2btppfjmhry4@ast-mbp.dhcp.thefacebook.com> <87h84kn9v0.fsf@toke.dk> <20191007202224.GD27307@pc-66.home>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Oct 2019 11:00:10 +0200
Message-ID: <87eeznlihx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On Mon, Oct 07, 2019 at 12:11:31PM +0200, Toke Høiland-Jørgensen wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> > On Fri, Oct 04, 2019 at 07:22:41PM +0200, Toke Høiland-Jørgensen wrote:
>> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> >> 
>> >> This adds support for injecting chain call logic into eBPF programs before
>> >> they return. The code injection is controlled by a flag at program load
>> >> time; if the flag is set, the verifier will add code to every BPF_EXIT
>> >> instruction that first does a lookup into a chain call structure to see if
>> >> it should call into another program before returning. The actual calls
>> >> reuse the tail call infrastructure.
>> >> 
>> >> Ideally, it shouldn't be necessary to set the flag on program load time,
>> >> but rather inject the calls when a chain call program is first loaded.
>> >> However, rewriting the program reallocates the bpf_prog struct, which is
>> >> obviously not possible after the program has been attached to something.
>> >> 
>> >> One way around this could be a sysctl to force the flag one (for enforcing
>> >> system-wide support). Another could be to have the chain call support
>> >> itself built into the interpreter and JIT, which could conceivably be
>> >> re-run each time we attach a new chain call program. This would also allow
>> >> the JIT to inject direct calls to the next program instead of using the
>> >> tail call infrastructure, which presumably would be a performance win. The
>> >> drawback is, of course, that it would require modifying all the JITs.
>> >> 
>> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> > ...
>> >>  
>> >> +static int bpf_inject_chain_calls(struct bpf_verifier_env *env)
>> >> +{
>> >> +	struct bpf_prog *prog = env->prog;
>> >> +	struct bpf_insn *insn = prog->insnsi;
>> >> +	int i, cnt, delta = 0, ret = -ENOMEM;
>> >> +	const int insn_cnt = prog->len;
>> >> +	struct bpf_array *prog_array;
>> >> +	struct bpf_prog *new_prog;
>> >> +	size_t array_size;
>> >> +
>> >> +	struct bpf_insn call_next[] = {
>> >> +		BPF_LD_IMM64(BPF_REG_2, 0),
>> >> +		/* Save real return value for later */
>> >> +		BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
>> >> +		/* First try tail call with index ret+1 */
>> >> +		BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
>> >> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 1),
>> >> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
>> >> +		/* If that doesn't work, try with index 0 (wildcard) */
>> >> +		BPF_MOV64_IMM(BPF_REG_3, 0),
>> >> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
>> >> +		/* Restore saved return value and exit */
>> >> +		BPF_MOV64_REG(BPF_REG_0, BPF_REG_6),
>> >> +		BPF_EXIT_INSN()
>> >> +	};
>> >
>> > How did you test it?
>> > With the only test from patch 5?
>> > +int xdp_drop_prog(struct xdp_md *ctx)
>> > +{
>> > +       return XDP_DROP;
>> > +}
>> >
>> > Please try different program with more than one instruction.
>> > And then look at above asm and think how it can be changed to
>> > get valid R1 all the way to each bpf_exit insn.
>> > Do you see amount of headaches this approach has?
>> 
>> Ah yes, that's a good point. It seems that I totally overlooked that
>> issue, somehow...
>> 
>> > The way you explained the use case of XDP-based firewall plus XDP-based
>> > IPS/IDS it's about "knows nothing" admin that has to deal with more than
>> > one XDP application on an unfamiliar server.
>> > This is the case of debugging.
>> 
>> This is not about debugging. The primary use case is about deploying
>> multiple, independently developed, XDP-enabled applications on the same
>> server.
>> 
>> Basically, we want the admin to be able to do:
>> 
>> # yum install MyIDS
>> # yum install MyXDPFirewall
>> 
>> and then have both of those *just work* in XDP mode, on the same
>> interface.
>
> How is the user space loader side handled in this situation, meaning,
> what are your plans on this regard?

I am planning to write a loader that supports this which can be used
stand-alone or as a library (either a standalone library, or as part of
libbpf). Applications can then use the library functions to load itself,
or ship an eBPF binary and have the user load it as needed (depending on
what makes sense for its use case).

> Reason I'm asking is that those independently developed, XDP-enabled
> applications today might on startup simply forcefully remove what is
> currently installed on XDP layer at device X, and then override it
> with their own program, meaning both of MyIDS and MyXDPFirewall would
> remove each other's programs on start.

Yes, they could. I'm hoping to establish sufficiently strong conventions
that they won't :)

> This will still require some sort of cooperation, think of something
> like systemd service files or the like where the former would then act
> as the loader to link these together in the background (perhaps also
> allowing to specify some sort of a dependency between well-known
> ones).

I am imagining something like a manifest file where an application can
specify which return codes it will return that it makes sense to chain
on. E.g., a firewall could say "chain after me when I return XDP_PASS".
In general, chaining on XDP_PASS will probably be the most common.

> How would an admin ad-hoc insert his xdpdump program in between,
> meaning what tooling do you have in mind here?

xdpdump would do something like this:

xdpdump_attach(after=my_firewall, action=drop) {
  my_prog_fd = load_prog(xdpdump.so)
  other_prog_fd = find_prog_fd(name=my_firewall)
  existing_prog_id = bpf_prog_chain_get(other_prog_fd, action)
  if (existing_prog_id) {
     existing_prog_fd = bpf_get_fd_by_id(existing_prog_id);
     bpf_prog_chain_add(my_prog_fd, action, existing_prog_fd);
  }
  bpf_prog_chain_add(other_prog_fd, action, my_prog_fd);
}

xdpdump_detach() {
  bpf_prog_chain_add(other_prog_fd, action, existing_prog_fd);
}

> And how would daemons update their own installed programs at runtime?

Like above; you attach the chain actions to your new prog first, then
atomically replace it with the old one.

> Right now it's simply atomic update of whatever is currently
> installed, but with chained progs, they would need to send it to
> whatever central daemon is managing all these instead of just calling
> bpf() and do the attaching by themselves, or is the expectation that
> the application would need to iterate its own chain via
> BPF_PROG_CHAIN_GET and resetup everything by itself?

I'm expecting each application to "play nice" like above, with the help
of a library. In particular, I want to avoid having a userspace daemon
that needs to keep state. If the kernel keeps the state, different
userspace applications can cooperatively insert and remove themselves
using that state. Similar to how they today can install themselves on
*different* interfaces, but still have to avoid replacing each other...

-Toke
