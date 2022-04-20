Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD42507EC9
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 04:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356849AbiDTCZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 22:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241584AbiDTCZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 22:25:19 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8589833E8D
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 19:22:35 -0700 (PDT)
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23K2MDpo016072;
        Wed, 20 Apr 2022 11:22:13 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Wed, 20 Apr 2022 11:22:13 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23K2MCHW016067
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 20 Apr 2022 11:22:13 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <0bc6443a-dbac-70ab-bf99-9a439e35f3ef@I-love.SAKURA.ne.jp>
Date:   Wed, 20 Apr 2022 11:22:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] wwan_hwsim: Avoid flush_scheduled_work() usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flushing system-wide workqueues is dangerous and will be forbidden.
Replace system_wq with local wwan_wq.

Link: https://lkml.kernel.org/r/49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Note: This patch is only compile tested. By the way, don't you want to call
debugfs_remove(wwan_hwsim_debugfs_devcreate) at err_clean_devs label in
wwan_hwsim_init() like wwan_hwsim_exit() does, for debugfs_create_file("devcreate")
is called before "goto err_clean_devs" happens?

 drivers/net/wwan/wwan_hwsim.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/wwan_hwsim.c b/drivers/net/wwan/wwan_hwsim.c
index 5b62cf3b3c42..2136319f588f 100644
--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -33,6 +33,7 @@ static struct dentry *wwan_hwsim_debugfs_devcreate;
 static DEFINE_SPINLOCK(wwan_hwsim_devs_lock);
 static LIST_HEAD(wwan_hwsim_devs);
 static unsigned int wwan_hwsim_dev_idx;
+static struct workqueue_struct *wwan_wq;
 
 struct wwan_hwsim_dev {
 	struct list_head list;
@@ -371,7 +372,7 @@ static ssize_t wwan_hwsim_debugfs_portdestroy_write(struct file *file,
 	 * waiting this callback to finish in the debugfs_remove() call. So,
 	 * use workqueue.
 	 */
-	schedule_work(&port->del_work);
+	queue_work(wwan_wq, &port->del_work);
 
 	return count;
 }
@@ -416,7 +417,7 @@ static ssize_t wwan_hwsim_debugfs_devdestroy_write(struct file *file,
 	 * waiting this callback to finish in the debugfs_remove() call. So,
 	 * use workqueue.
 	 */
-	schedule_work(&dev->del_work);
+	queue_work(wwan_wq, &dev->del_work);
 
 	return count;
 }
@@ -506,9 +507,15 @@ static int __init wwan_hwsim_init(void)
 	if (wwan_hwsim_devsnum < 0 || wwan_hwsim_devsnum > 128)
 		return -EINVAL;
 
+	wwan_wq = alloc_workqueue("wwan_wq", 0, 0);
+	if (!wwan_wq)
+		return -ENOMEM;
+
 	wwan_hwsim_class = class_create(THIS_MODULE, "wwan_hwsim");
-	if (IS_ERR(wwan_hwsim_class))
+	if (IS_ERR(wwan_hwsim_class)) {
+		destroy_workqueue(wwan_wq);
 		return PTR_ERR(wwan_hwsim_class);
+	}
 
 	wwan_hwsim_debugfs_topdir = debugfs_create_dir("wwan_hwsim", NULL);
 	wwan_hwsim_debugfs_devcreate =
@@ -524,6 +531,7 @@ static int __init wwan_hwsim_init(void)
 
 err_clean_devs:
 	wwan_hwsim_free_devs();
+	destroy_workqueue(wwan_wq);
 	debugfs_remove(wwan_hwsim_debugfs_topdir);
 	class_destroy(wwan_hwsim_class);
 
@@ -534,7 +542,7 @@ static void __exit wwan_hwsim_exit(void)
 {
 	debugfs_remove(wwan_hwsim_debugfs_devcreate);	/* Avoid new devs */
 	wwan_hwsim_free_devs();
-	flush_scheduled_work();		/* Wait deletion works completion */
+	destroy_workqueue(wwan_wq);		/* Wait deletion works completion */
 	debugfs_remove(wwan_hwsim_debugfs_topdir);
 	class_destroy(wwan_hwsim_class);
 }
-- 
2.32.0
