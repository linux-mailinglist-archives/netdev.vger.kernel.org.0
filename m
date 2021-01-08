Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4422EEF1F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbhAHJIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbhAHJIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:18 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDD1C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:37 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c7so10462820edv.6
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MvWdbpHlmPhq6FtvIjCBXNgOECoVYIRRCLQ4z1WPNPc=;
        b=kd7LANf/oA97u7XVqbRkgPXRRJPWH9TWhIT+a1aIvi9lMFbVzlMP7xN5rmA8zb5DXo
         wOeaRmPOpg8+GZdpLDwNJpKsNkdFD2rsZlUXRmX4EgHOnzJRKn4LMO84/paDzrXQZCtQ
         5H17Q3MgGINfZaSgh687ftOwhNh78Y/kC5ngTwXAA56qsTvkRpZMC1S4uwDDmEOfLnfF
         3sbOq8zcUZCak5K1caZhXLhbSgE7LL86fZ3IZmIVq/NLh1aQZn9vYbwTPZB3cXO/LuaB
         CuDB10BI6Bf3CRZldgKKQyrS/9G6hbiHiNmk6fPKWbtWKHFsqFylTdi3f3b4SeptC3Zl
         pw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MvWdbpHlmPhq6FtvIjCBXNgOECoVYIRRCLQ4z1WPNPc=;
        b=Y/nsoK7HEnqhuFT69YhyqYzbziXJ8XBryx8rCV6xxhbUGLSz75dFL70e0jR+LCgJRD
         jdzBr1T2dfJB14fmxvQKQqSjmVK2Y2s4mOjpdvpr6mYis9jZ+Vk/mim/crBNY9r5+5CB
         6XwaRkYBcu6/tCQUJ3vZHkvssjFzwrcq7MdMGd4mQNa7odEGvPDvV8AHTegiQIxHL3Nm
         wG4WJWSrlsQlMBxEzsskV1si7mkvaW5bnP2C2RWt+Pb2tCO8zxqkCRB76Uk2AVFdtnru
         QqWI6kuEcxdLteCCY6eZgZ0J7IL/V8TSSyzVZ8VyOLSmuCpLN2Vo1EKwhZ7BExMjlSFa
         Djzw==
X-Gm-Message-State: AOAM531pVV57CVf5CVrdvDckso0pVwWPmgYKCDG2UXtCLu9K+YLSjk6/
        b1W4xrSifEiXVDGumWYuttc=
X-Google-Smtp-Source: ABdhPJxq6SnUYyZMpV49M87jT6W/AaiR45bC/HnaROT8LIKb0AD2Yvd9GuCD4sWDTcH9xkEBqJShmA==
X-Received: by 2002:a05:6402:1d9a:: with SMTP id dk26mr4580714edb.283.1610096856260;
        Fri, 08 Jan 2021 01:07:36 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:35 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 1/6] dpaa2-mac: split up initializing the MAC object from connecting to it
Date:   Fri,  8 Jan 2021 11:07:22 +0200
Message-Id: <20210108090727.866283-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Split up the initialization phase of the dpmac object from actually
configuring the phylink instance, connecting to it and configuring the
MAC. This is done so that even though the dpni object is connected to a
dpmac which has link management handled by the firmware we are still
able to export the MAC counters.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 69 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  5 ++
 3 files changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fb0bcd18ec0c..61385894e8c7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4056,15 +4056,24 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	mac->mc_io = priv->mc_io;
 	mac->net_dev = priv->net_dev;
 
+	err = dpaa2_mac_open(mac);
+	if (err)
+		goto err_free_mac;
+
 	err = dpaa2_mac_connect(mac);
 	if (err) {
 		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
-		kfree(mac);
-		return err;
+		goto err_close_mac;
 	}
 	priv->mac = mac;
 
 	return 0;
+
+err_close_mac:
+	dpaa2_mac_close(mac);
+err_free_mac:
+	kfree(mac);
+	return err;
 }
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
@@ -4073,6 +4082,7 @@ static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 		return;
 
 	dpaa2_mac_disconnect(priv->mac);
+	dpaa2_mac_close(priv->mac);
 	kfree(priv->mac);
 	priv->mac = NULL;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 828c177df03d..50dd302abcf4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -302,36 +302,20 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
-	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 	struct net_device *net_dev = mac->net_dev;
 	struct device_node *dpmac_node;
 	struct phylink *phylink;
-	struct dpmac_attr attr;
 	int err;
 
-	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
-			 &dpmac_dev->mc_handle);
-	if (err || !dpmac_dev->mc_handle) {
-		netdev_err(net_dev, "dpmac_open() = %d\n", err);
-		return -ENODEV;
-	}
-
-	err = dpmac_get_attributes(mac->mc_io, 0, dpmac_dev->mc_handle, &attr);
-	if (err) {
-		netdev_err(net_dev, "dpmac_get_attributes() = %d\n", err);
-		goto err_close_dpmac;
-	}
-
-	mac->if_link_type = attr.link_type;
+	mac->if_link_type = mac->attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(attr.id);
+	dpmac_node = dpaa2_mac_get_node(mac->attr.id);
 	if (!dpmac_node) {
-		netdev_err(net_dev, "No dpmac@%d node found.\n", attr.id);
-		err = -ENODEV;
-		goto err_close_dpmac;
+		netdev_err(net_dev, "No dpmac@%d node found.\n", mac->attr.id);
+		return -ENODEV;
 	}
 
-	err = dpaa2_mac_get_if_mode(dpmac_node, attr);
+	err = dpaa2_mac_get_if_mode(dpmac_node, mac->attr);
 	if (err < 0) {
 		err = -EINVAL;
 		goto err_put_node;
@@ -351,9 +335,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_put_node;
 	}
 
-	if (attr.link_type == DPMAC_LINK_TYPE_PHY &&
-	    attr.eth_if != DPMAC_ETH_IF_RGMII) {
-		err = dpaa2_pcs_create(mac, dpmac_node, attr.id);
+	if (mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
+	    mac->attr.eth_if != DPMAC_ETH_IF_RGMII) {
+		err = dpaa2_pcs_create(mac, dpmac_node, mac->attr.id);
 		if (err)
 			goto err_put_node;
 	}
@@ -389,8 +373,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	dpaa2_pcs_destroy(mac);
 err_put_node:
 	of_node_put(dpmac_node);
-err_close_dpmac:
-	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
+
 	return err;
 }
 
@@ -402,8 +385,40 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 	phylink_disconnect_phy(mac->phylink);
 	phylink_destroy(mac->phylink);
 	dpaa2_pcs_destroy(mac);
+}
+
+int dpaa2_mac_open(struct dpaa2_mac *mac)
+{
+	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
+	struct net_device *net_dev = mac->net_dev;
+	int err;
+
+	err = dpmac_open(mac->mc_io, 0, dpmac_dev->obj_desc.id,
+			 &dpmac_dev->mc_handle);
+	if (err || !dpmac_dev->mc_handle) {
+		netdev_err(net_dev, "dpmac_open() = %d\n", err);
+		return -ENODEV;
+	}
+
+	err = dpmac_get_attributes(mac->mc_io, 0, dpmac_dev->mc_handle,
+				   &mac->attr);
+	if (err) {
+		netdev_err(net_dev, "dpmac_get_attributes() = %d\n", err);
+		goto err_close_dpmac;
+	}
+
+	return 0;
+
+err_close_dpmac:
+	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
+	return err;
+}
+
+void dpaa2_mac_close(struct dpaa2_mac *mac)
+{
+	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 
-	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
+	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 }
 
 static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 955a52856210..13d42dd58ec9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -17,6 +17,7 @@ struct dpaa2_mac {
 	struct dpmac_link_state state;
 	struct net_device *net_dev;
 	struct fsl_mc_io *mc_io;
+	struct dpmac_attr attr;
 
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
@@ -28,6 +29,10 @@ struct dpaa2_mac {
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 			     struct fsl_mc_io *mc_io);
 
+int dpaa2_mac_open(struct dpaa2_mac *mac);
+
+void dpaa2_mac_close(struct dpaa2_mac *mac);
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac);
 
 void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
-- 
2.29.2

