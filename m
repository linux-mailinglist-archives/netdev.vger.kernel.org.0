Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2549192C2E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgCYPW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36486 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727799AbgCYPW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so3173647wme.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DG4LZCfxfzCjr1pcaq6KqoTrPh/DJOB2QYJSudmozWg=;
        b=jI35jCtKYr7Na6GFLnsVGZ0dIQmy4zOz1QwsrxnNRrVLrfypo9qYJETUhmT0J95XUD
         cFdrsXyptO9jYTZVs8ZkYdLO6pD0rRFjbPZ8WzOX4rDQpy3Q+nrSgsc6fdMHROjDqF+2
         4NOm1AvXY/S7a5e3Wc/1ZVlcCeGBnKrds5gnyQNqW2MjXNpAQbGXl2vfJLDE1yzFc59x
         wAGM69/Dv4e9Y/G74RQ6G/OzFYyZNfGQLM8IvUw9QE9VaI8p/F20T4C5QKQhgPd8tUlI
         Y0FcXyMaASFizKkfZcQ0GKl+wIVIUb+vkURQAdjK27PhRKhW/hawEjEWfeKzKJE9mxYE
         Widg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DG4LZCfxfzCjr1pcaq6KqoTrPh/DJOB2QYJSudmozWg=;
        b=hEjITQKEuPs+shqgAXgN5djjkVsg2V/Bl5gwkJ1iiOrWfq+6O44XtsJN2UBD6N6LV9
         rLdh+T+eu2reXgIs23ZMXXznWhV8jTrLckuEXp+jdIOsl2tXDGMdaqylOVMJ1Q4odEsX
         MekbkktTbWhQYINQmULbC1w3jNjFQjIJlVsPItXxvHgblZ7IhLzuMYwesvLChQjrUPVD
         fKszQA752vb3bf5hBm78rmrXMsOgLCRd+hfgLoLDepM5brgbSs4mmiv8xXIaLI6vuu1J
         k4/jOIPa/XDKQMjELIKWWVCbU+Km2EEsK4HY9fwLLMRsQpvzCj2cdsIbIM7rzsa5BnUE
         PwXQ==
X-Gm-Message-State: ANhLgQ2hJEGrXbxQxY59QtjAKBdlPvbW0V48372p6DA3t0us/O0UlmMI
        nV3XtXYJsBa9iatCC44P5Cs=
X-Google-Smtp-Source: ADFU+vuQWAoHNtvaM+gjLIKWQOhdfxTFlIsoYFLtrFWvASl/i9VwgMk9YuM3DXKEib2OM0v9jY68jg==
X-Received: by 2002:a7b:c92d:: with SMTP id h13mr3885280wml.120.1585149744836;
        Wed, 25 Mar 2020 08:22:24 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 08/10] net: dsa: vsc73xx: Make the MTU configurable
Date:   Wed, 25 Mar 2020 17:22:07 +0200
Message-Id: <20200325152209.3428-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Instead of hardcoding the MTU to the maximum value allowed by the
hardware, obey the value known by the operating system.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

