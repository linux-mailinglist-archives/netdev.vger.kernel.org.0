Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F34B100E56
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfKRVt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:49:59 -0500
Received: from correo.us.es ([193.147.175.20]:45716 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKRVtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3AAB0EB491
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DCF0A7EC8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 12DD4A7EC5; Mon, 18 Nov 2019 22:49:31 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A458D202AE;
        Mon, 18 Nov 2019 22:49:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7600C42EE38F;
        Mon, 18 Nov 2019 22:49:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/18] netfilter: xt_time: use time64_t
Date:   Mon, 18 Nov 2019 22:49:03 +0100
Message-Id: <20191118214914.142794-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The current xt_time driver suffers from the y2038 overflow on 32-bit
architectures, when the time of day calculations break.

Also, on both 32-bit and 64-bit architectures, there is a problem with
info->date_start/stop, which is part of the user ABI and overflows in
in 2106.

Fix the first issue by using time64_t and explicit calls to div_u64()
and div_u64_rem(), and document the seconds issue.

The explicit 64-bit division is unfortunately slower on 32-bit
architectures, but doing it as unsigned lets us use the optimized
division-through-multiplication path in most configurations.  This should
be fine, as the code already does not allow any negative time of day
values.

Using u32 seconds values consistently would probably also work and
be a little more efficient, but that doesn't feel right as it would
propagate the y2106 overflow to more place rather than fewer.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_time.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 8dbb4d48f2ed..67cb98489415 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -77,12 +77,12 @@ static inline bool is_leap(unsigned int y)
  * This is done in three separate functions so that the most expensive
  * calculations are done last, in case a "simple match" can be found earlier.
  */
-static inline unsigned int localtime_1(struct xtm *r, time_t time)
+static inline unsigned int localtime_1(struct xtm *r, time64_t time)
 {
 	unsigned int v, w;
 
 	/* Each day has 86400s, so finding the hour/minute is actually easy. */
-	v         = time % SECONDS_PER_DAY;
+	div_u64_rem(time, SECONDS_PER_DAY, &v);
 	r->second = v % 60;
 	w         = v / 60;
 	r->minute = w % 60;
@@ -90,13 +90,13 @@ static inline unsigned int localtime_1(struct xtm *r, time_t time)
 	return v;
 }
 
-static inline void localtime_2(struct xtm *r, time_t time)
+static inline void localtime_2(struct xtm *r, time64_t time)
 {
 	/*
 	 * Here comes the rest (weekday, monthday). First, divide the SSTE
 	 * by seconds-per-day to get the number of _days_ since the epoch.
 	 */
-	r->dse = time / 86400;
+	r->dse = div_u64(time, SECONDS_PER_DAY);
 
 	/*
 	 * 1970-01-01 (w=0) was a Thursday (4).
@@ -105,7 +105,7 @@ static inline void localtime_2(struct xtm *r, time_t time)
 	r->weekday = (4 + r->dse - 1) % 7 + 1;
 }
 
-static void localtime_3(struct xtm *r, time_t time)
+static void localtime_3(struct xtm *r, time64_t time)
 {
 	unsigned int year, i, w = r->dse;
 
@@ -160,7 +160,7 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_time_info *info = par->matchinfo;
 	unsigned int packet_time;
 	struct xtm current_time;
-	s64 stamp;
+	time64_t stamp;
 
 	/*
 	 * We need real time here, but we can neither use skb->tstamp
@@ -173,14 +173,14 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	 *	1. match before 13:00
 	 *	2. match after 13:00
 	 *
-	 * If you match against processing time (get_seconds) it
+	 * If you match against processing time (ktime_get_real_seconds) it
 	 * may happen that the same packet matches both rules if
 	 * it arrived at the right moment before 13:00, so it would be
 	 * better to check skb->tstamp and set it via __net_timestamp()
 	 * if needed.  This however breaks outgoing packets tx timestamp,
 	 * and causes them to get delayed forever by fq packet scheduler.
 	 */
-	stamp = get_seconds();
+	stamp = ktime_get_real_seconds();
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */
@@ -193,6 +193,9 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	 *   - 'now' is in the weekday mask
 	 *   - 'now' is in the daytime range time_start..time_end
 	 * (and by default, libxt_time will set these so as to match)
+	 *
+	 * note: info->date_start/stop are unsigned 32-bit values that
+	 *	 can hold values beyond y2038, but not after y2106.
 	 */
 
 	if (stamp < info->date_start || stamp > info->date_stop)
-- 
2.11.0

