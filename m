Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A627D42CB40
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhJMUqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhJMUqh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABB416113E;
        Wed, 13 Oct 2021 20:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157873;
        bh=Z3DQ+Z4nxCDiFf5YjNS+6ibcgkKch/WFjfU7mmSJe5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOou6/xVP9Bbq6KxlSMJ7usDWiCY1lhmNehP5uc/EbFKYKvSXwMP3lryuFLNGZHb6
         x0ST6J8TBqrWBdleHeL9p2EjzjeHu6DR4MN8xutFJnCxmrSQAAwQj0B6E6bSTIS+Ah
         0sbEeW+SKL9x89E4EslKn7xla7ZXa3Q4q/YAq0j9t52A0Bi28jHqKO6XRhYVi3qMaf
         LmDA7KhRsYPAhjcjEPetk4V7y24X7jVaErMkVJ0MCqvwfxSW3vGZ0hCv2bJTKOCuZV
         uTmZCFQY5vtPOZdVBSP1sUaE8uDl5rWQERMQ63FQUWwEzsMg1PL1kcNZklKjumnBmX
         P3TqZetfsQoGA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     devicetree@vger.kernel.org, linux-leds@vger.kernel.org,
        pavel@ucw.cz, Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 3/3] dt-bindings: leds: Allow for multiple colors in the `color` property
Date:   Wed, 13 Oct 2021 22:44:24 +0200
Message-Id: <20211013204424.10961-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013204424.10961-1-kabel@kernel.org>
References: <20211013204424.10961-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some RJ-45 connectors have one green/yellow LED wired in the following
way:

        green
      +--|>|--+
      |       |
  A---+--|<|--+---B
        yellow

But semantically this is still just one (multi-color) LED (for example
it can be controlled by HW as one dual-LED).

This is a case that we do not support in device tree bindings; setting
  color = <LED_COLOR_ID_MULTI>;
or
  color = <LED_COLOR_ID_RGB>;
is wrong, because those are meant for when the controller can mix the
"channels", while for our case only one "channel" can be active at a
time.

Change the `color` property to accept an (non-empty) array of colors to
indicate this case.

Example:
  ethernet-phy {
    led@0 {
      reg = <0>;
      color = <LED_COLOR_ID_GREEN LED_COLOR_ID_YELLOW>;
      function = LED_FUNCTION_ID_LAN;
      trigger-sources = <&eth0>;
    };
  };

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../devicetree/bindings/leds/common.yaml         | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index 03759d2e125a..492dd3e7f9ac 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -37,13 +37,21 @@ properties:
     $ref: /schemas/types.yaml#/definitions/string
 
   color:
-    description:
+    description: |
       Color of the LED. Use one of the LED_COLOR_ID_* prefixed definitions from
       the header include/dt-bindings/leds/common.h. If there is no matching
       LED_COLOR_ID available, add a new one.
-    $ref: /schemas/types.yaml#/definitions/uint32
-    minimum: 0
-    maximum: 9
+
+      For multi color LEDs there are two cases:
+        - the LED can mix the channels (i.e. RGB LED); in this case use
+          LED_COLOR_ID_MULTI or LED_COLOR_ID_RGB
+        - the LED cannot mix the channels, only one can be active; in this case
+          enumerate all the possible colors
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    items:
+      minimum: 0
+      maximum: 9
 
   function-enumerator:
     description:
-- 
2.32.0

