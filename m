Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DD949D5BA
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiAZWwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiAZWwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:52:00 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8689FC061749
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:52:00 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y17so891119plg.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3XamyOUKOhYOUIf/RQQ4uu6WCjRVfiMgJ0/RAAtZBoY=;
        b=K1VMLE5Pur93VHjsvualZ92NugEpEzbEXz6Rpayh6pQM55+6IaCthqPTgHM543FK6e
         5h8JTRdw23CkAPR3xovJg3OJeQkQ17z82Mu8eVGtk+B8f64pCQy2LGTn8zG+98W+oOjg
         OVaVQfdJGmuDWIWl9xI/hW66OdBRyUE+9c2ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3XamyOUKOhYOUIf/RQQ4uu6WCjRVfiMgJ0/RAAtZBoY=;
        b=1tUH4BO3k6TNsNsd9z4jf1OvD0J1e8K6LpbbBv7iDI4CWnKOM8qToX4jYX0YI/Ilir
         SOUruFXMTntK6q2XF5Xo/XtOLYgW9gVB65CrMxDBBtgMIavk2hipTLqLUW7+ToaLoeKu
         zhpKd44HbbFb2G+3t8Q46ajGDw/5zxve/t90TCZEk+bzZU7u8a4Dx+RhJpFy35lR8wax
         Utk1irBA45vs87d2ffoeix9hJDKZFeJF7fYQb5vRZ/rGBbTYijZPmlLRiKI6AOm82uaz
         IoureADRKw87GytaDu6LHSgiJ866++agM4AgCuLluflCGIi+r539CmebNRD4mw6VPN+K
         1S9w==
X-Gm-Message-State: AOAM530iGgHB4QnM+OTbdDFvMJ2W5vPHSlOxPDkhJyVzK9HhYY0/MM7I
        52EUdTEcqJ+BNj1Ipa9tS2tqNHDTXzYPSrhaI5vHH55+iv+ITRgLWRUs1lFTSUx4tz9ys7c9uVa
        DpuNYWVSYp4oBSyJhLwJ6ycIutCP72lAioPknc195Kc9We6Dj98/tVbWp8mRr8NG0uvEa
X-Google-Smtp-Source: ABdhPJwomOY+A7Ps2AhNrNrqPaSHN1WQV6vVvvCkyOcjQjAz1Xb50wDlKHi8BoTrDMXp8tDWbghgkA==
X-Received: by 2002:a17:903:1cd:: with SMTP id e13mr644704plh.158.1643237519389;
        Wed, 26 Jan 2022 14:51:59 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.51.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:51:58 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH 6/6] net: page_pool: Add a stat tracking waived pages.
Date:   Wed, 26 Jan 2022 14:48:20 -0800
Message-Id: <1643237300-44904-7-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track how often pages obtained from the ring cannot be added to the cache
because of a NUMA mismatch. A static inline wrapper is added for accessing
this stat.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/net/page_pool.h | 11 +++++++++++
 net/core/page_pool.c    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a68d05f..cf65d78 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -88,6 +88,7 @@ struct page_pool_stats {
 			    * slow path allocation
 			    */
 		u64 refill; /* allocations via successful refill */
+		u64 waive;  /* failed refills due to numa zone mismatch */
 	} alloc;
 };
 
@@ -226,6 +227,11 @@ static inline u64 page_pool_stats_get_refill(struct page_pool *pool)
 {
 	return pool->ps.alloc.refill;
 }
+
+static inline u64 page_pool_stats_get_waive(struct page_pool *pool)
+{
+	return pool->ps.alloc.waive;
+}
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -270,6 +276,11 @@ static inline u64 page_pool_stats_get_refill(struct page_pool *pool)
 {
 	return 0;
 }
+
+static inline u64 page_pool_stats_get_waive(struct page_pool *pool)
+{
+	return 0;
+}
 #endif
 
 void page_pool_put_page(struct page_pool *pool, struct page *page,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 15f4e73..7c4ae2e 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -147,6 +147,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			 * This limit stress on page buddy alloactor.
 			 */
 			page_pool_return_page(pool, page);
+			pool->ps.alloc.waive++;
 			page = NULL;
 			break;
 		}
-- 
2.7.4

