Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E784A37F9
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 19:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355780AbiA3SDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 13:03:11 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:35463 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236867AbiA3SDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 13:03:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V3BCr7A_1643565786;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V3BCr7A_1643565786)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 31 Jan 2022 02:03:07 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH net-next 2/3] net/smc: Remove corked dealyed work
Date:   Mon, 31 Jan 2022 02:02:56 +0800
Message-Id: <20220130180256.28303-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220130180256.28303-1-tonylu@linux.alibaba.com>
References: <20220130180256.28303-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the manual of TCP_CORK [1] and MSG_MORE [2], these two options
have the same effect. Applications can set these options and informs the
kernel to pend the data, and send them out only when the socket or
syscall does not specify this flag. In other words, there's no need to
send data out by a delayed work, which will queue a lot of work.

This removes corked delayed work with SMC_TX_CORK_DELAY (250ms), and the
applications control how/when to send them out. It improves the
performance for sendfile and throughput, and remove unnecessary race of
lock_sock(). This also unlocks the limitation of sndbuf, and try to fill
it up before sending.

[1] https://linux.die.net/man/7/tcp
[2] https://man7.org/linux/man-pages/man2/send.2.html

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_tx.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 7b0b6e24582f..9cec62cae7cb 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -31,7 +31,6 @@
 #include "smc_tracepoint.h"
 
 #define SMC_TX_WORK_DELAY	0
-#define SMC_TX_CORK_DELAY	(HZ >> 2)	/* 250 ms */
 
 /***************************** sndbuf producer *******************************/
 
@@ -237,15 +236,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		if ((msg->msg_flags & MSG_OOB) && !send_remaining)
 			conn->urg_tx_pend = true;
 		if ((msg->msg_flags & MSG_MORE || smc_tx_is_corked(smc)) &&
-		    (atomic_read(&conn->sndbuf_space) >
-						(conn->sndbuf_desc->len >> 1)))
-			/* for a corked socket defer the RDMA writes if there
-			 * is still sufficient sndbuf_space available
+		    (atomic_read(&conn->sndbuf_space)))
+			/* for a corked socket defer the RDMA writes if
+			 * sndbuf_space is still available. The applications
+			 * should known how/when to uncork it.
 			 */
-			queue_delayed_work(conn->lgr->tx_wq, &conn->tx_work,
-					   SMC_TX_CORK_DELAY);
-		else
-			smc_tx_sndbuf_nonempty(conn);
+			continue;
+		smc_tx_sndbuf_nonempty(conn);
 
 		trace_smc_tx_sendmsg(smc, copylen);
 	} /* while (msg_data_left(msg)) */
-- 
2.32.0.3.g01195cf9f

