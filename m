Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C4663F28
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjAJLRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjAJLRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:17:48 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4CD121B5;
        Tue, 10 Jan 2023 03:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=uypHTRqIWHEuGCn4N8
        mdtJ44b2Q/Vg4/vbE4Vrge/BA=; b=YyAeY4tfim19XSymdWmVRPVMcNiyIkV8eo
        yL85/D+w1FlgN61dqVyZc26aZrknh+BSTN1WtdboYPT6OSBxZDd/pB7yYhjYQkmD
        OrAW6KJRlQ3Ca6xqNB1dbiUV8hYbw1f6OCUh+9VVMqTAeQ7bNBkbnHQJg8zB6c8u
        F6dLSLK5U=
Received: from localhost.localdomain (unknown [114.107.205.23])
        by zwqz-smtp-mta-g2-3 (Coremail) with SMTP id _____wAXDXqHSL1ji3RdAA--.41461S4;
        Tue, 10 Jan 2023 19:14:50 +0800 (CST)
From:   Lizhe <sensor1010@163.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        kuniyu@amazon.com, petrm@nvidia.com, weiwan@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lizhe <sensor1010@163.com>
Subject: [PATCH v2] net/core.c : remove redundant state settings after waking up
Date:   Tue, 10 Jan 2023 03:14:13 -0800
Message-Id: <20230110111413.3747-1-sensor1010@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: _____wAXDXqHSL1ji3RdAA--.41461S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF4ruryDJr45GF48tF18Xwb_yoW3WrbE9a
        yvyF48Zr18ZF1Uur15C3y5Jry0grs5AFn7Xw42yFW8J345GFyDZ3s5Wr9rJr4fW39xZr15
        ua9xXF4YkrWa9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKpnQ7UUUUU==
X-Originating-IP: [114.107.205.23]
X-CM-SenderInfo: 5vhq20jurqiii6rwjhhfrp/xtbBohDyq1aEHG08twAAsD
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when schedule() returns, the current state is TASK_RUNNING, no
need to set its status to TASK_INTERRUPTIBLE, and after jumping
out of the wile loop, its status will be set to TASK_RUNNING,
so, set_current_state(TASK_INTERRUPTIBLE) is redundant

Signed-off-by: Lizhe <sensor1010@163.com>
---
 net/core/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..4bd2d4b954c9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6580,7 +6580,6 @@ static int napi_thread_wait(struct napi_struct *napi)
 		schedule();
 		/* woken being true indicates this thread owns this napi. */
 		woken = true;
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
 
-- 
2.17.1

