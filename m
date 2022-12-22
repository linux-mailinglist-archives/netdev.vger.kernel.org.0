Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001F0654831
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiLVWMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLVWMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB8121E28;
        Thu, 22 Dec 2022 14:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6209861DAE;
        Thu, 22 Dec 2022 22:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6ABC433EF;
        Thu, 22 Dec 2022 22:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671747167;
        bh=6/3Z9VJ1qfYuDDjUhrIE3LXc4NT3VetuZ5KotX+3+58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axJZ+bqrgkFrKPJvPBzSSfx/QTBG34Fme1UeVDMTF+N3TEa3nbuov7nBj8Ff9ycRL
         rKXiubu2M5nCya5ElgsumAzZ8YvjVl9bCqLjXpolV+b+VVJbmqkOW2A/o2XqWbuYev
         G1cnGBCZtFIj10TMPRE6di3qTSGhHpYUnTfiPSedQO66GibXATNTcr+SXJU9x+9pCx
         tS8C8JHNfMPDaana1h1HVYkwpMkjKV7pDa7IlxIfK8PjQ5b4/9ViyMcQHqofW4V0Fd
         AtlnEVtE8ijGsEws3uF2IkfeITjTReDOUXi8bDcQ79F0soE1ZyMy3DPaWJyN6Vs8lf
         sMTspFS7s76Nw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     peterz@infradead.org, tglx@linutronix.de
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/3] softirq: rename ksoftirqd_running() -> ksoftirqd_should_handle()
Date:   Thu, 22 Dec 2022 14:12:42 -0800
Message-Id: <20221222221244.1290833-2-kuba@kernel.org>
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

ksoftirqd_running() takes the high priority softirqs into
consideration, so ksoftirqd_should_handle() seems like
a better name.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 kernel/softirq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index c8a6913c067d..00b838d566c1 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -86,7 +86,7 @@ static void wakeup_softirqd(void)
  * unless we're doing some of the synchronous softirqs.
  */
 #define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
-static bool ksoftirqd_running(unsigned long pending)
+static bool ksoftirqd_should_handle(unsigned long pending)
 {
 	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
 
@@ -236,7 +236,7 @@ void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 		goto out;
 
 	pending = local_softirq_pending();
-	if (!pending || ksoftirqd_running(pending))
+	if (!pending || ksoftirqd_should_handle(pending))
 		goto out;
 
 	/*
@@ -432,7 +432,7 @@ static inline bool should_wake_ksoftirqd(void)
 
 static inline void invoke_softirq(void)
 {
-	if (ksoftirqd_running(local_softirq_pending()))
+	if (ksoftirqd_should_handle(local_softirq_pending()))
 		return;
 
 	if (!force_irqthreads() || !__this_cpu_read(ksoftirqd)) {
@@ -468,7 +468,7 @@ asmlinkage __visible void do_softirq(void)
 
 	pending = local_softirq_pending();
 
-	if (pending && !ksoftirqd_running(pending))
+	if (pending && !ksoftirqd_should_handle(pending))
 		do_softirq_own_stack();
 
 	local_irq_restore(flags);
-- 
2.38.1

