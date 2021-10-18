Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9F4310AD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 08:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJRGl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 02:41:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29903 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhJRGl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 02:41:27 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HXnD26P8xzbn55;
        Mon, 18 Oct 2021 14:34:42 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 14:39:14 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 18 Oct
 2021 14:39:12 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <shenyang39@huawei.com>, <marcelo@kvack.org>,
        <linville@tuxdriver.com>, <luisca@cozybit.com>
CC:     <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] mwifiex: Fix possible memleak in probe and disconnect
Date:   Mon, 18 Oct 2021 14:38:18 +0800
Message-ID: <20211018063818.1895774-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff888031c2f000 (size 512):
  comm "kworker/0:2", pid 165, jiffies 4294922253 (age 391.180s)
  hex dump (first 32 bytes):
    00 20 f7 08 80 88 ff ff 01 00 00 00 00 00 00 00  . ..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000537bdb86>] kmem_cache_alloc_trace+0x16d/0x360
    [<0000000047666fab>] if_usb_probe+0x90/0x96e [usb8xxx]
    [<00000000de44b4f0>] usb_probe_interface+0x31b/0x800 [usbcore]
    [<000000009b1a1951>] really_probe+0x299/0xc30
    [<0000000055b8ffce>] __driver_probe_device+0x357/0x500
    [<00000000bb0c7161>] driver_probe_device+0x4e/0x140
    [<00000000866d1730>] __device_attach_driver+0x257/0x340
    [<0000000084e79b96>] bus_for_each_drv+0x166/0x1e0
    [<000000009bad60ea>] __device_attach+0x272/0x420
    [<00000000236b97c1>] bus_probe_device+0x1eb/0x2a0
    [<000000008d77d7cf>] device_add+0xbf0/0x1cd0
    [<000000004af6a3f0>] usb_set_configuration+0x10fb/0x18d0 [usbcore]
    [<000000002ebdfdcd>] usb_generic_driver_probe+0xa2/0xe0 [usbcore]
    [<00000000444f344d>] usb_probe_device+0xe4/0x2b0 [usbcore]
    [<000000009b1a1951>] really_probe+0x299/0xc30
    [<0000000055b8ffce>] __driver_probe_device+0x357/0x500

cardp is missing being freed in the error handling path of the probe
and the path of the disconnect, which will cause kmemleak.

This patch adds the missing free().

Fixes: 876c9d3aeb98 ("[PATCH] Marvell Libertas 8388 802.11b/g USB driver")
Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wireless/marvell/libertas/if_usb.c    | 2 ++
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 20436a289d5c..5d6dc1dd050d 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -292,6 +292,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	if_usb_reset_device(cardp);
 dealloc:
 	if_usb_free(cardp);
+	kfree(cardp);
 
 error:
 	return r;
@@ -316,6 +317,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
+	kfree(cardp);
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index fe0a69e804d8..75b5319d033f 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -230,6 +230,7 @@ static int if_usb_probe(struct usb_interface *intf,
 
 dealloc:
 	if_usb_free(cardp);
+	kfree(cardp);
 error:
 lbtf_deb_leave(LBTF_DEB_MAIN);
 	return -ENOMEM;
@@ -254,6 +255,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
 
 	/* Unlink and free urb */
 	if_usb_free(cardp);
+	kfree(cardp);
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
-- 
2.25.1

