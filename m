Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22CD5FEC9C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJNKfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJNKfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:35:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05CB2AC65
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 03:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665743701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IGRCqrNr2ZmOSsN+ZXeGJM8vRRz+Pjpq9lX8nmSdxEw=;
        b=Jn7D/XUxSzXJrV5g+144qgcm7rl5eJW8l/343s33w7zAnAn7cgfH2d6f5b8pz0KbOrQiNF
        U8mE5mYqBjQokl7mrPUqTtcCPLdTcqtMvma2UYtF59l5RFggssLJnJe92lMBdV+X/t+bO+
        8SuAmk0CxMhxbhAfcg88nsdmDpVj3ow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-UvAWA_NzOxiPbwVDZ_MGkw-1; Fri, 14 Oct 2022 06:34:53 -0400
X-MC-Unique: UvAWA_NzOxiPbwVDZ_MGkw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 346A929324A3;
        Fri, 14 Oct 2022 10:34:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7858C1121314;
        Fri, 14 Oct 2022 10:34:51 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     irusskikh@marvell.com, dbogdanov@marvell.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Li Liang <liali@redhat.com>
Subject: [PATCH net] atlantic: fix deadlock at aq_nic_stop
Date:   Fri, 14 Oct 2022 12:34:43 +0200
Message-Id: <20221014103443.138574-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIC is stopped with rtnl_lock held, and during the stop it cancels the
'service_task' work and free irqs.

However, if CONFIG_MACSEC is set, rtnl_lock is acquired both from
aq_nic_service_task and aq_linkstate_threaded_isr. Then a deadlock
happens if aq_nic_stop tries to cancel/disable them when they've already
started their execution.

As the deadlock is caused by rtnl_lock, it causes many other processes
to stall, not only atlantic related stuff.

Fix trying to acquire rtnl_lock at the beginning of those functions, and
returning if NIC closing is ongoing. Also do the "linkstate" stuff in a
workqueue instead than in a threaded irq, where sleeping or waiting a
mutex for a long time is discouraged.

The issue appeared repeteadly attaching and deattaching the NIC to a
bond interface. Doing that after this patch I cannot reproduce the bug.

Fixes: 62c1c2e606f6 ("net: atlantic: MACSec offload skeleton")
Reported-by: Li Liang <liali@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 .../ethernet/aquantia/atlantic/aq_macsec.c    |  7 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 59 ++++++++++++++++---
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  1 +
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 3d0e16791e1c..5759eba89db9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1458,7 +1458,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return 0;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 
 	if (nic->aq_fw_ops->send_macsec_req) {
 		struct macsec_cfg_request cfg = { 0 };
@@ -1507,7 +1507,6 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 	ret = aq_apply_macsec_cfg(nic);
 
 unlock:
-	rtnl_unlock();
 	return ret;
 }
 
@@ -1519,9 +1518,9 @@ void aq_macsec_work(struct aq_nic_s *nic)
 	if (!netif_carrier_ok(nic->ndev))
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	aq_check_txsa_expiration(nic);
-	rtnl_unlock();
 }
 
 int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 06508eebb585..5cb7d165dd21 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -40,6 +40,8 @@ static unsigned int aq_itr_rx;
 module_param_named(aq_itr_rx, aq_itr_rx, uint, 0644);
 MODULE_PARM_DESC(aq_itr_rx, "RX interrupt throttle rate");
 
+#define AQ_TASK_RETRY_MS	50
+
 static void aq_nic_update_ndev_stats(struct aq_nic_s *self);
 
 static void aq_nic_rss_init(struct aq_nic_s *self, unsigned int num_rss_queues)
@@ -210,19 +212,41 @@ static int aq_nic_update_link_status(struct aq_nic_s *self)
 	return 0;
 }
 
-static irqreturn_t aq_linkstate_threaded_isr(int irq, void *private)
+static irqreturn_t aq_linkstate_isr(int irq, void *private)
 {
 	struct aq_nic_s *self = private;
 
 	if (!self)
 		return IRQ_NONE;
 
+	if (!aq_utils_obj_test(&self->flags, AQ_NIC_FLAG_CLOSING))
+		aq_ndev_schedule_work(&self->linkstate_task);
+
+	return IRQ_HANDLED;
+}
+
+static void aq_nic_linkstate_task(struct work_struct *work)
+{
+	struct aq_nic_s *self = container_of(work, struct aq_nic_s,
+					     linkstate_task);
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* avoid deadlock at aq_nic_stop -> cancel_work_sync */
+	while (!rtnl_trylock()) {
+		if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAG_CLOSING))
+			return;
+		msleep(AQ_TASK_RETRY_MS);
+	}
+#endif
+
 	aq_nic_update_link_status(self);
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	rtnl_unlock();
+#endif
+
 	self->aq_hw_ops->hw_irq_enable(self->aq_hw,
 				       BIT(self->aq_nic_cfg.link_irq_vec));
-
-	return IRQ_HANDLED;
 }
 
 static void aq_nic_service_task(struct work_struct *work)
@@ -236,12 +260,23 @@ static void aq_nic_service_task(struct work_struct *work)
 	if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAGS_IS_NOT_READY))
 		return;
 
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* avoid deadlock at aq_nic_stop -> cancel_work_sync */
+	while (!rtnl_trylock()) {
+		if (aq_utils_obj_test(&self->flags, AQ_NIC_FLAG_CLOSING))
+			return;
+		msleep(AQ_TASK_RETRY_MS);
+	}
+#endif
+
 	err = aq_nic_update_link_status(self);
 	if (err)
 		return;
 
 #if IS_ENABLED(CONFIG_MACSEC)
 	aq_macsec_work(self);
+
+	rtnl_unlock();
 #endif
 
 	mutex_lock(&self->fwreq_mutex);
@@ -505,6 +540,7 @@ int aq_nic_start(struct aq_nic_s *self)
 	if (err)
 		goto err_exit;
 
+	INIT_WORK(&self->linkstate_task, aq_nic_linkstate_task);
 	INIT_WORK(&self->service_task, aq_nic_service_task);
 
 	timer_setup(&self->service_timer, aq_nic_service_timer_cb, 0);
@@ -531,10 +567,9 @@ int aq_nic_start(struct aq_nic_s *self)
 		if (cfg->link_irq_vec) {
 			int irqvec = pci_irq_vector(self->pdev,
 						    cfg->link_irq_vec);
-			err = request_threaded_irq(irqvec, NULL,
-						   aq_linkstate_threaded_isr,
-						   IRQF_SHARED | IRQF_ONESHOT,
-						   self->ndev->name, self);
+			err = request_irq(irqvec, aq_linkstate_isr,
+					  IRQF_SHARED | IRQF_ONESHOT,
+					  self->ndev->name, self);
 			if (err < 0)
 				goto err_exit;
 			self->msix_entry_mask |= (1 << cfg->link_irq_vec);
@@ -1380,11 +1415,15 @@ int aq_nic_set_loopback(struct aq_nic_s *self)
 int aq_nic_stop(struct aq_nic_s *self)
 {
 	unsigned int i = 0U;
+	int ret;
+
+	aq_utils_obj_set(&self->flags, AQ_NIC_FLAG_CLOSING);
 
 	netif_tx_disable(self->ndev);
 	netif_carrier_off(self->ndev);
 
 	del_timer_sync(&self->service_timer);
+	cancel_work_sync(&self->linkstate_task);
 	cancel_work_sync(&self->service_task);
 
 	self->aq_hw_ops->hw_irq_disable(self->aq_hw, AQ_CFG_IRQ_MASK);
@@ -1401,7 +1440,11 @@ int aq_nic_stop(struct aq_nic_s *self)
 
 	aq_ptp_ring_stop(self);
 
-	return self->aq_hw_ops->hw_stop(self->aq_hw);
+	ret = self->aq_hw_ops->hw_stop(self->aq_hw);
+
+	aq_utils_obj_clear(&self->flags, AQ_NIC_FLAG_CLOSING);
+
+	return ret;
 }
 
 void aq_nic_set_power(struct aq_nic_s *self)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 935ba889bd9a..a114b66990a9 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -140,6 +140,7 @@ struct aq_nic_s {
 	const struct aq_fw_ops *aq_fw_ops;
 	struct aq_nic_cfg_s aq_nic_cfg;
 	struct timer_list service_timer;
+	struct work_struct linkstate_task;
 	struct work_struct service_task;
 	struct timer_list polling_timer;
 	struct aq_hw_link_status_s link_status;
-- 
2.34.1

