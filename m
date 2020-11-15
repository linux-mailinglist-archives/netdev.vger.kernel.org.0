Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4442B3351
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgKOKJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgKOKJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 05:09:26 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4586C0613D1;
        Sun, 15 Nov 2020 02:09:25 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id w24so20934734wmi.0;
        Sun, 15 Nov 2020 02:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9KClr1LyDLvyufZIL58bcrROX5Pgh+5C+koJbGrnTx4=;
        b=hQBr53uwtMSDG1+akUP3QAcFKRPXnPsFUMZzcvujaZfRFcw/Z/gwZ0MUH5YPuinPbm
         PLSkkoQ2PBzRG2LC3sqS4QA7AYgLDawHSdGnnS3JxGaqRpdDvN2YTaGtOWdh7ajsHda5
         H6Nc0sYgPSbP7cnjGtPFTF8HDtvLSbeimzQg+SDkdIyrCzkC9PQVe8xWkn7GXhEkOe3e
         ZSwBrUp/NtVV738VLSczbDfuuGlslK+l77m1NncIou5VVVpHYarflc2f/jHWFvM4RMvj
         4BYThR6KwZe6AE/lhJy/Pu/IGqs7h67oOTrevb5QS4jpx4wM6UjPkDhyh83RYWNAvAxX
         29xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9KClr1LyDLvyufZIL58bcrROX5Pgh+5C+koJbGrnTx4=;
        b=NGc3DMhNViSMVh+wnAooWNSE4pT2OYMJcbq9OfIR5Dilsw/CXKlh543zlKuJBkBWgd
         deiDlXZN9W0knPaTXeXP/7qJwSZ9nrIOJK2Kz9bfZet1r4BDF5GTAVRsvEwfxIGCsZBT
         kGTuCDFNv1pmf2/H0v38PGRdScSTRlM5UgPr8N5bJHQXC3MkYddbdOxKicb4v/dC16t1
         GwCf31NTgX4TC7ZKyx/cWS1TElt1V8/0wsafr4UvOP1MQWE9qfJ33Rk2UXrJa1sB62m2
         dNrxG1Eo73/dhbxRMOo8drL4YGIZ5FWFLqm6DAHHGMr7YKAU8AYCty6Nsfv+d6+flxdh
         uSXg==
X-Gm-Message-State: AOAM532a0EfHU7HBwHq4IeJhGVEWDu3qmmEmiTv4YrWL6Zcr9DwrY/iG
        v8fYbW6JsLb1lBwuYYlOFOM=
X-Google-Smtp-Source: ABdhPJzpcVgNsTOTJvbGuj4s8M5SGc7Bmyrzw8RbDW2RWBCoRnYc2FSAagC+H8eC97OY6LMGmEe+vw==
X-Received: by 2002:a1c:ac03:: with SMTP id v3mr10643221wme.9.1605434964581;
        Sun, 15 Nov 2020 02:09:24 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id h15sm17959246wrw.15.2020.11.15.02.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:09:24 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: lantiq: Wait for the GPHY firmware to be ready
Date:   Sun, 15 Nov 2020 11:06:23 +0100
Message-Id: <20201115100623.257293-1-martin.blumenstingl@googlemail.com>
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
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 74db81dafee3..0a25283bdd13 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -26,6 +26,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/firmware.h>
 #include <linux/if_bridge.h>
@@ -1894,6 +1895,16 @@ static int gswip_probe(struct platform_device *pdev)
 			dev_err(dev, "gphy fw probe failed\n");
 			return err;
 		}
+
+		/* The standalone PHY11G requires 300ms to be fully
+		 * initialized and ready for any MDIO communication after being
+		 * taken out of reset. For the SoC-internal GPHY variant there
+		 * is no (known) documentation for the minimum time after a
+		 * reset. Use the same value as for the standalone variant as
+		 * some users have reported internal PHYs not being detected
+		 * without any delay.
+		 */
+		msleep(300);
 	}
 
 	/* bring up the mdio bus */
-- 
2.29.2

