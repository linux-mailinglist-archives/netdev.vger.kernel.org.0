Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB94643CB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345598AbhLAAGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345580AbhLAAG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:29 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFB5C06174A;
        Tue, 30 Nov 2021 16:03:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so19544436pjb.5;
        Tue, 30 Nov 2021 16:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rAgw96mWSTxvK0gyqEQQZc+al2NNhHRrOI3U1Yiwed8=;
        b=dBTD/QMPoS8OZGbjOcnwRWjy5R3oylcokNDgXTgTJV+L0BMEX8eKVF27FVodldn0JI
         hsEp/bMFz0UHzaExEdfgTOmQoXGtB/oeNZAWyd4Xt9HK9SZ6+Oz4pzLztP8ad9pX3A9Y
         Aiq3SSx3cMegWR3FYNsRMmJPCAxf/Eb3txMC3sBPhPXFldTBh7pMBK0uG62HLrPOc3Qi
         RwQ4SWUKNwb9ocfH6j20INfZIqPRfCMuJpz/bxUu+JJKg0B38Dk6E3SpxM7/ykyKkniv
         fJNqxezvIa5i4TfDD3hM7e20uqNuTerzhDL6Pv3nLfetpg4ePJwNJb0im+KtrfNg/nJh
         Towg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rAgw96mWSTxvK0gyqEQQZc+al2NNhHRrOI3U1Yiwed8=;
        b=b6Ymh0F4cO4TcW4nMgC3mGEVXjpyw/NUm65D2lBFEaxN9++nWI2586KWpnimi8t+ja
         h0pmAUYQoKSqv9Bh15DroepUVKZXv//cC32P+WJ2gOm3c3VpgWNffMRlggTTG/6i3U4H
         y78HZNZ40qC7SwoCgJv/IwqNxRYmJs2eq/GdQsdsAQR8MraIydeYOzhiwLJ0KeF9WyD/
         KH0zf+Px0NTUup4LdDYhlVEV54eGoP7iYdhoMuNbLYTtIZNKEUR6kZHTgeVOZ3q5PNu+
         h82Yd3MnU2LelyOB+6zIsZoZukxYMW/KKukXF+TueTYT/kRrXpF+zeZauITEVByLVCTF
         XnoQ==
X-Gm-Message-State: AOAM5323W3bEfEXN6sV0d4dFfjYIGG4sc4ln+yC+1X6uSaQZhIf1pSlO
        0P++WmijujA8XpOoJXpwtM8=
X-Google-Smtp-Source: ABdhPJwzxUAHsrJLqiGYwciSMRm9HvsvVgXoF7kEetjK/Sv7HQSd78Mpsy9tUCyvJcd2caK0F1eBCw==
X-Received: by 2002:a17:90a:7e10:: with SMTP id i16mr2820782pjl.185.1638316987518;
        Tue, 30 Nov 2021 16:03:07 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:07 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 10/15] Bluetooth: HCI: Use skb_pull_data to parse LE Ext Advertising Report event
Date:   Tue, 30 Nov 2021 16:02:10 -0800
Message-Id: <20211201000215.1134831-11-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the LE Extended Advertising Report
events received have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h | 17 +++++++++++------
 net/bluetooth/hci_event.c   | 36 +++++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c005b1ccdbc5..d3f2da9b2ac2 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2517,8 +2517,8 @@ struct hci_ev_le_phy_update_complete {
 } __packed;
 
 #define HCI_EV_LE_EXT_ADV_REPORT    0x0d
-struct hci_ev_le_ext_adv_report {
-	__le16 	 evt_type;
+struct hci_ev_le_ext_adv_info {
+	__le16   type;
 	__u8	 bdaddr_type;
 	bdaddr_t bdaddr;
 	__u8	 primary_phy;
@@ -2526,11 +2526,16 @@ struct hci_ev_le_ext_adv_report {
 	__u8	 sid;
 	__u8	 tx_power;
 	__s8	 rssi;
-	__le16 	 interval;
-	__u8  	 direct_addr_type;
+	__le16   interval;
+	__u8     direct_addr_type;
 	bdaddr_t direct_addr;
-	__u8  	 length;
-	__u8	 data[];
+	__u8     length;
+	__u8     data[];
+} __packed;
+
+struct hci_ev_le_ext_adv_report {
+	__u8     num;
+	struct hci_ev_le_ext_adv_info info[];
 } __packed;
 
 #define HCI_EV_LE_ENHANCED_CONN_COMPLETE    0x0a
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 42ffd5df6d4b..23cfcb1c0ca3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6649,26 +6649,40 @@ static u8 ext_evt_type_to_legacy(struct hci_dev *hdev, u16 evt_type)
 
 static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	u8 num_reports = skb->data[0];
-	void *ptr = &skb->data[1];
+	struct hci_ev_le_ext_adv_report *ev;
+
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_REPORT,
+				sizeof(*ev));
+	if (!ev)
+		return;
+
+	if (!ev->num)
+		return;
 
 	hci_dev_lock(hdev);
 
-	while (num_reports--) {
-		struct hci_ev_le_ext_adv_report *ev = ptr;
+	while (ev->num--) {
+		struct hci_ev_le_ext_adv_info *info;
 		u8 legacy_evt_type;
 		u16 evt_type;
 
-		evt_type = __le16_to_cpu(ev->evt_type);
+		info = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_REPORT,
+					  sizeof(*info));
+		if (!info)
+			break;
+
+		if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_EXT_ADV_REPORT,
+					info->length))
+			break;
+
+		evt_type = __le16_to_cpu(info->type);
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
 		if (legacy_evt_type != LE_ADV_INVALID) {
-			process_adv_report(hdev, legacy_evt_type, &ev->bdaddr,
-					   ev->bdaddr_type, NULL, 0, ev->rssi,
-					   ev->data, ev->length,
+			process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
+					   info->bdaddr_type, NULL, 0,
+					   info->rssi, info->data, info->length,
 					   !(evt_type & LE_EXT_ADV_LEGACY_PDU));
 		}
-
-		ptr += sizeof(*ev) + ev->length;
 	}
 
 	hci_dev_unlock(hdev);
@@ -7019,7 +7033,7 @@ static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
 {
 	struct hci_ev_le_advertising_info *adv;
 	struct hci_ev_le_direct_adv_info *direct_adv;
-	struct hci_ev_le_ext_adv_report *ext_adv;
+	struct hci_ev_le_ext_adv_info *ext_adv;
 	const struct hci_ev_conn_complete *conn_complete = (void *)skb->data;
 	const struct hci_ev_conn_request *conn_request = (void *)skb->data;
 
-- 
2.33.1

