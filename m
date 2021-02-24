Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEF032372C
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 07:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhBXGNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 01:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhBXGM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 01:12:56 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225EBC06174A;
        Tue, 23 Feb 2021 22:12:16 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c11so643898pfp.10;
        Tue, 23 Feb 2021 22:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C87YIkKVKFI0DF8+vH+AndEGXxxyw3xKzlEeNU6y0vc=;
        b=bHHw2gywDdAUFeCpeLk3CTX99bSYtvvc1DJJ5Bi24nTF7MMaJWKz9LlCbKa1mwX4hy
         LKBfSOWvTfkAFlEjtYXgX3EEL3io0zWv5KIs5QvBJuW1dP81PGLl33uHjS2yhWVcnG1M
         3EZSHd36QgNx6zvrmMuwhb6Z1yaZOdmrBlzSqmqxcvQtIMG4uM4URbQq/eGAFUXvOLJg
         eZ1AhvkPd8Zapm2WQNdz2QdSVNB6zqOPaqYGma3NAF7io5mktQpsroil3waXPpqHnpsO
         A7KRVveZwN5/mJgghOHLFSmnswyyW9amP4DoZ7ZyctTgKT7Z8uO5F9H4DVxq2L215cQD
         znVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C87YIkKVKFI0DF8+vH+AndEGXxxyw3xKzlEeNU6y0vc=;
        b=aHm55P/6iZjIe7KvcuXiKVDk+AxynynyEfa+3vfovN73YL9pK256tUCPSdV1NE1/cn
         6pDP/Q7Rnf6c6E7WcPMyoHDis2FLXvxPMvw1h7bA7I1AK9dfbqwPS7cbV5CTQ3ivSdi6
         YZa8JKLf1Itk4coS8W419ZiiPmUHXA9JLy2m9IbfEC791ByoZpnd349WrJcqi5CW3bb2
         q0iC3fFKEif3NTN53dd4k0kIoFa+kEYkwONqDJ+lgmZ/lwLk+m8XGVdAcYQrYcKOsOl9
         NKavAMWLI1C4ChBaH4XcOdki7LZmGEhAanuxcek3Hor7PSiiOV50WpDWsCXOEqVP+swq
         CiOQ==
X-Gm-Message-State: AOAM531auVFmnaF/KPf8AxggipzY20LFEz6MkFZKCgv7LLcdLP0eai5j
        3yWu+lBvN9drTDoFxvZbDhw=
X-Google-Smtp-Source: ABdhPJxx27iwZoozg4I5N8jqrNc8CIXT2Bc99UOsVWNYodi7D6RHOPk9MvTW8VFYnf1BHuvUaF40sQ==
X-Received: by 2002:a63:da57:: with SMTP id l23mr11770660pgj.11.1614147135716;
        Tue, 23 Feb 2021 22:12:15 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.221])
        by smtp.gmail.com with ESMTPSA id g6sm1226533pfi.15.2021.02.23.22.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 22:12:14 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
Date:   Wed, 24 Feb 2021 14:12:05 +0800
Message-Id: <20210224061205.23270-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use port isolation registers to configure bridge offloading.
Remove the VLAN init, as we have proper CPU tag and bridge offloading
support now.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
This is not tested, as I don't have a RTL8366RB board. And I think there
is potential race condition in port_bridge_{join,leave}.

 drivers/net/dsa/rtl8366rb.c | 73 ++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a89093bc6c6a..9f6e2b361216 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -300,6 +300,12 @@
 #define RTL8366RB_INTERRUPT_STATUS_REG	0x0442
 #define RTL8366RB_NUM_INTERRUPT		14 /* 0..13 */
 
+/* Port isolation registers */
+#define RTL8366RB_PORT_ISO_BASE		0x0F08
+#define RTL8366RB_PORT_ISO(pnum)	(RTL8366RB_PORT_ISO_BASE + (pnum))
+#define RTL8366RB_PORT_ISO_EN		BIT(0)
+#define RTL8366RB_PORT_ISO_PORTS_MASK	GENMASK(7, 1)
+
 /* bits 0..5 enable force when cleared */
 #define RTL8366RB_MAC_FORCE_CTRL_REG	0x0F11
 
@@ -835,6 +841,15 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	/* Isolate user ports */
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		ret = regmap_write(smi->map, RTL8366RB_PORT_ISO(i),
+				   RTL8366RB_PORT_ISO_EN |
+				   BIT(RTL8366RB_PORT_NUM_CPU + 1));
+		if (ret)
+			return ret;
+	}
+
 	/* Set up the "green ethernet" feature */
 	ret = rtl8366rb_jam_table(rtl8366rb_green_jam,
 				  ARRAY_SIZE(rtl8366rb_green_jam), smi, false);
@@ -963,10 +978,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 			return ret;
 	}
 
-	ret = rtl8366_init_vlan(smi);
-	if (ret)
-		return ret;
-
 	ret = rtl8366rb_setup_cascaded_irq(smi);
 	if (ret)
 		dev_info(smi->dev, "no interrupt support\n");
@@ -977,8 +988,6 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
 		return -ENODEV;
 	}
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
@@ -1127,6 +1136,56 @@ rtl8366rb_port_disable(struct dsa_switch *ds, int port)
 	rb8366rb_set_port_led(smi, port, false);
 }
 
+static int
+rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
+			   struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_bitmap = 0;
+	int ret, i;
+
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		if (i == port)
+			continue;
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+					 0, BIT(port + 1));
+		if (ret)
+			return ret;
+
+		port_bitmap |= BIT(i);
+	}
+
+	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+				  0, port_bitmap << 1);
+}
+
+static int
+rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
+			    struct net_device *bridge)
+{
+	struct realtek_smi *smi = ds->priv;
+	unsigned int port_bitmap = 0;
+	int ret, i;
+
+	for (i = 0; i < RTL8366RB_PORT_NUM_CPU; i++) {
+		if (i == port)
+			continue;
+		if (dsa_to_port(ds, i)->bridge_dev != bridge)
+			continue;
+		ret = regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(i),
+					 BIT(port + 1), 0);
+		if (ret)
+			return ret;
+
+		port_bitmap |= BIT(i);
+	}
+
+	return regmap_update_bits(smi->map, RTL8366RB_PORT_ISO(port),
+				  port_bitmap << 1, 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1510,6 +1569,8 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.get_strings = rtl8366_get_strings,
 	.get_ethtool_stats = rtl8366_get_ethtool_stats,
 	.get_sset_count = rtl8366_get_sset_count,
+	.port_bridge_join = rtl8366rb_port_bridge_join,
+	.port_bridge_leave = rtl8366rb_port_bridge_leave,
 	.port_vlan_filtering = rtl8366_vlan_filtering,
 	.port_vlan_add = rtl8366_vlan_add,
 	.port_vlan_del = rtl8366_vlan_del,
-- 
2.25.1

