Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2E844AAEC
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbhKIJxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:53:52 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34980 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245096AbhKIJxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:42 -0500
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aW6ZznmXqA8zEDZbkYNLIXCfqLwCLA1w/y4b1/dzeTg=;
        b=m3zlKfKywp4n3ayFQdZDSqn2H/wfESZNm2Q/nl3EIJpTpmBfm8abioTbu3+rkyDm7lArAE
        RDLRiyAwTMhj95XRd2cgMBpMyrOloh0Xd2pkK5tQM+tDUHURoS9vlnixuMpFwwQsVwtYkU
        a7S5ysCRwwzXzcDSaw+3HEgyx3JYckf/D3A/+1TFQAO0FZawE3ouJuqLZfKeV1Q4kK8AnW
        0xD5Dm4VXD4lz6Ev4xzP/wejgxR63Vb/RZ7Hn/zRdLO8u8z7TWObw5bxS/Hzq9ZpD+7gC6
        QKk1j1w24M+WqpqO677BzBzYA2kHcoyUDlO0R7V/dTUt6BLULERl/EPPvf62VA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aW6ZznmXqA8zEDZbkYNLIXCfqLwCLA1w/y4b1/dzeTg=;
        b=TUOEXKdGjBNqOQnGPSRh99U599f1AuTHSpAt0pJnQucHgbOv+kldDhBi+Dxu/70jswABDE
        I6+SkObPLqr6EaBw==
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
Subject: [PATCH v2 3/7] timecounter: allow for non-power of two overflow
Date:   Tue,  9 Nov 2021 10:50:05 +0100
Message-Id: <20211109095013.27829-4-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
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

