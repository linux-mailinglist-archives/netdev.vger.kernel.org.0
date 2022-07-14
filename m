Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EAB574983
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbiGNJqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238445AbiGNJpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:45:49 -0400
Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CED618E2A;
        Thu, 14 Jul 2022 02:45:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VJImAgW_1657791939;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJImAgW_1657791939)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 17:45:40 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/6] net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
Date:   Thu, 14 Jul 2022 17:44:04 +0800
Message-Id: <1657791845-1060-6-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On long-running enterprise production servers, high-order contiguous
memory pages are usually very rare and in most cases we can only get
fragmented pages.

When replacing TCP with SMC-R in such production scenarios, attempting
to allocate high-order physically contiguous sndbufs and RMBs may result
in frequent memory compaction, which will cause unexpected hung issue
and further stability risks.

So this patch is aimed to allow SMC-R link group to use virtually
contiguous sndbufs and RMBs to avoid potential issues mentioned above.
Whether to use physically or virtually contiguous buffers can be set
by sysctl smcr_buf_type.

Note that using virtually contiguous buffers will bring an acceptable
performance regression, which can be mainly divided into two parts:

1) regression in data path, which is brought by additional address
   translation of sndbuf by RNIC in Tx. But in general, translating
   address through MTT is fast.

   Taking 256KB sndbuf and RMB as an example, the comparisons in qperf
   latency and bandwidth test with physically and virtually contiguous
   buffers are as follows:

- client:
  smc_run taskset -c <cpu> qperf <server> -oo msg_size:1:64K:*2\
  -t 5 -vu tcp_{bw|lat}
- server:
  smc_run taskset -c <cpu> qperf

   [latency]
   msgsize              tcp            smcr        smcr-use-virt-buf
   1               11.17 us         7.56 us         7.51 us (-0.67%)
   2               10.65 us         7.74 us         7.56 us (-2.31%)
   4               11.11 us         7.52 us         7.59 us ( 0.84%)
   8               10.83 us         7.55 us         7.51 us (-0.48%)
   16              11.21 us         7.46 us         7.51 us ( 0.71%)
   32              10.65 us         7.53 us         7.58 us ( 0.61%)
   64              10.95 us         7.74 us         7.80 us ( 0.76%)
   128             11.14 us         7.83 us         7.87 us ( 0.47%)
   256             10.97 us         7.94 us         7.92 us (-0.28%)
   512             11.23 us         7.94 us         8.20 us ( 3.25%)
   1024            11.60 us         8.12 us         8.20 us ( 0.96%)
   2048            14.04 us         8.30 us         8.51 us ( 2.49%)
   4096            16.88 us         9.13 us         9.07 us (-0.64%)
   8192            22.50 us        10.56 us        11.22 us ( 6.26%)
   16384           28.99 us        12.88 us        13.83 us ( 7.37%)
   32768           40.13 us        16.76 us        16.95 us ( 1.16%)
   65536           68.70 us        24.68 us        24.85 us ( 0.68%)
   [bandwidth]
   msgsize                tcp              smcr          smcr-use-virt-buf
   1                1.65 MB/s         1.59 MB/s         1.53 MB/s (-3.88%)
   2                3.32 MB/s         3.17 MB/s         3.08 MB/s (-2.67%)
   4                6.66 MB/s         6.33 MB/s         6.09 MB/s (-3.85%)
   8               13.67 MB/s        13.45 MB/s        11.97 MB/s (-10.99%)
   16              25.36 MB/s        27.15 MB/s        24.16 MB/s (-11.01%)
   32              48.22 MB/s        54.24 MB/s        49.41 MB/s (-8.89%)
   64             106.79 MB/s       107.32 MB/s        99.05 MB/s (-7.71%)
   128            210.21 MB/s       202.46 MB/s       201.02 MB/s (-0.71%)
   256            400.81 MB/s       416.81 MB/s       393.52 MB/s (-5.59%)
   512            746.49 MB/s       834.12 MB/s       809.99 MB/s (-2.89%)
   1024          1292.33 MB/s      1641.96 MB/s      1571.82 MB/s (-4.27%)
   2048          2007.64 MB/s      2760.44 MB/s      2717.68 MB/s (-1.55%)
   4096          2665.17 MB/s      4157.44 MB/s      4070.76 MB/s (-2.09%)
   8192          3159.72 MB/s      4361.57 MB/s      4270.65 MB/s (-2.08%)
   16384         4186.70 MB/s      4574.13 MB/s      4501.17 MB/s (-1.60%)
   32768         4093.21 MB/s      4487.42 MB/s      4322.43 MB/s (-3.68%)
   65536         4057.14 MB/s      4735.61 MB/s      4555.17 MB/s (-3.81%)

2) regression in buffer initialization and destruction path, which is
   brought by additional MR operations of sndbufs. But thanks to link
   group buffer reuse mechanism, the impact of this kind of regression
   decreases as times of buffer reuse increases.

   Taking 256KB sndbuf and RMB as an example, latency of some key SMC-R
   buffer-related function obtained by bpftrace are as follows:

   Function                         Phys-bufs           Virt-bufs
   smcr_new_buf_create()             67154 ns            79164 ns
   smc_ib_buf_map_sg()                 525 ns              928 ns
   smc_ib_get_memory_region()       162294 ns           161191 ns
   smc_wr_reg_send()                  9957 ns             9635 ns
   smc_ib_put_memory_region()       203548 ns           198374 ns
   smc_ib_buf_unmap_sg()               508 ns             1158 ns

------------
Test environment notes:
1. Above tests run on 2 VMs within the same Host.
2. The NIC is ConnectX-4Lx, using SRIOV and passing through 2 VFs to
   the each VM respectively.
3. VMs' vCPUs are binded to different physical CPUs, and the binded
   physical CPUs are isolated by `isolcpus=xxx` cmdline.
4. NICs' queue number are set to 1.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c   |  66 +++++++++++++++--
 net/smc/smc_clc.c  |   8 +-
 net/smc/smc_clc.h  |   2 +-
 net/smc/smc_core.c | 213 +++++++++++++++++++++++++++++++++++++----------------
 net/smc/smc_core.h |  10 ++-
 net/smc/smc_ib.c   |  15 ++--
 net/smc/smc_llc.c  |  33 +++++----
 net/smc/smc_rx.c   |  90 ++++++++++++++++++----
 net/smc/smc_tx.c   |   9 ++-
 9 files changed, 328 insertions(+), 118 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 9497a3b..6e70d9c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -487,6 +487,29 @@ static void smc_copy_sock_settings_to_smc(struct smc_sock *smc)
 	smc_copy_sock_settings(&smc->sk, smc->clcsock->sk, SK_FLAGS_CLC_TO_SMC);
 }
 
+/* register the new vzalloced sndbuf on all links */
+static int smcr_lgr_reg_sndbufs(struct smc_link *link,
+				struct smc_buf_desc *snd_desc)
+{
+	struct smc_link_group *lgr = link->lgr;
+	int i, rc = 0;
+
+	if (!snd_desc->is_vm)
+		return -EINVAL;
+
+	/* protect against parallel smcr_link_reg_buf() */
+	mutex_lock(&lgr->llc_conf_mutex);
+	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
+		if (!smc_link_active(&lgr->lnk[i]))
+			continue;
+		rc = smcr_link_reg_buf(&lgr->lnk[i], snd_desc);
+		if (rc)
+			break;
+	}
+	mutex_unlock(&lgr->llc_conf_mutex);
+	return rc;
+}
+
 /* register the new rmb on all links */
 static int smcr_lgr_reg_rmbs(struct smc_link *link,
 			     struct smc_buf_desc *rmb_desc)
@@ -498,13 +521,13 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	if (rc)
 		return rc;
 	/* protect against parallel smc_llc_cli_rkey_exchange() and
-	 * parallel smcr_link_reg_rmb()
+	 * parallel smcr_link_reg_buf()
 	 */
 	mutex_lock(&lgr->llc_conf_mutex);
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
-		rc = smcr_link_reg_rmb(&lgr->lnk[i], rmb_desc);
+		rc = smcr_link_reg_buf(&lgr->lnk[i], rmb_desc);
 		if (rc)
 			goto out;
 	}
@@ -550,8 +573,15 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 
 	smc_wr_remember_qp_attr(link);
 
-	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc))
-		return SMC_CLC_DECL_ERR_REGRMB;
+	/* reg the sndbuf if it was vzalloced */
+	if (smc->conn.sndbuf_desc->is_vm) {
+		if (smcr_link_reg_buf(link, smc->conn.sndbuf_desc))
+			return SMC_CLC_DECL_ERR_REGBUF;
+	}
+
+	/* reg the rmb */
+	if (smcr_link_reg_buf(link, smc->conn.rmb_desc))
+		return SMC_CLC_DECL_ERR_REGBUF;
 
 	/* confirm_rkey is implicit on 1st contact */
 	smc->conn.rmb_desc->is_conf_rkey = true;
@@ -1221,8 +1251,15 @@ static int smc_connect_rdma(struct smc_sock *smc,
 			goto connect_abort;
 		}
 	} else {
+		/* reg sendbufs if they were vzalloced */
+		if (smc->conn.sndbuf_desc->is_vm) {
+			if (smcr_lgr_reg_sndbufs(link, smc->conn.sndbuf_desc)) {
+				reason_code = SMC_CLC_DECL_ERR_REGBUF;
+				goto connect_abort;
+			}
+		}
 		if (smcr_lgr_reg_rmbs(link, smc->conn.rmb_desc)) {
-			reason_code = SMC_CLC_DECL_ERR_REGRMB;
+			reason_code = SMC_CLC_DECL_ERR_REGBUF;
 			goto connect_abort;
 		}
 	}
@@ -1749,8 +1786,15 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	struct smc_llc_qentry *qentry;
 	int rc;
 
-	if (smcr_link_reg_rmb(link, smc->conn.rmb_desc))
-		return SMC_CLC_DECL_ERR_REGRMB;
+	/* reg the sndbuf if it was vzalloced*/
+	if (smc->conn.sndbuf_desc->is_vm) {
+		if (smcr_link_reg_buf(link, smc->conn.sndbuf_desc))
+			return SMC_CLC_DECL_ERR_REGBUF;
+	}
+
+	/* reg the rmb */
+	if (smcr_link_reg_buf(link, smc->conn.rmb_desc))
+		return SMC_CLC_DECL_ERR_REGBUF;
 
 	/* send CONFIRM LINK request to client over the RoCE fabric */
 	rc = smc_llc_send_confirm_link(link, SMC_LLC_REQ);
@@ -2109,8 +2153,14 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	struct smc_connection *conn = &new_smc->conn;
 
 	if (!local_first) {
+		/* reg sendbufs if they were vzalloced */
+		if (conn->sndbuf_desc->is_vm) {
+			if (smcr_lgr_reg_sndbufs(conn->lnk,
+						 conn->sndbuf_desc))
+				return SMC_CLC_DECL_ERR_REGBUF;
+		}
 		if (smcr_lgr_reg_rmbs(conn->lnk, conn->rmb_desc))
-			return SMC_CLC_DECL_ERR_REGRMB;
+			return SMC_CLC_DECL_ERR_REGBUF;
 	}
 
 	return 0;
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index f9f3f59..1472f31 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -1034,7 +1034,7 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 		       ETH_ALEN);
 		hton24(clc->r0.qpn, link->roce_qp->qp_num);
 		clc->r0.rmb_rkey =
-			htonl(conn->rmb_desc->mr_rx[link->link_idx]->rkey);
+			htonl(conn->rmb_desc->mr[link->link_idx]->rkey);
 		clc->r0.rmbe_idx = 1; /* for now: 1 RMB = 1 RMBE */
 		clc->r0.rmbe_alert_token = htonl(conn->alert_token_local);
 		switch (clc->hdr.type) {
@@ -1046,8 +1046,10 @@ static int smc_clc_send_confirm_accept(struct smc_sock *smc,
 			break;
 		}
 		clc->r0.rmbe_size = conn->rmbe_size_short;
-		clc->r0.rmb_dma_addr = cpu_to_be64((u64)sg_dma_address
-				(conn->rmb_desc->sgt[link->link_idx].sgl));
+		clc->r0.rmb_dma_addr = conn->rmb_desc->is_vm ?
+			cpu_to_be64((uintptr_t)conn->rmb_desc->cpu_addr) :
+			cpu_to_be64((u64)sg_dma_address
+				    (conn->rmb_desc->sgt[link->link_idx].sgl));
 		hton24(clc->r0.psn, link->psn_initial);
 		if (version == SMC_V1) {
 			clc->hdr.length = htons(SMCR_CLC_ACCEPT_CONFIRM_LEN);
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 83f02f1..5fee545 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -62,7 +62,7 @@
 #define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
 #define SMC_CLC_DECL_ERR_RTOK	0x09990001  /*	 rtoken handling failed       */
 #define SMC_CLC_DECL_ERR_RDYLNK	0x09990002  /*	 ib ready link failed	      */
-#define SMC_CLC_DECL_ERR_REGRMB	0x09990003  /*	 reg rmb failed		      */
+#define SMC_CLC_DECL_ERR_REGBUF	0x09990003  /*	 reg rdma bufs failed	      */
 
 #define SMC_FIRST_CONTACT_MASK	0b10	/* first contact bit within typev2 */
 
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 86afbbc..f26770c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1087,34 +1087,37 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 	return NULL;
 }
 
-static void smcr_buf_unuse(struct smc_buf_desc *rmb_desc,
+static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
 			   struct smc_link_group *lgr)
 {
+	struct mutex *lock;	/* lock buffer list */
 	int rc;
 
-	if (rmb_desc->is_conf_rkey && !list_empty(&lgr->list)) {
+	if (is_rmb && buf_desc->is_conf_rkey && !list_empty(&lgr->list)) {
 		/* unregister rmb with peer */
 		rc = smc_llc_flow_initiate(lgr, SMC_LLC_FLOW_RKEY);
 		if (!rc) {
 			/* protect against smc_llc_cli_rkey_exchange() */
 			mutex_lock(&lgr->llc_conf_mutex);
-			smc_llc_do_delete_rkey(lgr, rmb_desc);
-			rmb_desc->is_conf_rkey = false;
+			smc_llc_do_delete_rkey(lgr, buf_desc);
+			buf_desc->is_conf_rkey = false;
 			mutex_unlock(&lgr->llc_conf_mutex);
 			smc_llc_flow_stop(lgr, &lgr->llc_flow_lcl);
 		}
 	}
 
-	if (rmb_desc->is_reg_err) {
+	if (buf_desc->is_reg_err) {
 		/* buf registration failed, reuse not possible */
-		mutex_lock(&lgr->rmbs_lock);
-		list_del(&rmb_desc->list);
-		mutex_unlock(&lgr->rmbs_lock);
+		lock = is_rmb ? &lgr->rmbs_lock :
+				&lgr->sndbufs_lock;
+		mutex_lock(lock);
+		list_del(&buf_desc->list);
+		mutex_unlock(lock);
 
-		smc_buf_free(lgr, true, rmb_desc);
+		smc_buf_free(lgr, is_rmb, buf_desc);
 	} else {
-		rmb_desc->used = 0;
-		memset(rmb_desc->cpu_addr, 0, rmb_desc->len);
+		buf_desc->used = 0;
+		memset(buf_desc->cpu_addr, 0, buf_desc->len);
 	}
 }
 
@@ -1122,15 +1125,23 @@ static void smc_buf_unuse(struct smc_connection *conn,
 			  struct smc_link_group *lgr)
 {
 	if (conn->sndbuf_desc) {
-		conn->sndbuf_desc->used = 0;
-		memset(conn->sndbuf_desc->cpu_addr, 0, conn->sndbuf_desc->len);
+		if (!lgr->is_smcd && conn->sndbuf_desc->is_vm) {
+			smcr_buf_unuse(conn->sndbuf_desc, false, lgr);
+		} else {
+			conn->sndbuf_desc->used = 0;
+			memset(conn->sndbuf_desc->cpu_addr, 0,
+			       conn->sndbuf_desc->len);
+		}
 	}
-	if (conn->rmb_desc && lgr->is_smcd) {
-		conn->rmb_desc->used = 0;
-		memset(conn->rmb_desc->cpu_addr, 0, conn->rmb_desc->len +
-		       sizeof(struct smcd_cdc_msg));
-	} else if (conn->rmb_desc) {
-		smcr_buf_unuse(conn->rmb_desc, lgr);
+	if (conn->rmb_desc) {
+		if (!lgr->is_smcd) {
+			smcr_buf_unuse(conn->rmb_desc, true, lgr);
+		} else {
+			conn->rmb_desc->used = 0;
+			memset(conn->rmb_desc->cpu_addr, 0,
+			       conn->rmb_desc->len +
+			       sizeof(struct smcd_cdc_msg));
+		}
 	}
 }
 
@@ -1178,20 +1189,21 @@ void smc_conn_free(struct smc_connection *conn)
 static void smcr_buf_unmap_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 				struct smc_link *lnk)
 {
-	if (is_rmb)
+	if (is_rmb || buf_desc->is_vm)
 		buf_desc->is_reg_mr[lnk->link_idx] = false;
 	if (!buf_desc->is_map_ib[lnk->link_idx])
 		return;
-	if (is_rmb) {
-		if (buf_desc->mr_rx[lnk->link_idx]) {
-			smc_ib_put_memory_region(
-					buf_desc->mr_rx[lnk->link_idx]);
-			buf_desc->mr_rx[lnk->link_idx] = NULL;
-		}
+
+	if ((is_rmb || buf_desc->is_vm) &&
+	    buf_desc->mr[lnk->link_idx]) {
+		smc_ib_put_memory_region(buf_desc->mr[lnk->link_idx]);
+		buf_desc->mr[lnk->link_idx] = NULL;
+	}
+	if (is_rmb)
 		smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_FROM_DEVICE);
-	} else {
+	else
 		smc_ib_buf_unmap_sg(lnk, buf_desc, DMA_TO_DEVICE);
-	}
+
 	sg_free_table(&buf_desc->sgt[lnk->link_idx]);
 	buf_desc->is_map_ib[lnk->link_idx] = false;
 }
@@ -1280,8 +1292,10 @@ static void smcr_buf_free(struct smc_link_group *lgr, bool is_rmb,
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++)
 		smcr_buf_unmap_link(buf_desc, is_rmb, &lgr->lnk[i]);
 
-	if (buf_desc->pages)
+	if (!buf_desc->is_vm && buf_desc->pages)
 		__free_pages(buf_desc->pages, buf_desc->order);
+	else if (buf_desc->is_vm && buf_desc->cpu_addr)
+		vfree(buf_desc->cpu_addr);
 	kfree(buf_desc);
 }
 
@@ -1993,26 +2007,50 @@ static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 	return max_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
-/* map an rmb buf to a link */
+/* map an buf to a link */
 static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 			     struct smc_link *lnk)
 {
-	int rc;
+	int rc, i, nents, offset, buf_size, size, access_flags;
+	struct scatterlist *sg;
+	void *buf;
 
 	if (buf_desc->is_map_ib[lnk->link_idx])
 		return 0;
 
-	rc = sg_alloc_table(&buf_desc->sgt[lnk->link_idx], 1, GFP_KERNEL);
+	if (buf_desc->is_vm) {
+		buf = buf_desc->cpu_addr;
+		buf_size = buf_desc->len;
+		offset = offset_in_page(buf_desc->cpu_addr);
+		nents = PAGE_ALIGN(buf_size + offset) / PAGE_SIZE;
+	} else {
+		nents = 1;
+	}
+
+	rc = sg_alloc_table(&buf_desc->sgt[lnk->link_idx], nents, GFP_KERNEL);
 	if (rc)
 		return rc;
-	sg_set_buf(buf_desc->sgt[lnk->link_idx].sgl,
-		   buf_desc->cpu_addr, buf_desc->len);
+
+	if (buf_desc->is_vm) {
+		/* virtually contiguous buffer */
+		for_each_sg(buf_desc->sgt[lnk->link_idx].sgl, sg, nents, i) {
+			size = min_t(int, PAGE_SIZE - offset, buf_size);
+			sg_set_page(sg, vmalloc_to_page(buf), size, offset);
+			buf += size / sizeof(*buf);
+			buf_size -= size;
+			offset = 0;
+		}
+	} else {
+		/* physically contiguous buffer */
+		sg_set_buf(buf_desc->sgt[lnk->link_idx].sgl,
+			   buf_desc->cpu_addr, buf_desc->len);
+	}
 
 	/* map sg table to DMA address */
 	rc = smc_ib_buf_map_sg(lnk, buf_desc,
 			       is_rmb ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	/* SMC protocol depends on mapping to one DMA address only */
-	if (rc != 1) {
+	if (rc != nents) {
 		rc = -EAGAIN;
 		goto free_table;
 	}
@@ -2020,15 +2058,18 @@ static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 	buf_desc->is_dma_need_sync |=
 		smc_ib_is_sg_need_sync(lnk, buf_desc) << lnk->link_idx;
 
-	/* create a new memory region for the RMB */
-	if (is_rmb) {
-		rc = smc_ib_get_memory_region(lnk->roce_pd,
-					      IB_ACCESS_REMOTE_WRITE |
-					      IB_ACCESS_LOCAL_WRITE,
+	if (is_rmb || buf_desc->is_vm) {
+		/* create a new memory region for the RMB or vzalloced sndbuf */
+		access_flags = is_rmb ?
+			       IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
+			       IB_ACCESS_LOCAL_WRITE;
+
+		rc = smc_ib_get_memory_region(lnk->roce_pd, access_flags,
 					      buf_desc, lnk->link_idx);
 		if (rc)
 			goto buf_unmap;
-		smc_ib_sync_sg_for_device(lnk, buf_desc, DMA_FROM_DEVICE);
+		smc_ib_sync_sg_for_device(lnk, buf_desc,
+					  is_rmb ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
 	}
 	buf_desc->is_map_ib[lnk->link_idx] = true;
 	return 0;
@@ -2041,20 +2082,23 @@ static int smcr_buf_map_link(struct smc_buf_desc *buf_desc, bool is_rmb,
 	return rc;
 }
 
-/* register a new rmb on IB device,
+/* register a new buf on IB device, rmb or vzalloced sndbuf
  * must be called under lgr->llc_conf_mutex lock
  */
-int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc)
+int smcr_link_reg_buf(struct smc_link *link, struct smc_buf_desc *buf_desc)
 {
 	if (list_empty(&link->lgr->list))
 		return -ENOLINK;
-	if (!rmb_desc->is_reg_mr[link->link_idx]) {
-		/* register memory region for new rmb */
-		if (smc_wr_reg_send(link, rmb_desc->mr_rx[link->link_idx])) {
-			rmb_desc->is_reg_err = true;
+	if (!buf_desc->is_reg_mr[link->link_idx]) {
+		/* register memory region for new buf */
+		if (buf_desc->is_vm)
+			buf_desc->mr[link->link_idx]->iova =
+				(uintptr_t)buf_desc->cpu_addr;
+		if (smc_wr_reg_send(link, buf_desc->mr[link->link_idx])) {
+			buf_desc->is_reg_err = true;
 			return -EFAULT;
 		}
-		rmb_desc->is_reg_mr[link->link_idx] = true;
+		buf_desc->is_reg_mr[link->link_idx] = true;
 	}
 	return 0;
 }
@@ -2106,18 +2150,38 @@ int smcr_buf_reg_lgr(struct smc_link *lnk)
 	struct smc_buf_desc *buf_desc, *bf;
 	int i, rc = 0;
 
+	/* reg all RMBs for a new link */
 	mutex_lock(&lgr->rmbs_lock);
 	for (i = 0; i < SMC_RMBE_SIZES; i++) {
 		list_for_each_entry_safe(buf_desc, bf, &lgr->rmbs[i], list) {
 			if (!buf_desc->used)
 				continue;
-			rc = smcr_link_reg_rmb(lnk, buf_desc);
-			if (rc)
-				goto out;
+			rc = smcr_link_reg_buf(lnk, buf_desc);
+			if (rc) {
+				mutex_unlock(&lgr->rmbs_lock);
+				return rc;
+			}
 		}
 	}
-out:
 	mutex_unlock(&lgr->rmbs_lock);
+
+	if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
+		return rc;
+
+	/* reg all vzalloced sndbufs for a new link */
+	mutex_lock(&lgr->sndbufs_lock);
+	for (i = 0; i < SMC_RMBE_SIZES; i++) {
+		list_for_each_entry_safe(buf_desc, bf, &lgr->sndbufs[i], list) {
+			if (!buf_desc->used || !buf_desc->is_vm)
+				continue;
+			rc = smcr_link_reg_buf(lnk, buf_desc);
+			if (rc) {
+				mutex_unlock(&lgr->sndbufs_lock);
+				return rc;
+			}
+		}
+	}
+	mutex_unlock(&lgr->sndbufs_lock);
 	return rc;
 }
 
@@ -2131,18 +2195,39 @@ static struct smc_buf_desc *smcr_new_buf_create(struct smc_link_group *lgr,
 	if (!buf_desc)
 		return ERR_PTR(-ENOMEM);
 
-	buf_desc->order = get_order(bufsize);
-	buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
-				      __GFP_NOMEMALLOC | __GFP_COMP |
-				      __GFP_NORETRY | __GFP_ZERO,
-				      buf_desc->order);
-	if (!buf_desc->pages) {
-		kfree(buf_desc);
-		return ERR_PTR(-EAGAIN);
-	}
-	buf_desc->cpu_addr = (void *)page_address(buf_desc->pages);
-	buf_desc->len = bufsize;
+	switch (lgr->buf_type) {
+	case SMCR_PHYS_CONT_BUFS:
+	case SMCR_MIXED_BUFS:
+		buf_desc->order = get_order(bufsize);
+		buf_desc->pages = alloc_pages(GFP_KERNEL | __GFP_NOWARN |
+					      __GFP_NOMEMALLOC | __GFP_COMP |
+					      __GFP_NORETRY | __GFP_ZERO,
+					      buf_desc->order);
+		if (buf_desc->pages) {
+			buf_desc->cpu_addr =
+				(void *)page_address(buf_desc->pages);
+			buf_desc->len = bufsize;
+			buf_desc->is_vm = false;
+			break;
+		}
+		if (lgr->buf_type == SMCR_PHYS_CONT_BUFS)
+			goto out;
+		fallthrough;	// try virtually continguous buf
+	case SMCR_VIRT_CONT_BUFS:
+		buf_desc->order = get_order(bufsize);
+		buf_desc->cpu_addr = vzalloc(PAGE_SIZE << buf_desc->order);
+		if (!buf_desc->cpu_addr)
+			goto out;
+		buf_desc->pages = NULL;
+		buf_desc->len = bufsize;
+		buf_desc->is_vm = true;
+		break;
+	}
 	return buf_desc;
+
+out:
+	kfree(buf_desc);
+	return ERR_PTR(-EAGAIN);
 }
 
 /* map buf_desc on all usable links,
@@ -2273,7 +2358,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 
 	if (!is_smcd) {
 		if (smcr_buf_map_usable_links(lgr, buf_desc, is_rmb)) {
-			smcr_buf_unuse(buf_desc, lgr);
+			smcr_buf_unuse(buf_desc, is_rmb, lgr);
 			return -ENOMEM;
 		}
 	}
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 0261124..fe8b524 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -168,9 +168,11 @@ struct smc_buf_desc {
 		struct { /* SMC-R */
 			struct sg_table	sgt[SMC_LINKS_PER_LGR_MAX];
 					/* virtual buffer */
-			struct ib_mr	*mr_rx[SMC_LINKS_PER_LGR_MAX];
-					/* for rmb only: memory region
+			struct ib_mr	*mr[SMC_LINKS_PER_LGR_MAX];
+					/* memory region: for rmb and
+					 * vzalloced sndbuf
 					 * incl. rkey provided to peer
+					 * and lkey provided to local
 					 */
 			u32		order;	/* allocation order */
 
@@ -183,6 +185,8 @@ struct smc_buf_desc {
 			u8		is_dma_need_sync;
 			u8		is_reg_err;
 					/* buffer registration err */
+			u8		is_vm;
+					/* virtually contiguous */
 		};
 		struct { /* SMC-D */
 			unsigned short	sba_idx;
@@ -543,7 +547,7 @@ void smc_switch_link_and_count(struct smc_connection *conn,
 void smcr_lgr_set_type(struct smc_link_group *lgr, enum smc_lgr_type new_type);
 void smcr_lgr_set_type_asym(struct smc_link_group *lgr,
 			    enum smc_lgr_type new_type, int asym_lnk_idx);
-int smcr_link_reg_rmb(struct smc_link *link, struct smc_buf_desc *rmb_desc);
+int smcr_link_reg_buf(struct smc_link *link, struct smc_buf_desc *rmb_desc);
 struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 				  struct smc_link *from_lnk, bool is_dev_err);
 void smcr_link_down_cond(struct smc_link *lnk);
diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 60e5095..854772d 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -698,7 +698,7 @@ static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot, u8 link_idx)
 	int sg_num;
 
 	/* map the largest prefix of a dma mapped SG list */
-	sg_num = ib_map_mr_sg(buf_slot->mr_rx[link_idx],
+	sg_num = ib_map_mr_sg(buf_slot->mr[link_idx],
 			      buf_slot->sgt[link_idx].sgl,
 			      buf_slot->sgt[link_idx].orig_nents,
 			      &offset, PAGE_SIZE);
@@ -710,20 +710,21 @@ static int smc_ib_map_mr_sg(struct smc_buf_desc *buf_slot, u8 link_idx)
 int smc_ib_get_memory_region(struct ib_pd *pd, int access_flags,
 			     struct smc_buf_desc *buf_slot, u8 link_idx)
 {
-	if (buf_slot->mr_rx[link_idx])
+	if (buf_slot->mr[link_idx])
 		return 0; /* already done */
 
-	buf_slot->mr_rx[link_idx] =
+	buf_slot->mr[link_idx] =
 		ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG, 1 << buf_slot->order);
-	if (IS_ERR(buf_slot->mr_rx[link_idx])) {
+	if (IS_ERR(buf_slot->mr[link_idx])) {
 		int rc;
 
-		rc = PTR_ERR(buf_slot->mr_rx[link_idx]);
-		buf_slot->mr_rx[link_idx] = NULL;
+		rc = PTR_ERR(buf_slot->mr[link_idx]);
+		buf_slot->mr[link_idx] = NULL;
 		return rc;
 	}
 
-	if (smc_ib_map_mr_sg(buf_slot, link_idx) != 1)
+	if (smc_ib_map_mr_sg(buf_slot, link_idx) !=
+			     buf_slot->sgt[link_idx].orig_nents)
 		return -EINVAL;
 
 	return 0;
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index c4d057b..1d83fa9 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -505,19 +505,22 @@ static int smc_llc_send_confirm_rkey(struct smc_link *send_link,
 		if (smc_link_active(link) && link != send_link) {
 			rkeyllc->rtoken[rtok_ix].link_id = link->link_id;
 			rkeyllc->rtoken[rtok_ix].rmb_key =
-				htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
-			rkeyllc->rtoken[rtok_ix].rmb_vaddr = cpu_to_be64(
-				(u64)sg_dma_address(
-					rmb_desc->sgt[link->link_idx].sgl));
+				htonl(rmb_desc->mr[link->link_idx]->rkey);
+			rkeyllc->rtoken[rtok_ix].rmb_vaddr = rmb_desc->is_vm ?
+				cpu_to_be64((uintptr_t)rmb_desc->cpu_addr) :
+				cpu_to_be64((u64)sg_dma_address
+					    (rmb_desc->sgt[link->link_idx].sgl));
 			rtok_ix++;
 		}
 	}
 	/* rkey of send_link is in rtoken[0] */
 	rkeyllc->rtoken[0].num_rkeys = rtok_ix - 1;
 	rkeyllc->rtoken[0].rmb_key =
-		htonl(rmb_desc->mr_rx[send_link->link_idx]->rkey);
-	rkeyllc->rtoken[0].rmb_vaddr = cpu_to_be64(
-		(u64)sg_dma_address(rmb_desc->sgt[send_link->link_idx].sgl));
+		htonl(rmb_desc->mr[send_link->link_idx]->rkey);
+	rkeyllc->rtoken[0].rmb_vaddr = rmb_desc->is_vm ?
+		cpu_to_be64((uintptr_t)rmb_desc->cpu_addr) :
+		cpu_to_be64((u64)sg_dma_address
+			    (rmb_desc->sgt[send_link->link_idx].sgl));
 	/* send llc message */
 	rc = smc_wr_tx_send(send_link, pend);
 put_out:
@@ -544,7 +547,7 @@ static int smc_llc_send_delete_rkey(struct smc_link *link,
 	rkeyllc->hd.common.llc_type = SMC_LLC_DELETE_RKEY;
 	smc_llc_init_msg_hdr(&rkeyllc->hd, link->lgr, sizeof(*rkeyllc));
 	rkeyllc->num_rkeys = 1;
-	rkeyllc->rkey[0] = htonl(rmb_desc->mr_rx[link->link_idx]->rkey);
+	rkeyllc->rkey[0] = htonl(rmb_desc->mr[link->link_idx]->rkey);
 	/* send llc message */
 	rc = smc_wr_tx_send(link, pend);
 put_out:
@@ -614,9 +617,10 @@ static int smc_llc_fill_ext_v2(struct smc_llc_msg_add_link_v2_ext *ext,
 		if (!buf_pos)
 			break;
 		rmb = buf_pos;
-		ext->rt[i].rmb_key = htonl(rmb->mr_rx[prim_lnk_idx]->rkey);
-		ext->rt[i].rmb_key_new = htonl(rmb->mr_rx[lnk_idx]->rkey);
-		ext->rt[i].rmb_vaddr_new =
+		ext->rt[i].rmb_key = htonl(rmb->mr[prim_lnk_idx]->rkey);
+		ext->rt[i].rmb_key_new = htonl(rmb->mr[lnk_idx]->rkey);
+		ext->rt[i].rmb_vaddr_new = rmb->is_vm ?
+			cpu_to_be64((uintptr_t)rmb->cpu_addr) :
 			cpu_to_be64((u64)sg_dma_address(rmb->sgt[lnk_idx].sgl));
 		buf_pos = smc_llc_get_next_rmb(lgr, &buf_lst, buf_pos);
 		while (buf_pos && !(buf_pos)->used)
@@ -852,9 +856,10 @@ static int smc_llc_add_link_cont(struct smc_link *link,
 		}
 		rmb = *buf_pos;
 
-		addc_llc->rt[i].rmb_key = htonl(rmb->mr_rx[prim_lnk_idx]->rkey);
-		addc_llc->rt[i].rmb_key_new = htonl(rmb->mr_rx[lnk_idx]->rkey);
-		addc_llc->rt[i].rmb_vaddr_new =
+		addc_llc->rt[i].rmb_key = htonl(rmb->mr[prim_lnk_idx]->rkey);
+		addc_llc->rt[i].rmb_key_new = htonl(rmb->mr[lnk_idx]->rkey);
+		addc_llc->rt[i].rmb_vaddr_new = rmb->is_vm ?
+			cpu_to_be64((uintptr_t)rmb->cpu_addr) :
 			cpu_to_be64((u64)sg_dma_address(rmb->sgt[lnk_idx].sgl));
 
 		(*num_rkeys_todo)--;
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 00ad004..17c5aee 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -145,35 +145,93 @@ static void smc_rx_spd_release(struct splice_pipe_desc *spd,
 static int smc_rx_splice(struct pipe_inode_info *pipe, char *src, size_t len,
 			 struct smc_sock *smc)
 {
+	struct smc_link_group *lgr = smc->conn.lgr;
+	int offset = offset_in_page(src);
+	struct partial_page *partial;
 	struct splice_pipe_desc spd;
-	struct partial_page partial;
-	struct smc_spd_priv *priv;
-	int bytes;
+	struct smc_spd_priv **priv;
+	struct page **pages;
+	int bytes, nr_pages;
+	int i;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	nr_pages = !lgr->is_smcd && smc->conn.rmb_desc->is_vm ?
+		   PAGE_ALIGN(len + offset) / PAGE_SIZE : 1;
+
+	pages = kcalloc(nr_pages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		goto out;
+	partial = kcalloc(nr_pages, sizeof(*partial), GFP_KERNEL);
+	if (!partial)
+		goto out_page;
+	priv = kcalloc(nr_pages, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
-		return -ENOMEM;
-	priv->len = len;
-	priv->smc = smc;
-	partial.offset = src - (char *)smc->conn.rmb_desc->cpu_addr;
-	partial.len = len;
-	partial.private = (unsigned long)priv;
-
-	spd.nr_pages_max = 1;
-	spd.nr_pages = 1;
-	spd.pages = &smc->conn.rmb_desc->pages;
-	spd.partial = &partial;
+		goto out_part;
+	for (i = 0; i < nr_pages; i++) {
+		priv[i] = kzalloc(sizeof(**priv), GFP_KERNEL);
+		if (!priv[i])
+			goto out_priv;
+	}
+
+	if (lgr->is_smcd ||
+	    (!lgr->is_smcd && !smc->conn.rmb_desc->is_vm)) {
+		/* smcd or smcr that uses physically contiguous RMBs */
+		priv[0]->len = len;
+		priv[0]->smc = smc;
+		partial[0].offset = src - (char *)smc->conn.rmb_desc->cpu_addr;
+		partial[0].len = len;
+		partial[0].private = (unsigned long)priv[0];
+		pages[0] = smc->conn.rmb_desc->pages;
+	} else {
+		int size, left = len;
+		void *buf = src;
+		/* smcr that uses virtually contiguous RMBs*/
+		for (i = 0; i < nr_pages; i++) {
+			size = min_t(int, PAGE_SIZE - offset, left);
+			priv[i]->len = size;
+			priv[i]->smc = smc;
+			pages[i] = vmalloc_to_page(buf);
+			partial[i].offset = offset;
+			partial[i].len = size;
+			partial[i].private = (unsigned long)priv[i];
+			buf += size / sizeof(*buf);
+			left -= size;
+			offset = 0;
+		}
+	}
+	spd.nr_pages_max = nr_pages;
+	spd.nr_pages = nr_pages;
+	spd.pages = pages;
+	spd.partial = partial;
 	spd.ops = &smc_pipe_ops;
 	spd.spd_release = smc_rx_spd_release;
 
 	bytes = splice_to_pipe(pipe, &spd);
 	if (bytes > 0) {
 		sock_hold(&smc->sk);
-		get_page(smc->conn.rmb_desc->pages);
+		if (!lgr->is_smcd && smc->conn.rmb_desc->is_vm) {
+			for (i = 0; i < PAGE_ALIGN(bytes + offset) / PAGE_SIZE; i++)
+				get_page(pages[i]);
+		} else {
+			get_page(smc->conn.rmb_desc->pages);
+		}
 		atomic_add(bytes, &smc->conn.splice_pending);
 	}
+	kfree(priv);
+	kfree(partial);
+	kfree(pages);
 
 	return bytes;
+
+out_priv:
+	for (i = (i - 1); i >= 0; i--)
+		kfree(priv[i]);
+	kfree(priv);
+out_part:
+	kfree(partial);
+out_page:
+	kfree(pages);
+out:
+	return -ENOMEM;
 }
 
 static int smc_rx_data_available_and_no_splice_pend(struct smc_connection *conn)
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index ca0d5f5..4e83776 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -383,6 +383,7 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 
 	dma_addr_t dma_addr =
 		sg_dma_address(conn->sndbuf_desc->sgt[link->link_idx].sgl);
+	u64 virt_addr = (uintptr_t)conn->sndbuf_desc->cpu_addr;
 	int src_len_sum = src_len, dst_len_sum = dst_len;
 	int sent_count = src_off;
 	int srcchunk, dstchunk;
@@ -395,7 +396,7 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 		u64 base_addr = dma_addr;
 
 		if (dst_len < link->qp_attr.cap.max_inline_data) {
-			base_addr = (uintptr_t)conn->sndbuf_desc->cpu_addr;
+			base_addr = virt_addr;
 			wr->wr.send_flags |= IB_SEND_INLINE;
 		} else {
 			wr->wr.send_flags &= ~IB_SEND_INLINE;
@@ -403,8 +404,12 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 
 		num_sges = 0;
 		for (srcchunk = 0; srcchunk < 2; srcchunk++) {
-			sge[srcchunk].addr = base_addr + src_off;
+			sge[srcchunk].addr = conn->sndbuf_desc->is_vm ?
+				(virt_addr + src_off) : (base_addr + src_off);
 			sge[srcchunk].length = src_len;
+			if (conn->sndbuf_desc->is_vm)
+				sge[srcchunk].lkey =
+					conn->sndbuf_desc->mr[link->link_idx]->lkey;
 			num_sges++;
 
 			src_off += src_len;
-- 
1.8.3.1

