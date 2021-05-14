Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6915381441
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhENXaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhENXae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 19:30:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF016C06174A;
        Fri, 14 May 2021 16:29:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 10so844081pfl.1;
        Fri, 14 May 2021 16:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pxGT21SiUzu95yASNfR5Rqs+gSBjXrD9o1zl1GmblgM=;
        b=qZao8ueNBb2tmnKNMnDqY8rqiOKOFE73tcX42qFyHSWmPi5rigkL8g3qCStYSqmM+3
         +kuGbddn0txGFXBLYg8gxLiMcnPK2/0BLd/k8i9CBk0Fy5H+EFU/ujfhji23W8m3xcqe
         cC+BXvN5Z4cnpWTdU2kidbL2qnjeZm5p92wzHalhT5CykOUEVezKEEsag4EBgvBQ7Yt4
         qm/DCoGB9Ds+hbyJqZ4UEAeeXN1R6DWAMxtJ+9yoeEcATqi5cpF9BMyeIu2Re4TNFeGQ
         N5VZfkiRWGlDnuZopqRxjE4l+ZsXdP71F4x7FNUgKpRDDw3PANKemDNWVe1++tdUiBE2
         /IwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pxGT21SiUzu95yASNfR5Rqs+gSBjXrD9o1zl1GmblgM=;
        b=CHQUDsLWRoJGP/Eo8HJML2OfnXT9lOTOu47Bcgxn2aiLYOVBBIeIXiomfixiERtytV
         GW4ykvJbe2kNilkQo7zv03oL7U0hYTG2rCQv7HceUPwIYgFgiuIyxa9NwtMQbj9MGPEL
         ZOzZ6o0fJcPMdmVzNq5fbjeXHDxXFX6rotvcxaul40Ognm86kT8DeXExcOU3Z07eHcLU
         WfJ0HVWp1hSaT4bhcOIuzNsP4ZKxsnxpH2HQv5Az1t6gh5UzZSa3VFgsS2Lhmnk6V3LH
         lLk5dVaytRuBTwfa8OrwyP+/q7qOzU32+ozMVZPfESwaoM4xYt7N6asmpITsVS7q6pFl
         jGfA==
X-Gm-Message-State: AOAM532ch27gDXLEdfymoivk+pSemUg16au89TWFCzm0lpaHQWOLdG+c
        LPRu39k8d1sdwI0ygX16Ax0=
X-Google-Smtp-Source: ABdhPJxIi9rZ2YxYfKFWCeC23+x0pQy8/tEynUCWdm6ba7M7aNucGdndo04+EihgiQKnTDaoQa+6Zg==
X-Received: by 2002:aa7:989d:0:b029:2d7:c76f:dd8 with SMTP id r29-20020aa7989d0000b02902d7c76f0dd8mr1526861pfl.15.1621034961384;
        Fri, 14 May 2021 16:29:21 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.84])
        by smtp.gmail.com with ESMTPSA id s28sm4690581pfw.115.2021.05.14.16.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 16:29:20 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        bongsu.jeon@samsung.com, andrew@lunn.ch, wanghai38@huawei.com,
        zhengyongjun3@huawei.com, alexs@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+19bcfc64a8df1318d1c3@syzkaller.appspotmail.com
Subject: [PATCH v2] NFC: nci: fix memory leak in nci_allocate_device
Date:   Sat, 15 May 2021 07:29:06 +0800
Message-Id: <20210514232906.982825-1-mudongliangabcd@gmail.com>
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
Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: change nci_hci_allocate to nci_hci_deallocate
        add the Fixes tag
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
+void nci_hci_deallocate(struct nci_dev *ndev);
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

