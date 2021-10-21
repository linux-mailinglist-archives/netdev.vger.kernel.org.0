Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAAA4357AD
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhJUA1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhJUA02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BABF861284;
        Thu, 21 Oct 2021 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775853;
        bh=STXFYYl2lukrB8OSESFAQCreCYajWmAtbuq2DQZsr2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQg9OvMslUBAGtrW3SzfJiJvt0JscsHlQ1FM9elhxBN538VptkpbgB/qIicG4SgFU
         V8XNc1nhj93xLYwCn8CVFutwN/Cr737b2YKfkZO1KaurYvKqPp/eI+s3WCBGaGZDvM
         X7OsCUbVgfnmXb3EalGllSnkymwlyuPWzSGtx/zqUhsOm6eyEJjTwnZJBVUVg7mFTu
         CQNJmW7iu5V8cH660OZTvkdFYgst27eKH4OPhaoysKoaobRLACU1o7Gr8UaZveJsuw
         DjKbD++1xjS2lWGbhUW85LVB3sBzZh1f99ndXRX5mejgNf41BJgrcHmZJivyUAuNMs
         hTq7kA36TZPqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/7] isdn: cpai: check ctr->cnr to avoid array index out of bound
Date:   Wed, 20 Oct 2021 20:23:59 -0400
Message-Id: <20211021002404.1129946-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002404.1129946-1-sashal@kernel.org>
References: <20211021002404.1129946-1-sashal@kernel.org>
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
index 9de62c3b8bf9..658e116d8fe6 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -564,6 +564,11 @@ int detach_capi_ctr(struct capi_ctr *ctr)
 
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

