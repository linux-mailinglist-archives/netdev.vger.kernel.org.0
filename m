Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FB2A2FD8
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgKBQbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:31:21 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:60104 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgKBQbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:31:21 -0500
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A2GUhvZ005209;
        Mon, 2 Nov 2020 08:30:43 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next] chelsio/chtls: Utilizing multiple rxq/txq to process requests
Date:   Mon,  2 Nov 2020 21:58:33 +0530
Message-Id: <20201102162832.22344-1-vinay.yadav@chelsio.com>
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

