Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2884C484499
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbiADPbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:31:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:28647 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiADPbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:31:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641310292; x=1672846292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XWWZ94jt6LesFe+O8EUFY9XRUIEwF/VRiZ9KDYXezuQ=;
  b=kX8JUrCSL0EaCRnw2eM5qbwnsmauUiTNytbXX6zxuPxxBs3WVDj3YUU9
   vQokcfUykXrouTSzzlOanLUFRqqXcWPymEQsDQpNCQAgoOjJR3VyjKYP+
   46ljNou2kO7AtKRxVjQhAK97291qhC5BtntvGmYbI6H3hK3qPkwxYce/H
   qUA/mLSKDg1Z2SkiiBjwPXaDOtntH+ogsJjp6FK6gF2lWgq7B3qSSNXPF
   9BMx9K7U2LzV+UC/+PBMAp7T0HHqeSMs2A4IIi+4FFgqVTUzvtV1Ga/S8
   EXJ5dP4hYcE9PFnMaHH7eV+o4YOnxsgdq2FNmfXJSkrOa4owyP1S9jwtM
   g==;
IronPort-SDR: q+Mv5BRxAFINaSHaA9RGzVwMiF3u/1+JC6Vkop4L9LEQ1dT8zzRxnSOeakQKpd4RFEycT9FvvS
 kVWCTTd/cUCiXZN/okHtm2qs4Y5MH0nuY4cESOPCy2YzeaL4nVSkd1HQowvBH7pVHzd3RPwXun
 sUx4K/3mfKslgv4j/YHSZ3c6SYkZVL7uzyI1XZIxzOWKpGECznMnBTqaEvkyLp2LPR14UgqwfJ
 HLWOFd8lBE86kmcINMNq9gAfivu2zgPHuEkBu/RPORmuoyppAB6zetjhnoHokGyW3XGPddn44N
 c5POvfh04+gLKi1E+rN5FaO2
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="81391627"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 08:31:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 08:31:30 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 08:31:28 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 1/3] net: lan966x: Add function lan966x_mac_ip_learn()
Date:   Tue, 4 Jan 2022 16:33:36 +0100
Message-ID: <20220104153338.425250-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104153338.425250-1-horatiu.vultur@microchip.com>
References: <20220104153338.425250-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend mac functionality with the function lan966x_mac_ip_learn. This
function adds an entry in the MAC table for IP multicast addresses.
These entries can copy a frame to the CPU but also can forward on the
front ports.
This functionality is needed for mdb support. In case the CPU and some
of the front ports subscribe to an IP multicast address.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 36 ++++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 +++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 ++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index efadb8d326cc..ca5f1177963d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -68,17 +68,19 @@ static void lan966x_mac_select(struct lan966x *lan966x,
 	lan_wr(mach, lan966x, ANA_MACHDATA);
 }
 
-int lan966x_mac_learn(struct lan966x *lan966x, int port,
-		      const unsigned char mac[ETH_ALEN],
-		      unsigned int vid,
-		      enum macaccess_entry_type type)
+static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
+			       bool cpu_copy,
+			       const unsigned char mac[ETH_ALEN],
+			       unsigned int vid,
+			       enum macaccess_entry_type type)
 {
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a write command */
 	lan_wr(ANA_MACACCESS_VALID_SET(1) |
 	       ANA_MACACCESS_CHANGE2SW_SET(0) |
-	       ANA_MACACCESS_DEST_IDX_SET(port) |
+	       ANA_MACACCESS_MAC_CPU_COPY_SET(cpu_copy) |
+	       ANA_MACACCESS_DEST_IDX_SET(pgid) |
 	       ANA_MACACCESS_ENTRYTYPE_SET(type) |
 	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
 	       lan966x, ANA_MACACCESS);
@@ -86,6 +88,30 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
 	return lan966x_mac_wait_for_completion(lan966x);
 }
 
+/* The mask of the front ports is encoded inside the mac parameter via a call
+ * to lan966x_mdb_encode_mac().
+ */
+int lan966x_mac_ip_learn(struct lan966x *lan966x,
+			 bool cpu_copy,
+			 const unsigned char mac[ETH_ALEN],
+			 unsigned int vid,
+			 enum macaccess_entry_type type)
+{
+	WARN_ON(type != ENTRYTYPE_MACV4 && type != ENTRYTYPE_MACV6);
+
+	return __lan966x_mac_learn(lan966x, 0, cpu_copy, mac, vid, type);
+}
+
+int lan966x_mac_learn(struct lan966x *lan966x, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid,
+		      enum macaccess_entry_type type)
+{
+	WARN_ON(type != ENTRYTYPE_NORMAL && type != ENTRYTYPE_LOCKED);
+
+	return __lan966x_mac_learn(lan966x, port, false, mac, vid, type);
+}
+
 int lan966x_mac_forget(struct lan966x *lan966x,
 		       const unsigned char mac[ETH_ALEN],
 		       unsigned int vid,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c399b1256edc..f70e54526f53 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -157,6 +157,11 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 			 struct lan966x_port_config *config);
 void lan966x_port_init(struct lan966x_port *port);
 
+int lan966x_mac_ip_learn(struct lan966x *lan966x,
+			 bool cpu_copy,
+			 const unsigned char mac[ETH_ALEN],
+			 unsigned int vid,
+			 enum macaccess_entry_type type);
 int lan966x_mac_learn(struct lan966x *lan966x, int port,
 		      const unsigned char mac[ETH_ALEN],
 		      unsigned int vid,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
index a13c469e139a..797560172aca 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
@@ -169,6 +169,12 @@ enum lan966x_target {
 #define ANA_MACACCESS_CHANGE2SW_GET(x)\
 	FIELD_GET(ANA_MACACCESS_CHANGE2SW, x)
 
+#define ANA_MACACCESS_MAC_CPU_COPY               BIT(16)
+#define ANA_MACACCESS_MAC_CPU_COPY_SET(x)\
+	FIELD_PREP(ANA_MACACCESS_MAC_CPU_COPY, x)
+#define ANA_MACACCESS_MAC_CPU_COPY_GET(x)\
+	FIELD_GET(ANA_MACACCESS_MAC_CPU_COPY, x)
+
 #define ANA_MACACCESS_VALID                      BIT(12)
 #define ANA_MACACCESS_VALID_SET(x)\
 	FIELD_PREP(ANA_MACACCESS_VALID, x)
-- 
2.33.0

