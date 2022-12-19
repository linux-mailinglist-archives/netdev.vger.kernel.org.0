Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E846510F8
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiLSRIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiLSRIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:08:34 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7755DF4C;
        Mon, 19 Dec 2022 09:08:21 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VXi9uYP_1671469697;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VXi9uYP_1671469697)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 01:08:19 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 4/5] net/smc: avoid data copy from sndbuf to peer RMB in SMC-D loopback
Date:   Tue, 20 Dec 2022 01:07:47 +0800
Message-Id: <1671469668-82691-5-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671469668-82691-1-git-send-email-guwen@linux.alibaba.com>
References: <1671469668-82691-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch aims to improve SMC-D loopback performance by avoiding
data copy from local sndbuf to peer RMB. The main idea is to let
local sndbuf and peer RMB share the same physical memory.

 +----------+                     +----------+
 | socket A |                     | socket B |
 +----------+                     +----------+
       |                               ^
       |         +---------+           |
  regard as      |         | ----------|
  local sndbuf   |  B's    |     regard as
       |         |  RMB    |     local RMB
       |-------> |         |
                 +---------+

For connections using smcd loopback device:

1. Only create and maintain local RMB.
        a. Create or reuse RMB when create connection;
        b. Free RMB when lgr free;

2. Attach local sndbuf to peer RMB.
        a. sndbuf_desc describes the same memory region as peer rmb_desc.
        b. sndbuf_desc is exclusive to specific connection and won't be
           added to lgr buffer pool for reuse.
        c. sndbuf is attached to peer RMB when receive remote token after
           CLC accept/confirm message.
        d. sndbuf is detached from peer RMB when connection is freed.

Therefore, the data copied from the userspace to local sndbuf directly
reaches the peer RMB.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c   | 23 +++++++++++++++++++-
 net/smc/smc_core.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_core.h |  2 ++
 3 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b9884c8..c7de566 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1073,7 +1073,6 @@ static int smc_find_proposal_devices(struct smc_sock *smc,
 	 * The RFC patch hasn't resolved this, just simply always
 	 * chooses loopback device first, and fallback if loopback
 	 * communication is impossible.
-	 *
 	 */
 	/* check if there is an ism or loopback device available */
 	if (!(ini->smcd_version & SMC_V1) ||
@@ -1397,6 +1396,17 @@ static int smc_connect_ism(struct smc_sock *smc,
 	}
 
 	smc_conn_save_peer_info(smc, aclc);
+
+	/* special for smcd loopback
+	 * conns above smcd loopback dev only create their rmbs.
+	 * their sndbufs are 'maps' of peer rmbs.
+	 */
+	if (smc->conn.lgr->smcd->is_loopback) {
+		rc = smcd_buf_attach(&smc->conn);
+		if (rc)
+			goto connect_abort;
+		smc->sk.sk_sndbuf = 2 * (smc->conn.sndbuf_desc->len);
+	}
 	smc_close_init(smc);
 	smc_rx_init(smc);
 	smc_tx_init(smc);
@@ -2464,6 +2474,17 @@ static void smc_listen_work(struct work_struct *work)
 		mutex_unlock(&smc_server_lgr_pending);
 	}
 	smc_conn_save_peer_info(new_smc, cclc);
+
+	/* special for smcd loopback
+	 * conns above smcd loopback dev only create their rmbs.
+	 * their sndbufs are 'maps' of peer rmbs.
+	 */
+	if (ini->is_smcd && new_smc->conn.lgr->smcd->is_loopback) {
+		rc = smcd_buf_attach(&new_smc->conn);
+		if (rc)
+			goto out_decl;
+		new_smc->sk.sk_sndbuf = 2 * (new_smc->conn.sndbuf_desc->len);
+	}
 	smc_listen_out_connected(new_smc);
 	SMC_STAT_SERV_SUCC_INC(sock_net(newclcsock->sk), ini);
 	goto out_free;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index c305d8d..bf40ad3 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1171,6 +1171,10 @@ void smc_conn_free(struct smc_connection *conn)
 		if (!list_empty(&lgr->list))
 			smc_ism_unset_conn(conn);
 		tasklet_kill(&conn->rx_tsklet);
+
+		/* detach sndbuf from peer rmb */
+		if (lgr->smcd->is_loopback)
+			smcd_buf_detach(conn);
 	} else {
 		smc_cdc_wait_pend_tx_wr(conn);
 		if (current_work() != &conn->abort_work)
@@ -2423,6 +2427,14 @@ int smc_buf_create(struct smc_sock *smc, bool is_smcd)
 {
 	int rc;
 
+	if (is_smcd && smc->conn.lgr->smcd->is_loopback) {
+		/* Conns above smcd loopback device only create and maintain
+		 * their RMBs. The sndbufs will be attached to peer RMBs once
+		 * getting the tokens.
+		 */
+		return __smc_buf_create(smc, is_smcd, true);
+	}
+
 	/* create send buffer */
 	rc = __smc_buf_create(smc, is_smcd, false);
 	if (rc)
@@ -2439,6 +2451,56 @@ int smc_buf_create(struct smc_sock *smc, bool is_smcd)
 	return rc;
 }
 
+/* for smcd loopback conns, attach local sndbuf to peer RMB.
+ * The data copy to sndbuf is equal to data copy to peer RMB.
+ */
+int smcd_buf_attach(struct smc_connection *conn)
+{
+	struct smcd_dev *smcd = conn->lgr->smcd;
+	u64 peer_token = conn->peer_token;
+	struct smc_buf_desc *buf_desc;
+	int rc;
+
+	buf_desc = kzalloc(sizeof(*buf_desc), GFP_KERNEL);
+	if (!buf_desc)
+		return -ENOMEM;
+	rc = smc_ism_attach_dmb(smcd, peer_token, buf_desc);
+	if (rc) {
+		rc = SMC_CLC_DECL_ERR_RTOK;
+		goto free;
+	}
+
+	/* attach local sndbuf to peer RMB.
+	 * refer to local sndbuf is equal to refer to peer RMB.
+	 */
+	/* align with peer rmb */
+	buf_desc->cpu_addr = (u8 *)buf_desc->cpu_addr + sizeof(struct smcd_cdc_msg);
+	buf_desc->len -=  sizeof(struct smcd_cdc_msg);
+	conn->sndbuf_desc = buf_desc;
+	conn->sndbuf_desc->used = 1;
+	//smc->sk.sk_sndbuf = 2 * (smc->conn->sndbuf_desc->len);
+	atomic_set(&conn->sndbuf_space, conn->sndbuf_desc->len);
+	return 0;
+
+free:
+	kfree(buf_desc);
+	return rc;
+}
+
+void smcd_buf_detach(struct smc_connection *conn)
+{
+	struct smcd_dev *smcd = conn->lgr->smcd;
+	u64 peer_token = conn->peer_token;
+
+	if (!conn->sndbuf_desc)
+		return;
+
+	smc_ism_detach_dmb(smcd, peer_token);
+
+	kfree(conn->sndbuf_desc);
+	conn->sndbuf_desc = NULL;
+}
+
 static inline int smc_rmb_reserve_rtoken_idx(struct smc_link_group *lgr)
 {
 	int i;
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 285f9bd..b51b020 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -518,6 +518,8 @@ void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,
 void smc_smcd_terminate_all(struct smcd_dev *dev);
 void smc_smcr_terminate_all(struct smc_ib_device *smcibdev);
 int smc_buf_create(struct smc_sock *smc, bool is_smcd);
+int smcd_buf_attach(struct smc_connection *conn);
+void smcd_buf_detach(struct smc_connection *conn);
 int smc_uncompress_bufsize(u8 compressed);
 int smc_rmb_rtoken_handling(struct smc_connection *conn, struct smc_link *link,
 			    struct smc_clc_msg_accept_confirm *clc);
-- 
1.8.3.1

