Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3925A483FAE
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiADKQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:16:46 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:21184 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiADKQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:16:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641291404; x=1672827404;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fbn9aX14psETKI9MIYiHhnDAHFwFGUyJxLq5Np2CapM=;
  b=NRZ7xJ5HtUUNIzyh03WMdAZLJeZhLO0RUvy6xKz+BlUnospWiDT+BcPS
   RG25qJ6vdWt8XD3hCUZIJCY8rpHQCffovo02P7UhRBsr02nmmb5qTVPs4
   W1kUqw864zQJom/F6N98oOOIvygWiCk3FQPpdouefr9H52cuP9Km0rop9
   D517/3ixj8rkCdcLfhSDanYW0Qp2LQKLCgsTDhR4cTdY9SpKeBT4PcVnR
   Ij6JNbPAJxPgqdeXIj2OpISTJkmqheQ5JGbZ5UXnJ25xGc8rw31YAiZkM
   3Q3yI31tXoTL5yqoS5N/SNxYumNMJc9M7Z9N4udlw8XLMXdqX38H/8nLw
   w==;
IronPort-SDR: R5g5QNd7dGaVj+lPK8uZgTZqcW2N9wueFVrBG/ZDpPX+2Ja11N8J/++wdxFdCz7GC/3CrJ2/24
 fW1Tinwrno4IY+6cywIIfMp82He0FwQFFQKNx5c04I3roSd/W0hZjQ6F8KKA2+NB9T2gOPIbYF
 YVABC8HQNzWL6ZFbhXC95QWca8r88bw6k/p6LiJAICmlVZnho5PxGRn/OS8BL+CqdoeHZuV4Ci
 BvAIDWkRSfihDobpII74JekIhr549iUO3wVPR9XqST3yoFLeBsU2FRVZRFOUzDNdiIwRQfnVSb
 4FPpWH0qzFSZJgnwyS91dnX1
X-IronPort-AV: E=Sophos;i="5.88,260,1635231600"; 
   d="scan'208";a="141568082"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 03:16:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 03:16:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 03:16:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/3] net: lan966x: Add function lan966x_mac_ip_learn()
Date:   Tue, 4 Jan 2022 11:18:47 +0100
Message-ID: <20220104101849.229195-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104101849.229195-1-horatiu.vultur@microchip.com>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 33 ++++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 +++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 ++++
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index efadb8d326cc..82eb6606e17f 100644
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
@@ -86,6 +88,27 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
 	return lan966x_mac_wait_for_completion(lan966x);
 }
 
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

