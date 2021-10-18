Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A674328CA
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhJRVMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhJRVM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0828E6103B;
        Mon, 18 Oct 2021 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591418;
        bh=I4N+gY2n/y8DtesQrY9LNTBI8SFsQyU3vjtwQCWrsVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sop5o+S0StkEs+fg8C1J0Au160windiFfU74a5LAJEP9WkC+cmoGbsf4ELqm9j/QA
         BYSNRBj5bxdCUgCJK5DTpBz3vlY9mNGZ05lrF1DGAYSEtxvx5XYYUQdIGOCS01ahsR
         NZMw6JK9RfzsQEiOSbKB+fhpz/QYsG/8kfjq9MrXD9aMKL8uZbJIwPIgJrx9xeGTor
         pGuBVWpu0/nupVLP+EaeiuxOOnRk3ShO2XA96xaq5nPMhehqFgCDBGaxuNfSFdqAHH
         P+O+BgutTISx/mewFUjcHBFPX+sHLgfW6O8KxWZGMsaGWEfe6VriLZ8LOH9cFOrvvD
         8Yp544Kpx9jMA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] ethernet: add a helper for assigning port addresses
Date:   Mon, 18 Oct 2021 14:10:02 -0700
Message-Id: <20211018211007.1185777-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018211007.1185777-1-kuba@kernel.org>
References: <20211018211007.1185777-1-kuba@kernel.org>
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
--
 - eth_hw_addr_set_port() -> eth_hw_addr_gen()
 - id u8 -> unsigned int
---
 include/linux/etherdevice.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 23681c3d3b8a..2ad71cc90b37 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -551,6 +551,27 @@ static inline unsigned long compare_ether_header(const void *a, const void *b)
 #endif
 }
 
+/**
+ * eth_hw_addr_gen - Generate and assign Ethernet address to a port
+ * @dev: pointer to port's net_device structure
+ * @base_addr: base Ethernet address
+ * @id: offset to add to the base address
+ *
+ * Generate a MAC address using a base address and an offset and assign it
+ * to a net_device. Commonly used by switch drivers which need to compute
+ * addresses for all their ports. addr_assign_type is not changed.
+ */
+static inline void eth_hw_addr_gen(struct net_device *dev, const u8 *base_addr,
+				   unsigned int id)
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

