Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8C18EB19
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCVRt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:49:59 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52484 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgCVRt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:49:57 -0400
Received: by mail-pj1-f66.google.com with SMTP id ng8so5010009pjb.2;
        Sun, 22 Mar 2020 10:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y6ygVFYqMzt2De4r6GDL67AxV7bnQMxmtxe+tWMMmbQ=;
        b=pN3Mim6muNyc7udwZzmuWD4AWAHO1zuyiiRdb8q4cMnhpuyYzy+HaI0thchVjCDY6S
         ISwG8zZpspUERPG94L+4Og2NZOc3+XMO7pDCRTrZ45FDkKKdOLb83BJlUOz3bQ627V7k
         xHs6gEyVCskuDdnge0odpvqj2xxZAVqzhFLmFZCnrRMrlMRizz5CUA8dJCRa5nZQFZAJ
         coL8+1kKuSgiCHdAFf7sZoPapYgr8EBwep5OmSeZd/0AoYYMnC7K+CwOs6IK33ufufQJ
         91+e5sn6es0QOpSsYks16FEIVthfCXZFDxiET5vIwff5h29dW17GaXsB/9LfT1IX4Y/h
         k3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y6ygVFYqMzt2De4r6GDL67AxV7bnQMxmtxe+tWMMmbQ=;
        b=glhOSRLOIaZobhu+HAEnhoZh8z+ye3/gFle+BOQuaJ9TnY7Hpz8S0V9EN73r/WIYfK
         WvY6GtgZZNieHd3zbccLuCXMavtuLywHdxZGolcytSvBnZz6dykR+wKDEKACC+0qMbVk
         D1T9mWiwVyycGuYBOzSgGqEFS7Uca6ig0UDmR5c8riqxT5DBQ9N0i49kwUHmP5M5psQ1
         mjUs0GHpvkLdtkgawYf9u5cJr0DwAfP78qLhr3hxvWJdz7c5uSHIiuUXHZ/kh02P4v7Z
         x+zW4DFrL8LdI/XIfGBkkM0RsUjhTjFYZyIqeYvkFVVzm44e8FxsAKwH7nAlEu+MZLHP
         6axQ==
X-Gm-Message-State: ANhLgQ22LAnNbKo2JERtSjssq/wmdWI/IRiWFE0+uKMCkluQ+vHxi0GF
        DzkKdHG5udV/IhbPciBn+TA=
X-Google-Smtp-Source: ADFU+vt6T37tW8x+Rkrx3qm7lQ1EZuux4e1WSMCSr2mC6XYMjjTJaSm5Z3KbPrqVO+Ce2SmNOXIoqg==
X-Received: by 2002:a17:90a:5805:: with SMTP id h5mr9098496pji.175.1584899396035;
        Sun, 22 Mar 2020 10:49:56 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id s4sm3121073pgm.18.2020.03.22.10.49.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:49:55 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 01/10] iopoll: introduce read_poll_timeout macro
Date:   Mon, 23 Mar 2020 01:49:34 +0800
Message-Id: <20200322174943.26332-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322174943.26332-1-zhengdejin5@gmail.com>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
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

