Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8EFB4FC3
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfIQN5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:57:39 -0400
Received: from canardo.mork.no ([148.122.252.1]:41955 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfIQN5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 09:57:22 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:283:ec3f:f053:4dff:fe21:2003])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x8HDq8Bo021127
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 17 Sep 2019 15:52:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1568728331; bh=L7n18OkHZ0Cj4ivUUvS8a81ZmYnqAYgPDJQ5NFMCf6A=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=GBNVZEcwSBMi62y/PpqCkqqBAPy77T4oSbBM76KZH8Wzkzd8AngTyLlFC0iTrcDL9
         aW5IpD8JMjGAOYee2bIKu8wDv42u2/khHase2TDizH/MLlt5i0uY8JgOlmgoCPC2At
         OR/iJZT6CAfZJuBi10EVCK679r+0CipXLh5j7yr4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iADti-0007ms-Sz; Tue, 17 Sep 2019 15:52:02 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     syzbot <syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com>
Cc:     andreyknvl@google.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: divide error in cdc_ncm_update_rxtx_max
Organization: m
References: <000000000000c7b6940592ab9606@google.com>
Date:   Tue, 17 Sep 2019 15:52:02 +0200
In-Reply-To: <000000000000c7b6940592ab9606@google.com> (syzbot's message of
        "Mon, 16 Sep 2019 06:29:10 -0700")
Message-ID: <87h85bm3nh.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

#syz test: https://github.com/google/kasan.git f0df5c1b


--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
 filename=0001-cdc_ncm-fix-divide-error-when-USB-packet-size-is-0.patch
Content-Transfer-Encoding: quoted-printable

From dd2eb64899d5e695e5e05c674ecbbc3fce01b4b5 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Bj=3DC3=3DB8rn=3D20Mork?=3D <bjorn@mork.no>
Date: Tue, 17 Sep 2019 15:46:03 +0200
Subject: [RFC] cdc_ncm: fix divide error when USB packet size is 0
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

syzbot reported:

cdc_ncm 1-1:1.0: dwNtbInMaxSize=3D0 is too small. Using 2048
cdc_ncm 1-1:1.0: setting rx_max =3D 2048
cdc_ncm 1-1:1.0: setting tx_max =3D 16384
divide error: 0000 [#1] SMP KASAN
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:cdc_ncm_update_rxtx_max+0xc6e/0xef0 drivers/net/usb/cdc_ncm.c:419
Code: e0 07 38 c2 0f 9e c1 84 d2 0f 95 c0 84 c1 0f 85 35 02 00 00 0f
b7 5b 04 81 e3 ff 07 00 00 e8 29 47 f7 fd 31 d2 44 89 e0 31 ff <f7> f3
41 89 d5 89 d6 e8 86 48 f7 fd 45 85 ed 0f 85 17 f7 ff ff e8
RSP: 0018:ffff8881da20f030 EFLAGS: 00010246
RAX: 0000000000004000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff83469377 RDI: 0000000000000000
RBP: ffff8881c7ba0000 R08: ffff8881da1f9800 R09: ffffed103b645d58
R10: ffffed103b645d57 R11: ffff8881db22eabf R12: 0000000000004000
R13: 0000000000000000 R14: ffff8881d35f3dc0 R15: ffff8881d2a70f00
FS:  0000000000000000(0000) GS:ffff8881db200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1059879000 CR3: 00000001d49db000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cdc_ncm_setup drivers/net/usb/cdc_ncm.c:667 [inline]
 cdc_ncm_bind_common+0x1005/0x2570 drivers/net/usb/cdc_ncm.c:924
 cdc_ncm_bind+0x7c/0x1c0 drivers/net/usb/cdc_ncm.c:1038
 usbnet_probe+0xb43/0x23cf drivers/net/usb/usbnet.c:1722
 usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
 really_probe+0x281/0x6d0 drivers/base/dd.c:548
 driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
 __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
 bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
 __device_attach+0x217/0x360 drivers/base/dd.c:894
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
 device_add+0xae6/0x16f0 drivers/base/core.c:2165
 usb_set_configuration+0xdf6/0x1670 drivers/usb/core/message.c:2023
 generic_probe+0x9d/0xd5 drivers/usb/core/generic.c:210
 usb_probe_device+0x99/0x100 drivers/usb/core/driver.c:266
 really_probe+0x281/0x6d0 drivers/base/dd.c:548
 driver_probe_device+0x101/0x1b0 drivers/base/dd.c:721
 __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:828
 bus_for_each_drv+0x162/0x1e0 drivers/base/bus.c:454
 __device_attach+0x217/0x360 drivers/base/dd.c:894
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:514
 device_add+0xae6/0x16f0 drivers/base/core.c:2165
 usb_new_device.cold+0x6a4/0xe79 drivers/usb/core/hub.c:2536
 hub_port_connect drivers/usb/core/hub.c:5098 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
 port_event drivers/usb/core/hub.c:5359 [inline]
 hub_event+0x1b5c/0x3640 drivers/usb/core/hub.c:5441
 process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
 worker_thread+0x96/0xe20 kernel/workqueue.c:2415
 kthread+0x318/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace ab75cc10e099d8e9 ]---

Reported-by: syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com
Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 drivers/net/usb/cdc_ncm.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 50c05d0f44cb..029fe9082a8f 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -377,6 +377,7 @@ static void cdc_ncm_update_rxtx_max(struct usbnet *dev,=
 u32 new_rx, u32 new_tx)
 {
 	struct cdc_ncm_ctx *ctx =3D (struct cdc_ncm_ctx *)dev->data[0];
 	u8 iface_no =3D ctx->control->cur_altsetting->desc.bInterfaceNumber;
+	u16 maxp =3D usb_maxpacket(dev->udev, dev->out, 1);
 	u32 val;
=20
 	val =3D cdc_ncm_check_rx_max(dev, new_rx);
@@ -411,12 +412,8 @@ static void cdc_ncm_update_rxtx_max(struct usbnet *dev=
, u32 new_rx, u32 new_tx)
 	/* Adding a pad byte here if necessary simplifies the handling
 	 * in cdc_ncm_fill_tx_frame, making tx_max always represent
 	 * the real skb max size.
-	 *
-	 * We cannot use dev->maxpacket here because this is called from
-	 * .bind which is called before usbnet sets up dev->maxpacket
 	 */
-	if (val !=3D le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize) &&
-	    val % usb_maxpacket(dev->udev, dev->out, 1) =3D=3D 0)
+	if (maxp && val !=3D le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize) && val % =
maxp =3D=3D 0)
 		val++;
=20
 	/* we might need to flush any pending tx buffers if running */
--=20
2.20.1


--=-=-=--
