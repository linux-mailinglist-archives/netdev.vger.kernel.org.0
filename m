Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8415A2C2FA7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404262AbgKXSIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404263AbgKXSIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:08:00 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03945C061A4D
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:08:00 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id q6so15964006qvr.21
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 10:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AXAknEpvKBpoA/tQ74hoSelS5rcDfREdSPoIoNUpV40=;
        b=J4etFPaWB9eoRCeR0YqudbKLKE8hDVA1YWUNtPxTsVYHrAjlH9jD64QcT+MnHq10JJ
         PoKYJ0sE8U2mfCE+euxwudoBlPFrnhLMPu9adqFp2GHA82xXpJNQYER0Cycz+xb+PiJb
         AqZMVIZMO5GrGLfjRiFJ4gCRGOcfyWqmGrJ03fTGuctHvO4LaLtUnvNXTu1BcvlyqG2H
         W8DPTko8K1iRwYN2REoxnGrFn8rNSZFEGvGUEnG7S0X1ab2XRUQjBiZXx4kz6UEBxpok
         3oCeLmMSUvFwa3/290pqPNxe4EpDrtc+MYt+Dtec4dhzDRSk1Z6KHUQwH2V7/PvVqWFL
         gyAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AXAknEpvKBpoA/tQ74hoSelS5rcDfREdSPoIoNUpV40=;
        b=UMGZd1zGYL90Q+3IOEGKaOmu+Dd9au/Z/vmgXregME9edYyipN2gz87iLfyrkHfcgF
         T/U8BIC0jORk23PjSPKaRQCkm0EStj1ghhgP/aDBB+Fj8TBkcU/DTGQFvv6hUcn+XDTg
         Qm0QDDOUqfVraStnaYUDIuuhdPk/pDRJ6papxhA4rXHlG1jxgiYH9t4MqCElMnh0gUbm
         CUtRgv8joFoc3iuu+G/U8NKGTpSLAvzF63yJf4pF+cexpaKzdA/sQdcc527xV9Us9KwT
         yvAXZHfqpICGIJsU511Jj/+iSeRa4VG3U+x4wm+pIo9URHxrw/Mz8KimhhCU1vD1vqc6
         /WmQ==
X-Gm-Message-State: AOAM532Mlr5Nae968oJwEdqJNqew+OASLyQiY4TIPXS6lOOW4XdQSc7N
        UcoiDf+pk4xfaf5dB0pWL/64cqWMCnD7BRfEr0Y0
X-Google-Smtp-Source: ABdhPJzY2C7cnSo/pUL52Dj+KZhufo4Rl/uROB4BC81LmSi4u1oxHg0gsitbJRBwUPJhLB//0CsWRjKN8YpvZyU0zKmn
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:51c7:: with SMTP id
 f190mr10223300ybb.299.1606241279107; Tue, 24 Nov 2020 10:07:59 -0800 (PST)
Date:   Tue, 24 Nov 2020 10:07:45 -0800
In-Reply-To: <20201124180746.1773091-1-danielwinkler@google.com>
Message-Id: <20201124100610.v5.4.Ibedcb7af24f1c01a680de4cc8cc5a98951588393@changeid>
Mime-Version: 1.0
References: <20201124180746.1773091-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v5 4/5] Bluetooth: Query LE tx power on startup
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

Changes in v5: None
Changes in v4: None
Changes in v3: None
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
index ab168f46b6d909..9463039f85442c 100644
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
index 3397fc706e87a1..6f7d5ce965d7c8 100644
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
@@ -3656,6 +3662,8 @@ struct hci_dev *hci_alloc_dev(void)
 	hdev->le_num_of_adv_sets = HCI_MAX_ADV_INSTANCES;
 	hdev->def_multi_adv_rotation_duration = HCI_DEFAULT_ADV_DURATION;
 	hdev->def_le_autoconnect_timeout = HCI_LE_AUTOCONN_TIMEOUT;
+	hdev->min_le_tx_power = HCI_TX_POWER_INVALID;
+	hdev->max_le_tx_power = HCI_TX_POWER_INVALID;
 
 	hdev->rpa_timeout = HCI_DEFAULT_RPA_TIMEOUT;
 	hdev->discov_interleaved_timeout = DISCOV_INTERLEAVED_TIMEOUT;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index f193e73ef47c14..67668be3461e93 100644
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
@@ -3582,6 +3596,10 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
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
2.29.2.454.gaff20da3a2-goog

