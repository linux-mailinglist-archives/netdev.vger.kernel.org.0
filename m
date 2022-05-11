Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72525230C1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237886AbiEKKgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbiEKKgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:36:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 696682DD52
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652265380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ltrgVcSj8ZxhX557DX5Q3ZlR5arxa/6ASLwGBFui2Cw=;
        b=NUobbuPauxcko6UOMboH7oPx/YYjtEjTM+7DwbBj/AExI6zQZkrq5F8R/vXyNipQhjEbyX
        29ioQ5WFk9DK0aLQ5hMfeluAiEb7JYBO+BnMCX7eaU4c2NEi/+/nn8/IHaNl3qMC6i1dIT
        eDYqgqCE6luKpPufQZ2TGLuexZLCSF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-PVuWkMPFP5qJptGNDc3-Xw-1; Wed, 11 May 2022 06:36:15 -0400
X-MC-Unique: PVuWkMPFP5qJptGNDc3-Xw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE8D58047D6;
        Wed, 11 May 2022 10:36:14 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67AF4400E436;
        Wed, 11 May 2022 10:36:12 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        bhutchings@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 2/2] sfc: simplify mtd partitions list handling
Date:   Wed, 11 May 2022 12:36:04 +0200
Message-Id: <20220511103604.37962-3-ihuguet@redhat.com>
In-Reply-To: <20220511103604.37962-1-ihuguet@redhat.com>
References: <20220511103604.37962-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

efx_mtd_partitions are embedded inside efx_mcdi_mtd_partition structs.
They contain a list entry that is appended to efx->mtd_list, which is
traversed to perform add/remove/rename/etc operations over all
efx_mtd_partitions.

However, almost all operations done on a efx_mtd_partition asume that it
is actually embedded inside an efx_mcdi_mtd_partition, and the
deallocation asume that the first member of the list is located at the
beginning of the allocated memory.

Given all that asumptions, the possibility of having an
efx_mtd_partition not embedded in an efx_mcdi_efx_partition doesn't
exist. Neither it does the possibility of being in a memory position
other the one allocated for the efx_mcdi_mtd_partition array. Also, they
never need to be reordered.

Given all that, it is better to get rid of the list and use directly the
efx_mcdi_mtd_partition array. This shows more clearly how they lay
in memory, list traversal is more obvious and it save a small amount
of memory on the list nodes.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 12 ++++++--
 drivers/net/ethernet/sfc/efx.h        |  4 +--
 drivers/net/ethernet/sfc/efx_common.c |  3 --
 drivers/net/ethernet/sfc/mtd.c        | 42 ++++++++++-----------------
 drivers/net/ethernet/sfc/net_driver.h |  9 ++++--
 5 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 15a229731296..b5284fa529b7 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3584,10 +3584,16 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 		return 0;
 	}
 
-	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
-fail:
+	rc = efx_mtd_add(efx, parts, n_parts);
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
 
diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index c05a83da9e44..2ab9ba691b0d 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -181,8 +181,8 @@ void efx_update_sw_stats(struct efx_nic *efx, u64 *stats);
 
 /* MTD */
 #ifdef CONFIG_SFC_MTD
-int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
-		size_t n_parts, size_t sizeof_part);
+int efx_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
+		size_t n_parts);
 static inline int efx_mtd_probe(struct efx_nic *efx)
 {
 	return efx->type->mtd_probe(efx);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f6577e74d6e6..8802790403e9 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -987,9 +987,6 @@ int efx_init_struct(struct efx_nic *efx,
 	INIT_LIST_HEAD(&efx->node);
 	INIT_LIST_HEAD(&efx->secondary_list);
 	spin_lock_init(&efx->biu_lock);
-#ifdef CONFIG_SFC_MTD
-	INIT_LIST_HEAD(&efx->mtd_list);
-#endif
 	INIT_WORK(&efx->reset_work, efx_reset_work);
 	INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
 	efx_selftest_async_init(efx);
diff --git a/drivers/net/ethernet/sfc/mtd.c b/drivers/net/ethernet/sfc/mtd.c
index 273c08e5455f..4d06e8a9a729 100644
--- a/drivers/net/ethernet/sfc/mtd.c
+++ b/drivers/net/ethernet/sfc/mtd.c
@@ -12,6 +12,7 @@
 
 #include "net_driver.h"
 #include "efx.h"
+#include "mcdi.h"
 
 #define to_efx_mtd_partition(mtd)				\
 	container_of(mtd, struct efx_mtd_partition, mtd)
@@ -48,18 +49,16 @@ static void efx_mtd_remove_partition(struct efx_mtd_partition *part)
 		ssleep(1);
 	}
 	WARN_ON(rc);
-	list_del(&part->node);
 }
 
-int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
-		size_t n_parts, size_t sizeof_part)
+int efx_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *parts,
+		size_t n_parts)
 {
 	struct efx_mtd_partition *part;
 	size_t i;
 
 	for (i = 0; i < n_parts; i++) {
-		part = (struct efx_mtd_partition *)((char *)parts +
-						    i * sizeof_part);
+		part = &parts[i].common;
 
 		part->mtd.writesize = 1;
 
@@ -78,47 +77,38 @@ int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
 
 		if (mtd_device_register(&part->mtd, NULL, 0))
 			goto fail;
-
-		/* Add to list in order - efx_mtd_remove() depends on this */
-		list_add_tail(&part->node, &efx->mtd_list);
 	}
 
 	return 0;
 
 fail:
-	while (i--) {
-		part = (struct efx_mtd_partition *)((char *)parts +
-						    i * sizeof_part);
-		efx_mtd_remove_partition(part);
-	}
+	while (i--)
+		efx_mtd_remove_partition(&parts[i].common);
+
 	/* Failure is unlikely here, but probably means we're out of memory */
 	return -ENOMEM;
 }
 
 void efx_mtd_remove(struct efx_nic *efx)
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
+		efx_mtd_remove_partition(&efx->mcdi_mtd_parts[i].common);
 
-	list_for_each_entry_safe(part, next, &efx->mtd_list, node)
-		efx_mtd_remove_partition(part);
-
-	kfree(parts);
+	kfree(efx->mcdi_mtd_parts);
+	efx->mcdi_mtd_parts = NULL;
+	efx->n_mcdi_mtd_parts = 0;
 }
 
 void efx_mtd_rename(struct efx_nic *efx)
 {
-	struct efx_mtd_partition *part;
+	int i;
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(part, &efx->mtd_list, node)
-		efx->type->mtd_rename(part);
+	for (i = 0; i < efx->n_mcdi_mtd_parts; i++)
+		efx->type->mtd_rename(&efx->mcdi_mtd_parts[i].common);
 }
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 318db906a154..5d20b25b0e82 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -107,6 +107,8 @@ struct hwtstamp_config;
 
 struct efx_self_tests;
 
+struct efx_mcdi_mtd_partition;
+
 /**
  * struct efx_buffer - A general-purpose DMA buffer
  * @addr: host base address of the buffer
@@ -865,7 +867,8 @@ enum efx_xdp_tx_queues_mode {
  * @irq_zero_count: Number of legacy IRQs seen with queue flags == 0
  * @irq_level: IRQ level/index for IRQs not triggered by an event queue
  * @selftest_work: Work item for asynchronous self-test
- * @mtd_list: List of MTDs attached to the NIC
+ * @mcdi_mtd_parts: Array of MTDs attached to the NIC
+ * @n_mcdi_mtd_parts: Number of MTDs attached to the NIC
  * @nic_data: Hardware dependent state
  * @mcdi: Management-Controller-to-Driver Interface state
  * @mac_lock: MAC access lock. Protects @port_enabled, @phy_mode,
@@ -1033,7 +1036,8 @@ struct efx_nic {
 	struct delayed_work selftest_work;
 
 #ifdef CONFIG_SFC_MTD
-	struct list_head mtd_list;
+	struct efx_mcdi_mtd_partition *mcdi_mtd_parts;
+	unsigned int n_mcdi_mtd_parts;
 #endif
 
 	void *nic_data;
@@ -1134,7 +1138,6 @@ static inline unsigned int efx_port_num(struct efx_nic *efx)
 }
 
 struct efx_mtd_partition {
-	struct list_head node;
 	struct mtd_info mtd;
 	const char *dev_type_name;
 	const char *type_name;
-- 
2.34.1

