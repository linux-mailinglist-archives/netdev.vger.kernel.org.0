Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094B618EB18
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCVRtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:49:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38005 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgCVRtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:49:53 -0400
Received: by mail-pl1-f196.google.com with SMTP id w3so4863886plz.5;
        Sun, 22 Mar 2020 10:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eBI1fOyFAnh9kYunzCXwVSyGJl58uc4POnZ1ZNbJnhI=;
        b=HWbNwU4beCX3e6YY3C3JucuQ0Lf1/KuM7c2PM+v6sPA//MlFTMHYP7fByddN78jS0o
         7uNscZPdT61JQLjJVsPmFedAEGxOqjCWnj5ENKsfRFUnrEwbutCOMhR+xPlJUfvdo6/P
         9xozdPXPdrxWa7h+6iN28CNNgAH0o7qSr0BUhQk332P/JRj5WhwMe5FAbfAuHVlJdvKN
         4G3DuEbmXzKVG/FRKif2JhrjHFNBQLrvnlle9LttE1EAWCB5aQsLuHO8DhaNkFUz00Om
         5pcqwjYWcmI96XDe6joDNmPdtbFxz9oaGcHI9P9uTiVNlP0U/eUmNU4y9TqEY3Lq4kxz
         To2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eBI1fOyFAnh9kYunzCXwVSyGJl58uc4POnZ1ZNbJnhI=;
        b=TGV8erUImv0vm2XyYLZLdj5zkoq0IueubvwhTrCT2cOhhK4r5dbqKcUjkb5XGbESuj
         0Tk7iY5/RKboBXZYPOavtcjAQAjq+tK/B/ie8xhICwI8ec0ylNy2e3qCvi6eSRLnoQOD
         ZVz5e6KAESeek9oBG2zAPu3AcnE/jfM65OfzLVwtOVDmV9R1RDbohIkL14N7db9p/wBP
         bmr8qy/faHxMtukRoaZkuSj8MHc2bHKWnGAR2UKhfatbZ8QSlG0kLmF7ox0R5Rzb/aCB
         GoWjl9phjpL7N9njPcfhwL5tCCgAxOC9LwlD0m8dsju//B+Jslg0Zn03XFRXmry9DHKW
         0eLg==
X-Gm-Message-State: ANhLgQ0XQSmLp/HRBy2mKWNiGKGeWuZ3l8qLsPMmwDSCN6EPcWg3/TPX
        XoneWo259h5DvK6bXKArTWk=
X-Google-Smtp-Source: ADFU+vt+qWs5qCqT4eTDA7QOL5+LyYtp81v7eRas/d3P1xroRdbp0/pBSSxiHFMSYW46YuEDpvVtIg==
X-Received: by 2002:a17:90a:a40f:: with SMTP id y15mr21922925pjp.143.1584899390870;
        Sun, 22 Mar 2020 10:49:50 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id a3sm10965055pfg.172.2020.03.22.10.49.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:49:50 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 00/10] introduce read_poll_timeout
Date:   Mon, 23 Mar 2020 01:49:33 +0800
Message-Id: <20200322174943.26332-1-zhengdejin5@gmail.com>
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

v4 -> v5:
	- add some msleep() before call phy_read_mmd_poll_timeout() to
	  keep the code more similar in patch 6 and patch 9.
	- add a patch of drop by v4, it can add msleep before call
	  phy_read_poll_timeout() to keep the code more similar.
v3 -> v4:
	- add 3 examples of using new functions.
	- deal with precedence issues for parameter cond.
	- drop a patch about phy_poll_reset() function.
v2 -> v3:
	- modify the parameter order of newly added functions.
	  phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, \
				     phydev, devaddr, regnum)
				||
				\/
	  phy_read_mmd_poll_timeout(phydev, devaddr regnum, val, cond, \
				    sleep_us, timeout_us)

	  phy_read_poll_timeout(val, cond, sleep_us, timeout_us, \
				phydev, regnum)
				||
				\/
	  phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
				timeout_us)
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

Dejin Zheng (10):
  iopoll: introduce read_poll_timeout macro
  iopoll: redefined readx_poll_timeout macro to simplify the code
  net: phy: introduce phy_read_mmd_poll_timeout macro
  net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: marvell10g: use phy_read_mmd_poll_timeout() to simplify the
    code
  net: phy: introduce phy_read_poll_timeout macro
  net: phy: use phy_read_poll_timeout() to simplify the code
  net: phy: smsc: use phy_read_poll_timeout() to simplify the code
  net: phy: tja11xx: use phy_read_poll_timeout() to simplify the code

 drivers/net/phy/aquantia_main.c | 13 ++++--------
 drivers/net/phy/bcm84881.c      | 27 ++++---------------------
 drivers/net/phy/marvell10g.c    | 16 ++++++---------
 drivers/net/phy/nxp-tja11xx.c   | 16 +++------------
 drivers/net/phy/phy_device.c    | 17 +++++-----------
 drivers/net/phy/smsc.c          | 17 ++++++----------
 include/linux/iopoll.h          | 36 ++++++++++++++++++++++++++-------
 include/linux/phy.h             | 28 +++++++++++++++++++++++++
 8 files changed, 85 insertions(+), 85 deletions(-)

-- 
2.25.0

