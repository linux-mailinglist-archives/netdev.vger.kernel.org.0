Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EE74453EC
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhKDNfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhKDNfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:35:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0061AC061203;
        Thu,  4 Nov 2021 06:32:59 -0700 (PDT)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636032778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aW6ZznmXqA8zEDZbkYNLIXCfqLwCLA1w/y4b1/dzeTg=;
        b=2Mr9cPo20V5pIEMblKwrNHc73uQcRTrJZgZazSAHgtSONRXdawRbRGSqdueJI32p6SjYJN
        tgZKvokMyYCTbHGjfNDnvTuSUMm/BJh4Gy6cT7W85Wl+S+B18DUVNEcZ++mCYgkkUmd2bd
        fgkVeUbvkcNTv+r6iRtjl82gMvp6/5E/76XqAzNag6Mfy/2q1kTzNntlJymG9BQ5IaIo/R
        HglRnN6oweg6Zuug//Z7knByWTvHY4DrCrcpHJGrmhsDcwDnsFYeTK/Cxea5ReMDiDIYvs
        pdS26mKAaBB2vPiXZfRHAOJ3S2iPWq1RmBN+Wq9P1nSW/e+bJS47ZZYN+pigzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636032778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aW6ZznmXqA8zEDZbkYNLIXCfqLwCLA1w/y4b1/dzeTg=;
        b=w4Embh4PsX/WCOMqxcaQUCJG7l18xHIiS2d0MivABo/HRnsqsnJeMx/EvPc0oDD/Gydzx2
        3tbIC7X8t/++ihBg==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/7] timecounter: allow for non-power of two overflow
Date:   Thu,  4 Nov 2021 14:31:57 +0100
Message-Id: <20211104133204.19757-4-martin.kaistra@linutronix.de>
In-Reply-To: <20211104133204.19757-1-martin.kaistra@linutronix.de>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some hardware counters which are used as clocks have an overflow point
which is not a power of two. In order to be able to use the cycle
counter infrastructure with such hardware, add support for more generic
overflow logic.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 include/linux/timecounter.h | 3 +++
 kernel/time/timecounter.c   | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/timecounter.h b/include/linux/timecounter.h
index c6540ceea143..c71196a742b3 100644
--- a/include/linux/timecounter.h
+++ b/include/linux/timecounter.h
@@ -26,12 +26,15 @@
  *			see CYCLECOUNTER_MASK() helper macro
  * @mult:		cycle to nanosecond multiplier
  * @shift:		cycle to nanosecond divisor (power of two)
+ * @overflow_point:	non-power of two overflow point (optional),
+ *			smaller than mask
  */
 struct cyclecounter {
 	u64 (*read)(const struct cyclecounter *cc);
 	u64 mask;
 	u32 mult;
 	u32 shift;
+	u64 overflow_point;
 };
 
 /**
diff --git a/kernel/time/timecounter.c b/kernel/time/timecounter.c
index e6285288d765..afd2910a9724 100644
--- a/kernel/time/timecounter.c
+++ b/kernel/time/timecounter.c
@@ -39,6 +39,9 @@ static u64 timecounter_read_delta(struct timecounter *tc)
 	/* calculate the delta since the last timecounter_read_delta(): */
 	cycle_delta = (cycle_now - tc->cycle_last) & tc->cc->mask;
 
+	if (tc->cc->overflow_point && (cycle_now - tc->cycle_last) > tc->cc->mask)
+		cycle_delta -= tc->cc->mask - tc->cc->overflow_point;
+
 	/* convert to nanoseconds: */
 	ns_offset = cyclecounter_cyc2ns(tc->cc, cycle_delta,
 					tc->mask, &tc->frac);
-- 
2.20.1

