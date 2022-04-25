Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E86950E584
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243352AbiDYQZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243350AbiDYQZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:25:48 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D1A7487D;
        Mon, 25 Apr 2022 09:22:43 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nj1U0-0007dF-N7; Mon, 25 Apr 2022 18:22:40 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nj1U0-000CR6-9n; Mon, 25 Apr 2022 18:22:40 +0200
Subject: Re: [PATCH perf/core 1/5] libbpf: Add bpf_program__set_insns function
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-2-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <52f36e85-fea6-e307-344e-5bbb5b8431f7@iogearbox.net>
Date:   Mon, 25 Apr 2022 18:22:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220422100025.1469207-2-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 12:00 PM, Jiri Olsa wrote:
> Adding bpf_program__set_insns that allows to set new
> instructions for program.
> 
> Also moving bpf_program__attach_kprobe_multi_opts on
> the proper name sorted place in map file.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/lib/bpf/libbpf.c   |  8 ++++++++
>   tools/lib/bpf/libbpf.h   | 12 ++++++++++++
>   tools/lib/bpf/libbpf.map |  3 ++-
>   3 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 809fe209cdcc..284790d81c1b 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8457,6 +8457,14 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
>   	return prog->insns_cnt;
>   }
>   
> +void bpf_program__set_insns(struct bpf_program *prog,
> +			    struct bpf_insn *insns, size_t insns_cnt)
> +{
> +	free(prog->insns);
> +	prog->insns = insns;
> +	prog->insns_cnt = insns_cnt;
> +}
> +
>   int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
>   			  bpf_program_prep_t prep)
>   {
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 05dde85e19a6..b31ad58d335f 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -323,6 +323,18 @@ struct bpf_insn;
>    * different.
>    */
>   LIBBPF_API const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog);
> +
> +/**
> + * @brief **bpf_program__set_insns()** can set BPF program's underlying
> + * BPF instructions.
> + * @param prog BPF program for which to return instructions
> + * @param insn a pointer to an array of BPF instructions
> + * @param insns_cnt number of `struct bpf_insn`'s that form
> + * specified BPF program
> + */
> +LIBBPF_API void bpf_program__set_insns(struct bpf_program *prog,
> +				       struct bpf_insn *insns, size_t insns_cnt);
> +

Iiuc, patch 2 should be squashed into this one given they logically belong to the
same change?

Fwiw, I think the API description should be elaborated a bit more, in particular that
the passed-in insns need to be from allocated dynamic memory which is later on passed
to free(), and maybe also constraints at which point in time bpf_program__set_insns()
may be called.. (as well as high-level description on potential use cases e.g. around
patch 4).

>   /**
>    * @brief **bpf_program__insn_cnt()** returns number of `struct bpf_insn`'s
>    * that form specified BPF program.
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index dd35ee58bfaa..afa10d24ab41 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -444,7 +444,8 @@ LIBBPF_0.8.0 {
>   	global:
>   		bpf_object__destroy_subskeleton;
>   		bpf_object__open_subskeleton;
> +		bpf_program__attach_kprobe_multi_opts;
> +		bpf_program__set_insns;
>   		libbpf_register_prog_handler;
>   		libbpf_unregister_prog_handler;
> -		bpf_program__attach_kprobe_multi_opts;
>   } LIBBPF_0.7.0;
> 

