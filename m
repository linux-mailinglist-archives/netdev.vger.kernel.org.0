Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C31B4AA359
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352147AbiBDWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiBDWmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:42:46 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC39C061354
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:42:45 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id e16so6188031pgn.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BiDjGDalIJZgno57zKrydIx7zYwfZotf0yffC1XSl/o=;
        b=M/wUMmIgrAi4s4hLNLc7NqQ/OJPaUjEjf3KPyr54DOZl9UbT2awZCSVT4ugmVZ4lOT
         P49T2GuJL910RU5mPqf7xwNSwtySD0wynu9LFB7eWCO+HSSi3FrsQLXylNJcRKXO/e2K
         xeWApVjjh/3AcDkOIAq2STVWvl2kSxq+pJ0gMRaa4bNM/+HqlS4FF+o/p22ZQcb5llz7
         foFNuhS/vUmqe9o5/wtqFIeHseK//XsGdISYV9AqQjllfm5SH28DiCWNZNLV4SSawIbJ
         TEXHtRJi53vbEPBYDgh5RY1oe66ozM0p0fRgXcYf8QGWfbzR/DpELMB/iyhrjfBDAbNb
         KWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BiDjGDalIJZgno57zKrydIx7zYwfZotf0yffC1XSl/o=;
        b=yHpuvrC6LvX17y1a1wF4eX9uQMas4/KrHwSe8Rb2M1lPGpUeDwuxiZu9xpq7+SyJUT
         ocPyP56DvgkVFHV3I+0zppFG6QkManQau7Jy+plGiCCpTE202ns3KKudb5P+A3rHKtOq
         X5fUWHPLhKELv6b35R+9Z7tBzNgkus0CEC9UOlkO6tAXGDlhjupnbxt/2u+N54YtMsKb
         0aye63m46Idn6q88hU+tBnMhzS/GFojTJopKPbPZnyFNv2bZZJtgMz4NtId7mhY6DzLo
         ZgdFf/WUTlOZIqJcurwxcHQlyNGat5OTtLzl3Xpb1Pepxkv+wZcbmDzCo5tVp6jVlJ9s
         m7nw==
X-Gm-Message-State: AOAM532Im4N1jFANiN5wRH2LZqWV3PsW/OwgKeBK/4pgIix+UnxRjiuR
        JtAT7ZDOAgV0dabvzFo8Ku4Saj+vnSA=
X-Google-Smtp-Source: ABdhPJyDidm250mnD6JZeXHLsAmJzlWU6mY4jBS1aKwuMNDtbOQ3eNuwth/G8DEDBagbeaa+PUa4xQ==
X-Received: by 2002:a62:7a42:: with SMTP id v63mr5207043pfc.61.1644014564969;
        Fri, 04 Feb 2022 14:42:44 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id s2sm2410060pgl.21.2022.02.04.14.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:42:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 2/3] ref_tracker: add a count of untracked references
Date:   Fri,  4 Feb 2022 14:42:36 -0800
Message-Id: <20220204224237.2932026-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204224237.2932026-1-eric.dumazet@gmail.com>
References: <20220204224237.2932026-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We are still chasing a netdev refcount imbalance, and we suspect
we have one rogue dev_put() that is consuming a reference taken
from a dev_hold_track()

To detect this case, allow ref_tracker_alloc() and ref_tracker_free()
to be called with a NULL @trackerp parameter, and use a dedicated
refcount_t just for them.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ref_tracker.h |  2 ++
 lib/ref_tracker.c           | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index a443abda937d86ff534225bf16b958a9da295a7d..9ca353ab712b5e897d9b3e5cfcd7117b610dd01a 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -13,6 +13,7 @@ struct ref_tracker_dir {
 	spinlock_t		lock;
 	unsigned int		quarantine_avail;
 	refcount_t		untracked;
+	refcount_t		no_tracker;
 	bool			dead;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
@@ -29,6 +30,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	dir->quarantine_avail = quarantine_count;
 	dir->dead = false;
 	refcount_set(&dir->untracked, 1);
+	refcount_set(&dir->no_tracker, 1);
 	stack_depot_init();
 }
 
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 32ff6bd497f8e464eeb51a3628cb24bded0547da..9c0c2e09df666d19aba441f568762afbd1cad4d0 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -38,6 +38,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 	spin_unlock_irqrestore(&dir->lock, flags);
 	WARN_ON_ONCE(leak);
 	WARN_ON_ONCE(refcount_read(&dir->untracked) != 1);
+	WARN_ON_ONCE(refcount_read(&dir->no_tracker) != 1);
 }
 EXPORT_SYMBOL(ref_tracker_dir_exit);
 
@@ -75,6 +76,10 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 
 	WARN_ON_ONCE(dir->dead);
 
+	if (!trackerp) {
+		refcount_inc(&dir->no_tracker);
+		return 0;
+	}
 	if (gfp & __GFP_DIRECT_RECLAIM)
 		gfp_mask |= __GFP_NOFAIL;
 	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
@@ -98,13 +103,18 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 		     struct ref_tracker **trackerp)
 {
 	unsigned long entries[REF_TRACKER_STACK_ENTRIES];
-	struct ref_tracker *tracker = *trackerp;
 	depot_stack_handle_t stack_handle;
+	struct ref_tracker *tracker;
 	unsigned int nr_entries;
 	unsigned long flags;
 
 	WARN_ON_ONCE(dir->dead);
 
+	if (!trackerp) {
+		refcount_dec(&dir->no_tracker);
+		return 0;
+	}
+	tracker = *trackerp;
 	if (!tracker) {
 		refcount_dec(&dir->untracked);
 		return -EEXIST;
-- 
2.35.0.263.gb82422642f-goog

