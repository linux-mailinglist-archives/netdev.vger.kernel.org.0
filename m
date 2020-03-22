Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E3318EB0A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgCVRuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:50:03 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35654 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCVRuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:50:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id g6so4872510plt.2;
        Sun, 22 Mar 2020 10:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qmwlS5xIuT/pca30qYGROuDmXKXBAcQ9eYLHT8tR2lo=;
        b=NHOWPtIA4T9507e44+YKSVBWFsEbzLRGMdrfadWPbkKIoZWc7EnrevPGJygmnc2q9k
         ApeRBj6fYDTDG7H6Pk74W/0LTsYNf3B4juBA/UEO9bjlt7VLkYj9hIKZ5/BxSdJrFtht
         5N2jSMcdHF0Sg1LhI4/bJvJLtxTTKAIg0ZtZS+ULwJCYKsEdTf5EIyBGhDuRjFaNINlJ
         tCkgfGSBwY0meLqPyy3IrSktWWApHcgZnrR0zAuGcVR+PG5MuR9hX+LeY8lc55b5gkyp
         wYpJqARBvwRXD2zUG2FNbEd/9hD2Bc84cp3R8hnK1IvhzodGyrqCwxOHhviqpwTCYvM5
         Fl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qmwlS5xIuT/pca30qYGROuDmXKXBAcQ9eYLHT8tR2lo=;
        b=l6A45Jef5vYBafbbFS4sfxDTVNbtBp8JUirvWBFhsSYv7fyNTBpDSmU9dlR6LV9W8R
         ebnoLs6RsNnkcejKwJ+HOvptn9uMzeuKPfd0vHtUmnFL2I62nbX7RGD4BU59O1U/JwZu
         /hQBZYRKs3Hrgj9R5esRsgwAX9T9t4vs+XTG4ZRnrIUTenWflEIDUcFGs9H+7kZmFndF
         /O0OhHKCrfUqE66g2NIHNfaTsxZXTwHWIT8y10IBwm9NlRYwBdXjG957UO5Qggk89mUY
         kyiJjwi6NSf6Zb/MOAzHFQ0l+p7tuJjHCICvNw04Xd6hZM3sJBm78zTiMdB8g8h6ddLw
         5MzA==
X-Gm-Message-State: ANhLgQ1c1omWg5UHBCRsGzTVe9ndrlFGwtzCeA6CXWBmfTQTHVk8f/Qs
        T23D5E8mqOSZd1X21dd9dqw=
X-Google-Smtp-Source: ADFU+vtr1gRnp23Ko3NgxFoE4gZYKWx86mdtBKVKHh3U58hDGxqTjSwoTEeVx7y3Bo+PZ4b5TQHHkw==
X-Received: by 2002:a17:90a:6c22:: with SMTP id x31mr20960911pjj.124.1584899400051;
        Sun, 22 Mar 2020 10:50:00 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id c128sm10887375pfa.11.2020.03.22.10.49.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:49:59 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 02/10] iopoll: redefined readx_poll_timeout macro to simplify the code
Date:   Mon, 23 Mar 2020 01:49:35 +0800
Message-Id: <20200322174943.26332-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322174943.26332-1-zhengdejin5@gmail.com>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
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
v4 -> v5:
	- no changed
v3 -> v4:
	- no changed
v2 -> v3:
	- no changed
v1 -> v2:
	- no changed

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

