Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB2478610
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhLQISZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:18:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60398 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhLQISY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:18:24 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C844C607E0;
        Fri, 17 Dec 2021 09:15:52 +0100 (CET)
Date:   Fri, 17 Dec 2021 09:18:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 07/10] net/netfilter: Add unstable CT lookup
 helpers for XDP and TC-BPF
Message-ID: <YbxHy7yLwMQ7L0mN@salvia>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-8-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211217015031.1278167-8-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 07:20:28AM +0530, Kumar Kartikeya Dwivedi wrote:
> This change adds conntrack lookup helpers using the unstable kfunc call
> interface for the XDP and TC-BPF hooks. The primary usecase is
> implementing a synproxy in XDP, see Maxim's patchset at [0].
> 
> Export get_net_ns_by_id as nf_conntrack needs to call it.
> 
> Note that we search for acquire, release, and null returning kfuncs in
> the intersection of those sets and main set.
> 
> This implies that the kfunc_btf_id_list acq_set, rel_set, null_set may
> contain BTF ID not in main set, this is explicitly allowed and
> recommended (to save on definining more and more sets), since
> check_kfunc_call verifier operation would filter out the invalid BTF ID
> fairly early, so later checks for acquire, release, and ret_type_null
> kfunc will only consider allowed BTF IDs for that program that are
> allowed in main set. This is why the nf_conntrack_acq_ids set has BTF
> IDs for both xdp and tc hook kfuncs.
> 
>   [0]: https://lore.kernel.org/bpf/20211019144655.3483197-1-maximmi@nvidia.com
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/btf.h               |   2 +
>  kernel/bpf/btf.c                  |   1 +
>  net/core/filter.c                 |  24 +++
>  net/core/net_namespace.c          |   1 +
>  net/netfilter/nf_conntrack_core.c | 278 ++++++++++++++++++++++++++++++

Toke proposed to move it to net/netfilter/nf_conntrack_bpf.c
