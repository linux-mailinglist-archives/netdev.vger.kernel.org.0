Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826C250F38
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbfFXOxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:53:33 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33586 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbfFXOxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:53:33 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 88C895FEAA;
        Mon, 24 Jun 2019 16:53:31 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="Z97OrP5c";
        dkim-atps=neutral
Received: from pc-rene.vdorst.com (pc-rene.vdorst.com [192.168.2.125])
        by mail.vdorst.com (Postfix) with ESMTPA id 4BAB41CC6F20;
        Mon, 24 Jun 2019 16:53:31 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 4BAB41CC6F20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1561388011;
        bh=o1+uw8+JtKHBlTBA6PNZjG1cJU17dwIWI/clg9n7HZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z97OrP5cGmQX9952lOXduXvxBEa8mKL3zNXH/prknAEZgxU7TxHAkKWBjfD2AOFRs
         JgOSZW8l0lzWzb7mcAW8G29OKHfm12FYROoygcYQAImUFrLA2brWX6N8f3TZZ5gQHY
         0f8KhGNnHx1Wrgp1UHT+yzApmejZpmpPbD7HZqv6W4gnLvmT8qp3U09zaIWEDMj0p5
         jn+++VqeoezFH5Ttcqr6PQBc/ukG7UrSqccbuDuerqafROJTvXukRYVWuRoKJVxtSN
         xsYnhwAzcH2QTNoDevIkYC01TgllsQdqoiKQmsv5sAKm6ywfje2UhrpKPkNGOXZfMh
         vCjkLVw56pUqA==
From:   =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
To:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com
Cc:     frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH RFC net-next 5/5] net: dsa: mt7530: Add mediatek,ephy-handle to isolate external phy
Date:   Mon, 24 Jun 2019 16:52:51 +0200
Message-Id: <20190624145251.4849-6-opensource@vdorst.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624145251.4849-1-opensource@vdorst.com>
References: <20190624145251.4849-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms the external phy can only interface with the port 5 of
the switch because the xMII TX and RX lines are swapped. But it still can
be useful to use the internal phy of the switch to act as a WAN port which
connectes to the 2nd GMAC. This gives the SOC a double the bandwidth
between LAN and WAN. Because LAN and WAN don't share the same interface
anymore.

By adding an optional property mediatek,ephy-handle, the external phy
is put in isolation mode when internal phy is linked with 2nd GMAC via
phy-handle property.

Signed-off-by: René van Dorst <opensource@vdorst.com>
---
 drivers/net/dsa/mt7530.c | 28 ++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 838a921ca83e..25b0f35df75b 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -633,6 +633,26 @@ mt7530_get_sset_count(struct dsa_switch *ds, int port, int sset)
 	return ARRAY_SIZE(mt7530_mib);
 }
 
+static int mt7530_isolate_ephy(struct dsa_switch *ds,
+			       struct device_node *ephy_node)
+{
+	struct phy_device *phydev = of_phy_find_device(ephy_node);
+	int ret;
+
+	if (!phydev)
+		return 0;
+
+	ret = phy_modify(phydev, MII_BMCR, 0, (BMCR_ISOLATE | BMCR_PDOWN));
+	if (ret)
+		dev_err(ds->dev, "Failed to put phy %s in isolation mode!\n",
+			ephy_node->full_name);
+	else
+		dev_info(ds->dev, "Phy %s in isolation mode!\n",
+			 ephy_node->full_name);
+
+	return ret;
+}
+
 static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
@@ -655,6 +675,10 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* MT7530_P5_MODE_GPHY_P4: 2nd GMAC -> P5 -> P4 */
 		val &= ~MHWTRAP_P5_MAC_SEL & ~MHWTRAP_P5_DIS;
 
+		/* Isolate the external phy */
+		if (priv->ephy_node)
+			if (mt7530_isolate_ephy(ds, priv->ephy_node) < 0)
+				goto unlock_exit;
 		/* Setup the MAC by default for the cpu port */
 		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
 		break;
@@ -1330,6 +1354,10 @@ mt7530_setup(struct dsa_switch *ds)
 			mt7530_port_disable(ds, i);
 	}
 
+	/* Get external phy phandle */
+	priv->ephy_node = of_parse_phandle(priv->dev->of_node,
+					   "mediatek,ephy-handle", 0);
+
 	/* Setup port 5 */
 	priv->p5_mode = P5_MODE_DISABLED;
 	interface = PHY_INTERFACE_MODE_NA;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index f2a84ef48548..eb079e81a8e8 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -459,6 +459,7 @@ static const char *p5_modes(unsigned int p5_mode)
  * @reg_mutex:		The lock for protecting among process accessing
  *			registers
  * @p5_mode:		PORT 5 mode status
+ * @ephy_node:		External phy of_node.
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -472,6 +473,7 @@ struct mt7530_priv {
 	unsigned int		id;
 	bool			mcm;
 	unsigned int		p5_mode;
+	struct device_node	*ephy_node;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
-- 
2.20.1

