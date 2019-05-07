Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F309D15AC0
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfEGFrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfEGFlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:41:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E77A205ED;
        Tue,  7 May 2019 05:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207666;
        bh=2TFotMoJogSz8cQ3D94lytrYGs0Rm9Nw/CN5qSOhZb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlibZBCjGXCiAQMN7k8jLO1P42YBSm6W9M9i/ST6071ICpgJMfBoWtQ4BmUcT+NTl
         PKIUTVA/ldry5bza0s38snUXrfuXSVox99PFDP914tgjYYHxiDx3nsPKeJxCaaboii
         DrWRqRlSYHQZF87Gmpoozv206Aa2scijs7ZcJn/M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jun Xiao <xiaojun2@hisilicon.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 85/95] net: hns: Fix WARNING when hns modules installed
Date:   Tue,  7 May 2019 01:38:14 -0400
Message-Id: <20190507053826.31622-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jun Xiao <xiaojun2@hisilicon.com>

[ Upstream commit c77804be53369dd4c15bfc376cf9b45948194cab ]

Commit 308c6cafde01 ("net: hns: All ports can not work when insmod hns ko
after rmmod.") add phy_stop in hns_nic_init_phy(), In the branch of "net",
this method is effective, but in the branch of "net-next", it will cause
a WARNING when hns modules loaded, reference to commit 2b3e88ea6528 ("net:
phy: improve phy state checking"):

[10.092168] ------------[ cut here ]------------
[10.092171] called from state READY
[10.092189] WARNING: CPU: 4 PID: 1 at ../drivers/net/phy/phy.c:854
                phy_stop+0x90/0xb0
[10.092192] Modules linked in:
[10.092197] CPU: 4 PID:1 Comm:swapper/0 Not tainted 4.20.0-rc7-next-20181220 #1
[10.092200] Hardware name: Huawei TaiShan 2280 /D05, BIOS Hisilicon D05 UEFI
                16.12 Release 05/15/2017
[10.092202] pstate: 60000005 (nZCv daif -PAN -UAO)
[10.092205] pc : phy_stop+0x90/0xb0
[10.092208] lr : phy_stop+0x90/0xb0
[10.092209] sp : ffff00001159ba90
[10.092212] x29: ffff00001159ba90 x28: 0000000000000007
[10.092215] x27: ffff000011180068 x26: ffff0000110a5620
[10.092218] x25: ffff0000113b6000 x24: ffff842f96dac000
[10.092221] x23: 0000000000000000 x22: 0000000000000000
[10.092223] x21: ffff841fb8425e18 x20: ffff801fb3a56438
[10.092226] x19: ffff801fb3a56000 x18: ffffffffffffffff
[10.092228] x17: 0000000000000000 x16: 0000000000000000
[10.092231] x15: ffff00001122d6c8 x14: ffff00009159b7b7
[10.092234] x13: ffff00001159b7c5 x12: ffff000011245000
[10.092236] x11: 0000000005f5e0ff x10: ffff00001159b750
[10.092239] x9 : 00000000ffffffd0 x8 : 0000000000000465
[10.092242] x7 : ffff0000112457f8 x6 : ffff0000113bd7ce
[10.092245] x5 : 0000000000000000 x4 : 0000000000000000
[10.092247] x3 : 00000000ffffffff x2 : ffff000011245828
[10.092250] x1 : 4b5860bd05871300 x0 : 0000000000000000
[10.092253] Call trace:
[10.092255]  phy_stop+0x90/0xb0
[10.092260]  hns_nic_init_phy+0xf8/0x110
[10.092262]  hns_nic_try_get_ae+0x4c/0x3b0
[10.092264]  hns_nic_dev_probe+0x1fc/0x480
[10.092268]  platform_drv_probe+0x50/0xa0
[10.092271]  really_probe+0x1f4/0x298
[10.092273]  driver_probe_device+0x58/0x108
[10.092275]  __driver_attach+0xdc/0xe0
[10.092278]  bus_for_each_dev+0x74/0xc8
[10.092280]  driver_attach+0x20/0x28
[10.092283]  bus_add_driver+0x1b8/0x228
[10.092285]  driver_register+0x60/0x110
[10.092288]  __platform_driver_register+0x40/0x48
[10.092292]  hns_nic_dev_driver_init+0x18/0x20
[10.092296]  do_one_initcall+0x5c/0x180
[10.092299]  kernel_init_freeable+0x198/0x240
[10.092303]  kernel_init+0x10/0x108
[10.092306]  ret_from_fork+0x10/0x18
[10.092308] ---[ end trace 1396dd0278e397eb ]---

This WARNING occurred because of calling phy_stop before phy_start.

The root cause of the problem in commit '308c6cafde01' is:

Reference to hns_nic_init_phy, the flag phydev->supported is changed after
phy_connect_direct. The flag phydev->supported is 0x6ff when hns modules is
loaded, so will not change Fiber Port power(Reference to marvell.c), which
is power on at default.
Then the flag phydev->supported is changed to 0x6f, so Fiber Port power is
off when removing hns modules.
When hns modules installed again, the flag phydev->supported is default
value 0x6ff, so will not change Fiber Port power(now is off), causing mac
link not up problem.

So the solution is change phy flags before phy_connect_direct.

Fixes: 308c6cafde01 ("net: hns: All ports can not work when insmod hns ko after rmmod.")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index d30c28fba249..7f14f06e868a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1269,6 +1269,12 @@ int hns_nic_init_phy(struct net_device *ndev, struct hnae_handle *h)
 	if (!h->phy_dev)
 		return 0;
 
+	phy_dev->supported &= h->if_support;
+	phy_dev->advertising = phy_dev->supported;
+
+	if (h->phy_if == PHY_INTERFACE_MODE_XGMII)
+		phy_dev->autoneg = false;
+
 	if (h->phy_if != PHY_INTERFACE_MODE_XGMII) {
 		phy_dev->dev_flags = 0;
 
@@ -1280,15 +1286,6 @@ int hns_nic_init_phy(struct net_device *ndev, struct hnae_handle *h)
 	if (unlikely(ret))
 		return -ENODEV;
 
-	phy_dev->supported &= h->if_support;
-	phy_dev->advertising = phy_dev->supported;
-
-	if (h->phy_if == PHY_INTERFACE_MODE_XGMII)
-		phy_dev->autoneg = false;
-
-	if (h->phy_if == PHY_INTERFACE_MODE_SGMII)
-		phy_stop(phy_dev);
-
 	return 0;
 }
 
-- 
2.20.1

