Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FEC15DDF3
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389132AbgBNQBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:01:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388806AbgBNQAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:00:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F065D22314;
        Fri, 14 Feb 2020 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696006;
        bh=bKWTegWPGxXJzSS7GBSpgIhE21Cq/xxb9SuoiA7D0UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbW6xFsDpIfjdHUF7XJaO2I1ijF8LUrWgWTt7Q2BGZ7LsMoCVQRngS9fttvIGnJjL
         Ai9Wffbo61GKU1ZsHil2biLoAwXFVLQ/J3t3vNXucp7K9j48CbYWze2l9io5/42No0
         wd5cwoWCsM6/4yZA7Ea0Lnc9YlmS6WLJjlECq6xQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 524/542] netdevsim: use __GFP_NOWARN to avoid memalloc warning
Date:   Fri, 14 Feb 2020 10:48:36 -0500
Message-Id: <20200214154854.6746-524-sashal@kernel.org>
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

[ Upstream commit 83cf4213bafc4e3c747f0a25ad22cfbf55af7e84 ]

vfnum buffer size and binary_len buffer size is received by user-space.
So, this buffer size could be too large. If so, kmalloc will internally
print a warning message.
This warning message is actually not necessary for the netdevsim module.
So, this patch adds __GFP_NOWARN.

Test commands:
    modprobe netdevsim
    echo 1 > /sys/bus/netdevsim/new_device
    echo 1000000000 > /sys/devices/netdevsim1/sriov_numvfs

Splat looks like:
[  357.847266][ T1000] WARNING: CPU: 0 PID: 1000 at mm/page_alloc.c:4738 __alloc_pages_nodemask+0x2f3/0x740
[  357.850273][ T1000] Modules linked in: netdevsim veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrx
[  357.852989][ T1000] CPU: 0 PID: 1000 Comm: bash Tainted: G    B             5.5.0-rc5+ #270
[  357.854334][ T1000] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  357.855703][ T1000] RIP: 0010:__alloc_pages_nodemask+0x2f3/0x740
[  357.856669][ T1000] Code: 64 fe ff ff 65 48 8b 04 25 c0 0f 02 00 48 05 f0 12 00 00 41 be 01 00 00 00 49 89 47 0
[  357.860272][ T1000] RSP: 0018:ffff8880b7f47bd8 EFLAGS: 00010246
[  357.861009][ T1000] RAX: ffffed1016fe8f80 RBX: 1ffff11016fe8fae RCX: 0000000000000000
[  357.861843][ T1000] RDX: 0000000000000000 RSI: 0000000000000017 RDI: 0000000000000000
[  357.862661][ T1000] RBP: 0000000000040dc0 R08: 1ffff11016fe8f67 R09: dffffc0000000000
[  357.863509][ T1000] R10: ffff8880b7f47d68 R11: fffffbfff2798180 R12: 1ffff11016fe8f80
[  357.864355][ T1000] R13: 0000000000000017 R14: 0000000000000017 R15: ffff8880c2038d68
[  357.865178][ T1000] FS:  00007fd9a5b8c740(0000) GS:ffff8880d9c00000(0000) knlGS:0000000000000000
[  357.866248][ T1000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  357.867531][ T1000] CR2: 000055ce01ba8100 CR3: 00000000b7dbe005 CR4: 00000000000606f0
[  357.868972][ T1000] Call Trace:
[  357.869423][ T1000]  ? lock_contended+0xcd0/0xcd0
[  357.870001][ T1000]  ? __alloc_pages_slowpath+0x21d0/0x21d0
[  357.870673][ T1000]  ? _kstrtoull+0x76/0x160
[  357.871148][ T1000]  ? alloc_pages_current+0xc1/0x1a0
[  357.871704][ T1000]  kmalloc_order+0x22/0x80
[  357.872184][ T1000]  kmalloc_order_trace+0x1d/0x140
[  357.872733][ T1000]  __kmalloc+0x302/0x3a0
[  357.873204][ T1000]  nsim_bus_dev_numvfs_store+0x1ab/0x260 [netdevsim]
[  357.873919][ T1000]  ? kernfs_get_active+0x12c/0x180
[  357.874459][ T1000]  ? new_device_store+0x450/0x450 [netdevsim]
[  357.875111][ T1000]  ? kernfs_get_parent+0x70/0x70
[  357.875632][ T1000]  ? sysfs_file_ops+0x160/0x160
[  357.876152][ T1000]  kernfs_fop_write+0x276/0x410
[  357.876680][ T1000]  ? __sb_start_write+0x1ba/0x2e0
[  357.877225][ T1000]  vfs_write+0x197/0x4a0
[  357.877671][ T1000]  ksys_write+0x141/0x1d0
[ ... ]

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 79579220566c ("netdevsim: add SR-IOV functionality")
Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bus.c    | 2 +-
 drivers/net/netdevsim/health.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index e455dd1cf4d0a..7971dc4f54f15 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -29,7 +29,7 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 {
 	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
 					  sizeof(struct nsim_vf_config),
-					  GFP_KERNEL);
+					  GFP_KERNEL | __GFP_NOWARN);
 	if (!nsim_bus_dev->vfconfigs)
 		return -ENOMEM;
 	nsim_bus_dev->num_vfs = num_vfs;
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 9aa637d162eb7..c06e0f8fbc102 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -82,7 +82,7 @@ static int nsim_dev_dummy_fmsg_put(struct devlink_fmsg *fmsg, u32 binary_len)
 	if (err)
 		return err;
 
-	binary = kmalloc(binary_len, GFP_KERNEL);
+	binary = kmalloc(binary_len, GFP_KERNEL | __GFP_NOWARN);
 	if (!binary)
 		return -ENOMEM;
 	get_random_bytes(binary, binary_len);
-- 
2.20.1

