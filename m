Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83F28C7FD
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfHNCXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbfHNCXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:23:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A1A520679;
        Wed, 14 Aug 2019 02:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749426;
        bh=Zm7OUAr663szjshPoyCXHmWGlb2W+d8ZOnUhMFYWhDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IC36DJmVJZuoa7E+/fHOplvgnKh8QutjRM4VHX0IXt35b7NYahpYOsHBom7bw7ZRL
         gFMYEUey9jQNqxXxl8d/vZSav4PYgXyAT0T6BJacAhXdxCd9v6377Qc3AE9qbYFZ9e
         W0xOy6klTSii/4AhmNAht/4Kb1Jvs4ug+h/7EOhg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/33] isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack
Date:   Tue, 13 Aug 2019 22:23:03 -0400
Message-Id: <20190814022323.17111-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>

[ Upstream commit d8a1de3d5bb881507602bc02e004904828f88711 ]

Since linux 4.9 it is not possible to use buffers on the stack for DMA transfers.

During usb probe the driver crashes with "transfer buffer is on stack" message.

This fix k-allocates a buffer to be used on "read_reg_atomic", which is a macro
that calls "usb_control_msg" under the hood.

Kernel 4.19 backtrace:

usb_hcd_submit_urb+0x3e5/0x900
? sched_clock+0x9/0x10
? log_store+0x203/0x270
? get_random_u32+0x6f/0x90
? cache_alloc_refill+0x784/0x8a0
usb_submit_urb+0x3b4/0x550
usb_start_wait_urb+0x4e/0xd0
usb_control_msg+0xb8/0x120
hfcsusb_probe+0x6bc/0xb40 [hfcsusb]
usb_probe_interface+0xc2/0x260
really_probe+0x176/0x280
driver_probe_device+0x49/0x130
__driver_attach+0xa9/0xb0
? driver_probe_device+0x130/0x130
bus_for_each_dev+0x5a/0x90
driver_attach+0x14/0x20
? driver_probe_device+0x130/0x130
bus_add_driver+0x157/0x1e0
driver_register+0x51/0xe0
usb_register_driver+0x5d/0x120
? 0xf81ed000
hfcsusb_drv_init+0x17/0x1000 [hfcsusb]
do_one_initcall+0x44/0x190
? free_unref_page_commit+0x6a/0xd0
do_init_module+0x46/0x1c0
load_module+0x1dc1/0x2400
sys_init_module+0xed/0x120
do_fast_syscall_32+0x7a/0x200
entry_SYSENTER_32+0x6b/0xbe

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 6f19530ba2a93..726fba452f5f6 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1701,13 +1701,23 @@ hfcsusb_stop_endpoint(struct hfcsusb *hw, int channel)
 static int
 setup_hfcsusb(struct hfcsusb *hw)
 {
+	void *dmabuf = kmalloc(sizeof(u_char), GFP_KERNEL);
 	u_char b;
+	int ret;
 
 	if (debug & DBG_HFC_CALL_TRACE)
 		printk(KERN_DEBUG "%s: %s\n", hw->name, __func__);
 
+	if (!dmabuf)
+		return -ENOMEM;
+
+	ret = read_reg_atomic(hw, HFCUSB_CHIP_ID, dmabuf);
+
+	memcpy(&b, dmabuf, sizeof(u_char));
+	kfree(dmabuf);
+
 	/* check the chip id */
-	if (read_reg_atomic(hw, HFCUSB_CHIP_ID, &b) != 1) {
+	if (ret != 1) {
 		printk(KERN_DEBUG "%s: %s: cannot read chip id\n",
 		       hw->name, __func__);
 		return 1;
-- 
2.20.1

