Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED1E4C98E5
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbiCAXL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbiCAXLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:11:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7E090FF9;
        Tue,  1 Mar 2022 15:11:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764506146F;
        Tue,  1 Mar 2022 23:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BA8C340EE;
        Tue,  1 Mar 2022 23:10:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PZWdJMvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646176257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r94wKsnq6K6ND+X220Ovab4Du6A3foJxGdJh9sRmxh4=;
        b=PZWdJMvP7n2f1PXzoh3oU+xY+PZFzyyvsm0lKHqtwO9U3E9mHjtqaDthbhA81EZn9f5Fz0
        aEdPHaZipArVvlP4dHNvOT2G8261DJvChMlbVUhm7mgXctVyU5FbpXZNo5VbwWa7Eaeyaf
        IX55Cu8fBSiMH0l6aFX+z7/orXFmNNg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 358d3e1e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 23:10:57 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/3] wireguard: device: clear keys on VM fork
Date:   Wed,  2 Mar 2022 00:10:38 +0100
Message-Id: <20220301231038.530897-4-Jason@zx2c4.com>
In-Reply-To: <20220301231038.530897-1-Jason@zx2c4.com>
References: <20220301231038.530897-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a virtual machine forks, it's important that WireGuard clear
existing sessions so that different plaintext is not transmitted using
the same key+nonce, which can result in catastrophic cryptographic
failure. To accomplish this, we simply hook into the newly added vmfork
notifier, which can use the same notification function we're already
using for PM notifications.

As a bonus, it turns out that, like the vmfork registration function,
the PM registration function is stubbed out when CONFIG_PM_SLEEP is not
set, so we can actually just remove the maze of ifdefs, which makes it
really quite clean to support both notifiers at once.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Hi Jakub,

I wasn't planning on sending other WireGuard changes to net-next this
cycle, and this one here depends on previous things in my random.git
tree. Is it okay with you if I take this through my tree rather than
net-next? Alternatively, I could send it through net after rc1 if you'd
prefer that. Or we could just wait for 5.19, but that seems a long way's
off.

Thanks,
Jason

 drivers/net/wireguard/device.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index a46067c38bf5..22cc27c221f8 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -59,7 +59,10 @@ static int wg_open(struct net_device *dev)
 	return ret;
 }
 
-#ifdef CONFIG_PM_SLEEP
+static int wg_pm_notification(struct notifier_block *nb, unsigned long action, void *data);
+static struct notifier_block pm_notifier = { .notifier_call = wg_pm_notification };
+static struct notifier_block vm_notifier = { .notifier_call = wg_pm_notification };
+
 static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
 			      void *data)
 {
@@ -70,10 +73,10 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
 	 * its normal operation rather than as a somewhat rare event, then we
 	 * don't actually want to clear keys.
 	 */
-	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
+	if (nb == &pm_notifier && (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID)))
 		return 0;
 
-	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
+	if (nb == &pm_notifier && action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
 		return 0;
 
 	rtnl_lock();
@@ -91,9 +94,6 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action,
 	return 0;
 }
 
-static struct notifier_block pm_notifier = { .notifier_call = wg_pm_notification };
-#endif
-
 static int wg_stop(struct net_device *dev)
 {
 	struct wg_device *wg = netdev_priv(dev);
@@ -424,16 +424,18 @@ int __init wg_device_init(void)
 {
 	int ret;
 
-#ifdef CONFIG_PM_SLEEP
 	ret = register_pm_notifier(&pm_notifier);
 	if (ret)
 		return ret;
-#endif
 
-	ret = register_pernet_device(&pernet_ops);
+	ret = register_random_vmfork_notifier(&vm_notifier);
 	if (ret)
 		goto error_pm;
 
+	ret = register_pernet_device(&pernet_ops);
+	if (ret)
+		goto error_vm;
+
 	ret = rtnl_link_register(&link_ops);
 	if (ret)
 		goto error_pernet;
@@ -442,10 +444,10 @@ int __init wg_device_init(void)
 
 error_pernet:
 	unregister_pernet_device(&pernet_ops);
+error_vm:
+	unregister_random_vmfork_notifier(&vm_notifier);
 error_pm:
-#ifdef CONFIG_PM_SLEEP
 	unregister_pm_notifier(&pm_notifier);
-#endif
 	return ret;
 }
 
@@ -453,8 +455,7 @@ void wg_device_uninit(void)
 {
 	rtnl_link_unregister(&link_ops);
 	unregister_pernet_device(&pernet_ops);
-#ifdef CONFIG_PM_SLEEP
+	unregister_random_vmfork_notifier(&vm_notifier);
 	unregister_pm_notifier(&pm_notifier);
-#endif
 	rcu_barrier();
 }
-- 
2.35.1

