Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47E442FC44
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242743AbhJOTlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 15:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235167AbhJOTlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 15:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C049861164;
        Fri, 15 Oct 2021 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634326736;
        bh=weNnvNYdaUNDb2w7q63P4w4fOKU0Ms7iHvDrdhhtdvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4gNANYJeBAz6008qkwRD+phVRGzXjAWc2hr+qzgy76G3g3pKYM4x8Kg39tBa2iAF
         ybgA9GTqWyc1jJRtKB1k1m1UKQxoifl82RA2ztTbWP3qZfjPrNqQqDChXvWwg2/JOG
         iZMl6HBTxdcwoGSNH208fISk1YcFJI3NCJ3hn8KmNWqyvjWb/iO17nthU4LQ+e6P1U
         XP6y8mh9qzdzCcjWZPUNAxcg1hCaiKe6wi9yKMa7u4OVnzGS/jOmOkRbEdb9rDAhtb
         tfVhRq36sms/aDglqv/Qv41S+CCXms6vF8UdckT18zMihuXPWvB3lrPfSBQMZN39jW
         6YSYBIptgeWYg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        jiri@nvidia.com, idosch@nvidia.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        bjarni.jonasson@microchip.com,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        vkochan@marvell.com, tchornyi@marvell.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com
Subject: [RFC net-next 1/6] ethernet: add a helper for assigning port addresses
Date:   Fri, 15 Oct 2021 12:38:43 -0700
Message-Id: <20211015193848.779420-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015193848.779420-1-kuba@kernel.org>
References: <20211015193848.779420-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have 5 drivers which offset base MAC addr by port id.
Create a helper for them.

This helper takes care of overflows, which some drivers
did not do, please complain if that's going to break
anything!

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
CC: idosch@nvidia.com
CC: lars.povlsen@microchip.com
CC: Steen.Hegelund@microchip.com
CC: UNGLinuxDriver@microchip.com
CC: bjarni.jonasson@microchip.com
CC: linux-arm-kernel@lists.infradead.org
CC: qiangqing.zhang@nxp.com
CC: vkochan@marvell.com
CC: tchornyi@marvell.com
CC: vladimir.oltean@nxp.com
CC: claudiu.manoil@nxp.com
CC: alexandre.belloni@bootlin.com
CC: UNGLinuxDriver@microchip.com
---
 include/linux/etherdevice.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 23681c3d3b8a..157f6c7ac9ff 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -551,6 +551,27 @@ static inline unsigned long compare_ether_header(const void *a, const void *b)
 #endif
 }
 
+/**
+ * eth_hw_addr_set_port - Generate and assign Ethernet address to a port
+ * @dev: pointer to port's net_device structure
+ * @base_addr: base Ethernet address
+ * @id: offset to add to the base address
+ *
+ * Assign a MAC address to the net_device using a base address and an offset.
+ * Commonly used by switch drivers which need to compute addresses for all
+ * their ports. addr_assign_type is not changed.
+ */
+static inline void eth_hw_addr_set_port(struct net_device *dev,
+					const u8 *base_addr, u8 id)
+{
+	u64 u = ether_addr_to_u64(base_addr);
+	u8 addr[ETH_ALEN];
+
+	u += id;
+	u64_to_ether_addr(u, addr);
+	eth_hw_addr_set(dev, addr);
+}
+
 /**
  * eth_skb_pad - Pad buffer to mininum number of octets for Ethernet frame
  * @skb: Buffer to pad
-- 
2.31.1

