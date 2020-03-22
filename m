Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86718E613
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgCVCso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:48:44 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50880 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgCVCso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:48:44 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so4380669pjb.0;
        Sat, 21 Mar 2020 19:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCIj8fq/q96jHYgzBLDVhdpM+eEwLuU/oTk6gStMAzM=;
        b=LK1mfyTDiod3vlsSB3jvYdhENXRmVObA9TKK+RdbV5Vaqcge4vsH/oZSNHvc1breOt
         DKvRGfLe0ozP3KK9/4DYascv4ARIsJM2XVKasFcJJ76DAVoT0IgrOjMcch1q2B/6iRlo
         snzMVMlYVofZ9pJA5YQlDKFPNrGZ+d+7QISYjiEKm3OrzZX2hhIbyh+SXCQq8hk/TC2M
         rWi+y0Dw/F6sljMzM7xy4MC1CO1UdCejB79OQgVqQB+gelMuOyA2vMSAAg87FcHR1p0E
         Y/RmGMtvBT06ZlAA8+5Tfg+yvpVf24rG4msJvGmchVHxSA3pnOoN4G4Pen4/05f/FvSH
         u3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DCIj8fq/q96jHYgzBLDVhdpM+eEwLuU/oTk6gStMAzM=;
        b=iXtcvW75yaCIaTG1c06Pb2DGjGGgJxQ/qnUBItGfygjBPKXsi1F0t+psocp2aeboHg
         kL/DHI79aepzbR44ACNN1prnYJF8vUskH7caDEcfdULHzliZ4Qco10USElWsj1a9cPa6
         EHe3XhSp5sSyJA3MZXdux0ksCR+Ll/2vTL5+syFsKKDrGH1syolzV7RABJaTV21aeIhG
         IX2nD9+qup9Mi132aoTSyWB9VBQyVEQuXAs8ozsj/c+SX/WI7Fdr2VvUQ5qJ3VGlZlxB
         934Nja1G5B8pcHWdmsDEDtSQdxsTu9vjMSgT1KQF2wryEHshsbE52XjZf4vHWlp/CrEM
         ntVQ==
X-Gm-Message-State: ANhLgQ0a5MwJMjT8mQBkwxjmph/uWgw/SIYzh8j+ZYj5mZ36h4NEEpvt
        DyYFhcvAoPhHHCGhR9ug7z0=
X-Google-Smtp-Source: ADFU+vutnZtVGO1QhqBaniTvdqYJF53udVJM+ZAyn1irF4Ke1mDcqDCkQxkomylnEkpIpLqTKxuImQ==
X-Received: by 2002:a17:902:8508:: with SMTP id bj8mr15402454plb.309.1584845321925;
        Sat, 21 Mar 2020 19:48:41 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id my15sm8429921pjb.28.2020.03.21.19.48.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:48:41 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 0/7] introduce read_poll_timeout
Date:   Sun, 22 Mar 2020 10:48:27 +0800
Message-Id: <20200322024834.31402-1-zhengdejin5@gmail.com>
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

