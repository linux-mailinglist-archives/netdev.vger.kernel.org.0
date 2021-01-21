Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528082FE4B8
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 09:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbhAUIOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 03:14:45 -0500
Received: from m12-12.163.com ([220.181.12.12]:33444 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbhAUIOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 03:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=ujwu2jhAKdseHeYdwe
        bRz68PXQCswbggcNQ1+Mquy+U=; b=FrvZQz9/padfrDZ2aAG0AOswdOGb5LSvjE
        wm17EDxVe0/z5Tx4KU4VF/V1JpqZLcFDbOzztP51jjgWND7dCDxbXVDRejQDh8l+
        EnoXwvEPEObb6NTpG3MzGaKv8fc2yfaNxYWKhrcRuz5q1jURNbrXm4/QxeAC1oMV
        oSg+8lfFc=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp8 (Coremail) with SMTP id DMCowAAnZ8MINwlg68ZdNA--.63399S4;
        Thu, 21 Jan 2021 16:10:52 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andre Guedes <andre.guedes@openbossa.org>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] Bluetooth: Put HCI device if inquiry procedure interrupts
Date:   Thu, 21 Jan 2021 00:10:45 -0800
Message-Id: <20210121081045.38121-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DMCowAAnZ8MINwlg68ZdNA--.63399S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrur48Gr48uFWkAr13GF18AFb_yoWfGFc_ua
        ykZayfWr45Ga45Jr12vFW3Zw1j93yfCrn3Gw1IqFWUKryDWr1DJFn3Wrn8CFyfWwsrCrW3
        ZrsruFWavw1fGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbNeoUUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZAwhclQHMD9WnAAAst
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jump to the label done to decrement the reference count of HCI device
hdev on path that the Inquiry procedure is interrupted.

Fixes: 3e13fa1e1fab ("Bluetooth: Fix hci_inquiry ioctl usage")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 net/bluetooth/hci_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9d2c9a1c552f..9f8573131b97 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1362,8 +1362,10 @@ int hci_inquiry(void __user *arg)
 		 * cleared). If it is interrupted by a signal, return -EINTR.
 		 */
 		if (wait_on_bit(&hdev->flags, HCI_INQUIRY,
-				TASK_INTERRUPTIBLE))
-			return -EINTR;
+				TASK_INTERRUPTIBLE)) {
+			err = -EINTR;
+			goto done;
+		}
 	}
 
 	/* for unlimited number of responses we will use buffer with
-- 
2.17.1


