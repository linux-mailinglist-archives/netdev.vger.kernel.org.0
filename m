Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EE644E932
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhKLOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235124AbhKLOw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 09:52:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A1D61039;
        Fri, 12 Nov 2021 14:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636728578;
        bh=542ExInSeFahal2lHxYWLJ/CKxe0cym24ATsD09o1xE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVMJeBUjYgC6LL0BBRbbMhXeNR+bDS0TxLSJBrUj2Nd2zejqp4UiJJ2fKtPFcGCy8
         ggcSTYtWAEID/LaJQrmOMNRQRLNxDBzf196CaULofv//I5uMpEj2a/Wa114p4LpbiH
         RPO6U0BL9U/vDYU+ZLPXCyKRk02U3j9xUXYmpyEbAgSYa+yuEDUQprsGkUE2HqtzbF
         UHpzHpCcDc7fXpI4OaWrpqaiXPq2kaWn8+snRlO3/7iYpcHxDx1jiDJlkS+2qahHDs
         5cNAIKB9Hy4tiEidp3h/Z7ME3gJBVGq5SEb9F/TkRRr2TxPY7cmijgx7yqjy0tD2R/
         kjzMbQqZ+lExg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 40282410A1; Fri, 12 Nov 2021 11:49:35 -0300 (-03)
Date:   Fri, 12 Nov 2021 11:49:35 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2] perf bpf: Avoid memory leak from perf_env__insert_btf
Message-ID: <YY5+/35QWGlGsyuF@kernel.org>
References: <20211112074525.121633-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112074525.121633-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Nov 11, 2021 at 11:45:25PM -0800, Ian Rogers escreveu:
> perf_env__insert_btf doesn't insert if a duplicate btf id is
> encountered and this causes a memory leak. Modify the function to return
> a success/error value and then free the memory if insertion didn't
> happen.
> 
> v2. Adds a return -1 when the insertion error occurs in
>     perf_env__fetch_btf. This doesn't affect anything as the result is
>     never checked.

Thanks, applied.

- Arnaldo

 
> Fixes: 3792cb2ff43b ("perf bpf: Save BTF in a rbtree in perf_env")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/bpf-event.c | 6 +++++-
>  tools/perf/util/env.c       | 5 ++++-
>  tools/perf/util/env.h       | 2 +-
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
> index 4d3b4cdce176..d49cdff8fb39 100644
> --- a/tools/perf/util/bpf-event.c
> +++ b/tools/perf/util/bpf-event.c
> @@ -119,7 +119,11 @@ static int perf_env__fetch_btf(struct perf_env *env,
>  	node->data_size = data_size;
>  	memcpy(node->data, data, data_size);
>  
> -	perf_env__insert_btf(env, node);
> +	if (!perf_env__insert_btf(env, node)) {
> +		/* Insertion failed because of a duplicate. */
> +		free(node);
> +		return -1;
> +	}
>  	return 0;
>  }
>  
> diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
> index 17f1dd0680b4..b9904896eb97 100644
> --- a/tools/perf/util/env.c
> +++ b/tools/perf/util/env.c
> @@ -75,12 +75,13 @@ struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
>  	return node;
>  }
>  
> -void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
> +bool perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
>  {
>  	struct rb_node *parent = NULL;
>  	__u32 btf_id = btf_node->id;
>  	struct btf_node *node;
>  	struct rb_node **p;
> +	bool ret = true;
>  
>  	down_write(&env->bpf_progs.lock);
>  	p = &env->bpf_progs.btfs.rb_node;
> @@ -94,6 +95,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
>  			p = &(*p)->rb_right;
>  		} else {
>  			pr_debug("duplicated btf %u\n", btf_id);
> +			ret = false;
>  			goto out;
>  		}
>  	}
> @@ -103,6 +105,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
>  	env->bpf_progs.btfs_cnt++;
>  out:
>  	up_write(&env->bpf_progs.lock);
> +	return ret;
>  }
>  
>  struct btf_node *perf_env__find_btf(struct perf_env *env, __u32 btf_id)
> diff --git a/tools/perf/util/env.h b/tools/perf/util/env.h
> index 1383876f72b3..163e5ec503a2 100644
> --- a/tools/perf/util/env.h
> +++ b/tools/perf/util/env.h
> @@ -167,7 +167,7 @@ void perf_env__insert_bpf_prog_info(struct perf_env *env,
>  				    struct bpf_prog_info_node *info_node);
>  struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
>  							__u32 prog_id);
> -void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node);
> +bool perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node);
>  struct btf_node *perf_env__find_btf(struct perf_env *env, __u32 btf_id);
>  
>  int perf_env__numa_node(struct perf_env *env, int cpu);
> -- 
> 2.34.0.rc1.387.gb447b232ab-goog

-- 

- Arnaldo
