Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D063B45A887
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhKWQnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhKWQnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B23860FC3;
        Tue, 23 Nov 2021 16:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685634;
        bh=L48kIXjuaTs/4FTXMYKR2SMr9wsO+2Q7RveVzlbgxUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARyB35ZhiB99NdgF4lRr8UNgsMqwXcCNFOAVvnEcFEa3D33Xu1I6xhEhLjJOtAZrY
         2Y6iVnh5f/ShTkouSszXZ0bJq9fCpZ1tEW1/66BcrzBjpqUiO3vDtg547WgjZXmvw/
         k9MgMhT3yQiqGjccIlutPHgAlfYoUtUj0JGo4uUlXMCec1izmeIsAkylntGgJq89vX
         +o9Byyl727QhUdJ0f4hOJTwQCv4i5HYSH4ddBFI7UmlCbc61otyNSwhzQXInMLEqOB
         /1qAzaIl6CT7ZXbQP1diHTYycNs9ZjiJCbIwO+++G0oYwOjh/q6DwrfCJnGQyHsu06
         D5JX31YkjdMmA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 1/8] dt-bindings: ethernet-controller: support multiple PHY connection types
Date:   Tue, 23 Nov 2021 17:40:20 +0100
Message-Id: <20211123164027.15618-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: devicetree@vger.kernel.org
---
 .../bindings/net/ethernet-controller.yaml     | 94 ++++++++++---------
 1 file changed, 49 insertions(+), 45 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index b0933a8c295a..1fd27d45d136 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -54,51 +54,55 @@ properties:
 
   phy-connection-type:
     description:
-      Specifies interface type between the Ethernet device and a physical
-      layer (PHY) device.
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
+      Specifies interface types between the Ethernet device and a physical
+      layer (PHY) device. Since more interface types can be wired between
+      the MAC and the PHY, this property should list all that are supported
+      by the board.
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

