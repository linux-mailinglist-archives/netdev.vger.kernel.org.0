Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3FF271480
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 15:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgITN0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 09:26:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:35464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbgITN0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 09:26:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 14C63ABAD;
        Sun, 20 Sep 2020 13:26:59 +0000 (UTC)
From:   =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc:     Chin-Yen Lee <timlee@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-realtek-soc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 1/2] rtw88: Fix probe error handling race with firmware loading
Date:   Sun, 20 Sep 2020 15:26:20 +0200
Message-Id: <20200920132621.26468-2-afaerber@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200920132621.26468-1-afaerber@suse.de>
References: <20200920132621.26468-1-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of rtw8822be, a probe failure after successful rtw_core_init()
has been observed to occasionally lead to an oops from rtw_load_firmware_cb():

[    3.924268] pci 0001:01:00.0: [10ec:b822] type 00 class 0xff0000
[    3.930531] pci 0001:01:00.0: reg 0x10: [io  0x0000-0x00ff]
[    3.936360] pci 0001:01:00.0: reg 0x18: [mem 0x00000000-0x0000ffff 64bit]
[    3.944042] pci 0001:01:00.0: supports D1 D2
[    3.948438] pci 0001:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.957312] pci 0001:01:00.0: BAR 2: no space for [mem size 0x00010000 64bit]
[    3.964645] pci 0001:01:00.0: BAR 2: failed to assign [mem size 0x00010000 64bit]
[    3.972332] pci 0001:01:00.0: BAR 0: assigned [io  0x10000-0x100ff]
[    3.986240] rtw_8822be 0001:01:00.0: enabling device (0000 -> 0001)
[    3.992735] rtw_8822be 0001:01:00.0: failed to map pci memory
[    3.998638] rtw_8822be 0001:01:00.0: failed to request pci io region
[    4.005166] rtw_8822be 0001:01:00.0: failed to setup pci resources
[    4.011580] rtw_8822be: probe of 0001:01:00.0 failed with error -12
[    4.018827] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[    4.029121] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    4.050828] Unable to handle kernel paging request at virtual address edafeaac9607952c
[    4.058975] Mem abort info:
[    4.058980]   ESR = 0x96000004
[    4.058990]   EC = 0x25: DABT (current EL), IL = 32 bits
[    4.070353]   SET = 0, FnV = 0
[    4.073487]   EA = 0, S1PTW = 0
[    4.073501] dw-apb-uart 98007800.serial: forbid DMA for kernel console
[    4.076723] Data abort info:
[    4.086415]   ISV = 0, ISS = 0x00000004
[    4.087731] Freeing unused kernel memory: 1792K
[    4.090391]   CM = 0, WnR = 0
[    4.098091] [edafeaac9607952c] address between user and kernel address ranges
[    4.105418] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    4.111129] Modules linked in:
[    4.114275] CPU: 1 PID: 31 Comm: kworker/1:1 Not tainted 5.9.0-rc5-next-20200915+ #700
[    4.122386] Hardware name: Realtek Saola EVB (DT)
[    4.127223] Workqueue: events request_firmware_work_func
[    4.132676] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    4.138393] pc : rtw_load_firmware_cb+0x54/0xbc
[    4.143040] lr : request_firmware_work_func+0x44/0xb4
[    4.148217] sp : ffff800010133d70
[    4.151616] x29: ffff800010133d70 x28: 0000000000000000
[    4.157069] x27: 0000000000000000 x26: 0000000000000000
[    4.162520] x25: 0000000000000000 x24: 0000000000000000
[    4.167971] x23: ffff00007ac21908 x22: ffff00007ebb2100
[    4.173424] x21: ffff00007ad35880 x20: edafeaac96079504
[    4.178877] x19: ffff00007ad35870 x18: 0000000000000000
[    4.184328] x17: 00000000000044d8 x16: 0000000000004310
[    4.189780] x15: 0000000000000800 x14: 00000000ef006305
[    4.195231] x13: ffffffff00000000 x12: ffffffffffffffff
[    4.200682] x11: 0000000000000020 x10: 0000000000000003
[    4.206135] x9 : 0000000000000000 x8 : ffff00007e73f680
[    4.211585] x7 : 0000000000000000 x6 : ffff80001119b588
[    4.217036] x5 : ffff00007e649c80 x4 : ffff00007e649c80
[    4.222487] x3 : ffff80001119b588 x2 : ffff8000108d1718
[    4.227940] x1 : ffff800011bd5000 x0 : ffff00007ac21600
[    4.233391] Call trace:
[    4.235906]  rtw_load_firmware_cb+0x54/0xbc
[    4.240198]  request_firmware_work_func+0x44/0xb4
[    4.245027]  process_one_work+0x178/0x1e4
[    4.249142]  worker_thread+0x1d0/0x268
[    4.252989]  kthread+0xe8/0xf8
[    4.256127]  ret_from_fork+0x10/0x18
[    4.259800] Code: f94013f5 a8c37bfd d65f03c0 f9000260 (f9401681)
[    4.266049] ---[ end trace f822ebae1a8545c2 ]---

To avoid this, wait on the completion callbacks in rtw_core_deinit()
before releasing firmware and continuing teardown.

Note that rtw_wait_firmware_completion() was introduced with
c8e5695eae9959fc5774c0f490f2450be8bad3de ("rtw88: load wowlan firmware
if wowlan is supported"), so backports to earlier branches may need to
inline wait_for_completion(&rtwdev->fw.completion) instead.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Fixes: c8e5695eae99 ("rtw88: load wowlan firmware if wowlan is supported")
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 drivers/net/wireless/realtek/rtw88/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 9770982b2f14..dc48ec4b0a31 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1486,6 +1486,8 @@ void rtw_core_deinit(struct rtw_dev *rtwdev)
 	struct rtw_rsvd_page *rsvd_pkt, *tmp;
 	unsigned long flags;
 
+	rtw_wait_firmware_completion(rtwdev);
+
 	if (fw->firmware)
 		release_firmware(fw->firmware);
 
-- 
2.28.0

