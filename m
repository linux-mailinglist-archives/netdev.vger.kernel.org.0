Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6076E26E84A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgIQWW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIQWWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 18:22:38 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400DEC061788
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 15:22:38 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id j35so3136447qtk.14
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 15:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IaJ7+vsFyvrnLSPfue9ByLmu7bRRks/6xUYOpfJTdBM=;
        b=HjpZ03rr6c+5GqAa6ALQLVZe20uBr6rmFeyEfwkNwc1jUyv5Z24h0862guJtd4l53M
         xrs0+QluQQtaKYSCff4Z4wjMnYQ1k+Em6K+OO9Yx1CDxgQUlrPkIf+44MtnWrOgDY0FY
         BnHEDFNi70Oh1Ig05b7A3LYsWYx2MDFWOg8TQVRvyPjSPBabbetD2J0TmcEFLJKPXZO3
         2Eo88P3iFD8MxZnI7el4tM96cAyD4C+GkLER/QnVRNsbvRiFK6GoKis/HIf89+w9KVf4
         6KOmZu9gWEaXyJovkmgYmvhorctZsgsZrwKQXqABH/c18seDirVf0NWBQJI/uU54WKzd
         tdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IaJ7+vsFyvrnLSPfue9ByLmu7bRRks/6xUYOpfJTdBM=;
        b=KwqlYaECV+OIPmJdthE3SPz82zyXqc4k6SvQ+M9CPCEYvKFO4lUqw/RJbHxe2bNDQo
         3LnK86v2mc49xR2FPyxWIS212ELJ7YWt7lPIhHnMDDWZ63Jj6u3gqbyw9qjJVDsldvMt
         kz/0Zv7TIQHwvZ3pLofqgJX2NAhm+nIskxCexC2Gw/aEIPKCymNVvc+4I/NHgAq6oJ9C
         YXCBOfgki7TiA+NiXVTnMdG4HVG+ENI9JzZj8Rayz3QEKyW17gF0JjIqD6/KZauOE2mr
         l1I5McNiXYa1KhtNjG/kM7JilrEm11pvMolnoQrFl2S6QLBTTvg6nYpnT1U+IsanrLQK
         AQ5g==
X-Gm-Message-State: AOAM531Zo/xnf1LfEE6vkghq4usDV4+8rYdoqp9KrQrRmdzwPcR6jkYV
        xliN3ZKbYx5fRc9VnnBL+am9/4vLUkbK0hf//nvX
X-Google-Smtp-Source: ABdhPJxO04i6TgoP1lLH0ob3dEGaTPbQWTgn04wotZaWZPj/xXlqEtFTx9ZyI4mTjtBNs67uGrvrNjaLcprBSDWSWQLg
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a05:6214:c2:: with SMTP id
 f2mr14131052qvs.44.1600381357429; Thu, 17 Sep 2020 15:22:37 -0700 (PDT)
Date:   Thu, 17 Sep 2020 15:22:16 -0700
In-Reply-To: <20200917222217.2534502-1-danielwinkler@google.com>
Message-Id: <20200917152052.v2.5.Ibedcb7af24f1c01a680de4cc8cc5a98951588393@changeid>
Mime-Version: 1.0
References: <20200917222217.2534502-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v2 5/6] Bluetooth: Query LE tx power on startup
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Queries tx power via HCI_LE_Read_Transmit_Power command when the hci
device is initialized, and stores resulting min/max LE power in hdev
struct. If command isn't available (< BT5 support), min/max values
both default to HCI_TX_POWER_INVALID.

This patch is manually verified by ensuring BT5 devices correctly query
and receive controller tx power range.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

Changes in v2: None

 include/net/bluetooth/hci.h      |  7 +++++++
 include/net/bluetooth/hci_core.h |  2 ++
 net/bluetooth/hci_core.c         |  8 ++++++++
 net/bluetooth/hci_event.c        | 18 ++++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c8e67042a3b14c..c1504aa3d9cfd5 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1797,6 +1797,13 @@ struct hci_cp_le_set_adv_set_rand_addr {
 	bdaddr_t  bdaddr;
 } __packed;
 
+#define HCI_OP_LE_READ_TRANSMIT_POWER	0x204b
+struct hci_rp_le_read_transmit_power {
+	__u8  status;
+	__s8  min_le_tx_power;
+	__s8  max_le_tx_power;
+} __packed;
+
 #define HCI_OP_LE_READ_BUFFER_SIZE_V2	0x2060
 struct hci_rp_le_read_buffer_size_v2 {
 	__u8    status;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 667b9d37099dec..c1f5b5c4109215 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -381,6 +381,8 @@ struct hci_dev {
 	__u16		def_page_timeout;
 	__u16		def_multi_adv_rotation_duration;
 	__u16		def_le_autoconnect_timeout;
+	__s8		min_le_tx_power;
+	__s8		max_le_tx_power;
 
 	__u16		pkt_type;
 	__u16		esco_type;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3a2332f4a9bba2..6bff1c09be3b42 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -741,6 +741,12 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 			hci_req_add(req, HCI_OP_LE_READ_ADV_TX_POWER, 0, NULL);
 		}
 
+		if (hdev->commands[38] & 0x80) {
+			/* Read LE Min/Max Tx Power*/
+			hci_req_add(req, HCI_OP_LE_READ_TRANSMIT_POWER,
+				    0, NULL);
+		}
+
 		if (hdev->commands[26] & 0x40) {
 			/* Read LE White List Size */
 			hci_req_add(req, HCI_OP_LE_READ_WHITE_LIST_SIZE,
@@ -3654,6 +3660,8 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->le_num_of_adv_sets = HCI_MAX_ADV_INSTANCES;
 	hdev->def_multi_adv_rotation_duration = HCI_DEFAULT_ADV_DURATION;
 	hdev->def_le_autoconnect_timeout = HCI_LE_AUTOCONN_TIMEOUT;
+	hdev->min_le_tx_power = HCI_TX_POWER_INVALID;
+	hdev->max_le_tx_power = HCI_TX_POWER_INVALID;
 
 	hdev->rpa_timeout = HCI_DEFAULT_RPA_TIMEOUT;
 	hdev->discov_interleaved_timeout = DISCOV_INTERLEAVED_TIMEOUT;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9a24fd99d9e08e..beb35680f3a83a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1202,6 +1202,20 @@ static void hci_cc_le_set_adv_set_random_addr(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
+static void hci_cc_le_read_transmit_power(struct hci_dev *hdev,
+					  struct sk_buff *skb)
+{
+	struct hci_rp_le_read_transmit_power *rp = (void *)skb->data;
+
+	BT_DBG("%s status 0x%2.2x", hdev->name, rp->status);
+
+	if (rp->status)
+		return;
+
+	hdev->min_le_tx_power = rp->min_le_tx_power;
+	hdev->max_le_tx_power = rp->max_le_tx_power;
+}
+
 static void hci_cc_le_set_adv_enable(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	__u8 *sent, status = *((__u8 *) skb->data);
@@ -3577,6 +3591,10 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		hci_cc_le_set_adv_set_random_addr(hdev, skb);
 		break;
 
+	case HCI_OP_LE_READ_TRANSMIT_POWER:
+		hci_cc_le_read_transmit_power(hdev, skb);
+		break;
+
 	default:
 		BT_DBG("%s opcode 0x%4.4x", hdev->name, *opcode);
 		break;
-- 
2.28.0.681.g6f77f65b4e-goog

