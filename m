Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675B04643C9
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345723AbhLAAGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345576AbhLAAG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:26 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451BDC061574;
        Tue, 30 Nov 2021 16:03:06 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n85so22305108pfd.10;
        Tue, 30 Nov 2021 16:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8WbgfQy9Pg3s7B9vf/AWyt49WCqLJiGtD+eFrFA9TAc=;
        b=U8smHx1QFpq+b2fcqHWsOal6+fqFPrzk6mY1c/epVgN9Fk4BSsPu5TOWvnkiE6IXed
         0CtYuQanaynRoJkX4kc2ug19ud7hM3qh+q6H3y5LjgII25tX8lgAL7nLEbtSuz0l4pE4
         /GuGsCpWfIA9jSxmVgt+faW95noVItNbVATC7XeqzdoryLo8xdilEbYOUID8/3q1oEY7
         7qw1skQ69tJUyQKeVIWt0yq+1AnpaRmzQRybr/MNo2R1J5ccP26g54ASuE4D7c6YvMrK
         WhM4F6rMsHvc5VeHmVSWkAFMilNxdrac9pUM2DuTUBq9u69ucoDfqb9xLSm4UNHQ74Wh
         BYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8WbgfQy9Pg3s7B9vf/AWyt49WCqLJiGtD+eFrFA9TAc=;
        b=1IinZ69LnX8f6Isq5L6I8UpNdBlxVwBW9FvSGJ8PJkkFCM0pcv/1qpdTD6nfSwNRCV
         EQnmWSegD6qPitGNx5ZzFq0T/Qxpw7ggcW4hjbN8wVEaMNutCmy1PEoO9u1i2amUZB6P
         +QqDe9EaakOFUKxlwgd9mFJRsBSGPTfNTi2m0+Xa2Es1+19TM+3e+uPI60CbQX7CWNuQ
         MVWW5GvTLEw4KPg5TTRMl7mNLgjh4ImX1p8bVfLL9DwJ0d9OxTRK6pLaS4WocbmvkZvS
         e7h0cVxgAxCdZQGNYyNykFEFv+t5xEX7KjxPJFvRY19KYq5zRhE/jszwcA90n5ICM+ot
         1dTw==
X-Gm-Message-State: AOAM533NtVGwedAWVxxzB0MN2TOIdxoyeZK1nLaZoiiDJQ/zN+YV3ghH
        h7W4acbj00xEqNgy0vqACxw=
X-Google-Smtp-Source: ABdhPJz9v8b0G49tqvcAIlamB6Wnrh+HppebbKf1SUwhuDYgr4ubJ1WZXO4Xs+WxZKtnfQNUPuZGaw==
X-Received: by 2002:a63:2b03:: with SMTP id r3mr1918126pgr.328.1638316985669;
        Tue, 30 Nov 2021 16:03:05 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:05 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 08/15] Bluetooth: HCI: Use skb_pull_data to parse LE Metaevents
Date:   Tue, 30 Nov 2021 16:02:08 -0800
Message-Id: <20211201000215.1134831-9-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the LE Metaevents received have the
minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 net/bluetooth/hci_event.c | 75 +++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 89c263c1883f..d30e77f66376 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -69,6 +69,18 @@ static void *hci_cc_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
 	return data;
 }
 
+static void *hci_le_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
+				u8 ev, size_t len)
+{
+	void *data;
+
+	data = skb_pull_data(skb, len);
+	if (!data)
+		bt_dev_err(hdev, "Malformed LE Event: 0x%2.2x", ev);
+
+	return data;
+}
+
 static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb,
 				  u8 *new_status)
 {
@@ -6119,7 +6131,12 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 
 static void hci_le_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_le_conn_complete *ev = (void *) skb->data;
+	struct hci_ev_le_conn_complete *ev;
+
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_CONN_COMPLETE,
+				sizeof(*ev));
+	if (!ev)
+		return;
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
@@ -6133,7 +6150,12 @@ static void hci_le_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_le_enh_conn_complete *ev = (void *) skb->data;
+	struct hci_ev_le_enh_conn_complete *ev;
+
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_ENHANCED_CONN_COMPLETE,
+				sizeof(*ev));
+	if (!ev)
+		return;
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
@@ -6146,10 +6168,15 @@ static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev,
 
 static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_evt_le_ext_adv_set_term *ev = (void *) skb->data;
+	struct hci_evt_le_ext_adv_set_term *ev;
 	struct hci_conn *conn;
 	struct adv_info *adv, *n;
 
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_SET_TERM,
+				sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	adv = hci_find_adv_instance(hdev, ev->handle);
@@ -6211,9 +6238,14 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_le_conn_update_complete_evt(struct hci_dev *hdev,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_le_conn_update_complete *ev = (void *) skb->data;
+	struct hci_ev_le_conn_update_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_CONN_UPDATE_COMPLETE,
+				sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	if (ev->status)
@@ -6636,9 +6668,14 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_le_remote_feat_complete *ev = (void *)skb->data;
+	struct hci_ev_le_remote_feat_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_REPORT,
+				sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	hci_dev_lock(hdev);
@@ -6677,12 +6714,16 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev,
 
 static void hci_le_ltk_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_le_ltk_req *ev = (void *) skb->data;
+	struct hci_ev_le_ltk_req *ev;
 	struct hci_cp_le_ltk_reply cp;
 	struct hci_cp_le_ltk_neg_reply neg;
 	struct hci_conn *conn;
 	struct smp_ltk *ltk;
 
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_LTK_REQ, sizeof(*ev));
+	if (!ev)
+		return;
+
 	BT_DBG("%s handle 0x%4.4x", hdev->name, __le16_to_cpu(ev->handle));
 
 	hci_dev_lock(hdev);
@@ -6754,11 +6795,16 @@ static void send_conn_param_neg_reply(struct hci_dev *hdev, u16 handle,
 static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_le_remote_conn_param_req *ev = (void *) skb->data;
+	struct hci_ev_le_remote_conn_param_req *ev;
 	struct hci_cp_le_conn_param_req_reply cp;
 	struct hci_conn *hcon;
 	u16 handle, min, max, latency, timeout;
 
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_REMOTE_CONN_PARAM_REQ,
+				sizeof(*ev));
+	if (!ev)
+		return;
+
 	handle = le16_to_cpu(ev->handle);
 	min = le16_to_cpu(ev->interval_min);
 	max = le16_to_cpu(ev->interval_max);
@@ -6831,9 +6877,14 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 
 static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_le_phy_update_complete *ev = (void *) skb->data;
+	struct hci_ev_le_phy_update_complete *ev;
 	struct hci_conn *conn;
 
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PHY_UPDATE_COMPLETE,
+				sizeof(*ev));
+	if (ev)
+		return;
+
 	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
 
 	if (ev->status)
@@ -6854,11 +6905,13 @@ static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_le_meta_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_ev_le_meta *le_ev = (void *) skb->data;
+	struct hci_ev_le_meta *ev;
 
-	skb_pull(skb, sizeof(*le_ev));
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_LE_META, sizeof(*ev));
+	if (!ev)
+		return;
 
-	switch (le_ev->subevent) {
+	switch (ev->subevent) {
 	case HCI_EV_LE_CONN_COMPLETE:
 		hci_le_conn_complete_evt(hdev, skb);
 		break;
-- 
2.33.1

