Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C123F18E617
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgCVCtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:49:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40279 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCVCtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:49:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id t24so5248833pgj.7;
        Sat, 21 Mar 2020 19:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxTZlf+6tvrsDMK1RxMQP7zbT+yAxz48OgOEDOskWgA=;
        b=MDWIsJncHnry1pwm75IqjudXXdKuB6tKGVsYFQog9VmmM+SrnrhTuXn8fqA2Mwl31C
         JWJdGeMR0n3MTUU8szfT/GL4YGMfOcoSY63GydjoM5pFl8PpNENrDYaHhmJVOttWOCJj
         4U6vZYQJa57Hkyksxd+V1D7dHZu16kNGdmJnZzpmm3QcjbDiw+QmFk55x6L3BRz4p42n
         sXQsQTrtCdIvew9M5tJCkbuzrZ6cQYaKA/EyJDGcbge1pLFxIfngbcKKhCFaR19XlWvp
         SYgSfyiZHsuv0PMxGIJeCwHHqsWiqOfBVL8HpPsU9covooK/TWZFwdIH4zmK7ef6AMBO
         R9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxTZlf+6tvrsDMK1RxMQP7zbT+yAxz48OgOEDOskWgA=;
        b=LDGrWHIbFWWrpEno03bPXlcFh6ST/ue9G1nEI6qkYVlxsanMv8oNRDUdJJ+LrGiuuX
         bsdHa8gtun54NmKSPpWwliyNC8YyJFoxU5Ux3oeyzJjxnGHDOFWhwm4Dl+6v093Fd+ap
         SudS1ImPq70uM8FM0YxzdID/jSgnN//qm5I8OwxqkLGGiMVnDZ9WFmG+4kfZJaO/CtiP
         kONInxcUgP+l9tOt4mQTgswJGOuta8FIu9sUWwKqd9sMIF68I9SqGBAl1YatmT38NZH4
         hburKS1zEU5PVzqNmDuYKsfSzN3+44hEwystJc6bt93bT6yMxcWrzXqcVaJ5de/nW8bQ
         CEfA==
X-Gm-Message-State: ANhLgQ3nr6ukiDNG+/kFvMGy65QDtTFMTGmk4TbiT2vQFPVqikURPysT
        RX9EtvmFl3tCr1aaZZi0d9s=
X-Google-Smtp-Source: ADFU+vvdd7ejsydqLaFila5J6/viY2EKMQXoiowQQIL9xk9wP4T9+EH+BHDRJXjuVA9+QHI9mPKgXA==
X-Received: by 2002:a63:4502:: with SMTP id s2mr16074644pga.391.1584845369672;
        Sat, 21 Mar 2020 19:49:29 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id v123sm7640320pfv.41.2020.03.21.19.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:49:29 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 2/7] iopoll: redefined readx_poll_timeout macro to simplify the code
Date:   Sun, 22 Mar 2020 10:48:29 +0800
Message-Id: <20200322024834.31402-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322024834.31402-1-zhengdejin5@gmail.com>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

redefined readx_poll_timeout macro by read_poll_timeout to
simplify the code.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v2 -> v3:
	no changed
v1 -> v2:
	no changed

 include/linux/iopoll.h | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index 7d44a2e20267..29c016cd6249 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -72,25 +72,7 @@
  * macros defined below rather than this macro directly.
  */
 #define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
-({ \
-	u64 __timeout_us = (timeout_us); \
-	unsigned long __sleep_us = (sleep_us); \
-	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
-	might_sleep_if((__sleep_us) != 0); \
-	for (;;) { \
-		(val) = op(addr); \
-		if (cond) \
-			break; \
-		if (__timeout_us && \
-		    ktime_compare(ktime_get(), __timeout) > 0) { \
-			(val) = op(addr); \
-			break; \
-		} \
-		if (__sleep_us) \
-			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
-	} \
-	(cond) ? 0 : -ETIMEDOUT; \
-})
+	read_poll_timeout(op, val, cond, sleep_us, timeout_us, addr)
 
 /**
  * readx_poll_timeout_atomic - Periodically poll an address until a condition is met or a timeout occurs
-- 
2.25.0

