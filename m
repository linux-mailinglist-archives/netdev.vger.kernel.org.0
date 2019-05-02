Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A43512343
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfEBUZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:25:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42807 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfEBUYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so5116858wrb.9;
        Thu, 02 May 2019 13:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CWJqz6DthZLgwnOAsHSywgj6nKZaEgLjz5fYgg8lfFI=;
        b=g+zSv8aq6DMhXdvDfeBlXY1S20z/HSg9oIgwWnSEu1yovK35mRhw7CP+rdGUH1xAR8
         j9xcmgUgXAxWRXEbZQH+E1pj98Rkps1tZccLaLxAqnX+vnAlHLnnyWzCEEfBmrPxYGni
         dkb/GW96RvgOH6fRPknfwj4PA/ZxbU5AHIU7SPO/WCxNUNYO4Pb0H82O1UYam0y+NGB2
         BCJ6l7PWX7uPEXXHuCzIISRF/e7X/GTpgZ9OFS9FjLolFME1pzgItscgW0Ugkt0rlVH/
         k5qYdsOx1VjVRjatLWonj/h+/GwGAmlIEwcxhTat1GT8TlFv6gpjvi3je2ACk6L64fe2
         x5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CWJqz6DthZLgwnOAsHSywgj6nKZaEgLjz5fYgg8lfFI=;
        b=MUYcEnaCeIS3z+9sVYwDcRMnM1opWq7jqho44L2vzRlqi5qFQop+x6jWZ2dGhI454b
         fyoJyzeRa1tjcXudr2Fdzfkdedh7g3zlo5EBtbnB3pV/7Gbk8s3wI1v3nbNED8zf8awp
         vcyOerk7bIv1X3ZCtQ3zClSvMcXU/dzIOrxirTZsUk5rlb6j/VRPHduNN02TCG3i2hjo
         EKLLvSNt2aPFWAnN/LAvVYN27Myirelt16GmCN7Cmm20jL9tYIKxOUX4i5zQLT1X8KKz
         Z49nqy2PIiWBuSdZYpyN+uJPdLjasezJBO+JYhZRZW9/K32bBKkjoK0Pcf62pQhvLFLi
         Ly4g==
X-Gm-Message-State: APjAAAWNdwiqdaNnBfWx3J6LPLKLH2KhRke5Q3pYx+7uCIXHeDxLaMGc
        UYBLcLojef05IoIgwUfJRSc=
X-Google-Smtp-Source: APXvYqxEdvkmkkHgGienLrMSKZq+47BrBKiHxlCTr5cDliQ0sZOgA2V9aFUBTGnR9ZQSFUlOvH6KlQ==
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr3222468wru.84.1556828687976;
        Thu, 02 May 2019 13:24:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 10/12] net: dsa: sja1105: Reject unsupported link modes for AN
Date:   Thu,  2 May 2019 23:23:38 +0300
Message-Id: <20190502202340.21054-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethernet flow control:

The switch MAC does not consume, nor does it emit pause frames. It
simply forwards them as any other Ethernet frame (and since the DMAC is,
per IEEE spec, 01-80-C2-00-00-01, it means they are filtered as
link-local traffic and forwarded to the CPU, which can't do anything
useful with them).

Duplex:

There is no duplex setting in the SJA1105 MAC. It is known to forward
traffic at line rate on the same port in both directions. Therefore it
must be that it only supports full duplex.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f5205ce85dbe..74f8ff9e17e0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -11,6 +11,7 @@
 #include <linux/spi/spi.h>
 #include <linux/errno.h>
 #include <linux/gpio/consumer.h>
+#include <linux/phylink.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
@@ -726,6 +727,35 @@ static void sja1105_adjust_link(struct dsa_switch *ds, int port,
 		sja1105_adjust_port_config(priv, port, phydev->speed, true);
 }
 
+static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
+				     unsigned long *supported,
+				     struct phylink_link_state *state)
+{
+	/* Construct a new mask which exhaustively contains all link features
+	 * supported by the MAC, and then apply that (logical AND) to what will
+	 * be sent to the PHY for "marketing".
+	 */
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_xmii_params_entry *mii;
+
+	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
+
+	/* The MAC does not support pause frames, and also doesn't
+	 * support half-duplex traffic modes.
+	 */
+	phylink_set(mask, Autoneg);
+	phylink_set(mask, MII);
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Full);
+	if (mii->xmii_mode[port] == XMII_MODE_RGMII)
+		phylink_set(mask, 1000baseT_Full);
+
+	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 /* First-generation switches have a 4-way set associative TCAM that
  * holds the FDB entries. An FDB index spans from 0 to 1023 and is comprised of
  * a "bin" (grouping of 4 entries) and a "way" (an entry within a bin).
@@ -1278,6 +1308,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.setup			= sja1105_setup,
 	.adjust_link		= sja1105_adjust_link,
 	.set_ageing_time	= sja1105_set_ageing_time,
+	.phylink_validate	= sja1105_phylink_validate,
 	.get_strings		= sja1105_get_strings,
 	.get_ethtool_stats	= sja1105_get_ethtool_stats,
 	.get_sset_count		= sja1105_get_sset_count,
-- 
2.17.1

