Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB71E1C74
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbfJWNZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:25:30 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39095 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730296AbfJWNZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 09:25:30 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9NDPMJ6022722, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9NDPMJ6022722
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Oct 2019 21:25:23 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCAS11.realtek.com.tw
 (172.21.6.12) with Microsoft SMTP Server id 14.3.468.0; Wed, 23 Oct 2019
 21:25:21 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <pmalani@chromium.org>, <grundler@chromium.org>,
        <nic_swsd@realtek.com>, Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH net-next] r8152: check the pointer rtl_fw->fw before using it
Date:   Wed, 23 Oct 2019 21:24:44 +0800
Message-ID: <1394712342-15778-336-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the pointer rtl_fw->fw would be used before checking in
rtl8152_apply_firmware() that causes the following kernel oops.

Unable to handle kernel NULL pointer dereference at virtual address 00000002
pgd = (ptrval)
[00000002] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0 PID: 131 Comm: kworker/0:2 Not tainted
5.4.0-rc1-00539-g9370f2d05a2a #6788
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
Workqueue: events_long rtl_hw_phy_work_func_t
PC is at rtl8152_apply_firmware+0x14/0x464
LR is at r8153_hw_phy_cfg+0x24/0x17c
pc : [<c064f4e4>]    lr : [<c064fa18>]    psr: a0000013
sp : e75c9e60  ip : 60000013  fp : c11b7614
r10: e883b91c  r9 : 00000000  r8 : fffffffe
r7 : e883b640  r6 : fffffffe  r5 : fffffffe  r4 : e883b640
r3 : 736cfe7c  r2 : 736cfe7c  r1 : 000052f8  r0 : e883b640
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 6640006a  DAC: 00000051
Process kworker/0:2 (pid: 131, stack limit = 0x(ptrval))
Stack: (0xe75c9e60 to 0xe75ca000)
...
[<c064f4e4>] (rtl8152_apply_firmware) from [<c064fa18>]
(r8153_hw_phy_cfg+0x24/0x17c)
[<c064fa18>] (r8153_hw_phy_cfg) from [<c064e784>]
(rtl_hw_phy_work_func_t+0x220/0x3e4)
[<c064e784>] (rtl_hw_phy_work_func_t) from [<c0148a74>]
(process_one_work+0x22c/0x7c8)
[<c0148a74>] (process_one_work) from [<c0149054>] (worker_thread+0x44/0x520)
[<c0149054>] (worker_thread) from [<c0150548>] (kthread+0x130/0x164)
[<c0150548>] (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xe75c9fb0 to 0xe75c9ff8)
...

Fixes: 9370f2d05a2a ("r8152: support request_firmware for RTL8153")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d3c30ccc8577..283b35a76cf0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4000,8 +4000,8 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
 static void rtl8152_apply_firmware(struct r8152 *tp)
 {
 	struct rtl_fw *rtl_fw = &tp->rtl_fw;
-	const struct firmware *fw = rtl_fw->fw;
-	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
+	const struct firmware *fw;
+	struct fw_header *fw_hdr;
 	struct fw_phy_patch_key *key;
 	u16 key_addr = 0;
 	int i;
@@ -4009,6 +4009,9 @@ static void rtl8152_apply_firmware(struct r8152 *tp)
 	if (IS_ERR_OR_NULL(rtl_fw->fw))
 		return;
 
+	fw = rtl_fw->fw;
+	fw_hdr = (struct fw_header *)fw->data;
+
 	if (rtl_fw->pre_fw)
 		rtl_fw->pre_fw(tp);
 
-- 
2.21.0

