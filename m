Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1642428B5A1
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbgJLNL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbgJLNLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:11:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D0FC0613D0
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:11:19 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e17so19103236wru.12
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M471UGfuBWt6yY+tDjH4sZm57cgDUmY0/hgycjvGwOs=;
        b=xQInceDF8S6DNOMuW7QbQgBZgJ/1YHuMmbGeTuc2ta0dAesenpHohRVCoXkCRZM5st
         P75WceanY/DfHDQu6F6Rc/tm9ONnSGHBcPl9prSt5zvmXCMoyHFiJmaEN7zSwE+FFdyA
         o3YvEJr5UKD/3xNxfNGZmkaqb6D96wC7D50sxjI26zxRewmdZ6gDBjCRk3yKQhn9DxcG
         n0avGv8//4v14pvPXWJ9CNCEsfnJ0Hvzk7l7CuK1jQX/MYKSnacSPHF1FtpCvWSXj+2M
         JGHvPprGRsp6uDg8HI0RPbK0dMWPadmCSRUq17DVRfgHV9uadP/UTIWnLTqtVbaJ/6w1
         mSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M471UGfuBWt6yY+tDjH4sZm57cgDUmY0/hgycjvGwOs=;
        b=YbJ287vw5abcWAtAhQj9r01Uq+tdygMunJCCqUVC0I2ucxoRtAeETpApm4gy5bEjsc
         qZmNSpwRYMd71eUItQ3pOZIlwTUSH2vDr45xmS1mm+oFJgX0k8trNVqhWUwi/wcbGcPO
         wLNTK8Jqty4Wwv+5O29UvVB4mNaSrkG4U5GCVK1zTmFJRcCl1IOx9naLCeLg6NjDbbuG
         sAkABdcnSZtpj/bi5OBAH7DCUAbVmC/ckdcCNm49GzZNCjlj3I5quffAFElh1TUJSOd0
         8dc3JRa3PB/QqXTgaW6NiCRd1K1/2xb8szsP8wJhNRIHz89M6cSFvFQbA/XFD7Y9FVLB
         +aFA==
X-Gm-Message-State: AOAM530THBOStkDPkUvv5k0gQlDDQfmBMKn+bnROezNcnWTNYDQ3m12Q
        WUGSs9lmkVEbomEa+deBqYkqxWbZZTYcyxdslbcSVO0V87hZABBusU+xRIqJH6Ouna8VjA04jvW
        IyaqfoEw2X1KYz13zmsOwORquYcA0Pe9Tm9FVcc25QJa38S62gqqRU9+bEZbXAEC6PL5nkg==
X-Google-Smtp-Source: ABdhPJwzSBE6eYqHoV2JbUqbgKTswY99fIDBziJzeQyd/6QZIj2KSaMx5uGMFBH/QOcJDbBhrLqjoQ==
X-Received: by 2002:adf:e601:: with SMTP id p1mr32008338wrm.172.1602508277580;
        Mon, 12 Oct 2020 06:11:17 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id y7sm23600622wmg.40.2020.10.12.06.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:11:16 -0700 (PDT)
From:   Jamie Iles <jamie@nuviainc.com>
To:     netdev@vger.kernel.org
Cc:     Jamie Iles <jamie@nuviainc.com>, Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH 3/5] bonding: wait for sysfs kobject destruction before freeing struct slave
Date:   Mon, 12 Oct 2020 14:11:15 +0100
Message-Id: <20201012131115.58843-1-jamie@nuviainc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
struct slave device could result in the following splat:

  kobject: 'bonding_slave' (00000000cecdd4fe): kobject_release, parent 0000000074ceb2b2 (delayed 1000)
  bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
  ------------[ cut here ]------------
  ODEBUG: free active (active state 0) object type: timer_list hint: workqueue_select_cpu_near kernel/workqueue.c:1549 [inline]
  ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x98 kernel/workqueue.c:1600
  WARNING: CPU: 1 PID: 842 at lib/debugobjects.c:485 debug_print_object+0x180/0x240 lib/debugobjects.c:485
  Kernel panic - not syncing: panic_on_warn set ...
  CPU: 1 PID: 842 Comm: kworker/u4:4 Tainted: G S                5.9.0-rc8+ #96
  Hardware name: linux,dummy-virt (DT)
  Workqueue: netns cleanup_net
  Call trace:
   dump_backtrace+0x0/0x4d8 include/linux/bitmap.h:239
   show_stack+0x34/0x48 arch/arm64/kernel/traps.c:142
   __dump_stack lib/dump_stack.c:77 [inline]
   dump_stack+0x174/0x1f8 lib/dump_stack.c:118
   panic+0x360/0x7a0 kernel/panic.c:231
   __warn+0x244/0x2ec kernel/panic.c:600
   report_bug+0x240/0x398 lib/bug.c:198
   bug_handler+0x50/0xc0 arch/arm64/kernel/traps.c:974
   call_break_hook+0x160/0x1d8 arch/arm64/kernel/debug-monitors.c:322
   brk_handler+0x30/0xc0 arch/arm64/kernel/debug-monitors.c:329
   do_debug_exception+0x184/0x340 arch/arm64/mm/fault.c:864
   el1_dbg+0x48/0xb0 arch/arm64/kernel/entry-common.c:65
   el1_sync_handler+0x170/0x1c8 arch/arm64/kernel/entry-common.c:93
   el1_sync+0x80/0x100 arch/arm64/kernel/entry.S:594
   debug_print_object+0x180/0x240 lib/debugobjects.c:485
   __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
   debug_check_no_obj_freed+0x200/0x430 lib/debugobjects.c:998
   slab_free_hook mm/slub.c:1536 [inline]
   slab_free_freelist_hook+0x190/0x210 mm/slub.c:1577
   slab_free mm/slub.c:3138 [inline]
   kfree+0x13c/0x460 mm/slub.c:4119
   bond_free_slave+0x8c/0xf8 drivers/net/bonding/bond_main.c:1492
   __bond_release_one+0xe0c/0xec8 drivers/net/bonding/bond_main.c:2190
   bond_slave_netdev_event drivers/net/bonding/bond_main.c:3309 [inline]
   bond_netdev_event+0x8f0/0xa70 drivers/net/bonding/bond_main.c:3420
   notifier_call_chain+0xf0/0x200 kernel/notifier.c:83
   __raw_notifier_call_chain kernel/notifier.c:361 [inline]
   raw_notifier_call_chain+0x44/0x58 kernel/notifier.c:368
   call_netdevice_notifiers_info+0xbc/0x150 net/core/dev.c:2033
   call_netdevice_notifiers_extack net/core/dev.c:2045 [inline]
   call_netdevice_notifiers net/core/dev.c:2059 [inline]
   rollback_registered_many+0x6a4/0xec0 net/core/dev.c:9347
   unregister_netdevice_many.part.0+0x2c/0x1c0 net/core/dev.c:10509
   unregister_netdevice_many net/core/dev.c:10508 [inline]
   default_device_exit_batch+0x294/0x338 net/core/dev.c:10992
   ops_exit_list.isra.0+0xec/0x150 net/core/net_namespace.c:189
   cleanup_net+0x44c/0x888 net/core/net_namespace.c:603
   process_one_work+0x96c/0x18c0 kernel/workqueue.c:2269
   worker_thread+0x3f0/0xc30 kernel/workqueue.c:2415
   kthread+0x390/0x498 kernel/kthread.c:292
   ret_from_fork+0x10/0x18 arch/arm64/kernel/entry.S:925

This is a potential use-after-free if the sysfs nodes are being accessed
whilst removing the struct slave, so wait for the object destruction to
complete before freeing the struct slave itself.

Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
Fixes: a068aab42258 ("bonding: Fix reference count leak in bond_sysfs_slave_add.")
Cc: Qiushi Wu <wu000273@umn.edu>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
---
 drivers/net/bonding/bond_sysfs_slave.c | 12 ++++++++++++
 include/net/bonding.h                  |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 9b8346638f69..2fdbcf9692c5 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -136,7 +136,15 @@ static const struct sysfs_ops slave_sysfs_ops = {
 	.show = slave_show,
 };
 
+static void slave_release(struct kobject *kobj)
+{
+	struct slave *slave = to_slave(kobj);
+
+	complete(&slave->kobj_unregister_done);
+}
+
 static struct kobj_type slave_ktype = {
+	.release = slave_release,
 #ifdef CONFIG_SYSFS
 	.sysfs_ops = &slave_sysfs_ops,
 #endif
@@ -147,10 +155,12 @@ int bond_sysfs_slave_add(struct slave *slave)
 	const struct slave_attribute **a;
 	int err;
 
+	init_completion(&slave->kobj_unregister_done);
 	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
 				   &(slave->dev->dev.kobj), "bonding_slave");
 	if (err) {
 		kobject_put(&slave->kobj);
+		wait_for_completion(&slave->kobj_unregister_done);
 		return err;
 	}
 
@@ -158,6 +168,7 @@ int bond_sysfs_slave_add(struct slave *slave)
 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
 		if (err) {
 			kobject_put(&slave->kobj);
+			wait_for_completion(&slave->kobj_unregister_done);
 			return err;
 		}
 	}
@@ -173,4 +184,5 @@ void bond_sysfs_slave_del(struct slave *slave)
 		sysfs_remove_file(&slave->kobj, &((*a)->attr));
 
 	kobject_put(&slave->kobj);
+	wait_for_completion(&slave->kobj_unregister_done);
 }
diff --git a/include/net/bonding.h b/include/net/bonding.h
index aa854a9c01e2..5db6e8252fed 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -25,6 +25,7 @@
 #include <linux/etherdevice.h>
 #include <linux/reciprocal_div.h>
 #include <linux/if_link.h>
+#include <linux/completion.h>
 
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
@@ -177,6 +178,7 @@ struct slave {
 #endif
 	struct delayed_work notify_work;
 	struct kobject kobj;
+	struct completion kobj_unregister_done;
 	struct rtnl_link_stats64 slave_stats;
 };
 
-- 
2.25.1

