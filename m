Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E317AF0B06
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 01:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbfKFA34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 19:29:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43916 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFA34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 19:29:56 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so15842430pgh.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 16:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQn/hdpJtUBU4JXLBcANmsUsqxv2qw1rKwGzmCMjZAo=;
        b=jVQXC8BeCX0FWiJOeHNFnoeR6xuVmIEDLWUFVGMVeNOeMPLue9DiXC0Y5jsqZffeEq
         K+uA83vP0MSdkAlNO3OEvMar2FnfGklHxXcwEjSfGc1TkskmgkKWO0AcZ99Hm2bidAVJ
         Z5YgmVJ1CoPXXGmspjNqyaK63qbOVauqjo39Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mQn/hdpJtUBU4JXLBcANmsUsqxv2qw1rKwGzmCMjZAo=;
        b=AoyAswQ89Lfysfh97dbxfPJFMroj3t4wKJiXTPvIJPv4WOMKYcc5rSrVb08OljdVTk
         8PhVFAHnDbdXenuZqiO72FK1oqupRslviB0ISu6WJaHiyLzsFVO7eRLI0TIywHZ7Zq8j
         MgpSG+JVIi03jLNJKLbdc+dpm5yk3UBtZcJwBXWgDdtB1wR/6+f/2GkpjmFEn0NXzLFa
         kW3hTw9MgaOYV8G0/dlLPo0BmBOO5hOn4r6d4TDx9jjH0SwdJovkBVPOGS7Yo0PpGu3v
         g3gvD3An5p2Ksptt6FUmdzxP+6FeU5mhKgMKgBVatdPhd0Fye9k11N6gnxiTzSdaq880
         vCiw==
X-Gm-Message-State: APjAAAX569vLwjtl4+GfPsmaPVIQSA1Nm5wIz0PnWvuwM5pbENcfAfOZ
        nsgzLfhCQJs/8TZBLBlOWEW5Pg==
X-Google-Smtp-Source: APXvYqz2rCG/lEPlEh0vSeU192FAuw+9LsfJpkmg1K9UcojLZZPcV3opoR4zPGAyq7kqAjnbGyRGMQ==
X-Received: by 2002:a65:4c8b:: with SMTP id m11mr40815673pgt.25.1573000193870;
        Tue, 05 Nov 2019 16:29:53 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id k9sm21032835pfk.72.2019.11.05.16.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 16:29:53 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354 support
Date:   Tue,  5 Nov 2019 16:29:19 -0800
Message-Id: <20191106002923.109344-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
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



Abhishek Pandit-Subedi (4):
  Bluetooth: hci_bcm: Disallow set_baudrate for BCM4354
  Bluetooth: btbcm: Support pcm configuration
  Bluetooth: hci_bcm: Support pcm params in dts
  dt-bindings: net: bluetooth: update broadcom-bluetooth

 .../bindings/net/broadcom-bluetooth.txt       |  4 ++
 drivers/bluetooth/btbcm.c                     | 27 ++++++++++
 drivers/bluetooth/btbcm.h                     | 12 +++++
 drivers/bluetooth/hci_bcm.c                   | 52 ++++++++++++++++++-
 4 files changed, 94 insertions(+), 1 deletion(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

