Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC66648078F
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 10:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhL1JD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 04:03:29 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35699 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235791AbhL1JD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 04:03:29 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V03kfj-_1640682206;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V03kfj-_1640682206)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Dec 2021 17:03:27 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: [PATCH net 1/2] net/smc: don't send CDC/LLC message if link not ready
Date:   Tue, 28 Dec 2021 17:03:24 +0800
Message-Id: <20211228090325.27263-2-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20211228090325.27263-1-dust.li@linux.alibaba.com>
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found smc_llc_send_link_delete_all() sometimes wait
for 2s timeout when testing with RDMA link up/down.
It is possible when a smc_link is in ACTIVATING state,
the underlaying QP is still in RESET or RTR state, which
cannot send any messages out.

smc_llc_send_link_delete_all() use smc_link_usable() to
checks whether the link is usable, if the QP is still in
RESET or RTR state, but the smc_link is in ACTIVATING, this
LLC message will always fail without any CQE entering the
CQ, and we will always wait 2s before timeout.

Since we cannot send any messages through the QP before
the QP enter RTS. I add a wrapper smc_link_sendable()
which checks the state of QP along with the link state.
And replace smc_link_usable() with smc_link_sendable()
in all LLC & CDC message sending routine.

Fixes: 5f08318f617b ("smc: connection data control (CDC)")
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_core.c | 2 +-
 net/smc/smc_core.h | 6 ++++++
 net/smc/smc_llc.c  | 2 +-
 net/smc/smc_wr.c   | 4 ++--
 net/smc/smc_wr.h   | 2 +-
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 387d28b2f8dd..55ca175e8d57 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -647,7 +647,7 @@ static void smcr_lgr_link_deactivate_all(struct smc_link_group *lgr)
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		struct smc_link *lnk = &lgr->lnk[i];
 
-		if (smc_link_usable(lnk))
+		if (smc_link_sendable(lnk))
 			lnk->state = SMC_LNK_INACTIVE;
 	}
 	wake_up_all(&lgr->llc_msg_waiter);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 59cef3b830d8..d63b08274197 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -415,6 +415,12 @@ static inline bool smc_link_usable(struct smc_link *lnk)
 	return true;
 }
 
+static inline bool smc_link_sendable(struct smc_link *lnk)
+{
+	return smc_link_usable(lnk) &&
+		lnk->qp_attr.cur_qp_state == IB_QPS_RTS;
+}
+
 static inline bool smc_link_active(struct smc_link *lnk)
 {
 	return lnk->state == SMC_LNK_ACTIVE;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index b102680296b8..3e9fd8a3124c 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1630,7 +1630,7 @@ void smc_llc_send_link_delete_all(struct smc_link_group *lgr, bool ord, u32 rsn)
 	delllc.reason = htonl(rsn);
 
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_usable(&lgr->lnk[i]))
+		if (!smc_link_sendable(&lgr->lnk[i]))
 			continue;
 		if (!smc_llc_send_message_wait(&lgr->lnk[i], &delllc))
 			break;
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 600ab5889227..aaf3028a6fe9 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -188,7 +188,7 @@ void smc_wr_tx_cq_handler(struct ib_cq *ib_cq, void *cq_context)
 static inline int smc_wr_tx_get_free_slot_index(struct smc_link *link, u32 *idx)
 {
 	*idx = link->wr_tx_cnt;
-	if (!smc_link_usable(link))
+	if (!smc_link_sendable(link))
 		return -ENOLINK;
 	for_each_clear_bit(*idx, link->wr_tx_mask, link->wr_tx_cnt) {
 		if (!test_and_set_bit(*idx, link->wr_tx_mask))
@@ -231,7 +231,7 @@ int smc_wr_tx_get_free_slot(struct smc_link *link,
 	} else {
 		rc = wait_event_interruptible_timeout(
 			link->wr_tx_wait,
-			!smc_link_usable(link) ||
+			!smc_link_sendable(link) ||
 			lgr->terminating ||
 			(smc_wr_tx_get_free_slot_index(link, &idx) != -EBUSY),
 			SMC_WR_TX_WAIT_FREE_SLOT_TIME);
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index f353311e6f84..48ed9b08ac7a 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -62,7 +62,7 @@ static inline void smc_wr_tx_set_wr_id(atomic_long_t *wr_tx_id, long val)
 
 static inline bool smc_wr_tx_link_hold(struct smc_link *link)
 {
-	if (!smc_link_usable(link))
+	if (!smc_link_sendable(link))
 		return false;
 	atomic_inc(&link->wr_tx_refcnt);
 	return true;
-- 
2.19.1.3.ge56e4f7

