Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F1515DDF2
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389058AbgBNQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389049AbgBNQAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BA2B24681;
        Fri, 14 Feb 2020 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696004;
        bh=7L5bDc9acC8sQRHXM1BAfoIBdiypJUXvkpyIyTWMpSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZty0Cvj5PFXAXK6lThIDvv8Gcey5TXgxXEyGtHjcmJHyYSjDqKQ+qGdCT69h4/NW
         rz4PPS8Ddmi6s551GLSFwCnDmMzJB9FdJJv+f8dHIbvF2bjW4sxs+zOQ6AnmVfKRhd
         jwG3jBS3qcvSXCD8QQXun4tcUggEOCR8Pbxl2Yt8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 522/542] netdevsim: disable devlink reload when resources are being used
Date:   Fri, 14 Feb 2020 10:48:34 -0500
Message-Id: <20200214154854.6746-522-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 6ab63366e1ec4ec1900f253aa64727b4b5f4ee73 ]

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
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bus.c       | 19 +++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h |  2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index c086d1e522dc0..e455dd1cf4d0a 100644
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
index ea3931391ce21..be100b11a0550 100644
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
2.20.1

