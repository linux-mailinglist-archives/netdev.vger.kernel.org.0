Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D079C43B48
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfFMP1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:27:39 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35773 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfFMLf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:35:27 -0400
Received: by mail-lf1-f66.google.com with SMTP id a25so14815384lfg.2
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eIUb7QFUL1xRuXHbQmKp0h/Hfg3SUdrT+TZHlG6xJOU=;
        b=lTbgR2Xwu/whe+o46UX1RhLEox3cGUvTjCYuIrWyUWP7B8w2/vqQ1JEwU8d4RzAOBl
         pm1I3n7wUNVsmwb75kOj2f4XgoOo90I16rzzqyzmSNV+d0nKj9uTjdAz7i+a1Nc3vo9Q
         Z1vrTXsWQC6WtLCLAYgRcoalRS/0OaAQJ3alMagVRjXUlIgzjxfqRhCw1nt1XgzncvEe
         /dDaVsbJ3cRCuK8BFtOz6A7FTh7hVfMKxupY9W+GROwzJqgXj7d4kMVgCCsq9RWzOkJC
         OXJBxR4NZTC9KVlGZ5uW2zX38Uy/XhFbnv/cW8w+wHiW+EojI4Y1jgNubNYiwslNSS9P
         rNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eIUb7QFUL1xRuXHbQmKp0h/Hfg3SUdrT+TZHlG6xJOU=;
        b=ZJmjLy2F2n7J5CGLBW5g5WNaG7ps8mfN6x88t+jR/rNd3SKhNnqogrtuk46gAkeTbn
         ECedgWOUqpX9tWd7Bhq0iD+b43NpfK/N1QYzAH0Ao3SnybDMpb/mIoGealQEZyow1pd8
         A8ZTu+YHGjC38mIK772jLST+M9aO4Zb9JSdLPOy4gpnkyem8jSAV3bVRvnH2vF/4Dwt4
         qlvczPJCkH9Vtzezy+t8oXbYagltZxJTdWFP7vziP9tD6urs05HYUMF8sz/Kozka+FWx
         ze5qES+JCL9Mg/UGbhBa/3KpNy6tcV5GMsl8+2W/SrlY28gYcdNEEFPLtN3T1ujYuiSs
         cf4A==
X-Gm-Message-State: APjAAAUCsCsArfG2N9BH+tQt1YghjQTOnXyY4/3E4Hb88AGL92JmgdPg
        U4tKqD6GPMEOppjl3R3Gxe81UQ==
X-Google-Smtp-Source: APXvYqwv6wz6nCObWy2ZHT5xYou7pip7nnuJWYUnTo0YChkQcsvkhV1jKxP4YeJMIFfqP2xtnJp7hw==
X-Received: by 2002:ac2:4202:: with SMTP id y2mr26100657lfh.178.1560425724489;
        Thu, 13 Jun 2019 04:35:24 -0700 (PDT)
Received: from localhost (c-1c3670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.28])
        by smtp.gmail.com with ESMTPSA id r2sm541985lfi.51.2019.06.13.04.35.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:35:23 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linus.walleij@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH v3] net: dsa: fix warning same module names
Date:   Thu, 13 Jun 2019 13:35:03 +0200
Message-Id: <20190613113503.4839-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with CONFIG_NET_DSA_REALTEK_SMI and CONFIG_REALTEK_PHY
enabled as loadable modules, we see the following warning:

warning: same module names found:
  drivers/net/phy/realtek.ko
  drivers/net/dsa/realtek.ko

Rework so the driver name is realtek-smi instead of realtek.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/net/dsa/Makefile                              | 4 ++--
 drivers/net/dsa/{realtek-smi.c => realtek-smi-core.c} | 2 +-
 drivers/net/dsa/{realtek-smi.h => realtek-smi-core.h} | 0
 drivers/net/dsa/rtl8366.c                             | 2 +-
 drivers/net/dsa/rtl8366rb.c                           | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/net/dsa/{realtek-smi.c => realtek-smi-core.c} (99%)
 rename drivers/net/dsa/{realtek-smi.h => realtek-smi-core.h} (100%)

diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index fefb6aaa82ba..d99dc6de0006 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -9,8 +9,8 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
-obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek.o
-realtek-objs			:= realtek-smi.o rtl8366.o rtl8366rb.o
+obj-$(CONFIG_NET_DSA_REALTEK_SMI) += realtek-smi.o
+realtek-smi-objs		:= realtek-smi-core.o rtl8366.o rtl8366rb.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
diff --git a/drivers/net/dsa/realtek-smi.c b/drivers/net/dsa/realtek-smi-core.c
similarity index 99%
rename from drivers/net/dsa/realtek-smi.c
rename to drivers/net/dsa/realtek-smi-core.c
index ad41ec63cc9f..dc0509c02d29 100644
--- a/drivers/net/dsa/realtek-smi.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -40,7 +40,7 @@
 #include <linux/bitops.h>
 #include <linux/if_bridge.h>
 
-#include "realtek-smi.h"
+#include "realtek-smi-core.h"
 
 #define REALTEK_SMI_ACK_RETRY_COUNT		5
 #define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
diff --git a/drivers/net/dsa/realtek-smi.h b/drivers/net/dsa/realtek-smi-core.h
similarity index 100%
rename from drivers/net/dsa/realtek-smi.h
rename to drivers/net/dsa/realtek-smi-core.h
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 6dedd43442cc..fe5d976b0b10 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -11,7 +11,7 @@
 #include <linux/if_bridge.h>
 #include <net/dsa.h>
 
-#include "realtek-smi.h"
+#include "realtek-smi-core.h"
 
 int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used)
 {
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 40b3974970c6..a268085ffad2 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -20,7 +20,7 @@
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 
-#include "realtek-smi.h"
+#include "realtek-smi-core.h"
 
 #define RTL8366RB_PORT_NUM_CPU		5
 #define RTL8366RB_NUM_PORTS		6
-- 
2.20.1

