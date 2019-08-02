Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF37EF69
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404290AbfHBIfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:35:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44042 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfHBIfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:35:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so35712698pgl.11;
        Fri, 02 Aug 2019 01:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4v0SFKFIyHNGxiP45uXkSofHjrZsAC9JDmEkGPGixBs=;
        b=IkK+vXPsrqt/iHc2+lbvYH0BrN5OvdBCeDxrd51b/yxwzx4oXMq9Zd8fnMvp7nJocQ
         QBK+aDGaGER3rDmlrVBPS9zgmGyMkF/sCNTwf6GO8zUKmNoKIHTrf/pnJaZjkcZ1HTEN
         dOG6IGK8SX7eUi4rElZZco4KfgirV1wQ+QwJxm7ZNS8BWZQQFn/cg0KKrbAEpebmdBOk
         g3w6+MBjSvt8WdFUv62YtZjgjt45IYgtJiFNH+xDJyq6jwfCguUDHQZkVGh3JYJcDcZC
         zt0mjKj/ouzJtvbSVqh+e53n0UDolwA2XBLDfrs0eXFm1tZL9V4K+fv42RU7opn492ol
         y8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4v0SFKFIyHNGxiP45uXkSofHjrZsAC9JDmEkGPGixBs=;
        b=iyldemuYZyBM9mRWPZnyYcr1Jk17tQARCvLD3rDAJ9pcIOJ0X1ElN/acQ63kpNal56
         UqQQoJ1JHCv0GtZDkV/GyfozCrKAlEIyJraK0oSAd0XoHJUhCvTRsmT5oT1LHdjBijxQ
         R28nqCP/QQ/9/syZB0eLPrqSd5xe9errf3IS/QxzhRXhD/1pWNd9FaHVQYXjNutJNw2R
         sORazPmPWwtKSU87FWWmcpsn+02abYXT7lTomR7eLEJ5RCG7++15uqSI5VGNN5bzHZSG
         EqSGVZ/P5JA/23J0HkAckMrXvGqwT4jOB2Oiut2O4/x7hmlTI7XRX1iJn1CWDU13Vcyi
         UhYw==
X-Gm-Message-State: APjAAAVGcjMVP7GdZ84v/1jXA7Z2iXPsDXo3HgbuUnaPI1bkgo4oC25A
        H1s1y8EYDFylrHDLOx/BJ4GwDmk/V697bQ==
X-Google-Smtp-Source: APXvYqzkCBz788klMubzO3NpoJemAOZ0SwXI8KmyMXDQ8wSLB8BuOKuBxYbG8F9aq1fb22kK3I1iXw==
X-Received: by 2002:a17:90a:b908:: with SMTP id p8mr3256342pjr.94.1564734946718;
        Fri, 02 Aug 2019 01:35:46 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id r12sm53251778pgb.73.2019.08.02.01.35.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:35:45 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 1/2] cxgb4: sched: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 16:35:41 +0800
Message-Id: <20190802083541.12602-1-hslester96@gmail.com>
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
 1 file changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.20.1

