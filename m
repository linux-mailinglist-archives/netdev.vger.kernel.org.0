Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1622669E5
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgIKVIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgIKVHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:07:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC0FC061795
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:07:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n3so3101469pjq.1
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0EDfG7U4ZsAEWdz2bw53WcEhGvs/CQ/qZmbkCldzx8=;
        b=ex1Sl7Uz5mh12J+bs6llV1eFKhakw2Wom2mdEmwWqf4rpbgzAw6QYWoOCFiSwnHERc
         vAJ62kngwukDM245INL9WqPLR0P6gIK29OQ6KgOvoCi24Jo9Co0APBvPZA6oVai92dSS
         5t2S/Ii+brIAbQrzJ77wQKErW0gUIeORvBgsc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0EDfG7U4ZsAEWdz2bw53WcEhGvs/CQ/qZmbkCldzx8=;
        b=UhsDpink+N3tjA5yvBh/7F1ohw8KUYOFDFgBfPJWIJB2OSlCdRrjyc5bNcGa4EShMX
         SHXE9uuXnzpaFocMPWHe0nmHrn1HvbQ9hFQAevgaTz5ZiUar/d6xQkm4lFcbBP108YYb
         dOCKfFLEOtdkSeWUVjAsXFPN0RyyQiR2w40B6CKTZ/oa7kFSFlyxLnbUykKVRPsdxvA/
         EVQGC8BJKDSEIYDMsauVpkAR7sR1LZjOJViUc1+Ft31cVx1g8iP3gmIPYx3VBVeRzc+1
         H2Gz41uKXbb4Vws5jYwNQZwz1X+VdWRNpv1faXH5XIndvPSMPKQsdB8p66fwDOGa53RF
         5xsA==
X-Gm-Message-State: AOAM530NG+TUtg8w+BhnE4CqaLq0Dc3RMEHwnsGN5lHEMicezdqtc2An
        7gA0Sa5RwwMEQbu7fc0DAs1gng==
X-Google-Smtp-Source: ABdhPJwjV//LWKkRlmziKhmehZRNQek4ZJQNFtvQDNBHlDqxB2Lc8nfxYwDTAKmwwMuCEdn2iB1oPw==
X-Received: by 2002:a17:90a:ebd7:: with SMTP id cf23mr3817171pjb.126.1599858443601;
        Fri, 11 Sep 2020 14:07:23 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id c128sm3308764pfb.126.2020.09.11.14.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 14:07:23 -0700 (PDT)
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
Subject: [PATCH v2 1/3] Bluetooth: Add mgmt suspend and resume events
Date:   Fri, 11 Sep 2020 14:07:11 -0700
Message-Id: <20200911140700.v2.1.I1b721ef9da5c79d8515018d806801da4eacaf563@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200911210713.4066465-1-abhishekpandit@chromium.org>
References: <20200911210713.4066465-1-abhishekpandit@chromium.org>
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

Changes in v2:
- Added suspend/resume events to list of mgmt events

 include/net/bluetooth/hci_core.h |  3 +++
 include/net/bluetooth/mgmt.h     | 11 +++++++++++
 net/bluetooth/mgmt.c             | 26 ++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

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
index e1d12494d16e14..db48ee3c213cbd 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -163,6 +163,8 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_PHY_CONFIGURATION_CHANGED,
 	MGMT_EV_EXP_FEATURE_CHANGED,
 	MGMT_EV_DEVICE_FLAGS_CHANGED,
+	MGMT_EV_CONTROLLER_SUSPEND,
+	MGMT_EV_CONTROLLER_RESUME,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -8874,6 +8876,30 @@ void mgmt_discovering(struct hci_dev *hdev, u8 discovering)
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

