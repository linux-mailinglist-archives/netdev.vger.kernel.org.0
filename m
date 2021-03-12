Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97856338A73
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 11:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhCLKo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 05:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhCLKoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 05:44:03 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F57BC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 02:44:03 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f1so45007525lfu.3
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 02:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1baDrExlQQDwSEksjNaiMalt/b6BJANT+WqeZilrdFc=;
        b=PbJsDyE0isCatc/AbsGTNSQ/JUrItpYcequqDjPBL82g4SwG5AGQhUQj7JOt7fcMsn
         vQEAHeQcfG9O7ZOli9cMlOQEMJQnzKoQt0GliIRbdcvVcqEVUW4MfyG3OHT/8Jhl1VVS
         4WS17VbQvtDmWqYqsd0pALGeykZCWkfiZ4brXB9UJvzHEOyzSysr/E+sUkV1Ze0a9+Kk
         43TruiyL3ym8zw3fYWdpG4lrgXbG1+p/AEn0Lwu0cudU3glSxZl1UZB5Bq2/fXZe2Hls
         PlqrGgee3LeZCM9Z4Y0C5S5cAOkxkp3HbUTESj2M/K0HEfNQ57Z1TKkGj5X9Mr4koCF8
         IJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1baDrExlQQDwSEksjNaiMalt/b6BJANT+WqeZilrdFc=;
        b=BXsgm/HRfVbV78XS0Ap9EGp8p77x7sbodDq4GIqHQMVsTM0Z7oCy16AQzVkMQQq6jf
         TvNMmg/ugisaH7/ejmwKpt0DrxeMLmd5Sjx8xcVwMGi9kvldWoTAJdWalWWf8imPCJQB
         khyrvj7UBNa3NcwzYCre13EV3liQhDoz+YLVzYrJEIVzTsZvQ4E0GluQM5xcef6iMNJw
         KnI7Dd5OHhAobzFKWcnmU0sF/wPINAXD5oRKQaoXoMQR2DS57sniMLKldQBYy0oDPaiJ
         J/25lbkMVkXjE0di8Go5wANF6miAr+KZAexVKHhWeJQ5TeWm5c7Y/tuqwXxGnTXxx5aZ
         QOjg==
X-Gm-Message-State: AOAM530UewG/v4V4e4ZoBWIu4s8yo+6hu8c36DeXoIodWhCHrjmNrvPA
        6J28rM968VPt5aOcMe50gco=
X-Google-Smtp-Source: ABdhPJxej737YfB3PNnjfjyX57FvDTEGxIQwjHip0XZnDnOTGb7bqO+7Hw9gw2b0j/j6g0372HBsCg==
X-Received: by 2002:a05:6512:3490:: with SMTP id v16mr5040305lfr.644.1615545841748;
        Fri, 12 Mar 2021 02:44:01 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id w5sm1676606lfu.179.2021.03.12.02.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 02:44:01 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 1/2] net: dsa: bcm_sf2: store PHY interface/mode in port structure
Date:   Fri, 12 Mar 2021 11:41:07 +0100
Message-Id: <20210312104108.10862-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It's needed later for proper switch / crossbar setup.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c | 16 ++++++++++++----
 drivers/net/dsa/bcm_sf2.h |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 4dedd6e0b11b..bc0dbc0daa1a 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -446,10 +446,11 @@ static void bcm_sf2_intr_disable(struct bcm_sf2_priv *priv)
 static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 				   struct device_node *dn)
 {
+	struct device *dev = priv->dev->ds->dev;
+	struct bcm_sf2_port_status *port_st;
 	struct device_node *port;
 	unsigned int port_num;
 	struct property *prop;
-	phy_interface_t mode;
 	int err;
 
 	priv->moca_port = -1;
@@ -458,19 +459,26 @@ static void bcm_sf2_identify_ports(struct bcm_sf2_priv *priv,
 		if (of_property_read_u32(port, "reg", &port_num))
 			continue;
 
+		if (port_num >= DSA_MAX_PORTS) {
+			dev_err(dev, "Invalid port number %d\n", port_num);
+			continue;
+		}
+
+		port_st = &priv->port_sts[port_num];
+
 		/* Internal PHYs get assigned a specific 'phy-mode' property
 		 * value: "internal" to help flag them before MDIO probing
 		 * has completed, since they might be turned off at that
 		 * time
 		 */
-		err = of_get_phy_mode(port, &mode);
+		err = of_get_phy_mode(port, &port_st->mode);
 		if (err)
 			continue;
 
-		if (mode == PHY_INTERFACE_MODE_INTERNAL)
+		if (port_st->mode == PHY_INTERFACE_MODE_INTERNAL)
 			priv->int_phy_mask |= 1 << port_num;
 
-		if (mode == PHY_INTERFACE_MODE_MOCA)
+		if (port_st->mode == PHY_INTERFACE_MODE_MOCA)
 			priv->moca_port = port_num;
 
 		if (of_property_read_bool(port, "brcm,use-bcm-hdr"))
diff --git a/drivers/net/dsa/bcm_sf2.h b/drivers/net/dsa/bcm_sf2.h
index 1ed901a68536..a0fe0bf46d9f 100644
--- a/drivers/net/dsa/bcm_sf2.h
+++ b/drivers/net/dsa/bcm_sf2.h
@@ -44,6 +44,7 @@ struct bcm_sf2_hw_params {
 #define BCM_SF2_REGS_NUM	6
 
 struct bcm_sf2_port_status {
+	phy_interface_t mode;
 	unsigned int link;
 	bool enabled;
 };
-- 
2.26.2

