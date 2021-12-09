Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24A646E16B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhLIEL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhLIEL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:11:28 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239BFC061746;
        Wed,  8 Dec 2021 20:07:55 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d24so7628661wra.0;
        Wed, 08 Dec 2021 20:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQRX7Zmt/Icb9VbGplcV9OjkCDPdJHwADYXq6Kn6wtQ=;
        b=aoe/aYofO+GOTGW+4kqLVWC5CyGuWcYZlYykZSLNI/h8De+zvlX7Px0XHhZ9RQdOnc
         nSwkU6kuTQV1zgyQo+Jxux7FxOjaik9/OU0IsLw4/lj+34B0S6fVZht0aQOc4PWbteNV
         HryKuarSpbeRwdSrUM7635MOwzRRxHZATLmmG+uv5PNcgLpiKZzy+jnQVRTOSTyNlvmt
         BTmal0QjKM1ERFfTgBZqnzMLYQBcERbl8Yv9yaQGNsFixU8FQT6LjVOIXPgvAG9cJldi
         NRMgZQrO6O/lYhpgQ2IxXo09MhcHei9OnauS4GnnPIHCNN87fC2rMjqGGYp1gjIRXdTH
         xQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQRX7Zmt/Icb9VbGplcV9OjkCDPdJHwADYXq6Kn6wtQ=;
        b=QX64VpYPGFdhNrSr7K1bdmkO8oVKTLBguw5UY1SJD5cg+QjOI7p5c41WPlmT6GcbiE
         eW0F21B8ANmE2uqecTWZ09PnQgG9xYFdNbyjXOE+hvwxgk3Jx63PMhDdtY3NI5uhmMe8
         g/U6hPHsdQsCm7BU5i38m/ESMFVNd8djKnG2Blt8wsujYKygwGghRW4sw0KhS9Nkfcnc
         8vT1YJNETHToBjM3K9SGLMQcFXhHVVFL6mO1RM8rELZzzQPGPL7Hgenu92NuH1K0k8I2
         gp/Omeb2x4Yc2DwFnWkRkAI+tg4ojiXjFxL9D6oF5HWaGWF92J/09cDU6bfDp2UZcRNA
         Df+w==
X-Gm-Message-State: AOAM530xzfkFoRhqpuqzUqB4x39mJzNEBYdKDNnxvRgqTrt3paxkvOaU
        A00lE4DONxxYT3Um70NOvV0=
X-Google-Smtp-Source: ABdhPJxoi2oCqBQE/YtOtfZk2WX2PS2mzHcTgCu74TRau/CEb6afyQHUBkoab301vf4skfm7x8Dr5g==
X-Received: by 2002:a05:6000:18ad:: with SMTP id b13mr3633194wri.195.1639022873717;
        Wed, 08 Dec 2021 20:07:53 -0800 (PST)
Received: from localhost.localdomain ([39.48.134.175])
        by smtp.gmail.com with ESMTPSA id u23sm4791137wru.21.2021.12.08.20.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 20:07:53 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     kabel@kernel.org, kuba@kernel.org, andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, amhamza.mgc@gmail.com
Subject: [PATCH v4] net: dsa: mv88e6xxx: error handling for serdes_power functions
Date:   Thu,  9 Dec 2021 09:07:46 +0500
Message-Id: <20211209040746.9299-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207140647.6926a3e7@thinkpad>
References: <20211207140647.6926a3e7@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added default case to handle undefined cmode scenario in
mv88e6393x_serdes_power() and mv88e6393x_serdes_power() methods.

Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
Fixes: 21635d9203e1c (net: mvpp2: fix XDP rx queues registering)
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
Changes in v4:
Added fix tag and synced patch with latest repo
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 55273013bfb5..2b05ead515cd 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -830,7 +830,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err = 0;
+	int err;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
@@ -842,6 +842,9 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
 		err = mv88e6390_serdes_power_10g(chip, lane, up);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (!err && up)
@@ -1541,6 +1544,9 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 	case MV88E6393X_PORT_STS_CMODE_10GBASER:
 		err = mv88e6390_serdes_power_10g(chip, lane, on);
 		break;
+	default:
+		err = -EINVAL;
+		break;
 	}
 
 	if (err)
-- 
2.25.1

