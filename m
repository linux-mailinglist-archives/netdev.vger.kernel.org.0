Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A92B3974A1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhFANyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233584AbhFANy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:54:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E158F61376;
        Tue,  1 Jun 2021 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622555565;
        bh=JvEEdlPXj4ia4HL0u4q4ZXk0jCOdlivWDn7dFPYD3tM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CE5z9Qn0F8WJPAtTqloR3989T+FAmwPphxaJ3xPLgjWrIXOFpPut0WEtGvJylgRWC
         wgzHaEgrcWUXk4We3oPfc4P7fwZz+ixzQv0sk69/uCOwywdLrzaIpwaf8SoJHvYEZY
         vjKxWHiMzPQRRBbkXui77sOaGEKhVzdD8sOI1LZnkcUVN5tbwhdT6SiOkooJsXte0u
         e0ztDacoHuKbytb7KEMAQbINww2VFLsr58JtOgcqwWjQlmboxLFJgjf/XLvVcvnX7p
         o+UFMi3q/iZkoLkpZzyj5VvF2fHysyDpic89/2iJuwk219pcw/YqRWP4KVM9gMTutF
         6jEvMwRQ4Uc0g==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 565914011C; Tue,  1 Jun 2021 10:52:42 -0300 (-03)
Date:   Tue, 1 Jun 2021 10:52:42 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Yu Kuai <yukuai3@huawei.com>, Song Liu <songliubraving@fb.com>
Cc:     peterz@infradead.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] perf stat: Fix error return code in bperf__load()
Message-ID: <YLY7qozcJcj8RVe+@kernel.org>
References: <20210517081254.1561564-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517081254.1561564-1-yukuai3@huawei.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, May 17, 2021 at 04:12:54PM +0800, Yu Kuai escreveu:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied, but I had to add Song to the CC list and also add this line:

Fixes: 7fac83aaf2eecc9e ("perf stat: Introduce 'bperf' to share hardware PMCs with BPF")

So that the stable@kernel.org folks can get this auto-collected.

Perhaps you guys can make Hulk do that as well? :-)

Thanks,

- Arnaldo

> ---
>  tools/perf/util/bpf_counter.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
> index ddb52f748c8e..843b20aa6688 100644
> --- a/tools/perf/util/bpf_counter.c
> +++ b/tools/perf/util/bpf_counter.c
> @@ -522,6 +522,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
>  	evsel->bperf_leader_link_fd = bpf_link_get_fd_by_id(entry.link_id);
>  	if (evsel->bperf_leader_link_fd < 0 &&
>  	    bperf_reload_leader_program(evsel, attr_map_fd, &entry))
> +		err = -1;
>  		goto out;
>  
>  	/*
> @@ -550,6 +551,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
>  	/* Step 2: load the follower skeleton */
>  	evsel->follower_skel = bperf_follower_bpf__open();
>  	if (!evsel->follower_skel) {
> +		err = -1;
>  		pr_err("Failed to open follower skeleton\n");
>  		goto out;
>  	}
> -- 
> 2.25.4
> 

-- 

- Arnaldo
