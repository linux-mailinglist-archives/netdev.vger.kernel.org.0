Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389D87E312
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 21:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbfHATIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:08:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45625 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388367AbfHATIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 15:08:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so34595802pfq.12
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 12:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=apkwzGP4IobB8/NNejp9mcACeRe6NRoi/dm5PJtLiA0=;
        b=gwmU6JeVACTqTalB1fGyyUE6Y+PbXjWGBdnnjoYJZifDNfOrVBs4HCjUYw4malCPHU
         f0ZFovJlm75tpLkdzNnowpiCbLTcFWATBF2cpd2dPKrlDsLaUB9EeHKVXssTlrS3VPB9
         i7pbNRebrh+9jkSTAT+8daVEXlN257aIGmvQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=apkwzGP4IobB8/NNejp9mcACeRe6NRoi/dm5PJtLiA0=;
        b=k8zY1keBeMZy5KA6akbQgYzRZRD5qA0hQnyjlbeo3d/kw1uiASQ4d+UKmPO6Hpmaz6
         +wf8AafwabmEML/KhnZ6082SwVkgZfgX0t5pnWyvySqb/MpPpeBEOvwwjDBt28b/Cp7t
         GHEalbrIPYaKtB0NfLVaULEoeAjGMvnYrXJ1k2hmGe5GDOnpYGCPH6+Vbs2ySd1WQDC4
         9cmEZgl2udnc2Vinim/LPP2Nk+5ZPUvGAfOHKNgEu3o5CHuvNC0xs7KSY2q4UH4Of0zF
         TqcWhFmVuA1uoTQeok0P7afT/0luq7AV2kqTw1vg9m5PShuohF3slDhne+n+rI4B3sDi
         csOQ==
X-Gm-Message-State: APjAAAUOhT+asSSePF4Y8ZYCGodVuImycLcxeNZWLvJSrVZKeZwauvv7
        47AIqTJDxjm56yFdW7OyYTVnRw==
X-Google-Smtp-Source: APXvYqwGmPzsXWqQYmOZgCmSxakHKaF9ifqiLM5iTU08exAKI7L24QVO19d4DMzQIqU0FNUHp7xulA==
X-Received: by 2002:a62:ac1a:: with SMTP id v26mr56239768pfe.184.1564686483222;
        Thu, 01 Aug 2019 12:08:03 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id z6sm42715452pgk.18.2019.08.01.12.08.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 12:08:02 -0700 (PDT)
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
Subject: [PATCH v4 0/4] net: phy: realtek: Enable configuration of RTL8211E LEDs
Date:   Thu,  1 Aug 2019 12:07:55 -0700
Message-Id: <20190801190759.28201-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Realtek RTL8211E allows customization of the PHY LED behavior,
like which LEDs are on for certain link speeds and which LEDs blink
when there is traffic. By default EEE LED mode is enabled, in which
a blinking LED is on for 400ms and off for 2s. This series adds a
generic device tree binding for configuring PHY LEDs and adds LED
configuration support for the RTL8211E PHY.

Certain registers of the RTL8211E can only be accessed through
a vendor specific extended page mechanism. Extended pages need
to be accessed for the LED configuration. This series adds helpers
to facilitate accessing extended pages.

Matthias Kaehlcke (4):
  dt-bindings: net: phy: Add subnode for LED configuration
  net: phy: Add function to retrieve LED configuration from the DT
  net: phy: realtek: Add helpers for accessing RTL8211E extension pages
  net: phy: realtek: configure RTL8211E LEDs

 .../devicetree/bindings/net/ethernet-phy.yaml |  47 +++++
 drivers/net/phy/phy_device.c                  |  50 ++++++
 drivers/net/phy/realtek.c                     | 169 ++++++++++++++++--
 include/linux/phy.h                           |  15 ++
 4 files changed, 266 insertions(+), 15 deletions(-)

-- 
2.22.0.770.g0f2c4a37fd-goog

