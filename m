Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4826844106B
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 20:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhJaTV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 15:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhJaTV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 15:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4404060E90;
        Sun, 31 Oct 2021 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635707935;
        bh=f0CNKowKnu0Y0hiZPNL/Xt4UG4lZmb6ehucdY8vg27Y=;
        h=From:To:Cc:Subject:Date:From;
        b=KLhwvol/qTGHkqgaYhWhBmgSeNeYqCYfYGZkxd4MIQ01WsczxY8u7G0dz1LCrie5S
         Oz4cNcOUN5bquC/vAbsZbbZDOwm93wWQldoheXP3uQ+fhodlJORFAUtoXrJybnyjD+
         DGtUVlJSHLvwAaHu+eM4HAu7TVbbQp1R4qGAvAdPszhue9v92GVPyWHZSHYvgFjnwv
         ddMEnP8C+/xyuiAAAHnLJeY8pa9R7EuDd+7cNYQPEyQz/vu6nWOyS32QTa3TPyHAhN
         l431NTL17tO5EK6IROTl+uRG+GKpSPxoExynYNuKoj150QiUMo0LAio+dnIASzhMaC
         vnsFmrGKwtrEQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next] dt-bindings: ethernet-controller: support multiple PHY connection types
Date:   Sun, 31 Oct 2021 20:18:49 +0100
Message-Id: <20211031191849.15583-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes, an ethernet PHY may communicate with ethernet controller with
different PHY connection types, and the software should be able to choose
between them.

Existing example is one SerDes lane capable of `1000base-x`,
`2500base-x` and `sgmii` when connecting Marvell switches with Marvell
ethernet controller. Currently we mention only one of these modes in
device-tree, and software assumes the other modes are also supported,
since they use the same SerDes lanes. But a board may be able to support
`1000base-x` and not support `2500base-x`, for example due to the higher
frequency not working correctly on a particular board.

Another example is the Marvell 88X3310 PHY, which supports connecting
the MAC with the PHY with `xaui` and `rxaui`. The MAC may also support
both modes, but it is possible that a particular board doesn't have
these modes wired (since they use multiple SerDes lanes).

In order for the kernel to know which modes are supported on the board,
we need to be able to specify them all in the device-tree.

Change the property `phy-connection-type` of an ethernet controller to
be an array of the enumerated strings, with at least one item defined,
if the property is mentioned.

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

