Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4482E1B7E42
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgDXStd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:49:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34102 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbgDXStc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 14:49:32 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jS3O9-0006cb-MJ; Fri, 24 Apr 2020 18:49:26 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] iopoll: Introduce read_poll_timeout_atomic macro
Date:   Sat, 25 Apr 2020 02:49:14 +0800
Message-Id: <20200424184918.30360-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423063811.2636-1-kai.heng.feng@canonical.com>
References: <20200423063811.2636-1-kai.heng.feng@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like read_poll_timeout, an atomic variant for multiple parameter read
function can be useful.

Will be used by a later patch.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Cc linux-wireless.

 include/linux/iopoll.h | 62 +++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index cb20c733b15a..bc89ac625f26 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -57,6 +57,48 @@
 	(cond) ? 0 : -ETIMEDOUT; \
 })
 
+/**
+ * read_poll_timeout_atomic - Periodically poll an address until a condition is
+ * 				met or a timeout occurs
+ * @op: accessor function (takes @addr as its only argument)
+ * @addr: Address to poll
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @delay_us: Time to udelay between reads in us (0 tight-loops).  Should
+ *            be less than ~10us since udelay is used (see
+ *            Documentation/timers/timers-howto.rst).
+ * @timeout_us: Timeout in us, 0 means never timeout
+ * @delay_before_read: if it is true, delay @delay_us before read.
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @args is stored in @val.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define read_poll_timeout_atomic(op, val, cond, delay_us, timeout_us, \
+					delay_before_read, args...) \
+({ \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __delay_us = (delay_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
+	if (delay_before_read && __delay_us) \
+		udelay(__delay_us); \
+	for (;;) { \
+		(val) = op(args); \
+		if (cond) \
+			break; \
+		if (__timeout_us && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
+			(val) = op(args); \
+			break; \
+		} \
+		if (__delay_us) \
+			udelay(__delay_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
 /**
  * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
  * @op: accessor function (takes @addr as its only argument)
@@ -96,25 +138,7 @@
  * macros defined below rather than this macro directly.
  */
 #define readx_poll_timeout_atomic(op, addr, val, cond, delay_us, timeout_us) \
-({ \
-	u64 __timeout_us = (timeout_us); \
-	unsigned long __delay_us = (delay_us); \
-	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
-	for (;;) { \
-		(val) = op(addr); \
-		if (cond) \
-			break; \
-		if (__timeout_us && \
-		    ktime_compare(ktime_get(), __timeout) > 0) { \
-			(val) = op(addr); \
-			break; \
-		} \
-		if (__delay_us) \
-			udelay(__delay_us);	\
-	} \
-	(cond) ? 0 : -ETIMEDOUT; \
-})
-
+	read_poll_timeout_atomic(op, val, cond, delay_us, timeout_us, false, addr)
 
 #define readb_poll_timeout(addr, val, cond, delay_us, timeout_us) \
 	readx_poll_timeout(readb, addr, val, cond, delay_us, timeout_us)
-- 
2.17.1

