Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FC242CB3C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhJMUqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhJMUqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B052461100;
        Wed, 13 Oct 2021 20:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157871;
        bh=+nyIx/R6AQMNziqWAKrYxDgrkE93NytBCbo06ykWGBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9d3dO8k7IiOiaQbcX0quv5rCIRxwco4AqXgsZBLR81lElcBef+iwOFb/9tW2HN+7
         1viPYszJDYokoefB3WVx099DA0vtVkrnNx9sEpbF+h7WE7I+MgfH9uqiatHhHouVFE
         2xLidHcchoF3ECIgBObt0xlbMCyJ1ClTs449IlIOwAdfnocfapVra65hBzU6yt+qDf
         WiiB8GTnI7iZyCSrs+5iTOY/fPUS9XvRY//qVuHD8HKUBB4mo7pMemvsoqEVFdh8Cp
         ACTcNXjuS/BDFC7ZNYbQKRjhdc92k9NtrCWfH/14+mFPam/m71ux2EERBKYk1z4DJC
         HEK5jmqHxO0fw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     devicetree@vger.kernel.org, linux-leds@vger.kernel.org,
        pavel@ucw.cz, Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 2/3] dt-bindings: leds: Add `excludes` property
Date:   Wed, 13 Oct 2021 22:44:23 +0200
Message-Id: <20211013204424.10961-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013204424.10961-1-kabel@kernel.org>
References: <20211013204424.10961-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some RJ-45 connectors have LEDs wired in the following way:

         LED1
      +--|>|--+
      |       |
  A---+--|<|--+---B
         LED2

With + on A and - on B, LED1 is ON and LED2 is OFF. Inverting the
polarity turns LED1 OFF and LED2 ON.

So these LEDs exclude each other.

Add new `excludes` property to the LED binding. The property is a
phandle-array to all the other LEDs that are excluded by this LED.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 Documentation/devicetree/bindings/leds/common.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
index a19acc781e89..03759d2e125a 100644
--- a/Documentation/devicetree/bindings/leds/common.yaml
+++ b/Documentation/devicetree/bindings/leds/common.yaml
@@ -59,6 +59,14 @@ properties:
       deprecated - use 'function' and 'color' properties instead.
       function-enumerator has no effect when this property is present.
 
+  excludes:
+    description:
+      List of LEDs that are excluded by this LED: if this LED is ON, the others
+      must be OFF. This is mostly the case when there are two LEDs connected in
+      parallel, but inversely: inverting the polarity of the source turns one
+      LED ON while the other OFF. There are RJ-45 connectors with such wiring.
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+
   default-state:
     description:
       The initial state of the LED. If the LED is already on or off and the
-- 
2.32.0

