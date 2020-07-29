Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE39231754
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 03:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbgG2Bml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 21:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730117AbgG2Bmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 21:42:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E7FC0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 18:42:40 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j19so13369983pgm.11
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 18:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eSNl5guPVSTVFb6xmLUiPtvBabfXpb7A/lKPqGtlYVE=;
        b=Z1OP5tnvZFehixnm5/zklBzayLRLEJOr/wpWZHZdO9CCj3RzpX4aCf8laptB3LXr7m
         mMxRRhYsJ9NYel6WVmcmi2xleu2s/YC3hcavNYO2HFM3zX68h7M2aB3KB289JeVoCtd2
         RT8YAS/tfcxMD+qySCgNPwM64IvQtPQo3uvdA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eSNl5guPVSTVFb6xmLUiPtvBabfXpb7A/lKPqGtlYVE=;
        b=QV7mDD99mzZHjoHsRT+iAm/iKK7Nt2vR9QeS3lasDbIAkiE8tPxi4in5KneAy1iek7
         ac2Eaw+7FxSPlkIUUkisicpo3fczqNYkNdHi4x1jN9qRl5ve79NQaZ4kH1GMBF6jOVlQ
         3+GniPuanOWXtt5OE2HfVwckEn9ucw+pxRhgOtimiwoUbvelRQ6fJEGkd6uFexqrfSOg
         3G6G97GeIpiK7/dS1y7gO4xNJx9XfXL6xsWGbzcLV/+ug4xEeTkH90L8OVPAk/uIO13+
         DP237yxGBy6PxmBTYq9k/JoxqTnmyq000FdqnLV+6yvSMuUvvb9TMGrxtedIl5wGbihM
         MJxw==
X-Gm-Message-State: AOAM532aC5tMTYAbCGqoCZcG+51PsVMYGVT9HQ6TmENrQaUvN33l+Vk6
        O7Syw9LPk6z3Jn7Y/RIAzcTTeg==
X-Google-Smtp-Source: ABdhPJxmMzqdfhSy+5r+Shhpe9Koc5HP/8a+PhUzDBJ2QPDK9IcuRsnWyLnvvshaymFwOpCL7O2t1g==
X-Received: by 2002:a63:454d:: with SMTP id u13mr5805629pgk.309.1595986960385;
        Tue, 28 Jul 2020 18:42:40 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id e124sm280678pfe.176.2020.07.28.18.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 18:42:39 -0700 (PDT)
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
Subject: [PATCH 1/3] Bluetooth: Add mgmt suspend and resume events
Date:   Tue, 28 Jul 2020 18:42:23 -0700
Message-Id: <20200728184205.1.I1b721ef9da5c79d8515018d806801da4eacaf563@changeid>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
In-Reply-To: <20200729014225.1842177-1-abhishekpandit@chromium.org>
References: <20200729014225.1842177-1-abhishekpandit@chromium.org>
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
index bee1b4778ccc96..1b336e6ebe66aa 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1747,6 +1747,9 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
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
index beae5c3980f03b..d9a88cab379555 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1028,3 +1028,14 @@ struct mgmt_ev_adv_monitor_added {
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
index f45105d2de7722..1c89ae819207ac 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8730,6 +8730,30 @@ void mgmt_discovering(struct hci_dev *hdev, u8 discovering)
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
2.28.0.rc0.142.g3c755180ce-goog

