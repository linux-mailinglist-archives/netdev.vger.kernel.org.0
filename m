Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BB720B565
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgFZPxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbgFZPxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6253C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so6985369wrw.1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TXd4jj3VrnsX4Z0gbuiWIwSPLhObiVWYihkAwZ1Ts88=;
        b=LzyVTZC+2w/aKBMTZUt5MmxTMo0S4iPB5P7TKJflHwzZKdn4rd0y3K20LOco+dlUxk
         Tz9hYnG8GdAPf0QoejuYICkU1uxg/XWjD6Vw0ddmX9wiLnMNUekcHwv4Dr5/QTxILq60
         EZsz/syxmrb9/0E0JW5M1PIfXFXZEiwjqymmAsAiGOAk0BoDEN2EwN1UCSVFELCert61
         cWsdvs9NRgbLY9XhQlclWmwCTUg9rCWyRxknudb5CZJ+7fhR1ckcVeBpUJN54B0bWgOD
         NVRACtezv4fkvUwQt9ltLujeOl7T/uRdkJWit63uHHPeH+WBhgEjMsHwtRZIAD9rsKb/
         SsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TXd4jj3VrnsX4Z0gbuiWIwSPLhObiVWYihkAwZ1Ts88=;
        b=YImS9lP5j7Hq2z7z5QV/TU2IygGJX7Hz0naxw9xdXZKFFawvpuhwyD9jdcrf7shHW+
         rsKn36Ez6+sAXWKiU/mThUKIMzO4lZgG4TSlXQDlhBttV2OwZ9mM3Utr55Ujyrhw8gfH
         k80Av4w8q7FcWeEKK077Wr38QiUm4iW037JuUQuG1tf6qsgAnSc0cyG+PlUDCsQHeT+T
         FCD7Maaw2NQtCnpdJk9CCOK3I0cdKOJwQMP1u0AKqKSXdjAJl3zLM3veUOaaomBLHFy/
         8lyP0m6CG+gafGIyoc4dzbmEjmy8+w0mC0egiIBh2ZV3oz33pLHrXR6+wNTWCwtlOJrG
         UinA==
X-Gm-Message-State: AOAM532M4eTy/wmaAjvx36a/3R7TqhzC2y0HCwrTxhgc45kkq7VXIPrv
        T0gHD4ugsxsOlyJk//gnCRUXag==
X-Google-Smtp-Source: ABdhPJyKKHVtWOOtFUulccfQU79SvPaG6VzL6/9uFNKgujOFJz6POSkJq7pYd70XwenzTlhd3DT6pA==
X-Received: by 2002:adf:a491:: with SMTP id g17mr4772612wrb.132.1593186823502;
        Fri, 26 Jun 2020 08:53:43 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h142sm8242791wme.3.2020.06.26.08.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:53:43 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 0/6] net: phy: relax PHY and MDIO reset handling
Date:   Fri, 26 Jun 2020 17:53:19 +0200
Message-Id: <20200626155325.7021-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Previously these patches were submitted as part of a larger series[1]
but since the approach in it will have to be reworked I'm resending
the ones that were non-controversial and have been reviewed for upstream.

Florian suggested a better solution for managing multiple resets. While
I will definitely try to implement something at the driver model's bus
level (together with regulator support), the 'resets' and 'reset-gpios'
DT property is a stable ABI defined in mdio.yaml so improving its support
is in order as we'll have to stick with it anyway. Current implementation
contains an unnecessary limitation where drivers without probe() can't
define resets.

Changes from the previous version:
- order forward declarations in patch 4 alphabetically
- collect review tags

[1] https://lkml.org/lkml/2020/6/22/253

Bartosz Golaszewski (6):
  net: phy: arrange headers in mdio_bus.c alphabetically
  net: phy: arrange headers in mdio_device.c alphabetically
  net: phy: arrange headers in phy_device.c alphabetically
  net: mdio: add a forward declaration for reset_control to mdio.h
  net: phy: reset the PHY even if probe() is not implemented
  net: phy: mdio: reset MDIO devices even if probe() is not implemented

 drivers/net/phy/mdio_bus.c    | 32 +++++++++++-----------
 drivers/net/phy/mdio_device.c | 15 +++++------
 drivers/net/phy/phy_device.c  | 51 ++++++++++++++++++-----------------
 include/linux/mdio.h          |  1 +
 4 files changed, 50 insertions(+), 49 deletions(-)

-- 
2.26.1

