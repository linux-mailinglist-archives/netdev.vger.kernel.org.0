Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D133394B2F
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhE2JMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 05:12:17 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2404 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2JMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 05:12:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FsbKD48Gmz65XN;
        Sat, 29 May 2021 17:06:56 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 17:10:36 +0800
Received: from [10.174.179.129] (10.174.179.129) by
 dggema762-chm.china.huawei.com (10.1.198.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 17:10:35 +0800
Subject: Re: [PATCH] perf stat: Fix error return code in bperf__load()
To:     <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <yi.zhang@huawei.com>
References: <20210517081254.1561564-1-yukuai3@huawei.com>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <2b377d87-1356-7422-326d-4d1b4132e75c@huawei.com>
Date:   Sat, 29 May 2021 17:10:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210517081254.1561564-1-yukuai3@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.129]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping ...

On 2021/05/17 16:12, Yu Kuai wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   tools/perf/util/bpf_counter.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
> index ddb52f748c8e..843b20aa6688 100644
> --- a/tools/perf/util/bpf_counter.c
> +++ b/tools/perf/util/bpf_counter.c
> @@ -522,6 +522,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
>   	evsel->bperf_leader_link_fd = bpf_link_get_fd_by_id(entry.link_id);
>   	if (evsel->bperf_leader_link_fd < 0 &&
>   	    bperf_reload_leader_program(evsel, attr_map_fd, &entry))
> +		err = -1;
>   		goto out;
>   
>   	/*
> @@ -550,6 +551,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
>   	/* Step 2: load the follower skeleton */
>   	evsel->follower_skel = bperf_follower_bpf__open();
>   	if (!evsel->follower_skel) {
> +		err = -1;
>   		pr_err("Failed to open follower skeleton\n");
>   		goto out;
>   	}
> 
