Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594452B36E5
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 17:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgKOQ6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 11:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgKOQ6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 11:58:06 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5721BC0613D1;
        Sun, 15 Nov 2020 08:58:06 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id h2so21628113wmm.0;
        Sun, 15 Nov 2020 08:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qF9yStZHuIhpGKt0Se1a4eQvafHT0q3rr8k/OBb7qMU=;
        b=dRt1W10yyFl73Jg94BQCOvy7cRJANMXu31ils4GfQa7h582dASZGZ2sdFKNMubpGjw
         Ab9SdyTMlGsLZba3dSNIGPBk/0jjBNQIeLyYn/g2w5kWGVnuSWOvwOKn9BSdzpQW/fWt
         1LQy3XVhp1m+UGlTQb/muTUfD+C8TdvVTQRnJSg+njmUbKPnktd1VknROoRCXwy4QQjD
         O5QE5Kg+kOux1GS2hrPpbdUSjs2UYybsGlsjzrPp1+2JMKBBQka2mkxcTxDF/FDP3pFy
         Q9yQPvchSo0d+5r7ruRk8JEybH2wqOLcedUsUw1AXYj/larMemdtxg9eDH+4udy2OGJM
         zSfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qF9yStZHuIhpGKt0Se1a4eQvafHT0q3rr8k/OBb7qMU=;
        b=lpetp6GDYxVa/YKN5ZbCj2FjJ/gFDJYmvlhVrkb9jcmlrbo0lV+wQrIjfMSA9OWBSQ
         zVTPV/O53bo6dQBL8X+JsU2Gozu707KXu9Ff6zeT+y9nTFiReX/s/seJ2xTlrUDqLY8S
         7j/WQIAtDOU8KScHHPYiQvzphtBAKGU6XuQJFgFqoU72tN78yNy8e7jxK2AujyMh6b/z
         k5buLzMp/BpHyZnIrcBYDKq1kh1cygUs4GMOWX4cLOEtjpqMWQgojrFZkcf1gRrcq424
         MPpq+B4VQotITTDiA/QETHccvJBtsi7wZbWUCSs/bc7Mc0uLRxZHCN8Z9NBxFWL8RdwC
         353w==
X-Gm-Message-State: AOAM530oNxl3rlipMlAWXxxVG16Dw1ZCnkKkHrEo/qZxz+fm+O5cV0Di
        yvlKMQ5LAG/tPgREYxHqc6s=
X-Google-Smtp-Source: ABdhPJxpcx6TsxMXXphN6Q+l3Z8fDIgYP1kSCzNRXCEBG9fDisnOOfSucphxDlFCuXEkohFD2IEc8Q==
X-Received: by 2002:a7b:cb82:: with SMTP id m2mr11358489wmi.75.1605459485009;
        Sun, 15 Nov 2020 08:58:05 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id 6sm12583924wrn.72.2020.11.15.08.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 08:58:04 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2] net: lantiq: Wait for the GPHY firmware to be ready
Date:   Sun, 15 Nov 2020 17:57:57 +0100
Message-Id: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user reports (slightly shortened from the original message):
  libphy: lantiq,xrx200-mdio: probed
  mdio_bus 1e108000.switch-mii: MDIO device at address 17 is missing.
  gswip 1e108000.switch lan: no phy at 2
  gswip 1e108000.switch lan: failed to connect to port 2: -19
  lantiq,xrx200-net 1e10b308.eth eth0: error -19 setting up slave phy

This is a single-port board using the internal Fast Ethernet PHY. The
user reports that switching to PHY scanning instead of configuring the
PHY within device-tree works around this issue.

The documentation for the standalone variant of the PHY11G (which is
probably very similar to what is used inside the xRX200 SoCs but having
the firmware burnt onto that standalone chip in the factory) states that
the PHY needs 300ms to be ready for MDIO communication after releasing
the reset.

Add a 300ms delay after initializing all GPHYs to ensure that the GPHY
firmware had enough time to initialize and to appear on the MDIO bus.
Unfortunately there is no (known) documentation on what the minimum time
to wait after releasing the reset on an internal PHY so play safe and
take the one for the external variant. Only wait after the last GPHY
firmware is loaded to not slow down the initialization too much (
xRX200 has two GPHYs but newer SoCs have at least three GPHYs).

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1:
- move the msleep() closer to the actual loop over all GPHY instances
  as suggested by Andrew
- added Andrew's Reviewed-by (thank you!)


 drivers/net/dsa/lantiq_gswip.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 74db81dafee3..09701c17f3f6 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -26,6 +26,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/firmware.h>
 #include <linux/if_bridge.h>
@@ -1837,6 +1838,16 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 		i++;
 	}
 
+	/* The standalone PHY11G requires 300ms to be fully
+	 * initialized and ready for any MDIO communication after being
+	 * taken out of reset. For the SoC-internal GPHY variant there
+	 * is no (known) documentation for the minimum time after a
+	 * reset. Use the same value as for the standalone variant as
+	 * some users have reported internal PHYs not being detected
+	 * without any delay.
+	 */
+	msleep(300);
+
 	return 0;
 
 remove_gphy:
-- 
2.29.2

