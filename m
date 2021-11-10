Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D0944C881
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhKJTKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229781AbhKJTKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE51D610A0;
        Wed, 10 Nov 2021 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571235;
        bh=vW2C35K0s0nGFK7WLeuHet5sfDFgtjW7iqQvH0R7qCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuYbWBydC8Uo01r9rDo5tq+h4AN3NgiegMMIPVO7whYe9M2DiKjjdVBFh86VeIRuz
         CgM95PFk9aMsSzeOx+E+E1NngGSyOVhL7KIraEgnlSHRWsXAXJb7gsGUYn0V1wyrOR
         BFhVgh4ZgSCe7M5FDfInc4GLVIxOzB1E24l2/SpEPG5Wq5fqoQcXuHJw4yxoLevHHl
         YIB4S5OrXUvHqrlYVfJlvg4NvjIWtko7g7QdPmaWgc9li/CqzbzvlmlCULCJ0l0rEV
         jq2UL/IpLYfInWFUhn/vOQVKKYjHRShl29tPbEoZ1MXBqW0M3P+4CWa2PtXxBjsNPu
         W156u7M8Z8W6A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 1/8] dt-bindings: ethernet-controller: support multiple PHY connection types
Date:   Wed, 10 Nov 2021 20:07:02 +0100
Message-Id: <20211110190709.16505-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110190709.16505-1-kabel@kernel.org>
References: <20211110190709.16505-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes, an ethernet PHY may communicate with ethernet controller with
multiple different PHY connection types, and the software should be able
to choose between them.

Russell King says:
  conventionally phy-mode has meant "this is the mode we want to operate
  the PHY interface in" which was fine when PHYs didn't change their
  mode depending on the media speed
This is no longer the case, since we have PHYs that can change PHY mode.

Existing example is the Marvell 88X3310 PHY, which supports connecting
the MAC with the PHY with `xaui` and `rxaui`. The MAC may also support
both modes, but it is possible that a particular board doesn't have
these modes wired (since they use multiple SerDes lanes).

Another example is one SerDes lane capable of `1000base-x`, `2500base-x`
and `sgmii` when connecting Marvell switches with Marvell ethernet
controller. Currently we mention only one of these modes in device-tree,
and software assumes the other modes are also supported, since they use
the same SerDes lanes. But a board may be able to support `1000base-x`
and not support `2500base-x`, for example due to the higher frequency
not working correctly on a particular board.

In order for the kernel to know which modes are supported on the board,
we need to be able to specify them all in the device-tree.

Change the type of property `phy-connection-type` of an ethernet
controller to be an array of the enumerated strings, instead of just one
string. Require at least one item defined.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../bindings/net/ethernet-controller.yaml     | 88 ++++++++++---------
 1 file changed, 45 insertions(+), 43 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index b0933a8c295a..05a02fdc7ca9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -56,49 +56,51 @@ properties:
     description:
       Specifies interface type between the Ethernet device and a physical
       layer (PHY) device.
-    enum:
-      # There is not a standard bus between the MAC and the PHY,
-      # something proprietary is being used to embed the PHY in the
-      # MAC.
-      - internal
-      - mii
-      - gmii
-      - sgmii
-      - qsgmii
-      - tbi
-      - rev-mii
-      - rmii
-      - rev-rmii
-
-      # RX and TX delays are added by the MAC when required
-      - rgmii
-
-      # RGMII with internal RX and TX delays provided by the PHY,
-      # the MAC should not add the RX or TX delays in this case
-      - rgmii-id
-
-      # RGMII with internal RX delay provided by the PHY, the MAC
-      # should not add an RX delay in this case
-      - rgmii-rxid
-
-      # RGMII with internal TX delay provided by the PHY, the MAC
-      # should not add an TX delay in this case
-      - rgmii-txid
-      - rtbi
-      - smii
-      - xgmii
-      - trgmii
-      - 1000base-x
-      - 2500base-x
-      - 5gbase-r
-      - rxaui
-      - xaui
-
-      # 10GBASE-KR, XFI, SFI
-      - 10gbase-kr
-      - usxgmii
-      - 10gbase-r
-      - 25gbase-r
+    minItems: 1
+    items:
+      enum:
+        # There is not a standard bus between the MAC and the PHY,
+        # something proprietary is being used to embed the PHY in the
+        # MAC.
+        - internal
+        - mii
+        - gmii
+        - sgmii
+        - qsgmii
+        - tbi
+        - rev-mii
+        - rmii
+        - rev-rmii
+
+        # RX and TX delays are added by the MAC when required
+        - rgmii
+
+        # RGMII with internal RX and TX delays provided by the PHY,
+        # the MAC should not add the RX or TX delays in this case
+        - rgmii-id
+
+        # RGMII with internal RX delay provided by the PHY, the MAC
+        # should not add an RX delay in this case
+        - rgmii-rxid
+
+        # RGMII with internal TX delay provided by the PHY, the MAC
+        # should not add an TX delay in this case
+        - rgmii-txid
+        - rtbi
+        - smii
+        - xgmii
+        - trgmii
+        - 1000base-x
+        - 2500base-x
+        - 5gbase-r
+        - rxaui
+        - xaui
+
+        # 10GBASE-KR, XFI, SFI
+        - 10gbase-kr
+        - usxgmii
+        - 10gbase-r
+        - 25gbase-r
 
   phy-mode:
     $ref: "#/properties/phy-connection-type"
-- 
2.32.0

