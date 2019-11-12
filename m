Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9BFF95B9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKLQeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:34:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37684 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfKLQeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:34:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id p24so13756142pfn.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 08:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=DPhj+FISsB9CiFwJ01uBH2Csdf/68H9gz95We6SZpqY=;
        b=gprobbZaEl2PLQvySK0bsFIEodsIEjC1/kx6Uy0GBS/JI70GQer2PYNyQ2WEf5wp8T
         TFOLemddyNnGfiLgZxzFpwNqc8H74GtxNMC/Mxit0+odX8IiPXpnztu8H7PyELozX5Ja
         Q/FZeafBc1DOo707Tep7Wn3Dx2YvyClr9qC2wgxrRzdyTjKq2YXsEbiP9PAag7XAe1H7
         uhiFKonVDRbzy8tVKLdCMrVsLgJlIeB0knzoeTwCq/tveB4GMLYMkhkJe8X7eHWZiYGZ
         VIGm8aLAG+upZCVU7aJl5A5/cPJ7HAmLouHtwHFLp8T76tnBhmr10nd2kerDxNDhB4vP
         JTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=DPhj+FISsB9CiFwJ01uBH2Csdf/68H9gz95We6SZpqY=;
        b=AsiWE8xw34QoFexnBd3OIbnRoCTbHny+r1agd3CBoYFnrN51iuQU/TiZbejjr0gVYe
         41LPKUY8tYon+dko2+PSOZSDpVrJ6974aYaTMUpM6xccyJfneCqiqR3xN+G4sQXRbCP7
         HxJdy1TmGzcT5y4joRjxfhB1S51OCk/5xEbABXTZ5r5/xuO2piPaloSk/sosInrqF766
         KmWdEO4NiOO27uJSkbt2QC6jZyPxVGDo9oj2+ejv47RH7ovqLJiqX1leJ7VNKcM/ZztR
         m/RQHnimd5pFMZ0yAqyVIbcRATcV2AKOckbgKzWMTcYhwMZvDbv+aUtvledoMcSwyb8Y
         l5ng==
X-Gm-Message-State: APjAAAXo6Kzkxj9NtGdmtgJzT0hlntLOzgF5bA5vT86ou4K2GpsRiJVE
        W3jAARBNOa1KwDYxi0OfcFQ=
X-Google-Smtp-Source: APXvYqyVc4wKkYHvgFKScESixvi2JuKfqpGJ45IKDvtoNpRFH90NmkiWlZsLs0aWdtA5b6Vc92MLww==
X-Received: by 2002:aa7:9f0e:: with SMTP id g14mr38831352pfr.202.1573576440543;
        Tue, 12 Nov 2019 08:34:00 -0800 (PST)
Received: from [172.26.105.13] ([2620:10d:c090:180::8f4f])
        by smtp.gmail.com with ESMTPSA id l74sm604960pje.29.2019.11.12.08.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 08:33:59 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com,
        ilias.apalodimas@linaro.org
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight ==
 0.
Date:   Tue, 12 Nov 2019 08:33:58 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
In-Reply-To: <20191112130832.6b3d69d5@carbon>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
 <20191112130832.6b3d69d5@carbon>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 Nov 2019, at 4:08, Jesper Dangaard Brouer wrote:

> On Mon, 11 Nov 2019 21:32:10 -0800
> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>> The page pool keeps track of the number of pages in flight, and
>> it isn't safe to remove the pool until all pages are returned.
>>
>> Disallow removing the pool until all pages are back, so the pool
>> is always available for page producers.
>>
>> Make the page pool responsible for its own delayed destruction
>> instead of relying on XDP, so the page pool can be used without
>> xdp.
>
> Can you please change this to:
>  [... can be used without] xdp memory model.

Okay.


>> When all pages are returned, free the pool and notify xdp if the
>> pool is registered with the xdp memory system.  Have the callback
>> perform a table walk since some drivers (cpsw) may share the pool
>> among multiple xdp_rxq_info.
>>
>> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic 
>> warning")
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
> [...]
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 5bc65587f1c4..bfe96326335d 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
> [...]
>
> Found an issue, see below.
>
>> @@ -338,31 +333,10 @@ static void __page_pool_empty_ring(struct 
>> page_pool *pool)
>>  	}
>>  }
>>
>> -static void __warn_in_flight(struct page_pool *pool)
>> +static void page_pool_free(struct page_pool *pool)
>>  {
>> -	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
>> -	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
>> -	s32 distance;
>> -
>> -	distance = _distance(hold_cnt, release_cnt);
>> -
>> -	/* Drivers should fix this, but only problematic when DMA is used 
>> */
>> -	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
>> -	     distance, hold_cnt, release_cnt);
>> -}
>> -
>> -void __page_pool_free(struct page_pool *pool)
>> -{
>> -	/* Only last user actually free/release resources */
>> -	if (!page_pool_put(pool))
>> -		return;
>> -
>> -	WARN(pool->alloc.count, "API usage violation");
>> -	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>> -
>> -	/* Can happen due to forced shutdown */
>> -	if (!__page_pool_safe_to_destroy(pool))
>> -		__warn_in_flight(pool);
>> +	if (pool->disconnect)
>> +		pool->disconnect(pool);
>>  	ptr_ring_cleanup(&pool->ring, NULL);
>>
>> @@ -371,12 +345,8 @@ void __page_pool_free(struct page_pool *pool)
>>
>>  	kfree(pool);
>>  }
>> -EXPORT_SYMBOL(__page_pool_free);
>
> I don't think this is correct according to RCU.
>
> Let me reproduce the resulting version of page_pool_free():
>
>  static void page_pool_free(struct page_pool *pool)
>  {
> 	if (pool->disconnect)
> 		pool->disconnect(pool);
>
> 	ptr_ring_cleanup(&pool->ring, NULL);
>
> 	if (pool->p.flags & PP_FLAG_DMA_MAP)
> 		put_device(pool->p.dev);
>
> 	kfree(pool);
>  }
>
> The issue is that pool->disconnect() will call into
> mem_allocator_disconnect() -> mem_xa_remove(), and mem_xa_remove() 
> does
> a RCU delayed free.  And this function immediately does a kfree(pool).
>
> I do know that we can ONLY reach this page_pool_free() function, when
> inflight == 0, but that can happen as soon as __page_pool_clean_page()
> does the decrement, and after this trace_page_pool_state_release()
> still have access the page_pool object (thus, hard to catch 
> use-after-free).

Is this an issue?  The RCU delayed free is for the xa object, it is held
in an RCU-protected mem_id_ht, so it can't be freed until all the 
readers
are complete.

The change of &pool->pages_state_release_cnt can decrement the inflight
pages to 0, and another thread could see inflight == 0 and immediately
the remove the pool.  The atomic manipulation should be the last use of
the pool - this should be documented, I'll add that as well:

skip_dma_unmap:
         /* This may be the last page returned, releasing the pool, so
          * it is not safe to reference pool afterwards.
          */
         count = atomic_inc_return(&pool->pages_state_release_cnt);
         trace_page_pool_state_release(pool, page, count);

The trace_page_pool_state_release() does not dereference pool, it just
reports the pointer value, so there shouldn't be any use-after-free.
-- 
Jonathan
