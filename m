Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DD3DA1E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfD2ASg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53389 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfD2ASO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id 26so11575242wmj.3;
        Sun, 28 Apr 2019 17:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MqUoyAzUDsFlk0d3wBgPciFWjMtEf/VeaFykVMLMQWw=;
        b=XgsjIdxKsICMpDFkZ9a/CO0M2UHpMzqSchscDOVick+C+n2tzsGuss3aQogY0bASe5
         cyTTh1ZXXsuj/bzbe2pUDGxQU9JaeYWveAGKCblaTaUYLAoC6f/vFhZj+r7jTZb/c4QK
         RdFWGvbjnZ/GcT3sLskmTsThQcljcZWMR5WakjkGz8Nc59hOGQeSQMqGQkhv/wH1iE20
         aHde9BTwIZ3Z2ZitbRLjop4+dbD5Z/WohIQ1TrjnxSiwXWIu5p4Tl747SF5lftm96S2R
         arq/kdrV4xEgyGiBWntnxxjSz3Y+5vW5Jd51hO+t7pOlY0fIbJz6i3+mpamL0RV9ccKZ
         TalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MqUoyAzUDsFlk0d3wBgPciFWjMtEf/VeaFykVMLMQWw=;
        b=pFCI0UbyhEZma1Xgb5ROQEZTH2oqRDA3wqq0Ysdq8ithXy6x5duOmBIeBvqP14LIHN
         GVaQhK+juIuGZBvCNsi5RXJQKqbO7ljynxHmPVjdMinH9XkQNgbl0x8G5NmOKtTMuJNp
         pkdleWDJKCg1v25nVl+QjkQrS8cA9qNMn8RA4kX8TkBSZQORStFdRzUeS9eeWPs2sfEH
         NWl1CU3Ar8rF6i4gKwcKmzf4Q94M5jN9uWSVLgHWQhHYmDGMjaERLdpNFcJI5g48qFY5
         TflvsAyDwOC5JtHEf7Q7b2OqYLN5/Zm3p1eZbFm0huaYyuyA30evEyZQmZIvWhSLCg6e
         +O3Q==
X-Gm-Message-State: APjAAAX/EL7szXvnGrHubxz6NlmLriXBcb2VKt/UFtyxIC1S3PCzbD3S
        zoH/JyxBJzWLrKDshom4kbA=
X-Google-Smtp-Source: APXvYqy1q+Dt7hA5Q5ZnUbwT4RtQVvhfwDtZ40fPn6y/287p1RxaICXhRreJHv+htC8D70ro9FPpEA==
X-Received: by 2002:a1c:ef09:: with SMTP id n9mr10886791wmh.104.1556497091793;
        Sun, 28 Apr 2019 17:18:11 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 10/12] net: dsa: sja1105: Reject unsupported link modes for AN
Date:   Mon, 29 Apr 2019 03:17:04 +0300
Message-Id: <20190429001706.7449-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
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

