Return-Path: <netdev+bounces-10057-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2488A72BCDB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E8A41C20979
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F8717AA3;
	Mon, 12 Jun 2023 09:40:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E656C18AE1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:40:06 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8991701;
	Mon, 12 Jun 2023 02:40:04 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35C9dboI046777;
	Mon, 12 Jun 2023 04:39:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1686562777;
	bh=AGy91cg2bUq6lI9pwR/1/BuzfRyl0z5flNLxgO6J+zw=;
	h=From:To:CC:Subject:Date;
	b=IYZbNIUhxGX3LPKfl9SuBYExmgHOzQ7bQub5g0W+DMs4V1olvPjICgYT5eS04mx1F
	 Qv+Xofq3meea7Bkr+rEd6Ib2p5cX84bFp7yJPcNNS1Hc+Q67cy01gjqiKleqNmtITJ
	 GkVIi5FkMZyklViEd77ij3M4/5w1G0m0bGVgkpJ4=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35C9dbHu012876
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Jun 2023 04:39:37 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 12
 Jun 2023 04:39:37 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 12 Jun 2023 04:39:37 -0500
Received: from uda0500640.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35C9dXBJ021977;
	Mon, 12 Jun 2023 04:39:34 -0500
From: Ravi Gunasekaran <r-gunasekaran@ti.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bigeasy@linutronix.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rogerq@kernel.org>, <r-gunasekaran@ti.com>
Subject: [PATCH] net: hsr: Disable promiscuous mode in offload mode
Date: Mon, 12 Jun 2023 15:09:33 +0530
Message-ID: <20230612093933.13267-1-r-gunasekaran@ti.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When port-to-port forwarding for interfaces in HSR node is enabled,
disable promiscuous mode since L2 frame forward happens at the
offloaded hardware.

Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
---
 net/hsr/hsr_device.c |  5 +++++
 net/hsr/hsr_main.h   |  1 +
 net/hsr/hsr_slave.c  | 15 +++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 5a236aae2366..306f942c3b28 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -531,6 +531,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	if (res)
 		goto err_add_master;
 
+	/* HSR forwarding offload supported in lower device? */
+	if ((slave[0]->features & NETIF_F_HW_HSR_FWD) &&
+	    (slave[1]->features & NETIF_F_HW_HSR_FWD))
+		hsr->fwd_offloaded = true;
+
 	res = register_netdevice(hsr_dev);
 	if (res)
 		goto err_unregister;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 5584c80a5c79..0225fabbe6d1 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -195,6 +195,7 @@ struct hsr_priv {
 	struct hsr_self_node	__rcu *self_node;	/* MACs of slaves */
 	struct timer_list	announce_timer;	/* Supervision frame dispatch */
 	struct timer_list	prune_timer;
+	unsigned int            fwd_offloaded : 1; /* Forwarding offloaded to HW */
 	int announce_count;
 	u16 sequence_nr;
 	u16 sup_sequence_nr;	/* For HSRv1 separate seq_nr for supervision */
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index b70e6bbf6021..e5742f2a2d52 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -131,9 +131,14 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 	struct hsr_port *master;
 	int res;
 
-	res = dev_set_promiscuity(dev, 1);
-	if (res)
-		return res;
+	/* Don't use promiscuous mode for offload since L2 frame forward
+	 * happens at the offloaded hardware.
+	 */
+	if (!port->hsr->fwd_offloaded) {
+		res = dev_set_promiscuity(dev, 1);
+		if (res)
+			return res;
+	}
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	hsr_dev = master->dev;
@@ -152,7 +157,9 @@ static int hsr_portdev_setup(struct hsr_priv *hsr, struct net_device *dev,
 fail_rx_handler:
 	netdev_upper_dev_unlink(dev, hsr_dev);
 fail_upper_dev_link:
-	dev_set_promiscuity(dev, -1);
+	if (!port->hsr->fwd_offloaded)
+		dev_set_promiscuity(dev, -1);
+
 	return res;
 }
 
-- 
2.17.1


