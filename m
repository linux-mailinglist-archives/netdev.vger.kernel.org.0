Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA81967D2
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 18:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgC1REl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 13:04:41 -0400
Received: from mx.sdf.org ([205.166.94.20]:63281 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgC1REk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 13:04:40 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SH47cb023288
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 17:04:08 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SH4767016334;
        Sat, 28 Mar 2020 17:04:07 GMT
Message-Id: <202003281704.02SH4767016334@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Wed, 21 Aug 2019 20:30:18 -0400
Subject: [RFC PATCH v1 18/50] net/ipv6/addrconf.c: Use prandom_u32_max for
 rfc3315 backoff time computation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     Maciej Zenczykowski <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for 64-bit intermediate values and do_div.

(Actually, the algorithm isn't changing much, except that the old
code used a scaling factor of 1 million.  prandom_u32_max uses
a factor of 2^32, making the final division more efficient.)

One thing that concerns me a bit is that the data types are all
signed.  The old code cast the inputs to unsigned and produced
strange overflowed results if they were negative, so presumably
that never happens in practice.

The new code works the same for positive inputs, but produces
different strange overflowed results if fed negative inputs.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Maciej Żenczykowski <maze@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netdev@vger.kernel.org
---
 net/ipv6/addrconf.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ec3f472bc5a8f..5172f1f874363 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -103,20 +103,19 @@ static inline u32 cstamp_delta(unsigned long cstamp)
 static inline s32 rfc3315_s14_backoff_init(s32 irt)
 {
 	/* multiply 'initial retransmission time' by 0.9 .. 1.1 */
-	u64 tmp = (900000 + prandom_u32() % 200001) * (u64)irt;
-	do_div(tmp, 1000000);
-	return (s32)tmp;
+	s32 range = irt / 5;
+	return irt - (s32)(range/2) + (s32)prandom_u32_max(range);
 }
 
 static inline s32 rfc3315_s14_backoff_update(s32 rt, s32 mrt)
 {
 	/* multiply 'retransmission timeout' by 1.9 .. 2.1 */
-	u64 tmp = (1900000 + prandom_u32() % 200001) * (u64)rt;
-	do_div(tmp, 1000000);
-	if ((s32)tmp > mrt) {
+	s32 range = rt / 5;
+	s32 tmp = 2*rt - (s32)(range/2) + (s32)prandom_u32_max(range);
+	if (tmp > mrt) {
 		/* multiply 'maximum retransmission time' by 0.9 .. 1.1 */
-		tmp = (900000 + prandom_u32() % 200001) * (u64)mrt;
-		do_div(tmp, 1000000);
+		range = mrt / 5;
+		tmp = mrt - (s32)(range/2) + (s32)prandom_u32_max(range);
 	}
 	return (s32)tmp;
 }
-- 
2.26.0

