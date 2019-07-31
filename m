Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C367BD2A
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 11:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbfGaJ3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 05:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfGaJ3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 05:29:30 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6F3358552A;
        Wed, 31 Jul 2019 09:29:29 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03B8A100032A;
        Wed, 31 Jul 2019 09:29:22 +0000 (UTC)
Date:   Wed, 31 Jul 2019 11:29:21 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load
 XDP
Message-ID: <20190731112818.79e767e4@carbon>
In-Reply-To: <20190731015238.3kq3r7rlascv7tzs@ast-mbp>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
        <20190730155915.5bbe3a03@cakuba.netronome.com>
        <20190730231754.efh3fj4mnsbv445l@ast-mbp>
        <20190730170725.279761e7@cakuba.netronome.com>
        <20190731002338.d4lp2grsmm3aaav3@ast-mbp>
        <20190730182144.1355bf50@cakuba.netronome.com>
        <20190731015238.3kq3r7rlascv7tzs@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 31 Jul 2019 09:29:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 18:52:40 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Jul 30, 2019 at 06:21:44PM -0700, Jakub Kicinski wrote:
> > > > Duplicating the same features in bpftool will only diminish the
> > > > incentive for moving iproute2 to libbpf.     
> > > 
> > > not at all. why do you think so?  
> > 
> > Because iproute2's BPF has fallen behind so the simplest thing is to
> > just contribute to bpftool. But iproute2 is the tool set for Linux
> > networking, we can't let it bit rot :(  
> 
> where were you when a lot of libbpf was copy pasted into iproute2 ?!
> Now it diverged a lot and it's difficult to move iproute2 back to the main
> train which is libbpf.

I hope we all agree that libbpf it the way forward.  I really hope we
can convert iproute2 into using libbpf.  It is challenging because
iproute2 ELF files use another map-layout, and I guess we need to stay
backward compatible.

> Same thing with at least 5 copy-pastes of samples/bpf/bpf_load.c
> that spawned a bunch of different bpf loaders.

I'm also to blame here... as I ran with bpf_load.c and based my
prototype-kernel github project on it.  And it seems that it have
gotten enough Google entropy, that people find that first. E.g. I have
pull requests that add new tools, which I have not merged, as I want to
switch to libbpf first.

Recently I've added a README[1] that warn about this issue, and point
people to xdp-tutorial[2] instead.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/README.rst
[2] https://github.com/xdp-project/xdp-tutorial

 Quote[1]:
   "WARNING: This directory contains its own out-of-date BPF
    ELF-loader (in bpf_load.c). Instead people should use libbpf."

> > IMHO vaguely competent users of Linux networking will know ip link.
> > If they are not vaguely competent, they should not attach XDP programs
> > to interfaces by hand...  
> 
> I'm a prime example of moderately competent linux user who
> doesn't know iproute2. I'm not joking.
> I don't know tc syntax and always use my cheat sheet of ip/tc commands
> to do anything.

I agree... I also need to lookup the TC commands used for attaching BPF
programs every time.  It is a pain, and I've often made mistakes that
cause several tc filter's to get attached, which leads to strange
behavior.  (AFAIK you have to remember to use both prio and handle when
removing the old, before adding the new).

 
> > > 
> > > bpftool must be able to introspect every aspect of bpf programming.
> > > That includes detaching and attaching anywhere.
> > > Anyone doing 'bpftool p s' should be able to switch off particular
> > > prog id without learning ten different other tools.  
> > 
> > I think the fact that we already have an implementation in iproute2,
> > which is at the risk of bit rot is more important to me that the
> > hypothetical scenario where everyone knows to just use bpftool (for
> > XDP, for TC it's still iproute2 unless there's someone crazy enough 
> > to reimplement the TC functionality :))  
> 
> I think you're missing the point that iproute2 is still necessary
> to configure it.
> bpftool should be able to attach/detach from anything.
> But configuring that thing (whether it's cgroup or tc/xdp) is
> a job of corresponding apis and tools.
> 
> > I'm not sure we can settle our differences over email :)
> > I have tremendous respect for all the maintainers I CCed here, 
> > if nobody steps up to agree with me I'll concede the bpftool net
> > battle entirely :)  
> 
> we can keep arguing forever. Respect to ease-of-use only comes
> from the pain of operational experience. I don't think I can
> convey that pain in the email either.

Let me try to convey some pain...

Regarding operational experience.  I have a customer using this:
 https://github.com/xdp-project/xdp-cpumap-tc

The project combines TC and XDP (with CPUMAP redirect).  It has been a
*HUGE* pain that we needed to use iproute2 tc commands to attach and
load TC BPF-programs.

(Issue#1)
The iproute2 tc BPF loader uses another ELF-layout for maps.  This was
worked around, by keeping XDP and TC BPF-progs in different C-file
using different struct's for maps.  And avoiding to use map features,
that iproute2 doesn't know about... although we found a workaround for
using more advanced map features via load-order and pinning see issue#3
sub-problem(2).

(Issue#2)
As this is a C-prog I would really prefer using a library, instead of
having to call cmdline utilities, see C-code doing this[3].  This lead
to several issues.  E.g. they had installed too old version of iproute2
on their systems, after installing newer version (in /usr/local) it was
not first in $PATH for root.  Load order also matters see issue#3.

[3] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/common_user.c#L381-L493

(Issue#3)
Next to get TC and XDP programs to cooperate, pinned maps via bpffs is
used.  And iproute2 dictates that pinned maps are located in directory
/sys/fs/bpf/tc/globals/.  What could go wrong, it's only a static dir path.

Sub-problem(1): If XDP loads _before_ any tc-bpf cmd, then the subdirs
are not created, leading to replicating mkdir creation in C[4].  Else
the XDP load will fail.  (Troubleshooting this was complicated by 

[4] https://github.com/xdp-project/xdp-cpumap-tc/commit/25e7e56699cd75a4a

Sub-problem(2): We really want to load XDP first, because libbpf
creates maps in a better way, e.g. with "name" (and BTF info).
The "name" part was needed by libbpf to find a given map (to avoid
depending on the order maps are defined in C/ELF file) via helper
bpf_object__find_map_fd_by_name().  To handle TC noname case, I had to
code up this workaround[5], which depend on extracting the name of the
pinned file name.

[5] https://github.com/xdp-project/xdp-cpumap-tc/blob/master/src/xdp_iphash_to_cpu_user.c#L117-L131


Experience/conclusion: Getting XDP and TC to cooperate suck, primarily
because iproute2 tc is based on a separate BPF-ELF loader, which is
features are not in sync / lacking behind.  Calling cmdline binaries
from C also sucks, and I would prefer some libbpf TC attach function,
but most pain comes from the slight differences between ELF-loaders.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
