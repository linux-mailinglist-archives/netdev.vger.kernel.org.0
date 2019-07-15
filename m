Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC669756
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbfGON4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732313AbfGON4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:56:13 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D16420C01;
        Mon, 15 Jul 2019 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198972;
        bh=A/XpATUw5mCYjSAZ+Cg8opTeNa6c0gK1Fk1eGEFeR5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5fqqcP1VnSYsLMhTp393nIH9CPipiQTOHP7PjW4uNMorrqIvj69kbhhoQjKgCsuL
         bnZqT08sSNwhBfOqBxXkRIGHraLVraJauOLW1PudkTNoNTPUC7Ee8Euw/aws6j5aaS
         W2m4jXmwWAyiLgtGK5WU2xLi0MBAbcPIjDhiG5mw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 157/249] rtlwifi: rtl8192cu: fix error handle when usb probe failed
Date:   Mon, 15 Jul 2019 09:45:22 -0400
Message-Id: <20190715134655.4076-157-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 6c0ed66f1a5b84e2a812c7c2d6571a5621bf3396 ]

rtl_usb_probe() must do error handle rtl_deinit_core() only if
rtl_init_core() is done, otherwise goto error_out2.

| usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
| rtl_usb: reg 0xf0, usbctrl_vendorreq TimeOut! status:0xffffffb9 value=0x0
| rtl8192cu: Chip version 0x10
| rtl_usb: reg 0xa, usbctrl_vendorreq TimeOut! status:0xffffffb9 value=0x0
| rtl_usb: Too few input end points found
| INFO: trying to register non-static key.
| the code is fine but needs lockdep annotation.
| turning off the locking correctness validator.
| CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4-319354-g9a33b36 #3
| Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
| Google 01/01/2011
| Workqueue: usb_hub_wq hub_event
| Call Trace:
|   __dump_stack lib/dump_stack.c:77 [inline]
|   dump_stack+0xe8/0x16e lib/dump_stack.c:113
|   assign_lock_key kernel/locking/lockdep.c:786 [inline]
|   register_lock_class+0x11b8/0x1250 kernel/locking/lockdep.c:1095
|   __lock_acquire+0xfb/0x37c0 kernel/locking/lockdep.c:3582
|   lock_acquire+0x10d/0x2f0 kernel/locking/lockdep.c:4211
|   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
|   _raw_spin_lock_irqsave+0x44/0x60 kernel/locking/spinlock.c:152
|   rtl_c2hcmd_launcher+0xd1/0x390
| drivers/net/wireless/realtek/rtlwifi/base.c:2344
|   rtl_deinit_core+0x25/0x2d0 drivers/net/wireless/realtek/rtlwifi/base.c:574
|   rtl_usb_probe.cold+0x861/0xa70
| drivers/net/wireless/realtek/rtlwifi/usb.c:1093
|   usb_probe_interface+0x31d/0x820 drivers/usb/core/driver.c:361
|   really_probe+0x2da/0xb10 drivers/base/dd.c:509
|   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
|   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
|   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
|   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
|   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
|   device_add+0xad2/0x16e0 drivers/base/core.c:2106
|   usb_set_configuration+0xdf7/0x1740 drivers/usb/core/message.c:2021
|   generic_probe+0xa2/0xda drivers/usb/core/generic.c:210
|   usb_probe_device+0xc0/0x150 drivers/usb/core/driver.c:266
|   really_probe+0x2da/0xb10 drivers/base/dd.c:509
|   driver_probe_device+0x21d/0x350 drivers/base/dd.c:671
|   __device_attach_driver+0x1d8/0x290 drivers/base/dd.c:778
|   bus_for_each_drv+0x163/0x1e0 drivers/base/bus.c:454
|   __device_attach+0x223/0x3a0 drivers/base/dd.c:844
|   bus_probe_device+0x1f1/0x2a0 drivers/base/bus.c:514
|   device_add+0xad2/0x16e0 drivers/base/core.c:2106
|   usb_new_device.cold+0x537/0xccf drivers/usb/core/hub.c:2534
|   hub_port_connect drivers/usb/core/hub.c:5089 [inline]
|   hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
|   port_event drivers/usb/core/hub.c:5350 [inline]
|   hub_event+0x138e/0x3b00 drivers/usb/core/hub.c:5432
|   process_one_work+0x90f/0x1580 kernel/workqueue.c:2269
|   worker_thread+0x9b/0xe20 kernel/workqueue.c:2415
|   kthread+0x313/0x420 kernel/kthread.c:253
|   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Reported-by: syzbot+1fcc5ef45175fc774231@syzkaller.appspotmail.com
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index e24fda5e9087..34d68dbf4b4c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1064,13 +1064,13 @@ int rtl_usb_probe(struct usb_interface *intf,
 	rtlpriv->cfg->ops->read_eeprom_info(hw);
 	err = _rtl_usb_init(hw);
 	if (err)
-		goto error_out;
+		goto error_out2;
 	rtl_usb_init_sw(hw);
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
 		pr_err("Can't allocate sw for mac80211\n");
-		goto error_out;
+		goto error_out2;
 	}
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
 		pr_err("Can't init_sw_vars\n");
@@ -1091,6 +1091,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 
 error_out:
 	rtl_deinit_core(hw);
+error_out2:
 	_rtl_usb_io_handler_release(hw);
 	usb_put_dev(udev);
 	complete(&rtlpriv->firmware_loading_complete);
-- 
2.20.1

