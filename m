Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348674A698A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243645AbiBBBNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 20:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243652AbiBBBNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 20:13:22 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20EAC06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 17:13:21 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k17so16942748plk.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 17:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=C8VUXPM7TXe0m5OvMX/WoLxUo7hUGvGMBbngPBOXhII=;
        b=w/essKQEqLTCNunGkh/PMXbvgmvgD9H2PdbruyRxvERCKgoASTDsdNObxydRAs2szn
         28f7oCBKpgbUG2/ZOTO3Pn6eMFwHdFP910fzF4NeaPwNaOLhwp9d8ZTYJnlGaOj2FIch
         iKlQinKt4xhWcebluzW1fPge8soWC6cYoj5K0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C8VUXPM7TXe0m5OvMX/WoLxUo7hUGvGMBbngPBOXhII=;
        b=Xs/mgwgCOs/EvRrhFcNeyBny+W8Vc0+sev20Gvbmys/ayOeYWbsgNcqgomP8e/ZDXO
         o5dAf1epk5QWG2ounFarYtjsH+Q3hk10E/0R2xntiLwfzN1st64eqD2Q/BjAmHwrXLdU
         NM0HabYpbmbGj+rpKxyejbnYWhiRmLukUERQLDLEzhMN7ShFA2aPed1ZT5C9xrDxUGRM
         P/TdtNV1LoEs86H2RWDpFCps4375W7USCdkR1hq4ELJ4ySyMtjRGffDBFNYhu3hQTya8
         2LtrV1JlzszpZg5aaETwgk5xpOMiIZcAJQbxji014Zjfmy2pewcLUZ4jMvPE5BuQlXtR
         DD9g==
X-Gm-Message-State: AOAM531lQ14wPkHk0LTbKfk2WhNcgX8gWpY9qeyqnc1bSnc/T754ZfVc
        /9KnYYVkowFYZFtYKX3OKf5e/npU8lgzpVnN/XGYarZ/lJt9Sk7uWej4lNvL6WBen7zJOsFockB
        aIZpQZcZk26GWRPMgoVqTzfY/MWLqzbddTIzLg+U9YP0brq5BBVkrTDUFcMAI5QZZijCN
X-Google-Smtp-Source: ABdhPJxWOb8bUbV/7upSo7J0YgGpVuJVkVBQu/aIAqo+Jjnpra2ju7SqcaXwEMRc/+F5Rzuc37YMqg==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr5441566pjb.139.1643764401017;
        Tue, 01 Feb 2022 17:13:21 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id a125sm15170025pfa.205.2022.02.01.17.13.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Feb 2022 17:13:20 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [net-next v3 09/10] page_pool: Add a stat tracking waived pages
Date:   Tue,  1 Feb 2022 17:12:15 -0800
Message-Id: <1643764336-63864-10-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
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
index 00adab5..41725e3 100644
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

