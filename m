Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8C714F8FD
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgBAQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:43:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40640 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:43:12 -0500
Received: by mail-pg1-f195.google.com with SMTP id k25so5306502pgt.7
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WA55O2LAbuHIVkTYze8Anafz7APb/LltyVrNpI6jWQE=;
        b=TLl4U6mgL5p176K2v5GwhTj31WY5u19AJtwMFzu4YR0v7LuQyk4/+ReghEq1ZOkKVw
         0fe77F+YvDeUtY/DGURkhoLlFQVNY4ptno0FQO+KWqb1fjywS8eNvsJdVEAOkPCCKKlR
         3to5Im98eI5OXW/LnidWRNjKl0sAUwBqqbr6w/N+ovJBsWhYrG+iw+Jyo3U6Pafygdxi
         v7qFAgoFBmlC6uZ+IlHsPQ9mAchdbPaug730KlQRxcCZD3y6ryA3/qTFmCdrBHTDzyfI
         AU35R7wiHD6+wDzL2wSgW9eC16Sf+3jBxqyogwxeZnwBbJcx3FJNlIZZMataYQ8LoK3B
         l4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WA55O2LAbuHIVkTYze8Anafz7APb/LltyVrNpI6jWQE=;
        b=hbR/i+68qukxr+qNdKSVnv/fijeypE+QYglJd1SkJD1IOVJqSXdzhUEFgQd6q0Ar4e
         nr3LHT+mEssZU0T/CcNmmdE0VZ9GUVDpKKgrwChzLeQK7G9exf77nw3gi3JpfsUHLNlJ
         HeW0JXfCe7UpH5IVBFPVOZiQ7lu+jIUPaEdJ8uqDqQ61VJfA6OelgnA7EV2KxJFn99T8
         Z7LJ4bqo+o4n7hWbFK2+CLK4+wYfMa1p5sIl0iQHS6KpckKyBgLUj9h6wK5zUnxQ2ZoT
         G+un8CtvATeKVA0v2cGaFDis+K/Ci52lq8M3pFpPX2t2ZtPfZcwsaow2c5Wy9x9cXu9v
         K60A==
X-Gm-Message-State: APjAAAXba4aOx0yyFc1VypErWvocDC7ZnkSb0g5zqsvoX+wRHGDB9jA3
        i1e203YsQ4u6c6Zxcs/bl0o=
X-Google-Smtp-Source: APXvYqyD3qaVD/u2vaLOmNVuDMkbp7m1LPmXBA9pTzKQvDbnRmdtLxDavdDfhr6URi8/NPFPRp+Teg==
X-Received: by 2002:a63:da0e:: with SMTP id c14mr14179494pgh.237.1580575391096;
        Sat, 01 Feb 2020 08:43:11 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id b15sm14138652pgh.40.2020.02.01.08.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:43:10 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 2/7] netdevsim: disable devlink reload when resources are being used
Date:   Sat,  1 Feb 2020 16:43:04 +0000
Message-Id: <20200201164304.9908-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink reload destroys resources and allocates resources again.
So, when devices and ports resources are being used, devlink reload
function should not be executed. In order to avoid this race, a new
lock is added and new_port() and del_port() call devlink_reload_disable()
and devlink_reload_enable().

Thread0                      Thread1
{new/del}_port()             {new/del}_port()
devlink_reload_disable()
                             devlink_reload_disable()
devlink_reload_enable()
                             //here
                             devlink_reload_enable()

Before Thread1's devlink_reload_enable(), the devlink is already allowed
to execute reload because Thread0 allows it. devlink reload disable/enable
variable type is bool. So the above case would exist.
So, disable/enable should be executed atomically.
In order to do that, a new lock is used.

Test commands:
    modprobe netdevsim
    echo 1 > /sys/bus/netdevsim/new_device
    while :
    do
        echo 1 > /sys/devices/netdevsim1/new_port &
        echo 1 > /sys/devices/netdevsim1/del_port &
        devlink dev reload netdevsim/netdevsim1 &
    done

Splat looks like:
[   23.342145][  T932] DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock))
[   23.342159][  T932] WARNING: CPU: 0 PID: 932 at kernel/locking/mutex-debug.c:103 mutex_destroy+0xc7/0xf0
[   23.344182][  T932] Modules linked in: netdevsim openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_dx
[   23.346485][  T932] CPU: 0 PID: 932 Comm: devlink Not tainted 5.5.0+ #322
[   23.347696][  T932] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   23.348893][  T932] RIP: 0010:mutex_destroy+0xc7/0xf0
[   23.349505][  T932] Code: e0 07 83 c0 03 38 d0 7c 04 84 d2 75 2e 8b 05 00 ac b0 02 85 c0 75 8b 48 c7 c6 00 5e 07 96 40
[   23.351887][  T932] RSP: 0018:ffff88806208f810 EFLAGS: 00010286
[   23.353963][  T932] RAX: dffffc0000000008 RBX: ffff888067f6f2c0 RCX: ffffffff942c4bd4
[   23.355222][  T932] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff96dac5b4
[   23.356169][  T932] RBP: ffff888067f6f000 R08: fffffbfff2d235a5 R09: fffffbfff2d235a5
[   23.357160][  T932] R10: 0000000000000001 R11: fffffbfff2d235a4 R12: ffff888067f6f208
[   23.358288][  T932] R13: ffff88806208fa70 R14: ffff888067f6f000 R15: ffff888069ce3800
[   23.359307][  T932] FS:  00007fe2a3876740(0000) GS:ffff88806c000000(0000) knlGS:0000000000000000
[   23.360473][  T932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.361319][  T932] CR2: 00005561357aa000 CR3: 000000005227a006 CR4: 00000000000606f0
[   23.362323][  T932] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.363417][  T932] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   23.364414][  T932] Call Trace:
[   23.364828][  T932]  nsim_dev_reload_destroy+0x77/0xb0 [netdevsim]
[   23.365655][  T932]  nsim_dev_reload_down+0x84/0xb0 [netdevsim]
[   23.366433][  T932]  devlink_reload+0xb1/0x350
[   23.367010][  T932]  genl_rcv_msg+0x580/0xe90

[ ...]

[   23.531729][ T1305] kernel BUG at lib/list_debug.c:53!
[   23.532523][ T1305] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[   23.533467][ T1305] CPU: 2 PID: 1305 Comm: bash Tainted: G        W         5.5.0+ #322
[   23.534962][ T1305] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   23.536503][ T1305] RIP: 0010:__list_del_entry_valid+0xe6/0x150
[   23.538346][ T1305] Code: 89 ea 48 c7 c7 00 73 1e 96 e8 df f7 4c ff 0f 0b 48 c7 c7 60 73 1e 96 e8 d1 f7 4c ff 0f 0b 44
[   23.541068][ T1305] RSP: 0018:ffff888047c27b58 EFLAGS: 00010282
[   23.542001][ T1305] RAX: 0000000000000054 RBX: ffff888067f6f318 RCX: 0000000000000000
[   23.543051][ T1305] RDX: 0000000000000054 RSI: 0000000000000008 RDI: ffffed1008f84f61
[   23.544072][ T1305] RBP: ffff88804aa0fca0 R08: ffffed100d940539 R09: ffffed100d940539
[   23.545085][ T1305] R10: 0000000000000001 R11: ffffed100d940538 R12: ffff888047c27cb0
[   23.546422][ T1305] R13: ffff88806208b840 R14: ffffffff981976c0 R15: ffff888067f6f2c0
[   23.547406][ T1305] FS:  00007f76c0431740(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[   23.548527][ T1305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.549389][ T1305] CR2: 00007f5048f1a2f8 CR3: 000000004b310006 CR4: 00000000000606e0
[   23.550636][ T1305] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.551578][ T1305] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   23.552597][ T1305] Call Trace:
[   23.553004][ T1305]  mutex_remove_waiter+0x101/0x520
[   23.553646][ T1305]  __mutex_lock+0xac7/0x14b0
[   23.554218][ T1305]  ? nsim_dev_port_del+0x4e/0x140 [netdevsim]
[   23.554908][ T1305]  ? mutex_lock_io_nested+0x1380/0x1380
[   23.555570][ T1305]  ? _parse_integer+0xf0/0xf0
[   23.556043][ T1305]  ? kstrtouint+0x86/0x110
[   23.556504][ T1305]  ? nsim_dev_port_del+0x4e/0x140 [netdevsim]
[   23.557133][ T1305]  nsim_dev_port_del+0x4e/0x140 [netdevsim]
[   23.558024][ T1305]  del_port_store+0xcc/0xf0 [netdevsim]
[ ... ]

Fixes: 75ba029f3c07 ("netdevsim: implement proper devlink reload")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v3:
 - Fix deadlock
 - Do not fix snapshot_write() panic in this patch

v2:
 - Initial patch

 drivers/net/netdevsim/bus.c       | 19 +++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index c086d1e522dc..e455dd1cf4d0 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -97,6 +97,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
+	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
+	struct devlink *devlink;
 	unsigned int port_index;
 	int ret;
 
@@ -106,7 +108,14 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
+
+	devlink = priv_to_devlink(nsim_dev);
+
+	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
+	devlink_reload_disable(devlink);
 	ret = nsim_dev_port_add(nsim_bus_dev, port_index);
+	devlink_reload_enable(devlink);
+	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
 
@@ -117,6 +126,8 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
+	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
+	struct devlink *devlink;
 	unsigned int port_index;
 	int ret;
 
@@ -126,7 +137,14 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	ret = kstrtouint(buf, 0, &port_index);
 	if (ret)
 		return ret;
+
+	devlink = priv_to_devlink(nsim_dev);
+
+	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
+	devlink_reload_disable(devlink);
 	ret = nsim_dev_port_del(nsim_bus_dev, port_index);
+	devlink_reload_enable(devlink);
+	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
 
@@ -311,6 +329,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
+	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index ea3931391ce2..be100b11a055 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -240,6 +240,8 @@ struct nsim_bus_dev {
 				  */
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
+	/* Lock for devlink->reload_enabled in netdevsim module */
+	struct mutex nsim_bus_reload_lock;
 	bool init;
 };
 
-- 
2.17.1

