Return-Path: <netdev+bounces-8708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93F83725492
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5D551C20A98
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8851D440C;
	Wed,  7 Jun 2023 06:44:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5337F7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 06:44:09 +0000 (UTC)
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8C4710C3;
	Tue,  6 Jun 2023 23:44:07 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="6.00,223,1681138800"; 
   d="scan'208";a="162521557"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 07 Jun 2023 15:44:07 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id F04F74005E29;
	Wed,  7 Jun 2023 15:44:06 +0900 (JST)
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: s.shtylyov@omp.ru,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: [PATCH net] net: renesas: rswitch: Fix timestamp feature after all descritors are used
Date: Wed,  7 Jun 2023 15:44:02 +0900
Message-Id: <20230607064402.1795548-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The timestamp descriptors were intended to act cyclically. Descriptors
from index 0 through gq->ring_size - 1 contain actual information, and
the last index (gq->ring_size) should have LINKFIX to indicate
the first index 0 descriptor. However, thie LINKFIX value is missing,
causing the timestamp feature to stop after all descriptors are used.
To resolve this issue, set the LINKFIX to the timestamp descritors.

Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 Since I got this report locally, I didn't add Closes: tag.

 drivers/net/ethernet/renesas/rswitch.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index aace87139cea..049adbf5a642 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -420,7 +420,7 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 }
 
 static void rswitch_gwca_ts_queue_fill(struct rswitch_private *priv,
-				       int start_index, int num)
+				       int start_index, int num, bool last)
 {
 	struct rswitch_gwca_queue *gq = &priv->gwca.ts_queue;
 	struct rswitch_ts_desc *desc;
@@ -431,6 +431,12 @@ static void rswitch_gwca_ts_queue_fill(struct rswitch_private *priv,
 		desc = &gq->ts_ring[index];
 		desc->desc.die_dt = DT_FEMPTY_ND | DIE;
 	}
+
+	if (last) {
+		desc = &gq->ts_ring[gq->ring_size];
+		rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
+		desc->desc.die_dt = DT_LINKFIX;
+	}
 }
 
 static int rswitch_gwca_queue_ext_ts_fill(struct net_device *ndev,
@@ -941,7 +947,7 @@ static void rswitch_ts(struct rswitch_private *priv)
 	}
 
 	num = rswitch_get_num_cur_queues(gq);
-	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num);
+	rswitch_gwca_ts_queue_fill(priv, gq->dirty, num, false);
 	gq->dirty = rswitch_next_queue_index(gq, false, num);
 }
 
@@ -1780,7 +1786,7 @@ static int rswitch_init(struct rswitch_private *priv)
 	if (err < 0)
 		goto err_ts_queue_alloc;
 
-	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE);
+	rswitch_gwca_ts_queue_fill(priv, 0, TS_RING_SIZE, true);
 	INIT_LIST_HEAD(&priv->gwca.ts_info_list);
 
 	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
-- 
2.25.1


