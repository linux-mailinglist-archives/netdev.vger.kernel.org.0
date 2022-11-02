Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB6615B57
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiKBEPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiKBEPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:15:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9939623BEA;
        Tue,  1 Nov 2022 21:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667362483; x=1698898483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sZkHzp4axHvnVQJ1e6P/AN6YKQRNToLw1Xi9YPFU8ms=;
  b=uoGbcuOLEJuYwbY/ZM2qWX+xr++iXDH5VgvFzHU2rkogwzrlRbUiJjJD
   zcGYII5lPKp/Lst2j7GrWopCxfYKKXX70oy7cLp4640N6DODtFH167cT1
   hLH8IRJNYxs4xYDBJXQGNZ9lEtQigVs4rTAqIQEGME0vI6sBY2hHrXZRw
   RkxEnD4oRihaRF+iUCa8J5XEgM0mIf2QkUKB1EuGss2X8g6VY3ThOgln5
   B9Hp5mMFugeDRot74L/0wYKQg67SuqMpjj+ooFDnCxY/sngTVH8pZdDxT
   T8GEEkeT3TvAq9/F+8+N+eD13JDPpf43C4UR6Uy3Y6ooshphwR9sXEuHq
   w==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="184948864"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 21:14:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 21:14:40 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 21:14:36 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
Subject: [PATCH net-next 4/6] net: dsa: microchip: add error checking for ksz_pwrite
Date:   Wed, 2 Nov 2022 09:40:56 +0530
Message-ID: <20221102041058.128779-5-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add status validation for port register write inside
lan937x_change_mtu. ksz_pwrite and ksz_pread api's are
updated with return type int (Reference patch mentioned
below). Update lan937x_change_mtu with status validation
for ksz_pwrite16().

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220826105634.3855578-6-o.rempel@pengutronix.de/

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 7e4f307a0387..06d3d0308cba 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -242,7 +242,11 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 	}
 
 	/* Write the frame size in PORT_MAX_FR_SIZE register */
-	ksz_pwrite16(dev, port, PORT_MAX_FR_SIZE, new_mtu);
+	ret = ksz_pwrite16(dev, port, PORT_MAX_FR_SIZE, new_mtu);
+	if (ret) {
+		dev_err(ds->dev, "failed to update mtu for port %d\n", port);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.34.1

