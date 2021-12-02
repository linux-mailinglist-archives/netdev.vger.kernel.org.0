Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F63465CB6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355200AbhLBD1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355213AbhLBD07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:26:59 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53819C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:23:37 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id g19so26604715pfb.8
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TonOrxXUZEoVrlY5NkhayfSlEg7bcBHInbaBoJJpnUE=;
        b=j7Y0Fni0jJILUbXlFf1l1/+MjZgiWvmdYF3abTWcG1GVx0xk2PRfZRmZayIqPTVyXH
         aG6p072rB/YMPulRf2PHi1tVemEnfdf0n25s3JuubFvPeSFFcoy2k3zuSzYgihmHrHgd
         8eZXmy+6roMQD7w+2bjFyL5CzLTjgT5lKjqcK4eLONdI6ydJj1/H2dq5Mifg13QuUC6r
         y15c4/9jWFWBYR6YuBOiHqDWuSf1Zm06vhOjUS8YnvPe/WmlNUBdiTL8jzrVskjKbz/z
         C8OaFw86K23mKrBmrgFgpcw1n//MC0HxIc0foEFOzC9j79WhcZZ4X3PtjPmLaqG5gNEe
         w8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TonOrxXUZEoVrlY5NkhayfSlEg7bcBHInbaBoJJpnUE=;
        b=wjPjOFDtZhAz5JLsr1jQDy+/3YguJKQCmvx9xdQSE0wwOm3e4dowAqTL+Q/uQ96zB7
         i5HJqpNTGK6DkAhqqBQNgiqQrEPttxer9cAuQou/TlvBkcNjw7vrhASIhVKto1ez58h+
         C7kAiYUQCMViYRm5RToLjkmt1iNXuz2yjX8eLSv59LzYp4YzaK6ix7b/o3Xal/BU2C4/
         jd1Et59shm9FUnIYJHyv17OKtQQrhg1MVNcggNjx2LkH63oLMP3wtpW11vWdixEvVLOC
         S5on1ZVV2OEYL5cN7pGfHlHJ2eyzrKf3iVyRMtZH7Rykya3SY6Je8VFMsiyq8e2Vdp0s
         zUow==
X-Gm-Message-State: AOAM531CNtY3qLHfHYD7gkXR63geF/4gmfNN2CH0T/4f9h6bmVRQhFUk
        amgDJ21l9f5t6DEyea2ZRb8=
X-Google-Smtp-Source: ABdhPJzUdxUaKMzEFn5TSE9+zOGD3wc3zgntVAv/0H913Y81J0J+7BfVqKOjbxsKNUs01malWJzIuA==
X-Received: by 2002:a05:6a00:1396:b0:4a4:ca76:bc0f with SMTP id t22-20020a056a00139600b004a4ca76bc0fmr10282763pfg.5.1638415416925;
        Wed, 01 Dec 2021 19:23:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e768:caa5:c812:6a1c])
        by smtp.gmail.com with ESMTPSA id h5sm1306572pfi.46.2021.12.01.19.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 19:23:36 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 19/19] net/sched: add net device refcount tracker to struct Qdisc
Date:   Wed,  1 Dec 2021 19:21:39 -0800
Message-Id: <20211202032139.3156411-20-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211202032139.3156411-1-eric.dumazet@gmail.com>
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sch_generic.h | 2 +-
 net/sched/sch_generic.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 22179b2fda72a0a1c2fddc07eeda40716a443a46..dbf202bb1a0edad582dbaefe72aac1632e219fbd 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -125,7 +125,7 @@ struct Qdisc {
 	spinlock_t		seqlock;
 
 	struct rcu_head		rcu;
-
+	netdevice_tracker	dev_tracker;
 	/* private data */
 	long privdata[] ____cacheline_aligned;
 };
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d33804d41c5c5a9047c808fd37ba65ae8875fc79..8c8fbf2e385679e46a1b7af47eeac059fb8468cc 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -973,7 +973,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
-	dev_hold(dev);
+	dev_hold_track(dev, &sch->dev_tracker, GFP_KERNEL);
 	refcount_set(&sch->refcnt, 1);
 
 	return sch;
@@ -1073,7 +1073,7 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 		ops->destroy(qdisc);
 
 	module_put(ops->owner);
-	dev_put(qdisc_dev(qdisc));
+	dev_put_track(qdisc_dev(qdisc), &qdisc->dev_tracker);
 
 	trace_qdisc_destroy(qdisc);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

