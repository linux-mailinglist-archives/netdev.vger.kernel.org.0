Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281ED3E2E1E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhHFQHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 12:07:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:48628 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhHFQHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 12:07:19 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mC2NB-0005KG-W4; Fri, 06 Aug 2021 18:07:02 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mC2NB-000Trc-Pk; Fri, 06 Aug 2021 18:07:01 +0200
Subject: Re: [PATCH bpf-next 4/4] bpf: selftests: Add dctcp fallback test
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20210805050119.1349009-1-kafai@fb.com>
 <20210805050144.1352078-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <217393dd-9af6-7e5c-3a02-630dde4b1280@iogearbox.net>
Date:   Fri, 6 Aug 2021 18:07:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210805050144.1352078-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26255/Fri Aug  6 10:24:06 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 7:01 AM, Martin KaFai Lau wrote:
> This patch makes the bpf_dctcp test to fallback to cubic by
> using setsockopt(TCP_CONGESTION) when the tcp flow is not
> ecn ready.
> 
> It also checks setsockopt() is not available to release().
> 
> The settimeo() from the network_helpers.h is used, so the local
> one is removed.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
[...]
> diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> index fd42247da8b4..48df7ffbefdb 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> @@ -17,6 +17,9 @@
>   
>   char _license[] SEC("license") = "GPL";
>   
> +volatile const char fallback[TCP_CA_NAME_MAX];
> +const char bpf_dctcp[] = "bpf_dctcp";
> +char cc_res[TCP_CA_NAME_MAX];
>   int stg_result = 0;
>   
>   struct {
> @@ -57,6 +60,23 @@ void BPF_PROG(dctcp_init, struct sock *sk)
>   	struct dctcp *ca = inet_csk_ca(sk);
>   	int *stg;
>   
> +	if (!(tp->ecn_flags & TCP_ECN_OK) && fallback[0]) {
> +		/* Switch to fallback */
> +		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> +			       (void *)fallback, sizeof(fallback));
> +		/* Switch back to myself which the bpf trampoline
> +		 * stopped calling dctcp_init recursively.
> +		 */
> +		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> +			       (void *)bpf_dctcp, sizeof(bpf_dctcp));
> +		/* Switch back to fallback */
> +		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> +			       (void *)fallback, sizeof(fallback));
> +		bpf_getsockopt(sk, SOL_TCP, TCP_CONGESTION,
> +			       (void *)cc_res, sizeof(cc_res));
> +		return;

Is there a possibility where we later on instead of return refetch ca ptr via
ca = inet_csk_ca(sk) and mangle its struct dctcp fields whereas we're actually
messing with the new ca's internal fields (potentially crashing the kernel e.g.
if there was a pointer in the private struct of the new ca that we'd be corrupting)?

> +	}
> +
>   	ca->prior_rcv_nxt = tp->rcv_nxt;
>   	ca->dctcp_alpha = min(dctcp_alpha_on_init, DCTCP_MAX_ALPHA);
>   	ca->loss_cwnd = 0;
> diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp_release.c b/tools/testing/selftests/bpf/progs/bpf_dctcp_release.c
> new file mode 100644
> index 000000000000..d836f7c372f0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_dctcp_release.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2021 Facebook */
> +
> +#include <stddef.h>
> +#include <linux/bpf.h>
> +#include <linux/types.h>
> +#include <linux/stddef.h>
> +#include <linux/tcp.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include "bpf_tcp_helpers.h"
> +
> +char _license[] SEC("license") = "GPL";
> +const char cubic[] = "cubic";
> +
> +void BPF_STRUCT_OPS(dctcp_nouse_release, struct sock *sk)
> +{
> +	bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> +		       (void *)cubic, sizeof(cubic));
> +}
> +
> +SEC(".struct_ops")
> +struct tcp_congestion_ops dctcp_rel = {
> +	.release	= (void *)dctcp_nouse_release,
> +	.name		= "bpf_dctcp_rel",
> +};
> 

