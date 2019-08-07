Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61AD8519F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbfHGRE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:04:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33254 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388480AbfHGRE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:04:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so41638418plo.0
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 10:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvijXR0N1UhWnmCMLZgGc0uUllTfrVpMODKwZ+a/Lpk=;
        b=K0DdoHalNpqfXUXNlfVOTZluh1fZjO1htfDRq9m56tp8GguieWpk29NqYn/JHIlMqX
         x5omTQvbjQSqMW8FvWgPKUdfN50lnF0E8gIi/YwVkfPDfUnGC3HDSRFOOmN2hMG8jYmH
         IC0aggl0QQoDe4VmNAgyaeKoZkLunk0LyVC4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jvijXR0N1UhWnmCMLZgGc0uUllTfrVpMODKwZ+a/Lpk=;
        b=IW07I0qKVdAE/C6TMGQzeun3WSKk9qo/UM3FuePGlDPK6hdhH7lJ8kTpweu/BcwMCX
         xxkz3z97iceTJcwvs5nI8P8BMrbi6MmZMZUgNXr+W2kY2zF1w0C2V2zP3xVVs7Ee2/bK
         aVWwqinsnxNX0kLK9aP4+f8y9L3RVJFTJ4CJhWwFdZg+G34pSa0XpY2EZM0I9Ul3vBDI
         7nWy+ChwYC6LKlyiwc3k/4bq/Mg2/6Of+I6ziHi778puRp92fqcyNidxfLYQXJajbiLP
         g6ECJlVS8dX9+h+0i5A4c3OqRpFSfiZ3EEPL6lLUDs8QZJcfoCTYDxPjkyx/YPM9EWhW
         9p1g==
X-Gm-Message-State: APjAAAXJ+F36ZQ1dJvCPRaSKxzRLSe4Dw7ttrfExl6kAJiBZrlVRU3jh
        iYo7vw8YpuA8CowEhFmz6EbIPA==
X-Google-Smtp-Source: APXvYqxVB0ltkjMiFBNmYoV5UmkVDZAAacu/2A70V1J3piCWKQtT26uSS+wdaVnwrrq6Cj47oV1iCA==
X-Received: by 2002:aa7:92cb:: with SMTP id k11mr10521596pfa.126.1565197497581;
        Wed, 07 Aug 2019 10:04:57 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id i3sm98421238pfo.138.2019.08.07.10.04.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:04:56 -0700 (PDT)
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
Subject: [PATCH v5 0/4] net: phy: Add support for DT configuration of PHY LEDs and use it for RTL8211E
Date:   Wed,  7 Aug 2019 10:04:45 -0700
Message-Id: <20190807170449.205378-1-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
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

(subject updated, was "net: phy: realtek: Enable configuration
of RTL8211E LEDs")

Matthias Kaehlcke (4):
  dt-bindings: net: phy: Add subnode for LED configuration
  net: phy: Add support for generic LED configuration through the DT
  net: phy: realtek: Add helpers for accessing RTL8211x extension pages
  net: phy: realtek: Add LED configuration support for RTL8211E

 .../devicetree/bindings/net/ethernet-phy.yaml |  59 +++++++
 drivers/net/phy/phy_device.c                  |  72 +++++++++
 drivers/net/phy/realtek.c                     | 148 ++++++++++++++++--
 include/linux/phy.h                           |  22 +++
 4 files changed, 286 insertions(+), 15 deletions(-)

-- 
2.22.0.770.g0f2c4a37fd-goog

