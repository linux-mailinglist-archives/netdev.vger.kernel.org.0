Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4516715CD
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjARIEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjARIBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:01:46 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C205422D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 23:36:53 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B5ECA20EAD;
        Wed, 18 Jan 2023 07:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674027411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MYuQWqLPhNPLil6KLFw9XlwkP5BswaDfjZz2ueIxD6Q=;
        b=ZfMfMP/8lBjcrOo/dkw07xbdYMI4MLnCnWoCxsAl9wvJXn3MjbmTyWOcWD0GwBdnFOzE6f
        EIqXV+O6ozd2WT5fzNBEyg0HqhxpKntaoRjj1vGxj5/WPaibdoofc19Mu2vwgC369jqrg8
        AeXqeUpV1vXLKXzO3xItIZADVpYxdVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674027411;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MYuQWqLPhNPLil6KLFw9XlwkP5BswaDfjZz2ueIxD6Q=;
        b=Gw6WTYg7lXgd95iCVZ90Hey0ag0VcBnYzheewz3r8T5lLEqAUP43y73ClGyusQJbFfHVTi
        5ZA/5uxSgCrB+TCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 70B5E139D2;
        Wed, 18 Jan 2023 07:36:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FujMGpOhx2MqfQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 18 Jan 2023 07:36:51 +0000
Message-ID: <bfe4ff8f-0244-739d-3dfa-60101c8bf6b8@suse.cz>
Date:   Wed, 18 Jan 2023 08:36:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org
Cc:     Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, David Rientjes <rientjes@google.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <167396280045.539803.7540459812377220500.stgit@firesoul>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/23 14:40, Jesper Dangaard Brouer wrote:
> Allow API users of kmem_cache_create to specify that they don't want
> any slab merge or aliasing (with similar sized objects). Use this in
> network stack and kfence_test.
> 
> The SKB (sk_buff) kmem_cache slab is critical for network performance.
> Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
> performance by amortising the alloc/free cost.
> 
> For the bulk API to perform efficiently the slub fragmentation need to
> be low. Especially for the SLUB allocator, the efficiency of bulk free
> API depend on objects belonging to the same slab (page).

Incidentally, would you know if anyone still uses SLAB instead of SLUB
because it would perform better for networking? IIRC in the past discussions
networking was one of the reasons for SLAB to stay. We are looking again
into the possibility of removing it, so it would be good to know if there
are benchmarks where SLUB does worse so it can be looked into.

> When running different network performance microbenchmarks, I started
> to notice that performance was reduced (slightly) when machines had
> longer uptimes. I believe the cause was 'skbuff_head_cache' got
> aliased/merged into the general slub for 256 bytes sized objects (with
> my kernel config, without CONFIG_HARDENED_USERCOPY).

So did things improve with SLAB_NEVER_MERGE?

> For SKB kmem_cache network stack have reasons for not merging, but it
> varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
> We want to explicitly set SLAB_NEVER_MERGE for this kmem_cache.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/linux/slab.h    |    2 ++
>  mm/kfence/kfence_test.c |    7 +++----
>  mm/slab.h               |    5 +++--
>  mm/slab_common.c        |    8 ++++----
>  net/core/skbuff.c       |   13 ++++++++++++-
>  5 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 45af70315a94..83a89ba7c4be 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -138,6 +138,8 @@
>  #define SLAB_SKIP_KFENCE	0
>  #endif
>  
> +#define SLAB_NEVER_MERGE	((slab_flags_t __force)0x40000000U)

I think there should be an explanation what this does and when to consider
it. We should discourage blind use / cargo cult / copy paste from elsewhere
resulting in excessive proliferation of the flag.

- very specialized internal things like kfence? ok
- prevent a bad user of another cache corrupt my cache due to merging? no,
use slub_debug to find and fix the root cause
- performance concerns? only after proper evaluation, not prematurely

> +
>  /* The following flags affect the page allocator grouping pages by mobility */
>  /* Objects are reclaimable */
>  #ifndef CONFIG_SLUB_TINY
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index b5d66a69200d..9e83e344ee3c 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -191,11 +191,10 @@ static size_t setup_test_cache(struct kunit *test, size_t size, slab_flags_t fla
>  	kunit_info(test, "%s: size=%zu, ctor=%ps\n", __func__, size, ctor);
>  
>  	/*
> -	 * Use SLAB_NOLEAKTRACE to prevent merging with existing caches. Any
> -	 * other flag in SLAB_NEVER_MERGE also works. Use SLAB_ACCOUNT to
> -	 * allocate via memcg, if enabled.
> +	 * Use SLAB_NEVER_MERGE to prevent merging with existing caches.
> +	 * Use SLAB_ACCOUNT to allocate via memcg, if enabled.
>  	 */
> -	flags |= SLAB_NOLEAKTRACE | SLAB_ACCOUNT;
> +	flags |= SLAB_NEVER_MERGE | SLAB_ACCOUNT;
>  	test_cache = kmem_cache_create("test", size, 1, flags, ctor);
>  	KUNIT_ASSERT_TRUE_MSG(test, test_cache, "could not create cache");
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index 7cc432969945..be1383176d3e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -341,11 +341,11 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
>  #if defined(CONFIG_SLAB)
>  #define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
>  			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | \
> -			  SLAB_ACCOUNT)
> +			  SLAB_ACCOUNT | SLAB_NEVER_MERGE)
>  #elif defined(CONFIG_SLUB)
>  #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
>  			  SLAB_TEMPORARY | SLAB_ACCOUNT | \
> -			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC)
> +			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NEVER_MERGE)
>  #else
>  #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
>  #endif
> @@ -366,6 +366,7 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
>  			      SLAB_TEMPORARY | \
>  			      SLAB_ACCOUNT | \
>  			      SLAB_KMALLOC | \
> +			      SLAB_NEVER_MERGE | \
>  			      SLAB_NO_USER_FLAGS)
>  
>  bool __kmem_cache_empty(struct kmem_cache *);
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1cba98acc486..269f67c5fee6 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -45,9 +45,9 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
>  /*
>   * Set of flags that will prevent slab merging
>   */
> -#define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> +#define SLAB_NEVER_MERGE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER |\
>  		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
> -		SLAB_FAILSLAB | kasan_never_merge())
> +		SLAB_FAILSLAB | SLAB_NEVER_MERGE | kasan_never_merge())
>  
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
>  			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
> @@ -137,7 +137,7 @@ static unsigned int calculate_alignment(slab_flags_t flags,
>   */
>  int slab_unmergeable(struct kmem_cache *s)
>  {
> -	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE))
> +	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE_FLAGS))
>  		return 1;
>  
>  	if (s->ctor)
> @@ -173,7 +173,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
>  	size = ALIGN(size, align);
>  	flags = kmem_cache_flags(size, flags, name);
>  
> -	if (flags & SLAB_NEVER_MERGE)
> +	if (flags & SLAB_NEVER_MERGE_FLAGS)
>  		return NULL;
>  
>  	list_for_each_entry_reverse(s, &slab_caches, list) {
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 79c9e795a964..799b9914457b 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4629,12 +4629,23 @@ static void skb_extensions_init(void)
>  static void skb_extensions_init(void) {}
>  #endif
>  
> +/* The SKB kmem_cache slab is critical for network performance.  Never
> + * merge/alias the slab with similar sized objects.  This avoids fragmentation
> + * that hurts performance of kmem_cache_{alloc,free}_bulk APIs.
> + */
> +#ifndef CONFIG_SLUB_TINY
> +#define FLAG_SKB_NEVER_MERGE	SLAB_NEVER_MERGE
> +#else /* CONFIG_SLUB_TINY - simple loop in kmem_cache_alloc_bulk */
> +#define FLAG_SKB_NEVER_MERGE	0
> +#endif
> +
>  void __init skb_init(void)
>  {
>  	skbuff_head_cache = kmem_cache_create_usercopy("skbuff_head_cache",
>  					      sizeof(struct sk_buff),
>  					      0,
> -					      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
> +					      SLAB_HWCACHE_ALIGN|SLAB_PANIC|
> +						FLAG_SKB_NEVER_MERGE,
>  					      offsetof(struct sk_buff, cb),
>  					      sizeof_field(struct sk_buff, cb),
>  					      NULL);
> 
> 

