Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB25294369
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438159AbgJTToH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:44:07 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:25489 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409263AbgJTToH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 15:44:07 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09KJi1ke008202;
        Tue, 20 Oct 2020 12:44:01 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net] chelsio/chtls: Utilizing multiple rxq/txq to process requests
Date:   Wed, 21 Oct 2020 01:13:06 +0530
Message-Id: <20201020194305.12352-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch adds a logic to utilize multiple queues to process requests.
The queue selection logic uses a round-robin distribution technique
using a counter.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h    | 1 +
 drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 2d3dfdd2a716..e7b78b68eaac 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -235,6 +235,7 @@ struct chtls_dev {
 	struct list_head na_node;
 	unsigned int send_page_order;
 	int max_host_sndbuf;
+	u32 round_robin_cnt;
 	struct key_map kmap;
 	unsigned int cdev_state;
 };
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index ec4f79049a06..5c3242ec0e10 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1220,8 +1220,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	csk->sndbuf = csk->snd_win;
 	csk->ulp_mode = ULP_MODE_TLS;
 	step = cdev->lldi->nrxq / cdev->lldi->nchan;
-	csk->rss_qid = cdev->lldi->rxq_ids[port_id * step];
 	rxq_idx = port_id * step;
+	rxq_idx += cdev->round_robin_cnt++ % step;
+	csk->rss_qid = cdev->lldi->rxq_ids[rxq_idx];
 	csk->txq_idx = (rxq_idx < cdev->lldi->ntxq) ? rxq_idx :
 			port_id * step;
 	csk->sndbuf = newsk->sk_sndbuf;
-- 
2.18.1

