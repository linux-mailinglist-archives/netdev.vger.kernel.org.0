Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CBD46891F
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 05:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhLEE1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 23:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbhLEE1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 23:27:40 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BB9C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 20:24:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id r130so6934302pfc.1
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 20:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fT2Qu6/ffgiG1NGeWHN8tdR6mwWo+LW/WTBHIOFKRSI=;
        b=QyB4sUkP4VkscYlk9jII3j+uHCE/NLb+0yWygCZzRZV/KpE97NjK4YOGaI94+aa5aB
         6mvvNQif7/TV8pBjobrMAm85Khp6c4w/0OwTT9z8GI4QLv2GN4WiJ6/nJC4qcUNHW2kV
         XEPlRJgiBxMWOyxNOEjtVJQe9vRH18qxtKyByl0ah6YSrmi5K1Q/qUritzj+Z5sLH6ux
         eG3p8fWNcfDSmholXz7T2/96RSpRmkSkybxBPW9Anhb6e4zXLdpBXHw0GT/LpBNvKgnB
         gEpoCV9A55qW+EDnlB0ULQ6RpMsSOhmQYmxam3IRPOvL62NEC7CS6DLKXuF9EIS2JRzw
         okFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fT2Qu6/ffgiG1NGeWHN8tdR6mwWo+LW/WTBHIOFKRSI=;
        b=lil9cu7ixoCd6hX6dJcXqc2aIr7Lb9tnVTBPw0cxguBcJ64RDoXpLWBRjZ1zw9me69
         NMt/EyLVIERhUNDz3Y/ULjSb7s7VBNKv4TZaWUj4WxCvrnsQnY7WTLi8AkQ57GRaN7ve
         gmrSsXcDthPxFUbwVddwaynJYQPJkCowfUCoOU3FguNixmTnNUaRVnsFVMPu+MAEitOD
         TENIhiIQXaNOVyRStdoz060CBPswZgfcs2rYSVAXHSE/1RXxEnE0sR5x4CD//3+iUmuc
         qJvatRyWatxIQALD/FrnWpFqMjS1CYPmmZbexwl4We2RfSaFTyYvxIwmdM0J6lOqDGnO
         6Xlw==
X-Gm-Message-State: AOAM530GZnccEDyUuIGkqaIwag2Y4GImJ9iKrTLMHgrGTNIIp0Ysg547
        ocCPHjn22qTbJCrpL+WeVlfTg3BdA5I=
X-Google-Smtp-Source: ABdhPJw4LbaQU+SXlqgr5ALr+0BOz4pclCBQoUjWRphPdYEqvLZ21xSz0ysJz06o/f+axegnbX65uQ==
X-Received: by 2002:a62:b418:0:b0:4a0:3696:dec0 with SMTP id h24-20020a62b418000000b004a03696dec0mr28382591pfn.73.1638678253719;
        Sat, 04 Dec 2021 20:24:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ffa7:1c62:2d55:eac2])
        by smtp.gmail.com with ESMTPSA id 17sm6027095pgw.1.2021.12.04.20.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 20:24:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net-next 19/23] net/sched: add net device refcount tracker to struct Qdisc
Date:   Sat,  4 Dec 2021 20:22:13 -0800
Message-Id: <20211205042217.982127-20-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
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
2.34.1.400.ga245620fadb-goog

