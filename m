Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64197194BAC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCZWlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:41:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40790 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCZWlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:41:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so10024809wmf.5
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 15:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sx2clxuTbIqAwT1Jf/4nrCEiE87w5o3flWc3jxp/iSM=;
        b=T7hatM7mYjH8tCDNxogloHgoRgmqyYZn3YDutYqXpqV2/WJTTJ2Z2yu60wC/6UnE6f
         JRzXvUKAW2Vog3l/niBNgTy2i7d4Z0dvuw7Ov3aXbO7t1QLv45inQvp4ijMBPHvz8Pzk
         ITGaaUiQ5jgLmOWcGvgtM71KbZOOZcUTNnN1G55H73Xqy1KixUoUWbscJ/53enwE/XS9
         61wYVmnotpTBGt4+vdO0WAOcjz6cfbEHPM9FhwxvLyXZpAm7OsfDjGXRYc3AlOGQBx4C
         hDluV5nQcBF1SLxcJzu4dfvn49vsBlvOnXQ8C8rImjm3MQSJl4S5Shjw5sq5okyA72z7
         e9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sx2clxuTbIqAwT1Jf/4nrCEiE87w5o3flWc3jxp/iSM=;
        b=FOUV/6peIvKkg2KK5alN7pYHIsrZQBhBudgWY3dpv9qHF21Rd4sEXeEgupq3s5ndQk
         kgpqjAgtA5VhtEPpFfsWs4PGVpHFYdJVbEvpUde5NYKjPGILpkxP+oqJ1Lu/rDnh45uq
         ac3cKVIhxlPwEDHCm81lkxi2kq9N1zIZinpk0qjT7QoQUqR58VmLNZnywfLVkX93ehYp
         aXpZPl7xiotU0FN72rmrljZkqqVEy1Wa6V6YqC/Jpz8leV3Mnkru3NMQfBKMtyE+JyIT
         ydzm6AU9rc9X7CVI6VIXxmaOPlvu4vmvdC+yIpKCTKVUI4a9dqMK8XcDX32kqO3DyE6t
         t0UA==
X-Gm-Message-State: ANhLgQ2e9PrZabjW38S9pWkiBKkAcKEyPFPiP4xQe/G57A+nW1nzE5jA
        BD+A3Kq6UfDj5dcAh2FEvCYNz53UL26jLQ==
X-Google-Smtp-Source: ADFU+vsT8j810zGgbPieGONKBIPmP7a1HcswG7DcwKWQ96v2KN771ynvW43lBRdr9Yw7RmBuyoRhBg==
X-Received: by 2002:a5d:4683:: with SMTP id u3mr688570wrq.248.1585262470925;
        Thu, 26 Mar 2020 15:41:10 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t81sm5522783wmb.15.2020.03.26.15.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 15:41:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 7/8] net: dsa: vsc73xx: make the MTU configurable
Date:   Fri, 27 Mar 2020 00:40:39 +0200
Message-Id: <20200326224040.32014-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200326224040.32014-1-olteanv@gmail.com>
References: <20200326224040.32014-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Instead of hardcoding the MTU to the maximum value allowed by the
hardware, obey the value known by the operating system.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/vitesse-vsc73xx-core.c | 30 +++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 6e21a2a5cf01..19ce4aa0973b 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -664,16 +664,6 @@ static void vsc73xx_init_port(struct vsc73xx *vsc, int port)
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
@@ -1030,6 +1020,24 @@ static void vsc73xx_get_ethtool_stats(struct dsa_switch *ds, int port,
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
@@ -1041,6 +1049,8 @@ static const struct dsa_switch_ops vsc73xx_ds_ops = {
 	.get_sset_count = vsc73xx_get_sset_count,
 	.port_enable = vsc73xx_port_enable,
 	.port_disable = vsc73xx_port_disable,
+	.port_change_mtu = vsc73xx_change_mtu,
+	.port_max_mtu = vsc73xx_get_max_mtu,
 };
 
 static int vsc73xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
-- 
2.17.1

