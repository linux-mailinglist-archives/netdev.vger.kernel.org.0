Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9305718E72D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCVG4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40847 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgCVG4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:05 -0400
Received: by mail-pl1-f196.google.com with SMTP id h11so4435881plk.7;
        Sat, 21 Mar 2020 23:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZM8wvTtYvpXnviz8HWwxHoA2znSxp1yEpAeU7czbtT8=;
        b=DTDH4+IDTnbGI9cILLWNa3m0qR0o07jeBftz0rL8ZNLzCJFd9HlbfxELtC/mjHWtEt
         MJoARwlnS0L9RUc7vGRCYe15XXOiB0IqAMUSGgVi4+rFjgPAtKL+10HImET3H17BjQUW
         HPB+tXRn92HxqWJtYIDpPiIjKxDmaC6lVfQhM1u4TchZjN+qzO4mVVRDf+Szi+KV2f52
         UBVAZ0tYSV8ukUCT5dWvGyGAshO9Szf2Lo9Phjqi+TBXP5nyCQEzf//1KGfg9f06EqKl
         ZgUSn0WLdiIgiuxw1Swx3HcyR3N8zzCVgKcq+Fcj4LuTrp6wo1mjmkGaPgQNy6QVMV+M
         KLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZM8wvTtYvpXnviz8HWwxHoA2znSxp1yEpAeU7czbtT8=;
        b=aOkTspxsIhr7ZBAkOZSfnDpZbFsjqaAYyy6TLN6JlzioWJVGye+/iQnfFYYeM6NX0K
         c/tn+4qOVAwx4p7TqptG3buCUdexsKkMrutvf3F5qGjVPllblwFo13dP54gh6yFcPaJY
         bM/7VIyvPRBbCwjoTjw55b6es0URng/bTxvhSHjoDSi8RE1y77DFjoJVejUsjr8AMZh9
         ZWc30cJj1/cgWOkdq0DXmpgSRkiwg2RhqEJoYJi9rRSgOAl/OiqPaVcMWPZjcUHSEKES
         huVhBtvXKiM4eoAkMewHDKHF5mBL7hv+1XfY0ZArrnnafPfPwzLIJYjIC2W+qmoHv82Q
         qLVQ==
X-Gm-Message-State: ANhLgQ2bADCAQmntJAUpS0jDRtnfASPeeMKEJrZnblzmtFC0pkwhTfXY
        r64OiCiKKMnGRDKVHvlA0nI=
X-Google-Smtp-Source: ADFU+vviqPT+s7b6YP3EFcmY3FjO5fiSotojzrn1CcNeB0eAA5f5PzpNdquAUDEPMDmkqpJAHmZJlw==
X-Received: by 2002:a17:90a:26ef:: with SMTP id m102mr18404329pje.173.1584860164939;
        Sat, 21 Mar 2020 23:56:04 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id h26sm9980090pfr.134.2020.03.21.23.56.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:04 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 1/9] iopoll: introduce read_poll_timeout macro
Date:   Sun, 22 Mar 2020 14:55:47 +0800
Message-Id: <20200322065555.17742-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
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

