Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581B110802D
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 20:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKWTtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 14:49:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33847 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfKWTtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 14:49:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so12697394wrr.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 11:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q5Bm4DvgvZer6rntvEmWnyDps+9eYq4tdX1viVTj+ig=;
        b=ZAafM+B5p4NHttarrcYJVv8r+9N/InfSwywypUyEK8WhpFUxX5Z52vUZS1HN7J67ts
         pmk0m80KYFUOSU5XZqUWobkbQiIVvb2uLZU76LaCBJQcTByStAucAOmrfgjNsrlK8yxs
         i34vtE8pYIndNuy4FOA6BgojAGKHy/CKK0I4hfj5o6hLw2cPXAVq+frhcpPK+ZMY84DL
         YvDsKxpJKmwn2WxDBTLwVvx2dHewIWM/cBoS+5fYEqVd8SBjogB69b7z9b2s4tZN3DnZ
         paWaz3aGV1vUlo2kE+GCuUZx6rStoCRN4hYZCZGVU+NjWIDufphh8Q501BxWBIuq3txQ
         s+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q5Bm4DvgvZer6rntvEmWnyDps+9eYq4tdX1viVTj+ig=;
        b=bPFaflDl7pMEH6v5EpugRuHDrofrT0GfR+LzbPIqgcmUKHk/1p5cO8g9yaFxVSdlhX
         teSScqr/esWc+XyoAaPyAXr1H1WMIwJDoLoMiYgt9ZVj6vwkOdvj3Ki+OKCOlyCcK4te
         Yjjud26jDj+gfFNrbaGSZq4iDuUVdU5ogXYA45bYTRgw527Iix4GZF4bk9/+2c70cNdK
         s7o45nllRQ/v91g4GHiV2+w7p60dd1G7OidbtonF76rQEkt8QudeajOU+AoJ+vBLP2zw
         vp9jNDdFiR2pA7t3flKgRH5L5YO3IKoFJ67bWcAH/pHFW6WxOxt/OvOWBXQ67tFRQ6Rb
         VdrA==
X-Gm-Message-State: APjAAAVOCkuTF6BsZhBF056F4wOm2hgmYETXRFL2WrcrPKR0GevV38Le
        aBhBUq5GoNk99tFKdVNWk6k=
X-Google-Smtp-Source: APXvYqy5oPm+p1YBl74L0Zs0WuWQwSCCpradRlcjYOrfEkyEvXVYEkZCOThtSSNtiO9Qg7KCO4bPkg==
X-Received: by 2002:adf:e682:: with SMTP id r2mr24056203wrm.358.1574538579400;
        Sat, 23 Nov 2019 11:49:39 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id j10sm3300569wrx.30.2019.11.23.11.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 11:49:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: vsc73xx: Make the MTU configurable
Date:   Sat, 23 Nov 2019 21:48:44 +0200
Message-Id: <20191123194844.9508-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191123194844.9508-1-olteanv@gmail.com>
References: <20191123194844.9508-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of hardcoding the MTU to the maximum value allowed by the
hardware, obey the value known by the operating system.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 30 +++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 42c1574d45f2..eed98566e2bf 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -663,16 +663,6 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
 		      VSC73XX_MAC_CFG_TX_EN |
 		      VSC73XX_MAC_CFG_RX_EN);
 
-	/* Max length, we can do up to 9.6 KiB, so allow that.
-	 * According to application not "VSC7398 Jumbo Frames" setting
-	 * up the MTU to 9.6 KB does not affect the performance on standard
-	 * frames, so just enable it. It is clear from the application note
-	 * that "9.6 kilobytes" == 9600 bytes.
-	 */
-	vsc73xx_write(vsc, VSC73XX_BLOCK_MAC,
-		      port,
-		      VSC73XX_MAXLEN, 9600);
-
 	/* Flow control for the CPU port:
 	 * Use a zero delay pause frame when pause condition is left
 	 * Obey pause control frames
@@ -1029,6 +1019,24 @@ static void vsc73xx_get_ethtool_stats(struct dsa_switch *ds, int port,
 	}
 }
 
+static int vsc73xx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct vsc73xx *vsc = ds->priv;
+
+	return vsc73xx_write(vsc, VSC73XX_BLOCK_MAC, port,
+			     VSC73XX_MAXLEN, new_mtu);
+}
+
+/* According to application not "VSC7398 Jumbo Frames" setting
+ * up the MTU to 9.6 KB does not affect the performance on standard
+ * frames. It is clear from the application note that
+ * "9.6 kilobytes" == 9600 bytes.
+ */
+static int vsc73xx_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	return 9600;
+}
+
 static const struct dsa_switch_ops vsc73xx_ds_ops = {
 	.get_tag_protocol = vsc73xx_get_tag_protocol,
 	.setup = vsc73xx_setup,
@@ -1040,6 +1048,8 @@ static const struct dsa_switch_ops vsc73xx_ds_ops = {
 	.get_sset_count = vsc73xx_get_sset_count,
 	.port_enable = vsc73xx_port_enable,
 	.port_disable = vsc73xx_port_disable,
+	.change_mtu = vsc73xx_change_mtu,
+	.get_max_mtu = vsc73xx_get_max_mtu,
 };
 
 static int vsc73xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
-- 
2.17.1

