Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C633D891E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhG1HwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbhG1HwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 03:52:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44289C061757;
        Wed, 28 Jul 2021 00:52:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k4-20020a17090a5144b02901731c776526so8697274pjm.4;
        Wed, 28 Jul 2021 00:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BfFfoe2qcsk90EiXHqmqBH9bAIL6WXwzwjqk2LV2VVk=;
        b=ppIUqaLekxhrUOEuMFOP5KxK5q8q7129j/z6DU0EJzkYRxjo62gKXr2wJvu8QG/yMm
         xhMyy9Wx7VIEwZV1otUjTONOQ9rx8N2PpciwEVRTLyCCo9vewTvMRfII4Ufk+BgnW9Dx
         M4KuDZAEKxvlcuFcsrjfKxl6s32AgBgkzlE4VGK+VBiclbMB0alcxkmPEOJqyEKa5LNv
         EmqYuUIQ0otQ9M2qT58HsgUtU8gcpuD/5uXEjPTLUfrdUisqhL+A12xgykRAYUIELkkr
         K1tR8aRtt9u9GfzLnkL1beWCueQkDX0wdd+/HFdwXt+RHY1guUH/GCMaP6SKALwqoaWF
         gNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BfFfoe2qcsk90EiXHqmqBH9bAIL6WXwzwjqk2LV2VVk=;
        b=c+UtA7Q1l26LK1tHfnhzqqKVZx2dk+fvaELsNIsg2yHQvr54NkfGzt1BaOlRv9fGsb
         iLKdNsrVlvBDg7nzemc3e3LNq/yKe8Ko4i8uz3DY8MuBDVyMNrIFFVv0jB0k9klsAvTd
         dOycrGmvb6BDDwjsQhgWErVLdodZAQjJXlXUH/aY/82nWOinWZl1KBOaXgiURH5Ylr8P
         qNpYnBfl2Jqx3LsKPmj43Aq6hURKhbALitIPT5viRfxIjjubl8/Lcy3dRok0SlFHhKvt
         jYYibhRGcJme+PdhvHtwlGxV+Nt/x4OT7AsB8Jw+EKvAuOSviXrLDJP4XKJPctd1Q75N
         fl5w==
X-Gm-Message-State: AOAM532pFHG06Vh4+zRavT9cRDgGaWtChUHjIWtgLc55T/Vgmqt6eoCG
        uLCbY7xkkfRyQvZyzVkr4dU=
X-Google-Smtp-Source: ABdhPJw42zg0Y3dEy18wgMq779F5L2gS2hIZZYw/51Zmz+CQ+5PANyu0aE6Ap5rABGFjTLBKbdm28w==
X-Received: by 2002:a65:6909:: with SMTP id s9mr16014599pgq.321.1627458723697;
        Wed, 28 Jul 2021 00:52:03 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id oj4sm4903482pjb.56.2021.07.28.00.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 00:52:03 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Subject: [PATCH v2] Bluetooth: skip invalid hci_sync_conn_complete_evt
Date:   Wed, 28 Jul 2021 15:51:04 +0800
Message-Id: <20210728075105.415214-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a corrupted list in kobject_add_internal [1]. This
happens when multiple HCI_EV_SYNC_CONN_COMPLETE event packets with
status 0 are sent for the same HCI connection. This causes us to
register the device more than once which corrupts the kset list.

As this is forbidden behavior, we add a check for whether we're
trying to process the same HCI_EV_SYNC_CONN_COMPLETE event multiple
times for one connection. If that's the case, the event is invalid, so
we report an error that the device is misbehaving, and ignore the
packet.

Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [1]
Reported-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Tested-by: syzbot+66264bf2fd0476be7e6c@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---

v1 -> v2:
- Added more comments to explain the reasoning behind the new check, and
a bt_dev_err message upon detecting the invalid event. As suggested by
Marcel Holtmann.

 net/bluetooth/hci_event.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 016b2999f219..a6df4f9d2c23 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4373,6 +4373,22 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev,
 
 	switch (ev->status) {
 	case 0x00:
+		/* The synchronous connection complete event should only be
+		 * sent once per new connection. Receiving a successful
+		 * complete event when the connection status is already
+		 * BT_CONNECTED means that the device is misbehaving and sent
+		 * multiple complete event packets for the same new connection.
+		 *
+		 * Registering the device more than once can corrupt kernel
+		 * memory, hence upon detecting this invalid event, we report
+		 * an error and ignore the packet.
+		 */
+		if (conn->state == BT_CONNECTED) {
+			bt_dev_err(hdev,
+				   "received multiple HCI_EV_SYNC_CONN_COMPLETE events with status 0 for conn %p",
+				   conn);
+			goto unlock;
+		}
 		conn->handle = __le16_to_cpu(ev->handle);
 		conn->state  = BT_CONNECTED;
 		conn->type   = ev->link_type;
-- 
2.25.1

