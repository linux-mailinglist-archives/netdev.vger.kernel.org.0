Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84660654830
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiLVWMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLVWMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:12:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B86A10FDB;
        Thu, 22 Dec 2022 14:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2377C61DB4;
        Thu, 22 Dec 2022 22:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518A6C433F2;
        Thu, 22 Dec 2022 22:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671747168;
        bh=mQD2ZYw4YRduH/pzuxEiNaEpTsT1YNKaQ62QM19DZGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQqMj6Z4it5dSFIYft/H2Xzfs/wXS3w0orSN/1N6zaT/JSyNX+MYxUMbSYWJb9qYs
         MSKBbg7QoMfXqkYroZVfTbb7AAbk30WPU5M1BbT3jayFvOocStnYrnMcrVyj0QPZB0
         9wn1QMIuHbt1FRas8Tec/sEx7+abSc2//V5Qaep3OMpz2jNJt4jWu4RjRr1z3kzjcm
         K6l5kMN0ViZaNaWxzH8bc65XUL49e+TYdhLQnVgqmjx6Op02k6yrBr5FfRDBqPzDBl
         BopxF+W1aJmuDKVqwz7T09xdXnCm+8FgHIjxNkfLtL8byI++EUno7vjf2agYZZ66yP
         Z35qEt0tuQneg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     peterz@infradead.org, tglx@linutronix.de
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/3] softirq: don't yield if only expedited handlers are pending
Date:   Thu, 22 Dec 2022 14:12:44 -0800
Message-Id: <20221222221244.1290833-4-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221222221244.1290833-1-kuba@kernel.org>
References: <20221222221244.1290833-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In networking we try to keep Tx packet queues small, so we limit
how many bytes a socket may packetize and queue up. Tx completions
(from NAPI) notify the sockets when packets have left the system
(NIC Tx completion) and the socket schedules a tasklet to queue
the next batch of frames.

This leads to a situation where we go thru the softirq loop twice.
First round we have pending = NET (from the NIC IRQ/NAPI), and
the second iteration has pending = TASKLET (the socket tasklet).

On two web workloads I looked at this condition accounts for 10%
and 23% of all ksoftirqd wake ups respectively. We run NAPI
which wakes some process up, we hit need_resched() and wake up
ksoftirqd just to run the TSQ (TCP small queues) tasklet.

Tweak the need_resched() condition to be ignored if all pending
softIRQs are "non-deferred". The tasklet would run relatively
soon, anyway, but once ksoftirqd is woken we're risking stalls.

I did not see any negative impact on the latency in an RR test
on a loaded machine with this change applied.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 kernel/softirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index ad200d386ec1..4ac59ffb0d55 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -601,7 +601,7 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 
 		if (time_is_before_eq_jiffies(end) || !--max_restart)
 			limit = SOFTIRQ_OVERLOAD_TIME;
-		else if (need_resched())
+		else if (need_resched() && pending & ~SOFTIRQ_NOW_MASK)
 			limit = SOFTIRQ_DEFER_TIME;
 		else
 			goto restart;
-- 
2.38.1

