Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C31B434ABC
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJTMHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:07:04 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26104 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhJTMHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:07:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HZ8Pt6jHCz1DHh8;
        Wed, 20 Oct 2021 20:02:58 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 20 Oct 2021 20:04:43 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Wed, 20 Oct
 2021 20:04:42 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <kvalo@codeaurora.org>, <briannorris@chromium.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <shenyang39@huawei.com>,
        <marcelo@kvack.org>, <linville@tuxdriver.com>, <luisca@cozybit.com>
CC:     <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 wireless-drivers 2/2] libertas: Fix possible memory leak in probe and disconnect
Date:   Wed, 20 Oct 2021 20:03:45 +0800
Message-ID: <20211020120345.2016045-3-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020120345.2016045-1-wanghai38@huawei.com>
References: <20211020120345.2016045-1-wanghai38@huawei.com>
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

unreferenced object 0xffff88812c7d7400 (size 512):
  comm "kworker/6:1", pid 176, jiffies 4295003332 (age 822.830s)
  hex dump (first 32 bytes):
    00 68 1e 04 81 88 ff ff 01 00 00 00 00 00 00 00  .h..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8167939c>] slab_post_alloc_hook+0x9c/0x490
    [<ffffffff8167f627>] kmem_cache_alloc_trace+0x1f7/0x470
    [<ffffffffa02c9873>] if_usb_probe+0x63/0x446 [usb8xxx]
    [<ffffffffa022668a>] usb_probe_interface+0x1aa/0x3c0 [usbcore]
    [<ffffffff82b59630>] really_probe+0x190/0x480
    [<ffffffff82b59a19>] __driver_probe_device+0xf9/0x180
    [<ffffffff82b59af3>] driver_probe_device+0x53/0x130
    [<ffffffff82b5a075>] __device_attach_driver+0x105/0x130
    [<ffffffff82b55949>] bus_for_each_drv+0x129/0x190
    [<ffffffff82b593c9>] __device_attach+0x1c9/0x270
    [<ffffffff82b5a250>] device_initial_probe+0x20/0x30
    [<ffffffff82b579c2>] bus_probe_device+0x142/0x160
    [<ffffffff82b52e49>] device_add+0x829/0x1300
    [<ffffffffa02229b1>] usb_set_configuration+0xb01/0xcc0 [usbcore]
    [<ffffffffa0235c4e>] usb_generic_driver_probe+0x6e/0x90 [usbcore]
    [<ffffffffa022641f>] usb_probe_device+0x6f/0x130 [usbcore]

cardp is missing being freed in the error handling path of the probe
and the path of the disconnect, which will cause memory leak.

This patch adds the missing kfree().

Fixes: 876c9d3aeb98 ("[PATCH] Marvell Libertas 8388 802.11b/g USB driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.25.1

