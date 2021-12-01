Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD08D4643C4
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345671AbhLAAGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345546AbhLAAGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:23 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89651C061746;
        Tue, 30 Nov 2021 16:03:03 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f125so8353783pgc.0;
        Tue, 30 Nov 2021 16:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5vQn+Qe0kMnjkKX/1BwjLPY1a1irRV2Zdg3iTMrOkRw=;
        b=a1CYqNfDaS137pwKKzaCem2gglVjruO7ktMc3Sufos6WSXvveGVvqdIULvYXnvEaTj
         zDb2mIijPGHlPnAFYu+aJx3Lf/L0+rc5DYvJHAfqPtpxxmMDrMZbRnP8pMcWFhULk/q2
         5/OaFHJx9u1cvIEYlvbgVfKS7WmBqKtg9QD3iSmYyi6Lna5kWm799zIK9m1j+/PyBWSn
         hpKbv2VOKlsLbp2YDx/IUO/NWUgCPUMlUTCltBu6KQnbUzXGTKGuF+fXxqcNLGDTjnTS
         CMb9i1uGxdSKxaFLhSIXSopfTMr4gOHG48wTrcTzaiHqZEr6rDh/VEJmaFMPT+T9sn5E
         rKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5vQn+Qe0kMnjkKX/1BwjLPY1a1irRV2Zdg3iTMrOkRw=;
        b=j5kr17O0lnPdnvpou1G870irfzSshgJeC551A6w+jqfvh/BJsv+3wmhmE2lk96dByH
         UE3SnaY7HrZVhbUGF9di9auWFqnC1+ye7M93czhK9w+58YupQEc3GAPoGU94RHGgaVQe
         kVoHM/aX40sEnBNUREi3SLhV52SLtYw3zEkFl7+JzBvqDWIJKGhbhxeDVv3z3osEQJUE
         jJ53pDAtGAQRExZJWXui3GtfiiaxBWSrA2Y5SzXKDoQ02wygW/XCe+/IFgCdYGV8L08N
         e1rxxvanjUogKbIfQdVgL0Vx3mmdD4aBhGYZQJKv6YyGI3l5Q0onsNUPPl5FtVv0FXk9
         yzTw==
X-Gm-Message-State: AOAM5333JV1X+SBySXqgt1z72WYz9TRloKfAgoOxvYV150gtOGWSRG+6
        5kFQWaJ4TQaI0594nukPSTQ=
X-Google-Smtp-Source: ABdhPJyLPcKnhri/Vs8J8iyx2cFM+tleyvPhcU8xA7I7490/19FPr276lXE9nAPfNUDmor8TrhjCfw==
X-Received: by 2002:a05:6a00:1944:b0:438:d002:6e35 with SMTP id s4-20020a056a00194400b00438d0026e35mr2440258pfk.20.1638316982936;
        Tue, 30 Nov 2021 16:03:02 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:02 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 05/15] Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result event
Date:   Tue, 30 Nov 2021 16:02:05 -0800
Message-Id: <20211201000215.1134831-6-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the Inquiry Result events received
have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h |  5 +++++
 net/bluetooth/hci_event.c   | 19 ++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 3f57fd677b67..55466bfb972a 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2028,6 +2028,11 @@ struct inquiry_info {
 	__le16   clock_offset;
 } __packed;
 
+struct hci_ev_inquiry_result {
+	__u8    num;
+	struct inquiry_info info[];
+};
+
 #define HCI_EV_CONN_COMPLETE		0x03
 struct hci_ev_conn_complete {
 	__u8     status;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b27a4ad647ca..0bf062f6f262 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3180,13 +3180,21 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
+	struct hci_ev_inquiry_result *ev;
 	struct inquiry_data data;
-	struct inquiry_info *info = (void *) (skb->data + 1);
-	int num_rsp = *((__u8 *) skb->data);
+	int i;
 
-	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_RESULT, sizeof(*ev));
+	if (!ev)
+		return;
 
-	if (!num_rsp || skb->len < num_rsp * sizeof(*info) + 1)
+	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_INQUIRY_RESULT,
+			     flex_array_size(ev, info, ev->num)))
+		return;
+
+	BT_DBG("%s num %d", hdev->name, ev->num);
+
+	if (!ev->num)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))
@@ -3194,7 +3202,8 @@ static void hci_inquiry_result_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hci_dev_lock(hdev);
 
-	for (; num_rsp; num_rsp--, info++) {
+	for (i = 0; i < ev->num; i++) {
+		struct inquiry_info *info = &ev->info[i];
 		u32 flags;
 
 		bacpy(&data.bdaddr, &info->bdaddr);
-- 
2.33.1

