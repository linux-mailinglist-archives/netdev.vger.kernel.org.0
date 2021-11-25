Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F379945DA22
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 13:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353084AbhKYMiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 07:38:51 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55596 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345428AbhKYMgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 07:36:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyGWqse_1637843617;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyGWqse_1637843617)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 20:33:38 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net] net/smc: Clear memory when release and reuse buffer
Date:   Thu, 25 Nov 2021 20:28:59 +0800
Message-Id: <20211125122858.90726-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, buffers are clear when smc create connections and reuse
buffer. It will slow down the speed of establishing new connection. In
most cases, the applications hope to establish connections as quickly as
possible.

This patch moves memset() from connection creation path to release and
buffer unuse path, this trades off between speed of establishing and
release.

Test environments:
- CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4
- socket sndbuf / rcvbuf: 16384 / 131072 bytes
- w/o first round, 5 rounds, avg, 100 conns batch per round
- smc_buf_create() use bpftrace kprobe, introduces extra latency

Latency benchmarks for smc_buf_create():
  w/o patch : 19040.0 ns
  w/  patch :  1932.6 ns
  ratio :        10.2% (-89.8%)

Latency benchmarks for socket create and connect:
  w/o patch :   143.3 us
  w/  patch :   102.2 us
  ratio :        71.3% (-28.7%)

The latency of establishing connections is reduced by 28.7%.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index bb52c8b5f148..5f0bd547907d 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1102,18 +1102,24 @@ static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
 		smc_buf_free(lgr, true, rmb_desc);
 	} else {
 		rmb_desc->used = 0;
+		memset(rmb_desc->cpu_addr, 0, rmb_desc->len);
 	}
 }
 
 static void smc_buf_unuse(struct smc_connection *conn,
 			  struct smc_link_group *lgr)
 {
-	if (conn->sndbuf_desc)
+	if (conn->sndbuf_desc) {
 		conn->sndbuf_desc->used = 0;
-	if (conn->rmb_desc && lgr->is_smcd)
+		memset(conn->sndbuf_desc->cpu_addr, 0, conn->sndbuf_desc->len);
+	}
+	if (conn->rmb_desc && lgr->is_smcd) {
 		conn->rmb_desc->used = 0;
-	else if (conn->rmb_desc)
+		memset(conn->rmb_desc->cpu_addr, 0, conn->rmb_desc->len +
+		       sizeof(struct smcd_cdc_msg));
+	} else if (conn->rmb_desc) {
 		smcr_buf_unuse(conn->rmb_desc, lgr);
+	}
 }
 
 /* remove a finished connection from its link group */
@@ -2149,7 +2155,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 		if (buf_desc) {
 			SMC_STAT_RMB_SIZE(smc, is_smcd, is_rmb, bufsize);
 			SMC_STAT_BUF_REUSE(smc, is_smcd, is_rmb);
-			memset(buf_desc->cpu_addr, 0, bufsize);
 			break; /* found reusable slot */
 		}
 
-- 
2.32.0.3.g01195cf9f

