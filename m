Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949EC517398
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379476AbiEBQFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386108AbiEBQDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:03:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FB01085;
        Mon,  2 May 2022 09:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651507224; x=1683043224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e3GK+WVSDDsX7JUvQx+cj4UWyLA8yQJCFUYDrobggrQ=;
  b=2IZNx3kO48H1RgiNb0TulQQffrIFaJNW9gc25sxulNFJaJ6PkVw08RrT
   OWVpXmnO3pYFRCnantjnWEEJM+BmKU8dsvXzs5u03uuDg6lwbF8joM+oS
   O0KERaRU1MxMFdNraS08813s5bg8FTCiXDljdmHM+5XtHPhhGp4Inn2iX
   bBILYeZEJ5QG4/i6tNx3XElWCFUz7NW9a7DvOw1eYqUJNje4zyoqqONB1
   9hWRVUKNlkPq4DCzNuYg1bTC8TkYyKFEFWK7p9HibDrWS4AEKfdnxcqR4
   dni1BJeJFyGSXSJNgWoox+TAVSbsMgy4jNMSM8Atqpe6AXcaORLQ7HbTW
   w==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="171647249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2022 09:00:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 2 May 2022 09:00:23 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 2 May 2022 09:00:05 -0700
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
        Rob Herring <robh+dt@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [Patch net-next v12 03/13] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
Date:   Mon, 2 May 2022 21:28:38 +0530
Message-ID: <20220502155848.30493-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220502155848.30493-1-arun.ramadoss@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
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

