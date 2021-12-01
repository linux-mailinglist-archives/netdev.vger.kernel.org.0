Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA604643C6
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345678AbhLAAGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345553AbhLAAGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:24 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6E4C061574;
        Tue, 30 Nov 2021 16:03:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id np3so16554276pjb.4;
        Tue, 30 Nov 2021 16:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ab89kELLOw7PFgiC45BjFwbpcUH6t8PHkBmKKzmYafY=;
        b=cW9m0oC/wbdISjs0JrtZe/EdDMHcGbjj7SQGeHQv5dSdzJG9jAmDs4OSDyVXaFGoyv
         CRVNAinysfqd9QYx9lozQe0wLKNt3pIs0pGIRY3X2q+X2KQz6VdoBHlpU64t+7wfRJDA
         oeEzyyljbIyi8Ijs4VMl787hwB50Za1c890akbJtTRy3JhlWSQUkUK8ULoIrmPuztAGb
         4O+Id+cbg1GDwpiDyTqgc6/FTCD8Oukc6mT5oBA8ceFsUgoVO1JIoPS0wZxly9tEluzL
         mNjvE0VrvRaEh3+yU2litTNNqW6LDXOS7idtwRGsba0ioMMY9guwOU9uvNHOAOHoPoT1
         Eq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ab89kELLOw7PFgiC45BjFwbpcUH6t8PHkBmKKzmYafY=;
        b=E2lnXE7XhuDzR33om8Wc78rIaCSXcspHA6Ve+y/47Ne2k3ZfMbT8yl8fbHlQIf7pxh
         Fr7BEDCJchz9yc3891bRdGm6tGnX5bHoUjlOGTL0kxrlyCNrHnFDcA0AHTuTBfnLqOlW
         OdBKgz44YIn3EGEc/uuCN9lnt8/49UkRxZZGfN15q8qlU06lyFmhfFzsyL9W3Vn7xxuO
         PkMjX7gjL0+R6KQ5siK7DxqpcTP23ocUMw+ES2/l/1OloBPu2B3WH6vGqzEZpxvcWB+p
         Md2gYF9Jx+fmr5togxGnjKzpwwPdeo4fwTl+n9AESnshfVXCFRc1fvNX6kiU+3CJV3TQ
         +kYw==
X-Gm-Message-State: AOAM530MA7WLGdIw3VHkHxmo5mSAi2+TlOTV9W40QF2LtN+Kt6mNitgi
        n6eVpngk9o8oCRB+XA1fzTc=
X-Google-Smtp-Source: ABdhPJwfvbdCAV9JQy6ftTTO672+ZfLgMyXA6X/yMH0dn2UfW2hlrlcrU3PGfqLVm4n4lj0Pgv20IA==
X-Received: by 2002:a17:902:f092:b0:141:ccb6:897 with SMTP id p18-20020a170902f09200b00141ccb60897mr2935497pla.89.1638316983881;
        Tue, 30 Nov 2021 16:03:03 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:03 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 06/15] Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result with RSSI event
Date:   Tue, 30 Nov 2021 16:02:06 -0800
Message-Id: <20211201000215.1134831-7-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the Inquiry Result with RSSI events
received have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h | 12 +++++++++--
 net/bluetooth/hci_event.c   | 40 +++++++++++++++++++++----------------
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 55466bfb972a..d25afd92a46e 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2194,7 +2194,7 @@ struct hci_ev_pscan_rep_mode {
 } __packed;
 
 #define HCI_EV_INQUIRY_RESULT_WITH_RSSI	0x22
-struct inquiry_info_with_rssi {
+struct inquiry_info_rssi {
 	bdaddr_t bdaddr;
 	__u8     pscan_rep_mode;
 	__u8     pscan_period_mode;
@@ -2202,7 +2202,7 @@ struct inquiry_info_with_rssi {
 	__le16   clock_offset;
 	__s8     rssi;
 } __packed;
-struct inquiry_info_with_rssi_and_pscan_mode {
+struct inquiry_info_rssi_pscan {
 	bdaddr_t bdaddr;
 	__u8     pscan_rep_mode;
 	__u8     pscan_period_mode;
@@ -2211,6 +2211,14 @@ struct inquiry_info_with_rssi_and_pscan_mode {
 	__le16   clock_offset;
 	__s8     rssi;
 } __packed;
+struct hci_ev_inquiry_result_rssi {
+	__u8     num;
+	struct inquiry_info_rssi info[];
+} __packed;
+struct hci_ev_inquiry_result_rssi_pscan {
+	__u8     num;
+	struct inquiry_info_rssi_pscan info[];
+} __packed;
 
 #define HCI_EV_REMOTE_EXT_FEATURES	0x23
 struct hci_ev_remote_ext_features {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0bf062f6f262..6560dca8c5ce 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4921,12 +4921,21 @@ static void hci_pscan_rep_mode_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
 					     struct sk_buff *skb)
 {
+	union {
+		struct hci_ev_inquiry_result_rssi *res1;
+		struct hci_ev_inquiry_result_rssi_pscan *res2;
+	} *ev;
 	struct inquiry_data data;
-	int num_rsp = *((__u8 *) skb->data);
+	int i;
 
-	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_RESULT_WITH_RSSI,
+			     sizeof(*ev));
+	if (!ev)
+		return;
+
+	BT_DBG("%s num_rsp %d", hdev->name, ev->res1->num);
 
-	if (!num_rsp)
+	if (!ev->res1->num)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))
@@ -4934,16 +4943,13 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
 
 	hci_dev_lock(hdev);
 
-	if ((skb->len - 1) / num_rsp != sizeof(struct inquiry_info_with_rssi)) {
-		struct inquiry_info_with_rssi_and_pscan_mode *info;
-		info = (void *) (skb->data + 1);
+	if (skb->len == flex_array_size(ev, res2->info, ev->res2->num)) {
+		struct inquiry_info_rssi_pscan *info;
 
-		if (skb->len < num_rsp * sizeof(*info) + 1)
-			goto unlock;
-
-		for (; num_rsp; num_rsp--, info++) {
+		for (i = 0; i < ev->res2->num; i++) {
 			u32 flags;
 
+			info = &ev->res2->info[i];
 			bacpy(&data.bdaddr, &info->bdaddr);
 			data.pscan_rep_mode	= info->pscan_rep_mode;
 			data.pscan_period_mode	= info->pscan_period_mode;
@@ -4959,15 +4965,13 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
 					  info->dev_class, info->rssi,
 					  flags, NULL, 0, NULL, 0);
 		}
-	} else {
-		struct inquiry_info_with_rssi *info = (void *) (skb->data + 1);
+	} else if (skb->len == flex_array_size(ev, res1->info, ev->res1->num)) {
+		struct inquiry_info_rssi *info;
 
-		if (skb->len < num_rsp * sizeof(*info) + 1)
-			goto unlock;
-
-		for (; num_rsp; num_rsp--, info++) {
+		for (i = 0; i < ev->res1->num; i++) {
 			u32 flags;
 
+			info = &ev->res1->info[i];
 			bacpy(&data.bdaddr, &info->bdaddr);
 			data.pscan_rep_mode	= info->pscan_rep_mode;
 			data.pscan_period_mode	= info->pscan_period_mode;
@@ -4983,9 +4987,11 @@ static void hci_inquiry_result_with_rssi_evt(struct hci_dev *hdev,
 					  info->dev_class, info->rssi,
 					  flags, NULL, 0, NULL, 0);
 		}
+	} else {
+		bt_dev_err(hdev, "Malformed HCI Event: 0x%2.2x",
+			   HCI_EV_INQUIRY_RESULT_WITH_RSSI);
 	}
 
-unlock:
 	hci_dev_unlock(hdev);
 }
 
-- 
2.33.1

