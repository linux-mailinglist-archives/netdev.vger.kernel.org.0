Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0830C4643C1
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345624AbhLAAGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345518AbhLAAGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:22 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1EEC061574;
        Tue, 30 Nov 2021 16:03:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso18843429pjb.0;
        Tue, 30 Nov 2021 16:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j5ekZ4KztehWagyD6KmPICwo6+51UABy5q3ntCm5U44=;
        b=mIx/D2yITLzsdayj+LqXgyXnQIO1B7h2YkwxcSbX0raJ4zEGhkPnj6/Yfsk0oj/LAB
         qMqXyQ2rVdHJeh9koKNNtzGukqnRBTvJkRlkHW1QKb2q7xmIQ4d6PIOpYk4uwxw9jmSG
         h8UEm2rqzTHo6DVSTka0BRoVMf6BxJ8wky0XMIsrCxTroL1/mS22ecNXEMrgpfTYl1SJ
         glMjnIib0qjEmKMYv4wu9fB4kLtDdYqdZodBWG/iOz/qgngwENjE74wuhn6XCOAM2DPa
         3xlO8vDqAqiaDJmL+s6tXQWRjYLBKixnCYLpg02m3YV7HQsDwWO91Ba0nUZ8/74qpDyi
         Hm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j5ekZ4KztehWagyD6KmPICwo6+51UABy5q3ntCm5U44=;
        b=hf6dNYFzdPWX0ERS0wQZCUP++REUZx3KV2bXl2xpnwpauWbJfMZBa0saAXxKfx4g+G
         g/I+hhfz4s5PJq/UxdhTE86SNbL3lJdciVaDsKazI44kLDSl4kl1yboTWObAAoDj3Yn4
         bFpKAVJlvZETLx58Z+KXrl1tBR9ExnSDMJDltFyEfcwfD/gqnN7Rsc9N0LDMSDlA1rLV
         rhudYrARGf/JG5oX0KIORnXRSIWtPcM/5rORJzGOVNp9canbJTFB5Emr9qYVJIYOvUcN
         afInup72ia9Jw08G5Nxj8HgXsrvRusbBL6xuWRFdQXglzF6/FSvjSxUCucPoAGbOAo0h
         tVbw==
X-Gm-Message-State: AOAM5300BtTBwdc+pZP45TCvcol9vZlmR3ANnzv+usu1YjLPT24mdrUF
        qY51A7IfobKFJxFVWPKK0jI=
X-Google-Smtp-Source: ABdhPJwcjhlQ8rJssyBQWvJ6HDO+NFtCNIBc8Mw+nE5CENZfj7kkws9DyQHwyesD3eTphSlXetHXLQ==
X-Received: by 2002:a17:90b:1c8d:: with SMTP id oo13mr2898679pjb.239.1638316982264;
        Tue, 30 Nov 2021 16:03:02 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:01 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 04/15] Bluetooth: HCI: Use skb_pull_data to parse Number of Complete Packets event
Date:   Tue, 30 Nov 2021 16:02:04 -0800
Message-Id: <20211201000215.1134831-5-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the Number of Complete Packets events
received have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h |  2 +-
 net/bluetooth/hci_event.c   | 20 +++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index ba89b078ceb5..3f57fd677b67 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2139,7 +2139,7 @@ struct hci_comp_pkts_info {
 } __packed;
 
 struct hci_ev_num_comp_pkts {
-	__u8     num_hndl;
+	__u8     num;
 	struct hci_comp_pkts_info handles[];
 } __packed;
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 09d7d997c4b1..b27a4ad647ca 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4465,23 +4465,25 @@ static void hci_role_change_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_num_comp_pkts_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_num_comp_pkts *ev = (void *) skb->data;
+	struct hci_ev_num_comp_pkts *ev;
 	int i;
 
-	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_PACKET_BASED) {
-		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_PKTS, sizeof(*ev));
+	if (!ev)
 		return;
-	}
 
-	if (skb->len < sizeof(*ev) ||
-	    skb->len < struct_size(ev, handles, ev->num_hndl)) {
-		BT_DBG("%s bad parameters", hdev->name);
+	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_NUM_COMP_PKTS,
+			     flex_array_size(ev, handles, ev->num)))
+		return;
+
+	if (hdev->flow_ctl_mode != HCI_FLOW_CTL_MODE_PACKET_BASED) {
+		bt_dev_err(hdev, "wrong event for mode %d", hdev->flow_ctl_mode);
 		return;
 	}
 
-	BT_DBG("%s num_hndl %d", hdev->name, ev->num_hndl);
+	BT_DBG("%s num %d", hdev->name, ev->num);
 
-	for (i = 0; i < ev->num_hndl; i++) {
+	for (i = 0; i < ev->num; i++) {
 		struct hci_comp_pkts_info *info = &ev->handles[i];
 		struct hci_conn *conn;
 		__u16  handle, count;
-- 
2.33.1

