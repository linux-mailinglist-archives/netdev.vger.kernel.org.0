Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5214F8FE
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBAQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:43:21 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40407 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:43:20 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so5106891pfh.7
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jptiljI4IKOrS9i29P0RFBNgHoput2D6Veg9MuarmYw=;
        b=FlXP7wFmXQkfounQN5nUwRORIQACmDCMFJDEFabyt1hdiR+WF1piDFksXznQ7s0wvM
         gsfX40W2o6CZZpdZrhJGFARyJpPslbaV1GFyNgRxn+4zmF+u0GfTrnwzV486uqPfeFD1
         Wj/e1NNSKTOY0EDbxRqrKzrPgk70c6Gg1thIMRr8+W7l4WtbIPeT5N5/fveMUQ1eTTE5
         dE55a/CeaxD3NEs13p1PU+TYySLrU3uKMgmALEwsJgHcAu1SKUSZLasxnOK3Mf+d011R
         YYR5CY+rYLYY04A80OmljaL2Mdu9VLTRQcdywhzPh4hAIAoSDOtzt38n2SjA+SNU0/df
         Jv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jptiljI4IKOrS9i29P0RFBNgHoput2D6Veg9MuarmYw=;
        b=XT0kYguLewIcg9Kcf0gN7yJvhizbhgjBSc6QCdMUEO6qbGsuNvfRETEswIw58rN0A1
         Ltv0Ed5X+SjutW6L9Qs5NsQvh1reVxibaM2F7XkL4wLpoQyRVLAVDW2T5lOuVy+xKflL
         UO+FiUZIBJc/qrSn3PtA8UpSPBRO0ssTVXkM/UWv7sNBeGTrLOggmBKSVx7T1XTNgwMu
         HILdXe10wuyiIyqO5cwXHVew+3OVvIBFSaPGYDzJHwcqASv5C1jy3R+IIf10TMWzsa3H
         mSJAHdaOJ48JGYskf9G4Y8EaKDkYpxHhaycWKkVGuPromoALDWZ5m+F4V6BQXl4fSED8
         MoDQ==
X-Gm-Message-State: APjAAAWhCEP2J9ZEjpYuYI6FQFzNjNxCaShsxo1rE/fksiOuLBi9cOLg
        gVyEXZ6hQV/8KbsRSgtSicY=
X-Google-Smtp-Source: APXvYqxaykRwmHqIStn97a1ePa6Lw8FZUWyIcVizNcxBVMdtlJm3oec+F9dh7LiC4M8ndfm6Ann6bw==
X-Received: by 2002:a63:5456:: with SMTP id e22mr15933184pgm.177.1580575399975;
        Sat, 01 Feb 2020 08:43:19 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id b18sm4030219pfd.63.2020.02.01.08.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:43:19 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 3/7] netdevsim: fix panic in nsim_dev_take_snapshot_write()
Date:   Sat,  1 Feb 2020 16:43:13 +0000
Message-Id: <20200201164313.9987-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nsim_dev_take_snapshot_write() uses nsim_dev and nsim_dev->dummy_region.
So, during this function, these data shouldn't be removed.
But there is no protecting stuff in this function.

There are two similar cases.
1. reload case
reload could be called during nsim_dev_take_snapshot_write().
When reload is being executed, nsim_dev_reload_down() is called and it
calls nsim_dev_reload_destroy(). nsim_dev_reload_destroy() calls
devlink_region_destroy() to destroy nsim_dev->dummy_region.
So, during nsim_dev_take_snapshot_write(), nsim_dev->dummy_region()
would be removed.
At this point, snapshot_write() would access freed pointer.
In order to fix this case, take_snapshot file will be removed before
devlink_region_destroy().
The take_snapshot file will be re-created by ->reload_up().

2. del_device_store case
del_device_store() also could call nsim_dev_reload_destroy()
during nsim_dev_take_snapshot_write(). If so, panic would occur.
This problem is actually the same problem with the first case.
So, this problem will be fixed by the first case's solution.

Test commands:
    modprobe netdevsim
    while :
    do
        echo 1 > /sys/bus/netdevsim/new_device &
        echo 1 > /sys/bus/netdevsim/del_device &
	devlink dev reload netdevsim/netdevsim1 &
	echo 1 > /sys/kernel/debug/netdevsim/netdevsim1/take_snapshot &
    done

Splat looks like:
[   45.564513][  T975] general protection fault, probably for non-canonical address 0xdffffc000000003a: 0000 [#1] SMP DEI
[   45.566131][  T975] KASAN: null-ptr-deref in range [0x00000000000001d0-0x00000000000001d7]
[   45.566135][  T975] CPU: 1 PID: 975 Comm: bash Not tainted 5.5.0+ #322
[   45.569020][  T975] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   45.569026][  T975] RIP: 0010:__mutex_lock+0x10a/0x14b0
[   45.570518][  T975] Code: 08 84 d2 0f 85 7f 12 00 00 44 8b 0d 10 23 65 02 45 85 c9 75 29 49 8d 7f 68 48 b8 00 00 00 0f
[   45.570522][  T975] RSP: 0018:ffff888046ccfbf0 EFLAGS: 00010206
[   45.572305][  T975] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   45.572308][  T975] RDX: 000000000000003a RSI: ffffffffac926440 RDI: 00000000000001d0
[   45.576843][  T975] RBP: ffff888046ccfd70 R08: ffffffffab610645 R09: 0000000000000000
[   45.576847][  T975] R10: ffff888046ccfd90 R11: ffffed100d6360ad R12: 0000000000000000
[   45.578471][  T975] R13: dffffc0000000000 R14: ffffffffae1976c0 R15: 0000000000000168
[   45.578475][  T975] FS:  00007f614d6e7740(0000) GS:ffff88806c400000(0000) knlGS:0000000000000000
[   45.581492][  T975] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.582942][  T975] CR2: 00005618677d1cf0 CR3: 000000005fb9c002 CR4: 00000000000606e0
[   45.584543][  T975] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.586633][  T975] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   45.589889][  T975] Call Trace:
[   45.591445][  T975]  ? devlink_region_snapshot_create+0x55/0x4a0
[   45.601250][  T975]  ? mutex_lock_io_nested+0x1380/0x1380
[   45.602817][  T975]  ? mutex_lock_io_nested+0x1380/0x1380
[   45.603875][  T975]  ? mark_held_locks+0xa5/0xe0
[   45.604769][  T975]  ? _raw_spin_unlock_irqrestore+0x2d/0x50
[   45.606147][  T975]  ? __mutex_unlock_slowpath+0xd0/0x670
[   45.607723][  T975]  ? crng_backtrack_protect+0x80/0x80
[   45.613530][  T975]  ? wait_for_completion+0x390/0x390
[   45.615152][  T975]  ? devlink_region_snapshot_create+0x55/0x4a0
[   45.616834][  T975]  devlink_region_snapshot_create+0x55/0x4a0
[ ... ]

Fixes: 4418f862d675 ("netdevsim: implement support for devlink region and snapshots")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v3 : Initial patch

 drivers/net/netdevsim/dev.c       | 13 +++++++++++--
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b53fbc06e104..06b178be3017 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -88,8 +88,11 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			   &nsim_dev->max_macs);
 	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
 			    &nsim_dev->test1);
-	debugfs_create_file("take_snapshot", 0200, nsim_dev->ddir, nsim_dev,
-			    &nsim_dev_take_snapshot_fops);
+	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
+						      0200,
+						      nsim_dev->ddir,
+						      nsim_dev,
+						&nsim_dev_take_snapshot_fops);
 	debugfs_create_bool("dont_allow_reload", 0600, nsim_dev->ddir,
 			    &nsim_dev->dont_allow_reload);
 	debugfs_create_bool("fail_reload", 0600, nsim_dev->ddir,
@@ -740,6 +743,11 @@ static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_health_exit;
 
+	nsim_dev->take_snapshot = debugfs_create_file("take_snapshot",
+						      0200,
+						      nsim_dev->ddir,
+						      nsim_dev,
+						&nsim_dev_take_snapshot_fops);
 	return 0;
 
 err_health_exit:
@@ -853,6 +861,7 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 
 	if (devlink_is_reload_failed(devlink))
 		return;
+	debugfs_remove(nsim_dev->take_snapshot);
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index be100b11a055..2eb7b0dc1594 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -160,6 +160,7 @@ struct nsim_dev {
 	struct nsim_trap_data *trap_data;
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
+	struct dentry *take_snapshot;
 	struct bpf_offload_dev *bpf_dev;
 	bool bpf_bind_accept;
 	u32 bpf_bind_verifier_delay;
-- 
2.17.1

