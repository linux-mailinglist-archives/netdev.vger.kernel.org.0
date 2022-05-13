Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FFF52600D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379444AbiEMKY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379437AbiEMKXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:23:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1368095DD3;
        Fri, 13 May 2022 03:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652437406; x=1683973406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xp4K8hQTWLnSSIvT6QLUN6BPr9Fyl4/lp1+BYyvMhZ8=;
  b=hqK/i+ZQsEB6dbZTaWaSbDlmuFcF557RyQlug2MvKSLrMSRsiUh4miYG
   Hnbfy/QPdksR8fbF9bMIKuNWREnzwOfdDRqr8Z58XXUNDz4RUre5ql3/F
   Oo/4qnfQOOThrtSWFqT5CV/G4EALim7QmvKYhUEOneoiIAyO9jhawerfa
   P07J07C6g9Yssasc8xjZpJcXFQIH/oRvuq1Pa0+mfPLIUeA+MG3ZSXaO+
   oQuO8oKRNc3bxSppib44usfP+kJvkDggY3rr524ab3U5e1k0o6dV5SMjV
   2LrV/EiYZClyxTXfn+ZsGFemEHz5i9rpAhXOzCXCkDQBn2YO4qDUJSXMJ
   g==;
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="158946910"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 03:23:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 03:23:25 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 03:23:20 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC Patch net-next v2 7/9] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
Date:   Fri, 13 May 2022 15:52:17 +0530
Message-ID: <20220513102219.30399-8-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220513102219.30399-1-arun.ramadoss@microchip.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

mib->cnt_ptr resetting is handled in multiple places as part of
port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
and removed from individual product files.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 2 --
 drivers/net/dsa/microchip/ksz9477.c    | 3 ---
 drivers/net/dsa/microchip/ksz_common.c | 8 +++++++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 251048ffd3d4..d6162b00e4fb 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -388,8 +388,6 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->info->mib_cnt * sizeof(u64));
 }
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 7cffc3388106..22ef56e2cb7b 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -274,9 +274,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
 	mutex_unlock(&mib->cnt_mutex);
-
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->info->mib_cnt * sizeof(u64));
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 18160543090c..240a0aab96ff 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -560,8 +560,14 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	for (i = 0; i < dev->info->port_cnt; i++)
+	for (i = 0; i < dev->info->port_cnt; i++) {
+		struct ksz_port_mib *mib = &dev->ports[i].mib;
+
 		dev->dev_ops->port_init_cnt(dev, i);
+
+		mib->cnt_ptr = 0;
+		memset(mib->counters, 0, dev->info->mib_cnt * sizeof(u64));
+	}
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
-- 
2.33.0

