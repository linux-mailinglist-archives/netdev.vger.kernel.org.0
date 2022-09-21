Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8A25BFDF3
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiIUMcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiIUMce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:32:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38A1844D9;
        Wed, 21 Sep 2022 05:32:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXd3T3BPFzMnkq;
        Wed, 21 Sep 2022 20:27:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 20:32:30 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH -next, v3 10/10] net: hinic: remove the unused input parameter prod_idx in sq_prepare_ctrl()
Date:   Wed, 21 Sep 2022 20:33:58 +0800
Message-ID: <20220921123358.63442-11-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220921123358.63442-1-shaozhengchao@huawei.com>
References: <20220921123358.63442-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The input parameter prod_idx is not used in sq_prepare_ctrl(), remove it.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c | 11 ++++-------
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h |  5 ++---
 drivers/net/ethernet/huawei/hinic/hinic_tx.c    |  4 ++--
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
index 336248aa2e48..537a8098bc4e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
@@ -472,8 +472,7 @@ int hinic_get_rq_free_wqebbs(struct hinic_rq *rq)
 	return atomic_read(&wq->delta) - 1;
 }
 
-static void sq_prepare_ctrl(struct hinic_sq_ctrl *ctrl, u16 prod_idx,
-			    int nr_descs)
+static void sq_prepare_ctrl(struct hinic_sq_ctrl *ctrl, int nr_descs)
 {
 	u32 ctrl_size, task_size, bufdesc_size;
 
@@ -588,18 +587,16 @@ void hinic_set_tso_inner_l4(struct hinic_sq_task *task, u32 *queue_info,
 /**
  * hinic_sq_prepare_wqe - prepare wqe before insert to the queue
  * @sq: send queue
- * @prod_idx: pi value
  * @sq_wqe: wqe to prepare
  * @sges: sges for use by the wqe for send for buf addresses
  * @nr_sges: number of sges
  **/
-void hinic_sq_prepare_wqe(struct hinic_sq *sq, u16 prod_idx,
-			  struct hinic_sq_wqe *sq_wqe, struct hinic_sge *sges,
-			  int nr_sges)
+void hinic_sq_prepare_wqe(struct hinic_sq *sq, struct hinic_sq_wqe *sq_wqe,
+			  struct hinic_sge *sges, int nr_sges)
 {
 	int i;
 
-	sq_prepare_ctrl(&sq_wqe->ctrl, prod_idx, nr_sges);
+	sq_prepare_ctrl(&sq_wqe->ctrl, nr_sges);
 
 	sq_prepare_task(&sq_wqe->task);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
index 0dfa51ad5855..178dcc874370 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -175,9 +175,8 @@ void hinic_set_tso_inner_l4(struct hinic_sq_task *task,
 			    u32 l4_len,
 			    u32 offset, u32 ip_ident, u32 mss);
 
-void hinic_sq_prepare_wqe(struct hinic_sq *sq, u16 prod_idx,
-			  struct hinic_sq_wqe *wqe, struct hinic_sge *sges,
-			  int nr_sges);
+void hinic_sq_prepare_wqe(struct hinic_sq *sq, struct hinic_sq_wqe *wqe,
+			  struct hinic_sge *sges, int nr_sges);
 
 void hinic_sq_write_db(struct hinic_sq *sq, u16 prod_idx, unsigned int wqe_size,
 		       unsigned int cos);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 7f9d32860895..e91476c8ff8b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -530,7 +530,7 @@ netdev_tx_t hinic_lb_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 process_sq_wqe:
-	hinic_sq_prepare_wqe(txq->sq, prod_idx, sq_wqe, txq->sges, nr_sges);
+	hinic_sq_prepare_wqe(txq->sq, sq_wqe, txq->sges, nr_sges);
 	hinic_sq_write_wqe(txq->sq, prod_idx, sq_wqe, skb, wqe_size);
 
 flush_skbs:
@@ -614,7 +614,7 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	}
 
 process_sq_wqe:
-	hinic_sq_prepare_wqe(txq->sq, prod_idx, sq_wqe, txq->sges, nr_sges);
+	hinic_sq_prepare_wqe(txq->sq, sq_wqe, txq->sges, nr_sges);
 
 	err = hinic_tx_offload(skb, &sq_wqe->task, &sq_wqe->ctrl.queue_info);
 	if (err)
-- 
2.17.1

