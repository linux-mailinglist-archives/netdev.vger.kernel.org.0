Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6331ECEA3
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 13:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgFCLlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 07:41:49 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:44950 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFCLlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 07:41:49 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2020 07:41:47 EDT
Received: from iota-build.ysoft.local (unknown [10.1.5.151])
        by uho.ysoft.cz (Postfix) with ESMTP id CCC01A049E;
        Wed,  3 Jun 2020 13:31:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1591183914;
        bh=V5QNjV3HBqRkRY7vTGnb2qSQq5tZGtqOrS/+6XsIqto=;
        h=From:To:Cc:Subject:Date:From;
        b=MHTeeHrIuvRI/7zWYgFLuBelsDB7f1T1PstpmOkqcCE9d4l0SacVK6YLNKvN80eX4
         zoRlkpJBnVyjlwAessVQKU1W/e+BN8maQIphWZA0k1IcN81FHw4gR/0UUtkwp1Dh3z
         qI0laoN8BXkTUMNVtdDqaT0g3nm5NmysKbMDmfCQ=
From:   =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        <stable@vger.kernel.org>
Subject: [PATCH net] net: dsa: qca8k: Fix "Unexpected gfp" kernel exception
Date:   Wed,  3 Jun 2020 13:31:39 +0200
Message-Id: <1591183899-24987-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
replaced the dsa_switch_alloc helper by devm_kzalloc in all DSA
drivers. Unfortunately it introduced a typo in qca8k.c driver and
wrong argument is passed to the devm_kzalloc function.

This fix mitigates the following kernel exception:

  Unexpected gfp: 0x6 (__GFP_HIGHMEM|GFP_DMA32). Fixing up to gfp: 0x101 (GFP_DMA|__GFP_ZERO). Fix your code!
  CPU: 1 PID: 44 Comm: kworker/1:1 Not tainted 5.5.9-yocto-ua #1
  Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
  Workqueue: events deferred_probe_work_func
  [<c0014924>] (unwind_backtrace) from [<c00123bc>] (show_stack+0x10/0x14)
  [<c00123bc>] (show_stack) from [<c04c8fb4>] (dump_stack+0x90/0xa4)
  [<c04c8fb4>] (dump_stack) from [<c00e1b10>] (new_slab+0x20c/0x214)
  [<c00e1b10>] (new_slab) from [<c00e1cd0>] (___slab_alloc.constprop.0+0x1b8/0x540)
  [<c00e1cd0>] (___slab_alloc.constprop.0) from [<c00e2074>] (__slab_alloc.constprop.0+0x1c/0x24)
  [<c00e2074>] (__slab_alloc.constprop.0) from [<c00e4538>] (__kmalloc_track_caller+0x1b0/0x298)
  [<c00e4538>] (__kmalloc_track_caller) from [<c02cccac>] (devm_kmalloc+0x24/0x70)
  [<c02cccac>] (devm_kmalloc) from [<c030d888>] (qca8k_sw_probe+0x94/0x1ac)
  [<c030d888>] (qca8k_sw_probe) from [<c0304788>] (mdio_probe+0x30/0x54)
  [<c0304788>] (mdio_probe) from [<c02c93bc>] (really_probe+0x1e0/0x348)
  [<c02c93bc>] (really_probe) from [<c02c9884>] (driver_probe_device+0x60/0x16c)
  [<c02c9884>] (driver_probe_device) from [<c02c7fb0>] (bus_for_each_drv+0x70/0x94)
  [<c02c7fb0>] (bus_for_each_drv) from [<c02c9708>] (__device_attach+0xb4/0x11c)
  [<c02c9708>] (__device_attach) from [<c02c8148>] (bus_probe_device+0x84/0x8c)
  [<c02c8148>] (bus_probe_device) from [<c02c8cec>] (deferred_probe_work_func+0x64/0x90)
  [<c02c8cec>] (deferred_probe_work_func) from [<c0033c14>] (process_one_work+0x1d4/0x41c)
  [<c0033c14>] (process_one_work) from [<c00340a4>] (worker_thread+0x248/0x528)
  [<c00340a4>] (worker_thread) from [<c0039148>] (kthread+0x124/0x150)
  [<c0039148>] (kthread) from [<c00090d8>] (ret_from_fork+0x14/0x3c)
  Exception stack(0xee1b5fb0 to 0xee1b5ff8)
  5fa0:                                     00000000 00000000 00000000 00000000
  5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
  5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
  qca8k 2188000.ethernet-1:0a: Using legacy PHYLIB callbacks. Please migrate to PHYLINK!
  qca8k 2188000.ethernet-1:0a eth2 (uninitialized): PHY [2188000.ethernet-1:01] driver [Generic PHY]
  qca8k 2188000.ethernet-1:0a eth1 (uninitialized): PHY [2188000.ethernet-1:02] driver [Generic PHY]

Fixes: 7e99e3470172 ("net: dsa: remove dsa_switch_alloc helper")
Cc: <stable@vger.kernel.org>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
---
 drivers/net/dsa/qca8k.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9f4205b4439b..d2b5ab403e06 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1079,8 +1079,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (id != QCA8K_ID_QCA8337)
 		return -ENODEV;
 
-	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds),
-				QCA8K_NUM_PORTS);
+	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
 
-- 
2.1.4

