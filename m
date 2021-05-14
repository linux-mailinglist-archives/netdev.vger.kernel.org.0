Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD32380490
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhENHoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhENHoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:44:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA527C061574;
        Fri, 14 May 2021 00:43:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b21so15845683plz.0;
        Fri, 14 May 2021 00:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHaPvQmto+Bhanxbj9NMPMs12GXkBO31FUth1AEaHek=;
        b=FrDgQLtER5/YdbTwCRCrwoevZ/VwPgEnAhp4jszaUaMmiakqXrEk+3n0S1gFLVMnnY
         tfe9P9fj8EbpXppRnuobTQnjDz7T3EIlTgFEx59/8VTIfRCWNGP86BA9iiH3FLXtDwRF
         S2yEnr2VsO1QA5IY+O3R7DwLRNuZRFYNEtpOXDsiH9zIFY1X1PsDo6OZHCC+agiwGCdu
         D3hJBbmIL7WelGrdRVlUITdFDk4LQUKG24WnOZ6dGFYaf6BVzrDEtnSDxBEML12oiLYS
         EKkaDHmE/lGfEl4Hg4wmmsgH18IjsowZEx7iRe6dO5X9vvT1LYcV6ZU90Vkse6a1vizv
         /4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cHaPvQmto+Bhanxbj9NMPMs12GXkBO31FUth1AEaHek=;
        b=DIB2+nsUhvupFbo/jbp/diULFeE3DuSAsxtQ0Jx6EhR4QPRKhaykahtjuFsQhSxfhj
         tQXf11j5eFKv1uWPdE53ClMFFGy8SbeB5AOAKspq7OM0yJl19cRFruzCD1ChopB540Yb
         PyXgBLUQPs3kh93uD9tLWwM6z6AhYWobvGIM0wdTxb0BZMZi1K1sqMtxnZF0EtmOr3me
         tAG3jI2zGFxCHLsLy+osdSYhqpyC9QJssA1WiOneZW07XLkQwDbHHHHjCtY/EpvZDvba
         U8neuHiUIFCnUyZ5B3A2FwdMiQz5Ahlvzs/ZDj1K6afqBwngtv2iRrdbsGsynWjkbl9B
         7jGg==
X-Gm-Message-State: AOAM532aTfY67Sx3d0jqNiefIOe3Cq5H1qSF+FACCAzkNS4IyLxgxBM1
        nY6l4VNGaspmBuZexo6elDH5YuSqk58Nr8YjoA9Ayw==
X-Google-Smtp-Source: ABdhPJxV16yttVfW058Hp47noZTL/oMwnx9HrRTufQxH5EmjKT6Xrc5oUS+RKyNzCIldjH5gEdS+sw==
X-Received: by 2002:a17:902:e84c:b029:ee:d129:3b1c with SMTP id t12-20020a170902e84cb02900eed1293b1cmr43573452plg.73.1620978182363;
        Fri, 14 May 2021 00:43:02 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.84])
        by smtp.gmail.com with ESMTPSA id n53sm122817pfv.67.2021.05.14.00.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 00:43:01 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        bongsu.jeon@samsung.com, andrew@lunn.ch, wanghai38@huawei.com,
        zhengyongjun3@huawei.com, alexs@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Subject: [PATCH] NFC: nci: fix memory leak in nci_allocate_device
Date:   Fri, 14 May 2021 15:42:48 +0800
Message-Id: <20210514074248.780647-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfcmrvl_disconnect fails to free the hci_dev field in struct nci_dev.
Fix this by freeing hci_dev in nci_free_device.

BUG: memory leak
unreferenced object 0xffff888111ea6800 (size 1024):
  comm "kworker/1:0", pid 19, jiffies 4294942308 (age 13.580s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 60 fd 0c 81 88 ff ff  .........`......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000004bc25d43>] kmalloc include/linux/slab.h:552 [inline]
    [<000000004bc25d43>] kzalloc include/linux/slab.h:682 [inline]
    [<000000004bc25d43>] nci_hci_allocate+0x21/0xd0 net/nfc/nci/hci.c:784
    [<00000000c59cff92>] nci_allocate_device net/nfc/nci/core.c:1170 [inline]
    [<00000000c59cff92>] nci_allocate_device+0x10b/0x160 net/nfc/nci/core.c:1132
    [<00000000006e0a8e>] nfcmrvl_nci_register_dev+0x10a/0x1c0 drivers/nfc/nfcmrvl/main.c:153
    [<000000004da1b57e>] nfcmrvl_probe+0x223/0x290 drivers/nfc/nfcmrvl/usb.c:345
    [<00000000d506aed9>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<00000000bc632c92>] really_probe+0x159/0x4a0 drivers/base/dd.c:554
    [<00000000f5009125>] driver_probe_device+0x84/0x100 drivers/base/dd.c:740
    [<000000000ce658ca>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:846
    [<000000007067d05f>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000f8e13372>] __device_attach+0x122/0x250 drivers/base/dd.c:914
    [<000000009cf68860>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<00000000359c965a>] device_add+0x5be/0xc30 drivers/base/core.c:3109
    [<00000000086e4bd3>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2164
    [<00000000ca036872>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<00000000d40d36f6>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<00000000bc632c92>] really_probe+0x159/0x4a0 drivers/base/dd.c:554

Reported-by: syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 include/net/nfc/nci_core.h | 1 +
 net/nfc/nci/core.c         | 1 +
 net/nfc/nci/hci.c          | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index bd76e8e082c0..aa2e0f169015 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -298,6 +298,7 @@ int nci_nfcc_loopback(struct nci_dev *ndev, void *data, size_t data_len,
 		      struct sk_buff **resp);
 
 struct nci_hci_dev *nci_hci_allocate(struct nci_dev *ndev);
+void nci_hci_allocate(struct nci_dev *ndev);
 int nci_hci_send_event(struct nci_dev *ndev, u8 gate, u8 event,
 		       const u8 *param, size_t param_len);
 int nci_hci_send_cmd(struct nci_dev *ndev, u8 gate,
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 9a585332ea84..da7fe9db1b00 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1191,6 +1191,7 @@ EXPORT_SYMBOL(nci_allocate_device);
 void nci_free_device(struct nci_dev *ndev)
 {
 	nfc_free_device(ndev->nfc_dev);
+	nci_hci_deallocate(ndev);
 	kfree(ndev);
 }
 EXPORT_SYMBOL(nci_free_device);
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index 6b275a387a92..96865142104f 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -792,3 +792,8 @@ struct nci_hci_dev *nci_hci_allocate(struct nci_dev *ndev)
 
 	return hdev;
 }
+
+void nci_hci_deallocate(struct nci_dev *ndev)
+{
+	kfree(ndev->hci_dev);
+}
-- 
2.25.1

