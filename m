Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B886650164
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbiLRQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiLRQ2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:28:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41485140C6;
        Sun, 18 Dec 2022 08:10:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FF9360C99;
        Sun, 18 Dec 2022 16:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139E6C433D2;
        Sun, 18 Dec 2022 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379831;
        bh=GnX5r4rtuSSdm3opD1+RXVhwmIfbX0Z+JhXm+ZCYRKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UeNJSxIlFJWiVzlzO4YvhQmpC3Rjpv55S8pNCaDhYvUwpxciKQE6cRxM0C9UPPMeh
         B/FhPY8WWWj6NVFcvi7BCDVKm9drU1AmjydbyuueQ5rqiOwW/oT/QG8BRrTlZF8C+0
         HKZCIhoMKJYsj+8+K0qWqAYXvxStdqFdQ2eA+cUcLg+unO9N99B24+ApvWKDD1EsiJ
         XekR5QX8jJcugZTyLnYi1uyPCNy50qRY7BkDpypn2tKmgZrCBpliPSvhz9fSMtjMDC
         2PJ/GpFevSKoy+xaa4kTaep6gYvuMPI25KCKhn7wOWv0gGL2w9od/d+lsZhx2T+xRD
         dMWv+KR2M9uPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Schspa Shi <schspa@gmail.com>,
        syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kpsingh@kernel.org,
        yury.norov@gmail.com, christoph.boehmwalder@linbit.com,
        keescook@chromium.org, djwong@kernel.org, Jason@zx2c4.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 44/73] mrp: introduce active flags to prevent UAF when applicant uninit
Date:   Sun, 18 Dec 2022 11:07:12 -0500
Message-Id: <20221218160741.927862-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Schspa Shi <schspa@gmail.com>

[ Upstream commit ab0377803dafc58f1e22296708c1c28e309414d6 ]

The caller of del_timer_sync must prevent restarting of the timer, If
we have no this synchronization, there is a small probability that the
cancellation will not be successful.

And syzbot report the fellowing crash:
==================================================================
BUG: KASAN: use-after-free in hlist_add_head include/linux/list.h:929 [inline]
BUG: KASAN: use-after-free in enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
Write at addr f9ff000024df6058 by task syz-fuzzer/2256
Pointer tag: [f9], memory tag: [fe]

CPU: 1 PID: 2256 Comm: syz-fuzzer Not tainted 6.1.0-rc5-syzkaller-00008-
ge01d50cbd6ee #0
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace.part.0+0xe0/0xf0 arch/arm64/kernel/stacktrace.c:156
 dump_backtrace arch/arm64/kernel/stacktrace.c:162 [inline]
 show_stack+0x18/0x40 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x68/0x84 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x1a8/0x4a0 mm/kasan/report.c:395
 kasan_report+0x94/0xb4 mm/kasan/report.c:495
 __do_kernel_fault+0x164/0x1e0 arch/arm64/mm/fault.c:320
 do_bad_area arch/arm64/mm/fault.c:473 [inline]
 do_tag_check_fault+0x78/0x8c arch/arm64/mm/fault.c:749
 do_mem_abort+0x44/0x94 arch/arm64/mm/fault.c:825
 el1_abort+0x40/0x60 arch/arm64/kernel/entry-common.c:367
 el1h_64_sync_handler+0xd8/0xe4 arch/arm64/kernel/entry-common.c:427
 el1h_64_sync+0x64/0x68 arch/arm64/kernel/entry.S:576
 hlist_add_head include/linux/list.h:929 [inline]
 enqueue_timer+0x18/0xa4 kernel/time/timer.c:605
 mod_timer+0x14/0x20 kernel/time/timer.c:1161
 mrp_periodic_timer_arm net/802/mrp.c:614 [inline]
 mrp_periodic_timer+0xa0/0xc0 net/802/mrp.c:627
 call_timer_fn.constprop.0+0x24/0x80 kernel/time/timer.c:1474
 expire_timers+0x98/0xc4 kernel/time/timer.c:1519

To fix it, we can introduce a new active flags to make sure the timer will
not restart.

Reported-by: syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com

Signed-off-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mrp.h |  1 +
 net/802/mrp.c     | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/mrp.h b/include/net/mrp.h
index 92cd3fb6cf9d..b28915ffea28 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -124,6 +124,7 @@ struct mrp_applicant {
 	struct sk_buff		*pdu;
 	struct rb_root		mad;
 	struct rcu_head		rcu;
+	bool			active;
 };
 
 struct mrp_port {
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 35e04cc5390c..c10a432a5b43 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -606,7 +606,10 @@ static void mrp_join_timer(struct timer_list *t)
 	spin_unlock(&app->lock);
 
 	mrp_queue_xmit(app);
-	mrp_join_timer_arm(app);
+	spin_lock(&app->lock);
+	if (likely(app->active))
+		mrp_join_timer_arm(app);
+	spin_unlock(&app->lock);
 }
 
 static void mrp_periodic_timer_arm(struct mrp_applicant *app)
@@ -620,11 +623,12 @@ static void mrp_periodic_timer(struct timer_list *t)
 	struct mrp_applicant *app = from_timer(app, t, periodic_timer);
 
 	spin_lock(&app->lock);
-	mrp_mad_event(app, MRP_EVENT_PERIODIC);
-	mrp_pdu_queue(app);
+	if (likely(app->active)) {
+		mrp_mad_event(app, MRP_EVENT_PERIODIC);
+		mrp_pdu_queue(app);
+		mrp_periodic_timer_arm(app);
+	}
 	spin_unlock(&app->lock);
-
-	mrp_periodic_timer_arm(app);
 }
 
 static int mrp_pdu_parse_end_mark(struct sk_buff *skb, int *offset)
@@ -872,6 +876,7 @@ int mrp_init_applicant(struct net_device *dev, struct mrp_application *appl)
 	app->dev = dev;
 	app->app = appl;
 	app->mad = RB_ROOT;
+	app->active = true;
 	spin_lock_init(&app->lock);
 	skb_queue_head_init(&app->queue);
 	rcu_assign_pointer(dev->mrp_port->applicants[appl->type], app);
@@ -900,6 +905,9 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 
 	RCU_INIT_POINTER(port->applicants[appl->type], NULL);
 
+	spin_lock_bh(&app->lock);
+	app->active = false;
+	spin_unlock_bh(&app->lock);
 	/* Delete timer and generate a final TX event to flush out
 	 * all pending messages before the applicant is gone.
 	 */
-- 
2.35.1

