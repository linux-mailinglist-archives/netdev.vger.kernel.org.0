Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE672F313D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbhALM5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388706AbhALM47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:56:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 018602311F;
        Tue, 12 Jan 2021 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456144;
        bh=697ysmwKoKRSvCrwtszXFk25QAtHZknzwmmQ92IkpXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s72kCF9aH9Z4eXIdKdmgg256FRJPcYekuIpodTUIZDK55OAD+R6pmblKkP47FdPjC
         u3cz820O6NQGWjvJP23vz6RhExmtXH1UNYfeeEqRQG4S54kgjqFiSsirCc65u927EY
         8uw8UaLYw6pMktAKHjxbsDuq7DEgXpNSNvwpFz6EcyOi39MT4Pis4j8MzJHtno58Fm
         68W5WyoP5xROSd9KJZKwwf6j/J7kOjhGpv3O5NuW8l1iXB8vNHsC6bUd6K0H6/qE4w
         4CSW8jd2xnq6RhNBeih4rB6gumoJ/EmHZ3cHaaiPx9eDdTwoGL8jdgoPnTLUIyt3S9
         iaufdH9I6G8zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        syzbot+65be4277f3c489293939@syzkaller.appspotmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/51] rtlwifi: rise completion at the last step of firmware callback
Date:   Tue, 12 Jan 2021 07:54:49 -0500
Message-Id: <20210112125534.70280-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 4dfde294b9792dcf8615b55c58f093d544f472f0 ]

request_firmware_nowait() which schedules another work is used to load
firmware when USB is probing. If USB is unplugged before running the
firmware work, it goes disconnect ops, and then causes use-after-free.
Though we wait for completion of firmware work before freeing the hw,
firmware callback rises completion too early. So I move it to the
last step.

usb 5-1: Direct firmware load for rtlwifi/rtl8192cufw.bin failed with error -2
rtlwifi: Loading alternative firmware rtlwifi/rtl8192cufw.bin
rtlwifi: Selected firmware is not available
==================================================================
BUG: KASAN: use-after-free in rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
Write of size 4 at addr ffff8881454cff50 by task kworker/0:6/7379

CPU: 0 PID: 7379 Comm: kworker/0:6 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 rtl_fw_do_work.cold+0x68/0x6a drivers/net/wireless/realtek/rtlwifi/core.c:93
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1079
 process_one_work+0x933/0x1520 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the page:
page:00000000f54435b3 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1454cf
flags: 0x200000000000000()
raw: 0200000000000000 0000000000000000 ffffea00051533c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881454cfe00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881454cfe80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8881454cff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                 ^
 ffff8881454cff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8881454d0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Reported-by: syzbot+65be4277f3c489293939@syzkaller.appspotmail.com
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214053106.7748-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index a7259dbc953da..965bd95890459 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -78,7 +78,6 @@ static void rtl_fw_do_work(const struct firmware *firmware, void *context,
 
 	rtl_dbg(rtlpriv, COMP_ERR, DBG_LOUD,
 		"Firmware callback routine entered!\n");
-	complete(&rtlpriv->firmware_loading_complete);
 	if (!firmware) {
 		if (rtlpriv->cfg->alt_fw_name) {
 			err = request_firmware(&firmware,
@@ -91,13 +90,13 @@ static void rtl_fw_do_work(const struct firmware *firmware, void *context,
 		}
 		pr_err("Selected firmware is not available\n");
 		rtlpriv->max_fw_size = 0;
-		return;
+		goto exit;
 	}
 found_alt:
 	if (firmware->size > rtlpriv->max_fw_size) {
 		pr_err("Firmware is too big!\n");
 		release_firmware(firmware);
-		return;
+		goto exit;
 	}
 	if (!is_wow) {
 		memcpy(rtlpriv->rtlhal.pfirmware, firmware->data,
@@ -109,6 +108,9 @@ static void rtl_fw_do_work(const struct firmware *firmware, void *context,
 		rtlpriv->rtlhal.wowlan_fwsize = firmware->size;
 	}
 	release_firmware(firmware);
+
+exit:
+	complete(&rtlpriv->firmware_loading_complete);
 }
 
 void rtl_fw_cb(const struct firmware *firmware, void *context)
-- 
2.27.0

