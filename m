Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB1BD8E05
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392483AbfJPKfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:35:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:36590 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390135AbfJPKfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 06:35:10 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKgdx-0004t6-BL; Wed, 16 Oct 2019 12:35:01 +0200
Date:   Wed, 16 Oct 2019 12:35:01 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191016103501.GB21367@pc-63.home>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
 <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk>
 <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
 <20191016022849.weomgfdtep4aojpm@ast-mbp>
 <20191016102712.18f369e7@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191016102712.18f369e7@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25604/Wed Oct 16 10:53:05 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 10:27:12AM +0200, Jesper Dangaard Brouer wrote:
> On Tue, 15 Oct 2019 19:28:51 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > On Mon, Oct 14, 2019 at 02:35:45PM +0200, Toke Høiland-Jørgensen wrote:
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:  
> > > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
[...]
> > > > If you disagree please explain _your_ problem again.
> > > > Saying that fb katran is a use case for chaining is, hrm, not correct.  
> > > 
> > > I never said Katran was the driver for this. I just used Katran as one
> > > of the "prior art" examples for my "how are people solving running
> > > multiple programs on the same interface" survey.  
> > 
> > and they solved it. that's the point.
> > 
> > > What I want to achieve is simply the ability to run multiple independent
> > > XDP programs on the same interface, without having to put any
> > > constraints on the programs themselves. I'm not disputing that this is
> > > *possible* to do completely in userspace, I just don't believe the
> > > resulting solution will be very good.  
> > 
> > What makes me uneasy about the whole push for program chaining
> > is that tc cls_bpf supported multiple independent programs from day one.
> > Yet it doesn't help to run two firewalls hooked into tc ingress.
> 
> I do understand your concerns.
> 
> Let me explain why I believe TC cls_bpf multiple independent programs
> have not seen much usage.
> 
> First of all the TC-tool is notorious difficult to use and configure (I
> admit, I struggle with this myself every single time). (The TC layer
> have some amazing features, like hash based lookup, that never get used
> due to this).

We do use cls_bpf heavily in Cilium, but I don't necessarily agree on
the notorious difficult to use aspect (at least for tc + BPF): i) this
is abstracted away from the /user/ entirely to the point that this is an
implementation detail he doesn't need to know about, ii) these days most
access to these hooks is done programmatically, if this is a worry, then
lets simply add a cls_bpf pendant for APIs like bpf_set_link_xdp_fd() we
have in libbpf where you only pass in ifindex, direction (ingress/egress)
and priority of the program so that underneath it sets up cls_act qdisc
with a cls_bpf instance that makes the whole thing foolproof, e.g.:

  int bpf_set_link_tc_fd(int ifindex, int fd, enum bpf_tc_dir dir,
                         __u32 priority, __u32 flags);

The flags could be similar to XDP: 0 or xxx_FLAGS_UPDATE_IF_NOEXIST and
xxx_FLAGS_HW_MODE. The problem that might be easy to miss via tc cmdline
tool is that when you don't specify explicit prio/handle upon tc replace,
then it auto-allocates one and keeps adding new programs instead of
replacing the old ones, but this quirk can be solved via API like above.

> Second, the multiple "independent programs", are actually not
> independent, because the current running program must return
> TC_ACT_UNSPEC to allow next bpf-prog to run.  Thus, it is not really
> usable.

I'd argue that unless the only thing you do in your debugging program is
to introspect (read-only) the packet at the current point, you'd run into
a similar coordination issue, meaning, the "independent programs" works
for simple cases where you only have ACCEPT and DROP policy, such that
you could run through all the programs and have precedence on DROP.

But once you have conflicting policies with regards to how these programs
mangle and redirect packets, how would you handle these? I'd argue it's
a non-trivial task to outsource if /admins/ are supposed to do manual
order adjustments and more importantly to troubleshoot issues due to
them. Potentially debugging hooks would make that easier to avoid
recompilation, but it's more of a developer task.

Often times orchestration tools i) assume they just own the data path
to reduce complexity in an already complex system and ii) also keep
'refreshing' their setup. One random example for the latter is k8s'
kube-proxy that reinstalls its iptables rules every x sec, in order to
make sure there was no manual messing around and to keep the data path
eventually consistent with the daemon view (if they got borked). How
would you make the loader aware of daemons automatically refreshing/
reconfiguring their BPF progs in the situation where admins changed
the pipeline, adding similar handle as tc so whoever does the 'chain'
assembly know which one to update?

> > Similarly cgroup-bpf had a ton discussions on proper multi-prog api.
> > Everyone was eventually convinced that it's flexible and generic.
> > Yet people who started to use it complain that it's missing features
> > to make it truly usable in production.
> 
> I've not looked at the cgroup-bpf multi-prog API, I guess we should to
> understand why this failed.
> 
> > Tracing is the only bit where multi-prog works.
> > Because kernel always runs all programs there.
> 
> This is important insight ("kernel always runs all programs").  A key
> part of Toke's design with chain-calling, is that the kernel always
> runs all the XDP/BPF-progs in the chain. Regardless of the XDP return
> value.  The next program in the chain, need info about previous
> BPF-prog return value, but it can choose to override this.
> 
> > If we could use PROG_RUN_ARRAY for XDP that could have been a solution.
> > But we cannot. Return codes matter for XDP.
> 
> The proposal from Toke, is to allow next-chain BPF-program can override
> the prev BPF-prog return value.  This part of the design, which I must
> admit is also the only option due to tail-calls.  But I do think it
> makes sense, because even if XDP_DROP is returned, then I can install
> another XDP-prog that does XDP_REDIRECT out another interface to an
> analyzer box, or into an AF_XDP based dump tool.

Thanks,
Daniel
