Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFF92845AF
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgJFFxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgJFFxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 01:53:42 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A642FC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 22:53:42 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so7362279pgm.11
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 22:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6g5ccEqZLcgP1SObLQ8MYioz4JKNSnfj9H/FuCDJen0=;
        b=jk8L584cuWVWJkr25ZtP61aGFvGcUMMpI1Cw753OK1K5mvOSIHAP/2a8LQSfyP686L
         gpxHI9dl/wZ7+hKpBNHtBEGbml1OJnKpVRm5k10YgJRjrYvmmiWBimHx2ANfwiNY8NLy
         cfe6JY5GA1WkspdklypslnoZsHbxtg6pq4F3+4wTFBWsWfO1yw3xD/1a4BhWdq9Pftq8
         0lM1ZnE+QUxozBIsE2h91Egcdf2GEwVqlpJmA5eqf+SQSLqVlMbTUlmpXRfgAeNu+w9r
         kguG7LKGurpVQbKAbey+uaCjzsdUOOYewkqCJRMsovIxHhc37kJjSbW7ELGumOIZml+A
         XasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6g5ccEqZLcgP1SObLQ8MYioz4JKNSnfj9H/FuCDJen0=;
        b=ZUNnpJwhWL3+WmQXNriOQ4aRh97A3dYzzZJs9T7UWXDDEr/wZF2+xZVZtF+E5k0MOf
         1mA/nI5mOcYJmm9lcBUm4mkkRTVSCO+mjniy36SOCNCKEyGiR9l+ZZ5l9tFwd5WJ3EZD
         q8y+/G3x6DHxVM6mgvvv7n5D4gVsTiG1kD4rlxtkx9yjeqL9QTC3d9yBZjsN9E/7gm6V
         gEPzoIlJQ2562XOgbX1jn2cvdizNoPoNoiClu+LeBRk4p5N0jq4HKd7CkGxk/YSWBwmp
         s+Ez2X6ivEt4slSr3MAcRJ8dNuUEodm202B3wIOX9f947T1NeUjJ2i8beQvVQL9cc9sB
         5/WQ==
X-Gm-Message-State: AOAM530QgN7L68KV1KPscdc3pbAQAGLoptegwZoKGUq/sPG+NLboH0Vj
        Kjo9gf6KHcnnCyMAwzsCT3RD4T8aB6s=
X-Google-Smtp-Source: ABdhPJxAijQxJcCiGEZPSwhFjEog/coXfy/qtedi85bxCXGIddDKnZxdwpiTclUYAbS1EUPnZ1qbxg==
X-Received: by 2002:a63:1e65:: with SMTP id p37mr2747269pgm.131.1601963621946;
        Mon, 05 Oct 2020 22:53:41 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id 131sm2011256pfy.5.2020.10.05.22.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 22:53:41 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] cxgb4: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:23:32 +0530
Message-Id: <20201006055332.291520-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
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
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h           | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c | 3 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c             | 5 +++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index f55550d3a..3352dad6c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -2111,7 +2111,7 @@ void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 void cxgb4_eosw_txq_free_desc(struct adapter *adap, struct sge_eosw_txq *txq,
 			      u32 ndesc);
 int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc);
-void cxgb4_ethofld_restart(unsigned long data);
+void cxgb4_ethofld_restart(struct tasklet_struct *t);
 int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
 			     const struct pkt_gl *si);
 void free_txq(struct adapter *adap, struct sge_txq *q);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index ae7123a9d..6c259de96 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -114,8 +114,7 @@ static int cxgb4_init_eosw_txq(struct net_device *dev,
 	eosw_txq->cred = adap->params.ofldq_wr_cred;
 	eosw_txq->hwqid = hwqid;
 	eosw_txq->netdev = dev;
-	tasklet_init(&eosw_txq->qresume_tsk, cxgb4_ethofld_restart,
-		     (unsigned long)eosw_txq);
+	tasklet_setup(&eosw_txq->qresume_tsk, cxgb4_ethofld_restart);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 54e22f17a..a9e9c7ae5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3887,9 +3887,10 @@ static int napi_rx_handler(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-void cxgb4_ethofld_restart(unsigned long data)
+void cxgb4_ethofld_restart(struct tasklet_struct *t)
 {
-	struct sge_eosw_txq *eosw_txq = (struct sge_eosw_txq *)data;
+	struct sge_eosw_txq *eosw_txq = from_tasklet(eosw_txq, t,
+						     qresume_tsk);
 	int pktcount;
 
 	spin_lock(&eosw_txq->lock);
-- 
2.25.1

