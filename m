Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E466E195F5C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgC0T4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:56:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51053 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbgC0T4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:56:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id d198so12786781wmd.0
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Uk/DxC/DTQPMtIkU41WABD+Ug4bgzW/pJL+PmSxEaYk=;
        b=S2uUCIah9csHb+NiKgPeJy1RQkET0AgPtw2N3ywSAalltNEuXWlt3bYpJuGmuDCUPg
         eXjym1T2wNgBZl9Oee09cpH7cbDSNh+w41fwTeY7/sIRAdbEpO3gzi+OAuJ95XOCMIkR
         KorH2W+yojA05hSEMzyV6RYLKVWysCwvQP/VbCKHjtZuaej4oQ/Zj6DO1kGMTlfH1m94
         3eJoPdxlB0H09QhYrISqjQSUfGjgHKAY8roxOsO9SlKwa8nm9QSp0ExAnSG55HQqmm6E
         z/jfNgA5BvX9uDvcQCWgYxi7pgtnADRdYZUEArWWYRjtmNNR0R/JyvQEHZnu1j9esIeX
         vd5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Uk/DxC/DTQPMtIkU41WABD+Ug4bgzW/pJL+PmSxEaYk=;
        b=hG5bHnfAMBgG1A4BnAX+clvEbhJgkDOHYnHUCDSAOlNyxrlH7PZu6wexoEkhYK3lBe
         LhaMeLrOyMSdv+Ue44mfa4toLHMHM9ILWR8Xb0yswSckU9CACBlU0X47V29PVKVlap5Z
         iUbNFjYys0GV0QECWi1ofI/R25n0ifNGLgaJMh7qGJwnY+Q+96w/roqaBTnUOkm87lZT
         QS0+LAdlMw0ty/vUCvos+dH6Ifs/KKq4pKbeUDqjpQvwSSyWlahcovT14epuhybz0yiH
         p5WJWwkShD2rHaSm36JrZImy+q8Db2ZhL63WPMX05nN3VS67cLppYzY0whar20sIIOBp
         bRPg==
X-Gm-Message-State: ANhLgQ0feglDmNiRngPRSpwaUj1B0XVGlGSDVJxS7KOelzGx+HVHMTns
        J8q84GniveXocPvPHZd9Pnc=
X-Google-Smtp-Source: ADFU+vuc/5Ob4Aie2aUyMwMZj4JdQtY7AwPkRaNhQ+9H8BME7fBfs5KdSnyb5G0+XRJePNwTbC+itQ==
X-Received: by 2002:a05:600c:cc:: with SMTP id u12mr383836wmm.176.1585338963219;
        Fri, 27 Mar 2020 12:56:03 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z19sm10089479wrg.28.2020.03.27.12.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 12:56:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 7/8] net: dsa: vsc73xx: make the MTU configurable
Date:   Fri, 27 Mar 2020 21:55:46 +0200
Message-Id: <20200327195547.11583-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200327195547.11583-1-olteanv@gmail.com>
References: <20200327195547.11583-1-olteanv@gmail.com>
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
Changes in v4:
None.

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

