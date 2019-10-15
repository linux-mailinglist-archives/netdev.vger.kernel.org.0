Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C1ED8412
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733162AbfJOWuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:50:17 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33044 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfJOWuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:50:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so13425700pfl.0;
        Tue, 15 Oct 2019 15:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NkSOV4rPEF/xBI+7HXeWnh44zpsrJpGnj8aP9uw8FXY=;
        b=LyXxGJ8p/rAeB9QrMKMqbjNO98NMw9b9qnM8Ek1zfx/ukcCUD04g3axxdwqzT3EwwK
         ks3SJuoI2TzA1yRfNXa9bZzYMxP2GADdtVu6J544gsjWbdv7mGp/Bm62c9eJudBPaDAf
         aD8827n+pWax61HDiRugnfNEEOIghHlEb3BsKoRnumWCrDH67+LHcb9fjg3ZEEui8Ouo
         mDeez794kmXyP7L3BFR3aEb9SE7Vy6U7k1Pi//uLXnTLS/QuPz2vJH0KBlMFuzjOHIhw
         pNGIoP+7tklqGa1eqVqldpqEGYXMJTb16KGGH/WOJzdUZyrsA+tj9OZ8yn+jEXStTFsl
         vwsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NkSOV4rPEF/xBI+7HXeWnh44zpsrJpGnj8aP9uw8FXY=;
        b=IN1YMI1C/OTJQNWy8/j+X0mZL53PlsPYX+zcYofjUZXlfnU56W1N7ZRRgXS7mmeY3O
         S1wx6FDuq3ocJ5GZok2DFJe02eLv4usgnOSGWRnRYtIAULnlNojx0f0Bq+3/yjKX1osE
         QyB1rlb2LcPp+ZEj/pwYqCg1aEB5vtaAxl9iwRvMiZrsapRGcKMzmKfD0WmtWqQoii84
         2cqLwof8lk9HQwdQT+tKPC23W261GOYrGBLou/AMolfT6IiSplMVREFkYslPeZhDq3Nt
         5Nfyf82FjwRsxiLRdwF5BPuP3X94DWycWCUmT+2gUbr5LyUjzw07/s5TTLTttIcjB3Y7
         j9zw==
X-Gm-Message-State: APjAAAXeJhonK6Jx1syTAUudHKlWDhXXsfLUUrdtjkm8zr0tBK4EYcdE
        mnZ1FNzHQZkKkJkdwwZjG2Q9tvp2
X-Google-Smtp-Source: APXvYqwt4GC+yA+mt1hxaE8JPHGqWdZZ97I+P6t7ggaH6TLYx4/XofpEbGXxWYWkLG7PT5VrbUC5jw==
X-Received: by 2002:a63:da04:: with SMTP id c4mr40093706pgh.172.1571179816262;
        Tue, 15 Oct 2019 15:50:16 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x12sm20106171pfm.130.2019.10.15.15.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 15:50:15 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH net-next 0/2] net: phy: Add ability to debug RGMII connections
Date:   Tue, 15 Oct 2019 15:49:51 -0700
Message-Id: <20191015224953.24199-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch series is primarily intended to reduce the amount of support
involved with bringing up RGMII connections with the PHY library (or
PHYLINK) for that matter. The idea consists in looping back a packet we
just crafted and check whether it did came back correctly, if that is
the case, we are good, else we must try configuring the PHY for
different delays until it either works or we bail out.

As indicated in the commit message, future improvements could probably
be done in order to converge faster on the appropriate configuration.
This is intended to be PHY centric, and we are not playing with delays
on the MAC side other than through the parsing of the phydev->interface.

The typical output would look like this:

[   62.668701] bcmgenet 8f00000.ethernet eth0: Trying "rgmii-txid" PHY interface
[   62.676094] bcmgenet 8f00000.ethernet eth0: Determined "rgmii-txid" to be correct

Feedback highly welcome on this!

Florian Fainelli (2):
  net: phy: Use genphy_loopback() by default
  net: phy: Add ability to debug RGMII connections

 .../ABI/testing/sysfs-class-net-phydev        |  11 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/phy-rgmii-debug.c             | 269 ++++++++++++++++++
 drivers/net/phy/phy_device.c                  |  33 ++-
 include/linux/phy.h                           |   9 +
 6 files changed, 331 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/phy/phy-rgmii-debug.c

-- 
2.17.1

