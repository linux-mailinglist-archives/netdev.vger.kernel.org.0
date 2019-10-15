Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E7D7159
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfJOIo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfJOIo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:44:57 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5625F10CC1F8;
        Tue, 15 Oct 2019 08:44:56 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 65A125C1D4;
        Tue, 15 Oct 2019 08:44:51 +0000 (UTC)
Date:   Tue, 15 Oct 2019 10:44:51 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        ilubashe@akamai.com, ak@linux.intel.com, kan.liang@linux.intel.com,
        alexey.budankov@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, hushiyuan@huawei.com,
        linfeilong@huawei.com
Subject: Re: [PATCH] perf tools: fix resource leak of closedir() on the error
 paths
Message-ID: <20191015084451.GB10951@krava>
References: <cd5f7cd2-b80d-6add-20a1-32f4f43e0744@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd5f7cd2-b80d-6add-20a1-32f4f43e0744@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Tue, 15 Oct 2019 08:44:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 04:30:08PM +0800, Yunfeng Ye wrote:
> Both build_mem_topology() and rm_rf_depth_pat() have resource leak of
> closedir() on the error paths.
> 
> Fix this by calling closedir() before function returns.
> 
> Fixes: e2091cedd51b ("perf tools: Add MEM_TOPOLOGY feature to perf data file")
> Fixes: cdb6b0235f17 ("perf tools: Add pattern name checking to rm_rf")

guilty as charged ;-)

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka


> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> ---
>  tools/perf/util/header.c | 4 +++-
>  tools/perf/util/util.c   | 6 ++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 86d9396..becc2d1 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1296,8 +1296,10 @@ static int build_mem_topology(struct memory_node *nodes, u64 size, u64 *cntp)
>  			continue;
> 
>  		if (WARN_ONCE(cnt >= size,
> -			      "failed to write MEM_TOPOLOGY, way too many nodes\n"))
> +			"failed to write MEM_TOPOLOGY, way too many nodes\n")) {
> +			closedir(dir);
>  			return -1;
> +		}
> 
>  		ret = memory_node__read(&nodes[cnt++], idx);
>  	}
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 5eda6e1..ae56c76 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -154,8 +154,10 @@ static int rm_rf_depth_pat(const char *path, int depth, const char **pat)
>  		if (!strcmp(d->d_name, ".") || !strcmp(d->d_name, ".."))
>  			continue;
> 
> -		if (!match_pat(d->d_name, pat))
> -			return -2;
> +		if (!match_pat(d->d_name, pat)) {
> +			ret =  -2;
> +			break;
> +		}
> 
>  		scnprintf(namebuf, sizeof(namebuf), "%s/%s",
>  			  path, d->d_name);
> -- 
> 2.7.4.huawei.3
> 
