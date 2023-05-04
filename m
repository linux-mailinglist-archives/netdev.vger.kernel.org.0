Return-Path: <netdev+bounces-387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5906F7581
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88D1E280F50
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B565C1097A;
	Thu,  4 May 2023 19:46:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61210961
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D910C433A4;
	Thu,  4 May 2023 19:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229565;
	bh=xU5+GS7Z0ZOvuzry9gq4roNZWabzqWYxzl3qKvzYpew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwXn1xyjBbrzpWZzkeqWrU1e2NtZ2DUlZ1nB/aWbgt7AAlow9IHC8y28Vnt6H1Vuw
	 jEZbHKxZcyIB8hgEqqTxZhR67LSEqo2yYoWHg72/iBd4MQumYyhhtOsLKYTj0OIS/D
	 yj7lq2919LtCuLQ28uU4vJMxNXBIVMtw4KqWcORwpABCK2sQfHio1Neu8aN5rBH9/h
	 EtEBPpqgi14Iouk05ME4pBZaePPsB7DX/Wo3BGatMhaUdO3+bS1KiKMLYmi9ZYOWn+
	 U+cUCT9mN3SFLAvJDgJGgprlrVx/m8VuxovWicziEv3BIPfBb27GN6gFsnBBd8OAOu
	 zTiDEc5k0aG9A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tony0620emma@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 41/53] wifi: rtw88: Fix memory leak in rtw88_usb
Date: Thu,  4 May 2023 15:44:01 -0400
Message-Id: <20230504194413.3806354-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194413.3806354-1-sashal@kernel.org>
References: <20230504194413.3806354-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 59a3a312009723e3e5082899655fdcc420e2b47a ]

Kmemleak shows the following leak arising from routine in the usb
probe routine:

unreferenced object 0xffff895cb29bba00 (size 512):
  comm "(udev-worker)", pid 534, jiffies 4294903932 (age 102751.088s)
  hex dump (first 32 bytes):
    77 30 30 30 00 00 00 00 02 2f 2d 2b 30 00 00 00  w000...../-+0...
    02 00 2a 28 00 00 00 00 ff 55 ff ff ff 00 00 00  ..*(.....U......
  backtrace:
    [<ffffffff9265fa36>] kmalloc_trace+0x26/0x90
    [<ffffffffc17eec41>] rtw_usb_probe+0x2f1/0x680 [rtw_usb]
    [<ffffffffc03e19fd>] usb_probe_interface+0xdd/0x2e0 [usbcore]
    [<ffffffff92b4f2fe>] really_probe+0x18e/0x3d0
    [<ffffffff92b4f5b8>] __driver_probe_device+0x78/0x160
    [<ffffffff92b4f6bf>] driver_probe_device+0x1f/0x90
    [<ffffffff92b4f8df>] __driver_attach+0xbf/0x1b0
    [<ffffffff92b4d350>] bus_for_each_dev+0x70/0xc0
    [<ffffffff92b4e51e>] bus_add_driver+0x10e/0x210
    [<ffffffff92b50935>] driver_register+0x55/0xf0
    [<ffffffffc03e0708>] usb_register_driver+0x88/0x140 [usbcore]
    [<ffffffff92401153>] do_one_initcall+0x43/0x210
    [<ffffffff9254f42a>] do_init_module+0x4a/0x200
    [<ffffffff92551d1c>] __do_sys_finit_module+0xac/0x120
    [<ffffffff92ee6626>] do_syscall_64+0x56/0x80
    [<ffffffff9300006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

The leak was verified to be real by unloading the driver, which resulted
in a dangling pointer to the allocation.

The allocated memory is freed in rtw_usb_intf_deinit().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230417160331.23071-1-Larry.Finger@lwfinger.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 68e1b782d1992..05c7326443614 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -780,6 +780,7 @@ static void rtw_usb_intf_deinit(struct rtw_dev *rtwdev,
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 
 	usb_put_dev(rtwusb->udev);
+	kfree(rtwusb->usb_data);
 	usb_set_intfdata(intf, NULL);
 }
 
-- 
2.39.2


