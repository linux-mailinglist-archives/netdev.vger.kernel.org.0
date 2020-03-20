Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9CD18CEE8
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgCTNeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:34:50 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35570 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:34:49 -0400
Received: by mail-pj1-f65.google.com with SMTP id j20so2470305pjz.0;
        Fri, 20 Mar 2020 06:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5eu/GbCyiZnNjHzfysgXyEqnee5wSOADkQwll/x5vc8=;
        b=Kkb0Ae+Dtb93ZPx/AViX9EDKFrmUoWFyBqiUMtbajNEN0i4oYP1LFcjp/wuUarf9cO
         wKMAxaBzZ3bTj7rc6oz7cfpkdCiMwXele0F/BSJJbbrSglrVSD05peY5umEibIcIgukO
         YS3sUBjKZtSh5OG/pvTjOcFtMEOGX/RMO1pN05N29LahnsX9Mgc1i4e4OpiTqDdlwkK6
         ufNWvKAGkD0+vpGwU3ycPDAPnIkxsVa6ruOnDKULB800iBaUiJkjic+kWqhZCPC/Cuzj
         JKZSEha5usp6azU7nl8HbNLMSseiLbCGoW/G/QHuN+6LmKmLOv4zX2Bv/q/H4K/3bHtw
         pDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5eu/GbCyiZnNjHzfysgXyEqnee5wSOADkQwll/x5vc8=;
        b=nPYbt1zBB8e5Rdw673ULY8VrAUdXxjcA2GNs12yWbT88XbCkWfKULD4JRZgnoqJq1q
         iH5PFGjBMcHuthfSI60PkDLrxSDK8of64/sNuLkwpHl/jp6MRReE00F23LDSAFZ4Peez
         CYPG5x1fe5cqmVPT0QNvZMGC4InIJler2HzGMxcDzsZxbLrv79OE78WIbwRj8xTKFagI
         AataqXNl/ErqjuCATOOL7CtSIWgWA4UVvw4v7d1m+KHsOjSDA6DWxkp87r1Z+9yRhVh2
         m8Mdhvpfbxh8w2GS5M0DwSP/Ug9EXBUIMM816lZs54QwbCboG4V3r1KaUpqcR73FwhWb
         Vfjg==
X-Gm-Message-State: ANhLgQ0GJikyX+4PnCFnG9cDK9co+nD4WgJzDPbYHgkjlWdOQdIsgdTF
        MeJIgJtzpzU1qxZBeBYSuko=
X-Google-Smtp-Source: ADFU+vuMaIEyV/IzK4qcmULmonDMa/U+rDy9qqcLkRTEAzKMJjS28gxA2bXFVRWDITPFhLFo9WVHvA==
X-Received: by 2002:a17:90a:24c5:: with SMTP id i63mr9343344pje.177.1584711287966;
        Fri, 20 Mar 2020 06:34:47 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id r12sm5431447pgu.93.2020.03.20.06.34.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:34:47 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 2/7] iopoll: redefined readx_poll_timeout macro to simplify the code
Date:   Fri, 20 Mar 2020 21:34:26 +0800
Message-Id: <20200320133431.9354-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
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

