Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31584A917F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356183AbiBDALK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356182AbiBDALA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:11:00 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4DCC06173B
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:11:00 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id h125so3652588pgc.3
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hVma1L7yzdNLRu5n0rcjVM6eMRF2wNpEoUXbLpIYTeg=;
        b=hiDBwiR5i6Bb8//YZOL2txRf67ENI489euYlmbiXv41kFewRXwb2zpQlmU94/4a3JU
         GSBTy5Ed0q/IOTGwNC7aNn3VCbdmr05sp9tkuGitQWYhmQZyMCKT2piDpDC4jt/9jcaj
         DrcImzv+/lXy1vciI+mIVSF1yu4owXTotLpQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hVma1L7yzdNLRu5n0rcjVM6eMRF2wNpEoUXbLpIYTeg=;
        b=v5oeKIgebfJIJQzqlFUcyWLgIF3JYXXiL6plRLnYhfo5xEWPDgLQVcic1qzf2t+ihx
         Zi831OhjDdSv4st1cO/ZKHvXDanvWRuXBho4zDIISxRVyhUW+sZEcmyCZhow4okVJpTV
         wR+iFHRqNJdmyJ9/BeGfKeyA2flpY+w+hqiOcqLrxtvdIHfg9pturXCigjj07ze1lY1f
         YwWuiHN2ktXl1ZlW0Y7XadaEK0qqfRo7qVQQmrXh1Rt9Jo7m6UhJ0KwcZsr2dO+CIrrp
         kW4ZVvt/PxzkMr8qH8kNhUHP+qSZOkHzSNTuC3rYLL2b4g8J7F27xJh2lczt/orpnJq6
         MBkg==
X-Gm-Message-State: AOAM532nuEhtl5h4VorC4wYrKyUWXN4Fv1riS5Y4t++E8YOV+vLXx87K
        MzIZ1oG78QB9SHsvrFGn8CssgWFuhw5w1IfGskjQHWTSQsmgVZBFMf/8qNMrWDnqCSPxSKQn20a
        ucXb6wemnsstvlAJggF0cVyi4/U+tvkQlEh369zNpAFN5+FDRqm8/0H7qFjRnIUZM44JB
X-Google-Smtp-Source: ABdhPJxp/+FhWhTDitV9FyO3D+j03rhYgfmnHv8yCfvEhDpcnQdVXNYY3lBa2Uh+CNOe2RFeN4an2A==
X-Received: by 2002:a05:6a00:23d3:: with SMTP id g19mr452794pfc.27.1643933458945;
        Thu, 03 Feb 2022 16:10:58 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id z22sm159822pfe.42.2022.02.03.16.10.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:10:58 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v4 10/11] page_pool: Add a stat tracking waived pages
Date:   Thu,  3 Feb 2022 16:09:32 -0800
Message-Id: <1643933373-6590-11-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
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
index 65cd0ca..bb87706 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -150,6 +150,7 @@ struct page_pool_stats {
 			    * slow path allocation
 			    */
 		u64 refill; /* allocations via successful refill */
+		u64 waive;  /* failed refills due to numa zone mismatch */
 	} alloc;
 };
 #endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 4fe48ec..0bd084c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -166,6 +166,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 			 * This limit stress on page buddy alloactor.
 			 */
 			page_pool_return_page(pool, page);
+			this_cpu_inc_alloc_stat(pool, waive);
 			page = NULL;
 			break;
 		}
-- 
2.7.4

