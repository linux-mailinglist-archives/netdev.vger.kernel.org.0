Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19373131BDC
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgAFWwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:52:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:45328 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFWwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:52:20 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iobEQ-0004FY-5m; Mon, 06 Jan 2020 23:52:18 +0100
Received: from [178.197.249.51] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iobEP-000Cny-Q7; Mon, 06 Jan 2020 23:52:17 +0100
Subject: Re: [PATCH bpf-next 1/2] libbpf: Add probe for large INSN limit
To:     Michal Rostecki <mrostecki@suse.de>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191227110605.1757-1-mrostecki@suse.de>
 <20191227110605.1757-2-mrostecki@suse.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aa996612-7ba5-ef76-6f22-112fe1d7b278@iogearbox.net>
Date:   Mon, 6 Jan 2020 23:52:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191227110605.1757-2-mrostecki@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25686/Mon Jan  6 10:55:07 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/19 12:06 PM, Michal Rostecki wrote:
> Introduce a new probe which checks whether kernel has large maximum
> program size (1M) which was increased in commit c04c0d2b968a ("bpf:
> increase complexity limit and maximum program size").
> 
> Based on the similar check in Cilium[0], authored by Daniel Borkmann.
> 
> [0] https://github.com/cilium/cilium/commit/657d0f585afd26232cfa5d4e70b6f64d2ea91596
> 
> Co-authored-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Michal Rostecki <mrostecki@suse.de>
> ---
>   tools/lib/bpf/libbpf.h        |  1 +
>   tools/lib/bpf/libbpf.map      |  1 +
>   tools/lib/bpf/libbpf_probes.c | 23 +++++++++++++++++++++++
>   3 files changed, 25 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index fe592ef48f1b..26bf539f1b3c 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -521,6 +521,7 @@ LIBBPF_API bool bpf_probe_prog_type(enum bpf_prog_type prog_type,
>   LIBBPF_API bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex);
>   LIBBPF_API bool bpf_probe_helper(enum bpf_func_id id,
>   				 enum bpf_prog_type prog_type, __u32 ifindex);
> +LIBBPF_API bool bpf_probe_large_insn_limit(__u32 ifindex);
>   
>   /*
>    * Get bpf_prog_info in continuous memory
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index e9713a574243..b300d74c921a 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -219,6 +219,7 @@ LIBBPF_0.0.7 {
>   		bpf_object__detach_skeleton;
>   		bpf_object__load_skeleton;
>   		bpf_object__open_skeleton;
> +		bpf_probe_large_insn_limit;
>   		bpf_prog_attach_xattr;
>   		bpf_program__attach;
>   		bpf_program__name;
> diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
> index a9eb8b322671..925f95106a52 100644
> --- a/tools/lib/bpf/libbpf_probes.c
> +++ b/tools/lib/bpf/libbpf_probes.c
> @@ -17,6 +17,8 @@
>   #include "libbpf.h"
>   #include "libbpf_internal.h"
>   
> +#define INSN_REPEAT 4128
> +
>   static bool grep(const char *buffer, const char *pattern)
>   {
>   	return !!strstr(buffer, pattern);
> @@ -321,3 +323,24 @@ bool bpf_probe_helper(enum bpf_func_id id, enum bpf_prog_type prog_type,
>   
>   	return res;
>   }
> +
> +/*
> + * Probe for availability of kernel commit (5.3):
> + *
> + * c04c0d2b968a ("bpf: increase complexity limit and maximum program size")
> + */
> +bool bpf_probe_large_insn_limit(__u32 ifindex)
> +{
> +	struct bpf_insn insns[INSN_REPEAT + 1];
> +	int i;

Looks good, but lets test for 'BPF_MAXINSNS + 1' number of total insns, less
arbitrary than 4128.

> +	for (i = 0; i < INSN_REPEAT; i++)
> +		insns[i] = BPF_MOV64_IMM(BPF_REG_0, 1);
> +	insns[INSN_REPEAT] = BPF_EXIT_INSN();
> +
> +	errno = 0;
> +	probe_load(BPF_PROG_TYPE_SCHED_CLS, insns, ARRAY_SIZE(insns), NULL, 0,
> +		   ifindex);
> +
> +	return errno != E2BIG && errno != EINVAL;
> +}
> 

