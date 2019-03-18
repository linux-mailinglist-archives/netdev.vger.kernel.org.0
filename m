Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5519676C
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 17:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgC1QnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 12:43:17 -0400
Received: from mx.sdf.org ([205.166.94.20]:50230 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgC1QnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 12:43:17 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SGhEsd012112
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 16:43:14 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SGhE5I022872;
        Sat, 28 Mar 2020 16:43:14 GMT
Message-Id: <202003281643.02SGhE5I022872@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Mon, 18 Mar 2019 14:50:35 -0400
Subject: [RFC PATCH v1 19/50] net/sched/sch_netem: Simplify get_crandom
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be done with a single 32x32-bit multiply, rather
than a 64x64 as previously written.

One conditional subtract is required to handle the 33rd bit
of value - state->last, but that's cheaper than the wider multiply
even on 64-bit platforms, and much cheaper on 32-bit.

The need for a 33rd bit to hold rho+1 is avoided by using ~rho
instead.

(Found while auditing prandom_u32() callers.)

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org
---
 net/sched/sch_netem.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 7b7503326faf5..fa41601538b21 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -180,17 +180,15 @@ static void init_crandom(struct crndstate *state, unsigned long rho)
  */
 static u32 get_crandom(struct crndstate *state)
 {
-	u64 value, rho;
-	unsigned long answer;
+	u32 value = prandom_u32(), last, rho, answer;
 
-	if (!state || state->rho == 0)	/* no correlation */
-		return prandom_u32();
+	if (!state || (rho = state->rho) == 0)	/* no correlation */
+		return value;
+	last = state->last;
+	answer = last + reciprocal_scale(value - last, ~rho);
 
-	value = prandom_u32();
-	rho = (u64)state->rho + 1;
-	answer = (value * ((1ull<<32) - rho) + state->last * rho) >> 32;
-	state->last = answer;
-	return answer;
+	/* Handle 33rd bit of difference */
+	return state->last = value >= last ? answer : answer - ~rho;
 }
 
 /* loss_4state - 4-state model loss generator
-- 
2.26.0

