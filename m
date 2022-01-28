Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAA849FCAD
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244861AbiA1PTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:19:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240219AbiA1PTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643383180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vz/uNpBYB2ddvYzuSEK+QCIdrdDFGiC4+ty64oFSy+g=;
        b=ANQ1Pj+0ZlXVRB0g7Spwjk7UsFuDAONCb6Vutji8GYh7mT8sYExbi4FHSIh+Wxy41siaJs
        vfd0XdiYFrunNa4LDiqSutz2QsJXOla7M/0Nz48petlHrYv20U+tYDGBwL4lZc8jfknFhF
        ABnE7D7mBeMTEX5imOBteu9erXwZSlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-43uA1Ru1MQevCizNyzga9w-1; Fri, 28 Jan 2022 10:19:39 -0500
X-MC-Unique: 43uA1Ru1MQevCizNyzga9w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29DDC100B7A1;
        Fri, 28 Jan 2022 15:19:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 151F779A19;
        Fri, 28 Jan 2022 15:19:35 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 1/2] sfc: default config to 1 channel/core in local NUMA node only
Date:   Fri, 28 Jan 2022 16:19:21 +0100
Message-Id: <20220128151922.1016841-2-ihuguet@redhat.com>
In-Reply-To: <20220128151922.1016841-1-ihuguet@redhat.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handling channels from CPUs in different NUMA node can penalize
performance, so better configure only one channel per core in the same
NUMA node than the NIC, and not per each core in the system.

Fallback to all other online cores if there are not online CPUs in local
NUMA node.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 50 ++++++++++++++++---------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index ead550ae2709..ec6c2f231e73 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -78,31 +78,48 @@ static const struct efx_channel_type efx_default_channel_type = {
  * INTERRUPTS
  *************/
 
-static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
+static unsigned int count_online_cores(struct efx_nic *efx, bool local_node)
 {
-	cpumask_var_t thread_mask;
+	cpumask_var_t filter_mask;
 	unsigned int count;
 	int cpu;
+
+	if (unlikely(!zalloc_cpumask_var(&filter_mask, GFP_KERNEL))) {
+		netif_warn(efx, probe, efx->net_dev,
+			   "RSS disabled due to allocation failure\n");
+		return 1;
+	}
+
+	cpumask_copy(filter_mask, cpu_online_mask);
+	if (local_node) {
+		int numa_node = pcibus_to_node(efx->pci_dev->bus);
+
+		cpumask_and(filter_mask, filter_mask, cpumask_of_node(numa_node));
+	}
+
+	count = 0;
+	for_each_cpu(cpu, filter_mask) {
+		++count;
+		cpumask_andnot(filter_mask, filter_mask, topology_sibling_cpumask(cpu));
+	}
+
+	free_cpumask_var(filter_mask);
+
+	return count;
+}
+
+static unsigned int efx_wanted_parallelism(struct efx_nic *efx)
+{
+	unsigned int count;
 
 	if (rss_cpus) {
 		count = rss_cpus;
 	} else {
-		if (unlikely(!zalloc_cpumask_var(&thread_mask, GFP_KERNEL))) {
-			netif_warn(efx, probe, efx->net_dev,
-				   "RSS disabled due to allocation failure\n");
-			return 1;
-		}
-
-		count = 0;
-		for_each_online_cpu(cpu) {
-			if (!cpumask_test_cpu(cpu, thread_mask)) {
-				++count;
-				cpumask_or(thread_mask, thread_mask,
-					   topology_sibling_cpumask(cpu));
-			}
-		}
+		count = count_online_cores(efx, true);
 
-		free_cpumask_var(thread_mask);
+		/* If no online CPUs in local node, fallback to any online CPUs */
+		if (count == 0)
+			count = count_online_cores(efx, false);
 	}
 
 	if (count > EFX_MAX_RX_QUEUES) {
-- 
2.31.1

