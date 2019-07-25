Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D254D74D5E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 13:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404236AbfGYLoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 07:44:19 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:1693 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404217AbfGYLoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 07:44:15 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: tjjT0rz37UZLBn76k8jrHlulkDry/YlLFIAycfBfRZruaDmySPMebHeqpByVJ72bNVlSFRm948
 4nj+3SgjitcEmBD1/qmxqzREeENLliSHOY5LO8GSmvvs/oJSMxwDnCWil3u0y3+ZsoDhRZ4za3
 cCh9fnRU2jdLZ6XPjoXXdRBOIHj/hWFlFV1fRUexLfaFDbFwzitboiHW5vOvgOUkeGqlwMBPQ0
 Grv9/zDFOaC+5ApRSwuYwEJYgpPlXAKQLJBRubUsvJBTo4NV0nIX63VZty5UtIMu7EtnzVkLT+
 2vQ=
X-IronPort-AV: E=Sophos;i="5.64,306,1559545200"; 
   d="scan'208";a="42717160"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jul 2019 04:44:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.87.71) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jul 2019 04:44:13 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 25 Jul 2019 04:44:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <bridge@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <allan.nielsen@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH] net: bridge: Allow bridge to joing multicast groups
Date:   Thu, 25 Jul 2019 13:44:04 +0200
Message-ID: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no way to configure the bridge, to receive only specific link
layer multicast addresses. From the description of the command 'bridge
fdb append' is supposed to do that, but there was no way to notify the
network driver that the bridge joined a group, because LLADDR was added
to the unicast netdev_hw_addr_list.

Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
and if the source is NULL, which represent the bridge itself. Then add
address to multicast netdev_hw_addr_list for each bridge interfaces.
And then the .ndo_set_rx_mode function on the driver is called. To notify
the driver that the list of multicast mac addresses changed.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b1d3248..d93746d 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
 	}
 }
 
+static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
+{
+	int err;
+	struct net_bridge_port *p;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(p, &br->port_list, list) {
+		if (!br_promisc_port(p)) {
+			err = dev_mc_add(p->dev, addr);
+			if (err)
+				goto undo;
+		}
+	}
+
+	return;
+undo:
+	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
+		if (!br_promisc_port(p))
+			dev_mc_del(p->dev, addr);
+	}
+}
+
 /* When a static FDB entry is deleted, the HW address from that entry is
  * also removed from the bridge private HW address list and updates all
  * the ports with needed information.
@@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
 	}
 }
 
+static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
+{
+	struct net_bridge_port *p;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(p, &br->port_list, list) {
+		if (!br_promisc_port(p))
+			dev_mc_del(p->dev, addr);
+	}
+}
+
 static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
 		       bool swdev_notify)
 {
 	trace_fdb_delete(br, f);
 
-	if (f->is_static)
+	if (f->is_static) {
 		fdb_del_hw_addr(br, f->key.addr.addr);
+		fdb_del_hw_maddr(br, f->key.addr.addr);
+	}
 
 	hlist_del_init_rcu(&f->fdb_node);
 	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
@@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			fdb->is_local = 1;
 			if (!fdb->is_static) {
 				fdb->is_static = 1;
-				fdb_add_hw_addr(br, addr);
+				if (flags & NLM_F_APPEND && !source)
+					fdb_add_hw_maddr(br, addr);
+				else
+					fdb_add_hw_addr(br, addr);
 			}
 		} else if (state & NUD_NOARP) {
 			fdb->is_local = 0;
 			if (!fdb->is_static) {
 				fdb->is_static = 1;
-				fdb_add_hw_addr(br, addr);
+				if (flags & NLM_F_APPEND && !source)
+					fdb_add_hw_maddr(br, addr);
+				else
+					fdb_add_hw_addr(br, addr);
 			}
 		} else {
 			fdb->is_local = 0;
-- 
2.7.4

