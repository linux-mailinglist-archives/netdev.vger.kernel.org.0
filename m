Return-Path: <netdev+bounces-10691-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 328A772FD5A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B48E2813AF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB62D847E;
	Wed, 14 Jun 2023 11:47:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D37476
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:47:33 +0000 (UTC)
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A769510D8;
	Wed, 14 Jun 2023 04:47:26 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35EBlE1E109706;
	Wed, 14 Jun 2023 06:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1686743234;
	bh=sA/wHQWGukp8xdptR9h0VboCMWUkFR4POYrWrCGHCeE=;
	h=From:To:CC:Subject:Date;
	b=aiOCextLJUKAYz8Ee3M6kzNTrmzmiNHam9Dn6cIopUZoWQot4zqGloswc3fGqZaX+
	 LbQSLiJO1EC0FYN3KX3uUrOzl+a5CzeOYhoP+Ym/hKPFgD178Ax/L/vqlLue456MUI
	 +i1ZFjEHWbVimurcW1nUH0U5adayfHdxWUZ0nRIo=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35EBlEvP110320
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Jun 2023 06:47:14 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 14
 Jun 2023 06:47:14 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 14 Jun 2023 06:47:14 -0500
Received: from uda0500640.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35EBlA24044618;
	Wed, 14 Jun 2023 06:47:11 -0500
From: Ravi Gunasekaran <r-gunasekaran@ti.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bigeasy@linutronix.de>,
        <simon.horman@corigine.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rogerq@kernel.org>, <r-gunasekaran@ti.com>
Subject: [PATCH v2 net-next] net: hsr: Disable promiscuous mode in offload mode
Date: Wed, 14 Jun 2023 17:17:10 +0530
Message-ID: <20230614114710.31400-1-r-gunasekaran@ti.com>
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
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When port-to-port forwarding for interfaces in HSR node is enabled,
disable promiscuous mode since L2 frame forward happens at the
offloaded hardware.

Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
Changes from v1:
===============
* Changed the data type of "fwd_offloaded" from "unsigned int" to "bool"
  and moved it below "net_id" struct member as per Paolo's comment.
* Collected Reviewed-by tag from v1 patch.

v1: https://lore.kernel.org/all/20230612093933.13267-1-r-gunasekaran@ti.com/

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
index 5584c80a5c79..6851e33df7d1 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -208,6 +208,7 @@ struct hsr_priv {
 	u8 net_id;		/* for PRP, it occupies most significant 3 bits
 				 * of lan_id
 				 */
+	bool fwd_offloaded;	/* Forwarding offloaded to HW */
 	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
 				/* Align to u16 boundary to avoid unaligned access
 				 * in ether_addr_equal
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


