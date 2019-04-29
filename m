Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2328DDA25
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfD2ASk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33013 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfD2ASM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id z6so8269881wmi.0;
        Sun, 28 Apr 2019 17:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ReC0NB4EcDDzZP8++5EwDoBkw/g+orXNdcKDDbqW+HQ=;
        b=ZR48QrW/KybH/VGaMREEftVo/F8tXR+/QGLO11Fv5h0f24BM6LNG/W8+ElsHpTHMkB
         oc9alD4tJHFQY7Lx5KJazjDqL80Utp5S0DEBLxNsK40t7X9N/Km3SavGskcvdYLYw3nM
         Hr3l7gNwIVI/kP6hE1Ap7ITkcvyN605iiQ36t9teIj0BjOpGzMnx8jXC8sSZBKTNYUw1
         gfIA1ysTkkWI4DOviUYou12WtSckiCD5mWUYbdyPP08OpIr3yaS6lKTvncNzf8+jJz0D
         5V2CfgrrJ/kLdyyObdwBIfElUybU2VasrB4+uPeFKr+LC1WF1kDSWjh+59Pph1OCbRuv
         vvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ReC0NB4EcDDzZP8++5EwDoBkw/g+orXNdcKDDbqW+HQ=;
        b=scZQGjZARbtm+V0aMSp/gHhK+JvEEWksW7y5T95kHJwo3CoK9AcT9dvzEsOyOMJN9a
         g5G4EfGgUxluwaGT3DVRdIzJifpSJGUypsdIiXAvWTfMfL/Mfeu5PD4gdLCCME5hlugn
         wtCjFto27mrqwELckLkDFlFKu1tZycd+a/LNx/bBB4a5aGQ9Y+Vq6CJwA+buR7XhhDF8
         cI3vQGOhamS9IV2S4vJCsyM/cm64KENpmeIx6WsC3cxeOM5IlIMmnJmFPQtVgrQ3tQZW
         Dioxpf2d0aMTOYYaVXxcAsCMp0p0ToIX1IVFZdk2imsibJd/xOYjz3urBXTH8/4rL7zR
         JK0w==
X-Gm-Message-State: APjAAAUVP9+W+Li7mmzQCH7CVaIBVOyMww//e5aziYuPlpZpsA3o+KYg
        Sv/SyntcjwRaG52I5V6sScE=
X-Google-Smtp-Source: APXvYqyDdsSW8lh2QJEPo8alxCOwacM0ncr1vWBcTK8dbJEOYzqEHpH928aiG382uv2T9yNU4TJBUw==
X-Received: by 2002:a1c:2d91:: with SMTP id t139mr16197420wmt.102.1556497089918;
        Sun, 28 Apr 2019 17:18:09 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 08/12] net: dsa: sja1105: Add support for configuring address aging time
Date:   Mon, 29 Apr 2019 03:17:02 +0300
Message-Id: <20190429001706.7449-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If STP is active, this setting is applied on bridged ports each time an
Ethernet link is established (topology changes).

Since the setting is global to the switch and a reset is required to
change it, resets are prevented if the new callback does not change the
value that the hardware already is programmed for.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:
Patch is new.

 drivers/net/dsa/sja1105/sja1105.h      |  4 ++++
 drivers/net/dsa/sja1105/sja1105_main.c | 29 ++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f7195352d235..d91586a6f83e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -12,6 +12,10 @@
 #define SJA1105_NUM_PORTS		5
 #define SJA1105_NUM_TC			8
 #define SJA1105ET_FDB_BIN_SIZE		4
+/* The hardware value is in multiples of 10 ms.
+ * The passed parameter is in multiples of 1 ms.
+ */
+#define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
 /* Keeps the different addresses between E/T and P/Q/R/S */
 struct sja1105_regs {
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 28b11c7a81e7..f5205ce85dbe 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -193,8 +193,8 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 {
 	struct sja1105_table *table;
 	struct sja1105_l2_lookup_params_entry default_l2_lookup_params = {
-		/* TODO Learned FDB entries are never forgotten */
-		.maxage = 0,
+		/* Learned FDB entries are forgotten after 300 seconds */
+		.maxage = SJA1105_AGEING_TIME_MS(300000),
 		/* All entries within a FDB bin are available for learning */
 		.dyn_tbsz = SJA1105ET_FDB_BIN_SIZE,
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
@@ -1249,10 +1249,35 @@ static int sja1105_setup(struct dsa_switch *ds)
 	return 0;
 }
 
+/* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
+ * which cannot be reconfigured at runtime. So a switch reset is required.
+ */
+static int sja1105_set_ageing_time(struct dsa_switch *ds,
+				   unsigned int ageing_time)
+{
+	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_table *table;
+	unsigned int maxage;
+
+	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
+	l2_lookup_params = table->entries;
+
+	maxage = SJA1105_AGEING_TIME_MS(ageing_time);
+
+	if (l2_lookup_params->maxage == maxage)
+		return 0;
+
+	l2_lookup_params->maxage = maxage;
+
+	return sja1105_static_config_reload(priv);
+}
+
 static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.adjust_link		= sja1105_adjust_link,
+	.set_ageing_time	= sja1105_set_ageing_time,
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
-- 
2.17.1

