Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E817B53230A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 08:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbiEXGXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 02:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiEXGXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 02:23:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2951A6CAAD
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 23:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653373384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwBFiJ+mQByUdic+uxsFpQ5cj/TD5jsOfPWU+jzv324=;
        b=XM8PUAa0LxDmN67vEmMHePrGCUi6GlEkLnn5j5qXyHlcCVwdTBfVoYfcYh14uvKog2yPA+
        u+tf61krKza0JRp/w/9NbbCC4WsQZ5pa2QbuDT12HoCXxw6lOwkc7xmPImSFGipESt24o/
        1FkwUw7Eqvdz28OtNC/eBMZ73WDGdvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-G_vuWLh9PKOaZVhGK9cRgg-1; Tue, 24 May 2022 02:22:59 -0400
X-MC-Unique: G_vuWLh9PKOaZVhGK9cRgg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E155B803CB8;
        Tue, 24 May 2022 06:22:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D73DC27E8F;
        Tue, 24 May 2022 06:22:57 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next v2 2/2] sfc/siena: simplify mtd partitions list handling
Date:   Tue, 24 May 2022 08:22:43 +0200
Message-Id: <20220524062243.9206-3-ihuguet@redhat.com>
In-Reply-To: <20220524062243.9206-1-ihuguet@redhat.com>
References: <20220524062243.9206-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like in previous patch, get rid of efx->mtd_list and use the allocated
array of efx_mcdi_mtd_partition instead, also in siena.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/siena/efx.h        |  4 +-
 drivers/net/ethernet/sfc/siena/efx_common.c |  3 --
 drivers/net/ethernet/sfc/siena/mtd.c        | 42 ++++++++-------------
 drivers/net/ethernet/sfc/siena/net_driver.h |  9 +++--
 drivers/net/ethernet/sfc/siena/siena.c      | 12 ++++--
 5 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx.h b/drivers/net/ethernet/sfc/siena/efx.h
index 27d1d3f19cae..30ef11dfa7a1 100644
--- a/drivers/net/ethernet/sfc/siena/efx.h
+++ b/drivers/net/ethernet/sfc/siena/efx.h
@@ -163,8 +163,8 @@ void efx_siena_update_sw_stats(struct efx_nic *efx, u64 *stats);
 
 /* MTD */
 #ifdef CONFIG_SFC_SIENA_MTD
-int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
-		      size_t n_parts, size_t sizeof_part);
+int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
+		      size_t n_parts);
 static inline int efx_mtd_probe(struct efx_nic *efx)
 {
 	return efx->type->mtd_probe(efx);
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 954daf464abb..dbf48d682684 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -997,9 +997,6 @@ int efx_siena_init_struct(struct efx_nic *efx,
 	INIT_LIST_HEAD(&efx->node);
 	INIT_LIST_HEAD(&efx->secondary_list);
 	spin_lock_init(&efx->biu_lock);
-#ifdef CONFIG_SFC_SIENA_MTD
-	INIT_LIST_HEAD(&efx->mtd_list);
-#endif
 	INIT_WORK(&efx->reset_work, efx_reset_work);
 	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
 	efx_siena_selftest_async_init(efx);
diff --git a/drivers/net/ethernet/sfc/siena/mtd.c b/drivers/net/ethernet/sfc/siena/mtd.c
index 12a624247f44..d6700822c6fa 100644
--- a/drivers/net/ethernet/sfc/siena/mtd.c
+++ b/drivers/net/ethernet/sfc/siena/mtd.c
@@ -12,6 +12,7 @@
 
 #include "net_driver.h"
 #include "efx.h"
+#include "mcdi.h"
 
 #define to_efx_mtd_partition(mtd)				\
 	container_of(mtd, struct efx_mtd_partition, mtd)
@@ -48,18 +49,16 @@ static void efx_siena_mtd_remove_partition(struct efx_mtd_partition *part)
 		ssleep(1);
 	}
 	WARN_ON(rc);
-	list_del(&part->node);
 }
 
-int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
-		      size_t n_parts, size_t sizeof_part)
+int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
+		      size_t n_parts)
 {
 	struct efx_mtd_partition *part;
 	size_t i;
 
 	for (i = 0; i < n_parts; i++) {
-		part = (struct efx_mtd_partition *)((char *)parts +
-						    i * sizeof_part);
+		part = &parts[i].common;
 
 		part->mtd.writesize = 1;
 
@@ -78,47 +77,38 @@ int efx_siena_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
 
 		if (mtd_device_register(&part->mtd, NULL, 0))
 			goto fail;
-
-		/* Add to list in order - efx_siena_mtd_remove() depends on this */
-		list_add_tail(&part->node, &efx->mtd_list);
 	}
 
 	return 0;
 
 fail:
-	while (i--) {
-		part = (struct efx_mtd_partition *)((char *)parts +
-						    i * sizeof_part);
-		efx_siena_mtd_remove_partition(part);
-	}
+	while (i--)
+		efx_siena_mtd_remove_partition(&parts[i].common);
+
 	/* Failure is unlikely here, but probably means we're out of memory */
 	return -ENOMEM;
 }
 
 void efx_siena_mtd_remove(struct efx_nic *efx)
 {
-	struct efx_mtd_partition *parts, *part, *next;
+	int i;
 
 	WARN_ON(efx_dev_registered(efx));
 
-	if (list_empty(&efx->mtd_list))
-		return;
-
-	parts = list_first_entry(&efx->mtd_list, struct efx_mtd_partition,
-				 node);
+	for (i = 0; i < efx->n_mcdi_mtd_parts; i++)
+		efx_siena_mtd_remove_partition(&efx->mcdi_mtd_parts[i].common);
 
-	list_for_each_entry_safe(part, next, &efx->mtd_list, node)
-		efx_siena_mtd_remove_partition(part);
-
-	kfree(parts);
+	kfree(efx->mcdi_mtd_parts);
+	efx->mcdi_mtd_parts = NULL;
+	efx->n_mcdi_mtd_parts = 0;
 }
 
 void efx_siena_mtd_rename(struct efx_nic *efx)
 {
-	struct efx_mtd_partition *part;
+	int i;
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(part, &efx->mtd_list, node)
-		efx->type->mtd_rename(part);
+	for (i = 0; i < efx->n_mcdi_mtd_parts; i++)
+		efx->type->mtd_rename(&efx->mcdi_mtd_parts[i].common);
 }
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index a8f6c3699c8b..4c614f079359 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -107,6 +107,8 @@ struct hwtstamp_config;
 
 struct efx_self_tests;
 
+struct efx_mcdi_mtd_partition;
+
 /**
  * struct efx_buffer - A general-purpose DMA buffer
  * @addr: host base address of the buffer
@@ -864,7 +866,8 @@ enum efx_xdp_tx_queues_mode {
  * @irq_zero_count: Number of legacy IRQs seen with queue flags == 0
  * @irq_level: IRQ level/index for IRQs not triggered by an event queue
  * @selftest_work: Work item for asynchronous self-test
- * @mtd_list: List of MTDs attached to the NIC
+ * @mcdi_mtd_parts: Array of MTDs attached to the NIC
+ * @n_mcdi_mtd_parts: Number of MTDs attached to the NIC
  * @nic_data: Hardware dependent state
  * @mcdi: Management-Controller-to-Driver Interface state
  * @mac_lock: MAC access lock. Protects @port_enabled, @phy_mode,
@@ -1032,7 +1035,8 @@ struct efx_nic {
 	struct delayed_work selftest_work;
 
 #ifdef CONFIG_SFC_SIENA_MTD
-	struct list_head mtd_list;
+	struct efx_mcdi_mtd_partition *mcdi_mtd_parts;
+	unsigned int n_mcdi_mtd_parts;
 #endif
 
 	void *nic_data;
@@ -1133,7 +1137,6 @@ static inline unsigned int efx_port_num(struct efx_nic *efx)
 }
 
 struct efx_mtd_partition {
-	struct list_head node;
 	struct mtd_info mtd;
 	const char *dev_type_name;
 	const char *type_name;
diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ethernet/sfc/siena/siena.c
index a44c8fa25748..c9431955792e 100644
--- a/drivers/net/ethernet/sfc/siena/siena.c
+++ b/drivers/net/ethernet/sfc/siena/siena.c
@@ -947,10 +947,16 @@ static int siena_mtd_probe(struct efx_nic *efx)
 	if (rc)
 		goto fail;
 
-	rc = efx_siena_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
-fail:
+	rc = efx_siena_mtd_add(efx, parts, n_parts);
 	if (rc)
-		kfree(parts);
+		goto fail;
+	efx->mcdi_mtd_parts = parts;
+	efx->n_mcdi_mtd_parts = n_parts;
+
+	return 0;
+
+fail:
+	kfree(parts);
 	return rc;
 }
 
-- 
2.34.1

