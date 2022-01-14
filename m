Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948C448E3F6
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiANFtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:49:00 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49600 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231322AbiANFs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:48:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nD.Lp_1642139336;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nD.Lp_1642139336)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:48:56 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 2/6] net/smc: Prepare for multiple CQs per IB devices
Date:   Fri, 14 Jan 2022 13:48:48 +0800
Message-Id: <20220114054852.38058-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces load of completion vector helper. During setup progress
of IB device, it helps pick up the least used vector of current device.
Only one CQ and two vectors are needed, so it is no practical use right
now. This prepares for multiple CQs support.

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
---
 net/smc/smc_ib.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 net/smc/smc_ib.h |  1 +
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index d1f337522bd5..9a162810ed8c 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -625,6 +625,28 @@ int smcr_nl_get_device(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int smc_ib_get_least_used_vector(struct smc_ib_device *smcibdev)
+{
+	int min = smcibdev->vector_load[0];
+	int i, index = 0;
+
+	/* use it from the beginning of vectors */
+	for (i = 0; i < smcibdev->ibdev->num_comp_vectors; i++) {
+		if (smcibdev->vector_load[i] < min) {
+			index = i;
+			min = smcibdev->vector_load[i];
+		}
+	}
+
+	smcibdev->vector_load[index]++;
+	return index;
+}
+
+static void smc_ib_put_vector(struct smc_ib_device *smcibdev, int index)
+{
+	smcibdev->vector_load[index]--;
+}
+
 static void smc_ib_qp_event_handler(struct ib_event *ibevent, void *priv)
 {
 	struct smc_link *lnk = (struct smc_link *)priv;
@@ -801,8 +823,8 @@ void smc_ib_buf_unmap_sg(struct smc_link *lnk,
 
 long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 {
-	struct ib_cq_init_attr cqattr =	{
-		.cqe = SMC_MAX_CQE, .comp_vector = 0 };
+	struct ib_cq_init_attr cqattr =	{ .cqe = SMC_MAX_CQE };
+	int cq_send_vector, cq_recv_vector;
 	int cqe_size_order, smc_order;
 	long rc;
 
@@ -815,31 +837,35 @@ long smc_ib_setup_per_ibdev(struct smc_ib_device *smcibdev)
 	smc_order = MAX_ORDER - cqe_size_order - 1;
 	if (SMC_MAX_CQE + 2 > (0x00000001 << smc_order) * PAGE_SIZE)
 		cqattr.cqe = (0x00000001 << smc_order) * PAGE_SIZE - 2;
+	cq_send_vector = smc_ib_get_least_used_vector(smcibdev);
+	cqattr.comp_vector = cq_send_vector;
 	smcibdev->roce_cq_send = ib_create_cq(smcibdev->ibdev,
 					      smc_wr_tx_cq_handler, NULL,
 					      smcibdev, &cqattr);
 	rc = PTR_ERR_OR_ZERO(smcibdev->roce_cq_send);
 	if (IS_ERR(smcibdev->roce_cq_send)) {
 		smcibdev->roce_cq_send = NULL;
-		goto out;
+		goto err_send;
 	}
-	/* spread to different completion vector */
-	if (smcibdev->ibdev->num_comp_vectors > 1)
-		cqattr.comp_vector = 1;
+	cq_recv_vector = smc_ib_get_least_used_vector(smcibdev);
+	cqattr.comp_vector = cq_recv_vector;
 	smcibdev->roce_cq_recv = ib_create_cq(smcibdev->ibdev,
 					      smc_wr_rx_cq_handler, NULL,
 					      smcibdev, &cqattr);
 	rc = PTR_ERR_OR_ZERO(smcibdev->roce_cq_recv);
 	if (IS_ERR(smcibdev->roce_cq_recv)) {
 		smcibdev->roce_cq_recv = NULL;
-		goto err;
+		goto err_recv;
 	}
 	smc_wr_add_dev(smcibdev);
 	smcibdev->initialized = 1;
 	goto out;
 
-err:
+err_recv:
+	smc_ib_put_vector(smcibdev, cq_recv_vector);
 	ib_destroy_cq(smcibdev->roce_cq_send);
+err_send:
+	smc_ib_put_vector(smcibdev, cq_send_vector);
 out:
 	mutex_unlock(&smcibdev->mutex);
 	return rc;
@@ -928,6 +954,11 @@ static int smc_ib_add_dev(struct ib_device *ibdev)
 	INIT_IB_EVENT_HANDLER(&smcibdev->event_handler, smcibdev->ibdev,
 			      smc_ib_global_event_handler);
 	ib_register_event_handler(&smcibdev->event_handler);
+	/* vector's load per ib device */
+	smcibdev->vector_load = kcalloc(ibdev->num_comp_vectors,
+					sizeof(int), GFP_KERNEL);
+	if (!smcibdev->vector_load)
+		return -ENOMEM;
 
 	/* trigger reading of the port attributes */
 	port_cnt = smcibdev->ibdev->phys_port_cnt;
@@ -968,6 +999,7 @@ static void smc_ib_remove_dev(struct ib_device *ibdev, void *client_data)
 	smc_ib_cleanup_per_ibdev(smcibdev);
 	ib_unregister_event_handler(&smcibdev->event_handler);
 	cancel_work_sync(&smcibdev->port_event_work);
+	kfree(smcibdev->vector_load);
 	kfree(smcibdev);
 }
 
diff --git a/net/smc/smc_ib.h b/net/smc/smc_ib.h
index 5d8b49c57f50..a748b74e56e6 100644
--- a/net/smc/smc_ib.h
+++ b/net/smc/smc_ib.h
@@ -57,6 +57,7 @@ struct smc_ib_device {				/* ib-device infos for smc */
 	atomic_t		lnk_cnt_by_port[SMC_MAX_PORTS];
 						/* number of links per port */
 	int			ndev_ifidx[SMC_MAX_PORTS]; /* ndev if indexes */
+	int			*vector_load;	/* load of all completion vectors */
 };
 
 static inline __be32 smc_ib_gid_to_ipv4(u8 gid[SMC_GID_SIZE])
-- 
2.32.0.3.g01195cf9f

