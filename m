Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8854AA358
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbiBDWmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiBDWmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:42:44 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7B0D8778EC
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:42:43 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id p22-20020a17090adf9600b001b8783b2647so1185227pjv.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U8mvndYc5GiIgFu7fMQsqr6+5Dn5yDgnXOI/6CxhF5c=;
        b=WyoWMTplhXG9MB+kMp1xMuP1v6I0fJ2bTJlPS8ak8vuPVgNgyQNAdRWss0Es0vUAFo
         x5qDgQinFvVhIlBnw2CpgHuwi+TSslV2Fx7pR4tQelvpVwq2ix40bTmmNnC6lrNCb8wp
         aYiY5wPRyFXjlf2a/hcoGEllGbi4YjJWKSj8XCTag61VjhIVpDt+2bKyslDMvEhl9tX+
         KhoopHQj7FdfpHJ2A6LTa1f2N2fnYP2BkaUFRG9t/Fai5Ga/KFwKvp7/iwD6blz1Ob4N
         tghMeByWzSlU4fky2N82c5i/avkPSmbwFmKvQaF0l6O/QUJZsFQ5EbuLV42/tX3+O8EW
         OvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U8mvndYc5GiIgFu7fMQsqr6+5Dn5yDgnXOI/6CxhF5c=;
        b=AhKGu/d7wAzQqfk5sslN+nCX8R9zaaOLJnaQNcfEdVd1cK1Q556e7qdAwWyLX7TOM0
         dhv8Nm3GUO/pIbwnqHg4ThOFr0SJWTHifjbKYCYCtFQbwgrz4jfMMkodIDE8HKZ4fWae
         L3FcJ3L0Du1QGQS0rTt6WXXWG2d7aJlPmC458VtbTatmfEpWq1Gchu9lvWQBhQlVDxYR
         H5uEKHbhTyKxeGMjeqVNhFi4aIfe+M97fjry5lEyDgWKkG3ihtGFPgxLk+aOnLm8tk04
         TxEpQkEc2+rO1fwr06/7AzzaODdnBdZ8zwCVZfOt8Ym00fhL56ZTWbH4t7KwkxXxobCy
         WI1g==
X-Gm-Message-State: AOAM532Bde5K0eQW0rtcaQjkBKUdZ7LG0puFUNl/mXYC1kEDoVHdKZ6N
        cZo1zNRuVv3M1WZvplrF500=
X-Google-Smtp-Source: ABdhPJwPGPLy4Qo+w0FPcO6QPfuchVgjaL8UZfV+tSRcKKEDEeFcMQ64Heh/ZOHhL035GANW340qqA==
X-Received: by 2002:a17:90a:94cc:: with SMTP id j12mr5558467pjw.39.1644014563120;
        Fri, 04 Feb 2022 14:42:43 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id s2sm2410060pgl.21.2022.02.04.14.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:42:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 1/3] ref_tracker: implement use-after-free detection
Date:   Fri,  4 Feb 2022 14:42:35 -0800
Message-Id: <20220204224237.2932026-2-eric.dumazet@gmail.com>
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

Whenever ref_tracker_dir_init() is called, mark the struct ref_tracker_dir
as dead.

Test the dead status from ref_tracker_alloc() and ref_tracker_free()

This should detect buggy dev_put()/dev_hold() happening too late
in netdevice dismantle process.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ref_tracker.h | 2 ++
 lib/ref_tracker.c           | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index 60f3453be23e6881725d383c55f93143fda1e7a2..a443abda937d86ff534225bf16b958a9da295a7d 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -13,6 +13,7 @@ struct ref_tracker_dir {
 	spinlock_t		lock;
 	unsigned int		quarantine_avail;
 	refcount_t		untracked;
+	bool			dead;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
 #endif
@@ -26,6 +27,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	INIT_LIST_HEAD(&dir->quarantine);
 	spin_lock_init(&dir->lock);
 	dir->quarantine_avail = quarantine_count;
+	dir->dead = false;
 	refcount_set(&dir->untracked, 1);
 	stack_depot_init();
 }
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index a6789c0c626b0f68ad67c264cd19177a63fb82d2..32ff6bd497f8e464eeb51a3628cb24bded0547da 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -20,6 +20,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 	unsigned long flags;
 	bool leak = false;
 
+	dir->dead = true;
 	spin_lock_irqsave(&dir->lock, flags);
 	list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
 		list_del(&tracker->head);
@@ -72,6 +73,8 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 	gfp_t gfp_mask = gfp;
 	unsigned long flags;
 
+	WARN_ON_ONCE(dir->dead);
+
 	if (gfp & __GFP_DIRECT_RECLAIM)
 		gfp_mask |= __GFP_NOFAIL;
 	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
@@ -100,6 +103,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 	unsigned int nr_entries;
 	unsigned long flags;
 
+	WARN_ON_ONCE(dir->dead);
+
 	if (!tracker) {
 		refcount_dec(&dir->untracked);
 		return -EEXIST;
-- 
2.35.0.263.gb82422642f-goog

