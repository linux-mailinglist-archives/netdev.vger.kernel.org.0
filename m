Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23031DE2B6
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgEVJMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:41 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6888 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729719AbgEVJMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138757; x=1621674757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=p4KxdzwvrXe5XV5FTxNlOlaNjNP74Ax9I9QEYiGiajU=;
  b=kQZHvPWYGqptjulZ2zKFn8PUpn2OKcfs2da665D3Y2YQ2kgHc3PaU6oL
   bJantvy96mlnKtLs2bdyl0P6WhiJzCEBd7T14gkFaseDEhucWxrHtjS9L
   yATDSK8TLwa2zP8xkMefVoDmXCzE81uu8FKrjB6C8lmCC6y2dCiqGdnEu
   M=;
IronPort-SDR: rkAtFw65TT+uGKEGiawkBaLhlpVSUgixi2HEtBRr3WoXzmIbgCZJAXfR5LxNwiodVGSuOkoNjF
 dLuUKSFJ+d8g==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="31626278"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 May 2020 09:12:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id B9352A2866;
        Fri, 22 May 2020 09:12:36 +0000 (UTC)
Received: from EX13D10UWB002.ant.amazon.com (10.43.161.130) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB002.ant.amazon.com (10.43.161.130) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:20 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:12:16 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH V2 net-next 14/14] net: ena: reduce driver load time
Date:   Fri, 22 May 2020 12:09:05 +0300
Message-ID: <1590138545-501-15-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This commit reduces the driver load time by using usec resolution
instead of msec when polling for hardware state change.

Also add back-off mechanism to handle cases where minimal sleep
time is not enough.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    | 36 ++++++++++++++------
 drivers/net/ethernet/amazon/ena/ena_com.h    |  3 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.c |  2 ++
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  2 ++
 4 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 4b1dbedbe921..432f143559a1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -62,7 +62,9 @@
 
 #define ENA_REGS_ADMIN_INTR_MASK 1
 
-#define ENA_POLL_MS	5
+#define ENA_MIN_ADMIN_POLL_US 100
+
+#define ENA_MAX_ADMIN_POLL_US 5000
 
 /*****************************************************************************/
 /*****************************************************************************/
@@ -540,12 +542,20 @@ static int ena_com_comp_status_to_errno(u8 comp_status)
 	return -EINVAL;
 }
 
+static void ena_delay_exponential_backoff_us(u32 exp, u32 delay_us)
+{
+	delay_us = max_t(u32, ENA_MIN_ADMIN_POLL_US, delay_us);
+	delay_us = min_t(u32, delay_us * (1U << exp), ENA_MAX_ADMIN_POLL_US);
+	usleep_range(delay_us, 2 * delay_us);
+}
+
 static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_ctx,
 						     struct ena_com_admin_queue *admin_queue)
 {
 	unsigned long flags = 0;
 	unsigned long timeout;
 	int ret;
+	u32 exp = 0;
 
 	timeout = jiffies + usecs_to_jiffies(admin_queue->completion_timeout);
 
@@ -569,7 +579,8 @@ static int ena_com_wait_and_process_admin_cq_polling(struct ena_comp_ctx *comp_c
 			goto err;
 		}
 
-		msleep(ENA_POLL_MS);
+		ena_delay_exponential_backoff_us(exp++,
+						 admin_queue->ena_dev->ena_min_poll_delay_us);
 	}
 
 	if (unlikely(comp_ctx->status == ENA_CMD_ABORTED)) {
@@ -939,12 +950,13 @@ static void ena_com_io_queue_free(struct ena_com_dev *ena_dev,
 static int wait_for_reset_state(struct ena_com_dev *ena_dev, u32 timeout,
 				u16 exp_state)
 {
-	u32 val, i;
+	u32 val, exp = 0;
+	unsigned long timeout_stamp;
 
-	/* Convert timeout from resolution of 100ms to ENA_POLL_MS */
-	timeout = (timeout * 100) / ENA_POLL_MS;
+	/* Convert timeout from resolution of 100ms to us resolution. */
+	timeout_stamp = jiffies + usecs_to_jiffies(100 * 1000 * timeout);
 
-	for (i = 0; i < timeout; i++) {
+	while (1) {
 		val = ena_com_reg_bar_read32(ena_dev, ENA_REGS_DEV_STS_OFF);
 
 		if (unlikely(val == ENA_MMIO_READ_TIMEOUT)) {
@@ -956,10 +968,11 @@ static int wait_for_reset_state(struct ena_com_dev *ena_dev, u32 timeout,
 			exp_state)
 			return 0;
 
-		msleep(ENA_POLL_MS);
-	}
+		if (time_is_before_jiffies(timeout_stamp))
+			return -ETIME;
 
-	return -ETIME;
+		ena_delay_exponential_backoff_us(exp++, ena_dev->ena_min_poll_delay_us);
+	}
 }
 
 static bool ena_com_check_supported_feature_id(struct ena_com_dev *ena_dev,
@@ -1436,11 +1449,13 @@ void ena_com_wait_for_abort_completion(struct ena_com_dev *ena_dev)
 {
 	struct ena_com_admin_queue *admin_queue = &ena_dev->admin_queue;
 	unsigned long flags = 0;
+	u32 exp = 0;
 
 	spin_lock_irqsave(&admin_queue->q_lock, flags);
 	while (atomic_read(&admin_queue->outstanding_cmds) != 0) {
 		spin_unlock_irqrestore(&admin_queue->q_lock, flags);
-		msleep(ENA_POLL_MS);
+		ena_delay_exponential_backoff_us(exp++,
+						 ena_dev->ena_min_poll_delay_us);
 		spin_lock_irqsave(&admin_queue->q_lock, flags);
 	}
 	spin_unlock_irqrestore(&admin_queue->q_lock, flags);
@@ -1788,6 +1803,7 @@ int ena_com_admin_init(struct ena_com_dev *ena_dev,
 	if (ret)
 		goto error;
 
+	admin_queue->ena_dev = ena_dev;
 	admin_queue->running_state = true;
 
 	return 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 325c9a5f677b..bc187adf54e4 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -239,6 +239,7 @@ struct ena_com_stats_admin {
 
 struct ena_com_admin_queue {
 	void *q_dmadev;
+	struct ena_com_dev *ena_dev;
 	spinlock_t q_lock; /* spinlock for the admin queue */
 
 	struct ena_comp_ctx *comp_ctx;
@@ -351,6 +352,8 @@ struct ena_com_dev {
 	struct ena_intr_moder_entry *intr_moder_tbl;
 
 	struct ena_com_llq_info llq_info;
+
+	u32 ena_min_poll_delay_us;
 };
 
 struct ena_com_dev_get_features_ctx {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 313e65b17492..46865d5bd7e7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4166,6 +4166,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_free_region;
 	}
 
+	ena_dev->ena_min_poll_delay_us = ENA_ADMIN_POLL_DELAY_US;
+
 	ena_dev->dmadev = &pdev->dev;
 
 	rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 9b3948c7e8a0..ba030d260940 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -129,6 +129,8 @@
 #define ENA_IO_IRQ_FIRST_IDX		1
 #define ENA_IO_IRQ_IDX(q)		(ENA_IO_IRQ_FIRST_IDX + (q))
 
+#define ENA_ADMIN_POLL_DELAY_US 100
+
 /* ENA device should send keep alive msg every 1 sec.
  * We wait for 6 sec just to be on the safe side.
  */
-- 
2.23.1

