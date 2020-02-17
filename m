Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C26516119B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgBQMHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:07:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:43638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgBQMHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 07:07:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B8875AF01;
        Mon, 17 Feb 2020 12:07:27 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Tejun Heo <tj@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-rt-users@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: [PATCH] kthread: Mark timer used by delayed kthread works as IRQ safe
Date:   Mon, 17 Feb 2020 13:07:09 +0100
Message-Id: <20200217120709.1974-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timer used by delayed kthread works are IRQ safe because the used
kthread_delayed_work_timer_fn() is IRQ safe.

It is properly marked when initialized by KTHREAD_DELAYED_WORK_INIT().
But TIMER_IRQSAFE flag is missing when initialized by
kthread_init_delayed_work().

The missing flag might trigger invalid warning from del_timer_sync()
when kthread_mod_delayed_work() is called with interrupts disabled.

Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
This patch is result of a discussion about using the API, see
https://lkml.kernel.org/r/cfa886ad-e3b7-c0d2-3ff8-58d94170eab5@ti.com

 include/linux/kthread.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 0f9da966934e..8bbcaad7ef0f 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -165,7 +165,8 @@ extern void __kthread_init_worker(struct kthread_worker *worker,
 	do {								\
 		kthread_init_work(&(dwork)->work, (fn));		\
 		timer_setup(&(dwork)->timer,				\
-			     kthread_delayed_work_timer_fn, 0);		\
+			     kthread_delayed_work_timer_fn,		\
+			     TIMER_IRQSAFE);				\
 	} while (0)
 
 int kthread_worker_fn(void *worker_ptr);
-- 
2.16.4

