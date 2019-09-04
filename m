Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC122A89DA
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731602AbfIDP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731239AbfIDP5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:57:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329CE233FF;
        Wed,  4 Sep 2019 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612663;
        bh=VYbY30XxuB4PDQyDyAilembN1dn12ZikXDIQuAiwlZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XkhxLTC2JDW7ZVhnjv9S8XxHimKyKKnxgCwy8inlfyR+AwwMyM58wxP7zSFQ990a
         Xhu+I836VDrzltwG8PlpmiFA8as6kUGGvtzrFpQoi8n4Nns1c2XJaVlatxVTCgA1w3
         qqNuJt2FpAjMuBEzeMv++XsWakPYNp9MJRVGnEuU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alexander Aring <aring@mojatatu.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 02/94] ieee802154: hwsim: unregister hw while hwsim_subscribe_all_others fails
Date:   Wed,  4 Sep 2019 11:56:07 -0400
Message-Id: <20190904155739.2816-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit de166bbe861738c8bc3e5dad5b03f45d7d6ef914 ]

KASAN report this:

kernel BUG at net/mac802154/main.c:130!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU: 0 PID: 19932 Comm: modprobe Not tainted 5.1.0-rc6+ #22
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:ieee802154_free_hw+0x2a/0x30 [mac802154]
Code: 55 48 8d 57 38 48 89 e5 53 48 89 fb 48 8b 47 38 48 39 c2 75 15 48 8d 7f 48 e8 82 85 16 e1 48 8b 7b 28 e8 f9 ef 83 e2 5b 5d c3 <0f> 0b 0f 1f 40 00 55 48 89 e5 53 48 89 fb 0f b6 86 80 00 00 00 88
RSP: 0018:ffffc90001c7b9f0 EFLAGS: 00010206
RAX: ffff88822df3aa80 RBX: ffff88823143d5c0 RCX: 0000000000000002
RDX: ffff88823143d5f8 RSI: ffff88822b1fabc0 RDI: ffff88823143d5c0
RBP: ffffc90001c7b9f8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000fffffff4
R13: ffff88822dea4f50 R14: ffff88823143d7c0 R15: 00000000fffffff4
FS: 00007ff52e999540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdc06dba768 CR3: 000000023160a000 CR4: 00000000000006f0
Call Trace:
 hwsim_add_one+0x2dd/0x540 [mac802154_hwsim]
 hwsim_probe+0x2f/0xb0 [mac802154_hwsim]
 platform_drv_probe+0x3a/0x90
 ? driver_sysfs_add+0x79/0xb0
 really_probe+0x1d4/0x2d0
 driver_probe_device+0x50/0xf0
 device_driver_attach+0x54/0x60
 __driver_attach+0x7e/0xd0
 ? device_driver_attach+0x60/0x60
 bus_for_each_dev+0x68/0xc0
 driver_attach+0x19/0x20
 bus_add_driver+0x15e/0x200
 driver_register+0x5b/0xf0
 __platform_driver_register+0x31/0x40
 hwsim_init_module+0x74/0x1000 [mac802154_hwsim]
 ? 0xffffffffa00e9000
 do_one_initcall+0x6c/0x3cc
 ? kmem_cache_alloc_trace+0x248/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7ff52e4a2839
Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffffa7b3c08 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 00005647560a2a00 RCX: 00007ff52e4a2839
RDX: 0000000000000000 RSI: 00005647547f3c2e RDI: 0000000000000003
RBP: 00005647547f3c2e R08: 0000000000000000 R09: 00005647560a2a00
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
R13: 00005647560a2c10 R14: 0000000000040000 R15: 00005647560a2a00
Modules linked in: mac802154_hwsim(+) mac802154 [last unloaded: mac802154_hwsim]

In hwsim_add_one, if hwsim_subscribe_all_others fails, we
should call ieee802154_unregister_hw to free resources.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Alexander Aring <aring@mojatatu.com>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index 94b9e9d775e40..c20e7ef18bc95 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -802,7 +802,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 		err = hwsim_subscribe_all_others(phy);
 		if (err < 0) {
 			mutex_unlock(&hwsim_phys_lock);
-			goto err_reg;
+			goto err_subscribe;
 		}
 	}
 	list_add_tail(&phy->list, &hwsim_phys);
@@ -812,6 +812,8 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
 
 	return idx;
 
+err_subscribe:
+	ieee802154_unregister_hw(phy->hw);
 err_reg:
 	kfree(pib);
 err_pib:
-- 
2.20.1

