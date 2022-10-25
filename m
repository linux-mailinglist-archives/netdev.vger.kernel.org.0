Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C89260CB4C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJYLx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiJYLx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:53:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B799F4181;
        Tue, 25 Oct 2022 04:53:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B6FB51F898;
        Tue, 25 Oct 2022 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1666698834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRKktY4aU99itUG0r84bU0CD/8p8OYqUqOyB0oh37xY=;
        b=kPGJPSHP/ctcYyrSx4oh8j7Pq2g4jdSlpl1HIhd3g5GbEnEvnmILzJduBPl/Ub/M7WIJHT
        +lvatm9XT01VSQouX3Vu/3blEzbDvFMnJ91eE0gllEI199WDbVL9gwUgWn9mp3e8TepnLj
        V/VRSEaQ+FCUgjPX9loL17ric1YBQM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1666698834;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRKktY4aU99itUG0r84bU0CD/8p8OYqUqOyB0oh37xY=;
        b=tq6qoYZadZVZsQfxh7vkftnRYo6UjWbK0LsSW0/VjN+Q7oNHoEjGITPqyvHjMXtFTMA41p
        R8yevLb3/5Lue1Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7056A134CA;
        Tue, 25 Oct 2022 11:53:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ynO5GlLOV2OJBwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 25 Oct 2022 11:53:54 +0000
Message-ID: <fabffcfd-4e7f-a4b8-69ac-2865ead36598@suse.cz>
Date:   Tue, 25 Oct 2022 13:53:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] mm: Make ksize() a reporting-only function
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Christoph Lameter <cl@linux.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mm@kvack.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20221022180455.never.023-kees@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20221022180455.never.023-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/22 20:08, Kees Cook wrote:
> With all "silently resizing" callers of ksize() refactored, remove the
> logic in ksize() that would allow it to be used to effectively change
> the size of an allocation (bypassing __alloc_size hints, etc). Users
> wanting this feature need to either use kmalloc_size_roundup() before an
> allocation, or use krealloc() directly.
> 
> For kfree_sensitive(), move the unpoisoning logic inline. Replace the
> some of the partially open-coded ksize() in __do_krealloc with ksize()
> now that it doesn't perform unpoisoning.
> 
> Adjust the KUnit tests to match the new ksize() behavior.
> 
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: linux-mm@kvack.org
> Cc: kasan-dev@googlegroups.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> This requires at least this be landed first:
> https://lore.kernel.org/lkml/20221021234713.you.031-kees@kernel.org/

Don't we need all parts to have landed first, even if the skbuff one is the
most prominent?

> I suspect given that is the most central ksize() user, this ksize()
> fix might be best to land through the netdev tree...
> ---
>  mm/kasan/kasan_test.c |  8 +++++---
>  mm/slab_common.c      | 33 ++++++++++++++-------------------
>  2 files changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/kasan/kasan_test.c b/mm/kasan/kasan_test.c
> index 0d59098f0876..cb5c54adb503 100644
> --- a/mm/kasan/kasan_test.c
> +++ b/mm/kasan/kasan_test.c
> @@ -783,7 +783,7 @@ static void kasan_global_oob_left(struct kunit *test)
>  	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
>  }
>  
> -/* Check that ksize() makes the whole object accessible. */
> +/* Check that ksize() does NOT unpoison whole object. */
>  static void ksize_unpoisons_memory(struct kunit *test)
>  {
>  	char *ptr;
> @@ -791,15 +791,17 @@ static void ksize_unpoisons_memory(struct kunit *test)
>  
>  	ptr = kmalloc(size, GFP_KERNEL);
>  	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> +
>  	real_size = ksize(ptr);
> +	KUNIT_EXPECT_GT(test, real_size, size);
>  
>  	OPTIMIZER_HIDE_VAR(ptr);
>  
>  	/* This access shouldn't trigger a KASAN report. */
> -	ptr[size] = 'x';
> +	ptr[size - 1] = 'x';
>  
>  	/* This one must. */
> -	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
> +	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
>  
>  	kfree(ptr);
>  }
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 33b1886b06eb..eabd66fcabd0 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1333,11 +1333,11 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
>  	void *ret;
>  	size_t ks;
>  
> -	/* Don't use instrumented ksize to allow precise KASAN poisoning. */
> +	/* Check for double-free before calling ksize. */
>  	if (likely(!ZERO_OR_NULL_PTR(p))) {
>  		if (!kasan_check_byte(p))
>  			return NULL;
> -		ks = kfence_ksize(p) ?: __ksize(p);
> +		ks = ksize(p);
>  	} else
>  		ks = 0;
>  
> @@ -1405,8 +1405,10 @@ void kfree_sensitive(const void *p)
>  	void *mem = (void *)p;
>  
>  	ks = ksize(mem);
> -	if (ks)
> +	if (ks) {
> +		kasan_unpoison_range(mem, ks);
>  		memzero_explicit(mem, ks);
> +	}
>  	kfree(mem);
>  }
>  EXPORT_SYMBOL(kfree_sensitive);
> @@ -1415,10 +1417,11 @@ EXPORT_SYMBOL(kfree_sensitive);
>   * ksize - get the actual amount of memory allocated for a given object
>   * @objp: Pointer to the object
>   *
> - * kmalloc may internally round up allocations and return more memory
> + * kmalloc() may internally round up allocations and return more memory
>   * than requested. ksize() can be used to determine the actual amount of
> - * memory allocated. The caller may use this additional memory, even though
> - * a smaller amount of memory was initially specified with the kmalloc call.
> + * allocated memory. The caller may NOT use this additional memory, unless
> + * it calls krealloc(). To avoid an alloc/realloc cycle, callers can use
> + * kmalloc_size_roundup() to find the size of the associated kmalloc bucket.
>   * The caller must guarantee that objp points to a valid object previously
>   * allocated with either kmalloc() or kmem_cache_alloc(). The object
>   * must not be freed during the duration of the call.
> @@ -1427,13 +1430,11 @@ EXPORT_SYMBOL(kfree_sensitive);
>   */
>  size_t ksize(const void *objp)
>  {
> -	size_t size;
> -
>  	/*
> -	 * We need to first check that the pointer to the object is valid, and
> -	 * only then unpoison the memory. The report printed from ksize() is
> -	 * more useful, then when it's printed later when the behaviour could
> -	 * be undefined due to a potential use-after-free or double-free.
> +	 * We need to first check that the pointer to the object is valid.
> +	 * The KASAN report printed from ksize() is more useful, then when
> +	 * it's printed later when the behaviour could be undefined due to
> +	 * a potential use-after-free or double-free.
>  	 *
>  	 * We use kasan_check_byte(), which is supported for the hardware
>  	 * tag-based KASAN mode, unlike kasan_check_read/write().
> @@ -1447,13 +1448,7 @@ size_t ksize(const void *objp)
>  	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !kasan_check_byte(objp))
>  		return 0;
>  
> -	size = kfence_ksize(objp) ?: __ksize(objp);
> -	/*
> -	 * We assume that ksize callers could use whole allocated area,
> -	 * so we need to unpoison this area.
> -	 */
> -	kasan_unpoison_range(objp, size);
> -	return size;
> +	return kfence_ksize(objp) ?: __ksize(objp);
>  }
>  EXPORT_SYMBOL(ksize);
>  

