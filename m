Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9144A491403
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244380AbiARCTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:19:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244332AbiARCTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:19:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFA35B81232;
        Tue, 18 Jan 2022 02:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D1CC36AEB;
        Tue, 18 Jan 2022 02:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472386;
        bh=KgD6qxy+fP2fvSM/3e8PrWESYFntT/ISgWQqCE2FJS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euTA7ZLXr90l4pYuM6om2n6/wA6o8gZwVBPCYxn5Pig7zwTssCS6FH2UyIqRyDP2Q
         CF0KkH1aj287tLfn/Bmetp8uirul43gbc45Go7DTIpPUTqn2u0IJE0M52HTUAHp/R+
         zL8RfQERrH+WWQgbxwHReO3ZY1Tn4OFi39KeMdcDF5P2htDAUJgZoillcqxPh8GOYv
         W+eGuKBukIY8oBTCJFsn/a0dGgaNfyFtJ/1udGLVB96P7tpLE4GIfBrtLIU/8i8qk2
         EdKhoZwLzNPs1a0zqP/hRX1CZl8QVvKoQ/TvRfTdNIXHKI0tuC1ktL/BGVvW9+hleS
         cUywCW/hDkkfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 003/217] Bluetooth: Fix memory leak of hci device
Date:   Mon, 17 Jan 2022 21:16:06 -0500
Message-Id: <20220118021940.1942199-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 75d9b8559ac36e059238ee4f8e33cd86086586ba ]

Fault injection test reported memory leak of hci device as follows:

unreferenced object 0xffff88800b858000 (size 8192):
  comm "kworker/0:2", pid 167, jiffies 4294955747 (age 557.148s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
  backtrace:
    [<0000000070eb1059>] kmem_cache_alloc_trace mm/slub.c:3208
    [<00000000015eb521>] hci_alloc_dev_priv include/linux/slab.h:591
    [<00000000dcfc1e21>] bpa10x_probe include/net/bluetooth/hci_core.h:1240
    [<000000005d3028c7>] usb_probe_interface drivers/usb/core/driver.c:397
    [<00000000cbac9243>] really_probe drivers/base/dd.c:517
    [<0000000024cab3f0>] __driver_probe_device drivers/base/dd.c:751
    [<00000000202135cb>] driver_probe_device drivers/base/dd.c:782
    [<000000000761f2bc>] __device_attach_driver drivers/base/dd.c:899
    [<00000000f7d63134>] bus_for_each_drv drivers/base/bus.c:427
    [<00000000c9551f0b>] __device_attach drivers/base/dd.c:971
    [<000000007f79bd16>] bus_probe_device drivers/base/bus.c:487
    [<000000007bb8b95a>] device_add drivers/base/core.c:3364
    [<000000009564d9ea>] usb_set_configuration drivers/usb/core/message.c:2171
    [<00000000e4657087>] usb_generic_driver_probe drivers/usb/core/generic.c:239
    [<0000000071ede518>] usb_probe_device drivers/usb/core/driver.c:294
    [<00000000cbac9243>] really_probe drivers/base/dd.c:517

hci_alloc_dev() do not init the device's flag. And hci_free_dev()
using put_device() to free the memory allocated for this device,
but it calls just put_device(dev) only in case of HCI_UNREGISTER
flag is set, So any error handing before hci_register_dev() success
will cause memory leak.

To avoid this behaviour we can using kfree() to release dev before
hci_register_dev() success.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 7827639ecf5c3..4e3e0451b08c1 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -86,6 +86,8 @@ static void bt_host_release(struct device *dev)
 
 	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		hci_release_dev(hdev);
+	else
+		kfree(hdev);
 	module_put(THIS_MODULE);
 }
 
-- 
2.34.1

