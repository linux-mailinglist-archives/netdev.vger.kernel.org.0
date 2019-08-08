Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014BA863FF
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403829AbfHHOKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:10:20 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:55769 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390125AbfHHOKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:16 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 86E5D200016;
        Thu,  8 Aug 2019 14:10:14 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 3/9] net: macsec: introduce the macsec_context structure
Date:   Thu,  8 Aug 2019 16:05:54 +0200
Message-Id: <20190808140600.21477-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808140600.21477-1-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
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
underlying device (netdev or phydev).

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/net/macsec.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index 5db18a272ffd..1c82026dc17e 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -176,4 +176,28 @@ struct macsec_secy {
 	struct macsec_rx_sc __rcu *rx_sc;
 };
 
+/**
+ * struct macsec_context - MACsec context for hardware offloading
+ */
+struct macsec_context {
+	union {
+		struct net_device *netdev;
+		struct phy_device *phydev;
+	};
+
+	const struct macsec_secy *secy;
+	const struct macsec_rx_sc *rx_sc;
+	struct {
+		unsigned char assoc_num;
+		u8 key[MACSEC_KEYID_LEN];
+		union {
+			const struct macsec_rx_sa *rx_sa;
+			const struct macsec_tx_sa *tx_sa;
+		};
+	} sa;
+
+	u8 prepare:1;
+	u8 is_phy:1;
+};
+
 #endif /* _NET_MACSEC_H_ */
-- 
2.21.0

