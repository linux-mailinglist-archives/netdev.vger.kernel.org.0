Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102E4446FF6
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 20:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhKFTEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 15:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232523AbhKFTES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 15:04:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C3261058;
        Sat,  6 Nov 2021 19:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636225297;
        bh=gHiRP7T92ZrX+spwRw+xIdpGjcXe+C4gS84lei3bAXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QWf3im/y0N/JbBKieGbxgCnRWbwO7L7qXY+xgCOev9tT7B4JvpDD1PlyWkgf9CUfN
         IKRjIAkVj3v9hNpO8yqxxNAOjRSww+eKli1Gf/H1bOanbKlNnnKvS0rwXWlbypNQ+k
         e4AYixfm6F7uOFxiO/Cc6KdVAPMbeK6vra3oNXgNakBw9H0VrWQY10A5R7TEXIM9Ol
         qdsC37A12ATVR6fbLBK+1ePb11NnkO5S5g0UHxTZm8Qr92EuZBFrx75vnHJcvhuJvL
         +/aJlJmJMOoISG5YvaBEqA/wtaLd6e47NWAHOA5Om++x/IewwTCNlK23tW1L0MK67G
         dS2CLSvHJqrEQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 72C0F410A1; Sat,  6 Nov 2021 16:01:33 -0300 (-03)
Date:   Sat, 6 Nov 2021 16:01:33 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>, Song Liu <songliubraving@fb.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf bpf: Avoid memory leak from perf_env__insert_btf
Message-ID: <YYbRDT6eknbL1DVd@kernel.org>
References: <20211106053733.3580931-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106053733.3580931-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Nov 05, 2021 at 10:37:32PM -0700, Ian Rogers escreveu:
> perf_env__insert_btf doesn't insert if a duplicate btf id is
> encountered and this causes a memory leak. Modify the function to return
> a success/error value and then free the memory if insertion didn't
> happen.
> 
> Fixes: 3792cb2ff43b ("perf bpf: Save BTF in a rbtree in perf_env")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/bpf-event.c | 5 ++++-
>  tools/perf/util/env.c       | 5 ++++-
>  tools/perf/util/env.h       | 2 +-
>  3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
> index 1a7112a87736..0783b464777a 100644
> --- a/tools/perf/util/bpf-event.c
> +++ b/tools/perf/util/bpf-event.c
> @@ -120,7 +120,10 @@ static int perf_env__fetch_btf(struct perf_env *env,
>  	node->data_size = data_size;
>  	memcpy(node->data, data, data_size);
>  
> -	perf_env__insert_btf(env, node);
> +	if (!perf_env__insert_btf(env, node)) {
> +		/* Insertion failed because of a duplicate. */
> +		free(node);
> +	}
>  	return 0;

Shouldn't this error be propagated? Song?

- Arnaldo

>  }
>  
> diff --git a/tools/perf/util/env.c b/tools/perf/util/env.c
> index cf773f0dec38..5b24eb010336 100644
> --- a/tools/perf/util/env.c
> +++ b/tools/perf/util/env.c
> @@ -74,12 +74,13 @@ struct bpf_prog_info_node *perf_env__find_bpf_prog_info(struct perf_env *env,
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
> @@ -93,6 +94,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
>  			p = &(*p)->rb_right;
>  		} else {
>  			pr_debug("duplicated btf %u\n", btf_id);
> +			ret = false;
>  			goto out;
>  		}
>  	}
> @@ -102,6 +104,7 @@ void perf_env__insert_btf(struct perf_env *env, struct btf_node *btf_node)
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
> 2.34.0.rc0.344.g81b53c2807-goog

-- 

- Arnaldo
