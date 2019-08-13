Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195A48C152
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfHMTL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:11:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43315 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfHMTLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 15:11:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so4349671pfn.10
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUQw1gzY+2u1O9xiTfFMM+UyeEs+TCFLOE05raHDrEk=;
        b=FDJPC7ypuE9mls/enQE4a/f5cvsRt5EgFgfdHAFW7EbY0yOkFxAY56g3jBNt72xTYy
         RB5xl/ko8wqEtGBZN50hgF+AwhGON6FD7+YkCFI1j3x65J86h1ouy6kq6/IiVdsohlfh
         7FxMs60Yco75c8f3sjMePu4pW79u9l6J7fBaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUQw1gzY+2u1O9xiTfFMM+UyeEs+TCFLOE05raHDrEk=;
        b=p8SsVjmU/ZYx2TsI56sMLdJ7UyItIjpI/LG4DyuoHGNWUx4pckyTQS2ZZmK8L0tv/5
         a8XJlfLpCAtx/9auBjt2ZjvIXF7sQs/apKHwNZPbat62fwrMx2iLvQFMoEIN4Pm2x/r3
         9bo7JooGufy1Xlk1K7nI1YejtMwx+Xw/mVP5s92+X3f3pQ76R4TefCroYL741/3VLYQk
         /q8qVXxQzAGkw+3AuSElBwuHYYqhm0TATfP6M9GIxAVY7LYiy02BXxlRWvQYFInrPwH9
         M1PKNYY/sYm0HI0+DfRvArxPgDDnm21pr+xVM9S4y1z2OyM3kJJR43lhqf676cPsYPbV
         qBrw==
X-Gm-Message-State: APjAAAVeG8XdpSeqkmNEElsDlmU861K0D6gIyI4rxPOCEAvXxJGjIsYW
        D7dubKwbMMC8b5KHcSMuTfOz/Q==
X-Google-Smtp-Source: APXvYqzlu/F8V1w3r2GIwuoeaxUHJxJy7XCMy3Xw/LHRtkB/82GTcqpB5crY4+VYjjUXwn46miSYIw==
X-Received: by 2002:aa7:91cc:: with SMTP id z12mr42474700pfa.76.1565723515189;
        Tue, 13 Aug 2019 12:11:55 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id z63sm84970326pfb.98.2019.08.13.12.11.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 12:11:54 -0700 (PDT)
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
Subject: [PATCH v6 0/4] net: phy: Add support for DT configuration of PHY LEDs and use it for RTL8211E
Date:   Tue, 13 Aug 2019 12:11:43 -0700
Message-Id: <20190813191147.19936-1-mka@chromium.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a generic binding to configure PHY LEDs through
the device tree, and phylib support for reading the information
from the DT. PHY drivers that support the generic binding should
implement the new hook .config_led.

Enable DT configuration of the RTL8211E LEDs by implementing the
.config_led hook of the driver. Certain registers of the RTL8211E
can only be accessed through a vendor specific extended page
mechanism. Extended pages need to be accessed for the LED
configuration. This series adds helpers to facilitate accessing
extended pages.

Matthias Kaehlcke (4):
  dt-bindings: net: phy: Add subnode for LED configuration
  net: phy: Add support for generic LED configuration through the DT
  net: phy: realtek: Add helpers for accessing RTL8211x extension pages
  net: phy: realtek: Add LED configuration support for RTL8211E

 .../devicetree/bindings/net/ethernet-phy.yaml |  59 ++++++++
 drivers/net/phy/phy_device.c                  |  72 +++++++++
 drivers/net/phy/realtek.c                     | 137 ++++++++++++++++--
 include/linux/phy.h                           |  22 +++
 4 files changed, 275 insertions(+), 15 deletions(-)

-- 
2.23.0.rc1.153.gdeed80330f-goog

