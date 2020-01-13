Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897EB139C80
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 23:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgAMWcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 17:32:00 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:50983 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAMWb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 17:31:59 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 6287E40002;
        Mon, 13 Jan 2020 22:31:56 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v6 02/10] net: macsec: introduce the macsec_context structure
Date:   Mon, 13 Jan 2020 23:31:40 +0100
Message-Id: <20200113223148.746096-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200113223148.746096-1-antoine.tenart@bootlin.com>
References: <20200113223148.746096-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the macsec_context structure. It will be used
in the kernel to exchange information between the common MACsec
implementation (macsec.c) and the MACsec hardware offloading
implementations. This structure contains pointers to MACsec specific
structures which contain the actual MACsec configuration, and to the
underlying device (phydev for now).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/linux/phy.h                |  2 ++
 include/net/macsec.h               | 21 +++++++++++++++++++++
 include/uapi/linux/if_link.h       |  7 +++++++
 tools/include/uapi/linux/if_link.h |  7 +++++++
 4 files changed, 37 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5932bb8e9c35..0cc757ea2264 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -332,6 +332,8 @@ struct phy_c45_device_ids {
 	u32 device_ids[8];
 };
 
+struct macsec_context;
+
 /* phy_device: An instance of a PHY
  *
  * drv: Pointer to the driver for this PHY instance
diff --git a/include/net/macsec.h b/include/net/macsec.h
index e7b41c1043f6..0b98803f92ec 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -174,4 +174,25 @@ struct macsec_secy {
 	struct macsec_rx_sc __rcu *rx_sc;
 };
 
+/**
+ * struct macsec_context - MACsec context for hardware offloading
+ */
+struct macsec_context {
+	struct phy_device *phydev;
+	enum macsec_offload offload;
+
+	struct macsec_secy *secy;
+	struct macsec_rx_sc *rx_sc;
+	struct {
+		unsigned char assoc_num;
+		u8 key[MACSEC_KEYID_LEN];
+		union {
+			struct macsec_rx_sa *rx_sa;
+			struct macsec_tx_sa *tx_sa;
+		};
+	} sa;
+
+	u8 prepare:1;
+};
+
 #endif /* _NET_MACSEC_H_ */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1d69f637c5d6..024af2d1d0af 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -486,6 +486,13 @@ enum macsec_validation_type {
 	MACSEC_VALIDATE_MAX = __MACSEC_VALIDATE_END - 1,
 };
 
+enum macsec_offload {
+	MACSEC_OFFLOAD_OFF = 0,
+	MACSEC_OFFLOAD_PHY = 1,
+	__MACSEC_OFFLOAD_END,
+	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
+};
+
 /* IPVLAN section */
 enum {
 	IFLA_IPVLAN_UNSPEC,
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 8aec8769d944..42efdb84d189 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -485,6 +485,13 @@ enum macsec_validation_type {
 	MACSEC_VALIDATE_MAX = __MACSEC_VALIDATE_END - 1,
 };
 
+enum macsec_offload {
+	MACSEC_OFFLOAD_OFF = 0,
+	MACSEC_OFFLOAD_PHY = 1,
+	__MACSEC_OFFLOAD_END,
+	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
+};
+
 /* IPVLAN section */
 enum {
 	IFLA_IPVLAN_UNSPEC,
-- 
2.24.1

