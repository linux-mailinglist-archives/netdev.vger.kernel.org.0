Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DE978761
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfG2IaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:30:12 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:53608 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfG2IaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:30:12 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 04:30:10 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id 1D94315000D9;
        Mon, 29 Jul 2019 10:20:59 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id D77B76EE;
        Mon, 29 Jul 2019 10:20:58 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.68,VDF=8.16.19.170)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id 91A955C8;
        Mon, 29 Jul 2019 10:20:56 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: [PATCH] isdn: hfcsusb: Fix mISDN driver crash caused by transfer buffer on the stack
Date:   Mon, 29 Jul 2019 10:20:56 +0200
Message-ID: <2635856.so0i2TFZOM@rocinante.m.i2n>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 6d05946b445e..02006fdce67f 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1705,12 +1705,22 @@ static int
 setup_hfcsusb(struct hfcsusb *hw)
 {
 	u_char b;
+	int ret;
+	void *dmabuf = kmalloc(sizeof(u_char), GFP_KERNEL);
 
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




