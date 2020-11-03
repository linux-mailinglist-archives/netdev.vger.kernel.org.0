Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21242A3FD6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgKCJTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgKCJTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:19:08 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D0FC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:19:08 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id a200so13638940pfa.10
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eLTansvwhuS/FSHqhj49yYp2DNG3ITpf5pPmyBMM/GU=;
        b=sr4uQR43N86qnT5gb3StcgiOvcZuaAHbuXs+v2Nxh9lxR0AEjJ3AQaCW4Z7McQJyIh
         63pDVLiXc5Hsfgjj5x59SkLh5zAYLGrBpwIJGO8Ut/KOCbs1Cg+MtaNsqNgnzU7+bjhI
         nH9//96IlL3Ghdn1CYIia9vmTq30NRtpyBIor61Wynuwhwfw8M8kEtyrz4QXjV4RBLmN
         42wsfNUxsuKT+Xi/yMrdw91p2qBXTV9DaPYqXuy1qN2tebzj2ES4/hJIPIRrjm/dBMna
         UA8J+LJArr/rdBCVD72Ui98rHS0QN8cmRvIV/Y6gNa4WM4spp0W/f3Nj03jXdITbMmez
         9EAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eLTansvwhuS/FSHqhj49yYp2DNG3ITpf5pPmyBMM/GU=;
        b=TBzxZvW1R9K+ACQcXnxGRZRbXFntCH6pPDiwys1CcBw1RJNImfW8/ZI1R45wK62FGf
         3S5fe/r/15VsKjEEyO8FaZq8zyWXkJ48wAIM23fTENCDJ+2wQEcLIvCTEDM0Zji7Ag1u
         lFs7XWjS73ROEIPwGCx31ACxBJwEzPmd89aMUBKP6XejO3nsQwxuySlFukNok5UZ0bvL
         94ceAKwTdhW9QBpPqcl0p0OTnJ8uvYYvOMR4JsQJJVDZg5zRl+iLpAIPDoX8QUqMSCAo
         XvisTlGQyp1nxtMJYiWT5/W1qlYydwr7U6AGRSX4nAcvqHna/Tby2Lji+RFC8pmaJIcI
         l0ZQ==
X-Gm-Message-State: AOAM533UV9iwlJV9uwy8JkvAvZHJ0fQHORiGe+pAW2HrZAboU4UcoOdw
        gfG0us3KlTGO5RRmQRF2mrE=
X-Google-Smtp-Source: ABdhPJzoVWPFdJiBnFQHm6ma+jowTXPeb/kcQM+TEilMDUgMd4nHTvazbErVej6378DYYgKzZ8G4Nw==
X-Received: by 2002:a17:90b:4d12:: with SMTP id mw18mr893753pjb.32.1604395147877;
        Tue, 03 Nov 2020 01:19:07 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:19:07 -0800 (PST)
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
Subject: [net-next v4 5/8] net: rds: convert tasklets to use new tasklet_setup() API
Date:   Tue,  3 Nov 2020 14:48:20 +0530
Message-Id: <20201103091823.586717-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201103091823.586717-1-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
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

