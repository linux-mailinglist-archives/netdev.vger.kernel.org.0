Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4C518EE36
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCWC5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37710 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id h72so4574033pfe.4;
        Sun, 22 Mar 2020 19:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N5pRC9b+TZqeGXBVT4pizfBtvFSNx4b59v8wuhoJ2XI=;
        b=K4mNAD2s5ihPCbfDl4nyisNIFDasU+g5S0J6dkudMp+/Bmpcnq6s7APcgPvFCw0ZjZ
         GkDsumFU+TwjlBCXyrti/8QZgr/RU9uFrBShsIlMrSbL86Clm1XbqX3Wj9d/2T0aupJe
         mnjnWrmJ9Fy+zWiKBkwpcI20j7To7JPpytxfPC0HyMCcjbSmWK31FLcSrVb3AM75x0GF
         5yNo1BzZXE/jDSHdJZkJ07eAP31F6E1FUANNVKfDmXR/y28dytOb3HPZ44KlBgRSCG1y
         emtrimI84MART/B6323g3cKUNkyV0nbHOmOWyor1cNIL8J+AYPqTlZ5FYvOzgl0aqsMl
         pgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N5pRC9b+TZqeGXBVT4pizfBtvFSNx4b59v8wuhoJ2XI=;
        b=LrJQoA3KSsvoQvIa9Ixm7wnFpwerf6E7c+V6EXCYQ7ZCH5ieypnNODFhGLWQMnoCAa
         oWDTN1nlg5a7Lw8eKKEv1t1qaZOSNBfxPow4lxZh2sFrNtdpX4ZClKgLxQidN4u9OXmU
         Bcvg+Uc3g5aun2Ja13m+VOsW1e1eGk1uLq9HSiEQpIDFSKDBIc+2ECrc31Y1BCRarAiJ
         6PUNEPiNQxaH6kY4logiDT5+/ykmnzvCB0wMVPgBsU7h6Gy1dyb5i0+990MJDpG3Z5XJ
         d8COIphEPjrZaUuWLG1u9tWXYC6WBr9G/aODmgYvlLpFSXU5A8QnEWiIYjRpUPDZO0Ht
         OHIQ==
X-Gm-Message-State: ANhLgQ0EV92N8UHCNqPmqoYoRRO7NBPuYYqXZPhtMAVJUKgoS6p5p/n+
        L0ODbQuKlDBMB2MMd7nk6T8=
X-Google-Smtp-Source: ADFU+vu5QIWrDvFCerkjLT3N0tWJ8Z4bxDt4dPndcYToCafWo4PwesNKqgh/olHikJJg8wqmOID+jg==
X-Received: by 2002:a63:a062:: with SMTP id u34mr20243753pgn.286.1584932224950;
        Sun, 22 Mar 2020 19:57:04 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id r8sm10575016pjo.22.2020.03.22.19.57.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:04 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 02/10] iopoll: redefined readx_poll_timeout macro to simplify the code
Date:   Mon, 23 Mar 2020 10:56:25 +0800
Message-Id: <20200323025633.6069-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
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

