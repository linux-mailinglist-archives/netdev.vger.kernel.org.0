Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012B818F82A
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCWPGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:22 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50286 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:21 -0400
Received: by mail-pj1-f68.google.com with SMTP id v13so6312358pjb.0;
        Mon, 23 Mar 2020 08:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmXKgcJDZee4jC3cNKHKWCJhJ0kS9L2vONq2fIA+AaY=;
        b=N1ACwCYlon7WkTCOGFsGWeQq6lNeUjbuQa8UGIBK7O82wFqYoTVzGY8MUnU/tEjer9
         AtZt9996i6pDsvhpbunlFffuKPui1YOisSe6Xcn6Ur2AiFvfJr1DMpWE2PdmlLGH2bkH
         /Oiqbikpi9dSUfgFJ7JfIyISqKyP15jsdhhl8xtA30gWb6CuhlhBuWuLV5CqTAZKGWab
         LMFipg2GDKlx0udJoUoNAPi/hcypdWJW8DtamDxwH/OmZk2evJsfhm2MwG/1qAb95nJ0
         rU/60e4BhqadPHfO9cyvgdbR+xcCJkuSIqKWH6utfd9RamZDS2djU3XDWhFW2blmcVLb
         Ue5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmXKgcJDZee4jC3cNKHKWCJhJ0kS9L2vONq2fIA+AaY=;
        b=AwMmzIpdEKD6duSw3Dl9aQkzxRMmPOysumBp0nIE9FvhZJ+67auGBvMa7G80/DyF4x
         BbrwsUrYoDLXs7fuLEjjZgxKwSCtYfWyPDdM/ezShIx9KZIfPiXhn6uH3eXP+g4feJN4
         IlWVwvJMDzRJOhdZVzg934FJeMs4bW7XNm07jKxjsqksHGcw5JoHsP53xNegPbIpNb8X
         h7+AwHXYAKzVC9aGYTA8bgxSD0d+SlO7CJ4nY+lHXcBR266/rt7rDFOwCdv9TUUAMCkY
         rXrgSb8vThpKY/wZ8rK3SyJcPdvDt6TnmdZO7LqTbbzAHjzJml7s+5vYhk3CSOvjGTHt
         KcMA==
X-Gm-Message-State: ANhLgQ1lOBl50y5dc6fz/BIFJrpgXnM0GF/1DvoZm8oJbZIt2H9n38WA
        pBi6LVse2n2Ed5tvz68N8x8=
X-Google-Smtp-Source: ADFU+vtPoQt/0UFiy7Bq0L9uIMvQbBOJzH8+jTojBCcjj2V26XqJvxqSMSsy9g8ZZ96F/Q8I4cpXYw==
X-Received: by 2002:a17:902:9a09:: with SMTP id v9mr21358610plp.341.1584975980336;
        Mon, 23 Mar 2020 08:06:20 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id j19sm13485589pfe.102.2020.03.23.08.06.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:19 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 01/10] iopoll: introduce read_poll_timeout macro
Date:   Mon, 23 Mar 2020 23:05:51 +0800
Message-Id: <20200323150600.21382-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323150600.21382-1-zhengdejin5@gmail.com>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
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
also use this poll timeout core. and also expand it can sleep some time
before read operation.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v6 -> v7:
	- add a parameter sleep_before_read to support that it can sleep
	  some time before read operation in read_poll_timeout macro.
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

 include/linux/iopoll.h | 44 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index 35e15dfd4155..70f89b389648 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -13,6 +13,50 @@
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
+ * @sleep_before_read: if it is true, sleep @sleep_us before read.
+ * @args: arguments for @op poll
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @args is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define read_poll_timeout(op, val, cond, sleep_us, timeout_us, \
+				sleep_before_read, args...) \
+({ \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __sleep_us = (sleep_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
+	might_sleep_if((__sleep_us) != 0); \
+	if (sleep_before_read && __sleep_us) \
+		usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
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

