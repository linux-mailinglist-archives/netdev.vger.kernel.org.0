Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B5A264A80
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgIJQ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgIJQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:57:48 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CD4C0617BE
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:05 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l17so6969637edq.12
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fhs+K6Wdf5lIvDzAuwVm0JWNjHNJG5vKOqqTwb21lIs=;
        b=i8qkILib/stxz5IRGRc4YoIIqmEitpBtnl8feyyDy92O0HHmlakIGBl6yuN8UeSnQL
         oL5g86hZ6sVWdGSbmxBuIf1jYhAKzQPWQuasUaCDHYxaZW2MhukQzEqMrUeAoP5Ksfxz
         c/aikOP7mkHWrwya/vNwvkyQITx0jp0dkyZXUUTCCwaeUTAoqb7NpkkGujiEVMNByNJ5
         u38DsFZ7Q7wHrlGIQ480ThJLqdXlET89wbYE/ERg1LedlCn+Zrm60w+KNyfYgemfEpTO
         Ut1Wv+QZYhjfydxnIm0YYVFrCfR2apI/tcOw93GzX8tUgVIZTGdg/XR6dVksx193cb3l
         Qxqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fhs+K6Wdf5lIvDzAuwVm0JWNjHNJG5vKOqqTwb21lIs=;
        b=aHuqnKahX+J+aCpp6WB6K4xzJUn4Dl+J24gZunbErc9WijBPOuDuGWhChcnAUqkkkk
         Ghst4AOGpD9y79pxQ0e35LRJJHgKan5JL3TAhC5fiWwYpkE7i8MO4o40JZHDZMp8Pxkr
         rNfSdxrKhYwF4otSSYNJMMqCGPW1xi4N/yCh1K03VsAZxxb3QAoLdEFI/X8Q0tdU8rCz
         7yzBrJJnqJOZvmGmGqIj+Yu0Ea/2oYFx3J40OSDrAA2r6qa0b5wmOuoZfxz1o/ftUozK
         yISUdSUDtyLjq8fxJi39biPlrFW+LiHeVlnGKKEP1EcNfEosCRO0IsEBimb5sOeE8JLp
         hqPg==
X-Gm-Message-State: AOAM5309eDFWRBmZ66NwIoRYD1QN62rQ+CujMkUEAmycDNQCcWJCBz+4
        o6hP8UlklyAkMHJEEv7FO2UqtufvqSc=
X-Google-Smtp-Source: ABdhPJyD7J5HAVPd5rjhsSF7RnhcHWwHPpadntR70EvyGlmwcOBqyhbWsg+G40LlI89kz/M/Hpf1rg==
X-Received: by 2002:a50:a0c7:: with SMTP id 65mr9921148edo.375.1599756544257;
        Thu, 10 Sep 2020 09:49:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id o93sm8108024edd.75.2020.09.10.09.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:49:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/4] net: dsa: tag_8021q: setup tagging via a single function call
Date:   Thu, 10 Sep 2020 19:48:55 +0300
Message-Id: <20200910164857.1221202-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910164857.1221202-1-olteanv@gmail.com>
References: <20200910164857.1221202-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no point in calling dsa_port_setup_8021q_tagging for each
individual port. Additionally, it will become more difficult to do that
when we'll have a context structure to tag_8021q (next patch). So
refactor this now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Split from a larger patch.

 drivers/net/dsa/sja1105/sja1105_main.c | 15 ++++-----------
 include/linux/dsa/8021q.h              |  6 ++----
 net/dsa/tag_8021q.c                    | 21 +++++++++++++++++++--
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5a28dfb36ec3..508494390e81 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1934,18 +1934,11 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 {
 	struct sja1105_private *priv = ds->priv;
-	int rc, i;
+	int rc;
 
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		priv->expect_dsa_8021q = true;
-		rc = dsa_port_setup_8021q_tagging(ds, i, enabled);
-		priv->expect_dsa_8021q = false;
-		if (rc < 0) {
-			dev_err(ds->dev, "Failed to setup VLAN tagging for port %d: %d\n",
-				i, rc);
-			return rc;
-		}
-	}
+	rc = dsa_8021q_setup(priv->ds, enabled);
+	if (rc)
+		return rc;
 
 	dev_info(ds->dev, "%s switch tagging\n",
 		 enabled ? "Enabled" : "Disabled");
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 804750122c66..8586d8cdf956 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -25,8 +25,7 @@ struct dsa_8021q_crosschip_link {
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
 
-int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
-				 bool enabled);
+int dsa_8021q_setup(struct dsa_switch *ds, bool enabled);
 
 int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 				    struct dsa_switch *other_ds,
@@ -57,8 +56,7 @@ bool vid_is_dsa_8021q(u16 vid);
 
 #else
 
-int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
-				 bool enabled)
+int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
 {
 	return 0;
 }
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 780b2a15ac9b..e38fdf5d4d03 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -209,7 +209,7 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
+static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 {
 	int upstream = dsa_upstream_port(ds, port);
 	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
@@ -275,7 +275,24 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
+
+int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
+{
+	int rc, port;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		rc = dsa_8021q_setup_port(ds, port, enabled);
+		if (rc < 0) {
+			dev_err(ds->dev,
+				"Failed to setup VLAN tagging for port %d: %d\n",
+				port, rc);
+			return rc;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_setup);
 
 static int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
 					  struct dsa_switch *other_ds,
-- 
2.25.1

