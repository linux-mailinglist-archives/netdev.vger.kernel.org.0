Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D267E307
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388405AbfHATIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:08:07 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34186 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388391AbfHATIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:08:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so28493934pgc.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 12:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pilwiguV3zYj8l554M+/WPSO9NsoW5k7wuDa7fNfA6w=;
        b=d6B/+IF2td2vWdeD1vHpN67OOORdAJgapUv5FRYJObQONKvpaPjeW4VAODVXerCjz2
         FWXNpGwkp0iiuCfmurndet6Kfax4WomOZnD7nWwfy5MzHsT0lM9IoFZYPG7ljKLn+62a
         P0VR9InVbW5m5z7oCKP/42G3CAwOeXjn7cwo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pilwiguV3zYj8l554M+/WPSO9NsoW5k7wuDa7fNfA6w=;
        b=R5WibK0mLHvFIXLvBvbCA/GQ77viil/1nmKMQKEX9w4Vlk3wtYcgRPAkJTyQGyEkW9
         EyJ31dGbUmVqj+Z3faVl8r1sCHtqOoBE6RFqUAowMP5d2PY47FDJfcXxKvDtBGhf6fKD
         9rS7zgQxXs5BeeYDunNqD5VAMVVAxjr6v4ef5Fn9q57UhXPlmS38YQOUFCxhReW42bOd
         iYcNkgkgqU/xHRAbp9f9jmHFVLmKPU3VItFj3xkTYjE0vguxTDT4Cgc1pbhqXc5JYWjp
         n5f5n7aUblOJJ9W6yv1OO2D1tgsn0KbgEHySJwSGKm2WEQOK5r22vO8uF3DpDzoYp/Z8
         yHcw==
X-Gm-Message-State: APjAAAXaEOwlXIzVKr8zuvaOMJ4RofMo4KlrWXVGd/EhMtSTa46BhHQ0
        8Uwcp8xj+ijESbZVEkOaV+1qbw==
X-Google-Smtp-Source: APXvYqya0xPGEx4FHuIQWcvBMlzvjW5V53jWKyyxK/a26lJsfdRk/AV9SmfdSj4m5cFVS5OymvlNKQ==
X-Received: by 2002:a63:121b:: with SMTP id h27mr105425276pgl.335.1564686484632;
        Thu, 01 Aug 2019 12:08:04 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id 81sm67893704pfa.86.2019.08.01.12.08.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 12:08:04 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v4 1/4] dt-bindings: net: phy: Add subnode for LED configuration
Date:   Thu,  1 Aug 2019 12:07:56 -0700
Message-Id: <20190801190759.28201-2-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190801190759.28201-1-mka@chromium.org>
References: <20190801190759.28201-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LED behavior of some Ethernet PHYs is configurable. Add an
optional 'leds' subnode with a child node for each LED to be
configured. The binding aims to be compatible with the common
LED binding (see devicetree/bindings/leds/common.txt).

A LED can be configured to be 'on' when a link with a certain speed
is active, or to blink on RX/TX activity. For the configuration to
be effective it needs to be supported by the hardware and the
corresponding PHY driver.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v4:
- patch added to the series
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index f70f18ff821f..81c5aacc89a5 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -153,6 +153,38 @@ properties:
       Delay after the reset was deasserted in microseconds. If
       this property is missing the delay will be skipped.
 
+patternProperties:
+  "^leds$":
+    type: object
+    description:
+      Subnode with configuration of the PHY LEDs.
+
+    patternProperties:
+      "^led@[0-9]+$":
+        type: object
+        description:
+          Subnode with the configuration of a single PHY LED.
+
+    properties:
+      reg:
+        description:
+          The ID number of the LED, typically corresponds to a hardware ID.
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+
+      linux,default-trigger:
+        description:
+          This parameter, if present, is a string specifying the trigger
+          assigned to the LED. Supported triggers are:
+            "phy_link_10m_active" - LED will be on when a 10Mb/s link is active
+            "phy_link_100m_active" - LED will be on when a 100Mb/s link is active
+            "phy_link_1g_active" - LED will be on when a 1Gb/s link is active
+            "phy_link_10g_active" - LED will be on when a 10Gb/s link is active
+            "phy_activity" - LED will blink when data is received or transmitted
+        $ref: "/schemas/types.yaml#/definitions/string"
+
+    required:
+      - reg
+
 required:
   - reg
 
@@ -173,5 +205,20 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+
+            leds {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                led@0 {
+                    reg = <0>;
+                    linux,default-trigger = "phy_link_1g_active";
+                };
+
+                led@1 {
+                    reg = <1>;
+                    linux,default-trigger = "phy_activity";
+                };
+            };
         };
     };
-- 
2.22.0.770.g0f2c4a37fd-goog

