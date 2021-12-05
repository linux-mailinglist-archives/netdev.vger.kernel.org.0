Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E54468910
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhLEE0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhLEE0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:06 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2CDC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:40 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r5so7101836pgi.6
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GGeU+jp0LY5iv+WjCQyx9JP4s1aigp4ZNnokq1KrHEM=;
        b=iavKHjb8f3kMy315ZdZV0yngJORdxvvLumy57NmWuUzwpLyBSnQXiFhLb6JPIVdp9N
         8qFk7s7uuyxNLGttgVgNTeiwj4UNwXXZJMnPLcP1VcuW+MGXES4w1C4YMa26DaPWMeVk
         F+vGyqC0GmFd7HNksDC75cnFdSd6/izZ6+5yyqwgppDqQUZdgacxd3QUNgih5RxGgF21
         O6j+i1K2nu38dFUUimbnRGlV5BwKjmNbKryLkYAPeFAb9lH9DmuCZxtywf8nx6S9SQwt
         FUHZsG9Tgg1o1MPMOAdVKXDkdCSYf/0V2VbtGQ9UnFyE0FC9T7ocHESO2nkFFIQcocbr
         nbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGeU+jp0LY5iv+WjCQyx9JP4s1aigp4ZNnokq1KrHEM=;
        b=JsRIv/31kBkh5yZSoE/J7sHxp9LUPlvMyFo0c4y4HwcTq3Mpiw+kSooKTE8TMiKt6Z
         /aDcGY0RyzlJr48X2b2ECdx6zmYCL/Jy+OerE8ghGFTqQtH7P5BrDKc5PGo5BIMgCODV
         fxaJRH1tgLQ4rd/R5C77mll5TMTQ+QGqAjGBeRH0YwIryAsUbqC07kN6JVM8kRRGWX8c
         b7Tnqb6UMbvGyJyvQS9+HlamiW4OJ4SZAD8Xp9aAa40JKZgThH+fJP6OwZ2JuXkTRRLc
         k6iHgCB5/Jt/otw1vp1+p+2xWW9mvGiaCj0tsLYZzMjM3ndWvR5mPgXO0braS94/iS++
         Scgg==
X-Gm-Message-State: AOAM532aKFP4JxA1fSe3r4ZUhhhNnkY+XIN8wl4c2lre8NqyZSRm/pqK
        aszX+x2yA8PP73AAdudncnU=
X-Google-Smtp-Source: ABdhPJzcmUcGPw/wQRWdOluEnSfyHjR2jmHtzxHZAcPTGaAwcM8uqSjMw9/VLOrFxVZzRwSOL1HOhA==
X-Received: by 2002:a63:8041:: with SMTP id j62mr12150822pgd.517.1638678159846;
        Sat, 04 Dec 2021 20:22:39 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:39 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 04/23] net: add net device refcount tracker to struct netdev_rx_queue
Date:   Sat,  4 Dec 2021 20:21:58 -0800
Message-Id: <20211205042217.982127-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helps debugging net device refcount leaks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/net-sysfs.c      | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 143d60ed004732e4a086e66fdcf7b3d362c1dc20..3d691fadd56907212b8562432bb5fe0ced0fd962 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -741,6 +741,8 @@ struct netdev_rx_queue {
 #endif
 	struct kobject			kobj;
 	struct net_device		*dev;
+	netdevice_tracker		dev_tracker;
+
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
 #endif
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index affe34d71d313498d8fae4a319696250aa3aef0a..27a7ac2e516f65dbfdb2a2319e6faa27c7dd8f31 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1004,7 +1004,7 @@ static void rx_queue_release(struct kobject *kobj)
 #endif
 
 	memset(kobj, 0, sizeof(*kobj));
-	dev_put(queue->dev);
+	dev_put_track(queue->dev, &queue->dev_tracker);
 }
 
 static const void *rx_queue_namespace(struct kobject *kobj)
@@ -1044,7 +1044,7 @@ static int rx_queue_add_kobject(struct net_device *dev, int index)
 	/* Kobject_put later will trigger rx_queue_release call which
 	 * decreases dev refcount: Take that reference here
 	 */
-	dev_hold(queue->dev);
+	dev_hold_track(queue->dev, &queue->dev_tracker, GFP_KERNEL);
 
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &rx_queue_ktype, NULL,
-- 
2.34.1.400.ga245620fadb-goog

