Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8FFCED5D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfJGUWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:22:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:34506 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbfJGUWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:22:35 -0400
Received: from 55.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.55] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iHZWT-0004eD-8Y; Mon, 07 Oct 2019 22:22:25 +0200
Date:   Mon, 7 Oct 2019 22:22:24 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
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
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into
 BPF programs on load
Message-ID: <20191007202224.GD27307@pc-66.home>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
 <157020976144.1824887.10249946730258092768.stgit@alrua-x1>
 <20191007002739.5seu2btppfjmhry4@ast-mbp.dhcp.thefacebook.com>
 <87h84kn9v0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h84kn9v0.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25595/Mon Oct  7 10:28:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 12:11:31PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > On Fri, Oct 04, 2019 at 07:22:41PM +0200, Toke Høiland-Jørgensen wrote:
> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
> >> 
> >> This adds support for injecting chain call logic into eBPF programs before
> >> they return. The code injection is controlled by a flag at program load
> >> time; if the flag is set, the verifier will add code to every BPF_EXIT
> >> instruction that first does a lookup into a chain call structure to see if
> >> it should call into another program before returning. The actual calls
> >> reuse the tail call infrastructure.
> >> 
> >> Ideally, it shouldn't be necessary to set the flag on program load time,
> >> but rather inject the calls when a chain call program is first loaded.
> >> However, rewriting the program reallocates the bpf_prog struct, which is
> >> obviously not possible after the program has been attached to something.
> >> 
> >> One way around this could be a sysctl to force the flag one (for enforcing
> >> system-wide support). Another could be to have the chain call support
> >> itself built into the interpreter and JIT, which could conceivably be
> >> re-run each time we attach a new chain call program. This would also allow
> >> the JIT to inject direct calls to the next program instead of using the
> >> tail call infrastructure, which presumably would be a performance win. The
> >> drawback is, of course, that it would require modifying all the JITs.
> >> 
> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > ...
> >>  
> >> +static int bpf_inject_chain_calls(struct bpf_verifier_env *env)
> >> +{
> >> +	struct bpf_prog *prog = env->prog;
> >> +	struct bpf_insn *insn = prog->insnsi;
> >> +	int i, cnt, delta = 0, ret = -ENOMEM;
> >> +	const int insn_cnt = prog->len;
> >> +	struct bpf_array *prog_array;
> >> +	struct bpf_prog *new_prog;
> >> +	size_t array_size;
> >> +
> >> +	struct bpf_insn call_next[] = {
> >> +		BPF_LD_IMM64(BPF_REG_2, 0),
> >> +		/* Save real return value for later */
> >> +		BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
> >> +		/* First try tail call with index ret+1 */
> >> +		BPF_MOV64_REG(BPF_REG_3, BPF_REG_0),
> >> +		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 1),
> >> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
> >> +		/* If that doesn't work, try with index 0 (wildcard) */
> >> +		BPF_MOV64_IMM(BPF_REG_3, 0),
> >> +		BPF_RAW_INSN(BPF_JMP | BPF_TAIL_CALL, 0, 0, 0, 0),
> >> +		/* Restore saved return value and exit */
> >> +		BPF_MOV64_REG(BPF_REG_0, BPF_REG_6),
> >> +		BPF_EXIT_INSN()
> >> +	};
> >
> > How did you test it?
> > With the only test from patch 5?
> > +int xdp_drop_prog(struct xdp_md *ctx)
> > +{
> > +       return XDP_DROP;
> > +}
> >
> > Please try different program with more than one instruction.
> > And then look at above asm and think how it can be changed to
> > get valid R1 all the way to each bpf_exit insn.
> > Do you see amount of headaches this approach has?
> 
> Ah yes, that's a good point. It seems that I totally overlooked that
> issue, somehow...
> 
> > The way you explained the use case of XDP-based firewall plus XDP-based
> > IPS/IDS it's about "knows nothing" admin that has to deal with more than
> > one XDP application on an unfamiliar server.
> > This is the case of debugging.
> 
> This is not about debugging. The primary use case is about deploying
> multiple, independently developed, XDP-enabled applications on the same
> server.
> 
> Basically, we want the admin to be able to do:
> 
> # yum install MyIDS
> # yum install MyXDPFirewall
> 
> and then have both of those *just work* in XDP mode, on the same
> interface.

How is the user space loader side handled in this situation, meaning,
what are your plans on this regard?

Reason I'm asking is that those independently developed, XDP-enabled
applications today might on startup simply forcefully remove what is
currently installed on XDP layer at device X, and then override it
with their own program, meaning both of MyIDS and MyXDPFirewall would
remove each other's programs on start.

This will still require some sort of cooperation, think of something
like systemd service files or the like where the former would then
act as the loader to link these together in the background (perhaps
also allowing to specify some sort of a dependency between well-known
ones). How would an admin ad-hoc insert his xdpdump program in between,
meaning what tooling do you have in mind here?

And how would daemons update their own installed programs at runtime?
Right now it's simply atomic update of whatever is currently installed,
but with chained progs, they would need to send it to whatever central
daemon is managing all these instead of just calling bpf() and do the
attaching by themselves, or is the expectation that the application
would need to iterate its own chain via BPF_PROG_CHAIN_GET and resetup
everything by itself?

Thanks,
Daniel
