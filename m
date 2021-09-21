Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F9F413651
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhIUPjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 11:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbhIUPjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 11:39:11 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2841C061756
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 08:37:42 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n71so8351944iod.0
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 08:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bc1nCjtA9E5naFj/iieaeVOdv7rs48Z0WzIV2QbKr+U=;
        b=OfYiCg1ObQ+EjA8ezpWI/3b5+p47r3DuQ44Hhx2m6hzXqW+bA0IKjb+b7VGHygu21c
         A1tjp3CHrtC8f9PxzdKgiPgGTfL/xNSPnOmp444ag3J4LxNa8DXLC8ydyUOyk84YdWYw
         AXbBTwTsQZQSVQRJLk8WwXRdMiMQMeF9y7rq4I2rojpgd3+ciBzpJyptQYb1D/PVs5sV
         knd62R6tARK2X1cnt6w4RcYMXgYrUY5MItve6qgp4Yfpf3bSTiGc6o5yjPdd4MpPWWkg
         pYbIE8hWzEeecgYKdrfxcP8D+Rmh4uz0T4pEHvksHWYeTqSfrhv2Xo5Is6Hc1nCzED/j
         i9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bc1nCjtA9E5naFj/iieaeVOdv7rs48Z0WzIV2QbKr+U=;
        b=XAQRWNjmiiAxE9z3TTDWIuMQxFQxMoPUhR6BhZj6g6wrN7e6XwzcDpXvScn49JdQBg
         OGtQPIySJrKyhzSFvpmP56y/0nPsGDpZ9nsN7I2Cvb6SKfqiq3jHRVaUyYFIetfup1tm
         2F6VADm7es5Z17J6eveUNSCzwMz21vxVgRoajxwKY8Y7EtglV/8+sFVHJC3TdCLyGIxv
         yyJgK2xfZge9T6eNXzMjEfa5kfLfBPjS02weQjeXrdgaZNfiZ0wNWFV5xKkog4W6Xicr
         tdu+dQmDVQnf8ScrltuaOpIqnsC5VWJXbcGAyQzijIxHXqaUljo9sJZtwaKGfXW7Ntig
         CDNw==
X-Gm-Message-State: AOAM530gnfot9/0agOdW2Hqhm+nkeq0IfD7H7KTKQ+fIYm9k+DRs/hjS
        Cmh5wf6dYJbAnH1cAPMxbOgaYrk7Iynbs4U7q+Q=
X-Google-Smtp-Source: ABdhPJxwn39GagTcBMDoxqiNOTdAFFndvbDGREPxOIa25F+Lkj7Wif0shz5JkxgywXozyHTp84Qwnw==
X-Received: by 2002:a5d:8458:: with SMTP id w24mr505054ior.168.1632238662030;
        Tue, 21 Sep 2021 08:37:42 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w4sm636605iou.42.2021.09.21.08.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 08:37:41 -0700 (PDT)
Subject: Re: [RFC v2 PATCH] mm, sl[au]b: Introduce lockless cache
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org
Cc:     Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        John Garry <john.garry@huawei.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org
References: <20210920154816.31832-1-42.hyeyoo@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ebea2af2-90d0-248f-8461-80f2e834dfea@kernel.dk>
Date:   Tue, 21 Sep 2021 09:37:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210920154816.31832-1-42.hyeyoo@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -424,6 +431,57 @@ kmem_cache_create(const char *name, unsigned int size, unsigned int align,
>  }
>  EXPORT_SYMBOL(kmem_cache_create);
>  
> +/**
> + * kmem_cache_alloc_cached - try to allocate from cache without lock
> + * @s: slab cache
> + * @flags: SLAB flags
> + *
> + * Try to allocate from cache without lock. If fails, fill the lockless cache
> + * using bulk alloc API
> + *
> + * Be sure that there's no race condition.
> + * Must create slab cache with SLAB_LOCKLESS_CACHE flag to use this function.
> + *
> + * Return: a pointer to free object on allocation success, NULL on failure.
> + */
> +void *kmem_cache_alloc_cached(struct kmem_cache *s, gfp_t gfpflags)
> +{
> +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> +
> +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));
> +
> +	if (cache->size) /* fastpath without lock */
> +		return cache->queue[--cache->size];
> +
> +	/* slowpath */
> +	cache->size = kmem_cache_alloc_bulk(s, gfpflags,
> +			KMEM_LOCKLESS_CACHE_QUEUE_SIZE, cache->queue);
> +	if (cache->size)
> +		return cache->queue[--cache->size];
> +	else
> +		return NULL;
> +}
> +EXPORT_SYMBOL(kmem_cache_alloc_cached);

How does this work for preempt? You seem to assume that the function is
invoked with preempt disabled, but then it could only be used with
GFP_ATOMIC.

There are basically two types of use cases for this:

1) Freeing can happen from interrupts
2) Freeing cannot happen from interrupts

What I implemented for IOPOLL doesn't need to care about interrupts,
hence preemption disable is enough. But we do need that, at least.

And if you don't care about users that free from irq/softirq, then that
should be mentioned. Locking context should be mentioned, too. The above
may be just fine IFF both alloc and free are protected by a lock higher
up. If not, both need preemption disabled and GFP_ATOMIC. I'd suggest
making the get/put cpu part of the API internally.

> +/**
> + * kmem_cache_free_cached - return object to cache
> + * @s: slab cache
> + * @p: pointer to free
> + */
> +void kmem_cache_free_cached(struct kmem_cache *s, void *p)
> +{
> +	struct kmem_lockless_cache *cache = this_cpu_ptr(s->cache);
> +
> +	BUG_ON(!(s->flags & SLAB_LOCKLESS_CACHE));

Don't use BUG_ON, just do:

	if (WARN_ON_ONCE(!(s->flags & SLAB_LOCKLESS_CACHE))) {
		kmem_cache_free(s, p);
		return;
	}

-- 
Jens Axboe

