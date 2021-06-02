Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495AF397DDF
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFBBGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:06:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2833 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhFBBGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 21:06:47 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvrKw4VlfzWqsw;
        Wed,  2 Jun 2021 09:00:20 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 09:05:01 +0800
Received: from [10.174.179.129] (10.174.179.129) by
 dggema762-chm.china.huawei.com (10.1.198.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 09:05:01 +0800
Subject: Re: [PATCH] perf stat: Fix error return code in bperf__load()
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
CC:     <peterz@infradead.org>, <mingo@redhat.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <yi.zhang@huawei.com>
References: <20210517081254.1561564-1-yukuai3@huawei.com>
 <YLY7qozcJcj8RVe+@kernel.org> <YLY8aKsMvBG+DB1W@kernel.org>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <360aa666-2a78-d2f5-9547-6ebecd57bcb4@huawei.com>
Date:   Wed, 2 Jun 2021 09:05:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <YLY8aKsMvBG+DB1W@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.129]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/06/01 21:55, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jun 01, 2021 at 10:52:42AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, May 17, 2021 at 04:12:54PM +0800, Yu Kuai escreveu:
>>> Fix to return a negative error code from the error handling
>>> case instead of 0, as done elsewhere in this function.
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>
>> Applied, but I had to add Song to the CC list and also add this line:
>>
>> Fixes: 7fac83aaf2eecc9e ("perf stat: Introduce 'bperf' to share hardware PMCs with BPF")
>>
>> So that the stable@kernel.org folks can get this auto-collected.
>>
>> Perhaps you guys can make Hulk do that as well? :-)
>>
>> Thanks,
> 
> Something else to teach Hulk:
> 
> util/bpf_counter.c: In function ‘bperf__load’:
> util/bpf_counter.c:523:9: error: this ‘if’ clause does not guard... [-Werror=misleading-indentation]
>    523 |         if (evsel->bperf_leader_link_fd < 0 &&
>        |         ^~
> util/bpf_counter.c:526:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘if’
>    526 |                 goto out;
>        |                 ^~~~
> cc1: all warnings being treated as errors
> 
> I'm adding the missing {} for the now multiline if block.
Sorry for the mistake, and similar errors will be checked in the future.

Thanks
Yu Kuai
> 
> - Arnaldo
>>
>>> ---
>>>   tools/perf/util/bpf_counter.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
>>> index ddb52f748c8e..843b20aa6688 100644
>>> --- a/tools/perf/util/bpf_counter.c
>>> +++ b/tools/perf/util/bpf_counter.c
>>> @@ -522,6 +522,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
>>>   	evsel->bperf_leader_link_fd = bpf_link_get_fd_by_id(entry.link_id);
>>>   	if (evsel->bperf_leader_link_fd < 0 &&
>>>   	    bperf_reload_leader_program(evsel, attr_map_fd, &entry))
>>> +		err = -1;
>>>   		goto out;
>>>   
>>>   	/*
>>> @@ -550,6 +551,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
>>>   	/* Step 2: load the follower skeleton */
>>>   	evsel->follower_skel = bperf_follower_bpf__open();
>>>   	if (!evsel->follower_skel) {
>>> +		err = -1;
>>>   		pr_err("Failed to open follower skeleton\n");
>>>   		goto out;
>>>   	}
>>> -- 
>>> 2.25.4
>>>
>>
>> -- 
>>
>> - Arnaldo
> 
