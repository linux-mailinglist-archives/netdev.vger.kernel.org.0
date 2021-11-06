Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7165B446FF9
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 20:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhKFTF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 15:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232523AbhKFTF4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 15:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B87D161076;
        Sat,  6 Nov 2021 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636225394;
        bh=dvJnVXtykJb5fOfhANDIzNUpNdbIdocyte+fty4l+uE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Um5YP6q9WrJXqkaI10osNjoBSPL81UNr2Rm64XOjiCh984ABlEZ3O/IAwes7dY842
         n2wO4p0OC6FR54Td2sfYhhWXSkfIX288ty+XzrKVgDdCCxNiHWQpJt+ra4g+c14p/m
         MYwF2Gxtg1z9jgUwPXgziPme/bHgMxk5WU07tzPyUiyX+bCaHPfIrgnhPKjMgvbYGc
         NzfqegzNYscfjzFDUoqV6Yw7OXa+5gG2mHgF16Zaa7dtS7WDTtMJxsicGJL9oP38eX
         REZCjvOmR/rxgD5NTB5yeCaCo+9JX0nJZ30sEFATRxzoQS37veDhM/5WifHZzdsGsf
         glMsXIrqF600Q==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 693C8410A1; Sat,  6 Nov 2021 16:03:12 -0300 (-03)
Date:   Sat, 6 Nov 2021 16:03:12 -0300
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
Subject: Re: [PATCH 2/2] perf bpf: Add missing free to
 bpf_event__print_bpf_prog_info
Message-ID: <YYbRcJCx4J2pP1UO@kernel.org>
References: <20211106053733.3580931-1-irogers@google.com>
 <20211106053733.3580931-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106053733.3580931-2-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Nov 05, 2021 at 10:37:33PM -0700, Ian Rogers escreveu:
> If btf__new is called then there needs to be a corresponding btf__free.


Thanks, applied.

- Arnaldo


 
> Fixes: f8dfeae009ef ("perf bpf: Show more BPF program info in print_bpf_prog_info()")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/bpf-event.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
> index 0783b464777a..1f813d8bb946 100644
> --- a/tools/perf/util/bpf-event.c
> +++ b/tools/perf/util/bpf-event.c
> @@ -579,7 +579,7 @@ void bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
>  		synthesize_bpf_prog_name(name, KSYM_NAME_LEN, info, btf, 0);
>  		fprintf(fp, "# bpf_prog_info %u: %s addr 0x%llx size %u\n",
>  			info->id, name, prog_addrs[0], prog_lens[0]);
> -		return;
> +		goto out;
>  	}
>  
>  	fprintf(fp, "# bpf_prog_info %u:\n", info->id);
> @@ -589,4 +589,6 @@ void bpf_event__print_bpf_prog_info(struct bpf_prog_info *info,
>  		fprintf(fp, "# \tsub_prog %u: %s addr 0x%llx size %u\n",
>  			i, name, prog_addrs[i], prog_lens[i]);
>  	}
> +out:
> +	btf__free(btf);
>  }
> -- 
> 2.34.0.rc0.344.g81b53c2807-goog

-- 

- Arnaldo
