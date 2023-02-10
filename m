Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6F691782
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 05:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjBJEL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 23:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjBJEL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 23:11:26 -0500
Received: from m12.mail.163.com (m12.mail.163.com [123.126.96.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 138E08A5E;
        Thu,  9 Feb 2023 20:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=oGikc
        NFZc3el4R4e5AyREsNxJCPuWtBQAXD7oOnxock=; b=n3l44jrqs7cmBamNxL3+B
        qz0YihQC74inQu5cPZ0cYhj/UesFBgdV09BAYdfDTtzl6rXIB8iflL2zi5nH2aaG
        fX/67H4MqYjbjjMVVbyvHB06+EahnHdCIezXVd1pFCtIW5dMst4q269Sh42EuRjt
        rnZWLYVv/AGLD3mxb8Kpxo=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by smtp20 (Coremail) with SMTP id H91pCgC3gba3w+VjdWhCDg--.52843S2;
        Fri, 10 Feb 2023 12:10:32 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     marcel@holtmann.org
Cc:     hackerzheng666@gmail.com, alex000young@gmail.com,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH] Bluetooth: hci_core: Fix poential Use-after-Free bug in hci_remove_adv_monitor
Date:   Fri, 10 Feb 2023 12:10:30 +0800
Message-Id: <20230210041030.865478-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: H91pCgC3gba3w+VjdWhCDg--.52843S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw47GF47trWxWw4UGF43trb_yoWfuFbE9r
        1xAryfWr4UGF15AF47ZFW5Zr1Utw1rZF4fta4fXFWYq34qgwnxtr1IvwnxZFyxuw4qyry3
        AanxW34Y9w15tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKBT5JUUUUU==
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXBgSU1Xl5kpygQAAsq
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
the function will free the monitor and print its handle after that.

Fix it by switch the order.

Fixes: 7cf5c2978f23 ("Bluetooth: hci_sync: Refactor remove Adv Monitor")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b65c3aabcd53..db3352c60de6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1980,9 +1980,9 @@ static int hci_remove_adv_monitor(struct hci_dev *hdev,
 		goto free_monitor;
 
 	case HCI_ADV_MONITOR_EXT_MSFT:
-		status = msft_remove_monitor(hdev, monitor);
 		bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
 			   hdev->name, monitor->handle, status);
+		status = msft_remove_monitor(hdev, monitor);
 		break;
 	}
 
-- 
2.25.1

