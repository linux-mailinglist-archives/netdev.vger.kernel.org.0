Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6974835F796
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352100AbhDNP1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:27:32 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:55319 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbhDNP1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:27:30 -0400
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3915522259;
        Wed, 14 Apr 2021 17:27:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618414027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kAc6ABhNpdnJCipHDGNcvRdgD5/her0GkKHAGvSZOng=;
        b=bS1MJZhoLHWk9DbaawVJZhcQ/SwxDaX6O882z2I/dlhLMi/8uVPiHWIJhU3uvUpX1t/XDN
        gHVDOuYRYJFucZlBwLywpApmx4ToGXRYB+jVp7SHCc3cd/6hxmuBzMNpdgWA65eHehNG3H
        DjDNk/Y+yG+0Xu5VpDzaAk1Zkan+AZo=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/3] net: add helper eth_addr_add()
Date:   Wed, 14 Apr 2021 17:26:56 +0200
Message-Id: <20210414152657.12097-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210414152657.12097-1-michael@walle.cc>
References: <20210414152657.12097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes you need to add an offset to a base ethernet address. Add a
helper for that.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 include/linux/etherdevice.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 330345b1be54..6ec62c501d3f 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -466,6 +466,20 @@ static inline void eth_addr_inc(u8 *addr)
 	u64_to_ether_addr(u, addr);
 }
 
+/**
+ * eth_addr_add() - Add (or subtract) and offset to/from the given MAC address.
+ *
+ * @offset: Offset to add.
+ * @addr: Pointer to a six-byte array containing Ethernet address to increment.
+ */
+static inline void eth_addr_add(u8 *addr, long offset)
+{
+	u64 u = ether_addr_to_u64(addr);
+
+	u += offset;
+	u64_to_ether_addr(u, addr);
+}
+
 /**
  * is_etherdev_addr - Tell if given Ethernet address belongs to the device.
  * @dev: Pointer to a device structure
-- 
2.20.1

