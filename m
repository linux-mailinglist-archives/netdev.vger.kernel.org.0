Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D6BDB940
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 23:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441580AbfJQVpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 17:45:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40040 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395390AbfJQVpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 17:45:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so4052312wmj.5;
        Thu, 17 Oct 2019 14:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2LA+c8nL6CuddzON+vP31hmbzLON4cnG7H55TaoGvd0=;
        b=LRShpl8H8BovaIbrcZH08hJ4c5QvY1hL2S8VbYo+Cz/NJ/fQWAiPO16BGi+KVeHCrj
         tUNE2eWsS//AeNXWPM5h7cKmSRMfJ+jQ0SlKEZPbk6yIssKLPP6XjYkHh2pyeQ9zizBS
         /WGj6oVIoAZX8kXLvqdUnlwoKvAY02JwCnkC4tcfOfndggCwulJWRs2Z8HKAPDuv+eqX
         xwr13eB+Xiu9MBFvRSEwdFg3O2xCOqqCW4EJe9t2MbhmM8PM+bCHixtIU+rfLh361lmC
         l+bTxX9rvfWa+Hm21He0THh99EaQ+3zKE3ywGJgiAhpbiul+DtvsnMJeHa8vhENWxSCD
         adlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2LA+c8nL6CuddzON+vP31hmbzLON4cnG7H55TaoGvd0=;
        b=TSNytGSmm0rXReOxNgsHW8dsLC0QNoRo7YvymuwNxMQa4xAioiWX0QKQHGMA3m4cJZ
         DuAi4oMdPWpuPNQ9Vq0oMpuNgdDLzQDfg+IGNqjKneFlJjTOHiu5GXOYEr9l0y/pbsHk
         bSO9RwcO3TRF0xDDJVo89/XM8m8kf+AV5Z6do7HOrNDI1Afw7MWQWAtzgSGYhJpfhPHa
         E/MyG8xk++Uhy98UfUdcEaLrxMynnNq2Wbpl+p4/J9de0tl2WaazvrDLnQYV/NA0GPWM
         nWCpEDz/WIFkOn4K9PA7YBwRDFUx+LdW2tdE+Xqzqh2Po2KIeWOuM9WjnuQL8K/IKx/x
         8ZyQ==
X-Gm-Message-State: APjAAAWztHSsExXGE7QHzeq1dF7wV/oYVzbuRrQwRzYB0QlELknIcqKC
        2395sqd6J7Vj0ZbikBxGDzAjHk3m
X-Google-Smtp-Source: APXvYqw7sjBTvPuH6RRrsqtPEmrKTfez/QI57vIMlHDf/czI9nOlG4aHl2zNnIuZMluZkIpkaFh8yA==
X-Received: by 2002:a1c:55c4:: with SMTP id j187mr4635423wmb.155.1571348705418;
        Thu, 17 Oct 2019 14:45:05 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t203sm3977294wmf.42.2019.10.17.14.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 14:45:04 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list), hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH net-next v2 0/2] net: phy: Add ability to debug RGMII
Date:   Thu, 17 Oct 2019 14:44:51 -0700
Message-Id: <20191017214453.18934-1-f.fainelli@gmail.com>
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

[   62.668701] bcmgenet 8f00000.ethernet eth0: Trying "rgmii-txid" PHY
interface
[   62.676094] bcmgenet 8f00000.ethernet eth0: Determined "rgmii-txid"
to be correct

Feedback highly welcome on this!

Changes in v2:

- differenciate c22 vs. c45 PHYs in phy_loopback()
- print SKB length mismatch
- check that link comes back up between each iteration since we go in
  and out of loopback mode
- prevent NPD by checking attached_dev later
- moved check for af_packet_priv earlier

Florian Fainelli (2):
  net: phy: Use genphy_loopback() by default
  net: phy: Add ability to debug RGMII connections

 .../ABI/testing/sysfs-class-net-phydev        |  11 +
 drivers/net/phy/Kconfig                       |   9 +
 drivers/net/phy/Makefile                      |   1 +
 drivers/net/phy/phy-rgmii-debug.c             | 284 ++++++++++++++++++
 drivers/net/phy/phy_device.c                  |  35 ++-
 include/linux/phy.h                           |   9 +
 6 files changed, 348 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/phy/phy-rgmii-debug.c

-- 
2.17.1

