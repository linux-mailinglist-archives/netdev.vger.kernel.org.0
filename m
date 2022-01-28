Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E3749FCAE
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244673AbiA1PTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:19:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243841AbiA1PTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:19:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643383187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B8RpAVQIIBcOkJHyEwhaXB4QdE5C2J+jVccyRDXTKM4=;
        b=gAS1oYB/W+PhxySzO20FSiUU0k9Ec6HbJcblV7+byAWhxKeiwZtLIOCinDvXvTTce5y5W2
        5pDObmp3H0kO11IHfSACn9eJG4+JFXvVclcDU460gCXb+r2poWxsLqJLfYdwhPxl33oPsA
        gAvA8IO/SCI0C72RILDrw+bpSQdLcBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-0qt5DCjLMmif97cTAT9tZg-1; Fri, 28 Jan 2022 10:19:41 -0500
X-MC-Unique: 0qt5DCjLMmif97cTAT9tZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62CDF1923E20;
        Fri, 28 Jan 2022 15:19:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8868379A19;
        Fri, 28 Jan 2022 15:19:38 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 2/2] sfc: set affinity hints in local NUMA node only
Date:   Fri, 28 Jan 2022 16:19:22 +0100
Message-Id: <20220128151922.1016841-3-ihuguet@redhat.com>
In-Reply-To: <20220128151922.1016841-1-ihuguet@redhat.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Affinity hints were being set to CPUs in local NUMA node first, and then
in other CPUs. This was creating 2 unintended issues:
1. Channels created to be assigned each to a different physical core
   were assigned to hyperthreading siblings because of being in same
   NUMA node.
   Since the patch previous to this one, this did not longer happen
   with default rss_cpus modparam because less channels are created.
2. XDP channels could be assigned to CPUs in different NUMA nodes,
   decreasing performance too much (to less than half in some of my
   tests).

This patch sets the affinity hints spreading the channels only in local
NUMA node's CPUs. A fallback for the case that no CPU in local NUMA node
is online has been added too.

Example of CPUs being assigned in a non optimal way before this and the
previous patch (note: in this system, xdp-8 to xdp-15 are created
because num_possible_cpus == 64, but num_present_cpus == 32 so they're
never used):

$ lscpu | grep -i numa
NUMA node(s):                    2
NUMA node0 CPU(s):               0-7,16-23
NUMA node1 CPU(s):               8-15,24-31

$ grep -H . /proc/irq/*/0000:07:00.0*/../smp_affinity_list
/proc/irq/141/0000:07:00.0-0/../smp_affinity_list:0
/proc/irq/142/0000:07:00.0-1/../smp_affinity_list:1
/proc/irq/143/0000:07:00.0-2/../smp_affinity_list:2
/proc/irq/144/0000:07:00.0-3/../smp_affinity_list:3
/proc/irq/145/0000:07:00.0-4/../smp_affinity_list:4
/proc/irq/146/0000:07:00.0-5/../smp_affinity_list:5
/proc/irq/147/0000:07:00.0-6/../smp_affinity_list:6
/proc/irq/148/0000:07:00.0-7/../smp_affinity_list:7
/proc/irq/149/0000:07:00.0-8/../smp_affinity_list:16
/proc/irq/150/0000:07:00.0-9/../smp_affinity_list:17
/proc/irq/151/0000:07:00.0-10/../smp_affinity_list:18
/proc/irq/152/0000:07:00.0-11/../smp_affinity_list:19
/proc/irq/153/0000:07:00.0-12/../smp_affinity_list:20
/proc/irq/154/0000:07:00.0-13/../smp_affinity_list:21
/proc/irq/155/0000:07:00.0-14/../smp_affinity_list:22
/proc/irq/156/0000:07:00.0-15/../smp_affinity_list:23
/proc/irq/157/0000:07:00.0-xdp-0/../smp_affinity_list:8
/proc/irq/158/0000:07:00.0-xdp-1/../smp_affinity_list:9
/proc/irq/159/0000:07:00.0-xdp-2/../smp_affinity_list:10
/proc/irq/160/0000:07:00.0-xdp-3/../smp_affinity_list:11
/proc/irq/161/0000:07:00.0-xdp-4/../smp_affinity_list:12
/proc/irq/162/0000:07:00.0-xdp-5/../smp_affinity_list:13
/proc/irq/163/0000:07:00.0-xdp-6/../smp_affinity_list:14
/proc/irq/164/0000:07:00.0-xdp-7/../smp_affinity_list:15
/proc/irq/165/0000:07:00.0-xdp-8/../smp_affinity_list:24
/proc/irq/166/0000:07:00.0-xdp-9/../smp_affinity_list:25
/proc/irq/167/0000:07:00.0-xdp-10/../smp_affinity_list:26
/proc/irq/168/0000:07:00.0-xdp-11/../smp_affinity_list:27
/proc/irq/169/0000:07:00.0-xdp-12/../smp_affinity_list:28
/proc/irq/170/0000:07:00.0-xdp-13/../smp_affinity_list:29
/proc/irq/171/0000:07:00.0-xdp-14/../smp_affinity_list:30
/proc/irq/172/0000:07:00.0-xdp-15/../smp_affinity_list:31

CPUs assignments after this and previous patch, so normal channels
created only one per core in NUMA node and affinities set only to local
NUMA node:

$ grep -H . /proc/irq/*/0000:07:00.0*/../smp_affinity_list
/proc/irq/116/0000:07:00.0-0/../smp_affinity_list:0
/proc/irq/117/0000:07:00.0-1/../smp_affinity_list:1
/proc/irq/118/0000:07:00.0-2/../smp_affinity_list:2
/proc/irq/119/0000:07:00.0-3/../smp_affinity_list:3
/proc/irq/120/0000:07:00.0-4/../smp_affinity_list:4
/proc/irq/121/0000:07:00.0-5/../smp_affinity_list:5
/proc/irq/122/0000:07:00.0-6/../smp_affinity_list:6
/proc/irq/123/0000:07:00.0-7/../smp_affinity_list:7
/proc/irq/124/0000:07:00.0-xdp-0/../smp_affinity_list:16
/proc/irq/125/0000:07:00.0-xdp-1/../smp_affinity_list:17
/proc/irq/126/0000:07:00.0-xdp-2/../smp_affinity_list:18
/proc/irq/127/0000:07:00.0-xdp-3/../smp_affinity_list:19
/proc/irq/128/0000:07:00.0-xdp-4/../smp_affinity_list:20
/proc/irq/129/0000:07:00.0-xdp-5/../smp_affinity_list:21
/proc/irq/130/0000:07:00.0-xdp-6/../smp_affinity_list:22
/proc/irq/131/0000:07:00.0-xdp-7/../smp_affinity_list:23
/proc/irq/132/0000:07:00.0-xdp-8/../smp_affinity_list:0
/proc/irq/133/0000:07:00.0-xdp-9/../smp_affinity_list:1
/proc/irq/134/0000:07:00.0-xdp-10/../smp_affinity_list:2
/proc/irq/135/0000:07:00.0-xdp-11/../smp_affinity_list:3
/proc/irq/136/0000:07:00.0-xdp-12/../smp_affinity_list:4
/proc/irq/137/0000:07:00.0-xdp-13/../smp_affinity_list:5
/proc/irq/138/0000:07:00.0-xdp-14/../smp_affinity_list:6
/proc/irq/139/0000:07:00.0-xdp-15/../smp_affinity_list:7

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index ec6c2f231e73..ef3168fbb5a6 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -387,10 +387,18 @@ void efx_set_interrupt_affinity(struct efx_nic *efx)
 {
 	struct efx_channel *channel;
 	unsigned int cpu;
+	int numa_node = pcibus_to_node(efx->pci_dev->bus);
+	const struct cpumask *numa_mask = cpumask_of_node(numa_node);
 
+	/* If no online CPUs in local node, fallback to any online CPU */
+	if (cpumask_first_and(cpu_online_mask, numa_mask) >= nr_cpu_ids)
+		numa_mask = cpu_online_mask;
+
+	cpu = -1;
 	efx_for_each_channel(channel, efx) {
-		cpu = cpumask_local_spread(channel->channel,
-					   pcibus_to_node(efx->pci_dev->bus));
+		cpu = cpumask_next_and(cpu, cpu_online_mask, numa_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first_and(cpu_online_mask, numa_mask);
 		irq_set_affinity_hint(channel->irq, cpumask_of(cpu));
 	}
 }
-- 
2.31.1

