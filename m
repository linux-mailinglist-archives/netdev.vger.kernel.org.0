Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648B1F3C2D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKGX1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:27:46 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35244 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfKGX1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:27:45 -0500
Received: by mail-pl1-f195.google.com with SMTP id s10so2704062plp.2
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 15:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BmFIfu3M0HZwt+Q5j2ru4f7l0bIsWe0OLM9WwddihI=;
        b=G9f2QFqbIpvPzP+ipqv0GmvyF0eGXGh9QMSFOoyB9+jjACRbO5OOZS7NIVxmaNMytG
         n07iwrwawUQCkkQ+h2iJuX5tvkGdmj+06phZZtSy00G6NxWK5tA+YY4fFcpBzQ/aoZvN
         vS+ECTdz67UOybb5+svMppyxtzMa3RqNcmQEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7BmFIfu3M0HZwt+Q5j2ru4f7l0bIsWe0OLM9WwddihI=;
        b=kuNRuWSG1VH3wRyCy2VR1mxuT9KFcvJA+6lT/47iGaTFBVJVxFWCWmjtjcgleTjIUr
         k5c3tcZWWsk6UlZMBf23A6Lj2FN/Rji/vSgHo2EsUrwVSDhC3BECRl16JgMMVl36H/Jv
         uk9QvGLJen9h1gw9jR5rqPx/EOq5cX3M4JrZUCZKyPN6STUiprLpPzc2wc5xQ1dsC+7G
         sYlk/ctUBxG4KLE0C/PNGKBjnppXsZZkzAfr/i0WHbI5oIdktO5TO9nuotxT/UbSgBmH
         2FBLBmUneKkEJ8gPdVSKpCRLrMuD+Bnl+l3Z9YWwiDp2Q0Y5j587vRQ8lDR5OUu+Yanp
         2WhQ==
X-Gm-Message-State: APjAAAXv6UrFLUrkqzsQGTAp/KEDf+Bzr2kKqZG6B5Jfzo2eySF380GQ
        bXX6z9XzFpwxBFKDP6aFFSn+7g==
X-Google-Smtp-Source: APXvYqwZ3sdkT/3KJlMbe4Hd1YyUWULxtkb2dkHIZqIJTqrSJI3u9TYS9VmzJM4iV2SkR6u0xQOIyQ==
X-Received: by 2002:a17:902:9002:: with SMTP id a2mr6824143plp.133.1573169264975;
        Thu, 07 Nov 2019 15:27:44 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id h3sm2857579pji.16.2019.11.07.15.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 15:27:44 -0800 (PST)
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
Subject: [PATCH v2 0/4] Bluetooth: hci_bcm: Additional changes for BCM4354 support
Date:   Thu,  7 Nov 2019 15:27:08 -0800
Message-Id: <20191107232713.48577-1-abhishekpandit@chromium.org>
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


Changes in v2:
- Use match data to disallow baudrate setting
- Parse pcm parameters by name instead of as a byte string
- Fix prefix for dt-bindings commit

Abhishek Pandit-Subedi (4):
  Bluetooth: hci_bcm: Disallow set_baudrate for BCM4354
  Bluetooth: btbcm: Support pcm configuration
  Bluetooth: hci_bcm: Support pcm params in dts
  dt-bindings: net: broadcom-bluetooth: Add pcm config

 .../bindings/net/broadcom-bluetooth.txt       | 11 ++++
 drivers/bluetooth/btbcm.c                     | 35 +++++++++++
 drivers/bluetooth/btbcm.h                     | 10 ++++
 drivers/bluetooth/hci_bcm.c                   | 58 ++++++++++++++++++-
 4 files changed, 112 insertions(+), 2 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

