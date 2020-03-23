Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E6918EE31
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgCWC4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:56:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33601 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:56:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id j1so4084864pfe.0;
        Sun, 22 Mar 2020 19:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pycFC9yXt9fyrOJHnpwY8o/pFmsecrOugLE4ZWkikU=;
        b=q7cWyJgLILV2nwzJJrQoctiIR+8tL0fzxvNWrLtXAfbpuWq3MvGqR27FTONepz6I03
         VldrH+1hFj8vVZJwkbRYKz/I4Ds9TGavcetAOUK+jcqVwnBVTXckni7s/zdKyTf2e2hL
         ZnTa/AKFIRE5loOXRmEw9uS15S6T8TbzBYoDJio1KCc5drdXBaeffNITEm1Taax4Incx
         qYJYey2NveEdLRGaY8+kIRe3eu7T/cnXisflsiu4gy0Ysvt3sdptIK2xZ5bzg5wz9ApW
         n2Vuv5asKjnSN5pXyXf6pRdbgf24tmZFuou3F7UdRVO4gE5ZcPZBNPKRAMW2atNdQ5ii
         Zcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pycFC9yXt9fyrOJHnpwY8o/pFmsecrOugLE4ZWkikU=;
        b=qaEkyH3L+O3e9Ab5bz1JjgUgAHIlaw8M9ukg556uN2LwX1/sN8bmu6IdWV5li+x8n+
         l9AjgmxmnKvs/gKbMLNE1T/zQ9VrHqWE5C6GGGoT1wmH8nsjFJ4a0MDbJgyaRyvmujrb
         FCYz02C/f81BvIdVXC7lee9zNPtqMArSEhek7mXnb2MyYZxJ/FP3ms7By6kzZ5XYeV88
         nNKjw0xsOTWdkoJEkgmniRZ453EqvywnnXv7W9R1CwmQL1KSO1ZW2HigXnCp/U2MYyJf
         Fp+2ZthkW8UuPzSpDwZDCCNAAlpL5URv937z34Wdr0ZUk6zrC3KLEufr86B8P3tkMZuP
         7LEQ==
X-Gm-Message-State: ANhLgQ10AuQkPmAys/VdC3JHqiqAO8HL0vurS7nIzYbAOdyxC0BL5SAd
        iREk1TV6R+hQkXgMN5h3vRc=
X-Google-Smtp-Source: ADFU+vttscIcwnUDgLeK0+UYqkj1palcMSfQfIL+i9ZRWWcGSPE1j8naeLJvWlRnBqJe+SmLcKVdcw==
X-Received: by 2002:a63:5d42:: with SMTP id o2mr1371158pgm.265.1584932199206;
        Sun, 22 Mar 2020 19:56:39 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id 93sm10006709pjo.43.2020.03.22.19.56.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:56:38 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 00/10] introduce read_poll_timeout
Date:   Mon, 23 Mar 2020 10:56:23 +0800
Message-Id: <20200323025633.6069-1-zhengdejin5@gmail.com>
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

v5 -> v6:
	- add some check to keep the code more similar in patch 8
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
 drivers/net/phy/phy_device.c    | 17 ++++++----------
 drivers/net/phy/smsc.c          | 17 ++++++----------
 include/linux/iopoll.h          | 36 ++++++++++++++++++++++++++-------
 include/linux/phy.h             | 28 +++++++++++++++++++++++++
 8 files changed, 86 insertions(+), 84 deletions(-)

-- 
2.25.0

