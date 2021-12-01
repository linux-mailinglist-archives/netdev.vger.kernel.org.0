Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76264643D0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345617AbhLAAGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345596AbhLAAGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:30 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D121C061756;
        Tue, 30 Nov 2021 16:03:09 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so18819197pjb.1;
        Tue, 30 Nov 2021 16:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K0Q/AjPg4LwkcVHvTd078tsJRcQ1xeg7l6PZYQuqunw=;
        b=WbU1ITqH1tiaIbMD4bl1B6A5+smKGv6EiOcy9IpTkXHRwymNZybXjW5E8jcmeA9TJ2
         yHXAZWCGB5tXlt1zNrYVoukhb2oJfTtXkP6c/GXg7WzihL9F9nsdXgKxSWyFQzMLQS+5
         S6vglZxrE7L+n1qKbBGckQ9P2LzKrX7GefdMWL+QQA1XFAa1adurZEFRLlUBI8676IEk
         KluFDnsYhPiv8Pjv9SSLzR1HCf63LpAG9m98wvN4bDhVm6+LXYZul8dWgERIz9okawIn
         kqHPfXH7S2pSSuLEMRdzFuqQKjyFKsvKIc5BiFzMrFlHOmpW2w29Be1VG4mJAJ6maJ7W
         mLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K0Q/AjPg4LwkcVHvTd078tsJRcQ1xeg7l6PZYQuqunw=;
        b=OgHlHygCvKfARltf7HvS8TTwV8rJiUazBbEufqjjKI3DBEh22XscX8m91BqOU1rQfA
         MwXIdmHpXsuC5we8Q5OrPPiVZsc3r95tzZZlhDf01xnesgIGrocfdRIUBqy515HzWTpF
         cr8RNY4BeZIhc4pT+PGAt5pL3o/YDitZi+vpTiGkGVcn7w6PZjkBXYbn3mizQwZcAvIr
         FrQAq1m49NnqejGUs2ixysWqCOBHSsncdSY9S0WRsacc5wINELPvropqZ+fhoA7Vt7rE
         Ki5AgJEE15Zk4gE8USuP0hQCLSFMmtDfRmZodFU/NP3W6RDZDFhvHMorsMx9IsP+o/tx
         k7aA==
X-Gm-Message-State: AOAM531EyBndub6dACU81PRtUk6obiX1lZ0pdV+6NTTxvJqYaRc8XgYJ
        V0J7q3vCIxsgdcTXVVBeoK+KSp0CRBQ=
X-Google-Smtp-Source: ABdhPJzgaIrbYyE2vs0b6m1UGF+hihLQmYMzM6RPffGWCptX+Qd3N/H37zX3zQNX7vCA19UOr62Y7g==
X-Received: by 2002:a17:90b:4f44:: with SMTP id pj4mr2960526pjb.150.1638316988551;
        Tue, 30 Nov 2021 16:03:08 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:08 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 11/15] Bluetooth: HCI: Use skb_pull_data to parse LE Direct Advertising Report event
Date:   Tue, 30 Nov 2021 16:02:11 -0800
Message-Id: <20211201000215.1134831-12-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the LE Direct Advertising Report
events received have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h |  7 ++++++-
 net/bluetooth/hci_event.c   | 26 +++++++++++++++++++-------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index d3f2da9b2ac2..4343f79bd02c 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2500,7 +2500,7 @@ struct hci_ev_le_data_len_change {
 
 #define HCI_EV_LE_DIRECT_ADV_REPORT	0x0B
 struct hci_ev_le_direct_adv_info {
-	__u8	 evt_type;
+	__u8	 type;
 	__u8	 bdaddr_type;
 	bdaddr_t bdaddr;
 	__u8	 direct_addr_type;
@@ -2508,6 +2508,11 @@ struct hci_ev_le_direct_adv_info {
 	__s8	 rssi;
 } __packed;
 
+struct hci_ev_le_direct_adv_report {
+	__u8	 num;
+	struct hci_ev_le_direct_adv_info info[];
+} __packed;
+
 #define HCI_EV_LE_PHY_UPDATE_COMPLETE	0x0c
 struct hci_ev_le_phy_update_complete {
 	__u8  status;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 23cfcb1c0ca3..8f21405997d1 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6881,19 +6881,31 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 static void hci_le_direct_adv_report_evt(struct hci_dev *hdev,
 					 struct sk_buff *skb)
 {
-	u8 num_reports = skb->data[0];
-	struct hci_ev_le_direct_adv_info *ev = (void *)&skb->data[1];
+	struct hci_ev_le_direct_adv_report *ev;
+	int i;
+
+	ev = hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_DIRECT_ADV_REPORT,
+				sizeof(*ev));
+	if (!ev)
+		return;
 
-	if (!num_reports || skb->len < num_reports * sizeof(*ev) + 1)
+	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_DIRECT_ADV_REPORT,
+				flex_array_size(ev, info, ev->num)))
+		return;
+
+	if (!ev->num)
 		return;
 
 	hci_dev_lock(hdev);
 
-	for (; num_reports; num_reports--, ev++)
-		process_adv_report(hdev, ev->evt_type, &ev->bdaddr,
-				   ev->bdaddr_type, &ev->direct_addr,
-				   ev->direct_addr_type, ev->rssi, NULL, 0,
+	for (i = 0; i < ev->num; i++) {
+		struct hci_ev_le_direct_adv_info *info = &ev->info[i];
+
+		process_adv_report(hdev, info->type, &info->bdaddr,
+				   info->bdaddr_type, &info->direct_addr,
+				   info->direct_addr_type, info->rssi, NULL, 0,
 				   false);
+	}
 
 	hci_dev_unlock(hdev);
 }
-- 
2.33.1

