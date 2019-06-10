Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7EDE3B9AB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfFJQh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:37:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44596 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfFJQh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:37:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id b17so9856297wrq.11;
        Mon, 10 Jun 2019 09:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sh13vqQhVeUIp4ueCnaiflQcpY8w0hvllTIAtF32R/Y=;
        b=c6QlcPSWKF3BsvTZ/GIitZ8/3RkBf+tAU+lNnFvq9R0cwY7ZSTiKjHM58uNS9AvEuL
         8sykECWPbbVW0Po663W/EyEhlwwIZRkAmPC7YUl4tL+VGMSmScl+W18I7BYC5kCPXz1Y
         35WDuuUcnqFmF2kH9d0/og7OAQbbBIFTdfyzP3jmbVgb1RRena6AxnKrtesKwdr3sqs6
         33uVwN3IyoM8VTpXPN5emJgiwxo3HWFHTLyXiTX+TPGTJY4IBA7MB1WicpFOwY/pmDMb
         EjP1W140eDFQ20VCtf6Byv0h7MwSkzqDV/00u81EHXq1iM/5aGRJi+3emTRpE1s8HDxb
         mLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sh13vqQhVeUIp4ueCnaiflQcpY8w0hvllTIAtF32R/Y=;
        b=MMZZm3bB6ujKMlodsdGr85uCjltY6U9cqshYyYiFnJOLEm9fThXRFt7wziZH6bPyph
         QHtFpG+oGN/NdEE9y02y1fJQHxULY31kXDnWS0On3zwQrHLMAxuOzPwOIHbLiywg4jqk
         xMPORU9/wYnrLrHy06JKg2DixQpasR6wo6kMWRGPywgL+juEoMzOKeL8mB0zuL0Ar4vN
         5PKL7/U3bWW8BB7FuyoZ1Xroi4Frwb6vDMLh9bJIGbV7U5XzaDhcFcERHV4xcBcdqZQg
         9UX3bm7ybQTomWCJoa2ZKkBc/hZG1/jT4VLoIZ163iYKoZcv64Cee2Xmr/CaZhj2gcbC
         n5yg==
X-Gm-Message-State: APjAAAV/LFIwxXoK8LHd8DWv7q3fLiTJmLnOkA4VemsW+XMmN0oOLfoY
        DKTSnqymoCzRQozv/dBqB/E=
X-Google-Smtp-Source: APXvYqydlQA+PLFxW4LDdRVC2OqHQ48h8LCrH5vskDoOkpLzQroMIZP5WjRCaEJpvZm70zC3KggTFw==
X-Received: by 2002:a5d:53ca:: with SMTP id a10mr32962184wrw.131.1560184675468;
        Mon, 10 Jun 2019 09:37:55 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133DDA40000C4C39937FBD289.dip0.t-ipconnect.de. [2003:f1:33dd:a400:c4:c399:37fb:d289])
        by smtp.googlemail.com with ESMTPSA id g5sm13900517wrp.29.2019.06.10.09.37.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:37:54 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/4] Ethernet PHY reset GPIO updates for Amlogic SoCs
Date:   Mon, 10 Jun 2019 18:37:32 +0200
Message-Id: <20190610163736.6187-1-martin.blumenstingl@googlemail.com>
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


[0] https://patchwork.kernel.org/cover/10983801/


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

