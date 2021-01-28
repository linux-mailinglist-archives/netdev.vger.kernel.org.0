Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FE6307584
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhA1MFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:05:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:33754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1MEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 07:04:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6DA1AAC45;
        Thu, 28 Jan 2021 12:03:54 +0000 (UTC)
Subject: Re: [PATCH] Revert "mm/slub: fix a memory leak in sysfs_slab_add()"
To:     Wang Hai <wanghai38@huawei.com>, torvalds@linux-foundation.org,
        cl@linux.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Cc:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com
References: <20210128113250.60078-1-wanghai38@huawei.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <1f4afc98-f5de-3992-1f49-f041d3783ea2@suse.cz>
Date:   Thu, 28 Jan 2021 13:03:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128113250.60078-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 12:32 PM, Wang Hai wrote:
> This reverts commit dde3c6b72a16c2db826f54b2d49bdea26c3534a2.
> 
> syzbot report a double-free bug. The following case can cause this bug.
>  - mm/slab_common.c: create_cache(): if the __kmem_cache_create()
> fails, it does:
> 
> 	out_free_cache:
> 		kmem_cache_free(kmem_cache, s);
> 
>  - but __kmem_cache_create() - at least for slub() - will have done
> 
> 	sysfs_slab_add(s)
> 		-> sysfs_create_group() .. fails ..
> 		-> kobject_del(&s->kobj); .. which frees s ...
> 
> We can't remove the kmem_cache_free() in create_cache(), because
> other error cases of __kmem_cache_create() do not free this.
> 
> So, revert the commit dde3c6b72a16 ("mm/slub: fix a memory leak in
> sysfs_slab_add()") to fix this.
> 
> Reported-by: syzbot+d0bd96b4696c1ef67991@syzkaller.appspotmail.com
> Fixes: dde3c6b72a16 ("mm/slub: fix a memory leak in sysfs_slab_add()")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Cc: <stable@vger.kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>

Double-free is worse than a rare small memory leak. Which would still be nice to
fix, but I'm afraid it will be more complicated, so start with preventing the
worse issue, including stable.

> ---
>  mm/slub.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 69742ab9a21d..7ecbbbe5bc0c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5625,10 +5625,8 @@ static int sysfs_slab_add(struct kmem_cache *s)
>  
>  	s->kobj.kset = kset;
>  	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
> -	if (err) {
> -		kobject_put(&s->kobj);
> +	if (err)
>  		goto out;
> -	}
>  
>  	err = sysfs_create_group(&s->kobj, &slab_attr_group);
>  	if (err)
> 

