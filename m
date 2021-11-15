Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2C94500A2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhKOJAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:00:21 -0500
Received: from out0.migadu.com ([94.23.1.103]:23140 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhKOI7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 03:59:46 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1636966597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y+Bm8QDSa0sfdwkm8MF53jbofoWhdoJgEnE0ZPlEIOo=;
        b=DUKyIAVPJXZLDva9nCMJBOXes+N+8mSHlMza1R90BIFZBTW4K+mySyQp4eloLJ0hPLqeFK
        fN41UnXKRxDSOnh+V78/lQFxMKRuNBFwL1OYoHknSyFJ39HN2vb5Wii6k3pR9MT9dqVfJu
        BTT43g5TfikO6qNdkAjMCMQH/kamgtI=
From:   Jackie Liu <liu.yun@linux.dev>
To:     chethan.tumkur.narayan@intel.com, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH] bluetooth: fix uninitialized variables notify_evt
Date:   Mon, 15 Nov 2021 16:56:13 +0800
Message-Id: <20211115085613.1924762-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: liu.yun@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

Coverity Scan report:

[...]
*** CID 1493985:  Uninitialized variables  (UNINIT)
/net/bluetooth/hci_event.c: 4535 in hci_sync_conn_complete_evt()
4529
4530     	/* Notify only in case of SCO over HCI transport data path which
4531     	 * is zero and non-zero value shall be non-HCI transport data path
4532     	 */
4533     	if (conn->codec.data_path == 0) {
4534     		if (hdev->notify)
>>>     CID 1493985:  Uninitialized variables  (UNINIT)
>>>     Using uninitialized value "notify_evt" when calling "*hdev->notify".
4535     			hdev->notify(hdev, notify_evt);
4536     	}
4537
4538     	hci_connect_cfm(conn, ev->status);
4539     	if (ev->status)
4540     		hci_conn_del(conn);
[...]

Although only btusb uses air_mode, and he only handles HCI_NOTIFY_ENABLE_SCO_CVSD
and HCI_NOTIFY_ENABLE_SCO_TRANSP, there is still a very small chance that
ev->air_mode is not equal to 0x2 and 0x3, but notify_evt is initialized to
HCI_NOTIFY_ENABLE_SCO_CVSD or HCI_NOTIFY_ENABLE_SCO_TRANSP. the context is
maybe not correct.

In order to ensure 100% correctness, we directly give him a default value 0.

Addresses-Coverity: ("Uninitialized variables")
Fixes: f4f9fa0c07bb ("Bluetooth: Allow usb to auto-suspend when SCO use	non-HCI transport")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 net/bluetooth/hci_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7d0db1ca1248..f898fa42a183 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4445,7 +4445,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 {
 	struct hci_ev_sync_conn_complete *ev = (void *) skb->data;
 	struct hci_conn *conn;
-	unsigned int notify_evt;
+	unsigned int notify_evt = 0;
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
-- 
2.25.1

