Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99538FD2CA
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfKOCKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:10:45 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44665 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfKOCKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:10:23 -0500
Received: by mail-pf1-f195.google.com with SMTP id q26so5549224pfn.11
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 18:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ch62hxjVdpSefcwYlahnZyqeCAtTOnSI/yL3dB0MhBQ=;
        b=ALrLjcsDVm0EOQrB8SOwdMKLw0Tm/8+MuhiLVjRl4pl7inbKRMvzmsiGEJtNGcygcc
         LW5Z2+gSHawpfK/0Uf/S+9lyhcj2Swt92ljFNd59+RNGRiLH0WFdOrnDH9g/NuxoiKuG
         q3mi7MJ94j4mm6OW3j9PXC72X4IrBsHCztyDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ch62hxjVdpSefcwYlahnZyqeCAtTOnSI/yL3dB0MhBQ=;
        b=KRlHBNLevp/fqgdB8/Pjszw2E7kTm6/iR8YSkLbSCJYFGDkwa9hcVIHi8+6eLny6B7
         Lp0UMdOxQrog6zUoxh+2R//62NqrQewnT4g4Vb/W5O+2z7BUB1wYlpQy+USBPFPbAQ5/
         bdwqo4TTJJA8/ngnlh41XwAqJpgeEsY/vQ1M8nWvNEwdFUvzEcc9wnL+FvTTkYQjG6wW
         Fuw77xnXHsJwSbyWxCcY3vvrnlQs4T3JWHqfMZFLWSL3BNrbEU/wGgKnmhFX5p7+G4Ql
         5wMmyjIoxK/b+LoL3vslgzrPZ9JiDgIUw22EDsci/tfq9IkLo77US4hMJVL1YmUv73am
         O33g==
X-Gm-Message-State: APjAAAWV4FekRO0M/acxD92TOxEOO/o7y8uLuxMvTq0f9jpz2VX5Cl+D
        0hOeSrxpPWvSqh8Gt8CZ4YYLjQ==
X-Google-Smtp-Source: APXvYqzYdBXZfAK4MFzubotYOb6Yow+SJqMu3ols8A/VwmMuYipO5dK13dmP4+/9q92Mls9ahDkafw==
X-Received: by 2002:a65:67c1:: with SMTP id b1mr7111463pgs.149.1573783821067;
        Thu, 14 Nov 2019 18:10:21 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id f7sm9695820pfa.150.2019.11.14.18.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 18:10:20 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-bluetooth@vger.kernel.org, dianders@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH v5 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354 support
Date:   Thu, 14 Nov 2019 18:10:04 -0800
Message-Id: <20191115021008.32926-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


While adding support for the BCM4354, I discovered a few more things
that weren't working as they should have.

First, we disallow serdev from setting the baudrate on BCM4354. Serdev
sets the oper_speed first before calling hu->setup() in
hci_uart_setup(). On the BCM4354, this results in bcm_setup() failing
when the hci reset times out.

Next, we add support for setting the PCM parameters, which consists of
a pair of vendor specific opcodes to set the pcm parameters. The
documentation for these params are available in the brcm_patchram_plus
package (i.e. https://github.com/balena-os/brcm_patchram_plus). This is
necessary for PCM to work properly.

All changes were tested with rk3288-veyron-minnie.dts.


Changes in v5:
- Rename parameters to bt-* and read as integer instead of bytestring
- Update documentation with defaults and put values in header
- Changed patch order

Changes in v4:
- Fix incorrect function name in hci_bcm

Changes in v3:
- Change disallow baudrate setting to return -EBUSY if called before
  ready. bcm_proto is no longer modified and is back to being const.
- Changed btbcm_set_pcm_params to btbcm_set_pcm_int_params
- Changed brcm,sco-routing to brcm,bt-sco-routing

Changes in v2:
- Use match data to disallow baudrate setting
- Parse pcm parameters by name instead of as a byte string
- Fix prefix for dt-bindings commit

Abhishek Pandit-Subedi (4):
  Bluetooth: hci_bcm: Disallow set_baudrate for BCM4354
  Bluetooth: btbcm: Support pcm configuration
  dt-bindings: net: broadcom-bluetooth: Add pcm config
  Bluetooth: hci_bcm: Support pcm params in dts

 .../bindings/net/broadcom-bluetooth.txt       | 20 ++++-
 drivers/bluetooth/btbcm.c                     | 19 +++++
 drivers/bluetooth/btbcm.h                     |  8 ++
 drivers/bluetooth/hci_bcm.c                   | 78 ++++++++++++++++++-
 include/dt-bindings/bluetooth/brcm.h          | 32 ++++++++
 5 files changed, 154 insertions(+), 3 deletions(-)
 create mode 100644 include/dt-bindings/bluetooth/brcm.h

-- 
2.24.0.432.g9d3f5f5b63-goog

