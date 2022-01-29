Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820FC4A32AA
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353466AbiA2XkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353464AbiA2XkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:14 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07450C06173B
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:14 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id j10so8656211pgc.6
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EZpuFdvqL88AwGUcDLPACkayKgEAfVa9VWvyXah0H48=;
        b=l1dSfwiMGeC8i57oJdo5sV1jtrGods/IFM2x58eErut76zl2LT5HnS74V2ceFHxBI1
         HtqLXXuJGzAx3kWnDpVF95N7U1FX/P1p5D8kXi/Arz6TS3+V6Rd5b9DgqvUN7PagDnFD
         PiWXxiInrYuGTZ8TGPY50NPI6kva5YEi5qhkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EZpuFdvqL88AwGUcDLPACkayKgEAfVa9VWvyXah0H48=;
        b=CyecRe2KhbjBtu1je/MiKNS4POLbZ+jUS+GTKFsNsNB5BjQIsic5eCqcwSGkXJU6gz
         VcekoEVRkHzwjeHOKUjZd5x6kvenkl66g14j8mHFlRvdWEZtSx/pTbukDIai7gCBHHHO
         nQ2Toj0RkLRuK8Df7lTxyVLRcNFy90lHqRJvf/SdZwrk17/WmlNvo22F1S9Oc0pNAxeU
         J9ZUzrWHucfM6yKG8dJ5ALZIStZLFmCdevtGYIZjFtZWQLJb5IMXoKc92nNjvahMAbGa
         4p1/C4QUBfriW5yWyLtH2KFSp7mZ5yEV9d4z/phxLwRDNoPazT6hK6GiY518AIqff7r2
         8VMQ==
X-Gm-Message-State: AOAM531AUsm1oFTwRk0oBxkXaD6a8Q9qcsoJ6j1PU6jYILPYh1vbYzxN
        ptnKOJDOG+Yj+i7aswDjQkF8jCKRa14M88dRlEEpbUs1wrGR/IIL+HDNo/Op72co/LwG7vXlLLa
        Y2Wst6zbvlttZsX7QGUy/pGW8S3hWlVAPGAICwSa1UEA6/Aqa/xD6HZLyMeIUa0VCtyJ9
X-Google-Smtp-Source: ABdhPJyAo5kCL4EfYhPn480Jf+Q63EvJGRNM45zQGtK7JOm/a/9HkvP3BwvKezIMg8gyJvIgoMyH/Q==
X-Received: by 2002:a63:1641:: with SMTP id 1mr11492139pgw.396.1643499613165;
        Sat, 29 Jan 2022 15:40:13 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:12 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 07/10] page_pool: Add stat tracking empty ring
Date:   Sat, 29 Jan 2022 15:38:57 -0800
Message-Id: <1643499540-8351-8-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking when the ptr ring is empty. When this occurs, the cache
could not be refilled and a slow path allocation was forced.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 3 +++
 net/core/page_pool.c    | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index f59b8a9..ed2bc73 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -146,6 +146,9 @@ struct page_pool_stats {
 		u64 fast; /* fast path allocations */
 		u64 slow; /* slow-path order-0 allocations */
 		u64 slow_high_order; /* slow-path high order allocations */
+		u64 empty; /* failed refills due to empty ptr ring, forcing
+			    * slow path allocation
+			    */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 24306d6..9d20b12 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -131,8 +131,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	int pref_nid; /* preferred NUMA node */
 
 	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
+	if (__ptr_ring_empty(r)) {
+		page_pool_stat_alloc_inc(empty);
 		return NULL;
+	}
 
 	/* Softirq guarantee CPU and thus NUMA node is stable. This,
 	 * assumes CPU refilling driver RX-ring will also run RX-NAPI.
-- 
2.7.4

