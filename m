Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29EE18E615
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgCVCt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:49:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39411 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCVCt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:49:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id b22so5250288pgb.6;
        Sat, 21 Mar 2020 19:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Btg4kroL5uDoHzhX6UOjspMfVw/QQeUQppK1EME6qU8=;
        b=rW4b0Y36Phwhh8TKEs+/U3Q/O5w+ATdCpO4LLqLNKJjlPh1YXtNiam0UTd0sXNreHl
         4TEkHhqDHBzZkuvxK/oXLgB+Z5qhQxdpRDPWayPuOS3rjSuz+Q/+hgaI+Yi6cCZAWgZU
         lhADcwtPLdnswYcQs89ofdTwjqGd5feVSd0H9ZoH6NO08K8EGAWhXpvWBamPDry0VZ65
         dZ0gSGv64QkOl3PpmBIOwPkDfFDdKLKd0kjHMbjlK7mUUP40/hLvDGSlOcAg6Ci6EsXZ
         0pWtYMNJ8qM9qBhwbk8zCzvirSgivpRYPfaVh2aKbkXhxrqX1GVieV2Yv5xQIL+0tF5Q
         Mpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Btg4kroL5uDoHzhX6UOjspMfVw/QQeUQppK1EME6qU8=;
        b=rbALfUaxDe4JQYr9elktkRgbXaO0kJRtP1Nmzn/gZBJUdp3NIi+lhNKE+5jcQkbXD7
         pghMYKspnFwDTZe0SLWN62Mc78Y9NCkqUu0MLdLYloijpKshenFO1c8uJZWfLs/x4iYm
         ATX1WxluDQp6YTTC+2jeQx2TNQv6YvPTzV8G2Xs2ZEM4TSB/ZiKTAQ81kx9aMikjU65e
         deLniDAjoYHxgV3OHwLYxelqC2I/LpG+HvrMXDfbqVz8+nZiZMUEDI/Zy4MYxBACsrS5
         3qXYZsReU+zzVsC8KV24P+Xnh49tC3wPT+NpjNpGNpdDEV26V2NIY+UnRu02MtrI4uE2
         3JRQ==
X-Gm-Message-State: ANhLgQ3CkCkzHWwJWNElAiqQjtnUZ5mWOjVEcxvKZsSJJOqpwQ2+2jdM
        EIkioQKHr+zENm8vm1kYKqE=
X-Google-Smtp-Source: ADFU+vumFGuCj9bEwX6xuBcvUJMkFtK5fEACF9AqeufcAZpC/i9Gma3jv642XkcwBKBgwvFPxn9P0w==
X-Received: by 2002:a65:5846:: with SMTP id s6mr15836059pgr.179.1584845365232;
        Sat, 21 Mar 2020 19:49:25 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id w15sm9472840pfj.28.2020.03.21.19.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:49:24 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 1/7] iopoll: introduce read_poll_timeout macro
Date:   Sun, 22 Mar 2020 10:48:28 +0800
Message-Id: <20200322024834.31402-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322024834.31402-1-zhengdejin5@gmail.com>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
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
v2 -> v3:
	no changed
v1 -> v2:
	no changed

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

