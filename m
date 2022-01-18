Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A414919DF
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiARC4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56216 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349036AbiARCr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:47:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C25B81236;
        Tue, 18 Jan 2022 02:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94A9C36AF2;
        Tue, 18 Jan 2022 02:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474044;
        bh=teqJf60VfZfCyKR10hz8RbabCK/klAXvLnO3Vng0KDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sicew5hm5eyyPKlc0QKqYdx1xOVyOOVdSJRp1Nqq2cK9TdXbqxtoOw2xJAV8FwhVM
         5dPKMpHDWIYun4nidLQWT/X+ijSKhoM576hfR9KCq4X78QzjxpqfcVwyqlxGOzQlv9
         PHm/d0O/IcEWfQ5VkcNkvv6Gb4sJUCIIbWFUiVOnqykMbW/zTLhj8BuSHGqGeRmdDK
         vEWVsojU6tdCOrZVNnwiQSl7H8H37YwC1ymqyLN59DbF4ZHaEuR1aEFCwj/xWKAxnj
         ug2mlwrcRrp3e2IZllthkNG6wVeUdc0bBqWQQi/kiohWXRQHKAm5NeOdr+WVKr5TNO
         1ucjLlNtpI4BQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, petrm@nvidia.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/59] mlxsw: pci: Add shutdown method in PCI driver
Date:   Mon, 17 Jan 2022 21:46:10 -0500
Message-Id: <20220118024701.1952911-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit c1020d3cf4752f61a6a413f632ea2ce2370e150d ]

On an arm64 platform with the Spectrum ASIC, after loading and executing
a new kernel via kexec, the following trace [1] is observed. This seems
to be caused by the fact that the device is not properly shutdown before
executing the new kernel.

Fix this by implementing a shutdown method which mirrors the remove
method, as recommended by the kexec maintainer [2][3].

[1]
BUG: Bad page state in process devlink pfn:22f73d
page:fffffe00089dcf40 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x2ffff00000000000()
raw: 2ffff00000000000 0000000000000000 ffffffff089d0201 0000000000000000
raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
page dumped because: nonzero _refcount
Modules linked in:
CPU: 1 PID: 16346 Comm: devlink Tainted: G B 5.8.0-rc6-custom-273020-gac6b365b1bf5 #44
Hardware name: Marvell Armada 7040 TX4810M (DT)
Call trace:
 dump_backtrace+0x0/0x1d0
 show_stack+0x1c/0x28
 dump_stack+0xbc/0x118
 bad_page+0xcc/0xf8
 check_free_page_bad+0x80/0x88
 __free_pages_ok+0x3f8/0x418
 __free_pages+0x38/0x60
 kmem_freepages+0x200/0x2a8
 slab_destroy+0x28/0x68
 slabs_destroy+0x60/0x90
 ___cache_free+0x1b4/0x358
 kfree+0xc0/0x1d0
 skb_free_head+0x2c/0x38
 skb_release_data+0x110/0x1a0
 skb_release_all+0x2c/0x38
 consume_skb+0x38/0x130
 __dev_kfree_skb_any+0x44/0x50
 mlxsw_pci_rdq_fini+0x8c/0xb0
 mlxsw_pci_queue_fini.isra.0+0x28/0x58
 mlxsw_pci_queue_group_fini+0x58/0x88
 mlxsw_pci_aqs_fini+0x2c/0x60
 mlxsw_pci_fini+0x34/0x50
 mlxsw_core_bus_device_unregister+0x104/0x1d0
 mlxsw_devlink_core_bus_device_reload_down+0x2c/0x48
 devlink_reload+0x44/0x158
 devlink_nl_cmd_reload+0x270/0x290
 genl_rcv_msg+0x188/0x2f0
 netlink_rcv_skb+0x5c/0x118
 genl_rcv+0x3c/0x50
 netlink_unicast+0x1bc/0x278
 netlink_sendmsg+0x194/0x390
 __sys_sendto+0xe0/0x158
 __arm64_sys_sendto+0x2c/0x38
 el0_svc_common.constprop.0+0x70/0x168
 do_el0_svc+0x28/0x88
 el0_sync_handler+0x88/0x190
 el0_sync+0x140/0x180

[2]
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1195432.html

[3]
https://patchwork.kernel.org/project/linux-scsi/patch/20170212214920.28866-1-anton@ozlabs.org/#20116693

Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index a903e97793f9a..addd5765576d9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1825,6 +1825,7 @@ int mlxsw_pci_driver_register(struct pci_driver *pci_driver)
 {
 	pci_driver->probe = mlxsw_pci_probe;
 	pci_driver->remove = mlxsw_pci_remove;
+	pci_driver->shutdown = mlxsw_pci_remove;
 	return pci_register_driver(pci_driver);
 }
 EXPORT_SYMBOL(mlxsw_pci_driver_register);
-- 
2.34.1

