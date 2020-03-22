Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4D18E72B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgCVG4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35485 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgCVG4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id u68so5758839pfb.2;
        Sat, 21 Mar 2020 23:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQqQn99Uv4ZIDhpnDOVOqhMEbWNDKQDeCC0lY1Dffgw=;
        b=Tw8FZtzPIfeGhI19y21NNycSY1+7m1HuUSWAXa50RKIWvvz5hH8b9/FFQkqoJSoQzv
         hGfHZwjPy+bomjxwI4VYGapudLqwC3X7JWzXwTg6e947337ihCDnZCD9W+ZYe07Lnz5E
         CRIAa9LRmBscJv/6AuStSV/ryjuwMoUXvr11UnE9+jhH9Dop1VCjV4CTL+hs3Kz+wls3
         ppReVWxbCNEPRoEqy1k1S6jd3NS1HLzPCsjXdvKJgKFdnzUnMWmvCqQoF+24AsdzCiSH
         MD+7vrIKW3vZXxpTevE8F5vZDe05eUfhiKMUkV/ZFQmexKEVpSOf0Kjvp/jAPcNmMGJg
         GD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQqQn99Uv4ZIDhpnDOVOqhMEbWNDKQDeCC0lY1Dffgw=;
        b=Y/KOMWudDFCD/a19m2GCsemO1YKimngnDKOEv0To+SHjqpLRx4Ol0LOknDt5/gzCuq
         s5LLBC2JJjlVFikjZEZab9dKD904AG/xbjz8nb86jE3TyANpnQSOfp7dEkSGc/LraFRW
         PlwFFifunj2ktrChf0v21GQcDJL6LgzlaklpynOHQBRA5TPr3sG+BLhjeA67kEn88sNL
         mr5h1gJSZXDi+9PqHXH8LF3fjd0+QO1YD1VU+yCg+EfwLyDEQWqcUTLMmQmUwieaUP6g
         n4povGpirwuMJOcjZfpBps+aMkKENCtWAkyFHuE2NVFYk0F8Us5T6uw+bczVMQU8AGqS
         8VYg==
X-Gm-Message-State: ANhLgQ3Vk55KP7eCn1q7ASzJMzHX6umSCsQYpwkzaJqO3XJCpawcnGUZ
        A6TCQ10/l2XvJ594RKMLBtg=
X-Google-Smtp-Source: ADFU+vtJMlQB6d6Z28ui+I5qtWy8JDDWMXxZKKChfoPjKk/ry8aaP8+X9kW3orvOVWcFNsdIEfJvRw==
X-Received: by 2002:a63:a361:: with SMTP id v33mr16064714pgn.324.1584860160370;
        Sat, 21 Mar 2020 23:56:00 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id z132sm7115311pgz.45.2020.03.21.23.55.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:55:59 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 0/9] introduce read_poll_timeout
Date:   Sun, 22 Mar 2020 14:55:46 +0800
Message-Id: <20200322065555.17742-1-zhengdejin5@gmail.com>
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

Dejin Zheng (9):
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
  net: phy: smsc: use phy_read_poll_timeout() to simplify the code
  net: phy: tja11xx: use phy_read_poll_timeout() to simplify the code

 drivers/net/phy/aquantia_main.c | 13 ++++--------
 drivers/net/phy/bcm84881.c      | 27 ++++---------------------
 drivers/net/phy/marvell10g.c    | 15 +++++---------
 drivers/net/phy/nxp-tja11xx.c   | 16 +++------------
 drivers/net/phy/smsc.c          | 16 +++++----------
 include/linux/iopoll.h          | 36 ++++++++++++++++++++++++++-------
 include/linux/phy.h             | 28 +++++++++++++++++++++++++
 7 files changed, 78 insertions(+), 73 deletions(-)

-- 
2.25.0

