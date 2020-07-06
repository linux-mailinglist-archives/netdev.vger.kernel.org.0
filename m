Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7301215493
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 11:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgGFJVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 05:21:02 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:16676 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbgGFJVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 05:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594027261; x=1625563261;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6VmtK8G/xeP+sqbHDRW00jGBGN8YV1TASrTdld+tic0=;
  b=YwfcY9z6bK6zHkl1WWJTZJ5yCH/SASbztVG4IbBcgD0HHr40dh4oAEhW
   cuYhDTwd32kx/45exqhrmrpgOXj/bGgiKTlydKgfFsptgBQgR2d6LUvRd
   79AHKrHjRdC9TYocqWOzSqUjLWsATheKoTa+GFP+pKfgEELfLlUHo1WaH
   4ukbd6RCAr0yeG8+mK6p4+iEyz8n1MWjnnVAGSYvBSQFh68aMJyhRnvsS
   8pfrtB6nWbz2P9HCwOawJBAT97dk1uu+RwQmBkPwW0pGR4Fm1FbxPlSES
   WpQetOT6UlZxkqL/adxhIlfvRSBBPs7TG/SXbshvKN+ZoSzCGvvtJo9sJ
   g==;
IronPort-SDR: cRVX+K/ODGxl8h3WUn8lQDkI6MGYOctPusVMY5tXqG+yxs5SQZOcA49noEpH7fZXcvMNEej3ue
 cjyQvPhGsNSR+Gc28idMeehwLBlbAux4AFCn1FA6wFCoslLFWx07B49+PKhJSDxCY2AEh/grrz
 yQyLOpBfiJ0vzUJJNk6dgTaOuAMqb5Ho0heLU6phC/yrg48AXdFXmIhmPPVTM2X8yNf2Pw0V1/
 yDvuzHOChIkHdPEsKcWxYLh2Yq9LPuk6jdvrpmQ+N+vIpzJXH9cltUbOJLTDQvDYDHn9DJJ/yA
 ZoM=
X-IronPort-AV: E=Sophos;i="5.75,318,1589266800"; 
   d="scan'208";a="18108997"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2020 02:21:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 6 Jul 2020 02:21:00 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 6 Jul 2020 02:20:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 06/12] bridge: mrp: Add br_mrp_in_port_open function
Date:   Mon, 6 Jul 2020 11:18:36 +0200
Message-ID: <20200706091842.3324565-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function notifies the userspace when the node lost the continuity
of MRP_InTest frames.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_netlink.c | 22 ++++++++++++++++++++++
 net/bridge/br_private_mrp.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index acce300c0cc29..4bf7aaeb29152 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -389,3 +389,25 @@ int br_mrp_ring_port_open(struct net_device *dev, u8 loc)
 out:
 	return err;
 }
+
+int br_mrp_in_port_open(struct net_device *dev, u8 loc)
+{
+	struct net_bridge_port *p;
+	int err = 0;
+
+	p = br_port_get_rcu(dev);
+	if (!p) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (loc)
+		p->flags |= BR_MRP_LOST_IN_CONT;
+	else
+		p->flags &= ~BR_MRP_LOST_IN_CONT;
+
+	br_ifinfo_notify(RTM_NEWLINK, NULL, p);
+
+out:
+	return err;
+}
diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
index d5957f7e687ff..384cb69b47e02 100644
--- a/net/bridge/br_private_mrp.h
+++ b/net/bridge/br_private_mrp.h
@@ -75,5 +75,6 @@ int br_mrp_port_switchdev_set_role(struct net_bridge_port *p,
 
 /* br_mrp_netlink.c  */
 int br_mrp_ring_port_open(struct net_device *dev, u8 loc);
+int br_mrp_in_port_open(struct net_device *dev, u8 loc);
 
 #endif /* _BR_PRIVATE_MRP_H */
-- 
2.27.0

