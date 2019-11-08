Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADE9F58A0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbfKHUga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:36:30 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:36201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732171AbfKHUg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:36:29 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MEF87-1iadeR36H7-00AGgW; Fri, 08 Nov 2019 21:36:18 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH 5/8] netfilter: xt_time: use time64_t
Date:   Fri,  8 Nov 2019 21:34:28 +0100
Message-Id: <20191108203435.112759-6-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108203435.112759-1-arnd@arndb.de>
References: <20191108203435.112759-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:LAqgtMHpuHsHVqesPbRDDOnPbG3k3aIkl2ycNWLlt4hNWDe/h94
 GNpZ9xbyyD7LXXBKIdA2s2/AdUHfbg0DIx01Kj4OMx3p5kvSqUbOebvbj/QnE7eakpz0lHv
 uN5N4Lbi3Ve2HiOXFaAex9XSmQCyebw9uVyDgEMXqAnhjjgfzDAXhsrlExb0jFUFKUWnK+D
 4XcdXehRUk7EHSe1W5zeA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:uTLnXhQlaoA=:6gkTKIzGkH8u4p9n9EzB5+
 lrHh5mqs0gNbpufpMED1aZFRj6EM8Vdvk21VmgHmavXEMmYc2wxSYeavDcGdpdZ7CadtsRnAO
 qsbfYORBBYZdz02Y0pFnzClpTjdJxDYOiPorKaYrirT28tLfMyelNHuTue4mitFpPQkwUJ2vp
 1FdPn/cyPCua8wGrtCyi9289PPkzr214fg0Fv+WOBBWFYibuPoFVWzXyI83DcKdtvvPnvqIDz
 wdprTdsC/ZkfYx1s1jMPDmmohjYlPkV8FnO3K6nxce9wT/3gnfnxHFHUeiCMMJA22LZs2nOvn
 OLypew6aJxfs20P57HiMNl93gEsT/ycbJ4slABRZ7SD+vI3RGS4lWKiSvlZ4ZZmiwnhqiqFF6
 Fi/2Y9koVFyxao8U3z3LmwEw2d4k9EduaQb3mljAM4tskCgWqBzRabEsK+FQfK0VwMISD3IIW
 eKKPfoaXuB3AV6ejoIfIyfJQvB+avcI6HFn8HPjfm6LOHo9GWEk0eoUOa9jTziwzOGTcl+cD8
 gcHV80qweuOKUQszTaHIGeyW8GHBB0VgQf7EVzpkJjjJF7Cxl4bJVh8XV/7vXbWIf9M7eiW7O
 mucjrJW1Dqc/K1zHhLFKmZyuNrarpADVQ5zsZZu9VmgOrOVksy4eAIJbaKozfWtrjPhTIEmlZ
 D0+GgCVexquumqnxI1GUzSo2LH4sTJm7GUM6VZ190VgN9woJKTRGsN+7Vw1Az+NSbFtjEehCe
 ApXUQOzEXIOlfr98kuJiFJt4keBc1XueRtApEJZ9SKiLF9K6Hg4vDTcxSG9OWPjl48mdsLGTh
 jn56Ebw8x8hxA5jYZEZPKd2MMV86gz8op0dpLqRShX5Ujbjw2cpu0anrthVv58jvg5/ELj2ro
 rymaqfVxE+cCH9UVrcxg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.20.0

