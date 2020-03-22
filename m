Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA54718E61E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgCVCts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:49:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40293 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbgCVCtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:49:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id t24so5249006pgj.7;
        Sat, 21 Mar 2020 19:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1VcYGik7hKP7sx1O39JIjU063LsYKhPa4fKZoVZkWgw=;
        b=roFyt3rsBBLqxTgu9tA8nmp6t57gCbc2M5qF9MSofActeFc/Mvh0aFRaXNL37bW9Bh
         8S4Bwvn3X2gTCnfrtkGDYtKqFd91lzAMQoSMvfRNjxjO30GGK88LN52L8s7/qnOro/yJ
         hyHMpujBh+3nt67IDHBXUrmx13eCyd6h9UX1/kfTl1tEb0rwn49Re7Jg4fbvHPvAf7pz
         rnwhbE6B3qFWiyxpRI4bRlzGsopE89R+P1f5IQbTL+LgkH5CodjB3rjsqyfVmT6BFXX5
         iSLR3wIgQgF8djcDYt1T6rbNEa00OA5WulywCIrEjA7g15mrlb0nw1rGgrzLXqHDFuyJ
         bitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1VcYGik7hKP7sx1O39JIjU063LsYKhPa4fKZoVZkWgw=;
        b=CTAL8dQy8rlVl6fiDdXcKZm47aHIwXAzwybiqiprSoRAkLTswTZJqBn0IIe6PlSs2a
         6jcPZnzVn3a1z8FlFgenUPUk3hegNAV7D7l3hMX7BAcBHOscToxP5GjKyALeXHYIYemi
         RXj6FyejBRcxADg9Tom38kbguQdaFAjPlU0ecNRLOoEHM3h+GLeUv+PV7HyC9KkWbqir
         VMVZm+nS9PLh00Pjr2LUMikku++ULvPDDWHbMTuEks1PXXJTtvRD8r4O+dCXOWU7iYSw
         bzTak082TUW7F/4HGvqEAzm+PKSRj7UWQY+SF2qW+lAQ65j9qoVz9Zrvq+R0W/C1mgvI
         bEwQ==
X-Gm-Message-State: ANhLgQ3aYtUD0Jav/Ffhl657DNB7Bh4AnpiJEFXIvay4FElHhXb6T3Ep
        2okeaD09xiTlSRs6XPRrAck=
X-Google-Smtp-Source: ADFU+vv7l4sVi1SoaniA998s2TLWePk++Us2HUCezuwtpm7IQzjfYMo29yW2EdhOplVUq5SC0GKAyA==
X-Received: by 2002:a63:1517:: with SMTP id v23mr15442033pgl.89.1584845385234;
        Sat, 21 Mar 2020 19:49:45 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id f64sm10111279pfb.72.2020.03.21.19.49.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:49:44 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 6/7] net: phy: introduce phy_read_poll_timeout macro
Date:   Sun, 22 Mar 2020 10:48:33 +0800
Message-Id: <20200322024834.31402-7-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322024834.31402-1-zhengdejin5@gmail.com>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it is sometimes necessary to poll a phy register by phy_read()
function until its value satisfies some condition. introduce
phy_read_poll_timeout() macros that do this.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v2 -> v3:
	- modify the parameter order of newly added functions.
	  phy_read_poll_timeout(val, cond, sleep_us, timeout_us, \
				phydev, regnum)
				||
				\/
	  phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
				timeout_us)
v1 -> v2:
	- pass a phydev and a regnum to replace args... parameter in
	  the phy_read_poll_timeout(), and also handle the
	  phy_read() function's return error.
 
 include/linux/phy.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 29718865242d..a23d6caf5c2c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -714,6 +714,19 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 	return mdiobus_read(phydev->mdio.bus, phydev->mdio.addr, regnum);
 }
 
+#define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, timeout_us) \
+({ \
+	int ret = 0; \
+	ret = read_poll_timeout(phy_read, val, cond || val < 0, sleep_us, \
+				timeout_us, phydev, regnum); \
+	if (val <  0) \
+		ret = val; \
+	if (ret) \
+		phydev_err(phydev, "%s failed: %d\n", __func__, ret); \
+	ret; \
+})
+
+
 /**
  * __phy_read - convenience function for reading a given PHY register
  * @phydev: the phy_device struct
-- 
2.25.0

