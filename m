Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B262551A3A7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352214AbiEDPW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352162AbiEDPW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:22:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966AC4474E;
        Wed,  4 May 2022 08:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651677556; x=1683213556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e3GK+WVSDDsX7JUvQx+cj4UWyLA8yQJCFUYDrobggrQ=;
  b=r2mRkJZVgJtGNN2xSbxY+EfymmOgDAc/+m5MDN3p4uj25MsHRdIPSU6q
   +Y+KiDYohyQTnT6bncGN3vVIAJMfMiImRbhLT7wu4rgbw6FUEjXgw9jid
   tHZ/B6t3+nO305ySyl9coaWhMmoJmWg/I13uzJKNF+8k0xEH+cY2J1gjL
   L1Rv133guo4Aeo38pOkwJAq3lzEFr1JB05sW/i+yXG79DHnccCLblbTsQ
   ZQeewveXoEYZR032KA6VF0N10qcKmuZjMkicEwwI0VG/ZH8IA9ItNvDyR
   XyYh9Lf8gYBilA5N2WTXXQaE5eeG41YrqB9uoR/pzHoBYBR04VE6ZfPZk
   A==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="157794883"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 May 2022 08:19:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 4 May 2022 08:19:09 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 4 May 2022 08:18:53 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [Patch net-next v13 03/13] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
Date:   Wed, 4 May 2022 20:47:45 +0530
Message-ID: <20220504151755.11737-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220504151755.11737-1-arun.ramadoss@microchip.com>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 2 --
 drivers/net/dsa/microchip/ksz9477.c    | 3 ---
 drivers/net/dsa/microchip/ksz_common.c | 8 +++++++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index f91deea9368e..7c12b3518bab 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -468,8 +468,6 @@ static void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 					dropped, &mib->counters[mib->cnt_ptr]);
 		++mib->cnt_ptr;
 	}
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 48c90e4cda30..79f290ad73dc 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -316,9 +316,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	ksz_write8(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FLUSH);
 	ksz_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, 0);
 	mutex_unlock(&mib->cnt_mutex);
-
-	mib->cnt_ptr = 0;
-	memset(mib->counters, 0, dev->mib_cnt * sizeof(u64));
 }
 
 static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 10f127b09e58..235842e01e13 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -242,8 +242,14 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 
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
2.33.0

