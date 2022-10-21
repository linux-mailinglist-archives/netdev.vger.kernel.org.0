Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21B6607901
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 15:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiJUN6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 09:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiJUN6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 09:58:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A611B279D5B;
        Fri, 21 Oct 2022 06:58:34 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mv5f65BhvzHv7W;
        Fri, 21 Oct 2022 21:58:22 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 21:58:31 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 21:58:31 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <johannes@sipsolutions.net>
Subject: [PATCH -next] rfkill: replace BUG_ON() with WARN_ON() in core.c
Date:   Fri, 21 Oct 2022 21:57:38 +0800
Message-ID: <20221021135738.524370-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace BUG_ON() with WARN_ON() to handle fault more gracefully.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/rfkill/core.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index dac4fdc7488a..4f493e76520d 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -150,7 +150,8 @@ EXPORT_SYMBOL(rfkill_get_led_trigger_name);
 
 void rfkill_set_led_trigger_name(struct rfkill *rfkill, const char *name)
 {
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return;
 
 	rfkill->ledtrigname = name;
 }
@@ -532,7 +533,8 @@ bool rfkill_set_hw_state_reason(struct rfkill *rfkill,
 	unsigned long flags;
 	bool ret, prev;
 
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return blocked;
 
 	if (WARN(reason &
 	    ~(RFKILL_HARD_BLOCK_SIGNAL | RFKILL_HARD_BLOCK_NOT_OWNER),
@@ -581,7 +583,8 @@ bool rfkill_set_sw_state(struct rfkill *rfkill, bool blocked)
 	unsigned long flags;
 	bool prev, hwblock;
 
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return blocked;
 
 	spin_lock_irqsave(&rfkill->lock, flags);
 	prev = !!(rfkill->state & RFKILL_BLOCK_SW);
@@ -607,8 +610,8 @@ void rfkill_init_sw_state(struct rfkill *rfkill, bool blocked)
 {
 	unsigned long flags;
 
-	BUG_ON(!rfkill);
-	BUG_ON(rfkill->registered);
+	if (WARN_ON(!rfkill) || WARN_ON(rfkill->registered))
+		return;
 
 	spin_lock_irqsave(&rfkill->lock, flags);
 	__rfkill_set_sw_state(rfkill, blocked);
@@ -622,7 +625,8 @@ void rfkill_set_states(struct rfkill *rfkill, bool sw, bool hw)
 	unsigned long flags;
 	bool swprev, hwprev;
 
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return;
 
 	spin_lock_irqsave(&rfkill->lock, flags);
 
@@ -860,7 +864,8 @@ static int rfkill_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 void rfkill_pause_polling(struct rfkill *rfkill)
 {
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return;
 
 	if (!rfkill->ops->poll)
 		return;
@@ -872,7 +877,8 @@ EXPORT_SYMBOL(rfkill_pause_polling);
 
 void rfkill_resume_polling(struct rfkill *rfkill)
 {
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return;
 
 	if (!rfkill->ops->poll)
 		return;
@@ -1115,7 +1121,8 @@ EXPORT_SYMBOL(rfkill_register);
 
 void rfkill_unregister(struct rfkill *rfkill)
 {
-	BUG_ON(!rfkill);
+	if (WARN_ON(!rfkill))
+		return;
 
 	if (rfkill->ops->poll)
 		cancel_delayed_work_sync(&rfkill->poll_work);
-- 
2.25.1

