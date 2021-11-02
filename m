Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E803443775
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhKBUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhKBUqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 16:46:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FBFC061714;
        Tue,  2 Nov 2021 13:44:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mi0dS-0004AG-Aa; Tue, 02 Nov 2021 21:43:58 +0100
Date:   Tue, 2 Nov 2021 21:43:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 5/6] net: netfilter: Add unstable CT
 lookup helper for XDP and TC-BPF
Message-ID: <20211102204358.GC11415@breakpoint.cc>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211030144609.263572-6-memxor@gmail.com>
 <20211031191045.GA19266@breakpoint.cc>
 <87y2677j19.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2677j19.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > I tried to find a use case but I could not.
> > Entry will time out soon once packets stop appearing, so it can't be
> > used for stack bypass.  Is it for something else?  If so, what?
> 
> I think Maxim's use case was to implement a SYN proxy in XDP, where the
> XDP program just needs to answer the question "do I have state for this
> flow already". For TCP flows terminating on the local box this can be
> done via a socket lookup, but for a middlebox, a conntrack lookup is
> useful. Maxim, please correct me if I got your use case wrong.

Looked at
https://netdevconf.info/0x15/slides/30/Netdev%200x15%20Accelerating%20synproxy%20with%20XDP.pdf

seems thats right, its only a "does it exist".

> > For UDP it will work to let a packet pass through classic forward
> > path once in a while, but this will not work for tcp, depending
> > on conntrack settings (lose mode, liberal pickup etc. pp).
> 
> The idea is certainly to follow up with some kind of 'update' helper. At
> a minimum a "keep this entry alive" update, but potentially more
> complicated stuff as well. Details TBD, input welcome :)

Depends on use case.  For bypass infra I'd target the flowtable
infra rather than conntrack because it gets rid of the "early time out"
problem, plus you get the output interface/dst entry.

Not trivial for xdp because existing code assumes sk_buff.
But I think it can be refactored to allow raw buffers, similar
to flow dissector.

> >> +	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
> >
> > Ok, so default zone. Depending on meaning of "unstable helper" this
> > is ok and can be changed in incompatible way later.
> 
> I'm not sure about the meaning of "unstable" either, TBH, but in either
> case I'd rather avoid changing things if we don't have to, so I think
> adding the zone as an argument from the get-go may be better...

Another thing I just noted:
The above gives a nf_conn with incremented reference count.

For Maxims use case, thats unnecessary overhead. Existence can be
determined without reference increment.  The caveat is that the pointer
cannot be used after last rcu_read_unlock().
