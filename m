Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D676D72C74
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGXKj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:39:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41142 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGXKj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 06:39:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so20754890pff.8;
        Wed, 24 Jul 2019 03:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wO4O/Gvif+MADZGPdW4dqB529LtcQYyXiVt50YTB8sQ=;
        b=L4Cn/0ZMJQOyjLGxVaYXm152UsTOpbzYiYWqFq9i917amlQjuDqAGIDml7mnGbbS18
         hr2goSQqpjPH+wib0GQ1sPE4/MmxAPeSOzHpdZYyxwWeORTnnZtFuHpqArXYlnhHuB0/
         AU3Nr3KjBpWkKtCMlJBtl6PXylB84eX4sKomMC0Q9hXUa2/UWO3gGU5WPtpwKvnC2V5t
         pVXYu7f3G3tabd0agHqv02mcBr2ywbWKxqDIlnQQDricK/1cnQIMKCRjmpxJHxkmrDtV
         m3/5YUtHLMA8fuCdjIphE7TmX/xOXeZMiE/ukZmvmKj6fmdN3Byo7VO/vWb+k2JHHmgw
         gEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wO4O/Gvif+MADZGPdW4dqB529LtcQYyXiVt50YTB8sQ=;
        b=SX3KLZ46c8nU9x49ebt3HiSclf584+41RXH47ewLzhefhK5yrJh1tVmb6PvoBQPV5l
         WlYj7ll5F8sgR4u837uyw+gs+QLRisH1Qqz6Qwc/Aa6eOJNatPZzKQFfXNmCqeQBBBVm
         WJgowtvtaLwQcP8rQKMSegBVYUivRVfDQCj5QeyFVs8G1UoE9wWu+6A4WaCQd6/IX3Pt
         YAw/6FU2u2N4wv+0k1BG3iT/KHiDmz+1wrGrGBQtucbUIeBM2SsrKO/ofw4jqFPh7V5y
         pzfzLReR1ahGHGXwt4+plpqmsnRzbEsp85yboxSJ9du7rrFOHgCq6AZDFsw8I6f1bDz7
         ZPGg==
X-Gm-Message-State: APjAAAVj0i+VdsviT++HgBJZAKbewrv1S6JXiSuj+StELYe4vfeTifzy
        jJ7DPMivAH6vJJKs4/R6Zr3TqYxdqcA=
X-Google-Smtp-Source: APXvYqyB5tVuEHxgF/eAqyCET+wGzXScctFnZx1o/V16PJa1fLsTcB4Ztr+LWCuALB5012je06dYuA==
X-Received: by 2002:a62:1515:: with SMTP id 21mr10953193pfv.100.1563964795549;
        Wed, 24 Jul 2019 03:39:55 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id i7sm36393739pjk.24.2019.07.24.03.39.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:39:55 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: 9p: Fix possible null-pointer dereferences in p9_cm_event_handler()
Date:   Wed, 24 Jul 2019 18:39:48 +0800
Message-Id: <20190724103948.5834-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In p9_cm_event_handler(), there is an if statement on 260 to check
whether rdma is NULL, which indicates that rdma can be NULL.
If so, using rdma->xxx may cause a possible null-pointer dereference.

To fix these bugs, rdma is checked before being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/9p/trans_rdma.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index bac8dad5dd69..eba3c5fc2731 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -242,18 +242,24 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	struct p9_trans_rdma *rdma = c->trans;
 	switch (event->event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
-		BUG_ON(rdma->state != P9_RDMA_INIT);
-		rdma->state = P9_RDMA_ADDR_RESOLVED;
+		if (rdma) {
+			BUG_ON(rdma->state != P9_RDMA_INIT);
+			rdma->state = P9_RDMA_ADDR_RESOLVED;
+		}
 		break;
 
 	case RDMA_CM_EVENT_ROUTE_RESOLVED:
-		BUG_ON(rdma->state != P9_RDMA_ADDR_RESOLVED);
-		rdma->state = P9_RDMA_ROUTE_RESOLVED;
+		if (rdma) {
+			BUG_ON(rdma->state != P9_RDMA_ADDR_RESOLVED);
+			rdma->state = P9_RDMA_ROUTE_RESOLVED;
+		}
 		break;
 
 	case RDMA_CM_EVENT_ESTABLISHED:
-		BUG_ON(rdma->state != P9_RDMA_ROUTE_RESOLVED);
-		rdma->state = P9_RDMA_CONNECTED;
+		if (rdma) {
+			BUG_ON(rdma->state != P9_RDMA_ROUTE_RESOLVED);
+			rdma->state = P9_RDMA_CONNECTED;
+		}
 		break;
 
 	case RDMA_CM_EVENT_DISCONNECTED:
@@ -277,12 +283,14 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	case RDMA_CM_EVENT_ADDR_ERROR:
 	case RDMA_CM_EVENT_UNREACHABLE:
 		c->status = Disconnected;
-		rdma_disconnect(rdma->cm_id);
+		if (rdma)
+			rdma_disconnect(rdma->cm_id);
 		break;
 	default:
 		BUG();
 	}
-	complete(&rdma->cm_done);
+	if (rdma)
+		complete(&rdma->cm_done);
 	return 0;
 }
 
-- 
2.17.0

