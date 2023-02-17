Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9F69A8D0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 11:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjBQKE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 05:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjBQKEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 05:04:50 -0500
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 899635D3F6;
        Fri, 17 Feb 2023 02:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ZBdy2
        Nmsi/nHTRTs/Crmb7sXfqr4oP2fZCHYUPlE0fE=; b=jpqmdvt3VRjTBFF+F1o2/
        ETijjOy1/NtIbri5pGeailC3GPWj1GMVzRdzwnY5O+yyUhfus5MJCMAMzet19JT0
        Jcmdke172WyFBBYQcpQXfWU8anHOXcl7M4QSMO5BQ2lSp6kzdrZCE08OHVf7HhTc
        OcGZv9LjgDO4l8dKr1RJDo=
Received: from leanderwang-LC2.localdomain (unknown [111.206.145.21])
        by zwqz-smtp-mta-g4-4 (Coremail) with SMTP id _____wA3b7+xUO9jalZ3AA--.3246S2;
        Fri, 17 Feb 2023 18:02:25 +0800 (CST)
From:   Zheng Wang <zyytlz.wz@163.com>
To:     marcel@holtmann.org
Cc:     hackerzheng666@gmail.com, alex000young@gmail.com,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pmenzel@molgen.mpg.de,
        Zheng Wang <zyytlz.wz@163.com>
Subject: [PATCH v2] Bluetooth: hci_core: Fix poential Use-after-Free bug in  hci_remove_adv_monitor
Date:   Fri, 17 Feb 2023 18:02:23 +0800
Message-Id: <20230217100223.702330-1-zyytlz.wz@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wA3b7+xUO9jalZ3AA--.3246S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7urWUArW8Cw4fKr15GF47XFb_yoW8XFyxpF
        W5JF1Y9rW8tr17XF1xAa1fWFyUJw4YgFZ7Cr98A34fJwsxt3yktw18Ga4qqFyfuFZ5tF42
        vF1ktrs8WayDWFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziX_-dUUUUU=
X-Originating-IP: [111.206.145.21]
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiXAQZU1Xl5pZyywABsq
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
the function will free the monitor and print its handle after that.
Fix it by removing the logging into msft_le_cancel_monitor_advertisement_cb
before calling hci_free_adv_monitor.

Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
---
v2:
- move the logging inside msft_remove_monitor suggested by Luiz
---
 net/bluetooth/hci_core.c | 2 --
 net/bluetooth/msft.c     | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index b65c3aabcd53..69b82c2907ff 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1981,8 +1981,6 @@ static int hci_remove_adv_monitor(struct hci_dev *hdev,
 
 	case HCI_ADV_MONITOR_EXT_MSFT:
 		status = msft_remove_monitor(hdev, monitor);
-		bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
-			   hdev->name, monitor->handle, status);
 		break;
 	}
 
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index bee6a4c656be..4b35f0ed1360 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -286,6 +286,8 @@ static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 		 * suspend. It will be re-monitored on resume.
 		 */
 		if (!msft->suspending) {
+			bt_dev_dbg(hdev, "%s remove monitor %d status %d", hdev->name,
+				   monitor->handle, status);
 			hci_free_adv_monitor(hdev, monitor);
 
 			/* Clear any monitored devices by this Adv Monitor */
-- 
2.25.1

