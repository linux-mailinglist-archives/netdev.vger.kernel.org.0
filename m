Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5310B511CF2
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbiD0Qao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243645AbiD0Q3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:29:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80ED55BE60;
        Wed, 27 Apr 2022 09:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651076669; x=1682612669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v4vhsDzmv33N2pNyyNNULQV9byISZ8k+Sgt5aBjrcnA=;
  b=N5kpXgvyeQMyh1lbRD2amkmSaRNIownIvRsgjSB13FnRUnvJ9CkX1Tnn
   XQ38/vf/8WA9yL+c4PLM49yJ4tYkxCkybHTuxgEvCLgcoWKCZKBiabUCV
   BPZWNfLaPGD/5xR2qPph6S9VcW562tu2IdvZniUscLU3v4pF66kp5sgI0
   5Mg6AAqZkOZ4NN382AqRA59mTjQywWb6RbwflDrMC+/LDTdUAHiv/hoXw
   lm4WdJmXSdHpxUox/N8tMCnXOlNbXNEN/4rAJGVYq5rJWFbexr+d2Alv/
   +C7FsT2DQkkgr2hcvdQLiFyXsqOl24nx8XkrkIrysSi3S8VQx0MGmDrh7
   g==;
X-IronPort-AV: E=Sophos;i="5.90,293,1643698800"; 
   d="scan'208";a="161536314"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 09:24:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 09:24:26 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 09:24:17 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [RFC patch net-next 1/3] net: dsa: ksz9477: port mirror sniffing limited to one port
Date:   Wed, 27 Apr 2022 21:53:41 +0530
Message-ID: <20220427162343.18092-2-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220427162343.18092-1-arun.ramadoss@microchip.com>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
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
https://patchwork.kernel.org/project/netdevbpf/patch/20210422094257.1641396-8-prasanna.vengateshan@microchip.com/

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 38 ++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4f617fee9a4e..90ce789107eb 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -990,14 +990,32 @@ static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
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
@@ -1011,16 +1029,28 @@ static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
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
+	/* delete sniffing if there are no other mirroring rule exist */
+	if (!in_use)
 		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
 			     PORT_MIRROR_SNIFFER, false);
 }
-- 
2.33.0

