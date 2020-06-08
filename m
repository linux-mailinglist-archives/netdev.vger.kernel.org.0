Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AD41F26A8
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbgFHX1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732147AbgFHX1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:27:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A55892068D;
        Mon,  8 Jun 2020 23:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658863;
        bh=YGuNbxnOFdGZn9xhW1g0YbhvMFNUM6o6VtQi5BCwJ9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvZset2ucH6KBJDK17lX02b3sF9IGcHf49WHUElnsN5paw5/g61TPO5Cny5BBKjOT
         CX+poo3XretIEvFZGBvfPvTtZsW30TGg+g4GvNVSor4qAN0RKYfvdVzbrtmPRGd6O8
         x/uwy1WfCqPOA4ERwL2HMp784SOgwQ3UkXANCM/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie XiuQi <xiexiuqi@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 46/50] ixgbe: fix signed-integer-overflow warning
Date:   Mon,  8 Jun 2020 19:26:36 -0400
Message-Id: <20200608232640.3370262-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232640.3370262-1-sashal@kernel.org>
References: <20200608232640.3370262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie XiuQi <xiexiuqi@huawei.com>

[ Upstream commit 3b70683fc4d68f5d915d9dc7e5ba72c732c7315c ]

ubsan report this warning, fix it by adding a unsigned suffix.

UBSAN: signed-integer-overflow in
drivers/net/ethernet/intel/ixgbe/ixgbe_common.c:2246:26
65535 * 65537 cannot be represented in type 'int'
CPU: 21 PID: 7 Comm: kworker/u256:0 Not tainted 5.7.0-rc3-debug+ #39
Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 03/27/2020
Workqueue: ixgbe ixgbe_service_task [ixgbe]
Call trace:
 dump_backtrace+0x0/0x3f0
 show_stack+0x28/0x38
 dump_stack+0x154/0x1e4
 ubsan_epilogue+0x18/0x60
 handle_overflow+0xf8/0x148
 __ubsan_handle_mul_overflow+0x34/0x48
 ixgbe_fc_enable_generic+0x4d0/0x590 [ixgbe]
 ixgbe_service_task+0xc20/0x1f78 [ixgbe]
 process_one_work+0x8f0/0xf18
 worker_thread+0x430/0x6d0
 kthread+0x218/0x238
 ret_from_fork+0x10/0x18

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 0d2baec546e1..c17135b7fca7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -2219,7 +2219,7 @@ s32 ixgbe_fc_enable_generic(struct ixgbe_hw *hw)
 	}
 
 	/* Configure pause time (2 TCs per register) */
-	reg = hw->fc.pause_time * 0x00010001;
+	reg = hw->fc.pause_time * 0x00010001U;
 	for (i = 0; i < (MAX_TRAFFIC_CLASS / 2); i++)
 		IXGBE_WRITE_REG(hw, IXGBE_FCTTV(i), reg);
 
-- 
2.25.1

