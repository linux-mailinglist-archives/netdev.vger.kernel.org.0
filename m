Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AA543135
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbfFLUzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:55:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41264 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388338AbfFLUzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:55:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so18363591wrm.8;
        Wed, 12 Jun 2019 13:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lZ7Q02f4JEf34T5luLcOREHyEm4npQ5trSJ/nqzq8KI=;
        b=mg3vmtbO7GQE8XVffQtxwJcZF/oIwU11kK+Acbjymrr2vinDGw7IyBsL9IgNyBZY9n
         JLZ1XMsuYOhdNuxjBwTsptARffVdoBVduDOSs2kjL+wL4qr0Cn69+PcfWtsYo2lPTdKD
         qdZDu8w4Ept3hxTEEOvo7hmqhqvgbFNm1rGKbUXi0HrzXU9wTGDdix1/vZmZhsbf52/U
         WshRL/dw4YLGTk2yPYQTPDe32v753sbqy3j1Oc+Qh1oLxit5GuF6kl1u2b41+PmFmsWU
         jvFVIRWqhMTU+LglW3YXP38+DkPHcVWHoKnl4DyBQXl/Ftbq9KZ110zaZjuQBKV5+kLJ
         Ld2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lZ7Q02f4JEf34T5luLcOREHyEm4npQ5trSJ/nqzq8KI=;
        b=ivQOh/JdcB2qn9jzLl6p8PrGlAT7RUZ8Fi/6MFaD0AGnOBixCtHqvHKXTJ6TifVP2y
         SqI4GTf3xCwgTiPN5heG6X3+zrXMQ8aYDaMb+LGJnlb5Rpu+QNAVbl9HhgESypb4MGX6
         6COhFq9l/h0S09Qwq/OrkKJount0eQRayMk8HUEr8TDQgfzwx7cp3WS+R4fOhja1XnfG
         8UPqbbFg3JTmm3lBTGHHyqOCDgD8/HJp/qdFn1IGSbkvoMi1oYscq7zg2qoeUSo5VYjE
         DTjB37xUmPCzRPD51er8HaHqieCtZZXhDwciko6tPSdnKlLI0BNtMSXQDeKdL5iY8lO3
         ZLag==
X-Gm-Message-State: APjAAAXmhoiXhJLfygI//+fcryfNBUXW1c9vBo9qvIuWGVd3yHW2ddwI
        nWTe9XE7wJrDl2Q5hXx04Zw=
X-Google-Smtp-Source: APXvYqzPwLw3bVyQPoGki1H86cxQv/CaJAP/waZtaKCPgu6NSjHMKfqFNAFW/GHXnLzN8dcf/35BJQ==
X-Received: by 2002:a5d:6212:: with SMTP id y18mr8369049wru.178.1560372945219;
        Wed, 12 Jun 2019 13:55:45 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA400428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:33dd:a400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id s7sm3445793wmc.2.2019.06.12.13.55.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 13:55:44 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        robin.murphy@arm.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 0/4] Ethernet PHY reset GPIO updates for Amlogic SoCs
Date:   Wed, 12 Jun 2019 22:55:25 +0200
Message-Id: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While trying to add the Ethernet PHY interrupt on the X96 Max I found
that the current reset line definition is incorrect. Patch #1 fixes
this.

Since the fix requires moving from the deprecated "snps,reset-gpio"
property to the generic Ethernet PHY reset bindings I decided to move
all Amlogic boards over to the non-deprecated bindings. That's what
patches #2 and #3 do.

Finally I found that Odroid-N2 doesn't define the Ethernet PHY's reset
GPIO yet. I don't have that board so I can't test whether it really
works but based on the schematics it should. 

This series is a partial successor to "stmmac: honor the GPIO flags
for the PHY reset GPIO" from [0]. I decided not to take Linus W.'s
Reviewed-by from patch #4 of that series because I had to change the
wording and I want to be sure that he's happy with that now.

One quick note regarding patches #1 and #4: I decided to violate the
"max 80 characters per line" (by 4 characters) limit because I find
that the result is easier to read then it would be if I split the
line.


Changes since v1 at [1]:
- fixed the reset deassert delay for RTL8211F PHYs - spotted by Robin
  Murphy (thank you). according to the public RTL8211E datasheet the
  correct values seem to be: 10ms assert, 30ms deassert
- fixed the reset assert and deassert delays for IP101GR PHYs. There
  are two values given in the public datasheet, use the higher one
  (10ms instead of 2.5)
- update the patch descriptions to quote the datasheets (the RTL8211F
  quotes are taken from the public RTL8211E datasheet because as far
  as I can tell the reset sequence is identical on both PHYs)


[0] https://patchwork.kernel.org/cover/10983801/
[1] https://patchwork.kernel.org/cover/10985155/


Martin Blumenstingl (4):
  arm64: dts: meson: g12a: x96-max: fix the Ethernet PHY reset line
  ARM: dts: meson: switch to the generic Ethernet PHY reset bindings
  arm64: dts: meson: use the generic Ethernet PHY reset GPIO bindings
  arm64: dts: meson: g12b: odroid-n2: add the Ethernet PHY reset line

 arch/arm/boot/dts/meson8b-ec100.dts                   |  9 +++++----
 arch/arm/boot/dts/meson8b-mxq.dts                     |  9 +++++----
 arch/arm/boot/dts/meson8b-odroidc1.dts                |  9 +++++----
 arch/arm/boot/dts/meson8m2-mxiii-plus.dts             |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts    |  7 ++++---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dts  |  4 ++++
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts  |  9 +++++----
 .../arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts   |  9 +++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts       |  9 +++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi  |  9 +++++----
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi     |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts  | 11 ++++++-----
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 10 +++++-----
 arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts   |  8 ++++----
 arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts        | 11 ++++++-----
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts    |  8 ++++----
 17 files changed, 80 insertions(+), 66 deletions(-)

-- 
2.22.0

