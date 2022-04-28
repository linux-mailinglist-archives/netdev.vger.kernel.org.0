Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C1A512C5F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiD1HLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbiD1HLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:11:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B74B7CB03;
        Thu, 28 Apr 2022 00:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651129672; x=1682665672;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7IQZ0nOuAp1XafDeS7vtdno92cZi3MiHQLnW4BFWw8I=;
  b=DxZJmbVGMuB+ygO9uq4iwz8sTnBacLwZW4cYVEJV7uo9lemUHOl7AsrK
   JL7cBExdFijKIoxUCEwo/U8sgQYS8YYw43EHiFHRUMgu/H0liEqNkOqxE
   oZyntkFw1caPBREsradLv0T6pPLQBQad8AckBAcUZjqXRWt1bZb4w43HO
   m+UajhpIuK94bzhquoKKHlM8bupHXXQd8jrgWEs/7W+gzwAF82uS8hDyx
   jf4hvdBKzRkCMA4vlGNen3i6y2OSnWnK9yvHJvD0BFsSAY87nEnBsfR/q
   BV0IczjuWeUNRjeZbazZXNMYFs74XRdyb125MxGTaEc6aL2+QjnGRrU8f
   A==;
X-IronPort-AV: E=Sophos;i="5.90,295,1643698800"; 
   d="scan'208";a="157093245"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2022 00:07:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 28 Apr 2022 00:07:51 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 28 Apr 2022 00:07:47 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net] net: dsa: ksz9477: port mirror sniffing limited to one port
Date:   Thu, 28 Apr 2022 12:37:09 +0530
Message-ID: <20220428070709.7094-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch limits the sniffing to only one port during the mirror add.
And during the mirror_del it checks for all the ports using the sniff,
if and only if no other ports are referring, sniffing is disabled.
The code is updated based on the review comments of LAN937x port mirror
patch.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210422094257.1641396-8-prasanna.vengateshan@microchip.com/
Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 38 ++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 48c90e4cda30..61dd0fa97748 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -896,14 +896,32 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
 				   bool ingress, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
+	u8 data;
+	int p;
+
+	/* Limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/* Skip the current sniffing port */
+		if (p == mirror->to_local_port)
+			continue;
+
+		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if (data & PORT_MIRROR_SNIFFER) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Sniffer port is already configured, delete existing rules & retry");
+			return -EBUSY;
+		}
+	}
 
 	if (ingress)
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
 	else
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
 
-	ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
-
 	/* configure mirror port */
 	ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
 		     PORT_MIRROR_SNIFFER, true);
@@ -917,16 +935,28 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
 				    struct dsa_mall_mirror_tc_entry *mirror)
 {
 	struct ksz_device *dev = ds->priv;
+	bool in_use = false;
 	u8 data;
+	int p;
 
 	if (mirror->ingress)
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
 	else
 		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
 
-	ksz_pread8(dev, port, P_MIRROR_CTRL, &data);
 
-	if (!(data & (PORT_MIRROR_RX | PORT_MIRROR_TX)))
+	/* Check if any of the port is still referring to sniffer port */
+	for (p = 0; p < dev->port_cnt; p++) {
+		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rules */
+	if (!in_use)
 		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
 			     PORT_MIRROR_SNIFFER, false);
 }

base-commit: 50c6afabfd2ae91a4ff0e2feb14fe702b0688ec5
-- 
2.33.0

