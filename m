Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C66A31C80A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBPJ0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:26:39 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:48909 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhBPJ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 04:26:26 -0500
X-Originating-IP: 90.55.97.122
Received: from pc-2.home (apoitiers-259-1-26-122.w90-55.abo.wanadoo.fr [90.55.97.122])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 3F7E31BF208;
        Tue, 16 Feb 2021 09:25:41 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH net-next v2 1/2] net: mvneta: Remove per-cpu queue mapping for Armada 3700
Date:   Tue, 16 Feb 2021 10:25:35 +0100
Message-Id: <20210216092536.1153864-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210216092536.1153864-1-maxime.chevallier@bootlin.com>
References: <20210216092536.1153864-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Errata #23 "The per-CPU GbE interrupt is limited to Core
0", we can't use the per-cpu interrupt mechanism on the Armada 3700
familly.

This is correctly checked for RSS configuration, but the initial queue
mapping is still done by having the queues spread across all the CPUs in
the system, both in the init path and in the cpu_hotplug path.

Fixes: 2636ac3cc2b4 ("net: mvneta: Add network support for Armada 3700 SoC")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V2: Added Fixes tag, as per Pali's review

 drivers/net/ethernet/marvell/mvneta.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 6290bfb6494e..8e410fafff8d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3428,7 +3428,9 @@ static int mvneta_txq_sw_init(struct mvneta_port *pp,
 		return -ENOMEM;
 
 	/* Setup XPS mapping */
-	if (txq_number > 1)
+	if (pp->neta_armada3700)
+		cpu = 0;
+	else if (txq_number > 1)
 		cpu = txq->id % num_present_cpus();
 	else
 		cpu = pp->rxq_def % num_present_cpus();
@@ -4206,6 +4208,11 @@ static int mvneta_cpu_online(unsigned int cpu, struct hlist_node *node)
 						  node_online);
 	struct mvneta_pcpu_port *port = per_cpu_ptr(pp->ports, cpu);
 
+	/* Armada 3700's per-cpu interrupt for mvneta is broken, all interrupts
+	 * are routed to CPU 0, so we don't need all the cpu-hotplug support
+	 */
+	if (pp->neta_armada3700)
+		return 0;
 
 	spin_lock(&pp->lock);
 	/*
-- 
2.25.4

