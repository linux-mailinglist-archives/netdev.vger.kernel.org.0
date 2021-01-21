Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE12FEB4F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbhAUNOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:14:30 -0500
Received: from m12-14.163.com ([220.181.12.14]:46912 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbhAUNNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 08:13:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=xUdecuC7vvbq3Zw4lX
        6slIDn9RFCjzwmGVMWNixg2e4=; b=PKUKUNGQ8XeHyTK85add9f8bwp0+gxdQ7T
        AEsepw3akoxRkbpQCCSyQltQgB2ZLKsty4fsQem0BPIjySmYDVC/Dp//KftLT48E
        gQQZLncr3qUAcS0+f3+1PG4eNBycKxdZwJxIeJUfrCk28XFu2yBMEzmsKV1gDacO
        lbHyogPpk=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp10 (Coremail) with SMTP id DsCowABHk3t9Lglgt_V9hA--.20648S4;
        Thu, 21 Jan 2021 15:34:25 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] Bluetooth: drop HCI device reference before return
Date:   Wed, 20 Jan 2021 23:34:19 -0800
Message-Id: <20210121073419.14219-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DsCowABHk3t9Lglgt_V9hA--.20648S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrur4DtrWUCryDKFy3uryfZwb_yoWxKFc_uF
        47urZ3ur48ta1Yq3y0kFZa9r1xJrs3Xan3WwnIgrW3X3sxGr45Jr4xurn8Gr1xWw4DCry7
        ZF4kXFy5Aw48WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5oGQDUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBUQIhclaD9tmcKQAAsP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call hci_dev_put() to decrement reference count of HCI device hdev if
fails to duplicate memory.

Fixes: 0b26ab9dce74 ("Bluetooth: AMP: Handle Accept phylink command status evt")
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 net/bluetooth/a2mp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index da7fd7c8c2dc..5974fd828c35 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -512,6 +512,7 @@ static int a2mp_createphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 		assoc = kmemdup(req->amp_assoc, assoc_len, GFP_KERNEL);
 		if (!assoc) {
 			amp_ctrl_put(ctrl);
+			hci_dev_put(hdev);
 			return -ENOMEM;
 		}
 
-- 
2.17.1


