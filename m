Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2777620F60E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbgF3Npx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:45:53 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:12907 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388321AbgF3Npq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593524746; x=1625060746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ReYzEMP1WNRGlHS75E1G5y1MYQS2lAxtN7u/5noQe8c=;
  b=fEIYUKYjgkApIk42mWUkvesyzRkozpJgR8AeFMBj7CPVDtrmseVOl5hI
   /X9Wd9AlwihaZE+q56yZWZpPjT1fo7bLYlz98FDcyoN4xminCyv/PCfjQ
   oA+yu4NreRy/z/qtVhrh9J4yKOEXobr9fnW2/IPGrG6x13UtpVt136MkM
   qeXNVOMaI0UQ1X6XhXi7NSdN9Pw+mtTicQ2OdrUmAJ/f9G3dRtV8qX76t
   yu6olBwbyxxQHaaqw3WFmMNU/ykwGzlP2cht+upO0gESIRy7HI5BROk2m
   7Nu7IfJdI17GdOB+piDpHgkA38Lx+frN/qN1Ptkfmmw6qNfBVwSn2qjgC
   g==;
IronPort-SDR: Ffvde+VwBMKF/E2XbQ5VJUdj8loBqfWUtY/YzJDHYQYmvCR74i8hiftHRAVckCUu3VrnCwAMac
 HXbAQ6+DyO4zJafSlOOiFGaVoS2NX91HncaKNw//iG5rbATp9H9XBLYIox3U2YpxZ/hd4V1/6S
 GRgiWkCl7qKSPFmEY1LPMWH2JaqemDuvTafoq7+D2uxiYQMRloPEsOyHU6YVx4Mg3cSEJdME2r
 K04Hb8oNp64NOJga8DLWxkuVed/62ovfdBXZwxQpVbETgKWcTbF5E4iOxsnNo5HoyMpXVRipBO
 RoA=
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="78274323"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2020 06:45:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 06:45:27 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 30 Jun 2020 06:45:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/3] bridge: mrp: Add br_mrp_fill_info
Date:   Tue, 30 Jun 2020 15:44:23 +0200
Message-ID: <20200630134424.4114086-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
References: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the function br_mrp_fill_info which populates the MRP attributes
regarding the status of each MRP instance.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp_netlink.c | 57 +++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h     |  7 +++++
 2 files changed, 64 insertions(+)

diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
index 34b3a8776991f..c7dd0cc5b90e5 100644
--- a/net/bridge/br_mrp_netlink.c
+++ b/net/bridge/br_mrp_netlink.c
@@ -304,6 +304,63 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 	return 0;
 }
 
+int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	struct nlattr *tb, *mrp_tb;
+	struct br_mrp *mrp;
+
+	mrp_tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
+	if (!mrp_tb)
+		return -EMSGSIZE;
+
+	list_for_each_entry(mrp, &br->mrp_list, list) {
+		tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP_INFO);
+		if (!tb)
+			goto nla_info_failure;
+
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_ID,
+				mrp->ring_id))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_P_IFINDEX,
+				mrp->p_port->dev->ifindex))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_S_IFINDEX,
+				mrp->s_port->dev->ifindex))
+			goto nla_put_failure;
+		if (nla_put_u16(skb, IFLA_BRIDGE_MRP_INFO_PRIO,
+				mrp->prio))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_STATE,
+				mrp->ring_state))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_ROLE,
+				mrp->ring_role))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
+				mrp->test_interval))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
+				mrp->test_max_miss))
+			goto nla_put_failure;
+		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
+				mrp->test_monitor))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, tb);
+	}
+	nla_nest_end(skb, mrp_tb);
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, tb);
+
+nla_info_failure:
+	nla_nest_cancel(skb, mrp_tb);
+
+	return -EMSGSIZE;
+}
+
 int br_mrp_port_open(struct net_device *dev, u8 loc)
 {
 	struct net_bridge_port *p;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6a7d8e218ae7e..65d2c163a24ab 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1317,6 +1317,7 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
 bool br_mrp_enabled(struct net_bridge *br);
 void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
+int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br);
 #else
 static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 			       struct nlattr *attr, int cmd,
@@ -1339,6 +1340,12 @@ static inline void br_mrp_port_del(struct net_bridge *br,
 				   struct net_bridge_port *p)
 {
 }
+
+static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
+{
+	return 0;
+}
+
 #endif
 
 /* br_netlink.c */
-- 
2.27.0

