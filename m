Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD24854A8
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240942AbiAEOdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:33:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240913AbiAEOdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:33:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77EC5B81B60;
        Wed,  5 Jan 2022 14:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76943C36AE9;
        Wed,  5 Jan 2022 14:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641393179;
        bh=Kw96vXcxJrrUVhwGqm3/YXrxz5qus1Y9+XKUh4pYQuA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c0+hVicSFx41Aoucb0+tNaX6sWkED4MZ/2ZzKItQ/6IJPrSkd3qgYANQO0NX2WqVf
         Lv+jMEhqvzBtivgBvMNNVA+5h1SSBW5idy8ai4f2/GfsBGFOMxCspgeCzLgTMIngJi
         sxV4lDMHUZbqyzCaW8pyRe6cLLgsh5LKSdRtpywk8QjUaBx6+TZzGiPc2t4rMsTTFO
         VnZbD6SmGFcKjJTpOKZX0ZAJ9UJpD6i2ZzF8EjIE96FeaqLAaV+rUFnMUG15zGftAv
         1ZBDnf4UxxthaUSd0F5w3SRVuIFTY9cDYMV1+SaIcsXkdbOYQK0eGb3maU9JGKphbq
         qzyfjzyVjG1JQ==
Date:   Wed, 5 Jan 2022 23:32:52 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/13] kprobe: Keep traced function address
Message-Id: <20220105233252.2bc92d14c42827328109d9d0@kernel.org>
In-Reply-To: <20220104080943.113249-3-jolsa@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <20220104080943.113249-3-jolsa@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Jan 2022 09:09:32 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> The bpf_get_func_ip_kprobe helper should return traced function
> address, but it's doing so only for kprobes that are placed on
> the function entry.
> 
> If kprobe is placed within the function, bpf_get_func_ip_kprobe
> returns that address instead of function entry.
> 
> Storing the function entry directly in kprobe object, so it could
> be used in bpf_get_func_ip_kprobe helper.

Hmm, please do this in bpf side, which should have some data structure
around the kprobe itself. Do not add this "specialized" field to
the kprobe data structure.

Thank you,

> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kprobes.h                              |  3 +++
>  kernel/kprobes.c                                     | 12 ++++++++++++
>  kernel/trace/bpf_trace.c                             |  2 +-
>  tools/testing/selftests/bpf/progs/get_func_ip_test.c |  4 ++--
>  4 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 8c8f7a4d93af..a204df4fef96 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -74,6 +74,9 @@ struct kprobe {
>  	/* Offset into the symbol */
>  	unsigned int offset;
>  
> +	/* traced function address */
> +	unsigned long func_addr;
> +
>  	/* Called before addr is executed. */
>  	kprobe_pre_handler_t pre_handler;
>  
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index d20ae8232835..c4060a8da050 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1310,6 +1310,7 @@ static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
>  	copy_kprobe(p, ap);
>  	flush_insn_slot(ap);
>  	ap->addr = p->addr;
> +	ap->func_addr = p->func_addr;
>  	ap->flags = p->flags & ~KPROBE_FLAG_OPTIMIZED;
>  	ap->pre_handler = aggr_pre_handler;
>  	/* We don't care the kprobe which has gone. */
> @@ -1588,6 +1589,16 @@ static int check_kprobe_address_safe(struct kprobe *p,
>  	return ret;
>  }
>  
> +static unsigned long resolve_func_addr(kprobe_opcode_t *addr)
> +{
> +	char str[KSYM_SYMBOL_LEN];
> +	unsigned long offset;
> +
> +	if (kallsyms_lookup((unsigned long) addr, NULL, &offset, NULL, str))
> +		return (unsigned long) addr - offset;
> +	return 0;
> +}
> +
>  int register_kprobe(struct kprobe *p)
>  {
>  	int ret;
> @@ -1600,6 +1611,7 @@ int register_kprobe(struct kprobe *p)
>  	if (IS_ERR(addr))
>  		return PTR_ERR(addr);
>  	p->addr = addr;
> +	p->func_addr = resolve_func_addr(addr);
>  
>  	ret = warn_kprobe_rereg(p);
>  	if (ret)
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 21aa30644219..25631253084a 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1026,7 +1026,7 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
>  {
>  	struct kprobe *kp = kprobe_running();
>  
> -	return kp ? (uintptr_t)kp->addr : 0;
> +	return kp ? (uintptr_t)kp->func_addr : 0;
>  }
>  
>  static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> index a587aeca5ae0..e988aefa567e 100644
> --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> @@ -69,7 +69,7 @@ int test6(struct pt_regs *ctx)
>  {
>  	__u64 addr = bpf_get_func_ip(ctx);
>  
> -	test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> +	test6_result = (const void *) addr == &bpf_fentry_test6;
>  	return 0;
>  }
>  
> @@ -79,6 +79,6 @@ int test7(struct pt_regs *ctx)
>  {
>  	__u64 addr = bpf_get_func_ip(ctx);
>  
> -	test7_result = (const void *) addr == &bpf_fentry_test7 + 5;
> +	test7_result = (const void *) addr == &bpf_fentry_test7;
>  	return 0;
>  }
> -- 
> 2.33.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
