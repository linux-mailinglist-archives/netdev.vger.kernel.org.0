Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23D654E587
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377533AbiFPPA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377585AbiFPPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:00:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C456E3EB81;
        Thu, 16 Jun 2022 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655391622; x=1686927622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kV1H+VrXmd8vgp7hvdNx73Lpzuc5h2gYs0xrQ2ZUrY0=;
  b=ar8Sfe1EfLea0F1TCv/bsoVcu5ZTM8RXthjxgFOveTjgQNREwn3aqEkh
   9ZuxsqfTi0UTlovFitdm2/q0aRPfg5H7ILFvPFW26qTme15omDI/bdAgs
   my+HS2tY9FBu5chLPZWrp12lNS8DtVgrdR5rTBbpTRHXJjiijYB8AffLL
   mKqzLXBP5bCsbEA+SmMm4QYqy/uSApifXnasxe/5cqkGF+2V9ScAuNxit
   /sJKAcqMEsVPTqWOoNpD+UnFs0/RDYR7CShBrju3c12KNHhc3S7JyLPEX
   JnL1AmMbFShAaOM+eRITwhzGr33A9seOepYKlWaQeF9ayUa9OJG+xCYGf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="267954448"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="267954448"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:00:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="912191890"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2022 08:00:18 -0700
Date:   Thu, 16 Jun 2022 17:00:17 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Subject: Re: [RFC bpf] selftests/bpf: Curious case of a successful tailcall
 that returns to caller
Message-ID: <YqtFgYkUsM8VMWRy@boxer>
References: <20220616110252.418333-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616110252.418333-1-jakub@cloudflare.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 01:02:52PM +0200, Jakub Sitnicki wrote:
> While working aarch64 JIT to allow mixing bpf2bpf calls with tailcalls, I
> noticed unexpected tailcall behavior in x86 JIT.
> 
> I don't know if it is by design or a bug. The bpf_tail_call helper
> documentation says that the user should not expect the control flow to
> return to the previous program, if the tail call was successful:
> 
> > If the call succeeds, the kernel immediately runs the first
> > instruction of the new program. This is not a function call,
> > and it never returns to the previous program.
> 
> However, when a tailcall happens from a subprogram, that is after a bpf2bpf
> call, that is not the case. We return to the caller program because the
> stack destruction is too shallow. BPF stack of just the top-most BPF
> function gets destroyed.
> 
> This in turn allows the return value of the tailcall'ed program to get
> overwritten, as the test below test demonstrates. It currently fails on
> x86:

Disclaimer: some time has passed by since I looked into this :P

To me the bug would be if test would have returned 1 in your case. If I
recall correctly that was the design choice, so tailcalls when mixed with
bpf2bpf will consume current stack frame. When tailcall happens from
subprogram then we would return to the caller of this subprog. We added
logic to verifier that checks if this (tc + bpf2bpf) mix wouldn't cause
stack overflow. We even limit the stack frame size to 256 in such case.

Cilium docs explain this:
https://docs.cilium.io/en/latest/bpf/#bpf-to-bpf-calls

> 
> test_tailcall_bpf2bpf_7:PASS:open and load 0 nsec
> test_tailcall_bpf2bpf_7:PASS:entry prog fd 0 nsec
> test_tailcall_bpf2bpf_7:PASS:jmp_table map fd 0 nsec
> test_tailcall_bpf2bpf_7:PASS:classifier_0 prog fd 0 nsec
> test_tailcall_bpf2bpf_7:PASS:jmp_table map update 0 nsec
> test_tailcall_bpf2bpf_7:PASS:entry prog test run 0 nsec
> test_tailcall_bpf2bpf_7:FAIL:tailcall retval unexpected tailcall retval: actual 2 != expected 0
> test_tailcall_bpf2bpf_7:PASS:bss map fd 0 nsec
> test_tailcall_bpf2bpf_7:PASS:bss map lookup 0 nsec
> test_tailcall_bpf2bpf_7:PASS:done flag is set 0 nsec
> 
> If we step through the program, we can observe the flow as so:
> 
> int entry(struct __sk_buff * skb):
> bpf_prog_3bb007ac57240471_entry:
> ; subprog_tail(skb);
>    0:   nopl   0x0(%rax,%rax,1)
>    5:   xor    %eax,%eax
>    7:   push   %rbp
>    8:   mov    %rsp,%rbp
>    b:   push   %rax
>    c:   mov    -0x8(%rbp),%rax
>   13:   call   0x0000000000000048 ---------.
> ; return 2;                                |
>   18:   mov    $0x2,%eax <--------------------------------------.
>   1d:   leave                              |                    |
>   1e:   ret                                |                    |
>                                            |                    |
> int subprog_tail(struct __sk_buff * skb):  |                    |
> bpf_prog_3a140cef239a4b4f_F:               |                    |
> ; int subprog_tail(struct __sk_buff *skb)  |                    |
>    0:   nopl   0x0(%rax,%rax,1) <----------'                    |
>    5:   xchg   %ax,%ax                                          |
>    7:   push   %rbp                                             |
>    8:   mov    %rsp,%rbp                                        |
>    b:   push   %rax                                             |
>    c:   push   %rbx                                             |
>    d:   push   %r13                                             |
>    f:   mov    %rdi,%rbx                                        |
> ; asm volatile("r1 = %[ctx]\n\t"                                |
>   12:   movabs $0xffff888104119000,%r13                         |
>   1c:   mov    %rbx,%rdi                                        |
>   1f:   mov    %r13,%rsi                                        |
>   22:   xor    %edx,%edx                                        |
>   24:   mov    -0x4(%rbp),%eax                                  |
>   2a:   cmp    $0x21,%eax                                       |
>   2d:   jae    0x0000000000000046                               |
>   2f:   add    $0x1,%eax                                        |
>   32:   mov    %eax,-0x4(%rbp)                                  |
>   38:   jmp    0x0000000000000046 ---------------------------.  |
>   3d:   pop    %r13                                          |  |
>   3f:   pop    %rbx                                          |  |
>   40:   pop    %rax                                          |  |
>   41:   nopl   0x0(%rax,%rax,1)                              |  |
> ; return 1;                                                  |  |
>   46:   pop    %r13                                          |  |
>   48:   pop    %rbx                                          |  |
>   49:   leave                                                |  |
>   4a:   ret                                                  |  |
>                                                              |  |
> int classifier_0(struct __sk_buff * skb):                    |  |
> bpf_prog_6e664b22811ace0d_classifier_0:                      |  |
> ; done = 1;                                                  |  |
>    0:   nopl   0x0(%rax,%rax,1)                              |  |
>    5:   xchg   %ax,%ax                                       |  |
>    7:   push   %rbp                                          |  |
>    8:   mov    %rsp,%rbp                                     |  |
>    b:   movabs $0xffffc900000b6000,%rdi <--------------------'  |
>   15:   mov    $0x1,%esi                                        |
>   1a:   mov    %esi,0x0(%rdi)                                   |
> ; return 0;                                                     |
>   1d:   xor    %eax,%eax                                        |
>   1f:   leave                                                   |
>   20:   ret ----------------------------------------------------'
> 
> My question is - is it a bug or intended behavior that other JITs should
> replicate?
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/tailcalls.c      | 55 +++++++++++++++++++
>  .../selftests/bpf/progs/tailcall_bpf2bpf7.c   | 37 +++++++++++++
>  2 files changed, 92 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf7.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> index c4da87ec3ba4..696c307a1bee 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
> @@ -831,6 +831,59 @@ static void test_tailcall_bpf2bpf_4(bool noise)
>  	bpf_object__close(obj);
>  }
>  
> +#include "tailcall_bpf2bpf7.skel.h"
> +
> +/* The tail call should never return to the previous program, if the
> + * jump was successful.
> + */
> +static void test_tailcall_bpf2bpf_7(void)
> +{
> +	struct tailcall_bpf2bpf7 *obj;
> +	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
> +	LIBBPF_OPTS(bpf_test_run_opts, topts,
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.repeat = 1,
> +	);
> +
> +	obj = tailcall_bpf2bpf7__open_and_load();
> +	if (!ASSERT_OK_PTR(obj, "open and load"))
> +		return;
> +
> +	main_fd = bpf_program__fd(obj->progs.entry);
> +	if (!ASSERT_GE(main_fd, 0, "entry prog fd"))
> +		goto out;
> +
> +	map_fd = bpf_map__fd(obj->maps.jmp_table);
> +	if (!ASSERT_GE(map_fd, 0, "jmp_table map fd"))
> +		goto out;
> +
> +	prog_fd = bpf_program__fd(obj->progs.classifier_0);
> +	if (!ASSERT_GE(prog_fd, 0, "classifier_0 prog fd"))
> +		goto out;
> +
> +	i = 0;
> +	err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
> +	if (!ASSERT_OK(err, "jmp_table map update"))
> +		goto out;
> +
> +	err = bpf_prog_test_run_opts(main_fd, &topts);
> +	ASSERT_OK(err, "entry prog test run");
> +	ASSERT_EQ(topts.retval, 0, "tailcall retval");
> +
> +	data_fd = bpf_map__fd(obj->maps.bss);
> +	if (!ASSERT_GE(map_fd, 0, "bss map fd"))
> +		goto out;
> +
> +	i = 0;
> +	err = bpf_map_lookup_elem(data_fd, &i, &val);
> +	ASSERT_OK(err, "bss map lookup");
> +	ASSERT_EQ(val, 1, "done flag is set");
> +
> +out:
> +	tailcall_bpf2bpf7__destroy(obj);
> +}
> +
>  void test_tailcalls(void)
>  {
>  	if (test__start_subtest("tailcall_1"))
> @@ -855,4 +908,6 @@ void test_tailcalls(void)
>  		test_tailcall_bpf2bpf_4(false);
>  	if (test__start_subtest("tailcall_bpf2bpf_5"))
>  		test_tailcall_bpf2bpf_4(true);
> +	if (test__start_subtest("tailcall_bpf2bpf_7"))
> +		test_tailcall_bpf2bpf_7();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf7.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf7.c
> new file mode 100644
> index 000000000000..1be27cfa1702
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf7.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define __unused __attribute__((always_unused))
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(__u32));
> +	__uint(value_size, sizeof(__u32));
> +} jmp_table SEC(".maps");
> +
> +int done = 0;
> +
> +SEC("tc")
> +int classifier_0(struct __sk_buff *skb __unused)
> +{
> +	done = 1;
> +	return 0;
> +}
> +
> +static __noinline
> +int subprog_tail(struct __sk_buff *skb)
> +{
> +	bpf_tail_call_static(skb, &jmp_table, 0);
> +	return 1;
> +}
> +
> +SEC("tc")
> +int entry(struct __sk_buff *skb)
> +{
> +	subprog_tail(skb);
> +	return 2;
> +}
> +
> +char __license[] SEC("license") = "GPL";
> -- 
> 2.35.3
> 
