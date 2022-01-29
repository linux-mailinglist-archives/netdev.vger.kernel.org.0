Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5C54A32AD
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353487AbiA2XkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 18:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353479AbiA2XkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 18:40:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC16C061753
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:16 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so14482346pju.2
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 15:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dJc+WeEpXTCtUAsBZBL3YsLvPmU50z2QJlgbbdI6CRs=;
        b=RUNjwi2mmjE5/Hs+Z89naGLKYdXCUvkFdDCORVO47p/rVfC5Ff9/ptYTsNQcbbEo7G
         iI0XgJZRjeDqx8dsD1aF01jNN7uHsAEfl1uhYwK38lYvUYExD1HAgRRfZ5S1NF/VhSdb
         gVeLLYRfosAdoooIqhTci/fOz4UpK4l7AIBGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dJc+WeEpXTCtUAsBZBL3YsLvPmU50z2QJlgbbdI6CRs=;
        b=m5lz0uXuLkHFDmjhMoJc/DthotnOUVbPasoLYz4kbSDHyPYilkFZWFqJOyEvVXqd+c
         Mu8IJ58+OTXUkhx9OKwkO0jBh38cR5FDPQZNVpx85JhQDmPuVyKMaPYgIZ/kMYWF9Cdu
         4/UKyisw9d6k6iCv+BLRqwaCKqOLngG4PcTbxC/jXpZG703axE98+ZP9a3qVXvOe8iJN
         shDFYAPzpaVqmSchHsbMATZcGK0YPIv4WX2VlEpAuFq5CXaKNPttrPdz+HX8J77Bs9NU
         Dt33Gy+m1gsOyNRyrek7LJhrfGyS11MQk7Rvfugvo9ipuDvuxHqU/b/JXvWbkg6JxyD4
         ZrwQ==
X-Gm-Message-State: AOAM531DINDzT3LYSVD8hedfNJToyKepyBdfja/sTDniM76Wm3sVDTXg
        +wBDBUWJrOcbQK2HTLZPjrzMxSuPOgSIKPU86DdX2NUU0TK3Nyp8AE2fgsnS1Uhj1ncMiUuL2O9
        AvnL+LIsGpV+E6HEHp+y9YkApr3iYoBm2qZQm1v1fUFhrs7iWGFz3dFTsvau4ewtibzyu
X-Google-Smtp-Source: ABdhPJzR1u/twS9ESa31rcx4irMNdOuitUJvlWpFILQEsSRzlrdwqFr8yZczA4RLSixG4Lm1K/GwoA==
X-Received: by 2002:a17:902:eccb:: with SMTP id a11mr15062818plh.121.1643499615908;
        Sat, 29 Jan 2022 15:40:15 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id gb5sm6573276pjb.16.2022.01.29.15.40.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jan 2022 15:40:15 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v2 09/10] page_pool: Add a stat tracking waived pages
Date:   Sat, 29 Jan 2022 15:38:59 -0800
Message-Id: <1643499540-8351-10-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
References: <1643499540-8351-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track how often pages obtained from the ring cannot be added to the cache
because of a NUMA mismatch.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 1 +
 net/core/page_pool.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 4991109..e411ef6 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -150,6 +150,7 @@ struct page_pool_stats {
 			    * slow path allocation
 			    */
 		u64 refill; /* allocations via successful refill */
+		u64 waive;  /* failed refills due to numa zone mismatch */
 	} alloc;
 };
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ffb68b8..c6f31c5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -161,6 +161,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			 * This limit stress on page buddy alloactor.
 			 */
 			page_pool_return_page(pool, page);
+			page_pool_stat_alloc_inc(waive);
 			page = NULL;
 			break;
 		}
-- 
2.7.4

