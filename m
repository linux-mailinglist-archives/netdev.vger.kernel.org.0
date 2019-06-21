Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31694EB58
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfFUO7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 10:59:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43438 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUO7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 10:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XzAaUhJ0bSs/mdF9ef3MgCxg3px0Mc5fJslS2oHAA2s=; b=aOkqU6TzkSj3Hs8gQZh+Gg2TPS
        PE+RW9xlYBZgqPpwDfY+BPJLx73nC/uAh9OryKfWEUs5pIAu/WbxS4KxMlZgDthtNW2WXnqsCXBuY
        exqWkIYjqUm7CFb6VeReLElSNu4PiZNqFrJyLFWqhuzuw94ojts0aVQF1EpuKRdbWx46gDaOcDw/7
        BUNN0lFyixCcItxFxDPebsbfUYxAGH7I3NDCRkLIdg369WR1JnllQkCXAcxFQMMekBoSmqSdzBcng
        2IWrSBOZBylUPXwgytg5AhyxFdA2ZyDVACKMKwMV2ZSO4rFqw8lP06sNc+MbZ6Tx/+ONsHkdbCZ10
        E+Rw4Dpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:48270 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1heL0P-00065F-Sz; Fri, 21 Jun 2019 15:59:09 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1heL0P-00075z-An; Fri, 21 Jun 2019 15:59:09 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] doc: phy: document some PHY_INTERFACE_MODE_xxx settings
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1heL0P-00075z-An@rmk-PC.armlinux.org.uk>
Date:   Fri, 21 Jun 2019 15:59:09 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There seems to be some confusion surrounding three PHY interface modes,
specifically 1000BASE-X, 2500BASE-X and SGMII.  Add some documentation
to phylib detailing precisely what these interface modes refer to.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---

This is in response to recent discussion, both public and private of
recent attempts to convert some drivers to use phylink.  This is to
aid understanding the differences between these three phy link modes,
specifically with respect to the "up-clocked" 2.5G variants.

The 2.5G variants are the basic 1G variants but with the serdes link
clocked 2.5 times faster; there are no bits in the control word that
identify this over the standard rates.  A serdes clocked 2.5x faster
does not support the 1G/100M/10M speeds, but can only support 2.5G
and (theoretically for SGMII) 250M/25M.  In practice, the PHY data
sheets I've read state that these slower speeds at the up-clocked link
speed are not supported.

It should be noted that we do not currently support 2.5G SGMII, but
we do support 2.5G BASE-X PHY interface mode.

 Documentation/networking/phy.rst | 45 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index 0dd90d7df5ec..a689966bc4be 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -202,7 +202,8 @@ the PHY/controller, of which the PHY needs to be aware.
 
 *interface* is a u32 which specifies the connection type used
 between the controller and the PHY.  Examples are GMII, MII,
-RGMII, and SGMII.  For a full list, see include/linux/phy.h
+RGMII, and SGMII.  See "PHY interface mode" below.  For a full
+list, see include/linux/phy.h
 
 Now just make sure that phydev->supported and phydev->advertising have any
 values pruned from them which don't make sense for your controller (a 10/100
@@ -225,6 +226,48 @@ When you want to disconnect from the network (even if just briefly), you call
 phy_stop(phydev). This function also stops the phylib state machine and
 disables PHY interrupts.
 
+PHY interface modes
+===================
+
+The PHY interface mode supplied in the phy_connect() family of functions
+defines the initial operating mode of the PHY interface.  This is not
+guaranteed to remain constant; there are PHYs which dynamically change
+their interface mode without software interaction depending on the
+negotiation results.
+
+Some of the interface modes are described below:
+
+``PHY_INTERFACE_MODE_1000BASEX``
+    This defines the 1000BASE-X single-lane serdes link as defined by the
+    802.3 standard section 36.  The link operates at a fixed bit rate of
+    1.25Gbaud using a 10B/8B encoding scheme, resulting in an underlying
+    data rate of 1Gbps.  Embedded in the data stream is a 16-bit control
+    word which is used to negotiate the duplex and pause modes with the
+    remote end.  This does not include "up-clocked" variants such as 2.5Gbps
+    speeds (see below.)
+
+``PHY_INTERFACE_MODE_2500BASEX``
+    This defines a variant of 1000BASE-X which is clocked 2.5 times faster,
+    than the 802.3 standard giving a fixed bit rate of 3.125Gbaud.
+
+``PHY_INTERFACE_MODE_SGMII``
+    This is used for Cisco SGMII, which is a modification of 1000BASE-X
+    as defined by the 802.3 standard.  The SGMII link consists of a single
+    serdes lane running at a fixed bit rate of 1.25Gbaud with 10B/8B
+    encoding.  The underlying data rate is 1Gbps, with the slower speeds of
+    100Mbps and 10Mbps being achieved through replication of each data symbol.
+    The 802.3 control word is re-purposed to send the negotiated speed and
+    duplex information from to the MAC, and for the MAC to acknowledge
+    receipt.  This does not include "up-clocked" variants such as 2.5Gbps
+    speeds.
+
+    Note: mismatched SGMII vs 1000BASE-X configuration on a link can
+    successfully pass data in some circumstances, but the 16-bit control
+    word will not be correctly interpreted, which may cause mismatches in
+    duplex, pause or other settings.  This is dependent on the MAC and/or
+    PHY behaviour.
+
+
 Pause frames / flow control
 ===========================
 
-- 
2.7.4

