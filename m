Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0378F18F828
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCWPGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32889 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id d17so6759632pgo.0;
        Mon, 23 Mar 2020 08:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ajceQ+V3zw66qFn+FAQDxPZYKnMzPixlGv65sCGTpO0=;
        b=s1e2fAiR6oBx32wFcEhUi82X7PDRtxZ3jpg+LyNIyR2i98Fp7kBZKqN/hj7dQVp8DM
         mfw4vf4CjC3yFh41Mh8J1j8ieRtm3AH6C13FWFQuJ6RZ3unnivu2+P15nGphRWoDCmsi
         MOMeAC71Kv9E6F7hEOeWXPNIx+5owixsqrUBHiWk0nyYbSByhxf21Q2rdRNQuf1bTTNF
         h7Qi7POYmW8nmA7o1/GzpJr7ingg6uYRqJsb3//j4SfN/ldweu19ClcghCtNWQ9aLR5l
         6MnUwiGpR9W0PEjjPayOMM7c0Rwlgj+Zy1PLNwqPtHn6XaK/2JQq9uFbo2atya5qJP/P
         r+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ajceQ+V3zw66qFn+FAQDxPZYKnMzPixlGv65sCGTpO0=;
        b=gER7hEsMQzF3J/l3vOJT4ZQ9zcU8nNqWZ7hEZIa+M2cfTo3hk8yf4rb7hvUhdXWerW
         SwZPfz+TFHVpLlYttI0kfha/f7OET+jHF2sshqaI4VMOUwo13M0IhSAp/pyBpqbwVwel
         7eKElmae2jb/VY5ZEBKTlGC3QLk240s3fWHFLyMt+FsdnUngPA1f2tbrhybp82F1fz27
         m58HRomq86uX5i5vREDiZRx3N0LeS80yP3LE87AVv/bMn8nv0nd6rV14Olt7UulgrmO6
         DMEjfGg2kZeNmE9e0OM0qvJBhxpDXodnG2FbbNWS2wLLUKiwiFENXGZ4CrNN4LZygm+9
         Gn+Q==
X-Gm-Message-State: ANhLgQ06MeK3NeFGOkzL6+fioxsuTCkaXNE+dsSWZQoEwYq3NWDcNjI5
        y3fjCbjjIihvr5DCYOocea8=
X-Google-Smtp-Source: ADFU+vvrocWci1SAHOFEVPIhwHInDnYdCfu5g8Z/k3fgBIJ6LIJY6sxkGmyKM9N23Q8dim4CLrjRzQ==
X-Received: by 2002:aa7:953b:: with SMTP id c27mr25124221pfp.201.1584975968013;
        Mon, 23 Mar 2020 08:06:08 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id d26sm56811pfo.37.2020.03.23.08.06.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:07 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 00/10] introduce read_poll_timeout
Date:   Mon, 23 Mar 2020 23:05:50 +0800
Message-Id: <20200323150600.21382-1-zhengdejin5@gmail.com>
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

v6 -> v7:
	- add a parameter to supports that it can sleep some time
	  before read operation in read_poll_timeout macro.
	- add prefix with double underscores for some variable to avoid
	  any variable re-declaration or shadowing in patch 3 and patch
	  7.
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

 drivers/net/phy/aquantia_main.c | 13 ++++-------
 drivers/net/phy/bcm84881.c      | 27 ++++------------------
 drivers/net/phy/marvell10g.c    | 15 +++++--------
 drivers/net/phy/nxp-tja11xx.c   | 16 +++----------
 drivers/net/phy/phy_device.c    | 16 +++++--------
 drivers/net/phy/smsc.c          | 16 +++++--------
 include/linux/iopoll.h          | 40 +++++++++++++++++++++++++++------
 include/linux/phy.h             | 27 ++++++++++++++++++++++
 8 files changed, 86 insertions(+), 84 deletions(-)

-- 
2.25.0

