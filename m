Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FE9F5893
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbfKHUfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:35:12 -0500
Received: from mout.kundenserver.de ([217.72.192.73]:52165 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfKHUfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:35:11 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MUXd0-1iKLFU3ITg-00QQen; Fri, 08 Nov 2019 21:35:00 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>,
        linux-alpha@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 1/8] y2038: timex: remove incorrect time_t truncation
Date:   Fri,  8 Nov 2019 21:34:24 +0100
Message-Id: <20191108203435.112759-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108203435.112759-1-arnd@arndb.de>
References: <20191108203435.112759-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dsvYf++PaRS643RBIcfftXOiikOLND2cOaNKY9DSf4lXSBk9638
 lhMQnUQ5oC+UdORdW39GRI2YOYmmzkdt2K8YdgnKGU+Q1xAfY/croquox+EBMHjxSXARGT9
 0KoXD79AZobQRGcB4BAfLqfv+dMyxMf9KaFtVcRIAA16T+1NEtuZVuDeIlASU8CyEkGCHNx
 gAYJo1aZa8zydstxki2/w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1nRjZ/tmDjg=:emR5zWF51M5/vEo+98Qgj5
 lnbGKVBN8OwOj2FSuvwsPCgcN6LedIvlNOmNcBKcifHK40VgpKjAFw2tfBI9Pb9lOCisZHMlQ
 UgYJBlUEX2GrQSQBuRRgLPsrsEFg8nAt5dl0UdiO2vrCaYoHrs3ssjTNh77iLW3qkjUfcPA/r
 TLt2R1Ir5LhoMlH5kH9/p7N8FndtLd3Y3wyDbRThOuG7NzJp5DEiHgENEHoLEvpS4YW/kZSWM
 2R0R1JiGtePuEDlkNZQnnRvAem3cCKuFMhbk5lEvSQDO5xWR+rV1nnyq1taJX9Thu5smjAbjP
 NiJLOb9M+SBxTVhQgzorOSfX7GDqlIZE6LLW2eRc/v7vNTLLWys2+qfw2zZLBLZtdQxMf9XRo
 UNKNJR3sXpJnqnQJywDVKLKrnS6/+gv2+VL/xoQNcBoGDnZbjm2EKnxJVuZJ1MqSb4h8bpdD4
 jVoo0Q3Jia5qgDYIJx4cqCmXe8SvOyVWNlI5xNnZSMQDVJwk3C+G9xeu4wGC6Y70VEI+Jq0uG
 my9rYqeWWl/kYJKkQtupze2O70ykbmjRDmCCwcf0RJdp/bBkDWg96ROBzcZiPjuHi9yNkF8z8
 664Js3Dn+0KQ22oAb7M58v9laXjw1l1T0VxaaMLE/b3P6tydF0ciIRrcrLuJwqrRv+w6h6gme
 GUnRujq4IU2xuU91uKfsvlGrbIcXJOOKhxgdkl4AZyUcb6TnYO9IIxlslvmpXVV+PSw6B2hXQ
 DcSLQDJmcx9Qy66IRjuTUQ3HlGodY38IH5p3onsw70wnIIEZ01F+I9xFf+q4tZhwQ78OesHYu
 m6wUEUrXwZ3xXgMfnYU8MPbmDMYVB5muevfSfy5ckxLrsP0w8XZ0rOPRQxffJLajGaSxb5YF6
 by1mEgUmD5heT8jjdxbQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A cast to 'time_t' was accidentally left in place during the
conversion of __do_adjtimex() to 64-bit timestamps, so the
resulting value is incorrectly truncated.

Remove the cast so the 64-bit time gets propagated correctly.

Cc: stable@vger.kernel.org
Fixes: ead25417f82e ("timex: use __kernel_timex internally")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/time/ntp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 65eb796610dc..069ca78fb0bf 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -771,7 +771,7 @@ int __do_adjtimex(struct __kernel_timex *txc, const struct timespec64 *ts,
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	txc->time.tv_sec = (time_t)ts->tv_sec;
+	txc->time.tv_sec = ts->tv_sec;
 	txc->time.tv_usec = ts->tv_nsec;
 	if (!(time_status & STA_NANO))
 		txc->time.tv_usec = ts->tv_nsec / NSEC_PER_USEC;
-- 
2.20.0

