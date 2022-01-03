Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C97483147
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 14:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiACNIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 08:08:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:6231 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiACNIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 08:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641215314; x=1672751314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5eMVCp5Y4voeWPHCELZJjSzGFKISJ0EyZAi+IDPQ2Sc=;
  b=OULlw86o09J4CVT5Jc3usw+zQHM6Kc016fc3kjUWngRCf/NVGkf4zJqZ
   rJzWoFaNja0ye+5C3RUUGmgNPLlnEAtHMP0tyrs+DcHN6vnkISAWzx1gR
   b7zRRTMOfUwRen9qbZSjfIQcGdJHppordFh+C6vAv9Qvl/0XjZV4FY2/x
   RmkJ/IePE+QFUpNS6FD6XP3M55oxrTcix+fnKNrAgyQlMBb9umYhxjIik
   wR6no+0h+L4qafHoFjObapppw/uodHxeffs1iCQITZueysFKFiWX1/Su/
   RZtHZxk2E8ahyBYOmgnTRiRjGh2UGyEJaYxU1C645vVlNW7ynKaXujFtr
   g==;
IronPort-SDR: BlGIJy41yiTaXU5Gv30xasOq1QgzCIfVfYs0RLlEYC6uEtPgav41wRmw+mJhGujX2QQN1G5mRo
 2Lz7t4nfpnysRg+1RpKlVTVeLmUBsKT0UgdUjqLtVXCbkrwLe0NwjxPbtwjqszvht5z/v0MbxK
 AipZhNwM092jvQrvz0wDq3p21K5FQeDXcdOVN/nk75D0X5LepVxXx8Qkkc9V7JEAKv0B5O4s5Z
 nyY3FYktyP+tPKCoeFVekK5aaNRClSW/DgNWcNlqzd1j3IzjfiJkSNddASyPVeco34wBz7ve93
 S3nuhW5JR52vSpV2T5v4pPZD
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="141458437"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jan 2022 06:08:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 3 Jan 2022 06:08:34 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 3 Jan 2022 06:08:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/3] net: lan966x: Add function lan966x_mac_cpu_copy()
Date:   Mon, 3 Jan 2022 14:10:37 +0100
Message-ID: <20220103131039.3473876-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend mac functionality with the function lan966x_mac_cpu_copy. This
function adds an entry in the MAC table where a frame is copy to the CPU
but also can be forward on the front ports.
This functionality is needed for mdb support. In case the CPU and some
of the front ports subscribe to an IP multicast address.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 27 ++++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 ++++
 .../ethernet/microchip/lan966x/lan966x_regs.h |  6 +++++
 3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index efadb8d326cc..ae3a7a10e0d6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -68,16 +68,18 @@ static void lan966x_mac_select(struct lan966x *lan966x,
 	lan_wr(mach, lan966x, ANA_MACHDATA);
 }
 
-int lan966x_mac_learn(struct lan966x *lan966x, int port,
-		      const unsigned char mac[ETH_ALEN],
-		      unsigned int vid,
-		      enum macaccess_entry_type type)
+static int lan966x_mac_learn_impl(struct lan966x *lan966x, int port,
+				  bool cpu_copy,
+				  const unsigned char mac[ETH_ALEN],
+				  unsigned int vid,
+				  enum macaccess_entry_type type)
 {
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a write command */
 	lan_wr(ANA_MACACCESS_VALID_SET(1) |
 	       ANA_MACACCESS_CHANGE2SW_SET(0) |
+	       ANA_MACACCESS_MAC_CPU_COPY_SET(cpu_copy) |
 	       ANA_MACACCESS_DEST_IDX_SET(port) |
 	       ANA_MACACCESS_ENTRYTYPE_SET(type) |
 	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
@@ -86,6 +88,23 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
 	return lan966x_mac_wait_for_completion(lan966x);
 }
 
+int lan966x_mac_cpu_copy(struct lan966x *lan966x, int port,
+			 bool cpu_copy,
+			 const unsigned char mac[ETH_ALEN],
+			 unsigned int vid,
+			 enum macaccess_entry_type type)
+{
+	return lan966x_mac_learn_impl(lan966x, port, cpu_copy, mac, vid, type);
+}
+
+int lan966x_mac_learn(struct lan966x *lan966x, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid,
+		      enum macaccess_entry_type type)
+{
+	return lan966x_mac_learn_impl(lan966x, port, false, mac, vid, type);
+}
+
 int lan966x_mac_forget(struct lan966x *lan966x,
 		       const unsigned char mac[ETH_ALEN],
 		       unsigned int vid,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c399b1256edc..a7a2a3537036 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -157,6 +157,11 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 			 struct lan966x_port_config *config);
 void lan966x_port_init(struct lan966x_port *port);
 
+int lan966x_mac_cpu_copy(struct lan966x *lan966x, int port,
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

