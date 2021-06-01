Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08533974B6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhFAN5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234119AbhFAN5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B324613AE;
        Tue,  1 Jun 2021 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622555755;
        bh=uDkz4YoEHcgBW7m92lJvZYICBqyo72YlqEVTWUbMiRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZVkzo27Mj0F/+XVAb7Pw2B8W97FekTZBXxYswPbWs2QxuOu4AejG/xzX1XCBYpQie
         vAVhvyi23fC2KHpFCB5mke3sxNhZ86Lr6Wt8zrbIR1MalzoGxQkEOGBzjKyMIIYU67
         CJHo3AXVtRTpQGpG+gCpYxgOKAwXIkebXYJzuQtZmxYVYFoBjQv1taJ6J2IVmG/stN
         mRrZNhYDdG7NMjiVLzjHV+7JkGpb7+Kwzbw/5rmhz4DQFPF67M/Pm9GQiVlClNoNXZ
         YTsyvSbH9aBCKtIRlsNAV72XvP6kskT1LRbF6YdanDvszeBt0K8MQjEPL4e0S/NCT7
         PRRI3pa8/xoFA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 78FB34011C; Tue,  1 Jun 2021 10:55:52 -0300 (-03)
Date:   Tue, 1 Jun 2021 10:55:52 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Yu Kuai <yukuai3@huawei.com>, Song Liu <songliubraving@fb.com>
Cc:     peterz@infradead.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH] perf stat: Fix error return code in bperf__load()
Message-ID: <YLY8aKsMvBG+DB1W@kernel.org>
References: <20210517081254.1561564-1-yukuai3@huawei.com>
 <YLY7qozcJcj8RVe+@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YLY7qozcJcj8RVe+@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jun 01, 2021 at 10:52:42AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, May 17, 2021 at 04:12:54PM +0800, Yu Kuai escreveu:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> Applied, but I had to add Song to the CC list and also add this line:
> 
> Fixes: 7fac83aaf2eecc9e ("perf stat: Introduce 'bperf' to share hardware PMCs with BPF")
> 
> So that the stable@kernel.org folks can get this auto-collected.
> 
> Perhaps you guys can make Hulk do that as well? :-)
> 
> Thanks,

Something else to teach Hulk:

util/bpf_counter.c: In function ‘bperf__load’:
util/bpf_counter.c:523:9: error: this ‘if’ clause does not guard... [-Werror=misleading-indentation]
  523 |         if (evsel->bperf_leader_link_fd < 0 &&
      |         ^~
util/bpf_counter.c:526:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘if’
  526 |                 goto out;
      |                 ^~~~
cc1: all warnings being treated as errors

I'm adding the missing {} for the now multiline if block.

- Arnaldo
> 
> > ---
> >  tools/perf/util/bpf_counter.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/perf/util/bpf_counter.c b/tools/perf/util/bpf_counter.c
> > index ddb52f748c8e..843b20aa6688 100644
> > --- a/tools/perf/util/bpf_counter.c
> > +++ b/tools/perf/util/bpf_counter.c
> > @@ -522,6 +522,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
> >  	evsel->bperf_leader_link_fd = bpf_link_get_fd_by_id(entry.link_id);
> >  	if (evsel->bperf_leader_link_fd < 0 &&
> >  	    bperf_reload_leader_program(evsel, attr_map_fd, &entry))
> > +		err = -1;
> >  		goto out;
> >  
> >  	/*
> > @@ -550,6 +551,7 @@ static int bperf__load(struct evsel *evsel, struct target *target)
> >  	/* Step 2: load the follower skeleton */
> >  	evsel->follower_skel = bperf_follower_bpf__open();
> >  	if (!evsel->follower_skel) {
> > +		err = -1;
> >  		pr_err("Failed to open follower skeleton\n");
> >  		goto out;
> >  	}
> > -- 
> > 2.25.4
> > 
> 
> -- 
> 
> - Arnaldo

-- 

- Arnaldo
