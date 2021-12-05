Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6910A468911
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhLEE0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhLEE0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:26:10 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEDBC061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:22:43 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so8229196pju.3
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+45D+NR04lSsJ9/LKIhtU5WULWdUBQCD1Ai2qKN+DHw=;
        b=b3P8M2TEKHCduglLOFu7wQ0WBCm4ja/hIogVysH31gtpH+23fuyNG9eVsZOSGwILGM
         L+nkdl+X40cI2+pQyXhTRRe1PubADaXBwnP6sUREi23kiHqrxY96uXx4DpHh+17VEYsC
         H81fkYaNvvtiMDSbz8VyqeEzRhKAzwfhNsTNUTnp2bnWmonvQ+RSKDSQnWQ0Qq9kgHYp
         6pcz9c0dAW9fpw5tJ4mKFfs4/+ZZesjMI+/VgtQf8zLpPD0fbTMiSPC/LFp3QmKUxiJz
         /rXeFT0jj53gamOx15+9aPs0jgcR2+/DeMWG0YuYtflGF/ZUlXoYJrk0s8gTAdJem9bM
         +HSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+45D+NR04lSsJ9/LKIhtU5WULWdUBQCD1Ai2qKN+DHw=;
        b=vVgRkBiHVoi0VfxJ2E0wDERoIJaB4aYp2Wk4EpQY1qtfiYC6S8IVIqc/2/VBHksupi
         8066dHoRPPNzVB1fy5ySU8h5CsZ7oqWKRzrI2eFXHwEbTH8pG8J1C3jq2LbTE2Was78J
         OFOY3VS1MU7UnGqmkkAcm0ZPjEyHQajqrFuT6HBS+BSg47h+S77/0yXpJ4OLJkWCR7vJ
         /r230TA6xqF5Z96YROjsoXuveDM0IkaK6qbsDXmeenNYtFTzJySlfseE1q7cyf96VfsN
         9FMKZnndDjtwk0PqlBgn1vmlg3meIDHSsV31aPTn0jvK02mI4zrhsdbMZTYRj9T/Bzhm
         1W4g==
X-Gm-Message-State: AOAM533cW2DlEILfIriZeegZ/p50c7DljhqO2LPUWFm/jRz8DEXdcOkb
        o6Y3HChXe9guRp6LJ+lUn9Y=
X-Google-Smtp-Source: ABdhPJyQBP+TZriux8QJziHGCGVzeoZStcv9ggrw7Cq7woCyHDd3s0o49F2rMcD/xcgv9STfqLm9WA==
X-Received: by 2002:a17:903:24d:b0:143:beb5:b6b1 with SMTP id j13-20020a170903024d00b00143beb5b6b1mr34551166plh.54.1638678163297;
        Sat, 04 Dec 2021 20:22:43 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:22:42 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 05/23] net: add net device refcount tracker to struct netdev_queue
Date:   Sat,  4 Dec 2021 20:21:59 -0800
Message-Id: <20211205042217.982127-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This will help debugging pesky netdev reference leaks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 2 ++
 net/core/net-sysfs.c      | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3d691fadd56907212b8562432bb5fe0ced0fd962..b4f704337f657ebc46e02c9e5e7f5d2c2c64685e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -586,6 +586,8 @@ struct netdev_queue {
  * read-mostly part
  */
 	struct net_device	*dev;
+	netdevice_tracker	dev_tracker;
+
 	struct Qdisc __rcu	*qdisc;
 	struct Qdisc		*qdisc_sleeping;
 #ifdef CONFIG_SYSFS
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 27a7ac2e516f65dbfdb2a2319e6faa27c7dd8f31..3b2cdbbdc858e06fb0a482a9b7fc778e501ba1e0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1607,7 +1607,7 @@ static void netdev_queue_release(struct kobject *kobj)
 	struct netdev_queue *queue = to_netdev_queue(kobj);
 
 	memset(kobj, 0, sizeof(*kobj));
-	dev_put(queue->dev);
+	dev_put_track(queue->dev, &queue->dev_tracker);
 }
 
 static const void *netdev_queue_namespace(struct kobject *kobj)
@@ -1647,7 +1647,7 @@ static int netdev_queue_add_kobject(struct net_device *dev, int index)
 	/* Kobject_put later will trigger netdev_queue_release call
 	 * which decreases dev refcount: Take that reference here
 	 */
-	dev_hold(queue->dev);
+	dev_hold_track(queue->dev, &queue->dev_tracker, GFP_KERNEL);
 
 	kobj->kset = dev->queues_kset;
 	error = kobject_init_and_add(kobj, &netdev_queue_ktype, NULL,
-- 
2.34.1.400.ga245620fadb-goog

