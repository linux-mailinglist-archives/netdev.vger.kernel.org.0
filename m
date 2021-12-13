Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6714733E1
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241826AbhLMSUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:20:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52718 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbhLMSUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:20:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27DFAB8120C;
        Mon, 13 Dec 2021 18:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE72FC34604;
        Mon, 13 Dec 2021 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639419631;
        bh=NqhADOz46JoKzAQFwiPf89sY/cliSz2oGKNXFw3TUVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oxnTrCMh3/PJ6utpsuFIm6PbgK2e6EUzMl1KyGthiOe3plrZTY09A76kB2eRCCWiQ
         glMmnXE77P0kj7qofXTRTSP+XOEupVm8fE1kAtHFGJyoB46ONhbihxnKMds697J4h+
         yEhogH3CrAFyOHvJL3pAJNROor6SZpju35EbqgSnX1ETjp03eh85wTNgL3vLh9pild
         ru1ArUyHwARvrOjhd0LfWO1YMkcXAvSSrYzwbdEYc4avX1OsnI47w4ee6m3qyrcwxS
         5CKBqSZF9tIlSjgcNSUTNJEfLBDryJB+vSZOmGd4ZNmy2yR/v+kPni9d7ntU3Xcq6z
         rrqyPTv0KeFfg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3426F405D8; Mon, 13 Dec 2021 15:20:30 -0300 (-03)
Date:   Mon, 13 Dec 2021 15:20:30 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v1 1/2] perf namespaces: Add helper
 nsinfo__is_in_root_namespace()
Message-ID: <YbeO7sHHL0AvDl5g@kernel.org>
References: <20211212134721.1721245-1-leo.yan@linaro.org>
 <20211212134721.1721245-2-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212134721.1721245-2-leo.yan@linaro.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, Dec 12, 2021 at 09:47:20PM +0800, Leo Yan escreveu:
> Refactors code for gathering PID infos, it creates the function
> nsinfo__get_nspid() to parse process 'status' node in folder '/proc'.
> 
> Base on the refactoring, this patch introduces a new helper
> nsinfo__is_in_root_namespace(), it returns true when the caller runs in
> the root PID namespace.

Thanks, applied.

- Arnaldo

 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/util/namespaces.c | 76 ++++++++++++++++++++++--------------
>  tools/perf/util/namespaces.h |  2 +
>  2 files changed, 48 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/perf/util/namespaces.c b/tools/perf/util/namespaces.c
> index 608b20c72a5c..48aa3217300b 100644
> --- a/tools/perf/util/namespaces.c
> +++ b/tools/perf/util/namespaces.c
> @@ -60,17 +60,49 @@ void namespaces__free(struct namespaces *namespaces)
>  	free(namespaces);
>  }
>  
> +static int nsinfo__get_nspid(struct nsinfo *nsi, const char *path)
> +{
> +	FILE *f = NULL;
> +	char *statln = NULL;
> +	size_t linesz = 0;
> +	char *nspid;
> +
> +	f = fopen(path, "r");
> +	if (f == NULL)
> +		return -1;
> +
> +	while (getline(&statln, &linesz, f) != -1) {
> +		/* Use tgid if CONFIG_PID_NS is not defined. */
> +		if (strstr(statln, "Tgid:") != NULL) {
> +			nsi->tgid = (pid_t)strtol(strrchr(statln, '\t'),
> +						     NULL, 10);
> +			nsi->nstgid = nsi->tgid;
> +		}
> +
> +		if (strstr(statln, "NStgid:") != NULL) {
> +			nspid = strrchr(statln, '\t');
> +			nsi->nstgid = (pid_t)strtol(nspid, NULL, 10);
> +			/*
> +			 * If innermost tgid is not the first, process is in a different
> +			 * PID namespace.
> +			 */
> +			nsi->in_pidns = (statln + sizeof("NStgid:") - 1) != nspid;
> +			break;
> +		}
> +	}
> +
> +	fclose(f);
> +	free(statln);
> +	return 0;
> +}
> +
>  int nsinfo__init(struct nsinfo *nsi)
>  {
>  	char oldns[PATH_MAX];
>  	char spath[PATH_MAX];
>  	char *newns = NULL;
> -	char *statln = NULL;
> -	char *nspid;
>  	struct stat old_stat;
>  	struct stat new_stat;
> -	FILE *f = NULL;
> -	size_t linesz = 0;
>  	int rv = -1;
>  
>  	if (snprintf(oldns, PATH_MAX, "/proc/self/ns/mnt") >= PATH_MAX)
> @@ -100,34 +132,9 @@ int nsinfo__init(struct nsinfo *nsi)
>  	if (snprintf(spath, PATH_MAX, "/proc/%d/status", nsi->pid) >= PATH_MAX)
>  		goto out;
>  
> -	f = fopen(spath, "r");
> -	if (f == NULL)
> -		goto out;
> -
> -	while (getline(&statln, &linesz, f) != -1) {
> -		/* Use tgid if CONFIG_PID_NS is not defined. */
> -		if (strstr(statln, "Tgid:") != NULL) {
> -			nsi->tgid = (pid_t)strtol(strrchr(statln, '\t'),
> -						     NULL, 10);
> -			nsi->nstgid = nsi->tgid;
> -		}
> -
> -		if (strstr(statln, "NStgid:") != NULL) {
> -			nspid = strrchr(statln, '\t');
> -			nsi->nstgid = (pid_t)strtol(nspid, NULL, 10);
> -			/* If innermost tgid is not the first, process is in a different
> -			 * PID namespace.
> -			 */
> -			nsi->in_pidns = (statln + sizeof("NStgid:") - 1) != nspid;
> -			break;
> -		}
> -	}
> -	rv = 0;
> +	rv = nsinfo__get_nspid(nsi, spath);
>  
>  out:
> -	if (f != NULL)
> -		(void) fclose(f);
> -	free(statln);
>  	free(newns);
>  	return rv;
>  }
> @@ -299,3 +306,12 @@ int nsinfo__stat(const char *filename, struct stat *st, struct nsinfo *nsi)
>  
>  	return ret;
>  }
> +
> +bool nsinfo__is_in_root_namespace(void)
> +{
> +	struct nsinfo nsi;
> +
> +	memset(&nsi, 0x0, sizeof(nsi));
> +	nsinfo__get_nspid(&nsi, "/proc/self/status");
> +	return !nsi.in_pidns;
> +}
> diff --git a/tools/perf/util/namespaces.h b/tools/perf/util/namespaces.h
> index ad9775db7b9c..9ceea9643507 100644
> --- a/tools/perf/util/namespaces.h
> +++ b/tools/perf/util/namespaces.h
> @@ -59,6 +59,8 @@ void nsinfo__mountns_exit(struct nscookie *nc);
>  char *nsinfo__realpath(const char *path, struct nsinfo *nsi);
>  int nsinfo__stat(const char *filename, struct stat *st, struct nsinfo *nsi);
>  
> +bool nsinfo__is_in_root_namespace(void);
> +
>  static inline void __nsinfo__zput(struct nsinfo **nsip)
>  {
>  	if (nsip) {
> -- 
> 2.25.1

-- 

- Arnaldo
