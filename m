Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A226E4643D3
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345824AbhLAAHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345692AbhLAAGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:46 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6E8C061759;
        Tue, 30 Nov 2021 16:03:11 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p13so14671376pfw.2;
        Tue, 30 Nov 2021 16:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B8hQmQlDkJwGXZMc+gnEQsV52++miiDJSKCy1U61Vp8=;
        b=faL8DqKtefXoBDQqmS0FyfcUHviO/4iEuHXkBb8YprAWpPykxnQBFNS3tw17DBpJ2l
         W9jRPilzwv5hiVsVtfb153RLC8hTfnVa8XNjBIrJ9zHOoKoU0SRf7CxS4isVKn8GtAWL
         g4oZBUoIVKKZjRlxCOjBjZpBtzcs286i9lpIEqXo+ary4MEoziwCOGRPls9CL3X0DwtF
         f1h5PgS3JuvOpu5X2ORDlJY+9z4HDxLImR51KFScjzPp21aOOBr6rJJA52k0+6YcaSxh
         X6DYPd92jfIv+fRn048m7igIckhki69KIqLgAUzh5yZIjWJVEZ9AVenPcfz3XaHEeC47
         A62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B8hQmQlDkJwGXZMc+gnEQsV52++miiDJSKCy1U61Vp8=;
        b=zsALW2CMpRYt2d67TKmHKuTXI2aU+KQxpwB+W+nzJeHY14+YzKgVKBeE2owZ803pSf
         gc2xC/qhvxpD9nyiuyMoCGH5eLQYCHWd2RMcLRLnqXa44JtFLGPebziyi2n+Xh+64NZE
         /MXWiYQzefhkLuZMPm5cSiNeaAPruME+a63dJoN7RTIDMtysCk+vUKt8SM4bRIIaUlg5
         IsabnTvPpwkifI00/AFda/Xcza+NPErPMS5MlyEuAf6luN895qkaG98JTznw7XUBdbHO
         CMX6v4uP/GrTg976sLGTfVSOPXqR2fgY2Mw2Yq3WYrgRTvyhXdbx6yBRc5aCF9pZqqCN
         RJZA==
X-Gm-Message-State: AOAM530R3jBSS5uQyIRH5Sk/u3eoB/P2R+B+rhfc5sS91dNkd2YI6yRD
        uVJ31VK9aXemGDO4ANj+Vg8=
X-Google-Smtp-Source: ABdhPJyd5wegETtOTUNBrJBBqXg2gOyX8HZr+SKXol2oXEHpjCWcP4LOx+cf6uqo+V+bXOY27ESf/A==
X-Received: by 2002:a63:3fc3:: with SMTP id m186mr1966543pga.378.1638316990805;
        Tue, 30 Nov 2021 16:03:10 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:10 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 13/15] Bluetooth: hci_event: Use of a function table to handle LE subevents
Date:   Tue, 30 Nov 2021 16:02:13 -0800
Message-Id: <20211201000215.1134831-14-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This change the use of switch statement to a function table which is
easier to extend and can include min/max length of each subevent.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 net/bluetooth/hci_event.c | 247 +++++++++++++++++++-------------------
 1 file changed, 122 insertions(+), 125 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6fbb16997849..c39f5ea1736a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5969,16 +5969,12 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_le_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_conn_complete_evt(struct hci_dev *hdev, void *data,
+				     struct sk_buff *skb)
 {
-	struct hci_ev_le_conn_complete *ev;
-
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_CONN_COMPLETE,
-				sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_le_conn_complete *ev = data;
 
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	le_conn_complete_evt(hdev, ev->status, &ev->bdaddr, ev->bdaddr_type,
 			     NULL, ev->role, le16_to_cpu(ev->handle),
@@ -5987,17 +5983,12 @@ static void hci_le_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 			     le16_to_cpu(ev->supervision_timeout));
 }
 
-static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev,
+static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_le_enh_conn_complete *ev;
+	struct hci_ev_le_enh_conn_complete *ev = data;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_ENHANCED_CONN_COMPLETE,
-				sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	le_conn_complete_evt(hdev, ev->status, &ev->bdaddr, ev->bdaddr_type,
 			     &ev->local_rpa, ev->role, le16_to_cpu(ev->handle),
@@ -6006,18 +5997,14 @@ static void hci_le_enh_conn_complete_evt(struct hci_dev *hdev,
 			     le16_to_cpu(ev->supervision_timeout));
 }
 
-static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, void *data,
+				    struct sk_buff *skb)
 {
-	struct hci_evt_le_ext_adv_set_term *ev;
+	struct hci_evt_le_ext_adv_set_term *ev = data;
 	struct hci_conn *conn;
 	struct adv_info *adv, *n;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_SET_TERM,
-				sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	adv = hci_find_adv_instance(hdev, ev->handle);
 
@@ -6075,18 +6062,13 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	}
 }
 
-static void hci_le_conn_update_complete_evt(struct hci_dev *hdev,
+static void hci_le_conn_update_complete_evt(struct hci_dev *hdev, void *data,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_le_conn_update_complete *ev;
+	struct hci_ev_le_conn_update_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_CONN_UPDATE_COMPLETE,
-				sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	if (ev->status)
 		return;
@@ -6402,14 +6384,10 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 	clear_pending_adv_report(hdev);
 }
 
-static void hci_le_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_le_advertising_report *ev;
-
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_ADVERTISING_REPORT,
-				sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_le_advertising_report *ev = data;
 
 	if (!ev->num)
 		return;
@@ -6487,14 +6465,10 @@ static u8 ext_evt_type_to_legacy(struct hci_dev *hdev, u16 evt_type)
 	return LE_ADV_INVALID;
 }
 
-static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
+				      struct sk_buff *skb)
 {
-	struct hci_ev_le_ext_adv_report *ev;
-
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_REPORT,
-				sizeof(*ev));
-	if (!ev)
-		return;
+	struct hci_ev_le_ext_adv_report *ev = data;
 
 	if (!ev->num)
 		return;
@@ -6528,18 +6502,13 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev,
+static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev, void *data,
 					    struct sk_buff *skb)
 {
-	struct hci_ev_le_remote_feat_complete *ev;
+	struct hci_ev_le_remote_feat_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_REPORT,
-				sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	hci_dev_lock(hdev);
 
@@ -6575,19 +6544,16 @@ static void hci_le_remote_feat_complete_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_le_ltk_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_ltk_request_evt(struct hci_dev *hdev, void *data,
+				   struct sk_buff *skb)
 {
-	struct hci_ev_le_ltk_req *ev;
+	struct hci_ev_le_ltk_req *ev = data;
 	struct hci_cp_le_ltk_reply cp;
 	struct hci_cp_le_ltk_neg_reply neg;
 	struct hci_conn *conn;
 	struct smp_ltk *ltk;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_LTK_REQ, sizeof(*ev));
-	if (!ev)
-		return;
-
-	BT_DBG("%s handle 0x%4.4x", hdev->name, __le16_to_cpu(ev->handle));
+	bt_dev_dbg(hdev, "handle 0x%4.4x", __le16_to_cpu(ev->handle));
 
 	hci_dev_lock(hdev);
 
@@ -6655,18 +6621,15 @@ static void send_conn_param_neg_reply(struct hci_dev *hdev, u16 handle,
 		     &cp);
 }
 
-static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
+static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev, void *data,
 					     struct sk_buff *skb)
 {
-	struct hci_ev_le_remote_conn_param_req *ev;
+	struct hci_ev_le_remote_conn_param_req *ev = data;
 	struct hci_cp_le_conn_param_req_reply cp;
 	struct hci_conn *hcon;
 	u16 handle, min, max, latency, timeout;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_REMOTE_CONN_PARAM_REQ,
-				sizeof(*ev));
-	if (!ev)
-		return;
+	bt_dev_dbg(hdev, "handle 0x%4.4x", __le16_to_cpu(ev->handle));
 
 	handle = le16_to_cpu(ev->handle);
 	min = le16_to_cpu(ev->interval_min);
@@ -6718,17 +6681,12 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 	hci_send_cmd(hdev, HCI_OP_LE_CONN_PARAM_REQ_REPLY, sizeof(cp), &cp);
 }
 
-static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
+static void hci_le_direct_adv_report_evt(struct hci_dev *hdev, void *data,
 					 struct sk_buff *skb)
 {
-	struct hci_ev_le_direct_adv_report *ev;
+	struct hci_ev_le_direct_adv_report *ev = data;
 	int i;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_DIRECT_ADV_REPORT,
-				sizeof(*ev));
-	if (!ev)
-		return;
-
 	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_DIRECT_ADV_REPORT,
 				flex_array_size(ev, info, ev->num)))
 		return;
@@ -6750,17 +6708,13 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
+static void hci_le_phy_update_evt(struct hci_dev *hdev, void *data,
+				  struct sk_buff *skb)
 {
-	struct hci_ev_le_phy_update_complete *ev;
+	struct hci_ev_le_phy_update_complete *ev = data;
 	struct hci_conn *conn;
 
-	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PHY_UPDATE_COMPLETE,
-				sizeof(*ev));
-	if (ev)
-		return;
-
-	BT_DBG("%s status 0x%2.2x", hdev->name, ev->status);
+	bt_dev_dbg(hdev, "status 0x%2.2x", ev->status);
 
 	if (ev->status)
 		return;
@@ -6778,59 +6732,102 @@ static void hci_le_phy_update_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_unlock(hdev);
 }
 
-static void hci_le_meta_evt(struct hci_dev *hdev, void *data,
-			    struct sk_buff *skb)
-{
-	struct hci_ev_le_meta *ev = data;
-
-	switch (ev->subevent) {
-	case HCI_EV_LE_CONN_COMPLETE:
-		hci_le_conn_complete_evt(hdev, skb);
-		break;
-
-	case HCI_EV_LE_CONN_UPDATE_COMPLETE:
-		hci_le_conn_update_complete_evt(hdev, skb);
-		break;
+#define HCI_LE_EV_VL(_op, _func, _min_len, _max_len) \
+[_op] = { \
+	.func = _func, \
+	.min_len = _min_len, \
+	.max_len = _max_len, \
+}
 
-	case HCI_EV_LE_ADVERTISING_REPORT:
-		hci_le_adv_report_evt(hdev, skb);
-		break;
+#define HCI_LE_EV(_op, _func, _len) \
+	HCI_LE_EV_VL(_op, _func, _len, _len)
 
-	case HCI_EV_LE_REMOTE_FEAT_COMPLETE:
-		hci_le_remote_feat_complete_evt(hdev, skb);
-		break;
+#define HCI_LE_EV_STATUS(_op, _func) \
+	HCI_LE_EV(_op, _func, sizeof(struct hci_ev_status))
 
-	case HCI_EV_LE_LTK_REQ:
-		hci_le_ltk_request_evt(hdev, skb);
-		break;
+/* Entries in this table shall have their position according to the subevent
+ * opcode they handle so the use of the macros above is recommend since it does
+ * attempt to initialize at its proper index using Designated Initializers that
+ * way events without a callback function can be ommited.
+ */
+static const struct hci_le_ev {
+	void (*func)(struct hci_dev *hdev, void *data, struct sk_buff *skb);
+	u16  min_len;
+	u16  max_len;
+} hci_le_ev_table[U8_MAX + 1] = {
+	/* [0x01 = HCI_EV_LE_CONN_COMPLETE] */
+	HCI_LE_EV(HCI_EV_LE_CONN_COMPLETE, hci_le_conn_complete_evt,
+		  sizeof(struct hci_ev_le_conn_complete)),
+	/* [0x02 = HCI_EV_LE_ADVERTISING_REPORT] */
+	HCI_LE_EV_VL(HCI_EV_LE_ADVERTISING_REPORT, hci_le_adv_report_evt,
+		     sizeof(struct hci_ev_le_advertising_report),
+		     HCI_MAX_EVENT_SIZE),
+	/* [0x03 = HCI_EV_LE_CONN_UPDATE_COMPLETE] */
+	HCI_LE_EV(HCI_EV_LE_CONN_UPDATE_COMPLETE,
+		  hci_le_conn_update_complete_evt,
+		  sizeof(struct hci_ev_le_conn_update_complete)),
+	/* [0x04 = HCI_EV_LE_REMOTE_FEAT_COMPLETE] */
+	HCI_LE_EV(HCI_EV_LE_REMOTE_FEAT_COMPLETE,
+		  hci_le_remote_feat_complete_evt,
+		  sizeof(struct hci_ev_le_remote_feat_complete)),
+	/* [0x05 = HCI_EV_LE_LTK_REQ] */
+	HCI_LE_EV(HCI_EV_LE_LTK_REQ, hci_le_ltk_request_evt,
+		  sizeof(struct hci_ev_le_ltk_req)),
+	/* [0x06 = HCI_EV_LE_REMOTE_CONN_PARAM_REQ] */
+	HCI_LE_EV(HCI_EV_LE_REMOTE_CONN_PARAM_REQ,
+		  hci_le_remote_conn_param_req_evt,
+		  sizeof(struct hci_ev_le_remote_conn_param_req)),
+	/* [0x0a = HCI_EV_LE_ENHANCED_CONN_COMPLETE] */
+	HCI_LE_EV(HCI_EV_LE_ENHANCED_CONN_COMPLETE,
+		  hci_le_enh_conn_complete_evt,
+		  sizeof(struct hci_ev_le_enh_conn_complete)),
+	/* [0x0b = HCI_EV_LE_DIRECT_ADV_REPORT] */
+	HCI_LE_EV_VL(HCI_EV_LE_DIRECT_ADV_REPORT, hci_le_direct_adv_report_evt,
+		     sizeof(struct hci_ev_le_direct_adv_report),
+		     HCI_MAX_EVENT_SIZE),
+	/* [0x0c = HCI_EV_LE_PHY_UPDATE_COMPLETE] */
+	HCI_LE_EV(HCI_EV_LE_PHY_UPDATE_COMPLETE, hci_le_phy_update_evt,
+		  sizeof(struct hci_ev_le_phy_update_complete)),
+	/* [0x0d = HCI_EV_LE_EXT_ADV_REPORT] */
+	HCI_LE_EV_VL(HCI_EV_LE_EXT_ADV_REPORT, hci_le_ext_adv_report_evt,
+		     sizeof(struct hci_ev_le_ext_adv_report),
+		     HCI_MAX_EVENT_SIZE),
+	/* [0x12 = HCI_EV_LE_EXT_ADV_SET_TERM] */
+	HCI_LE_EV(HCI_EV_LE_EXT_ADV_SET_TERM, hci_le_ext_adv_term_evt,
+		  sizeof(struct hci_evt_le_ext_adv_set_term)),
+};
 
-	case HCI_EV_LE_REMOTE_CONN_PARAM_REQ:
-		hci_le_remote_conn_param_req_evt(hdev, skb);
-		break;
+static void hci_le_meta_evt(struct hci_dev *hdev, void *data,
+			    struct sk_buff *skb)
+{
+	struct hci_ev_le_meta *ev = data;
+	const struct hci_le_ev *subev;
 
-	case HCI_EV_LE_DIRECT_ADV_REPORT:
-		hci_le_direct_adv_report_evt(hdev, skb);
-		break;
+	bt_dev_dbg(hdev, "subevent 0x%2.2x", ev->subevent);
 
-	case HCI_EV_LE_PHY_UPDATE_COMPLETE:
-		hci_le_phy_update_evt(hdev, skb);
-		break;
+	subev = &hci_le_ev_table[ev->subevent];
+	if (!subev->func)
+		return;
 
-	case HCI_EV_LE_EXT_ADV_REPORT:
-		hci_le_ext_adv_report_evt(hdev, skb);
-		break;
+	if (skb->len < subev->min_len) {
+		bt_dev_err(hdev, "unexpected subevent 0x%2.2x length: %u < %u",
+			   ev->subevent, skb->len, subev->min_len);
+		return;
+	}
 
-	case HCI_EV_LE_ENHANCED_CONN_COMPLETE:
-		hci_le_enh_conn_complete_evt(hdev, skb);
-		break;
+	/* Just warn if the length is over max_len size it still be
+	 * possible to partially parse the event so leave to callback to
+	 * decide if that is acceptable.
+	 */
+	if (skb->len > subev->max_len)
+		bt_dev_warn(hdev, "unexpected subevent 0x%2.2x length: %u > %u",
+			    ev->subevent, skb->len, subev->max_len);
 
-	case HCI_EV_LE_EXT_ADV_SET_TERM:
-		hci_le_ext_adv_term_evt(hdev, skb);
-		break;
+	data = hci_le_ev_skb_pull(hdev, skb, ev->subevent, subev->min_len);
+	if (!data)
+		return;
 
-	default:
-		break;
-	}
+	subev->func(hdev, data, skb);
 }
 
 static bool hci_get_cmd_complete(struct hci_dev *hdev, u16 opcode,
-- 
2.33.1

