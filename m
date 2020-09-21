Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6282271D9D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgIUIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:12:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:42198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgIUIME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 04:12:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600675922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qY5z/CIzbaqHx8s2HYRdo5vtY/9cgm6CVe0rMQIWXjg=;
        b=NlpFxE4kmST4SqiC5KofXcdP2j2eEf3octfP5pb/ZkthT+R+VMr0ShAlQF0vVtz0GEe+GO
        D26n3IIIRUqhBlVspyCQkqlGByh3LG83HorXcqlE6pFmkl+VuZQXmVa7ttvda40L06GP2m
        RMCAgOXkCA9XWEXTU8TB5d2ETbPr2Qk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B8B2B270;
        Mon, 21 Sep 2020 08:12:38 +0000 (UTC)
Date:   Mon, 21 Sep 2020 10:12:00 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     zangchunxin@bytedance.com
Cc:     hannes@cmpxchg.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, tj@kernel.org, lizefan@huawei.com,
        corbet@lwn.net, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: Add the drop_cache interface for cgroup v2
Message-ID: <20200921081200.GE12990@dhcp22.suse.cz>
References: <20200921080255.15505-1-zangchunxin@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921080255.15505-1-zangchunxin@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 21-09-20 16:02:55, zangchunxin@bytedance.com wrote:
> From: Chunxin Zang <zangchunxin@bytedance.com>
> 
> In the cgroup v1, we have 'force_mepty' interface. This is very
> useful for userspace to actively release memory. But the cgroup
> v2 does not.
> 
> This patch reuse cgroup v1's function, but have a new name for
> the interface. Because I think 'drop_cache' may be is easier to
> understand :)

This should really explain a usecase. Global drop_caches is a terrible
interface and it has caused many problems in the past. People have
learned to use it as a remedy to any problem they might see and cause
other problems without realizing that. This is the reason why we even
log each attempt to drop caches.

I would rather not repeat the same mistake on the memcg level unless
there is a very strong reason for it.

> Signed-off-by: Chunxin Zang <zangchunxin@bytedance.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 11 +++++++++++
>  mm/memcontrol.c                         |  5 +++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index ce3e05e41724..fbff959c8116 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1181,6 +1181,17 @@ PAGE_SIZE multiple when read back.
>  	high limit is used and monitored properly, this limit's
>  	utility is limited to providing the final safety net.
>  
> +  memory.drop_cache
> +    A write-only single value file which exists on non-root
> +    cgroups.
> +
> +    Provide a mechanism for users to actively trigger memory
> +    reclaim. The cgroup will be reclaimed and as many pages
> +    reclaimed as possible.
> +
> +    It will broke low boundary. Because it tries to reclaim the
> +    memory many times, until the memory drops to a certain level.
> +
>    memory.oom.group
>  	A read-write single value file which exists on non-root
>  	cgroups.  The default value is "0".
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0b38b6ad547d..98646484efff 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6226,6 +6226,11 @@ static struct cftype memory_files[] = {
>  		.write = memory_max_write,
>  	},
>  	{
> +		.name = "drop_cache",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.write = mem_cgroup_force_empty_write,
> +	},
> +	{
>  		.name = "events",
>  		.flags = CFTYPE_NOT_ON_ROOT,
>  		.file_offset = offsetof(struct mem_cgroup, events_file),
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
