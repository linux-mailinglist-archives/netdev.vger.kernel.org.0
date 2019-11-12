Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A4EF96D4
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfKLROx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:53 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33406 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLROx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:14:53 -0500
Received: by mail-pf1-f193.google.com with SMTP id c184so13858187pfb.0
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 09:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=o6LJZhwKflP1d1NL6VA403/lEpKKpxma3g1FymYAfPE=;
        b=h+rzlOcHT6v0592ErW0+uB6g3cruAZfk3wIUlPQFkqSjWvmktzSJGJ1ufuuO4gJVfd
         3jizhRTElNqXKh4la+DjxU5tz2uXPisWZimT9MlLQfcC6OfrNgWyMaCksGbv5ng2F71t
         NaSGMCVy8nE7V3wZgxW2knJHnCEw8pbwVZEte4AszDLKfnOzhRo+gj/MyKwyxczPA3FN
         eBrgZsa48KCOHd/GZ0pPZTmgRfsR9iUvc6Q7C/cSp9Xj5fwehGUEtAtS1IwJmy2/L3Km
         cErkmtzg7+trWlwcWMBfcXUapGeYru7ogYjjTIAHP+ABusuxyEPslIMuOgIPKy1uag/I
         XODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=o6LJZhwKflP1d1NL6VA403/lEpKKpxma3g1FymYAfPE=;
        b=CoOSutWUXEfv6KkeEKoBifUTz80kTRfwdJukJQUCZdI20r46+7MRLhM0o1fm5Ikeln
         y1s7A7xyhZEhxaLNYQVGPeBN9DrGB7Q6RNrpSwO3HRFN02SoGFNSMf30WchuimgNonen
         TFaRcYZ1jd24OE4u0zxrpJEwErBEOQSCpAdni8R9TyPQA44A9tdD4kvUjjiW+ieHo6TO
         7KO1/9pj3TSsQOux+H3Iup9yECunuJdsSAKjlHbVMw0cIk+4eMSlYFqlinzsBC9VvyOP
         nReHLSUcmaHzokDOr1b8HcWe0o6w8zji1SADuNz6IQ62vAySeQ2h0+SfN5DeD4mq2uNL
         zBxA==
X-Gm-Message-State: APjAAAVseSfApcJL8SyNfjKCj92tfsAYaMDiG/g0vuJ80scBHCYvCf14
        Y8BONTh0agYtlhlZiHqArNk=
X-Google-Smtp-Source: APXvYqwC5TLyasJXYQjQdP09B5jTu2BDklrjJuiROXmk8RvYN3DAFDmGeD5wMdzYEnvEy8Fw7CcysQ==
X-Received: by 2002:a17:90a:ca0e:: with SMTP id x14mr7950393pjt.95.1573578892243;
        Tue, 12 Nov 2019 09:14:52 -0800 (PST)
Received: from [172.26.105.13] ([2620:10d:c090:180::8f4f])
        by smtp.gmail.com with ESMTPSA id w69sm13094514pfc.164.2019.11.12.09.14.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 09:14:51 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com,
        ilias.apalodimas@linaro.org
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight ==
 0.
Date:   Tue, 12 Nov 2019 09:14:50 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <A46945E9-A060-4621-BB43-63C940F6E4B9@gmail.com>
In-Reply-To: <20191112174822.4b635e56@carbon>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
 <20191112130832.6b3d69d5@carbon>
 <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
 <20191112174822.4b635e56@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12 Nov 2019, at 8:48, Jesper Dangaard Brouer wrote:

> On Tue, 12 Nov 2019 08:33:58 -0800
> "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
>
>> On 12 Nov 2019, at 4:08, Jesper Dangaard Brouer wrote:
>>
>>> On Mon, 11 Nov 2019 21:32:10 -0800
>>> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>>
>>>> The page pool keeps track of the number of pages in flight, and
>>>> it isn't safe to remove the pool until all pages are returned.
>>>>
>>>> Disallow removing the pool until all pages are back, so the pool
>>>> is always available for page producers.
>>>>
>>>> Make the page pool responsible for its own delayed destruction
>>>> instead of relying on XDP, so the page pool can be used without
>>>> xdp.
>>>
>>> Can you please change this to:
>>>  [... can be used without] xdp memory model.
>>
>> Okay.
>>
>>
>>>> When all pages are returned, free the pool and notify xdp if the
>>>> pool is registered with the xdp memory system.  Have the callback
>>>> perform a table walk since some drivers (cpsw) may share the pool
>>>> among multiple xdp_rxq_info.
>>>>
>>>> Fixes: d956a048cd3f ("xdp: force mem allocator removal and periodic
>>>> warning")
>>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>>> ---
>>> [...]
>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>>> index 5bc65587f1c4..bfe96326335d 100644
>>>> --- a/net/core/page_pool.c
>>>> +++ b/net/core/page_pool.c
>>> [...]
>>>
>>> Found an issue, see below.
>>>
>>>> @@ -338,31 +333,10 @@ static void __page_pool_empty_ring(struct
>>>> page_pool *pool)
>>>>  	}
>>>>  }
>>>>
>>>> -static void __warn_in_flight(struct page_pool *pool)
>>>> +static void page_pool_free(struct page_pool *pool)
>>>>  {
>>>> -	u32 release_cnt = atomic_read(&pool->pages_state_release_cnt);
>>>> -	u32 hold_cnt = READ_ONCE(pool->pages_state_hold_cnt);
>>>> -	s32 distance;
>>>> -
>>>> -	distance = _distance(hold_cnt, release_cnt);
>>>> -
>>>> -	/* Drivers should fix this, but only problematic when DMA is used
>>>> */
>>>> -	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
>>>> -	     distance, hold_cnt, release_cnt);
>>>> -}
>>>> -
>>>> -void __page_pool_free(struct page_pool *pool)
>>>> -{
>>>> -	/* Only last user actually free/release resources */
>>>> -	if (!page_pool_put(pool))
>>>> -		return;
>>>> -
>>>> -	WARN(pool->alloc.count, "API usage violation");
>>>> -	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>>>> -
>>>> -	/* Can happen due to forced shutdown */
>>>> -	if (!__page_pool_safe_to_destroy(pool))
>>>> -		__warn_in_flight(pool);
>>>> +	if (pool->disconnect)
>>>> +		pool->disconnect(pool);
>>>>  	ptr_ring_cleanup(&pool->ring, NULL);
>>>>
>>>> @@ -371,12 +345,8 @@ void __page_pool_free(struct page_pool *pool)
>>>>
>>>>  	kfree(pool);
>>>>  }
>>>> -EXPORT_SYMBOL(__page_pool_free);
>>>
>>> I don't think this is correct according to RCU.
>>>
>>> Let me reproduce the resulting version of page_pool_free():
>>>
>>>  static void page_pool_free(struct page_pool *pool)
>>>  {
>>> 	if (pool->disconnect)
>>> 		pool->disconnect(pool);
>>>
>>> 	ptr_ring_cleanup(&pool->ring, NULL);
>>>
>>> 	if (pool->p.flags & PP_FLAG_DMA_MAP)
>>> 		put_device(pool->p.dev);
>>>
>>> 	kfree(pool);
>>>  }
>>>
>>> The issue is that pool->disconnect() will call into
>>> mem_allocator_disconnect() -> mem_xa_remove(), and mem_xa_remove()
>>> does
>>> a RCU delayed free.  And this function immediately does a kfree(pool).
>>>
>>> I do know that we can ONLY reach this page_pool_free() function, when
>>> inflight == 0, but that can happen as soon as __page_pool_clean_page()
>>> does the decrement, and after this trace_page_pool_state_release()
>>> still have access the page_pool object (thus, hard to catch
>>> use-after-free).
>>
>> Is this an issue?  The RCU delayed free is for the xa object, it is held
>> in an RCU-protected mem_id_ht, so it can't be freed until all the
>> readers
>> are complete.
>>
>> The change of &pool->pages_state_release_cnt can decrement the inflight
>> pages to 0, and another thread could see inflight == 0 and immediately
>> the remove the pool.  The atomic manipulation should be the last use of
>> the pool - this should be documented, I'll add that as well:
>>
>> skip_dma_unmap:
>>          /* This may be the last page returned, releasing the pool, so
>>           * it is not safe to reference pool afterwards.
>>           */
>>          count = atomic_inc_return(&pool->pages_state_release_cnt);
>>          trace_page_pool_state_release(pool, page, count);
>>
>> The trace_page_pool_state_release() does not dereference pool, it just
>> reports the pointer value, so there shouldn't be any use-after-free.
>
> In the tracepoint we can still dereference the pool object pointer.
> This is made easier via using bpftrace for example see[1] (and with BTF
> this will become more common to do so).

This seems problematic today - essentially the current code is only
safe because it's borrowing the RCU protection from the xdp_mem info,
right?
-- 
Jonathan
