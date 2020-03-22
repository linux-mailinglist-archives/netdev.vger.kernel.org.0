Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1FF18E72F
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCVG4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:12 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33590 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgCVG4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id j1so3061109pfe.0;
        Sat, 21 Mar 2020 23:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y3mml8Osh1PWGbUYRNmnqwRXsHDi7cFIAqFgkDgX/F8=;
        b=t9SNdYF0wbq4CK+nIUFYD3siyNFFFW7C+CzpztqRRHbkBX/6EDft9Stt3LbJXHzl4s
         rPJG3TJfSQfUONpTSo05cbXofbousQxx76QtHVKy6G3qaiTi6CW6Zt22A2B0T6F2YPmh
         Pv7HqopMls03lACL8zcpA++mbnxavpBeM1jMKyN04fCDt3lnYih+zckzyDTOGIsCUQCE
         Rf3vX8NnhAH7N2i/dzr3oG47LXbKqG5vyYnouHBb5frPPE3minrNObnTcPLYND+Szx4m
         LqkqZERf3juZtlG6Oen7K8zbgwCCqfxgwbfTt7m+u7cwL7O7MbFRwurO5F2ZKjM7uK3W
         cPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y3mml8Osh1PWGbUYRNmnqwRXsHDi7cFIAqFgkDgX/F8=;
        b=ZPDaXo4+sAwrvOPQU4pwXyhk/NU6ka8Q40WrWomO6ylj9Ut0/+SZazfLW2eLPqA9CS
         VRHxWWXTM98RrpFlZQVjMmV5gps6E4/2qJgqiGp1yaVWYnEciEG9nWwZMI7qh6qmox/2
         Ud+IYGrRif1D84KD3KhyZhDWagNszrWmo8J9QE5gnwN4E6cl+Cpqxf8yCw5rs77MIqEm
         O/1Jky+fuew/Q7MZZpY9Ws09MoU8q0fpaaTpD3kXAYJhLoyVs2pGZM4C8xNYBl4feAat
         iGW3o6L+q6J3RSe52GlRaGJ1ybH+zp9FnAiiTT1Kz/cG9oKwzSmF9K9aDvs1Wuh2rJDw
         69rg==
X-Gm-Message-State: ANhLgQ3yTc8ddIPCixUUS67JD4ZsTh4/mmy0FA8tclD79WaN00u9bpDZ
        rcn0tF4VK+iD8s44e6yOY60=
X-Google-Smtp-Source: ADFU+vuYBlqZ/tbaYayNTrfEREMfbaS35+L/hFKMTZSDRLmqgLxHA7NmI+bZoNP/xkgW353iACHkww==
X-Received: by 2002:a62:ce8a:: with SMTP id y132mr17956465pfg.163.1584860170531;
        Sat, 21 Mar 2020 23:56:10 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id u5sm9974026pfb.153.2020.03.21.23.56.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:10 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 2/9] iopoll: redefined readx_poll_timeout macro to simplify the code
Date:   Sun, 22 Mar 2020 14:55:48 +0800
Message-Id: <20200322065555.17742-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
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

