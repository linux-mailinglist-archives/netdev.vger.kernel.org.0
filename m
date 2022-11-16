Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E7F62BCAB
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbiKPLyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiKPLyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:54:00 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B17F27F;
        Wed, 16 Nov 2022 03:45:50 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id 7so8972196ilg.11;
        Wed, 16 Nov 2022 03:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RA8QY4hcuCySzouxhlTWv2Sr+QGglcv1Fl/GC5Stgwo=;
        b=ffBCCeybrB1movsmUCLvuoqewLP6ltVc5PHtJkyu55VMe4jGHOCSlpGqjvXFV1mpvf
         fH33RPKAq70ZeS7v7DF31UnAcFKOtgd4qtsIq1IsWfPYjWmRBHmLN+4+3aublIxjFaNg
         D+4AIStJFv0QN0lX5uR1/MmHWim6jLN3jFMDcw3BX59Q9V0a6inaNQc264PzYtKGuOUE
         DK7Hj0rkG5CWkJ2W5/02/FoTgXfuByQubepk27EEHaK75VM9iNVfNjQS19z29bnJ6WAz
         TtNOLS9D59mRYYjliYpOeUhWZ0uiMq8mo1L3NGzywaIJSyyqUOV9kCo20/6c8XnckHXz
         6bPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RA8QY4hcuCySzouxhlTWv2Sr+QGglcv1Fl/GC5Stgwo=;
        b=DrZm3RkhVp7nZOz7xkyoJ3s4oOSAWliXt+D+HP585arSAU2wsMpqZQu4APCzTVyRSM
         EYaKCfZLzmF7XhvGthtmoQiemQfMNbYCRJD3xeJa7N6Yw5CjIvI4oFmPnmgGbAd6oiMu
         yW+DgodyCcVl2KHpgtkHp/9D19HBKVqUxjoHomjqSw1fKDh83Jk9gniuIbOv85HN+mdw
         QKPyLyNBIr3VJ2B7LNMxhgjzInFbtAafjF+0cpF7BnsCKpkhT4gRBZ/A4ILy9DDmwOyZ
         933AmwiKSNnVSA6F2yJaUDLg+kk5AmXWPqY/0BzNXug9fiQM2hwDPxtCZWHRYa6DGZ7T
         Ffww==
X-Gm-Message-State: ANoB5pllRGJpn3rcHffOxvLK3z6NOf03HVi1L6OOtniz6bJmcntQR3xI
        f3QA7iXaqzuA2tqTFsRjv9kuNdVcmcMXAw==
X-Google-Smtp-Source: AA0mqf765SOct2ze3FbYeMfJ5903EuLlT3KbTmyulPtv76sjpXeNAca5Vf6vuM3y6EAVQZzgqm0XEA==
X-Received: by 2002:a05:6e02:109:b0:300:1f82:73e5 with SMTP id t9-20020a056e02010900b003001f8273e5mr9900263ilm.85.1668599149339;
        Wed, 16 Nov 2022 03:45:49 -0800 (PST)
Received: from MBP.lan (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id g94-20020a028567000000b00374fa5b600csm5689973jai.0.2022.11.16.03.45.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Nov 2022 03:45:48 -0800 (PST)
From:   Schspa Shi <schspa@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Jason@zx2c4.com, djwong@kernel.org, jack@suse.cz,
        hca@linux.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>,
        syzbot+6fd64001c20aa99e34a4@syzkaller.appspotmail.com
Subject: [PATCH] mrp: introduce active flags to prevent UAF when applicant uninit
Date:   Wed, 16 Nov 2022 19:45:11 +0800
Message-Id: <20221116114511.7720-1-schspa@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 155f74d8b14f..6c927d4b35f0 100644
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
2.37.3

