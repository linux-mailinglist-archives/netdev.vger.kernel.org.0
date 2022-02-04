Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971274A9F42
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377584AbiBDSgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377627AbiBDSgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:36:40 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10200C061401
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:36:40 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y17so5864527plg.7
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BiDjGDalIJZgno57zKrydIx7zYwfZotf0yffC1XSl/o=;
        b=DviQ3myROXk73iicb5/Hhhudaifzd2FOi0zrjDpnw8s8Xc8xbatcTltrmZNd9sd/zL
         c9Aca9Pz965q2CsKPGtZ9fh2t/XfBMnYP0WGQWtvlo0kk3VCpSovnoI+wYrvuP5LvegH
         K9vR3XBLrBWAzvaP03u4C6jaqZZvTRsFKft1kOImHr2IQ3bSV91ympYfBbA1AKhnVdsz
         Iwx9ckTCytASoq6S+JrHufhvJZK+FWkwKwumJdIkr8VuS+p5UiXLPDIMjJxJdEaea4yy
         ELy5R7QG4qhdFO66rSbtVFrX+pHMKBMJtaWrBy6/ayDEl7wJhdFh0eaYbdtUyrp49JFD
         SC+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BiDjGDalIJZgno57zKrydIx7zYwfZotf0yffC1XSl/o=;
        b=yFJ29U8MwNB3GhDx59TKuQ3dd673wyg06fkPzAnhUoS77whCYQcNAv5CVosVfp2PS4
         uw9+lN+vNcIf7qx4sakXrisKfw8Na2Eq98iXh07c9RIhF3W5UZHi871vobz9gtgL9tXa
         1xIkC+FXdcYQux7HaaOB+DgLqab6SF+e5RXoZZZYJjBk9m5lFDHEgubnntrawjzTpiOM
         PinSpfgJF0lmVnf0yUXWSSTAnVT41QDy831ZXtKObha9cKtPB2Y2Tmv+mYlsCV6ICoIn
         CbMyWeNJnGg6jhHc5vJREezd2o+zyyKIDMrDEs0E6HJ2ihpv3mpCBGhTcBUb8exxR84A
         W6Zw==
X-Gm-Message-State: AOAM533AtvZrI3g/6csgJNsP+JW9EmkaBxNrPORzfUDt3PeZ3RIlSwzU
        JiESIMAZL3aM01GGkViEphw=
X-Google-Smtp-Source: ABdhPJz58kY7zY/TmKQgTz/Tmi62Y+WgAzeUekgnq9gcOR+A8Wm0T+60OL6mn9bQfM0lDecwSDQOAQ==
X-Received: by 2002:a17:90b:3144:: with SMTP id ip4mr4651034pjb.23.1643999799630;
        Fri, 04 Feb 2022 10:36:39 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id f15sm3483142pfv.189.2022.02.04.10.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:36:39 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/3] ref_tracker: add a count of untracked references
Date:   Fri,  4 Feb 2022 10:36:29 -0800
Message-Id: <20220204183630.2376998-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204183630.2376998-1-eric.dumazet@gmail.com>
References: <20220204183630.2376998-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

