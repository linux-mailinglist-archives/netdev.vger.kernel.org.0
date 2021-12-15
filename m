Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05A44766BD
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhLOXuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:50:05 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56732 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhLOXuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:50:04 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EE160607E0;
        Thu, 16 Dec 2021 00:47:33 +0100 (CET)
Date:   Thu, 16 Dec 2021 00:49:59 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 7/9] net/netfilter: Add unstable CT lookup
 helpers for XDP and TC-BPF
Message-ID: <Ybp/J5KXn0hLT4DZ@salvia>
References: <20211210130230.4128676-1-memxor@gmail.com>
 <20211210130230.4128676-8-memxor@gmail.com>
 <YbNtmlaeqPuHHRgl@salvia>
 <20211210153129.srb6p2ebzhl5yyzh@apollo.legion>
 <YbPcxjdsdqepEQAJ@salvia>
 <87pmq3ugz5.fsf@toke.dk>
 <YbT5DEmlkunw7cCo@salvia>
 <87tufcyz72.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tufcyz72.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 10:25:37PM +0100, Toke Høiland-Jørgensen wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > On Sat, Dec 11, 2021 at 07:35:58PM +0100, Toke Høiland-Jørgensen wrote:
> >> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> >> 
> >> > On Fri, Dec 10, 2021 at 09:01:29PM +0530, Kumar Kartikeya Dwivedi wrote:
> >> >> On Fri, Dec 10, 2021 at 08:39:14PM IST, Pablo Neira Ayuso wrote:
> >> >> > On Fri, Dec 10, 2021 at 06:32:28PM +0530, Kumar Kartikeya Dwivedi wrote:
> >> >> > [...]
> >> >> > >  net/netfilter/nf_conntrack_core.c | 252 ++++++++++++++++++++++++++++++
> >> >> > >  7 files changed, 497 insertions(+), 1 deletion(-)
> >> >> > >
> >> >> > [...]
> >> >> > > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> >> >> > > index 770a63103c7a..85042cb6f82e 100644
> >> >> > > --- a/net/netfilter/nf_conntrack_core.c
> >> >> > > +++ b/net/netfilter/nf_conntrack_core.c
> >> >> >
> >> >> > Please, keep this new code away from net/netfilter/nf_conntrack_core.c
> >> >> 
> >> >> Ok. Can it be a new file under net/netfilter, or should it live elsewhere?
> >> >
> >> > IPVS and OVS use conntrack for already quite a bit of time and they
> >> > keep their code in their respective folders.
> >> 
> >> Those are users, though.
> >
> > OK, I see this as a yet user of the conntrack infrastructure.
> 
> The users are the BPF programs; this series adds the exports. I.e., the
> code defines an API that BPF programs can hook into, and implements the
> validation and lifetime enforcement that is necessary for the particular
> data structures being exposed. This is very much something that the
> module doing the exports should be concerned with, so from that
> perspective it makes sense to keep it in the nf_conntrack kmod.

Thanks for explaining.

> >> This is adding a different set of exported functions, like a BPF
> >> version of EXPORT_SYMBOL(). We don't put those outside the module
> >> where the code lives either...
> >
> > OVS and IPVS uses Kconfig to enable the conntrack module as a
> > dependency. Then, add module that is loaded when conntrack is used.
> 
> BPF can't do that, though: all the core BPF code is always built into
> the kernel, so we can't have any dependencies on module code. Until now,
> this has meant that hooking into modules has been out of scope for BPF
> entirely. With kfuncs and the module BTF support this is now possible,
> but it's a bit "weird" (i.e., different) compared to what we're used to
> with kernel modules.

OK.

> This series represents the first instance of actually implementing BPF
> hooks into a module, BTW, so opinions on how to do it best are
> absolutely welcome. But I have a hard time seeing how this could be done
> without introducing *any* new code into the conntrack module...

OK, move on then and let's take the time to revisit.

Thanks.
