Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8E762958
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391132AbfGHTZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37368 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfGHTZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so8077168pfa.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/u92z35Ke4CKIbgzmi0ZCVrrTWSoncNGXWMgkU4HjU=;
        b=hMTkzh7N34WJMex7DCQgYtT6uMIctbygBh0hRb7bTeVZciQKdfi/QkiLFqBL9FtSDP
         zj6WdZXfF3AQzeV7Wl5G6g1e+Qh08ZlUEVvu9Wug4rlbb4CFks9pS2S2RlujC/kPbauV
         6u8MODyvje12OGh9ko7dkGQqnM6WLvJOAdI3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/u92z35Ke4CKIbgzmi0ZCVrrTWSoncNGXWMgkU4HjU=;
        b=Pbigdfi2wfP0sQX3cgJ6z0s56KrC1xSYZk7pBu1Kvnt3olplPHPJEBoTh0ksYM0NlT
         gUVGrMXnyEVzot5ht8VUEiIpVNy7Y0Hv+ek1ARBa/HdpOZEAT901zUEDZJzIOi/bSMX5
         lvCSbxrUofpz+s87V6f1ZVjs5K7YvtxxELo2iKmdxRkv/Mw9y5nfDarTW2nzsY25nOi+
         0NrMLu2DSHm7wuzjBlt9b3RGxCuqXkBlVpS3WmxhDoHcdH96KHKoK9k7K9xI1auBdvEY
         dmA6DRgqKjrIWMSDrXoY42sG2n9IvMAmocaENo55tHARGHWXrw7XX9sR/BEc2F7GZCUG
         nCJw==
X-Gm-Message-State: APjAAAXvci1NmvmRxxbp90YiPBmWAiKoS8dkuFkZPPtLLEFoKdf0OYtP
        tyd+JLj6IUjFExFCYW1GwHkNdg==
X-Google-Smtp-Source: APXvYqxOSQwQ7NAwnECL2t+8NgMoEu6WfclD8cbGn9DmiABWUbcM+f3VfzhREsWQjcfcoaNhKkccsQ==
X-Received: by 2002:a63:a1a:: with SMTP id 26mr25517384pgk.265.1562613910217;
        Mon, 08 Jul 2019 12:25:10 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id u23sm20751520pfn.140.2019.07.08.12.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:09 -0700 (PDT)
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
Subject: [PATCH v3 0/7] net: phy: realtek: Enable configuration of RTL8211E LEDs and SSC
Date:   Mon,  8 Jul 2019 12:24:52 -0700
Message-Id: <20190708192459.187984-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Realtek RTL8211E allows customization of the PHY LED behavior,
like which LEDs are on for certain link speeds and which LEDs blink
when there is traffic. By default EEE LED mode is enabled, in which
a blinking LED is on for 400ms and off for 2s. This series adds
support for configuring the LED behavior through device tree
properties.

The RTL8211E supports Spread Spectrum Clocking (SSC), which reduces
clock noise that may affect other board functions. By default SSC
is disabled, this series adds support for enabling it through a
device tree property.

Certain registers on the RTL8211E can only be accessed through
a vendor specific extended page mechanism. Extended pages need
to be accessed for the LED configuration and enabling SSC. This
series adds helpers to facilitate accessing extended pages.

Matthias Kaehlcke (7):
  dt-bindings: net: Add bindings for Realtek PHYs
  net: phy: realtek: Allow disabling RTL8211E EEE LED mode
  dt-bindings: net: realtek: Add property to enable SSC
  net: phy: realtek: Add helpers for accessing RTL8211E extension pages
  net: phy: realtek: Support SSC for the RTL8211E
  dt-bindings: net: realtek: Add property to configure LED mode
  net: phy: realtek: configure RTL8211E LEDs

 .../devicetree/bindings/net/realtek.txt       |  47 +++++
 drivers/net/phy/realtek.c                     | 171 ++++++++++++++++--
 include/dt-bindings/net/realtek.h             |  18 ++
 3 files changed, 221 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/realtek.txt
 create mode 100644 include/dt-bindings/net/realtek.h

-- 
2.22.0.410.gd8fdbe21b5-goog

