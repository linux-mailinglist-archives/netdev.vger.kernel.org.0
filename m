Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532BACEDDA
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbfJGUpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:45:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40324 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbfJGUpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:45:39 -0400
Received: by mail-pg1-f194.google.com with SMTP id d26so8922323pgl.7;
        Mon, 07 Oct 2019 13:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zLF7FBI1yC1AB3/YFO8eHFBENCgJ+U2JL9HlkV8ynIY=;
        b=SD+TbgfBEC9pXOSq6yqEI0GukwfzUE+/HllpJ4jdoge+72vYYX4F3vHJeq6dQXk86I
         a68UpO/B8tTCRCJPWCfmOy1s9TFOPXYV+kbQP7sS/P0ut7bivdI2dhqJOfUxiMhxc6+3
         E1wbHGlYCygcf10LEk3ElEbWIUQMrW1uZpQ96+9yRoYWgtfR/i7Ljz7njX0nmOxO04uO
         HAdcWCHv7wUrOm7bSZThTdgKxvTGUFjaTtveabvkSSQIy8kIvyp+VSvzV4jGWsdlY9lG
         FfbGdqiPGQmDSPts3SQsPNDO7l28HpTAXyFfYn+/h4aWrrTotCOWf5iqBzIz489tfwap
         9KtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zLF7FBI1yC1AB3/YFO8eHFBENCgJ+U2JL9HlkV8ynIY=;
        b=jMR4WTrFhkYcc5mr1zawH4E4LO59/Et8/ze72z3fJ0L3Vs4sRlo8+SIdqad8Fz7G46
         CS0YwGSB4JtfFNp2Qp4N3ZtrS7rhhriS0JakjAHr0T/aGWnHtQpWIavBEPZs5AdHZRGO
         nkD/PX67PWJRYoicX4B4dBgHgiZRSt9w8ZchtZq6rwMNQjjsk43rw3GPOJ9pxjfBUeU9
         4M42P4Ca1jrsGZatdpv+clo5IkavqsO5WSckWFrjnySp+PUXGAdfxOZvZk8IpTaxx0e4
         a/kWrrUUVSXT2Zs8tFT6dJy3v8e8mqOo0IPz049yeifRPmlZsIFWymK2lkRCVcKntoxk
         ocZg==
X-Gm-Message-State: APjAAAUHCmv4EBq6DGq/+6/nDdxfEChpjroYEPmt2Sfw+spuoM0pZxrm
        Q8/7gY2NLajQznUsLLq1vhhGty0c
X-Google-Smtp-Source: APXvYqx5hRV3XE5QN1mXuJGLox2NmhPzBr4c/GNzUkD0SRTmZ1zUsCgQ9TebuOS7dOmF8cBG9n8qOA==
X-Received: by 2002:a62:7d54:: with SMTP id y81mr194419pfc.86.1570481138017;
        Mon, 07 Oct 2019 13:45:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:2257])
        by smtp.gmail.com with ESMTPSA id x19sm10810246pgc.59.2019.10.07.13.45.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 13:45:37 -0700 (PDT)
Date:   Mon, 7 Oct 2019 13:45:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
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
Message-ID: <20191007204534.o3prqf463yk4sepn@ast-mbp.dhcp.thefacebook.com>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
 <157020976144.1824887.10249946730258092768.stgit@alrua-x1>
 <20191007002739.5seu2btppfjmhry4@ast-mbp.dhcp.thefacebook.com>
 <87h84kn9v0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h84kn9v0.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 12:11:31PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
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
> 
> I originally started solving this in an XDP-specific way (v1 of this
> patch set), but the reactions to that was pretty unanimous that this
> could be useful as a general eBPF feature. Do you agree with this?

Chaining in general is useful, but
yum install ids
yum install firewall
is not.

Say, xdp doesn't exist. Such ids and firewall will be using iptables.
And they will collide and conflict all over it.
The problem of mixing unrelated ids and firewall is not new.

