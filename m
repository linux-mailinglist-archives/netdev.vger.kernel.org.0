Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BEE4643CE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345754AbhLAAGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345557AbhLAAG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:29 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE48C061746;
        Tue, 30 Nov 2021 16:03:07 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id r130so22397526pfc.1;
        Tue, 30 Nov 2021 16:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rGmuzjNWCJwSMo2crUTDHRKMD3or9KnZlwBZfVFowyQ=;
        b=gwqHOOlAVJb/e8VQWi2S896HtsQ2D/O6ZikTztKgPh2C9kOp6QbapjXcUnRmMAOMRY
         tSi14pVj+e6JeYGQhOO3q8NEb5rpvIj4BoA45ZD9KtdogCtKK6c6uGlpIGRS0PfXmqid
         TR3fVyaOl5h6ldwegHtmnmfMZPyUOlNnbzjOGnF/AEicXxvuTwhvPuqHe88I9Kqmhxdg
         CQPq6qv3awHcPlOHVeJVW5+tZsjADnHFna/dk3w8j26X9bpSLbzNwg8YNtRaYIb0R9D5
         Yl9M0SmE+mR6LdN7sLF6rTtSsOcmQRRu4KDQxRwHixx8FQL5BSW07k4HGp1Prqe6Tt7Z
         5l1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rGmuzjNWCJwSMo2crUTDHRKMD3or9KnZlwBZfVFowyQ=;
        b=WxIXMFoGa/vKZuTvcp6dPvXgeBJWOgiu5+Tfu9S0mRL33gFB967XtZa+VwAsDAa3O6
         b+gta2KVcsSMRuuI9l0M4Yt1/k0wQM4rGvLUGEkGJmVx/xjHMBz4C6gQxLavAFUczYpx
         XSMMHzyU5JB6QPrVbajBXB875IzWj9etmlZ0A61FR/KChEorIOamBdZOTmYl7TimsFDe
         z5l6QMbjbnwA/pOElXyfuU/mNP0OppPKSa+eP3IrNlGunUbOMrGHzcpZA6C+fDO2OAB1
         rK7uXQUrc230i0vQYYTWgThDzSqXUzRgL1hH0oSh5gQhBxqyYS/2+AcTVToZWQH1ehU9
         wr4Q==
X-Gm-Message-State: AOAM532m+Oziux9bji9q8IvPQLWBsy9/JGoiskYhPR2So7pX5T7TkHMv
        f1HjK4HnnHp+eauJ2tbbG8E=
X-Google-Smtp-Source: ABdhPJw9Y84a0L+Q+aieI68sb4qCC2ILrv0RqS2/lClt3NhwGAfjBXGbyZLmPBdNpyXA/JsHBYFGuA==
X-Received: by 2002:a63:a51e:: with SMTP id n30mr1914069pgf.594.1638316986642;
        Tue, 30 Nov 2021 16:03:06 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:06 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 09/15] Bluetooth: HCI: Use skb_pull_data to parse LE Advertising Report event
Date:   Tue, 30 Nov 2021 16:02:09 -0800
Message-Id: <20211201000215.1134831-10-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the LE Advertising Report events
received have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h |  7 ++++++-
 net/bluetooth/hci_event.c   | 39 +++++++++++++++++++++++--------------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 9e721e6efef3..c005b1ccdbc5 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2445,13 +2445,18 @@ struct hci_ev_le_conn_complete {
 
 #define HCI_EV_LE_ADVERTISING_REPORT	0x02
 struct hci_ev_le_advertising_info {
-	__u8	 evt_type;
+	__u8	 type;
 	__u8	 bdaddr_type;
 	bdaddr_t bdaddr;
 	__u8	 length;
 	__u8	 data[];
 } __packed;
 
+struct hci_ev_le_advertising_report {
+	__u8    num;
+	struct hci_ev_le_advertising_info info[];
+} __packed;
+
 #define HCI_EV_LE_CONN_UPDATE_COMPLETE	0x03
 struct hci_ev_le_conn_update_complete {
 	__u8     status;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d30e77f66376..42ffd5df6d4b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6564,31 +6564,40 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 
 static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	u8 num_reports = skb->data[0];
-	void *ptr = &skb->data[1];
+	struct hci_ev_le_advertising_report *ev;
+
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_ADVERTISING_REPORT,
+				sizeof(*ev));
+	if (!ev)
+		return;
+
+	if (!ev->num)
+		return;
 
 	hci_dev_lock(hdev);
 
-	while (num_reports--) {
-		struct hci_ev_le_advertising_info *ev = ptr;
+	while (ev->num--) {
+		struct hci_ev_le_advertising_info *info;
 		s8 rssi;
 
-		if (ptr > (void *)skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data.");
+		info = hci_le_ev_skb_pull(hdev, skb,
+					  HCI_EV_LE_ADVERTISING_REPORT,
+					  sizeof(*info));
+		if (!info)
 			break;
-		}
 
-		if (ev->length <= HCI_MAX_AD_LENGTH &&
-		    ev->data + ev->length <= skb_tail_pointer(skb)) {
-			rssi = ev->data[ev->length];
-			process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
-					   ev->bdaddr_type, NULL, 0, rssi,
-					   ev->data, ev->length, false);
+		if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_ADVERTISING_REPORT,
+					info->length + 1))
+			break;
+
+		if (info->length <= HCI_MAX_AD_LENGTH) {
+			rssi = info->data[info->length];
+			process_adv_report(hdev, info->type, &info->bdaddr,
+					   info->bdaddr_type, NULL, 0, rssi,
+					   info->data, info->length, false);
 		} else {
 			bt_dev_err(hdev, "Dropping invalid advertising data");
 		}
-
-		ptr += sizeof(*ev) + ev->length + 1;
 	}
 
 	hci_dev_unlock(hdev);
-- 
2.33.1

