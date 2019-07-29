Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885D1786E7
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfG2IAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:00:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40587 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfG2IAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:00:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so27589366pfp.7;
        Mon, 29 Jul 2019 01:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sHreTI6pjMjpSS3l9XfOzmIgje94ZwckoRy4s15t6gc=;
        b=IL7E+lWAmJRAOYrpHdkkAku6XU17qS8ac815x+cn7Pi3NZuvBbyEhBRTllzGkFaM17
         zgxZa4xgDCgCXCa6pLRvwTb0XRHIRfURmP+Y1rRCTZ/NPMhMv8pi+WsXkpa7Kw66ZJR1
         Y/2JWEAU8qGlBeGPXBckBROIe2lUCe+UG7ZFQ8QbH7Y61hT/9UlZ6ae17ng01nVm47BM
         MkV2J1ca/Ge5hds5Cu2O/SBFsinTCog4MCj3Yt4JldhUMLqQp8kjMinwr3dBI/Xrx4xJ
         cwfO45AWPHZV1Tx2fc7LU81EheGEYzZUYdfxOkR13frk1ik+oC1f8H+ReSEKMLPYLM7M
         qQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sHreTI6pjMjpSS3l9XfOzmIgje94ZwckoRy4s15t6gc=;
        b=Fnl8jqYuLXIeijFrO+NkdyM/ri7Gzroa5ziAWCGzYa2cWUqfbNcfShYZxR6S6MZ0WM
         5JJuC3A2+eJab3GWrg8a4Q6TCC3P1FQUmRsGcLJ5L5+yBTUBdY7/jwYh941T+BlNy0Sb
         sAi3nUTchN+s7aUGXd10/Xfbt1+N0YfTs4aqh6WQ/sxKt7onx3C7nNBNuMQIBQyhODHh
         DInUUrLWy6pcpNu6fofXkQDPxVw8jdk/e8+3YfSPqchh64ZYz5z+gGV7WmT9b0bIjcuT
         hCWNdzltgRzQD/kt8jKXf71cXuEUr4M9RYPOTXj0M7Y+6H4+Ap7u3t8yX97xmLP1ecRG
         GGlA==
X-Gm-Message-State: APjAAAWKbSo8n3VYQKuYZBuEhzaLYOkVBJNCg0j5xJ1gH+dopU7Hnnm9
        E6REclFn6pr9tW1tMWNnWpVZVDyV4U8=
X-Google-Smtp-Source: APXvYqwtYEnuKAS9Muhpr3xUIRtlZkMmMYnvmpbRAL8N7K0KvFCMNFzu4hQ3MN5AF1/t9Rg/PbAbdg==
X-Received: by 2002:a17:90a:c70c:: with SMTP id o12mr85447831pjt.62.1564387229826;
        Mon, 29 Jul 2019 01:00:29 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id p15sm58050661pjf.27.2019.07.29.01.00.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 01:00:29 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] net: sched: Fix a possible null-pointer dereference in dequeue_func()
Date:   Mon, 29 Jul 2019 16:00:18 +0800
Message-Id: <20190729080018.28678-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dequeue_func(), there is an if statement on line 74 to check whether
skb is NULL:
    if (skb)

When skb is NULL, it is used on line 77:
    prefetch(&skb->end);

Thus, a possible null-pointer dereference may occur.

To fix this bug, skb->end is used when skb is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Fixes: 79bdc4c862af ("codel: generalize the implementation")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Add a fix tag.
  Thank Jiri Pirko for helpful advice.

---
 net/sched/sch_codel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 25ef172c23df..30169b3adbbb 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -71,10 +71,10 @@ static struct sk_buff *dequeue_func(struct codel_vars *vars, void *ctx)
 	struct Qdisc *sch = ctx;
 	struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
 
-	if (skb)
+	if (skb) {
 		sch->qstats.backlog -= qdisc_pkt_len(skb);
-
-	prefetch(&skb->end); /* we'll need skb_shinfo() */
+		prefetch(&skb->end); /* we'll need skb_shinfo() */
+	}
 	return skb;
 }
 
-- 
2.17.0

