Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1F44A9F40
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiBDSgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243054AbiBDSgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:36:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F010C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:36:37 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d5so6378033pjk.5
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U8mvndYc5GiIgFu7fMQsqr6+5Dn5yDgnXOI/6CxhF5c=;
        b=lIW5JCQemPN/GJOX43CN0V/vd3xcbZjg9iCYnMmljRO8dIUPpAsFFdu51OpCrl8Tbp
         kXQm0Aoi4I+Un2k+wl+hspNRqtkNCZ/LIuV79waIGwdLfEPPWA4iSUfuf1fK3TVaVIW2
         qjHk02tW6Q8mOuky6sKfAwYhbw3RwKuAtn9pYMJRj4Mf2z7D5SEOAJjACgllhmd7/9Yg
         daxLLs0tIoeo1s3bJHUfSy118810mzsAkulaMVq22mOFOcEvfVfTp2fZxWEzz8X6BoSl
         dGn12v1NDZl0UVFLBPT/m/ipi9foRMCX2KzbADXeck0UMzvxEoEY5dJ7vsi5mdZxHj1O
         YY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U8mvndYc5GiIgFu7fMQsqr6+5Dn5yDgnXOI/6CxhF5c=;
        b=pur+mDDVw6G+Qq1yZCmLCxgaLaqR0oumjX+jjy0B8Lc5s4hG8rqXIG0OqtbDBP2EjC
         WnCUj/AphgKZVkof8ER3j8R3qpR+hkzOm/YFTDM7Ygxwfxrxm+TC+BIzTHHLIXPTuz9K
         bVKaPfXg2uOOgkOr63rYDlNNNMAHjbLDmURnbZE0cDatrgZu6Jwq7I4VIdjgPV+cBzH+
         tfx6wupfrKglYgHIDJtriir3NyqUtjR17z2/Mp5O4+RyWcPeqiWnntQSVJBj7OoTL1Dz
         JtNI4wjEJuGsc7fSYJLY6FQ2axbKX73MpCFgMaOQiJKpdn1wQEvX/W3Gor530u1OmqQT
         SQew==
X-Gm-Message-State: AOAM531COWvhsyUMfh9bQuVw94bSeWIi0P2MUrH/Vz7Lac3AW6FZQL2s
        fMkY+4Ea41we6fbK0vV1MMk=
X-Google-Smtp-Source: ABdhPJzUHFIAoELeSeIGy9wvLaEJQUFpCtrV8cmZ4P8h/BMQtmMb87HnibhjuxwaIOFjiXhdEoswCA==
X-Received: by 2002:a17:902:7c02:: with SMTP id x2mr4238733pll.47.1643999796674;
        Fri, 04 Feb 2022 10:36:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d3:6ec9:bd06:3e67])
        by smtp.gmail.com with ESMTPSA id f15sm3483142pfv.189.2022.02.04.10.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:36:36 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/3] ref_tracker: implement use-after-free detection
Date:   Fri,  4 Feb 2022 10:36:28 -0800
Message-Id: <20220204183630.2376998-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220204183630.2376998-1-eric.dumazet@gmail.com>
References: <20220204183630.2376998-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

