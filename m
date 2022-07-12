Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAAB5718EF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiGLLvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiGLLvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:51:39 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04788B38CA;
        Tue, 12 Jul 2022 04:51:35 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VJ7zTIJ_1657626692;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJ7zTIJ_1657626692)
          by smtp.aliyun-inc.com;
          Tue, 12 Jul 2022 19:51:32 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net/smc: remove redundant dma sync ops
Date:   Tue, 12 Jul 2022 19:51:25 +0800
Message-Id: <1657626690-60367-2-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
References: <1657626690-60367-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

smc_ib_sync_sg_for_cpu/device are the ops used for dma memory cache
consistency. Smc sndbufs are dma buffers, where CPU writes data to
it and PCIE device reads data from it. So for sndbufs,
smc_ib_sync_sg_for_device is needed and smc_ib_sync_sg_for_cpu is
redundant as PCIE device will not write the buffers. Smc rmbs
are dma buffers, where PCIE device write data to it and CPU read
data from it. So for rmbs, smc_ib_sync_sg_for_cpu is needed and
smc_ib_sync_sg_for_device is redundant as CPU will not write the buffers.

Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
---
 net/smc/af_smc.c   |  2 --
 net/smc/smc_core.c | 22 ----------------------
 net/smc/smc_core.h |  2 --
 net/smc/smc_rx.c   |  2 --
 net/smc/smc_tx.c   |  1 -
 5 files changed, 29 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 433bb5a7..9497a3b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1226,7 +1226,6 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			goto connect_abort;
 		}
 	}
-	smc_rmb_sync_sg_for_device(&smc->conn);
 
 	if (aclc->hdr.version > SMC_V1) {
 		struct smc_clc_msg_accept_confirm_v2 *clc_v2 =
@@ -2113,7 +2112,6 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 		if (smcr_lgr_reg_rmbs(conn->lnk, conn->rmb_desc))
 			return SMC_CLC_DECL_ERR_REGRMB;
 	}
-	smc_rmb_sync_sg_for_device(&new_smc->conn);
 
 	return 0;
 }
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index f40f6ed..1faa0cb 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2290,14 +2290,6 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	return 0;
 }
 
-void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn)
-{
-	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd ||
-	    !smc_link_active(conn->lnk))
-		return;
-	smc_ib_sync_sg_for_cpu(conn->lnk, conn->sndbuf_desc, DMA_TO_DEVICE);
-}
-
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn)
 {
 	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd ||
@@ -2320,20 +2312,6 @@ void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn)
 	}
 }
 
-void smc_rmb_sync_sg_for_device(struct smc_connection *conn)
-{
-	int i;
-
-	if (!smc_conn_lgr_valid(conn) || conn->lgr->is_smcd)
-		return;
-	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
-		if (!smc_link_active(&conn->lgr->lnk[i]))
-			continue;
-		smc_ib_sync_sg_for_device(&conn->lgr->lnk[i], conn->rmb_desc,
-					  DMA_FROM_DEVICE);
-	}
-}
-
 /* create the send and receive buffer for an SMC socket;
  * receive buffers are called RMBs;
  * (even though the SMC protocol allows more than one RMB-element per RMB,
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4cb03e9..c441dfe 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -513,10 +513,8 @@ void smc_rtoken_set(struct smc_link_group *lgr, int link_idx, int link_idx_new,
 		    __be32 nw_rkey_known, __be64 nw_vaddr, __be32 nw_rkey);
 void smc_rtoken_set2(struct smc_link_group *lgr, int rtok_idx, int link_id,
 		     __be64 nw_vaddr, __be32 nw_rkey);
-void smc_sndbuf_sync_sg_for_cpu(struct smc_connection *conn);
 void smc_sndbuf_sync_sg_for_device(struct smc_connection *conn);
 void smc_rmb_sync_sg_for_cpu(struct smc_connection *conn);
-void smc_rmb_sync_sg_for_device(struct smc_connection *conn);
 int smc_vlan_by_tcpsk(struct socket *clcsock, struct smc_init_info *ini);
 
 void smc_conn_free(struct smc_connection *conn);
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 338b9ef..00ad004 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -413,7 +413,6 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 				if (rc < 0) {
 					if (!read_done)
 						read_done = -EFAULT;
-					smc_rmb_sync_sg_for_device(conn);
 					goto out;
 				}
 			}
@@ -427,7 +426,6 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 			chunk_len_sum += chunk_len;
 			chunk_off = 0; /* modulo offset in recv ring buffer */
 		}
-		smc_rmb_sync_sg_for_device(conn);
 
 		/* update cursors */
 		if (!(flags & MSG_PEEK)) {
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 805a546..ca0d5f5 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -246,7 +246,6 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 				  tx_cnt_prep);
 		chunk_len_sum = chunk_len;
 		chunk_off = tx_cnt_prep;
-		smc_sndbuf_sync_sg_for_cpu(conn);
 		for (chunk = 0; chunk < 2; chunk++) {
 			rc = memcpy_from_msg(sndbuf_base + chunk_off,
 					     msg, chunk_len);
-- 
1.8.3.1

