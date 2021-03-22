Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DCD345047
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhCVTvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231621AbhCVTuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 15:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EF326198E;
        Mon, 22 Mar 2021 19:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616442636;
        bh=itcODGQHLpuXMXSmPfGYKFBLRHdM96wzv6qnbYt2C+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4F0kf64zmG4qTDSfQ+kPWCy4LRHTC3JUOesC1X23302nYEPd+4EWodurVWz2RLJb
         vcr18b+QoJ35q21jq5dommhmFOmpfOhPXkPLgZ7LscClagKKkh7X87pW+M9CZN8fZq
         0wxTsprFpb7kZvnjmL/1abvdEXDgApQi7aT6cv5TF7HTQLt+s+3xnwwcSPt0jk1aH1
         eU2bJD6t5xXe80rZZA54p5heeGfy7yOUNCDmjA6ig6CQ3tshh6tac5GfsjFIopvZYx
         i4y46tQUdrtR3wKFXVtfMgRDPDU+/9OeuRDrSLvTptFnbKVruF505Zskd+oQjVGTaB
         uY7F799+Ek1Mg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC net-next 2/2] dt-bindings: ethernet-phy: define `unsupported-mac-connection-types` property
Date:   Mon, 22 Mar 2021 20:49:59 +0100
Message-Id: <20210322195001.28036-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322195001.28036-1-kabel@kernel.org>
References: <20210322195001.28036-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ethernet PHY may support PHY interface modes that are not wired on a
specific board (or are broken for some other reason). In order for the
kernel to know that these modes should not be used, we need to specify
this in device tree.

Define a new ethernet PHY property `unsupported-mac-connection-types`,
which lists these unsupported modes.

Signed-off-by: Marek Behún <kabel@kernel.org>
---

As in the previous patch: we allow both `phy-connection-type` and
`phy-mode` to define PHY interface mode. Should we call this new
property as it is proposed by this patch, or something different,
like `unsupported-mac-phy-modes`?

Also, some PHYs (marvell10g for example) also multiple units (host
unit for connecting to the MAC, fiber unit for connecting for example
via a SFP). Should we also add `unsupported-fiber-connection-types`
property?

Moreover should this property be a member of PHY's node, or the
ethernet controller's node? Were it a member of ethernet controller's
node, we wouldn't need to $ref a definition from another file's $defs
(which Rob Herring says that so far is done only in withing single
file).
On the other hand `unsupported-fiber-connection-types` property should
be a member of PHY's node, if we will add this in the future.

---
 .../devicetree/bindings/net/ethernet-phy.yaml     | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 2766fe45bb98..4c5b8fabbec3 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -136,6 +136,20 @@ properties:
       used. The absence of this property indicates the muxers
       should be configured so that the external PHY is used.
 
+  unsupported-mac-connection-types:
+    $ref: "ethernet-controller.yaml#/$defs/phy-connection-type-array"
+    description:
+      The PHY device may support different interface types for
+      connecting the Ethernet MAC device to the PHY device (i.e.
+      rgmii, sgmii, xaui, ...), but not all of these interface
+      types must necessarily be supported for a specific board
+      (either not all of them are wired, or there is a known bug
+      for a specific mode).
+      This property specifies a list of interface modes are not
+      supported on the board.
+    minItems: 1
+    maxItems: 128
+
   resets:
     maxItems: 1
 
@@ -196,5 +210,6 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+            unsupported-mac-connection-types = "xaui", "rxaui";
         };
     };
-- 
2.26.2

