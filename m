Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DAB43AFB3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhJZKI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbhJZKI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:08:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C42C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 03:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NyA1MYJSKdpmJ5eu2d/WvL5Nx7lFePjEriez2j2ZLQ4=; b=ItcJ4NFSdfMrX39sWvqqd5NWtC
        jQHhRnbKpw52ftvnfDxAJiIRTNbljzJLfp/561zaEL9CYzRP0+bdWOfdpnPsamAZ5J62FiOxbk41T
        jxVrm63aNtYZX+JNgaJSU/JCwUrAzzzaLaFP7eq8ZR37SUwW2b+QiHvqLg/rC2NRHFGNU7OO44tPW
        RMfJNWmG8cTy9paiy4sL4g7iI1bx4ufSvdT0C9wXO7wJXu74ktBAcBN9s+2LMRKiytThjtjKSaWRR
        n7Lst1ZJPiJJz0g76G+uuahFDZQ0sgEvna+e6AkvDXcTM7h6rxcDu1vP38NJ19cYfubSCgUl1ecsx
        OoMbsBhQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52998 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfJLG-0005Cp-1u; Tue, 26 Oct 2021 11:06:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfJLF-001KXN-JN; Tue, 26 Oct 2021 11:06:01 +0100
In-Reply-To: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
References: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: phy: add phy_interface_t bitmap support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mfJLF-001KXN-JN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 26 Oct 2021 11:06:01 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for a bitmap for phy interface modes, which includes:
- a macro to declare the interface bitmap
- an inline helper to zero the interface bitmap
- an inline helper to detect an empty interface bitmap
- inline helpers to do a bitwise AND and OR operations on two interface
  bitmaps

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/phy.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 04e90423fa88..96e43fbb2dd8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -155,6 +155,40 @@ typedef enum {
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
+/* PHY interface mode bitmap handling */
+#define DECLARE_PHY_INTERFACE_MASK(name) \
+	DECLARE_BITMAP(name, PHY_INTERFACE_MODE_MAX)
+
+static inline void phy_interface_zero(unsigned long *intf)
+{
+	bitmap_zero(intf, PHY_INTERFACE_MODE_MAX);
+}
+
+static inline bool phy_interface_empty(const unsigned long *intf)
+{
+	return bitmap_empty(intf, PHY_INTERFACE_MODE_MAX);
+}
+
+static inline void phy_interface_and(unsigned long *dst, const unsigned long *a,
+				     const unsigned long *b)
+{
+	bitmap_and(dst, a, b, PHY_INTERFACE_MODE_MAX);
+}
+
+static inline void phy_interface_or(unsigned long *dst, const unsigned long *a,
+				    const unsigned long *b)
+{
+	bitmap_or(dst, a, b, PHY_INTERFACE_MODE_MAX);
+}
+
+static inline void phy_interface_set_rgmii(unsigned long *intf)
+{
+	__set_bit(PHY_INTERFACE_MODE_RGMII, intf);
+	__set_bit(PHY_INTERFACE_MODE_RGMII_ID, intf);
+	__set_bit(PHY_INTERFACE_MODE_RGMII_RXID, intf);
+	__set_bit(PHY_INTERFACE_MODE_RGMII_TXID, intf);
+}
+
 /*
  * phy_supported_speeds - return all speeds currently supported by a PHY device
  */
-- 
2.30.2

