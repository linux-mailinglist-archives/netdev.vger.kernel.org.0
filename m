Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDADD46AFCC
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhLGBfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245069AbhLGBe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:34:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F51C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 17:30:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1318572pjb.1
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CJJQGs2HcBmcq9pz1NYDogopjqgRXVFMWnUGx4H0oSU=;
        b=TiSvF5IYkqgRr0v6T/vs0BTBFvPSUen4ydKwL9/WFGW0a+Y7ssJvEE8rBr31MbBZSb
         ipmT4546xzCV0gW1QY8vkhVnGSXfC9kavC5Slr8auZqzNGIDRmGF2jBElcDisz4XzOfw
         uaXsoOS+lmttASGKhX1wIiuz1fB8Yysgk+Pf57qmQNxERdxqas1y3ibuH6xDzF0uvtew
         A7OeAE1Y2u//IfPoc7LawDUKSAAWH+82xJ2sVXmhQaXftzl8dLiStbu0d+ACpCZTMbOH
         0rwO9+pLWm0y042GPOpy/bBSYnk5n6HvrFVmjvqy6D814+gDYUEwjcrg7nEgR7HRtuc9
         YoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CJJQGs2HcBmcq9pz1NYDogopjqgRXVFMWnUGx4H0oSU=;
        b=Mn8kEFajO9JZQLJkdulVwMbrOZZ+ZVcW+MS7vcoVYrDpDwrRp9+AYkbm4tzb24e5M+
         IrxE6yUdGZW+L4FZydmH2Bw8uRFCYJT/18Wl4E7eQuobtd81M1nMEoCxx0ZdqfKUtMLO
         S2u0i/nb2Kdm06+Ap60bnIfmyKLk0JKGYLTfTFU9S+/D5D30ahxZ3r2BxY2sdcWgIXit
         A+Eab5icvRaj32BHxu5JNls5kvWuL3gTbhDQSUHUq2gtsV2QGbe87eGPS/8LrzgoanRi
         j7IWTZRxUUDg4h1Sv2lNnVTmHcGHRhtDqpmscg3i69TmPrB/hDMyJBp++NjhApSefY7s
         g/Eg==
X-Gm-Message-State: AOAM530YvUESc2IY/uFdojXHsryGsMLFtC50W+rOuyOyNpSHGKc54fF7
        FAe31Xm9GheyCnwYlqhXZEg=
X-Google-Smtp-Source: ABdhPJx0yonqv/flNCwxoV7QAw8P2xm1VXmKV0DWTT5PBqaMVmU56qEN+lqhulWCgV705k9FOXA27A==
X-Received: by 2002:a17:903:1c3:b0:142:3ae:5c09 with SMTP id e3-20020a17090301c300b0014203ae5c09mr46920179plh.52.1638840657558;
        Mon, 06 Dec 2021 17:30:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id u6sm13342907pfg.157.2021.12.06.17.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 17:30:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 01/13] net: eql: add net device refcount tracker
Date:   Mon,  6 Dec 2021 17:30:27 -0800
Message-Id: <20211207013039.1868645-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207013039.1868645-1-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/eql.c      | 4 ++--
 include/linux/if_eql.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 8ef34901c2d8eef46ade52600c31359042463297..1111d1f33865edc7f98e7057118c9e4b8c8d327b 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -225,7 +225,7 @@ static void eql_kill_one_slave(slave_queue_t *queue, slave_t *slave)
 	list_del(&slave->list);
 	queue->num_slaves--;
 	slave->dev->flags &= ~IFF_SLAVE;
-	dev_put(slave->dev);
+	dev_put_track(slave->dev, &slave->dev_tracker);
 	kfree(slave);
 }
 
@@ -399,7 +399,7 @@ static int __eql_insert_slave(slave_queue_t *queue, slave_t *slave)
 		if (duplicate_slave)
 			eql_kill_one_slave(queue, duplicate_slave);
 
-		dev_hold(slave->dev);
+		dev_hold_track(slave->dev, &slave->dev_tracker, GFP_ATOMIC);
 		list_add(&slave->list, &queue->all_slaves);
 		queue->num_slaves++;
 		slave->dev->flags |= IFF_SLAVE;
diff --git a/include/linux/if_eql.h b/include/linux/if_eql.h
index d984694c384d7dde37b7b1f9ac0a90e6ef7bb87f..d75601d613cc6859b692ab3a41b55893e5921dd9 100644
--- a/include/linux/if_eql.h
+++ b/include/linux/if_eql.h
@@ -26,6 +26,7 @@
 typedef struct slave {
 	struct list_head	list;
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
 	long			priority;
 	long			priority_bps;
 	long			priority_Bps;
-- 
2.34.1.400.ga245620fadb-goog

