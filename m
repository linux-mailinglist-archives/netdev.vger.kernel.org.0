Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77290F9722
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLRco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:32:44 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41010 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLRcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:32:43 -0500
Received: by mail-pl1-f194.google.com with SMTP id d29so9683914plj.8
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 09:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=g5EnIaW67IXl3e+lyfyMEx0JP31xG+YrRaWW+828rsA=;
        b=jU0Bpa2JX+z3DM3htJg81TASmFoqwE9b0CLylfIzBmEMK0t3jVEe6/uHzg3aGcBJD2
         JcANDBesbH4uQmKj/7UWSaOGmacuPfb1y2DvrM2Et9dqsrz8IDlJoZ0VzyQc9l6ceCUX
         4QDeGClhy/rxjUkr4vMos2nD5DRlYdAN5aGyV12WvgrKC8q5/nXG5a/VaQ2bBpcFWeRx
         igBQWtC1bcYddT51m+Ob5/4KT+w6VBF/DVJqqi4Ccd/wZIQpsHxMe1eiwukimUSTEbx7
         VBhnuJpSWpZne/IUB4eZsFf8RskC+73cvZ+n2d0NQKVvf2iuUhgL5f11OfrRpdBkCDTk
         6MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=g5EnIaW67IXl3e+lyfyMEx0JP31xG+YrRaWW+828rsA=;
        b=LWi/RaY4BwSlsIn005vUzbCCz4BmMCBpjnqDF++7KfQ0ZYKhdMuMwess+auaCLhRj4
         oLADwNIx7mQCq5kdvVVo8qhowcyz4W54mwxwiLmujh8meSF4Lt0ytTVxb6ScBaGCTHI+
         BFn1tn0dqqRh9p3TXHXsPhDImdcUIDDo5CZVsOfANGfR9Led5441IpwESdw3IhOa1Zai
         WPSUqWHZ5vkmSkja6DP6ESxHMGyayC8jP7/vA3P5YanQxAFdcqc3zFqObkR2CnhSxdPn
         uOo7lS1osCV6kOHvwrT5IGpBTom1xWZ6WJcFDdHVtbdgxmYbQQULq+43z1EThccUnse/
         qPrg==
X-Gm-Message-State: APjAAAWFNwETohQiaOR7gY24Gmg4EUj/YC6hvUBBybUuE8DlZhtvH1Im
        0nTgKEHyhgnlDKh1gRCncVE=
X-Google-Smtp-Source: APXvYqxA6byZk+dm2hJBYcSQK2oyYsB1IHAa64mQ14jb2gOI9W7D1QLRaZod791yIoOizKFuA4oV/g==
X-Received: by 2002:a17:902:690a:: with SMTP id j10mr12908251plk.67.1573579962827;
        Tue, 12 Nov 2019 09:32:42 -0800 (PST)
Received: from [172.26.105.13] ([2620:10d:c090:180::8f4f])
        by smtp.gmail.com with ESMTPSA id 83sm17971190pgh.86.2019.11.12.09.32.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 09:32:42 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Alexei Starovoitov" <ast@fb.com>
Cc:     "Jesper Dangaard Brouer" <brouer@redhat.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        "Kernel Team" <Kernel-team@fb.com>, ilias.apalodimas@linaro.org
Subject: Re: [net-next PATCH] page_pool: do not release pool until inflight ==
 0.
Date:   Tue, 12 Nov 2019 09:32:10 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <04EECB84-2958-4D59-BE2D-FD7ABD8E4C05@gmail.com>
In-Reply-To: <e4aa8923-7c81-a215-345c-a2127862048f@fb.com>
References: <20191112053210.2555169-1-jonathan.lemon@gmail.com>
 <20191112130832.6b3d69d5@carbon>
 <12C67CAA-4C7A-465D-84DD-8C3F94115CAA@gmail.com>
 <20191112174822.4b635e56@carbon>
 <e4aa8923-7c81-a215-345c-a2127862048f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12 Nov 2019, at 9:23, Alexei Starovoitov wrote:

> On 11/12/19 8:48 AM, Jesper Dangaard Brouer wrote:
>>> The trace_page_pool_state_release() does not dereference pool, it 
>>> just
>>> reports the pointer value, so there shouldn't be any use-after-free.
>> In the tracepoint we can still dereference the pool object pointer.
>> This is made easier via using bpftrace for example see[1] (and with 
>> BTF
>> this will become more common to do so).
>
> bpf tracing progs cannot assume that the pointer is valid.
> The program can remember a kernel pointer in a map and then
> access it days later.
> Like kretprobe on kfree_skb(). The skb is freed. 100% use-after-free.
> Such bpf program is broken and won't be reading meaningful values,
> but it won't crash the kernel.
>
> On the other side we should not be passing pointers to freed objects
> into tracepoints. That just wrong.
> May be simply move that questionable tracepoint?

Yes, move and simplify it.  I believe this patch should resolve the 
issue,
it just reports pages entering/exiting the pool, without trying to 
access
the counters - the counters are reported through the inflight 
tracepoint.
-- 
Jonathan

diff --git a/include/trace/events/page_pool.h 
b/include/trace/events/page_pool.h
index 47b5ee880aa9..0adf9aed9f5b 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -35,50 +35,46 @@ TRACE_EVENT(page_pool_inflight,
  	  __entry->pool, __entry->inflight, __entry->hold, __entry->release)
  );

-TRACE_EVENT(page_pool_state_release,
+TRACE_EVENT(page_pool_page_release,

  	TP_PROTO(const struct page_pool *pool,
-		 const struct page *page, u32 release),
+		 const struct page *page)

-	TP_ARGS(pool, page, release),
+	TP_ARGS(pool, page),

  	TP_STRUCT__entry(
  		__field(const struct page_pool *,	pool)
  		__field(const struct page *,		page)
-		__field(u32,				release)
  	),

  	TP_fast_assign(
  		__entry->pool		= pool;
  		__entry->page		= page;
-		__entry->release	= release;
  	),

-	TP_printk("page_pool=%p page=%p release=%u",
-		  __entry->pool, __entry->page, __entry->release)
+	TP_printk("page_pool=%p page=%p",
+		  __entry->pool, __entry->page)
  );

-TRACE_EVENT(page_pool_state_hold,
+TRACE_EVENT(page_pool_page_hold,

  	TP_PROTO(const struct page_pool *pool,
-		 const struct page *page, u32 hold),
+		 const struct page *page),

-	TP_ARGS(pool, page, hold),
+	TP_ARGS(pool, page),

  	TP_STRUCT__entry(
  		__field(const struct page_pool *,	pool)
  		__field(const struct page *,		page)
-		__field(u32,				hold)
  	),

  	TP_fast_assign(
  		__entry->pool	= pool;
  		__entry->page	= page;
-		__entry->hold	= hold;
  	),

-	TP_printk("page_pool=%p page=%p hold=%u",
-		  __entry->pool, __entry->page, __entry->hold)
+	TP_printk("page_pool=%p page=%p",
+		  __entry->pool, __entry->page)
  );

  #endif /* _TRACE_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bfe96326335d..05b93ea67ac5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -163,7 +163,7 @@ static struct page 
*__page_pool_alloc_pages_slow(struct page_pool *pool,
  	/* Track how many pages are held 'in-flight' */
  	pool->pages_state_hold_cnt++;

-	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	trace_page_pool_page_hold(pool, page);

  	/* When page just alloc'ed is should/must have refcnt 1. */
  	return page;
@@ -222,9 +223,11 @@ static void __page_pool_clean_page(struct page_pool 
*pool,
  			     DMA_ATTR_SKIP_CPU_SYNC);
  	page->dma_addr = 0;
  skip_dma_unmap:
+	trace_page_pool_page_release(pool, page);
+	/* This may be the last page returned, releasing the pool, so
+	 * it is not safe to reference pool afterwards.
+	 */
  	atomic_inc(&pool->pages_state_release_cnt);
-	trace_page_pool_state_release(pool, page,
-			      atomic_read(&pool->pages_state_release_cnt));
  }

  /* unmap the page and clean our state */
