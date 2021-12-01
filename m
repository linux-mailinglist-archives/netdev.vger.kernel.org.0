Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2414643C8
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbhLAAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345570AbhLAAGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69652C061746;
        Tue, 30 Nov 2021 16:03:05 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso19600144pji.0;
        Tue, 30 Nov 2021 16:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TR5msw3HgDvkV0NY0xMd3R5/Y+9WHFDKSZCOK0wsevM=;
        b=pvjqNueXmLUAYX8Z8EGLs0iR5QjuELba1obmq4LE7uPIyPZyd8II6JMAc5JulMgICK
         hB2HPZLQWp9VfpgVIJnsOdmq2VtvOqieA/Xq7jsSC3kfq77i7SsKmMd2zVDpWaUNUzV8
         WTRLib/zUQdLt5Z94fySIY1eQ+NIrMkAqKan+EWe67lAQcHdOoDR8mu2t84RBaIVjw6K
         7FN71mLIUd5LvUtjY5bWHqIPkVy2WMj5RTKj0z/h4rMlwgFeeKjIq7kQBWBM6m/zj+tk
         1gdvqYQVZ4O9pDZg1rrl1P61RnQ5OnxC/eBYRqJAPrEmQF8sSb3BaU6EUH+5Hah1gwN5
         9C/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TR5msw3HgDvkV0NY0xMd3R5/Y+9WHFDKSZCOK0wsevM=;
        b=gyA+yS5cAzn+aV21uu6rtHTGZgC8sbSEQLF8ASpNcvOUqO8QXUWplBQC6CWxTIoJan
         wfS29j+ArNByvminxEabSFR371nTNI0VQV0sAJ9QwDp7WI6lWsohzGFt6GPvUKbF2Gqv
         38lwTOavRLXzouD4SVQ6GvAO4c2DDLd5OxUNaCliOzluMxVQ4h4pjexZGorP1NRqDjnE
         0TjgkRFkBLGaljdI4Nq09XrijYBCQb3wnUT21JW36ZN2PNBB157eyn3BaNEuOUx2t/Dv
         Hp+fDHFsb7cHuTQbFeY9XhWy58uCWhCRjtEMpWSavooTt0wl651XnqcwFe25SZQAsghf
         m6Mw==
X-Gm-Message-State: AOAM5302fdDrGS/WRAdgMiSmR5zpZJDN52QwWAy9N+P3pKQUhZOH1XHD
        qRb37gN9/9yyn5ECFDl13MM=
X-Google-Smtp-Source: ABdhPJygc1qongmt8SQYRDbWVd8IEmqoqMSU18opkYKEkLoUpK6RQqYNMsHEdi34J33YZ/1/+jxx1Q==
X-Received: by 2002:a17:90b:4acd:: with SMTP id mh13mr2939535pjb.230.1638316984802;
        Tue, 30 Nov 2021 16:03:04 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:03:04 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 07/15] Bluetooth: HCI: Use skb_pull_data to parse Extended Inquiry Result event
Date:   Tue, 30 Nov 2021 16:02:07 -0800
Message-Id: <20211201000215.1134831-8-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211201000215.1134831-1-luiz.dentz@gmail.com>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This uses skb_pull_data to check the Extended Inquiry Result events
received have the minimum required length.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
---
 include/net/bluetooth/hci.h |  5 +++++
 net/bluetooth/hci_event.c   | 20 +++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index d25afd92a46e..9e721e6efef3 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -2273,6 +2273,11 @@ struct extended_inquiry_info {
 	__u8     data[240];
 } __packed;
 
+struct hci_ev_ext_inquiry_result {
+	__u8     num;
+	struct extended_inquiry_info info[];
+} __packed;
+
 #define HCI_EV_KEY_REFRESH_COMPLETE	0x30
 struct hci_ev_key_refresh_complete {
 	__u8	status;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6560dca8c5ce..89c263c1883f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5186,14 +5186,23 @@ static inline size_t eir_get_length(u8 *eir, size_t eir_len)
 static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
 					    struct sk_buff *skb)
 {
+	struct hci_ev_ext_inquiry_result *ev;
 	struct inquiry_data data;
-	struct extended_inquiry_info *info = (void *) (skb->data + 1);
-	int num_rsp = *((__u8 *) skb->data);
 	size_t eir_len;
+	int i;
 
-	BT_DBG("%s num_rsp %d", hdev->name, num_rsp);
+	ev = hci_ev_skb_pull(hdev, skb, HCI_EV_EXTENDED_INQUIRY_RESULT,
+			     sizeof(*ev));
+	if (!ev)
+		return;
 
-	if (!num_rsp || skb->len < num_rsp * sizeof(*info) + 1)
+	if (!hci_ev_skb_pull(hdev, skb, HCI_EV_EXTENDED_INQUIRY_RESULT,
+			     flex_array_size(ev, info, ev->num)))
+		return;
+
+	BT_DBG("%s num %d", hdev->name, ev->num);
+
+	if (!ev->num)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_PERIODIC_INQ))
@@ -5201,7 +5210,8 @@ static void hci_extended_inquiry_result_evt(struct hci_dev *hdev,
 
 	hci_dev_lock(hdev);
 
-	for (; num_rsp; num_rsp--, info++) {
+	for (i = 0; i < ev->num; i++) {
+		struct extended_inquiry_info *info = &ev->info[i];
 		u32 flags;
 		bool name_known;
 
-- 
2.33.1

