Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1384525FDF
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379403AbiEMKXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379408AbiEMKXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:23:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EA91737D9;
        Fri, 13 May 2022 03:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652437385; x=1683973385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SbpONxbcftQxpalIBthpvonbGnah7yUXwuxk+eTeCvs=;
  b=CniokuksrW6MIMxwKl40Zn88u1UpjDke6/5LCXYxN96qJU2rGmqqthR9
   eUG1AEB84JrEpKHcS/s3F0FyaoJ16NDQbLufh7BgnBgDU6ucwU2zfBaUy
   RMK5pAUspqukp9yGEKuBOrbIVfoeH2RDXX3qO/aDvudMlzbN49OgfLUyu
   8nBl7ij75UvEmny2OyNY93FurHNODytUnjz6IqeDXEw7BsIxEjDP86dqG
   e03mPKq8rboPOrqu7hAd5w7UTbL57VbAwBgAKgl6iXSq99xpNhxw99LJm
   aWzw23H2raQ1L/i6KrI9VY9HhtRFMsayNmm/71JLM2WKB6BNJmkWpz9Wj
   w==;
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="158946863"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 03:23:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 03:23:04 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 03:22:59 -0700
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
Subject: [RFC Patch net-next v2 4/9] net: dsa: microchip: move port memory allocation to ksz_common
Date:   Fri, 13 May 2022 15:52:14 +0530
Message-ID: <20220513102219.30399-5-arun.ramadoss@microchip.com>
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

ksz8795 and ksz9477 init function initializes the memory to dev->ports
and assigns the ds real number of ports. Since both the routines are
same, moved the allocation of port memory to ksz_switch_register after
init.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 8 --------
 drivers/net/dsa/microchip/ksz9477.c    | 8 --------
 drivers/net/dsa/microchip/ksz_common.c | 9 +++++++++
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b6032b65afc2..91f29ff7256c 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1599,11 +1599,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
 
 	dev->reg_mib_cnt = MIB_COUNTER_NUM;
 
-	dev->ports = devm_kzalloc(dev->dev,
-				  dev->info->port_cnt * sizeof(struct ksz_port),
-				  GFP_KERNEL);
-	if (!dev->ports)
-		return -ENOMEM;
 	for (i = 0; i < dev->info->port_cnt; i++) {
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
 		dev->ports[i].mib.counters =
@@ -1615,9 +1610,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
 			return -ENOMEM;
 	}
 
-	/* set the real number of ports */
-	dev->ds->num_ports = dev->info->port_cnt;
-
 	/* We rely on software untagging on the CPU port, so that we
 	 * can support both tagged and untagged VLANs
 	 */
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c712a0011367..1a0fd36e180e 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1482,11 +1482,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
 	dev->mib_cnt = TOTAL_SWITCH_COUNTER_NUM;
 
-	dev->ports = devm_kzalloc(dev->dev,
-				  dev->info->port_cnt * sizeof(struct ksz_port),
-				  GFP_KERNEL);
-	if (!dev->ports)
-		return -ENOMEM;
 	for (i = 0; i < dev->info->port_cnt; i++) {
 		spin_lock_init(&dev->ports[i].mib.stats64_lock);
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
@@ -1499,9 +1494,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 			return -ENOMEM;
 	}
 
-	/* set the real number of ports */
-	dev->ds->num_ports = dev->info->port_cnt;
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fd2f1bd3feb5..717734fe437e 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -768,6 +768,15 @@ int ksz_switch_register(struct ksz_device *dev,
 	if (ret)
 		return ret;
 
+	dev->ports = devm_kzalloc(dev->dev,
+				  dev->info->port_cnt * sizeof(struct ksz_port),
+				  GFP_KERNEL);
+	if (!dev->ports)
+		return -ENOMEM;
+
+	/* set the real number of ports */
+	dev->ds->num_ports = dev->info->port_cnt;
+
 	/* Host port interface will be self detected, or specifically set in
 	 * device tree.
 	 */
-- 
2.33.0

