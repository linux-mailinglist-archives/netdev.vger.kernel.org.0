Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5470618F82C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgCWPGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42726 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id 22so4008262pfa.9;
        Mon, 23 Mar 2020 08:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+b07ISFav8//v/MjE0gKDPdsioIv/EK/RPYLBuu/D8M=;
        b=nSbDNW71Y9fTVXFt+cyO473J23wNUm0zsU0Kb58F7829rGoVc9HWo7vGHUglFKvI8h
         zFMk3Y2UZH1ET45NrLqnXdorqpdjZc6T0dED6vsUMH1aGMf5rX/PnD0Fq5EwF/xKA/lc
         rQgB+mUguLXvEgpkhP4QPjv/6V0QxUUE8ENygmHAXUBF15B7T2FJmbjE4fLbeSzOWoFO
         SZrngU6U4YDsS/kB4BdkenzMwlG/XnDnxTbEEzbUITGJlPsf3htd3ARPilvSvx4FAC43
         zDnoDcTOftXD9604QmAFku6qeUszcQsfUydJQzPI23JIqJ/jRaOHr0wCVZcesc+xQELw
         d/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+b07ISFav8//v/MjE0gKDPdsioIv/EK/RPYLBuu/D8M=;
        b=rvSmeIF8wsI00ZtOUUtGmYUxcCNRr4BCsKgOTWEf1nRvBgylwwkcDEZ8+vqgugO200
         CTO8Nrp6yWqtZm/o1Ixtc5TzUeC7yRubMI7UOKhRsu37kuY47OHiu2ozRxINQM+nCqbw
         ZVQoXtJ2RMkINCxglSrqtDMw5j7j6SMZucpLx6kghlmwE+/L5KeRw9lf6/gcFPv4iopX
         pVA8X2COulX6Iok+Hkpi+Wj31jftVTtrKQphEaChIU0vqf7IHJ6MbK0WF2jjmSleD6JB
         ktDVMOxJPn0poivm0M/QuuOnviBL5TGIy2EFh0jIdJ+mSjRocx2ia5v/JdmhDFkBp7xn
         jU+w==
X-Gm-Message-State: ANhLgQ0yGwFvsQA+c0THYbrGqKwjh3oy4q3/E2spngSwfG62M3bk6sOd
        DTgfEAyU6BC+GRODG8EfOto=
X-Google-Smtp-Source: ADFU+vv1fkUhWxqRC2vP/bVVS6MRL+x7JxynGSZWctNRTFa51SvJcu6E7/xhdMyqUv4zaeZdo6vNuA==
X-Received: by 2002:aa7:91cb:: with SMTP id z11mr24845432pfa.126.1584975991217;
        Mon, 23 Mar 2020 08:06:31 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id s15sm13689823pfd.164.2020.03.23.08.06.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:30 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 02/10] iopoll: redefined readx_poll_timeout macro to simplify the code
Date:   Mon, 23 Mar 2020 23:05:52 +0800
Message-Id: <20200323150600.21382-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323150600.21382-1-zhengdejin5@gmail.com>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
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
v6 -> v7:
	- adapt to a newly added parameter sleep_before_read.
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
index 70f89b389648..cb20c733b15a 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -76,25 +76,7 @@
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
+	read_poll_timeout(op, val, cond, sleep_us, timeout_us, false, addr)
 
 /**
  * readx_poll_timeout_atomic - Periodically poll an address until a condition is met or a timeout occurs
-- 
2.25.0

