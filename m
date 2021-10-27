Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE5F43C591
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241050AbhJ0IzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:55:06 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:59276 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235961AbhJ0IzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 04:55:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UtsJwZd_1635324758;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UtsJwZd_1635324758)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 16:52:38 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: [PATCH net 1/4] Revert "net/smc: don't wait for send buffer space when data was already sent"
Date:   Wed, 27 Oct 2021 16:52:07 +0800
Message-Id: <20211027085208.16048-2-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211027085208.16048-1-tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tony.ly@linux.alibaba.com>

This reverts commit 6889b36da78a21a312d8b462c1fa25a03c2ff192.

When using SMC to replace TCP, some userspace applications like netperf
don't check the return code of send syscall correctly, which means how
many bytes are sent. If rc of send() is smaller than expected, it should
try to send again, instead of exit directly. It is difficult to change
the uncorrect behaviors of userspace applications, so choose to revert it.

Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Reported-by: Jacob Qi <jacob.qi@linux.alibaba.com>
Signed-off-by: Tony Lu <tony.ly@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 738a4a99c827..d401286e9058 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -178,11 +178,12 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 			conn->local_tx_ctrl.prod_flags.urg_data_pending = 1;
 
 		if (!atomic_read(&conn->sndbuf_space) || conn->urg_tx_pend) {
-			if (send_done)
-				return send_done;
 			rc = smc_tx_wait(smc, msg->msg_flags);
-			if (rc)
+			if (rc) {
+				if (send_done)
+					return send_done;
 				goto out_err;
+			}
 			continue;
 		}
 
-- 
2.19.1.6.gb485710b

