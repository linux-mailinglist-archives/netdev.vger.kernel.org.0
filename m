Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB632A3D31
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgKCHKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgKCHKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:40 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D60C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 23:10:40 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id z3so7010348pfz.6
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 23:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eLTansvwhuS/FSHqhj49yYp2DNG3ITpf5pPmyBMM/GU=;
        b=HcsdxSelfgsTNqiS3e6nT+6IRElsdVhoCztDGNXRWoOsyU2ds2QlUl59vlBL3fXxyQ
         /1Dq68iB54L+7unzijvHQcSOyCYidsZ7aG44uD8Pc+QNlClg9nTxSf8EdopNAe4Xgsly
         eF+x8HQtJBFquOOA16B1RPaps6uUzBud/oC5vCuhh9Vw/FOVR3i0Pwuyu0fl7wZT6Ve7
         kGKFWKHxKLpqByDtGm5M7hBFB1LiOPsBhTDvdh7fNeV0v5WQ6CW/baXcfhkynXJJOhJm
         ZLwnKBPfWFAlE7svAITssU6K2HdccV0cQ63eTPp5IaAag1b2NMrhZjxuChiBLVbMWj24
         1zFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eLTansvwhuS/FSHqhj49yYp2DNG3ITpf5pPmyBMM/GU=;
        b=ug3pR20EKBAHhJSEN8ffP2tYI6nFBMfhI/oqd0LP3FM4TI3PyABvWJLWMnXkZ68LKi
         DKOkAn6s2mVeKO3hNp0NIq6wSzuIC4wVbLQlXX/PZK1s2YrABBIGuitFkV6XEAkzg9eG
         /jptKnMkMrDy7MPZZ0mtFeBZxhFguYA9bcHTSX2SKB5yFfOy4TwXRrKVFbYuO2uTRFJS
         FC3EAwdjjCI7Srar/chP5+y2JmdkRD8GzKHz630PjHrh3kLDeZkKylFpD8jlENlxMBHU
         nwtlRHHDaR6ByCBmtcxWv9e88wcEDbRZhJvTQtredwBMBQwUQmFfo9dYbHuuasOhhiX8
         nvAw==
X-Gm-Message-State: AOAM530KlKAy7FmgzCIrPuULDXHCVTKigxpaOxLypEMNCbXslTwiS/ru
        /JmjsyRlnl/ojnaWowKjG5c=
X-Google-Smtp-Source: ABdhPJws5qpdmLQNPB+JrywpPPGMx/f3h9R88/kj7yebjeBsmSsiaBbRxhwEQOKhD+lxAW2X+5ymCA==
X-Received: by 2002:a17:90a:ea8a:: with SMTP id h10mr2385718pjz.142.1604387439839;
        Mon, 02 Nov 2020 23:10:39 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id 92sm2020074pjv.32.2020.11.02.23.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 23:10:39 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next V3 5/8] net: rds: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 12:39:44 +0530
Message-Id: <20201103070947.577831-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103070947.577831-1-allen.lkml@gmail.com>
References: <20201103070947.577831-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/rds/ib_cm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index b36b60668b1d..d06398be4b80 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -314,9 +314,9 @@ static void poll_scq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_send(unsigned long data)
+static void rds_ib_tasklet_fn_send(struct tasklet_struct *t)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic = from_tasklet(ic, t, i_send_tasklet);
 	struct rds_connection *conn = ic->conn;
 
 	rds_ib_stats_inc(s_ib_tasklet_call);
@@ -354,9 +354,9 @@ static void poll_rcq(struct rds_ib_connection *ic, struct ib_cq *cq,
 	}
 }
 
-static void rds_ib_tasklet_fn_recv(unsigned long data)
+static void rds_ib_tasklet_fn_recv(struct tasklet_struct *t)
 {
-	struct rds_ib_connection *ic = (struct rds_ib_connection *)data;
+	struct rds_ib_connection *ic = from_tasklet(ic, t, i_recv_tasklet);
 	struct rds_connection *conn = ic->conn;
 	struct rds_ib_device *rds_ibdev = ic->rds_ibdev;
 	struct rds_ib_ack_state state;
@@ -1219,10 +1219,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
 	}
 
 	INIT_LIST_HEAD(&ic->ib_node);
-	tasklet_init(&ic->i_send_tasklet, rds_ib_tasklet_fn_send,
-		     (unsigned long)ic);
-	tasklet_init(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv,
-		     (unsigned long)ic);
+	tasklet_setup(&ic->i_send_tasklet, rds_ib_tasklet_fn_send);
+	tasklet_setup(&ic->i_recv_tasklet, rds_ib_tasklet_fn_recv);
 	mutex_init(&ic->i_recv_mutex);
 #ifndef KERNEL_HAS_ATOMIC64
 	spin_lock_init(&ic->i_ack_lock);
-- 
2.25.1

