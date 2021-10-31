Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEC9441065
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 20:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhJaTN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 15:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhJaTN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 15:13:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87633C061570;
        Sun, 31 Oct 2021 12:10:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mhGE9-00013B-JV; Sun, 31 Oct 2021 20:10:45 +0100
Date:   Sun, 31 Oct 2021 20:10:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 5/6] net: netfilter: Add unstable CT
 lookup helper for XDP and TC-BPF
Message-ID: <20211031191045.GA19266@breakpoint.cc>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211030144609.263572-6-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030144609.263572-6-memxor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> This change adds conntrack lookup helpers using the unstable kfunc call
> interface for the XDP and TC-BPF hooks.
> 
> Also add acquire/release functions (randomly returning NULL), and also
> exercise the RET_PTR_TO_BTF_ID_OR_NULL path so that BPF program caller
> has to check for NULL before dereferencing the pointer, for the TC hook.
> These will be used in selftest.
> 
> Export get_net_ns_by_id and btf_type_by_id as nf_conntrack needs to call
> them.

It would be good to get a summary on how this is useful.

I tried to find a use case but I could not.
Entry will time out soon once packets stop appearing, so it can't be
used for stack bypass.  Is it for something else?  If so, what?

For UDP it will work to let a packet pass through classic forward
path once in a while, but this will not work for tcp, depending
on conntrack settings (lose mode, liberal pickup etc. pp).

> +/* Unstable Kernel Helpers for XDP hook */
> +static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
> +					  struct bpf_sock_tuple *bpf_tuple,
> +					  u32 tuple_len, u8 protonum,
> +					  u64 netns_id, u64 flags)
> +{
> +	struct nf_conntrack_tuple_hash *hash;
> +	struct nf_conntrack_tuple tuple;
> +
> +	if (flags != IP_CT_DIR_ORIGINAL && flags != IP_CT_DIR_REPLY)
> +		return ERR_PTR(-EINVAL);

The flags argument is not needed.

> +	tuple.dst.dir = flags;

.dir can be 0, its not used by nf_conntrack_find_get().

> +	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);

Ok, so default zone. Depending on meaning of "unstable helper" this
is ok and can be changed in incompatible way later.
