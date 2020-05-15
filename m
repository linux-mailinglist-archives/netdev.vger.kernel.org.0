Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1A01D4D81
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 14:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgEOMMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 08:12:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:40100 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgEOMMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 08:12:38 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZZCd-0003lK-QM; Fri, 15 May 2020 14:12:35 +0200
Date:   Fri, 15 May 2020 14:12:35 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next] bpf, bpftool: Allow probing for CONFIG_HZ from
 kernel config
Message-ID: <20200515121235.GA7407@pc-9.home>
References: <20200513075849.20868-1-daniel@iogearbox.net>
 <CAEf4BzYfgXSOPmi6B23=rKgUge77g+tg=jJ9jwgZ48Co1nSViA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYfgXSOPmi6B23=rKgUge77g+tg=jJ9jwgZ48Co1nSViA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25812/Thu May 14 14:13:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 04:19:41PM -0700, Andrii Nakryiko wrote:
> On Wed, May 13, 2020 at 1:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > In Cilium we've recently switched to make use of bpf_jiffies64() for
> > parts of our tc and XDP datapath since bpf_ktime_get_ns() is more
> > expensive and high-precision is not needed for our timeouts we have
> > anyway. Our agent has a probe manager which picks up the json of
> > bpftool's feature probe and we also use the macro output in our C
> > programs e.g. to have workarounds when helpers are not available on
> > older kernels.
> >
> > Extend the kernel config info dump to also include the kernel's
> > CONFIG_HZ, and rework the probe_kernel_image_config() for allowing a
> > macro dump such that CONFIG_HZ can be propagated to BPF C code as a
> > simple define if available via config. Latter allows to have _compile-
> > time_ resolution of jiffies <-> sec conversion in our code since all
> > are propagated as known constants.
> >
> > Given we cannot generally assume availability of kconfig everywhere,
> > we also have a kernel hz probe [0] as a fallback. Potentially, bpftool
> > could have an integrated probe fallback as well, although to derive it,
> > we might need to place it under 'bpftool feature probe full' or similar
> > given it would slow down the probing process overall. Yet 'full' doesn't
> > fit either for us since we don't want to pollute the kernel log with
> > warning messages from bpf_probe_write_user() and bpf_trace_printk() on
> > agent startup; I've left it out for the time being.
> >
> >   [0] https://github.com/cilium/cilium/blob/master/bpf/cilium-probe-kernel-hz.c
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > ---
> 
> libbpf supports kconfig values, so don't have to even probe for that,
> it will just appear as a constant global variable:
> 
> extern unsigned long CONFIG_HZ __kconfig;
> 
> But I assume you want this for iproute2 case, which doesn't support
> this, right? We really should try to make iproute2 just use libbpf as

It's one but not the only reason. Our golang daemon picks up the json config
from `bpftool feature -j` and based on that we decide which features our BPF
datapath will have where the daemons needs to also adapt accordingly. So for
users running older kernels we need fallback behavior in our daemon, for
example, in case of missing LPM delete or get_next_key from syscall side the
LPM map management and/or program regeneration will differ in the agent. In
case of jiffies, it's also not as trivial from control plane side, e.g.
existing deployments cannot simply switch from ktime to jiffies during upgrade
while traffic is live in the datapath given this has upgrade and downgrade
implications on timeouts. However, we can switch to using it for new deployments
via helm. In that case, the agent today probes for availability, so it needs
to know i) whether the underlying kernel supports jiffies64 helper, ii) it needs
to know the kernel hz value in order to convert timeouts for our CT's GC. This
is done based on bpftool feature -j from the agent's probe manager. Next, we
also cannot assume general availability of an existing .config from distro side,
so in that case we run the probe to determine kernel hz and emit the CONFIG_HZ
define instead, and if all breaks down we fall back to using ktime in our data
path. From the macro side, the timeouts all resolve nicely during compilation
time since everything is passed as a constant here. We have a small helper for
bpf_jiffies_to_sec() and bpf_sec_to_jiffies() that resolves it whereas `extern
unsigned long CONFIG_HZ __kconfig` hapens at load time plus relies on the fact
that config must be available, although the latter could probably be fixed via
user-callback.

> a loader with all the libbpf features available. I think all (at least
> all major ones) features needed are already there in libbpf, iproute2
> would just need to implement custom support for old-style map
> definitions and maybe something else, not sure. I wonder if any of
> iproute2/BPF users willing to spend some effort on this?

Right, my main concern are all the behavioral subtleties where things could
break on our side e.g. debugging something like [0] is not fun, but I might
eventually do it, at least it's on my list. I recently converted our LB to
be compileable and loadable from both tc as well as XDP side and I'm in the
process of optimizing the BPF side further. So I found myself annoyed enough
that `bpftool prog profile` doesn't work. ;) Lack of BTF - the iproute2 lib
does load BTF [1], but it broke with newer LLVM versions (we ship clang-10
these days). So yeah, either fixing the BTF handling for getting `bpftool
prog profile` working or investing the cycles to move iproute2 finally to
libbpf along with our entire datapath. It's still an intermediate step as
long-term we would love to handle everything native from golang via cilium/ebpf
library to avoid shelling out, but it would allow for opening usage of other
features in the meantime and latter might still be further out. One of the
things that is still not clear yet to me is the global data handling and how
to have a clean solution for both old kernels that don't have BPF global data
support and new ones that have it. Our iproute2 version uses the bpf_apply_relo_glob()
variant [2] which we discussed longer time ago at plumbers and while a hack,
it solved the use-case of avoiding to invoke the compiler for every regeneration
even on old kernels down to 4.9 [3] where BPF global data is not available of
course. Tricky, but maybe there is some low-overhead solution we could add to
libbpf that would resolve it under the hood, or worst case just inline asm ...

  [0] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=e4c4685fd6e4afd3e9b6818c96fded371f350a3f
  [1] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=f823f36012fb5ab4ddfca6ed4ff56188730f281e
  [2] https://github.com/cilium/iproute2/blob/static-data/lib/bpf.c#L2525
  [3] https://cilium.io/blog/2019/04/24/cilium-15#BpfTemplating

> >  tools/bpf/bpftool/feature.c | 120 ++++++++++++++++++++----------------
> >  1 file changed, 67 insertions(+), 53 deletions(-)
> >
> 
> [...]

Thanks,
Daniel
