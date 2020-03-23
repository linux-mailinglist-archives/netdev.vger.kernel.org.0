Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8017518EE33
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgCWC46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:56:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45225 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:56:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id b9so5277960pls.12;
        Sun, 22 Mar 2020 19:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CIaJDacIEM2pET5Cxv3vrEk+VwaiqZRb/EmAApNnPZs=;
        b=dgfSrtAv4UeB4ZVPrRRtCV+Geyg7w+eEn2NT+ZLHuW7qdz6vK58+NrtyGw+ZM6tYOx
         gOduP0ALtnS0j6yIt87cIMmN9or4v/2C5Jb2WRr7N0suDQ9AujTny/NBpVRrmSmwXMwV
         SYixJn0JW75cLKQ6giWsKxgttlZEQkk/NXxIyngVne2sRSsyWxDyVC2JcZQkp9Vxvm9K
         oUknn6HEWL63+zIKFZInppTCzedX5+OZm+4bGM7HFTIP1p/H8lbE58yUO2LRkKf85t1i
         NfQmNGth87uG3/JQ4Yvrj3ufYpJPDbVTMLL+E1kv/11dV3wnl3y6nDAPks61PSi2LFXc
         z5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CIaJDacIEM2pET5Cxv3vrEk+VwaiqZRb/EmAApNnPZs=;
        b=WoJtjcR+TT3eV81rTh5XOSC5t3YmRSKC4mLRMRIrqIoY3Gm9MQ8TPJx0Ox54t9TXFx
         TO4aJD7hOdGChY6hjQYjGkh7l/hon2e2FQlLbuFemznU+G+JTnl0ZKmNXdwUboE7i/NP
         bUTuWXg5b35RjQA9BgB68MYQome1xO4UdaA0UV9OymWmjSEKyZxPZAGYbh81lPLHu2uk
         cMyuWtzwHU15alU5ReXqtY5xF6ukIQ+3Ye/THddJjTOnS4Xu22Aq41ZDrzS+pZa5yB3+
         gw7O9B1U49M31heakJ0RRf67z7EuPrdX1y3m9squp5TDLBD4+oOGzF/yL7/h1G1NQYaz
         PbJg==
X-Gm-Message-State: ANhLgQ0yZWm3bm9irdZTNUhBsXugsnBkRtz0zD2OWY3ji3RWUbvIOwXI
        fJup+54SXR6PZSXXwNsH7H1kyBVS
X-Google-Smtp-Source: ADFU+vvUrEsR7XRgDEhqSVAczw3D69SuHHm+myk/oneJkyD/2vYTdg8F78i29OmbJ3lySWnMaqKJpA==
X-Received: by 2002:a17:90a:6c22:: with SMTP id x31mr22952650pjj.124.1584932217236;
        Sun, 22 Mar 2020 19:56:57 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id a24sm11388020pfl.115.2020.03.22.19.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:56:56 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 01/10] iopoll: introduce read_poll_timeout macro
Date:   Mon, 23 Mar 2020 10:56:24 +0800
Message-Id: <20200323025633.6069-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this macro is an extension of readx_poll_timeout macro. the accessor
function op just supports only one parameter in the readx_poll_timeout
macro, but this macro can supports multiple variable parameters for
it. so functions like phy_read(struct phy_device *phydev, u32 regnum)
and phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
also use this poll timeout framework.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- no changed
v4 -> v5:
	- no changed
v3 -> v4:
	- no changed
v2 -> v3:
	- no changed
v1 -> v2:
	- no changed

 include/linux/iopoll.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index 35e15dfd4155..7d44a2e20267 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -13,6 +13,46 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
+/**
+ * read_poll_timeout - Periodically poll an address until a condition is
+ *			met or a timeout occurs
+ * @op: accessor function (takes @args as its arguments)
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @sleep_us: Maximum time to sleep between reads in us (0
+ *            tight-loops).  Should be less than ~20ms since usleep_range
+ *            is used (see Documentation/timers/timers-howto.rst).
+ * @timeout_us: Timeout in us, 0 means never timeout
+ * @args: arguments for @op poll
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @args is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define read_poll_timeout(op, val, cond, sleep_us, timeout_us, args...)	\
+({ \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __sleep_us = (sleep_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
+	might_sleep_if((__sleep_us) != 0); \
+	for (;;) { \
+		(val) = op(args); \
+		if (cond) \
+			break; \
+		if (__timeout_us && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
+			(val) = op(args); \
+			break; \
+		} \
+		if (__sleep_us) \
+			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
 /**
  * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
  * @op: accessor function (takes @addr as its only argument)
-- 
2.25.0

