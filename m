Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151967C421
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbfGaNzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:55:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35809 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfGaNzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:55:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so31938381pfn.2;
        Wed, 31 Jul 2019 06:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AUehYmAmHAFKhA+UzW4C2Ny1DOn2u7scNPtafjv+ab8=;
        b=NdK5mbveYV0uJ0PdbLG7vKVErAQFSXqF/0JnQIkBqPeipAS/JkeXYG9CuFvlN6HnaL
         bXjjeSelPvaJn4fztI1kJ3oS3D8XXYM3TckWfdWAFGY6zMVDxOjABXddMthXWLtHdKLo
         ObFkyssGmRMkkquXN3+fUt9C0L8qfsGj55hpSSmSHD0bEnwfiRu+CbWBurS/aQ5afOXa
         bY9srq/AafGT18BmsdCXFfgycTswNfGl7MYWLWwqPeknVb0l08oJZnyST/cUYCMJFy+p
         jIDQNNNfBWq8x+tkY2V/pa8qYVHDP/1bf/lgS95j+6BYdq70NL3pFSQVrSKIdjJaMYbJ
         nraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AUehYmAmHAFKhA+UzW4C2Ny1DOn2u7scNPtafjv+ab8=;
        b=M1OTx5SljeTV9LBy6LrOIKifAVGqsDSGZoCPA+HR3uwzXLEnIZ7VNTWQKG+SanjN/F
         EtK8ljPE4ZyxKNkJRNbjyPZagWENRQzblBegEd9JxkDEu6w6oBe0u220YQSIXgrD+0KX
         NHkZ/rDTRDocFSyJeoLIIKotdNolKGVY3DFSwBnjU1x0Yyr43ur7GnoAiwqgx43gEHqu
         W0qNHflEjv2PX16MN9s3AAbe5vIY7AsGRYZHDLbfjdl/CqUM/sX4MKV9cVM1w577ZlXY
         dSKWT3d5bPYCXrB39g4Tm04ym2kZLWxvqnsWKZhU02PVEeR4s7SvKw/LeazKW5n3K774
         2/Pw==
X-Gm-Message-State: APjAAAXUeHzZUQRAUhtCjl9d4p3l06a9+ek8/dkvT7my+o/V2I6KM9/R
        BtniH6zE0GiDEKEkUkCXzU4vp1mxdho=
X-Google-Smtp-Source: APXvYqx6o1XtWxx/iWZ6cjAFiJaEFfAkKOAWjV3cMtn4W7y4t4eDJqA/4NpyUabZhQjlo2JzrHHoqg==
X-Received: by 2002:a17:90a:9f4a:: with SMTP id q10mr3102467pjv.95.1564581308426;
        Wed, 31 Jul 2019 06:55:08 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id y11sm71143156pfb.119.2019.07.31.06.55.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 06:55:07 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 1/2] cxgb4: sched: Use refcount_t for refcount
Date:   Wed, 31 Jul 2019 21:55:02 +0800
Message-Id: <20190731135502.26485-1-hslester96@gmail.com>
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
 drivers/net/ethernet/chelsio/cxgb4/sched.c | 8 ++++----
 drivers/net/ethernet/chelsio/cxgb4/sched.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index 60218dc676a8..2d04ffb31528 100644
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
+		refcount_set(&e->refcnt, 0);
 		e->state = SCHED_STATE_ACTIVE;
 	}
 
@@ -488,7 +488,7 @@ struct sched_table *t4_init_sched(unsigned int sched_size)
 		s->tab[i].idx = i;
 		s->tab[i].state = SCHED_STATE_UNUSED;
 		INIT_LIST_HEAD(&s->tab[i].queue_list);
-		atomic_set(&s->tab[i].refcnt, 0);
+		refcount_set(&s->tab[i].refcnt, 0);
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

