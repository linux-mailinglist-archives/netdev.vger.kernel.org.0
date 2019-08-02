Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D67B7EF81
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404363AbfHBIlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:41:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41672 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbfHBIlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:41:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id m9so33252471pls.8;
        Fri, 02 Aug 2019 01:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZAc60zmmWfJUPJOxztGC1Zo0QcSwvZnWidwh1YadQW4=;
        b=BeiakVZ/69l0C40HpLypKpjGyqlbjMzm3PySNszVR6EOhpT+j+PH0BIMvvQ0zkGlHX
         XQUQVOiygfbQ8ydDOxejN7p02EyZXsb3q0gOkdztKAR7Dk/HUtjFg3/RtrnSWI2yVIAb
         vJEJ43TRr17U0CfYB5o5ZfJQr53fqKZc4AOCYc8kFRIfsueek7PpKPr98juBm7CLFL0y
         gfR9xAHxL7qkohnOof48JG6GrmP1SbEPVBZ2NiMRzYpaFk1+SJj3ZPsQSdCUEhRpXar6
         /m0ZGUsruQNrXq9oPdRJibQZokvrdGLYI+oOUiPIWZ925shzg/8WT3lGM6DDAtCcv9Ln
         nA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZAc60zmmWfJUPJOxztGC1Zo0QcSwvZnWidwh1YadQW4=;
        b=CVS9OYHyDh0EvyISAYxDoG6Yo2uisP/oPBzKrLETkeiCBGhjOQ7OtZvlNH4URxaOSA
         L7czBIO8EnrnlHPvnisxnLXeG6lw+8Mt8BXsHCI3cvalIiCprjtZUXhogwG4nFAODQN4
         DvV07HtArvF+iA6iX+pEJQr3P7icrEK6F09xAqv4LmlTMYWbMRC4AALavvPLAjqMOv43
         ZWyIuUZUR0P0nZjnOn2aZgbXcEUaCKN+X1uVsIY883mvSk7rvm76C+XcItKlq6iaPx94
         2C0Sf7lxTuiQBWQ9HjwCDx2YIva8i4ALVBgAGdnjYu8eGAtJzkMNzwVrYrK81BamFT5L
         HyPQ==
X-Gm-Message-State: APjAAAVXoBjF2Z9GZ5gF8HIyuAwa8/bKGpWvyOpE3iBlc/CkscNLJsDI
        0nncFt8/60VhzGmfh2iL+6A=
X-Google-Smtp-Source: APXvYqzNE1bewwsx9D1UZc8lGoqthGwl6qcode52EkBnUpn1dSdl6cReLdopztd1bcNFRzL18bEziA==
X-Received: by 2002:a17:902:7687:: with SMTP id m7mr76984090pll.310.1564735273710;
        Fri, 02 Aug 2019 01:41:13 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id q7sm81671983pff.2.2019.08.02.01.41.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:41:13 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 1/2] cxgb4: sched: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 16:41:08 +0800
Message-Id: <20190802084108.13005-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Convert refcount from 0-base to 1-base.

 drivers/net/ethernet/chelsio/cxgb4/sched.c | 8 ++++----
 drivers/net/ethernet/chelsio/cxgb4/sched.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index 60218dc676a8..0d902d125be4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -173,7 +173,7 @@ static int t4_sched_queue_unbind(struct port_info *pi, struct ch_sched_queue *p)
 
 		list_del(&qe->list);
 		kvfree(qe);
-		if (atomic_dec_and_test(&e->refcnt)) {
+		if (refcount_dec_and_test(&e->refcnt)) {
 			e->state = SCHED_STATE_UNUSED;
 			memset(&e->info, 0, sizeof(e->info));
 		}
@@ -216,7 +216,7 @@ static int t4_sched_queue_bind(struct port_info *pi, struct ch_sched_queue *p)
 		goto out_err;
 
 	list_add_tail(&qe->list, &e->queue_list);
-	atomic_inc(&e->refcnt);
+	refcount_inc(&e->refcnt);
 	return err;
 
 out_err:
@@ -434,7 +434,7 @@ static struct sched_class *t4_sched_class_alloc(struct port_info *pi,
 		if (err)
 			return NULL;
 		memcpy(&e->info, &np, sizeof(e->info));
-		atomic_set(&e->refcnt, 0);
+		refcount_set(&e->refcnt, 1);
 		e->state = SCHED_STATE_ACTIVE;
 	}
 
@@ -488,7 +488,7 @@ struct sched_table *t4_init_sched(unsigned int sched_size)
 		s->tab[i].idx = i;
 		s->tab[i].state = SCHED_STATE_UNUSED;
 		INIT_LIST_HEAD(&s->tab[i].queue_list);
-		atomic_set(&s->tab[i].refcnt, 0);
+		refcount_set(&s->tab[i].refcnt, 1);
 	}
 	return s;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.h b/drivers/net/ethernet/chelsio/cxgb4/sched.h
index 168fb4ce3759..23a6ca1e6d3e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.h
@@ -69,7 +69,7 @@ struct sched_class {
 	u8 idx;
 	struct ch_sched_params info;
 	struct list_head queue_list;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 struct sched_table {      /* per port scheduling table */
-- 
2.20.1

