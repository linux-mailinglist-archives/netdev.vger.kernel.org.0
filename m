Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57005435732
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhJUAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232112AbhJUAYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B93E61057;
        Thu, 21 Oct 2021 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775738;
        bh=1Ak5FV3owk5mFqvsftkNia8D5DWbjl4oJ+vAtNG0OJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pt4ELQiA1/Fe7+tK6MFlqFqnW9c2uLwPohQLs4S7voEpwk/JqfL4NMkbixHoJn5uY
         LruxGGd9BZPxE620Hxc6owy1g+BK3N2BVTHwsCgKs8+HVRematQWxIHi1xiO8RiMkR
         pLL/cbMOplHyZDyAEIruI8sIa3AQO7p3X8oOGfFu1Ty16ieVfIzyc+elZRGAfb57W1
         N60nAfEkTwc7MCcwLP9ezlPfc5D22Jpw5UYIT3yhOgBbbuE3bq1sTEtn+O1Yk5ZZgx
         aRC7vTHhLkjiS8JWlJh1IHgU3gjvQIKaBkO4mR968bcQACtXVQmXPCFsmLEPVN+y6B
         eYK6NN0EpGZlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/14] isdn: cpai: check ctr->cnr to avoid array index out of bound
Date:   Wed, 20 Oct 2021 20:21:48 -0400
Message-Id: <20211021002155.1129292-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002155.1129292-1-sashal@kernel.org>
References: <20211021002155.1129292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

[ Upstream commit 1f3e2e97c003f80c4b087092b225c8787ff91e4d ]

The cmtp_add_connection() would add a cmtp session to a controller
and run a kernel thread to process cmtp.

	__module_get(THIS_MODULE);
	session->task = kthread_run(cmtp_session, session, "kcmtpd_ctr_%d",
								session->num);

During this process, the kernel thread would call detach_capi_ctr()
to detach a register controller. if the controller
was not attached yet, detach_capi_ctr() would
trigger an array-index-out-bounds bug.

[   46.866069][ T6479] UBSAN: array-index-out-of-bounds in
drivers/isdn/capi/kcapi.c:483:21
[   46.867196][ T6479] index -1 is out of range for type 'capi_ctr *[32]'
[   46.867982][ T6479] CPU: 1 PID: 6479 Comm: kcmtpd_ctr_0 Not tainted
5.15.0-rc2+ #8
[   46.869002][ T6479] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.14.0-2 04/01/2014
[   46.870107][ T6479] Call Trace:
[   46.870473][ T6479]  dump_stack_lvl+0x57/0x7d
[   46.870974][ T6479]  ubsan_epilogue+0x5/0x40
[   46.871458][ T6479]  __ubsan_handle_out_of_bounds.cold+0x43/0x48
[   46.872135][ T6479]  detach_capi_ctr+0x64/0xc0
[   46.872639][ T6479]  cmtp_session+0x5c8/0x5d0
[   46.873131][ T6479]  ? __init_waitqueue_head+0x60/0x60
[   46.873712][ T6479]  ? cmtp_add_msgpart+0x120/0x120
[   46.874256][ T6479]  kthread+0x147/0x170
[   46.874709][ T6479]  ? set_kthread_struct+0x40/0x40
[   46.875248][ T6479]  ret_from_fork+0x1f/0x30
[   46.875773][ T6479]

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211008065830.305057-1-butterflyhuangxx@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/capi/kcapi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index cb0afe897162..7313454e403a 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -480,6 +480,11 @@ int detach_capi_ctr(struct capi_ctr *ctr)
 
 	ctr_down(ctr, CAPI_CTR_DETACHED);
 
+	if (ctr->cnr < 1 || ctr->cnr - 1 >= CAPI_MAXCONTR) {
+		err = -EINVAL;
+		goto unlock_out;
+	}
+
 	if (capi_controller[ctr->cnr - 1] != ctr) {
 		err = -EINVAL;
 		goto unlock_out;
-- 
2.33.0

