Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4266DFA98
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjDLPwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjDLPwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:52:34 -0400
X-Greylist: delayed 26566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 08:52:31 PDT
Received: from 4.mo545.mail-out.ovh.net (4.mo545.mail-out.ovh.net [46.105.45.191])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAD19F
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:52:31 -0700 (PDT)
Received: from ex4.mail.ovh.net (unknown [10.108.16.154])
        by mo545.mail-out.ovh.net (Postfix) with ESMTPS id 1DD8624FA9;
        Wed, 12 Apr 2023 08:20:10 +0000 (UTC)
Received: from [192.168.1.125] (93.21.160.242) by DAG10EX1.indiv4.local
 (172.16.2.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.23; Wed, 12 Apr
 2023 10:20:10 +0200
Message-ID: <7d97222a-36c1-ee77-4ad6-d8d2c6056d4c@naccy.de>
Date:   Wed, 12 Apr 2023 10:20:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 0/6] bpf: add netfilter program type
To:     Florian Westphal <fw@strlen.de>, <netdev@vger.kernel.org>
CC:     <netfilter-devel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dxu@dxuuu.xyz>
References: <20230405161116.13565-1-fw@strlen.de>
Content-Language: en-US
From:   Quentin Deslandes <qde@naccy.de>
In-Reply-To: <20230405161116.13565-1-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [93.21.160.242]
X-ClientProxiedBy: CAS9.indiv4.local (172.16.1.9) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 7618683196916231790
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekiedgtdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttddvjeenucfhrhhomhepsfhuvghnthhinhcuffgvshhlrghnuggvshcuoehquggvsehnrggttgihrdguvgeqnecuggftrfgrthhtvghrnheptdfgveetgfetkeejvefhudeiueeufeeffeeitdffjeevudehveejveegffdvkeefnecukfhppeduvdejrddtrddtrddupdelfedrvddurdduiedtrddvgedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeoqhguvgesnhgrtggthidruggvqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehffiesshhtrhhlvghnrdguvgdpnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhnvghtfhhilhhtvghrqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgugihusegugihuuhhurdighiiipdfovfetjfhoshhtpehmohehgeehpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04/2023 18:11, Florian Westphal wrote:
> Add minimal support to hook bpf programs to netfilter hooks, e.g.
> PREROUTING or FORWARD.
> 
> For this the most relevant parts for registering a netfilter
> hook via the in-kernel api are exposed to userspace via bpf_link.
> 
> The new program type is 'tracing style', i.e. there is no context
> access rewrite done by verifier, the function argument (struct bpf_nf_ctx)
> isn't stable.
> There is no support for direct packet access, dynptr api should be used
> instead.

Does this mean the verifier will reject any program accessing ctx->skb
(e.g. ctx->skb + X)?

> With this its possible to build a small test program such as:
> 
>  #include "vmlinux.h"
> extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
>                                struct bpf_dynptr *ptr__uninit) __ksym;
> extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, uint32_t offset,
>                                    void *buffer, uint32_t buffer__sz) __ksym;
> SEC("netfilter")
> int nf_test(struct bpf_nf_ctx *ctx)
> {
> 	struct nf_hook_state *state = ctx->state;
> 	struct sk_buff *skb = ctx->skb;
> 	const struct iphdr *iph, _iph;
> 	const struct tcphdr *th, _th;
> 	struct bpf_dynptr ptr;
> 
> 	if (bpf_dynptr_from_skb(skb, 0, &ptr))
> 		return NF_DROP;
> 
> 	iph = bpf_dynptr_slice(&ptr, 0, &_iph, sizeof(_iph));
> 	if (!iph)
> 		return NF_DROP;
> 
> 	th = bpf_dynptr_slice(&ptr, iph->ihl << 2, &_th, sizeof(_th));
> 	if (!th)
> 		return NF_DROP;
> 
> 	bpf_printk("accept %x:%d->%x:%d, hook %d ifin %d\n", iph->saddr, bpf_ntohs(th->source), iph->daddr, bpf_ntohs(th->dest), state->hook, state->in->ifindex);
>         return NF_ACCEPT;
> }
> 
> Then, tail /sys/kernel/tracing/trace_pipe.
> 
> Changes since last RFC version:
> 1. extend 'bpftool link show' to print prio/hooknum etc
> 2. extend 'nft list hooks' so it can print the bpf program id
> 3. Add an extra patch to artificially restrict bpf progs with
>    same priority.  Its fine from a technical pov but it will
>    cause ordering issues (most recent one comes first).
>    Can be removed later.
> 4. Add test_run support for netfilter prog type and a small
>    extension to verifier tests to make sure we can't return
>    verdicts like NF_STOLEN.
> 5. Alter the netfilter part of the bpf_link uapi struct:
>    - add flags/reserved members.
>   Not used here except returning errors when they are nonzero.
>   Plan is to allow the bpf_link users to enable netfilter
>   defrag or conntrack engine by setting feature flags at
>   link create time in the future.
> 
> Let me know if there is anything missing that has to be addressed
> before this can be merged.
> 
> Thanks!
> 
> Florian Westphal (6):
>   bpf: add bpf_link support for BPF_NETFILTER programs
>   bpf: minimal support for programs hooked into netfilter framework
>   netfilter: nfnetlink hook: dump bpf prog id
>   netfilter: disallow bpf hook attachment at same priority
>   tools: bpftool: print netfilter link info
>   bpf: add test_run support for netfilter program type
> 
>  include/linux/bpf.h                           |   3 +
>  include/linux/bpf_types.h                     |   4 +
>  include/linux/netfilter.h                     |   1 +
>  include/net/netfilter/nf_bpf_link.h           |   8 +
>  include/uapi/linux/bpf.h                      |  15 ++
>  include/uapi/linux/netfilter/nfnetlink_hook.h |  20 +-
>  kernel/bpf/btf.c                              |   6 +
>  kernel/bpf/syscall.c                          |   6 +
>  kernel/bpf/verifier.c                         |   3 +
>  net/bpf/test_run.c                            | 143 +++++++++++++
>  net/core/filter.c                             |   1 +
>  net/netfilter/Kconfig                         |   3 +
>  net/netfilter/Makefile                        |   1 +
>  net/netfilter/core.c                          |  12 ++
>  net/netfilter/nf_bpf_link.c                   | 190 ++++++++++++++++++
>  net/netfilter/nfnetlink_hook.c                |  81 ++++++--
>  tools/bpf/bpftool/link.c                      |  24 +++
>  tools/include/uapi/linux/bpf.h                |  15 ++
>  tools/lib/bpf/libbpf.c                        |   1 +
>  .../selftests/bpf/verifier/netfilter.c        |  23 +++
>  20 files changed, 546 insertions(+), 14 deletions(-)
>  create mode 100644 include/net/netfilter/nf_bpf_link.h
>  create mode 100644 net/netfilter/nf_bpf_link.c
>  create mode 100644 tools/testing/selftests/bpf/verifier/netfilter.c
> 

