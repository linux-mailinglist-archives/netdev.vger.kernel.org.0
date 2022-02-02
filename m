Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D04A6989
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243618AbiBBBNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbiBBBNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:21 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F385EC06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:20 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cq9-20020a17090af98900b001b8262fe2d5so981155pjb.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QbO+mRA437kEIBKYkoV8UATS3Q+q6DqWwFp2zvezEIo=;
        b=dpm3DgcxuR1zI8VIs5K1qszDWyt7wE2tMPvffPa30dfpQXAcEDIrK1ONpbxNp1kid0
         DJx78AW3I57LAnJWEApspcN53qlp11xvpx0IXYteq1zpQo8HcHsPmeaA3S7MFC7UOuL6
         jTd/E0u9liS3wc3a36ovrn3WoFLazJl6C3q4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QbO+mRA437kEIBKYkoV8UATS3Q+q6DqWwFp2zvezEIo=;
        b=7NfNjl56ni0vHz+CUT8cO3HTWynFC7F3OY6hH656TUXofn+L8ALa6/I6ErXGvTJH6h
         TCYpYD6JT1k2h1KsDSfOUrBJvE31Jnl80JlcbEeDv4JGUQpeXT4W+pg6r2ALr8jOVsbe
         5x891oiU7mu6iFBY7/zHoKfaIKxT6z4WngWUxi4fOyXkLRuhOsFbGNaMbkKs9BZ/vga3
         AUVqcKg5xADdiEz8xV3HcE3LZ0lOi7BCFiX6Gu13NfO2xqjlqB8NwHHk6C9yJyD3/P70
         TrXHI9gkYKYzV27lHUWzdKZjjmvlHtSRnBNj0uqkHsHeSRWypc46HApNghZIOMnIpdsJ
         CBdQ==
X-Gm-Message-State: AOAM530AuBRmHMhYjqyl2sgKO4sPYOKF9Ugw91LD9Vr4qrrsQHpixlnO
        mMEJQnunUYqn11jhYUYNY179ZPD5aAZF601X0cJ1SQnWiucNUzi0qw8CGJT4dYTNLJIYzklmUbx
        9/vgrGM8J6lOir76VJXIZbxtp19xsg6Z3wcZSQizfIm9HnMcfyvAr+HAe8hffTpWOlFa5
X-Google-Smtp-Source: ABdhPJzKRxstrcnVBtdAMV43S7UcCalL1mvfxdxXdUxF0RGhH8ymQD1O0ga+57kH0oG+LPlMG3knuw==
X-Received: by 2002:a17:902:8504:: with SMTP id bj4mr28919966plb.108.1643764399466;
        Tue, 01 Feb 2022 17:13:19 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:18 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 08/10] page_pool: Add stat tracking cache refill
Date:   Tue,  1 Feb 2022 17:12:14 -0800
Message-Id: <1643764336-63864-9-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a stat tracking succesfull allocations which triggered a refill.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index ed2bc73..4991109 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -149,6 +149,7 @@ struct page_pool_stats {
 		u64 empty; /* failed refills due to empty ptr ring, forcing
 			    * slow path allocation
 			    */
+		u64 refill; /* allocations via successful refill */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9d20b12..00adab5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -167,8 +167,10 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 	} while (pool->alloc.count < PP_ALLOC_CACHE_REFILL);
 
 	/* Return last page */
-	if (likely(pool->alloc.count > 0))
+	if (likely(pool->alloc.count > 0)) {
 		page = pool->alloc.cache[--pool->alloc.count];
+		page_pool_stat_alloc_inc(refill);
+	}
 
 	return page;
 }
-- 
2.7.4

