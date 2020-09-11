Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB31E2665CE
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgIKRNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgIKRNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:13:13 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B458CC061795
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:13:12 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so7098258pgl.4
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mbot9ybxN7CEBjkJx2/zfixlDiQJfoliZ9FJfemsvkc=;
        b=dkngZxcJsfiwaoaeeA5ivGItvOj+ltwumQrEg2V2Fb6waCKmwZnjPEH4f4GucgxVLB
         5dw95RVIXR7dHD+f1E9ucpz2A3/rbkTFTnco1FwjNge2jtemQnNxvrRRKr+KfkzRDqJQ
         +oLDdyDVAapClSi2quq12dscrXXbs1KAohowQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mbot9ybxN7CEBjkJx2/zfixlDiQJfoliZ9FJfemsvkc=;
        b=fNwy9eT64ly9+2HWuZTYpnCoWAupU8QzQfIfbzoO+XZJfFOjlHceEm8ozz1+9EJa4d
         eQPUOxgMhiB3j2CnS0YFf5GgzQEhSIwEjwA47N4BTnwcIpmR/bFK2CceXNbYZlonoz/X
         aeKRxuckT0YJPXYZLBYefQkYbvnl+py4t+RSDVKteJhzwRDut+6xQCon1m2qyJPmjcfD
         RE6UboahfeGnqEPrq1p0SgaHAbrU3rFg+gcHeiLT6c+hYO86HegFCnazVIdCJ/G7L08w
         VOE68vBo65l2Z9DVtylx63FPdgvwxHa7O7zlaFklB4DRa9rON0L1k+EwLV67fA2Vwqbl
         k/7Q==
X-Gm-Message-State: AOAM530iPEBscCENX31W7lrU2VHj13CMwZNxCMzn1oOHjKHAMfkynY2y
        BA3SwZc1MlNS1A1ACch3F0a31A==
X-Google-Smtp-Source: ABdhPJxZSSZY4mIQBJ0os+Tl+NKbSD61XqIC+eZsymowPVyQeWCMOMXGMvOnS58X3crxD9bFA3MAlw==
X-Received: by 2002:a63:b20d:: with SMTP id x13mr385059pge.136.1599844392256;
        Fri, 11 Sep 2020 10:13:12 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id h9sm2787452pfc.28.2020.09.11.10.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 10:13:11 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RESEND PATCH 1/3] Bluetooth: Add mgmt suspend and resume events
Date:   Fri, 11 Sep 2020 10:13:04 -0700
Message-Id: <20200911101255.RESEND.1.I1b721ef9da5c79d8515018d806801da4eacaf563@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200911171306.3758642-1-abhishekpandit@chromium.org>
References: <20200911171306.3758642-1-abhishekpandit@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the controller suspend and resume events, which will signal when
Bluetooth has completed preparing for suspend and when it's ready for
resume.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
---

 include/net/bluetooth/hci_core.h |  3 +++
 include/net/bluetooth/mgmt.h     | 11 +++++++++++
 net/bluetooth/mgmt.c             | 24 ++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 8caac20556b499..02a6ee056b2374 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1750,6 +1750,9 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 void mgmt_remote_name(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 		      u8 addr_type, s8 rssi, u8 *name, u8 name_len);
 void mgmt_discovering(struct hci_dev *hdev, u8 discovering);
+void mgmt_suspending(struct hci_dev *hdev, u8 state);
+void mgmt_resuming(struct hci_dev *hdev, u8 reason, bdaddr_t *bdaddr,
+		   u8 addr_type);
 bool mgmt_powering_down(struct hci_dev *hdev);
 void mgmt_new_ltk(struct hci_dev *hdev, struct smp_ltk *key, bool persistent);
 void mgmt_new_irk(struct hci_dev *hdev, struct smp_irk *irk, bool persistent);
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 9ad505b9e694e4..e19e33c7b65c34 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1030,3 +1030,14 @@ struct mgmt_ev_adv_monitor_added {
 struct mgmt_ev_adv_monitor_removed {
 	__le16 monitor_handle;
 }  __packed;
+
+#define MGMT_EV_CONTROLLER_SUSPEND		0x002d
+struct mgmt_ev_controller_suspend {
+	__u8	suspend_state;
+} __packed;
+
+#define MGMT_EV_CONTROLLER_RESUME		0x002e
+struct mgmt_ev_controller_resume {
+	__u8	wake_reason;
+	struct mgmt_addr_info addr;
+} __packed;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index e1d12494d16e14..1475a47edb080b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8874,6 +8874,30 @@ void mgmt_discovering(struct hci_dev *hdev, u8 discovering)
 	mgmt_event(MGMT_EV_DISCOVERING, hdev, &ev, sizeof(ev), NULL);
 }
 
+void mgmt_suspending(struct hci_dev *hdev, u8 state)
+{
+	struct mgmt_ev_controller_suspend ev;
+
+	ev.suspend_state = state;
+	mgmt_event(MGMT_EV_CONTROLLER_SUSPEND, hdev, &ev, sizeof(ev), NULL);
+}
+
+void mgmt_resuming(struct hci_dev *hdev, u8 reason, bdaddr_t *bdaddr,
+		   u8 addr_type)
+{
+	struct mgmt_ev_controller_resume ev;
+
+	ev.wake_reason = reason;
+	if (bdaddr) {
+		bacpy(&ev.addr.bdaddr, bdaddr);
+		ev.addr.type = addr_type;
+	} else {
+		memset(&ev.addr, 0, sizeof(ev.addr));
+	}
+
+	mgmt_event(MGMT_EV_CONTROLLER_RESUME, hdev, &ev, sizeof(ev), NULL);
+}
+
 static struct hci_mgmt_chan chan = {
 	.channel	= HCI_CHANNEL_CONTROL,
 	.handler_count	= ARRAY_SIZE(mgmt_handlers),
-- 
2.28.0.618.gf4bc123cb7-goog

