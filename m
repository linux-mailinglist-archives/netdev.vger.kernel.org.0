Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4CD77B0
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbfJONtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 09:49:24 -0400
Received: from foss.arm.com ([217.140.110.172]:39132 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732106AbfJONtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 09:49:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F34641576;
        Tue, 15 Oct 2019 06:49:21 -0700 (PDT)
Received: from eglon.cambridge.arm.com (unknown [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 690AD3F718;
        Tue, 15 Oct 2019 06:49:21 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     netdev@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        "Dave S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH net 2/2] amd-xgbe: Avoid sleeping in napi_disable() while holding a spinlock
Date:   Tue, 15 Oct 2019 14:49:11 +0100
Message-Id: <20191015134911.231121-3-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015134911.231121-1-james.morse@arm.com>
References: <20191015134911.231121-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xgbe_powerdown() takes an irqsave spinlock, then calls napi_disable()
via xgbe_napi_disable(). napi_disable() might call msleep().
DEBUG_ATOMIC_SLEEP isn't happy about this:
| BUG: sleeping function called from invalid context at ../net/core/dev.c:6332
| in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 2831, name: bash
| CPU: 3 PID: 2831 Comm: bash Tainted: G        W         5.4.0-rc3-00001-g9dbe793f263b #114
| Hardware name: AMD Seattle (Rev.B0) Development Board (Overdrive) (DT)
| Call trace:
|  dump_backtrace+0x0/0x160
|  show_stack+0x24/0x30
|  dump_stack+0xb0/0xf8
|  ___might_sleep+0x124/0x148
|  __might_sleep+0x54/0x90
|  napi_disable+0x48/0x140
|  xgbe_napi_disable+0x64/0xc0
|  xgbe_powerdown+0xb0/0x120
|  xgbe_platform_suspend+0x34/0x80
|  pm_generic_freeze+0x3c/0x58
|  acpi_subsys_freeze+0x2c/0x38
|  dpm_run_callback+0x3c/0x1e8
|  __device_suspend+0x130/0x468
|  dpm_suspend+0x114/0x388
|  hibernation_snapshot+0xe8/0x378
|  hibernate+0x18c/0x2f8

Move xgbe_napi_disable() outside the spin_lock()d region of
xgbe_powerdown(). This matches its use in xgbe_stop() ... but this
might only be safe because of the earlier call to xgbe_free_irqs().

Signed-off-by: James Morse <james.morse@arm.com>

---
RFC as I'm not familiar with this driver. I'm happy to test a better fix!
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index bfba7effcf9f..a6e6c21e921f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1278,10 +1278,10 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 	hw_if->powerdown_tx(pdata);
 	hw_if->powerdown_rx(pdata);
 
-	xgbe_napi_disable(pdata, 0);
-
 	spin_unlock_irqrestore(&pdata->lock, flags);
 
+	xgbe_napi_disable(pdata, 0);
+
 	DBGPR("<--xgbe_powerdown\n");
 
 	return 0;
-- 
2.20.1

