Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BDA246143
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgHQIwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgHQIwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:52:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36117C061388;
        Mon, 17 Aug 2020 01:52:11 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t10so7157183plz.10;
        Mon, 17 Aug 2020 01:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FBwgroa5ysfr0mOctJOQjACyLAT2zXIJaPJz3rnhkuM=;
        b=UNXbknHW6Kjd/+Qrjr+x0igc7PXrS8iFuBBcvR4LmNo7I3d93wK0HQ0pJpE2l810Rc
         kd5aQJu7Czwuoks2B/EonPDstuPaV9k19zY9NOXOdBzJdZ2fz2bGfyvK7QB1K2cD+ZGd
         qAUqSPH9fpsLj+EqIOxWOkC/mT4G2fftllOK8kzgjr4DAHXNi8figb6vBuuCQQQfbnZt
         SA8wtgta58pLjDkKLl/VneyFfZHGTFNDPr+p9r7ut0nAov0NKZBb2bhb7NyI/s2ia3qm
         UIpkg1fmaJ7tX5Zs3zZbOGpMnkBu1DXVHmS6eglYeAQ2CAtLYtgVCHF9raly2gfaDdV4
         2fwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FBwgroa5ysfr0mOctJOQjACyLAT2zXIJaPJz3rnhkuM=;
        b=kNT6uuSwcIPQYl/y2MSOhQUHEsGk17a2L1eBuT082e6mPjm1I+2+mqqe8e99ben01G
         fLRFRIJZXG8Mnd6dLG6EFdEFZcWtxwujV7MmippJOW6F/ifOMBKxynZzZXSeG+E3l7ot
         uOSPtupHTc+d2rM4HJlG2WkAHpunbONg75Y2ZrTLmXcERegEzfhe3Ev/kBKsw1FHQsad
         HAyPC655dU2pcL2zUkt6up9ikCsSQpvHIL0bDQhpiFH4yEElZW/jKsIGAJ7z16WRrQXz
         JpIpDe5kEZegobZiEOpdjvUKp0xwIhlpRQRpbvTSG85XyQwEDZIfWuR1FQqfMk0zX7KD
         yZNA==
X-Gm-Message-State: AOAM5313ojsgGRhWPW/gH0DJG4p7RhpUmoh6n+dm3nLM0M7Kb3yLA3CE
        n50uDawpgycfZQAEWcBr+XQ=
X-Google-Smtp-Source: ABdhPJzHWrkDQzqDFcQ5s56yRVeDTo9be/bCA2S56GP8Ll8Uy+wcH4cPFMPncT3lbIdRtXKCLdaq1g==
X-Received: by 2002:a17:90a:d986:: with SMTP id d6mr11019969pjv.134.1597654330763;
        Mon, 17 Aug 2020 01:52:10 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:52:10 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 5/8] net: rds: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:17 +0530
Message-Id: <20200817085120.24894-5-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085120.24894-1-allen.cryptic@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 net/rds/ib_cm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index c3319ff3ee11..2e8872d51fa8 100644
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
@@ -1218,10 +1218,8 @@ int rds_ib_conn_alloc(struct rds_connection *conn, gfp_t gfp)
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
2.17.1

