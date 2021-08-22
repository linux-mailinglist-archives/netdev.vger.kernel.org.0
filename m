Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D423F4136
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 21:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhHVTd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 15:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbhHVTdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 15:33:25 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB12EC061757
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:43 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s25so10064181edw.0
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 12:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t/57/7Ra/e8dihd9Z1Y6uUjnPgEzQmajUXKvHAVuv2o=;
        b=KskLkgGD8JaNGD7ASOLh1s3nv+GQU/By7BGMuPpogHKd98UmycDTDIp+JL52TOseZj
         KSonxBFgsSDlnwdUFw/bXEAZ59NcjEBqJoaEqYuTTyfRL1rfM98dcAKuqwUcuCwcgl1J
         PN4qN2J1RbDUKZofcxhYZEYxXW+OIFtDC5Mkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t/57/7Ra/e8dihd9Z1Y6uUjnPgEzQmajUXKvHAVuv2o=;
        b=qdifO8z5gzPEl4OzEcNAtB2Itj48VvQtA7wVPxtsiOWfpPXo8xu3/F1CJuY1gcYgim
         zk/YQYoCR7Cy/ykbVtkL8vpcOnsKcdTrTxCPVIrZb6gKcn7tj6j8YSznrYJKOU0KrVOy
         Nev8BPB/CkC3oLzA1g3mw2bul8op7uFuUXPM4FyqvjqcsAEpqWleFCAQ8i53S4Ut14Tu
         cu5mPpTp55eIcXPOY6gpbHvg7XRf+Qx5JNKjjLT+nA9jMukvbJzvKMqaJVlz4CXrsRG9
         IISM6m3wDXbp7j6ceZyhjjTmtZ2iF2DAvybATwip+NvV3YdjxACnF89IkQw2OOY/toZ2
         /PVw==
X-Gm-Message-State: AOAM531StRER3mhNbmYIclMwTgE8+7NbDk8DByExXS2PDJCeIC1nSZlP
        u2PxnTNKjVWFC89RGs1gLXaKdw==
X-Google-Smtp-Source: ABdhPJyOalP5cgOvTIbjQBcjni7YYpjDwoLN4S5AIgJBwrMoFXLDQal+RH27EMs/BQI8kdNO20bI5g==
X-Received: by 2002:a05:6402:4406:: with SMTP id y6mr32848397eda.242.1629660762281;
        Sun, 22 Aug 2021 12:32:42 -0700 (PDT)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cn16sm7780053edb.9.2021.08.22.12.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 12:32:41 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     mir@bang-olufsen.dk, alvin@pqrs.dk,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free bug on module unload
Date:   Sun, 22 Aug 2021 21:31:39 +0200
Message-Id: <20210822193145.1312668-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822193145.1312668-1-alvin@pqrs.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

realtek-smi-core fails to unregister the slave MII bus on module unload,
raising the following BUG warning:

    mdio_bus.c:650: BUG_ON(bus->state != MDIOBUS_UNREGISTERED);

    kernel BUG at drivers/net/phy/mdio_bus.c:650!
    Internal error: Oops - BUG: 0 [#1] PREEMPT_RT SMP
    Call trace:
     mdiobus_free+0x4c/0x50
     devm_mdiobus_free+0x18/0x20
     release_nodes.isra.0+0x1c0/0x2b0
     devres_release_all+0x38/0x58
     device_release_driver_internal+0x124/0x1e8
     driver_detach+0x54/0xe0
     bus_remove_driver+0x60/0xd8
     driver_unregister+0x34/0x60
     platform_driver_unregister+0x18/0x20
     realtek_smi_driver_exit+0x14/0x1c [realtek_smi]

Fix this by duly unregistering the slave MII bus with
mdiobus_unregister. We do this in the DSA teardown path, since
registration is performed in the DSA setup path.

Cc: Linus Walleij <linus.walleij@linaro.org>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek-smi-core.c | 6 ++++++
 drivers/net/dsa/realtek-smi-core.h | 1 +
 drivers/net/dsa/rtl8366rb.c        | 8 ++++++++
 3 files changed, 15 insertions(+)

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index 8e49d4f85d48..6992b6b31db6 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -383,6 +383,12 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi)
 	return ret;
 }
 
+void realtek_smi_teardown_mdio(struct realtek_smi *smi)
+{
+	if (smi->slave_mii_bus)
+		mdiobus_unregister(smi->slave_mii_bus);
+}
+
 static int realtek_smi_probe(struct platform_device *pdev)
 {
 	const struct realtek_smi_variant *var;
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index fcf465f7f922..6cfa5f2df7ea 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -119,6 +119,7 @@ struct realtek_smi_variant {
 int realtek_smi_write_reg_noack(struct realtek_smi *smi, u32 addr,
 				u32 data);
 int realtek_smi_setup_mdio(struct realtek_smi *smi);
+void realtek_smi_teardown_mdio(struct realtek_smi *smi);
 
 /* RTL8366 library helpers */
 int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used);
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6a..6537fac7aba4 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -982,6 +982,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+static void rtl8366rb_teardown(struct dsa_switch *ds)
+{
+	struct realtek_smi *smi = ds->priv;
+
+	realtek_smi_teardown_mdio(smi);
+}
+
 static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
 						      int port,
 						      enum dsa_tag_protocol mp)
@@ -1505,6 +1512,7 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
 static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
+	.teardown = rtl8366rb_teardown,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
 	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
-- 
2.32.0

