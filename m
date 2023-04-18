Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F566E6581
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjDRNKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjDRNKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:10:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27527132;
        Tue, 18 Apr 2023 06:10:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pol6g-0004ED-Ef; Tue, 18 Apr 2023 15:10:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <bpf@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de, Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next v3 0/6] bpf: add netfilter program type
Date:   Tue, 18 Apr 2023 15:10:32 +0200
Message-Id: <20230418131038.18054-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add minimal support to hook bpf programs to netfilter hooks, e.g.
PREROUTING or FORWARD.

For this the most relevant parts for registering a netfilter
hook via the in-kernel api are exposed to userspace via bpf_link.

The new program type is 'tracing style', i.e. there is no context
access rewrite done by verifier, the function argument (struct bpf_nf_ctx)
isn't stable.
There is no support for direct packet access, dynptr api should be used
instead.

With this its possible to build a small test program such as:

 #include "vmlinux.h"
extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
                               struct bpf_dynptr *ptr__uninit) __ksym;
extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, uint32_t offset,
                                   void *buffer, uint32_t buffer__sz) __ksym;
SEC("netfilter")
int nf_test(struct bpf_nf_ctx *ctx)
{
	struct nf_hook_state *state = ctx->state;
	struct sk_buff *skb = ctx->skb;
	const struct iphdr *iph, _iph;
	const struct tcphdr *th, _th;
	struct bpf_dynptr ptr;

	if (bpf_dynptr_from_skb(skb, 0, &ptr))
		return NF_DROP;

	iph = bpf_dynptr_slice(&ptr, 0, &_iph, sizeof(_iph));
	if (!iph)
		return NF_DROP;

	th = bpf_dynptr_slice(&ptr, iph->ihl << 2, &_th, sizeof(_th));
	if (!th)
		return NF_DROP;

	bpf_printk("accept %x:%d->%x:%d, hook %d ifin %d\n", iph->saddr, bpf_ntohs(th->source), iph->daddr, bpf_ntohs(th->dest), state->hook, state->in->ifindex);
        return NF_ACCEPT;
}

Then, tail /sys/kernel/tracing/trace_pipe.

Changes since v2:
1. don't WARN when user calls 'bpftool loink detach' twice
   restrict attachment to ip+ip6 families, lets relax this
   later in case arp/bridge/netdev are needed too.
2. show netfilter links in 'bpftool net' output as well.

Changes since v1:
1. Don't fail to link when CONFIG_NETFILTER=n (build bot)
2. Use test_progs instead of test_verifier (Alexei)

Changes since last RFC version:
1. extend 'bpftool link show' to print prio/hooknum etc
2. extend 'nft list hooks' so it can print the bpf program id
3. Add an extra patch to artificially restrict bpf progs with
   same priority.  Its fine from a technical pov but it will
   cause ordering issues (most recent one comes first).
   Can be removed later.
4. Add test_run support for netfilter prog type and a small
   extension to verifier tests to make sure we can't return
   verdicts like NF_STOLEN.
5. Alter the netfilter part of the bpf_link uapi struct:
   - add flags/reserved members.
  Not used here except returning errors when they are nonzero.
  Plan is to allow the bpf_link users to enable netfilter
  defrag or conntrack engine by setting feature flags at
  link create time in the future.

Let me know if there is anything missing that has to be addressed
before this can be merged.

Florian Westphal (6):
  bpf: add bpf_link support for BPF_NETFILTER programs
  bpf: minimal support for programs hooked into netfilter framework
  netfilter: nfnetlink hook: dump bpf prog id
  netfilter: disallow bpf hook attachment at same priority
  tools: bpftool: print netfilter link info
  bpf: add test_run support for netfilter program type

 include/linux/bpf.h                           |   3 +
 include/linux/bpf_types.h                     |   4 +
 include/linux/netfilter.h                     |   1 +
 include/net/netfilter/nf_bpf_link.h           |  15 ++
 include/uapi/linux/bpf.h                      |  15 ++
 include/uapi/linux/netfilter/nfnetlink_hook.h |  20 +-
 kernel/bpf/btf.c                              |   6 +
 kernel/bpf/syscall.c                          |   6 +
 kernel/bpf/verifier.c                         |   3 +
 net/bpf/test_run.c                            | 140 +++++++++++
 net/core/filter.c                             |   1 +
 net/netfilter/Kconfig                         |   3 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/core.c                          |  12 +
 net/netfilter/nf_bpf_link.c                   | 229 ++++++++++++++++++
 net/netfilter/nfnetlink_hook.c                |  81 ++++++-
 tools/bpf/bpftool/link.c                      |  83 +++++++
 tools/bpf/bpftool/main.h                      |   3 +
 tools/bpf/bpftool/net.c                       | 105 ++++++++
 tools/include/uapi/linux/bpf.h                |  15 ++
 tools/lib/bpf/libbpf.c                        |   2 +
 .../selftests/bpf/prog_tests/verifier.c       |   2 +
 .../bpf/progs/verifier_netfilter_retcode.c    |  49 ++++
 23 files changed, 785 insertions(+), 14 deletions(-)
 create mode 100644 include/net/netfilter/nf_bpf_link.h
 create mode 100644 net/netfilter/nf_bpf_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c

-- 
2.39.2

