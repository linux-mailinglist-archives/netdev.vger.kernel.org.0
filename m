Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C434AC755
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359540AbiBGR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346182AbiBGRXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB77C0401D6
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644254616; x=1675790616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M5RUw9aInzvMr/cEGUCrZ6Um3TAA0XPSudFDktRPWxc=;
  b=t8O1J8xnCD7oP0n6KyZELv8p00Tw/bORcgV5ZiMlCta+HSwGc4g+VUkX
   QIh8YiolWUbg4EB+p9sCNuQSm4CoE7m6110YbnbAadk1bn+1sI0uSq27U
   JK6YAmHxmflRBi8uSdQjJcXyR8/hCbs4hu7g7eGHw3SaxPwJu7qGIFMPB
   cHbpgT9nf7iUB0wYOeaBouh2/nDaU2068hNApKklx1GxPMcwr4bSIodY4
   CPb/YcU3gpl/jMNmokIoLsF64cNSskKcLkv90EHlmY3zN2Wy75CHDUIXm
   JMMCFqGyxTEB6TGJy/uv2rs6zCM6hL9y3JzwVjr0H9pv/lTS689mmCXRV
   w==;
IronPort-SDR: 62TR9QcmVvCj++gip/XlOvuNjlF3kWQCUrK/cDOiCybD0eGQG4shPZnORH0nfGsci5dzuhfxDl
 VHgoL7HW4KybsDk2mU8OLXw6AKCn9O1ZNsXjBhtV2MdLwv1j97LIGtqEtgXnk3nVm8rZNkQlnR
 EBb1St6pf/LUnmdkK5WsSbt4qX2bdc6q9Tm0VGHOJd10U2AYxTc0k458iksV07tqVc3TNzsiTO
 i4cJ2TfV1xXWgiPpehjlppI7QfBPdMknRuH6GUR4SUBqeNFM1lEXFWGmKFSvV3Dl4Qn+fgm6hm
 qeoSgd5D2EOsn2nhXgwSqmB8
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="147879263"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2022 10:22:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Feb 2022 10:22:32 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Feb 2022 10:22:26 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v8 net-next 02/10] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
Date:   Mon, 7 Feb 2022 22:51:56 +0530
Message-ID: <20220207172204.589190-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mib->cnt_ptr resetting is handled in multiple places as part of
port_init_cnt(). Hence moved mib->cnt_ptr code to ksz common layer
and removed from individual product files.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 2 --
 drivers/net/dsa/microchip/ksz9477.c    | 3 ---
 drivers/net/dsa/microchip/ksz_common.c | 8 +++++++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 5dc9899bc0a6..2de2302b9a50 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -448,8 +448,6 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a85d990896b0..21900cab96b3 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -292,9 +292,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
 	mutex_unlock(&mib->cnt_mutex);
-
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7e33ec73f803..196aa4fc1100 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -122,8 +122,14 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	for (i = 0; i < dev->port_cnt; i++)
+	for (i = 0; i < dev->port_cnt; i++) {
+		struct ksz_port_mib *mib = &dev->ports[i].mib;
+
 		dev->dev_ops->port_init_cnt(dev, i);
+
+		mib->cnt_ptr = 0;
+		memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
+	}
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
-- 
2.30.2

