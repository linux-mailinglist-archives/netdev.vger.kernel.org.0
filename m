Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B05617C2
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiF3KX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiF3KXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:23:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDAF10FD9;
        Thu, 30 Jun 2022 03:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656584592; x=1688120592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kPNZzaic70bWMl6j4drzefsnYsnTMFIAN5Pu85MQ0tU=;
  b=YngNDd4G/rgMyBrH/ToKwxYlqAtCpDGldV5N5kZ66Z93/vMbLryUUvgq
   qF9t5n+H29/ZiKJpem/p9XfM4JTNHcZe7lQwjwrijO29fdzgHFc2rffzD
   Jjro+dXpI82xE1MHmkTQvaliWV4fTha5IMb4aWR9v0/5JaYnuIulM78Yp
   mHzquImhQXg5hZr3rx14qYuCAHvreXZ0BNDUzQ1A9l8YQIn2sYHEC5I//
   aROJJd9bBNx80vF2lv4J9xmCuAUg51pGK8UI5Js9cjyJeYWxa0mzRXcUq
   EukkakMxMGHK+8wlvRmsU3YMWH1dHvhO2s105B/6Vndnn1JYKbyHJLEO9
   w==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="165805175"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 03:23:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 03:23:08 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 30 Jun 2022 03:23:00 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add phylink_get_caps support
Date:   Thu, 30 Jun 2022 15:50:38 +0530
Message-ID: <20220630102041.25555-11-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630102041.25555-1-arun.ramadoss@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal phy of the LAN937x are capable of 100Mbps speed. And the
xMII port of switch is capable of 10/100/1000Mbps.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c   |  1 +
 drivers/net/dsa/microchip/lan937x.h      |  2 ++
 drivers/net/dsa/microchip/lan937x_main.c | 12 ++++++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fb0de48a3f5e..ca7ca327285d 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -220,6 +220,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.vlan_del = ksz9477_port_vlan_del,
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
+	.get_caps = lan937x_phylink_get_caps,
 	.fdb_dump = ksz9477_fdb_dump,
 	.fdb_add = ksz9477_fdb_add,
 	.fdb_del = ksz9477_fdb_del,
diff --git a/drivers/net/dsa/microchip/lan937x.h b/drivers/net/dsa/microchip/lan937x.h
index 50563874600d..d4207e97a130 100644
--- a/drivers/net/dsa/microchip/lan937x.h
+++ b/drivers/net/dsa/microchip/lan937x.h
@@ -15,4 +15,6 @@ void lan937x_switch_exit(struct ksz_device *dev);
 void lan937x_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data);
 void lan937x_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val);
 int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu);
+void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
+			      struct phylink_config *config);
 #endif
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 5917cc11ba59..8cb46caf5340 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -312,6 +312,18 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	return 0;
 }
 
+void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
+			      struct phylink_config *config)
+{
+	config->mac_capabilities = MAC_100FD;
+
+	if (dev->info->supports_rgmii[port]) {
+		/* MII/RMII/RGMII ports */
+		config->mac_capabilities |= MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+					    MAC_100HD | MAC_10 | MAC_1000FD;
+	}
+}
+
 int lan937x_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
-- 
2.36.1

