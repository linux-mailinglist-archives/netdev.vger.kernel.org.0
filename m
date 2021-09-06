Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE8840217D
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 01:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhIFXiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 19:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhIFXiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 19:38:17 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC46C061575;
        Mon,  6 Sep 2021 16:37:10 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e7so8132966pgk.2;
        Mon, 06 Sep 2021 16:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sanJQgCOj6QndmuB/d1oi1oeHwgYC+0Otb8h+XZVNNI=;
        b=Z5I2WDWbjBd8bVxVY5zxa5Lf6V+l0DGyC/hOgiwHSrTOOen/88bEu07rDPQ4ZShBgQ
         dSUy9aWem3GOLdx3PzONf9XLsqdDFHgVstzRF+EdBjFoeY37c8bJZY+SWsOfyMsYLoWB
         iFilu0WgaYjxlK17giSFJ1D+ykz1C1SLgZqkwMFdEx+R+g1GYgJTvMBabjnJKP/crLMR
         I+ieOQGPYltTq7oDpxKVsg1Gkcpsu1ecvpEhfyNGTYzVYAhRK1ChnO+OY4qTtbQ09pny
         xwdTl1DjEIS4+AvBZrvhTOSl2gLYeRban0knGGjzJLESTLxctKuPAmy1jRDteoxQFH61
         rmwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sanJQgCOj6QndmuB/d1oi1oeHwgYC+0Otb8h+XZVNNI=;
        b=Ot2C/Uj4EXyxEJTmRJbdav8QjyBlGn/N/GYsSPwMvlc7YPQA6buG+GXRxH7L8/joJi
         Saw1XO7CW6IjojUHljyO4RBKSk50Wa7ncEXMI6Q7G5ykBXhHZvEGKmsuHciBmWkg/R1R
         HBF++RgKHO7J6qc1lMplMk465ZGRC08K/LwXs9YCeVEcFI3rJprdQMjrehoPL4fJaHgx
         HkheCgNyIJXt1d6hMRK/ryQmK378hdrKIKQDhtNKBAe1iYqjU8aMjMuAm4mviaV24gEH
         kj1zxoIp+rVSobKn2gt6tJpfleala8g3aD+R7fzf45JrEDpxrpFQUJ2oHOAuctxnmtw2
         f6SA==
X-Gm-Message-State: AOAM532MxMRm/WHbSVKnX0i5t26x/zGEvHG3NM+v5KANKQWUlvbdYrD8
        /a9vvbywMY4Wu+MwKYzWdnE=
X-Google-Smtp-Source: ABdhPJxQv460ugCPPWo2Au4TeA7NDFDB7zF3qIAdkwwmscxGUcK+DTWr5lJwt5yAdkfHSl7t2N3ENQ==
X-Received: by 2002:a62:8415:0:b0:407:8998:7c84 with SMTP id k21-20020a628415000000b0040789987c84mr14198037pfd.71.1630971429983;
        Mon, 06 Sep 2021 16:37:09 -0700 (PDT)
Received: from tong-desktop.local (99-105-211-126.lightspeed.sntcca.sbcglobal.net. [99.105.211.126])
        by smtp.googlemail.com with ESMTPSA id t68sm10890250pgc.59.2021.09.06.16.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 16:37:09 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tong Zhang <ztong0001@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Dario Binacchi <dariobin@libero.it>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] can: c_can: fix null-ptr-deref on ioctl()
Date:   Mon,  6 Sep 2021 16:37:02 -0700
Message-Id: <20210906233704.1162666-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the pdev maybe not a platform device, e.g. c_can_pci device,
in this case, calling to_platform_device() would not make sense.
Also, per the comment in drivers/net/can/c_can/c_can_ethtool.c, @bus_info
sould match dev_name() string, so I am replacing this with dev_name() to
fix this issue.

[    1.458583] BUG: unable to handle page fault for address: 0000000100000000
[    1.460921] RIP: 0010:strnlen+0x1a/0x30
[    1.466336]  ? c_can_get_drvinfo+0x65/0xb0 [c_can]
[    1.466597]  ethtool_get_drvinfo+0xae/0x360
[    1.466826]  dev_ethtool+0x10f8/0x2970
[    1.467880]  sock_ioctl+0xef/0x300

Fixes: 2722ac986e93 ("can: c_can: add ethtool support")
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/can/c_can/c_can_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
index cd5f07fca2a5..377c7d2e7612 100644
--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -15,10 +15,8 @@ static void c_can_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *info)
 {
 	struct c_can_priv *priv = netdev_priv(netdev);
-	struct platform_device *pdev = to_platform_device(priv->device);
-
 	strscpy(info->driver, "c_can", sizeof(info->driver));
-	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(priv->device), sizeof(info->bus_info));
 }
 
 static void c_can_get_ringparam(struct net_device *netdev,
-- 
2.25.1

