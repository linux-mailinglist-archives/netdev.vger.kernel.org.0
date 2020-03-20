Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71EA18CEE4
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgCTNej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:34:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45159 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:34:39 -0400
Received: by mail-pf1-f194.google.com with SMTP id j10so3222011pfi.12;
        Fri, 20 Mar 2020 06:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nb2z4/AMhcIMCMakc6EWwO7L/vzjKqviBOdIUyt8ibM=;
        b=nAxCYBmXrHFobSLiHWdQpRdDmIb332Ku2C4WDhQFAubl6i6RL41O1pYivIfZelYQCs
         O1fe2ZzNF1QCrZpewjhMAuuTPYmgmss30z9uE6AQl3XHOmmMiYGIu6iuIOlkq/dJV/8A
         TyExAvPly0Kr1klEktzo9x+BTZVdjoJ6yuD7+oyzWFdStGAKUlj94R9+wie0SoPKUrJ8
         JXid5QZJ7/29r46Brt5XkjLYiTIUqALASdzfBpVWLZIwyyO6Dgu68PWQ84VCqJdgGLMx
         8cFTLgpSckw1nBp1tXAluCuCqJdEm0QwiRvnyysy0k5x/65fLP7mOeCoRJIso+vM6duV
         LtSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nb2z4/AMhcIMCMakc6EWwO7L/vzjKqviBOdIUyt8ibM=;
        b=QSRso9nyfReaGuP16phv3ZOgk47wOAn2XR9vbiVCsmvN+YsCtvylBiXsoQ72bVgryA
         Z6sSKNN4oGEiuKJTYCO3QqmSfLuhbUZlEqNZV0Op9KrElcHihhiDodSLKH8qagrX+Fp0
         ZwezH871/yZkPZTAkzq7u3IVh2dhwW7jShAUoxKYCVTbrhSUE1gaFck3YezaHO5QWLHv
         2Z/UWNAquscNbk6UGLEKRPRx1PMp5p5I5jALB7mRDIQr0w2D8tb8V1rw/8bnDV74kaoq
         lRl83PROase/Vml41fpFgam1IrJzpJ8ujgOLRFrqJCje09SGOSRyAbiN1qcO068/lzFv
         z54Q==
X-Gm-Message-State: ANhLgQ1yzCsA6+FOI16L4WOqlWaZ2TViAL85Hpr6rm7mpOyPbiH+gF9p
        JsidRUWnvDhvf2ZVW7+3L283+oBE
X-Google-Smtp-Source: ADFU+vsC/nkTLCwfzW90pe6nDleUtkBND2JfvbYWa+fw+1Fk4qyHnpYdzR5KFIrJ5c3CDuObikvW2A==
X-Received: by 2002:a62:1dd3:: with SMTP id d202mr9761467pfd.47.1584711277858;
        Fri, 20 Mar 2020 06:34:37 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id q91sm5043241pjb.11.2020.03.20.06.34.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:34:37 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 0/7] introduce read_poll_timeout
Date:   Fri, 20 Mar 2020 21:34:24 +0800
Message-Id: <20200320133431.9354-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets is introduce read_poll_timeout macro, it is an extension
of readx_poll_timeout macro. the accessor function op just supports only
one parameter in the readx_poll_timeout macro, but this macro can
supports multiple variable parameters for it. so functions like
phy_read(struct phy_device *phydev, u32 regnum) and
phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
use this poll timeout framework.

the first patch introduce read_poll_timeout macro, and the second patch
redefined readx_poll_timeout macro by read_poll_timeout(), and the other
patches are examples using read_poll_timeout macro.

v1 -> v2:
	- passed a phydev, device address and a reg to replace args...
	  parameter in phy_read_mmd_poll_timeout() by Andrew Lunn 's
	  suggestion in patch 3. Andrew Lunn <andrew@lunn.ch>, Thanks
	  very much for your help!
	- also in patch 3, handle phy_read_mmd return an error(the return
	  value < 0) in phy_read_mmd_poll_timeout(). Thanks Andrew
	  again.
	- in patch 6, pass a phydev and a reg to replace args...
	  parameter in phy_read_poll_timeout(), and also handle the
	  phy_read() function's return error.

Dejin Zheng (7):
  iopoll: introduce read_poll_timeout macro
  iopoll: redefined readx_poll_timeout macro to simplify the code
  net: phy: introduce phy_read_mmd_poll_timeout macro
  net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: introduce phy_read_poll_timeout macro
  net: phy: use phy_read_poll_timeout() to simplify the code

 drivers/net/phy/aquantia_main.c | 13 ++++--------
 drivers/net/phy/bcm84881.c      | 27 ++++---------------------
 drivers/net/phy/phy_device.c    | 16 ++++-----------
 include/linux/iopoll.h          | 36 ++++++++++++++++++++++++++-------
 include/linux/phy.h             | 27 +++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 51 deletions(-)

-- 
2.25.0

