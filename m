Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E19D8AE4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391644AbfJPI10 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 04:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729709AbfJPI1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 04:27:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B12E9308A98C;
        Wed, 16 Oct 2019 08:27:24 +0000 (UTC)
Received: from carbon (ovpn-200-46.brq.redhat.com [10.40.200.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 310445D6A9;
        Wed, 16 Oct 2019 08:27:13 +0000 (UTC)
Date:   Wed, 16 Oct 2019 10:27:12 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191016102712.18f369e7@carbon>
In-Reply-To: <20191016022849.weomgfdtep4aojpm@ast-mbp>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
        <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
        <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
        <87sgo3lkx9.fsf@toke.dk>
        <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
        <87o8yqjqg0.fsf@toke.dk>
        <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
        <87v9srijxa.fsf@toke.dk>
        <20191016022849.weomgfdtep4aojpm@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 16 Oct 2019 08:27:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019 19:28:51 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Oct 14, 2019 at 02:35:45PM +0200, Toke Høiland-Jørgensen wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >   
> > > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:  
> > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >>   
> > >> > Please implement proper indirect calls and jumps.  
> > >> 
> > >> I am still not convinced this will actually solve our problem; but OK, I
> > >> can give it a shot.  
> > >
> > > If you're not convinced let's talk about it first.
> > >
> > > Indirect calls is a building block for debugpoints.
> > > Let's not call them tracepoints, because Linus banned any discusion
> > > that includes that name.
> > > The debugpoints is a way for BPF program to insert points in its
> > > code to let external facility to do tracing and debugging.
> > >
> > > void (*debugpoint1)(struct xdp_buff *, int code);
> > > void (*debugpoint2)(struct xdp_buff *);
> > > void (*debugpoint3)(int len);  
> > 
> > So how would these work? Similar to global variables (i.e., the loader
> > creates a single-entry PROG_ARRAY map for each one)? Presumably with
> > some BTF to validate the argument types?
> > 
> > So what would it take to actually support this? It doesn't quite sound
> > trivial to add?  
> 
> Depends on definition of 'trivial' :)
> The kernel has a luxury of waiting until clean solution is implemented
> instead of resorting to hacks.
> 
> > > Essentially it's live debugging (tracing) of cooperative bpf programs
> > > that added debugpoints to their code.  
> > 
> > Yup, certainly not disputing that this would be useful for debugging;
> > although it'll probably be a while before its use becomes widespread
> > enough that it'll be a reliable tool for people deploying XDP programs...  
> 
> same for any new api.
> 
> > > Obviously indirect calls can be used for a ton of other things
> > > including proper chaing of progs, but I'm convinced that
> > > you don't need chaining to solve your problem.
> > > You need debugging.  
> > 
> > Debugging is certainly also an area that I want to improve. However, I
> > think that focusing on debugging as the driver for chaining programs was
> > a mistake on my part; rudimentary debugging (using a tool such as
> > xdpdump) is something that falls out of program chaining, but it's not
> > the main driver for it.  
> 
> xdpdump can be done already the way I suggested without adding new
> kernel code and it will work on old-ish kernels. Aside from xdp itself
> the other requirement is to have get_fd_by_id sys_bpf command.

You only demonstrated we can hook in xdpdump BEFORE an existing XDP
program without modifying the XDP program.  I'm much more interested in
running xdpdump AFTER an existing XDP program (without modifying it),
and very importantly I want to know the XDP-return codes in my xdpdump. 

That said, with your proposal of "proper indirect calls for BPF", then
the xdpdump AFTER will be easy to implement.

Maybe we should not focus on the xdpdump use-case, because it might be
better to solve by simply adding a tracepoint, that have access to the
xdp_buff.


> > > If you disagree please explain _your_ problem again.
> > > Saying that fb katran is a use case for chaining is, hrm, not correct.  
> > 
> > I never said Katran was the driver for this. I just used Katran as one
> > of the "prior art" examples for my "how are people solving running
> > multiple programs on the same interface" survey.  
> 
> and they solved it. that's the point.
> 
> > What I want to achieve is simply the ability to run multiple independent
> > XDP programs on the same interface, without having to put any
> > constraints on the programs themselves. I'm not disputing that this is
> > *possible* to do completely in userspace, I just don't believe the
> > resulting solution will be very good.  
> 
> What makes me uneasy about the whole push for program chaining
> is that tc cls_bpf supported multiple independent programs from day one.
> Yet it doesn't help to run two firewalls hooked into tc ingress.

I do understand your concerns.

Let me explain why I believe TC cls_bpf multiple independent programs
have not seen much usage.

First of all the TC-tool is notorious difficult to use and configure (I
admit, I struggle with this myself every single time). (The TC layer
have some amazing features, like hash based lookup, that never get used
due to this).

Second, the multiple "independent programs", are actually not
independent, because the current running program must return
TC_ACT_UNSPEC to allow next bpf-prog to run.  Thus, it is not really
usable.


> Similarly cgroup-bpf had a ton discussions on proper multi-prog api.
> Everyone was eventually convinced that it's flexible and generic.
> Yet people who started to use it complain that it's missing features
> to make it truly usable in production.

I've not looked at the cgroup-bpf multi-prog API, I guess we should to
understand why this failed.

> Tracing is the only bit where multi-prog works.
> Because kernel always runs all programs there.

This is important insight ("kernel always runs all programs").  A key
part of Toke's design with chain-calling, is that the kernel always
runs all the XDP/BPF-progs in the chain. Regardless of the XDP return
value.  The next program in the chain, need info about previous
BPF-prog return value, but it can choose to override this.

> If we could use PROG_RUN_ARRAY for XDP that could have been a solution.
> But we cannot. Return codes matter for XDP.

The proposal from Toke, is to allow next-chain BPF-program can override
the prev BPF-prog return value.  This part of the design, which I must
admit is also the only option due to tail-calls.  But I do think it
makes sense, because even if XDP_DROP is returned, then I can install
another XDP-prog that does XDP_REDIRECT out another interface to an
analyzer box, or into an AF_XDP based dump tool.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
